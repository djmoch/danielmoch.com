title: Developing Go Modules In Private
author: Daniel Moch
copyright: 2021, Daniel Moch
date: 2021-12-31 13:30:00 UTC-05:00
category: technology
description: Using Private Modules In Your Projects

Today brings us another reminder to read the reference materials,
which will be your best source of information for any well-documented
project.
I'm primarily putting this out there as a reminder of that advice,
and to point folks to the appropriate reference in this specific
case.

I like that Go's module system is an integrated part of the toolchain,
and that for the most part it does The Right Thing.
Until recently I thought that private modules were an exception to
this.
It turns out I was mercifully wrong.

Here's the problem: I'm developing a small, personal project, and
I want to break out a small subset of capability into a separate,
library module.
How do I import the new library from my larger project without
making it public?

I was aware of [private proxies], but that's an entire server
infrastructure that needs to be stood up, and this is a personal
project.
I didn't want to take that on, but since that was *a* solution, I
had assumed it was *the* solution.
So my choice was between making  the module public so I could import
it via the standard channels, or standing up this server infrastructure.

[private proxies]: https://go.dev/ref/mod#module-proxy

That choice turned out to be a false one, because there's a third,
configuration-based option.
And while I pride myself on preferring primary sources in software
development (think API docs versus StackOverflow), I'll admit I
missed this option despite it being pretty clearly documented in
the [Go Modules Reference].

[Go Modules Reference]: https://go.dev/ref/mod

Okay, so here's how to configure Go to grab private modules from a
private repo.
First, skip trying to download any module I've created via a proxy
server by setting the `GOPRIVATE` environment variable to match my
module prefix.
Second, configure Git to re-write the URL Go would otherwise use
to fetch my code by adding the following to my .gitconfig:

```
`[url "git@git.danielmoch.com:"]
    insteadOf = git://git.danielmoch.com/
```

If you've visited the Modules Reference already, but aren't finding
the relevant section, that's because this whole solution is spread
out over two sections.
`GOPRIVATE` is discussed in [Direct access to private modules],
while the Git configuration was suggested in [Passing credentials
to private repositories].

[Direct access to private modules]: https://go.dev/ref/mod#private-module-proxy-direct
[Passing credentials to private repositories]: https://go.dev/ref/mod#private-module-repo-auth

So there you go.
I hope you found this helpful, but more importantly I hope you've
rediscovered the importance of reading the documentation.
