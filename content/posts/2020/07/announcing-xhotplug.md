---
title: Announcing Xhotplug
author: Daniel Moch
copyright: 2020, Daniel Moch
date: 2020-07-04T13:54:52-04:00
category: announcements
description: An X11 monitor attach/detach responder
---
I'm pleased to announce the initial, beta release of
[xhotplug](https://dl.danielmoch.com/xhotplug), a small utility for
automatically responding to X11 montor attach/detach events.

I've recently switch to OpenBSD from Linux, and one small annoyance
has been the lack of udev, which I was able to pair with
[autorandr](https://github.com/phillipberndt/autorandr) on my laptop
to automatically reconfigure my X11 screen whenever I attached a new
monitor. I recently came across an IRC comment linking to a
[Gist](https://gist.github.com/mafrasi2/4ee01e0ba4dad20cf7a80ae463f32fca
) that showed the guts of a little C program that did the trick. From
there it was a small effort to wrap that logic in something a bit more
user friendly and capable of being launched from `.xinitrc`. xhotplug
pairs well with autorandr, or you can write your own script to respond
to events.

If you have any feedback, or just find it useful, please reach out
an let me know.

Cheers!
