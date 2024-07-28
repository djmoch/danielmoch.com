---
title: Regarding Semantic Versioning
author: Daniel Moch
copyright: 2020, Daniel Moch
date: 2020-09-11T08:51:18-04:00
categories: [technology]
description: Semantic Versioning is a meta-API
---
So as not to bury the lede, I'll get to my point: [Semantic
Versioning](https://semver.org/) is a meta-API, and maintainers who
are cavalier about violating it can't be trusted to created stable
contracts. I've lost patience for breaking changes making their way
to my code bases without the maintainers incrementing the major
version of their projects, especially in language ecosystems where
Semantic Versioning is expected, and in such cases I'm going to
begin exploring alternative options so I can ban such libraries
from my projects---personal and professional---altogether.

What Even Is Semantic Versioning?
---------------------------------

When developers adopt an external library into their code bases, they
do so knowing they will be bound in their use of the library by the
application programming interface (API). In this sense, an API can be
seen as a kind of contract between a library's maintainer and its
consumers. If a maintainer makes frequent changes to a library's API,
then that API is considered unstable. In that situation, consumers
either use the library anyway, accepting the risk that things will
break as a result of a change in the library, or they avoid it.

Semantic Versioning seeks to ease this picture by embedding notions of
backward- and forward- compatibility into software version numbers. If
a library maintainer adheres to it, then consumers are able to upgrade
to newer versions of the library (say, to pick up bug fixes) without
fear of breaking changes, provided they aren't moving to a new, major
version. In terms of backward- and forward-compatibility, Semantic
Versioning creates an expectation that a given version of a library is
forward-compatible with any future version up to the next, major
release. A library is also backward-compatible down to the most
recent, minor release (beyond which point consumers' code _might_
break if they are using newer library features).

There are several benefits to using Semantic Versioning. One benefit
is that it becomes easy to codify dependency requirements into
automated dependency tools. By _assuming_ Semantic Versioning, users
of tools like NodeJS's `npm` and Rust's `cargo` are able to
specify dependency _ranges_ rather than hard-coded versions. So if a
new release of a library comes out, these tools are able to decide
automatically whether or not they can be used in a given project. In
other words, Semantic Versioning creates an opportunity for downstream
developers to easily decide whether or not to upgrade to a new version
of a library, potentially picking up important bug fixes in the
process.

Semantic Versioning As A Meta-API
---------------------------------

Let me go back and unpack what I mean by calling Semantic Versioning a
meta-API. As I said above, API's represent a sort of contract between
library maintainers and downstream consumers. Semantic Versioning then
represents a sort of contract-about-the-contract. It's an agreement
regarding when and how the API will change. In a situation where
Semantic Versioning is the _de facto_ norm, as it is in the language
ecosystems mentioned above, a maintainer who chooses not to follow it
is breaking this contract, creating the risk of needless downstream
breakage.

Because Semantic Versioning requires more contextual knowledge than
any compiler or tool chain can boast, the process is largely manual.
This means mistakes happen, and breaking changes are introduced
without rolling the major version number. Responsible maintainers will
own such mistakes and issue bug fixes to correct them, implicitly
acknowledging that the meta-API is as important as the API itself.

Other maintainers aren't as interested as Semantic Versioning, and
seem to view it as a sort of straight jacket they would rather break
free of than a tool to promote software stability. These folks fight
against their tool chains, and indeed their entire language ecosystems,
arguing that Semantic Versioning doesn't work for them and they should
be free to work however they want. Some of their arguments are likely
stronger than others, but none of them will be ultimately compelling.

Conclusion
----------

If you work in a language ecosystem where Semantic Versioning is the
_de facto_ norm, where violating it can wreak havoc downstream, then
please play nice and follow its dictates. Instead of viewing it as a
straight jacket, try to see it as an algorithm to determine what your
next release number should be. We should all like algorithms!

If you refuse to be persuaded, then understand I will will not work
downstream from you [^dn]. I'll find a different upstream to work with
because I cannot trust you to create a stable contract. Your
willingness to conform to the meta-API is something I will take into
consideration in the future before adopting a library into any project
that I work on. I wish you well; I hope you have fun; I'll be sure to
give you a wide berth.

[^dn]: I'll note here that I'm more forgiving in environments where Semantic Versioning is not a _de facto_ norm.
