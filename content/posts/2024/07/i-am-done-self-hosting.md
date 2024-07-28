---
title: I Am Done With Self-Hosting
author: Daniel Moch
copyright: 2024, Daniel Moch
date: 2024-07-04T14:43:00-04:00
categories: [personal]
description: Changes on the home front
---
This is a personal post on why, after almost ten years, I am no
longer self-hosting my blog, mail and other servers.

First, a clarification: up until now a lot of my data has been
hosted on various virtual private server (VPS) providers.
This may walk up to the line between proper self-hosting and ...
something else.
Still, I continue to call what I was doing self-hosting, not least
because data I felt needed to stay private remained on servers
physically under my control.
I also think it qualifies because I was still fully responsible for
OS-level maintenance of my VPS.

Pedantry aside, that maintenance was a primary driver for moving
to a different hosting model.
I have spent long enough maintaining Linux and OpenBSD servers that
the excitement has long since worn off, and so giving time to it
on weekends and holidays became untenable in the face of other
options.
There are services run by companies I trust that will host my email
and most other data I might care to access remotely.
They will even apply end-to-end encryption to the majority of that
data.
This is far from a zero trust arrangement, I admit.
Still, the companies I have migrated to have cleared a threshold
that I am comfortable with for the data they are hosting.

Plus, these companies have better availability guarantees than I
could ever hope to achieve on my own.
For example, my VPS was configured to forward incoming mail through
a Wireguard VPN into a mail server hosted at my home.
But as a result, if the power went out at my house, email service
would go down.
This was fine most of the time, but when I was on vacation the issue
could persist until I got home to reboot the necessary hardware.
Spending my vacation anxious about my servers came to seem like a
ridiculous trade in exchange for more control over my data.

Probably the biggest surprise was that providers often have free
tiers that are sufficient for my needs, meaning I'm actually paying
less in hosting fees than I was before.
I stand to make back even more if I sell hardware I'm not using at
the moment (although I'm pretty good at coming up with new uses).

But mostly I'm glad to get the time back.
I'll use it to spend more time with my family, or maybe write more.
At the very least I'll be more present on vacation.
