title: Using QEMU Without Pulling Your Hair Out
author: Daniel Moch
copyright: 2018, Daniel Moch
date: 2019-07-15 21:25:02 UTC-04:00
category: technology
description: Tips for keeping your sanity with a very powerful tool

I make it a rule to choose my tools carefully and to invest the time
to learn them deeply. QEMU has been one of those tools that I've
wanted to learn how to use for a long time, but was always a bit
intimidated. I actually had been able to use it indirectly via
libvirt, but it felt like I was cheating my rule by using one tool to
manage another. Despite my vague sense of guilt, things continued this
way until I read a recent(ish) [introductory post on
QEMU](https://drewdevault.com/2018/09/10/Getting-started-with-qemu.html)
by Drew DeVault. The article is well written (as per usual for
DeVault), and you'd do well to read it before continuing here. The
point is that it was the kick in the pants I needed to finally roll up
my sleeves and learn some QEMU.

The process of gaining some level of mastery over QEMU ended up being
a fair bit more painful than I had anticipated, and so I wanted to
capture some of my lessons learned over and above the
introductory-level topics. The hard lessons were, by and large, not
related directly to QEMU per-se, but more how to manage QEMU VM's. I
use my virtual machines to isolate environments for various reasons,
and so I need ways to automate their management. In particular, I had
two needs that took some time to work out satisfactorily.

1. Starting VM's automatically on system startup (and cleanly shutting
them down
   with the host system).

2. Securely and remotely accessing VM consoles.

Let's take each of those two issues in turn.

Automatic VM Management
-----------------------

For our purposes, what I mean by automatic management of VM's is just
what I said above. If I need to restart the host server, I want the
VM's to cleanly shut down with the host system, and come back up
automatically after the host restarts. Since this is the kind of thing
init systems are designed to do, it's only natural that we start there
as a place to design our VM management infrastructure.

So we just tell our init system to signal QEMU to shut down any
running VM's and we're good right? In theory yes, but in reality
QEMU's management interface is a bit tricky to script interactions
with. There is a `-monitor` switch that allows you to configure a
very powerful management interface, and you'll need to use that
because the default is to attach that interface to a virtual console
in the VM itself (or stdio, if you're not running a graphical
interface locally). There are several options for configuring the
monitor and the device it's connected to, but the best compromise I
found between convenience and security was to make it available via a
UNIX socket.

If you've read DeVault's entry already, then you know that QEMU allows
you to configure anything you could want via the command line. After
deciding how to expose the monitor to the init system (systemd in my
case), the rest came together pretty quickly. Here's what my service
file looks like:

		[Unit]
		Description=QEMU virtual machine
		Wants=network-online.target
		After=network-online.target

		[Service]
		User=qemu
		Group=qemu
		UMask=0007
		Environment=SMP=1
		EnvironmentFile=/etc/conf.d/qemu.d/%I
		ExecStart=/bin/sh -c "/usr/bin/qemu-${TYPE} -enable-kvm -smp ${SMP} -spice unix,disable-ticketing,addr=/run/qemu/%I.sock -m ${MEMORY} -nic bridge,br=${BRIDGE},mac=${MAC_ADDR},model=virtio -kernel /var/lib/qemu/%I/vmlinuz-linux -initrd /var/lib/qemu/%I/initramfs-linux-fallback.img -drive file=/var/lib/qemu/%I/%I.qcow2,media=disk,if=virtio -append 'root=/dev/vda rw' -monitor unix:/run/qemu/%I-mon.sock,server,nowait -name %I"
		ExecStop=/bin/sh -c "echo system_powerdown | nc -U /run/qemu/%I-mon.sock"

		[Install]
		WantedBy=multi-user.target

The `%I` should clue you in that this is a [service
template](https://www.freedesktop.org/software/systemd/man/systemd.service.html#Service%20Templates),
which is a nice convenience if you plan to run more than one VM as a
service. This allows multiple VM's to use the same service file via a
symlink. For example, a symlink from qemu@webhost.service to
qemu@.service would cause systemd to replace `%I` with `webhost`.
In-depth description of service templates is beyond the scope of this
post, but the link above should be sufficient to answer additional
questions. The last point I'll make here is that the netcat (nc)
implementation used in `ExecStop` must be OpenBSD netcat, otherwise
the service will not shut down cleanly. Other implementations will
disconnect immediately after sending the `system_powerdown` message,
while OpenBSD netcat waits for the socket to close.

It's also worth taking a moment to stress how important the `UMask`
directive in the above service template is. QEMU uses this to set
permissions for the files it creates (including sockets), so we use
this to secure our monitor and console sockets. A umask of 0007
directs QEMU to create any files with full permissions for the qemu
user and group, while giving no global permissions.

All that's missing then is the environment file, and that looks like
the following:

		TYPE=system-x86_64
		SMP=cores=1,threads=2
		MEMORY=4G
		MAC_ADDR=52:54:BE:EF:00:01
		BRIDGE=br0

The point of the environment file is to be tailored to your needs, so
don't just blindly copy this. In particular, the `BRIDGE` device
will need to exist, otherwise the service will fail. It bears
mentioning that we use a bridge device so that the VM can appear like
it's own machine to the outside world (and thus we can route traffic
to it).

So much for automating VM startup/shutdown, let's talk about how to
access the console.

Accessing Your VM Console
-------------------------

Again, QEMU has a plethora of options for accessing the VM console,
both local and remote. Since I run my VM's on a server, I wanted
something that would allow remote access, but I also wanted something
reasonably secure. UNIX sockets end up being a good,
middle-of-the-road solution again. They're treated like files, with
all of the standard UNIX permissions, but it's also easy to route
traffic from a remove machine to a UNIX socket via SSH.

The applicable switch to achieve this configuration is `-spice`. In
the above service template, you see the full switch reads::

		-spice unix,disable-ticketing,addr=/run/qemu/%I.sock

`unix` configures QEMU to use a UNIX socket (as opposed to, say, a
TCP port), `disable-ticketing` configures the console without an
additional password (this is okay since we're relying on UNIX file
permissions), and `addr` gives the socket path.

Now if you want to access the console remotely, it's as simple as
setting up a forwarding socket via SSH and connecting your local SPICE
client to it. Here's a shell script I whipped up to wrap that
behavior:

		#!/bin/sh
		uid=`id -u`
		path=/run/user/$uid/qemu

		if [ ! -d $path ]
		then
		        mkdir -p $path
		        chmod 700 $path
		fi

		ssh -NL $path/$1.sock:/run/qemu/$1.sock urbock.djmoch.org &
		pid=$!

		while [ ! -S $path/$1.sock ]
		do
		        sleep 1
		done

		spicy --uri="spice+unix://$path/$1.sock"
		kill $!
		rm $path/$1.sock

And that's how I learned to use QEMU without pulling my hair out. It's
a great tool, and I'm glad I took the time to learn how to use it. I
suggest you do the same!
