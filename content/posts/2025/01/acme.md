---
title: 'Acme: The Un-Terminal'
date: 2025-01-20T04:05:43-05:00
categories: [technology]
description: Reasons to prefer an integrating development environment
params:
  social:
    bluesky: https://bsky.app/profile/danielmoch.com/post/3lg6jmnp3as2q
    mastodon: https://discuss.systems/@djmoch/113861103836380487
    linkedin: https://www.linkedin.com/posts/djmoch_plan9-acme-softwaredevelopment-activity-7287110904523943938-HhZa
---
If you are not a software developer, you might be surprised to learn
that a large subset of that community loves terminal-based user
interfaces (TUIs).
These are applications that run, for instance, in Terminal.app on
MacOS or Windows PowerShell[^cp].
Developers who prefer TUIs will usually insist on using Emacs
or Vim to write their code.
They might also try to find TUIs to do *everything* in the terminal:
[Mutt] for email, the [Vifm] file manger.

[Mutt]: http://www.mutt.org
[Vifm]: https://vifm.info
[^cp]: Windows also has an antediluvian terminal called Command Prompt
    if that's more your speed.

I was one of those folks for a time.
Then I realized the magic wasn't the terminal *per se*, but rather
what is best described as a highly-regular, text-based user interface
with a clear interface to other utilities.
Modern GUIs tend to each be created from scratch and are designed
to operate hermetically.
But treating every application like its own blank slate and creating
every user interaction from scratch has the effect, in aggregate,
of making modern computers overwhelming to use.
The heavy use of iconography makes the uphill climb all that much
steeper.

Terminal-based programs don't suffer from this.
Their inability to display arbitrary bitmaps (pictures) essentially
narrows their bandwidth.
With text as the dominant mode of communication, behavioral patterns
have emerged across programs, making the second terminal program
easier to learn that the first and scaling from there.

## Text-Based GUIs?

So can we create GUI-based applications that rely only (or
significantly) on text and provide a standardized mode of interaction?
We can, and, in fact, it has already been done in the area of text
editors.
The editor I have in mind is Acme[^vc], originally released in the 1990's
as part of the Plan 9 operating system and brought to other Unix-like
systems by Russ Cox's [plan9port] project.

[plan9port]: https://9fans.github.io/plan9port/
[^vc]: Visual Studio code might come close to achieving this ideal
    as well.
    If it succeeds, I think it is mainly because it integrates a
    text-based terminal into a text-heavy GUI environment, something
    Acme does by a different method.
    As we shall see shortly, whereas VS Code allows you to open a
    terminal window within the editor, Acme's integration goes
    deeper, allowing the use of standard CLI-style commands in *any*
    window.

The power of the Acme editor is twofold.
First is its seamless way of integrating the command-line tools
programmers are already familiar with into its environment.
Users can select any text and pipe[^pi] it a command.
The output of that command can in turn either populate a new window
within Acme, or it can replace the original, selected text.
Second is Acme's use of the [9P protocol] under the hood.
Without diving into the details of the protocol, this allows for a
variety of interactions, including the use of what would in other
programming environments be called plugins[^hp].
What makes these so powerful is the free-form nature of the
interaction model.
The 9P communication is exposed on POSIX systems via [Unix domain
sockets], but the protocol's semantics are simple enough that
plan9port includes a general-purpose client, allowing for helper
programs to theoretically be written even as shell scripts.

[^pi]: The word "pipe" here should be understood in the standard,
    Unix sense.
[^hp]: Cox calls these "helper programs" in the video linked below.

[9P protocol]: https://en.wikipedia.org/wiki/9P_(protocol)
[Unix domain sockets]: https://en.wikipedia.org/wiki/Unix_domain_socket

This is all a bit unusual and hard to imagine, so I recommend viewing
this [brief(-ish) tour of Acme] by Russ Cox.

[brief(-ish) tour of Acme]: https://www.youtube.com/watch?v=dP1xVpMPn8M

## Acme's Un-Strengths

While I was taken with all of this when I first became acquainted
with it, there are a couple things to say about what Acme does *not*
do that have also contributed to its staying power for me.
To summarize, there is no configuration to speak of: no color themes,
no syntax highlighting, no attempt (save for an optional, primitive
auto-indent) to automatically format code[^cf].
Prior to Acme, I had spent far too much time concerned with how my
Vim setup *looked*, e.g. the color scheme.
Configuration files running into the hundreds of lines do not and
cannot exist in Acme.
Not everyone will want such a thing[^sh], but I cannot emphasize
enough what a breath of fresh air it was for me to enter an environment
with no knobs to tweak.

[^cf]: There are examples of plugins that will format code on save,
    similar to VS Code, and even a full-blown [Language Server
    Protocol] client in [acme-lsp].

[Language Server Protocol]: https://en.wikipedia.org/wiki/Language_Server_Protocol
[acme-lsp]: https://github.com/9fans/acme-lsp

[^sh]: The lack of syntax highlighting in particular is likely to
    draw ire.
    This is not something I wish to advocate for or against, so I
    will limit myself to saying that, if you are like me, you will
    not miss it once it is gone.
    Instead, you will find that you have discarded a whole panel
    of "knobs" with which you no longer need to concern yourself.
    While I found there was almost no cost to giving up syntax
    highlighting, the alternative—endlessly tweaking syntax
    highlighting themes—was, for me, an extraordinary waste of time.

## An Integrating Development Environment

Acme is remarkable for what it represents: a class of application
that leverages a simple, text-based GUI to create a compelling model
of interacting with all of the tools available in the Unix (or Plan
9) environment.
Cox calls it an "integrating development environment," distinguishing
it from the more hermetic "integrated development environment"
developers will be familiar with.
The simplicity of its interface is important.
It is what has allowed Acme to age gracefully over the past 30 or
so years, without the constant churn of adding support for new
languages, compilers, terminals, or color schemes.
