---
title: Hardening Services With Systemd
author: Daniel Moch
copyright: 2018, Daniel Moch
date: 2018-10-05T09:13:03-04:00
categories: [technology]
description: More secure services are an out-of-the-box feature with Systemd
---
Systemd gets a lot of hate. There's a lot of heat and very little
light in those discussions, in my opinion, and I don't expect that
this post will change the mind of anyone who has already decided to
hate Systemd. My goal here is far more modest. I want to share a
feature of the new init system that I find really compelling, and that
I hadn't seen discussed pretty much anywhere: Systemd's native ability
to leverage the Linux kernel's namespacing features to run services in
a sandboxed environment.

[Linux namespaces](https://en.wikipedia.org/wiki/Linux_namespaces) are
the kernel feature that enables partitioning everything from
processes, to the filesystem, to the network stack. A process
operating in one namespace will have a different view of the system's
resources than a process operating in another namespace. Probably the
best known application of Linux namespaces are container platforms
such as [Docker](https://www.docker.com/). While Docker is ostensibly
a devops platform enabling rapid deployment of applications, the
underlying kernel namespace features can be applied to security as
well, allowing processes to be effectively partitioned off from one
another and, to varying degrees, the underlying system. That's what
folks mean when they talk about running a process or service in a
sandboxed environment.

So what if I'm a sysadmin who wants to run a service in a sandbox?
This would traditionally be done by setting up a
[chroot](https://wiki.archlinux.org/index.php/Change_root)
environment. But another option, one that offers a bit more
flexibility, would be to run the service in a mount namespace, and
then reconfigure the existing filesystem within the namespace to apply
least-privilege to data the services needs and hide data the service
doesn't need access to.

With Systemd, you can configure your service according to either of
the above scenarios by simply adding a couple of lines to the service
file. Say I want my service to run within a chroot located at
``/srv/http``. Assuming the chroot is set up appropriately so that the
service has access to all of the data it needs within its folder
hierarchy, then all I need to do is add the line
``RootDirectory=/srv/http`` to the ``[Service]`` section of the
Systemd service file.

The second scenario is a bit more interesting. Say I'm running a web
front-end for my Git service, and that my service needs access to
``/dev/urandom`` ``/tmp`` and read-only access to ``/home/git``.
Systemd offers several options that allow you to do this in a way that
exposes little else to the service. Take the below service file:

	...
	[Service]
	PrivateDevices=yes
	PrivateTmp=yes
	ProtectHome=tmpfs
	BindReadOnlyPaths=/home/git
	...

These options implicitly place the service within a mount namespace,
meaning we set up our file hierarchy however we like. In the above
example, ``PrivateDevices`` creates a private ``/dev`` structure that
only provides access to pseudo-devices like ``random`` ``null``, etc.
Critically, disk devices are not visible to the service when the
``PrivateDevices`` option is used. Likewise, ``PrivateTmp`` creates a
``/tmp`` folder that is empty except for what the service itself
writes. ``ProtectHome`` has a few options, but the ``tmpfs`` option,
according to the documentation, is designed for pairing with the
``BindPaths/BindReadOnlyPaths`` options in order to selectively
provide access to folders within ``/home``. Since all we need there is
read-only access to the ``git`` user, that's exactly what we provide,
nothing more and nothing less.

This is all great, but it admittedly only provides mount namespacing
for the service. This is probably sufficient in most cases, but
Systemd does offer options for network and user namespacing. Readers
looking to utilize those, or looking for a comprehensive description
of the mount namespacing options, are encouraged to read the
[systemd.exec man
page](http://jlk.fjfi.cvut.cz/arch/manpages/man/core/systemd/systemd.exec.5.en).
