---
title: 'Systems Programming'
date: 2025-01-13T04:41:53-05:00
categories: [technology]
description: |
    Keeping a kind of systems programming in mind can help leaders
    organize teams and make hiring decisions.
---
I'm not sure what *systems programming* means.
It used to mean something like designing operating systems.
The creators of the Go programming language sought to redefine the
term (although they may not have seen it that way) to mean something
like designing networked systems, and particularly web servers.
This to say, the term's usefulness is debatable.

And yet I find myself attracted to it.
I even like to think of myself as a *systems programmer* of a sort.
I'm not content to simply use the layers of abstraction provided
to me.
I always want to know what's going on above and especially below
the layer I am programming.
Over the course of my career I've had the privilege of working on
everything from device drivers, to power-on self-test (POST), all
the way up the stack to large, web-based systems.

## An Actually-Useful Definition of Systems Programming

I think this approach to programming is about the best definition
of *systems programming* I can come up with.
Systems programmers want all of the layers in their software system
to cooperate.  They don't think abstraction should be used to hide
messes in lower layers.
Those messes should be cleaned up.
The whole system will be better for it.

This all came to mind as I read Fernando Hurtado Cardenas's blog
post "[That's Not an Abstraction, That's Just a Layer of Indirection][na]."
In noticing and commenting on the difference between abstraction
and indirection, Cardenas is behaving like a good systems programmer
(at least by my definition).
They recognize it is the whole system that needs to be optimized
and not just the topmost layer.

[na]: https://fhur.me/posts/2024/thats-not-an-abstraction

With my own experience and Cardenas's post in mind, maybe we can
start to sketch a useful definition of *systems programming* as
applying the same thoughtful approach to the entire stack that one
does to the software they are actually writing[^ha].
This mindset is not a given within the software community, and with
well-designed systems it does not need to be ubiquitous.
But I would argue it does need to be *present* in any large-scale
software team.

[^ha]: It is perhaps useful to identify an opposite of this kind
    of systems programming in certain kinds of hacking.
    Let me say that I have a lot of respect for the hacker ethos
    (or perhaps *mythos*).
    Still, I struggle to see its place in large scale software
    *engineering*, where the technical requirements are always (at
    least implicitly) complemented with non-technical requirements
    around maintainability, technical debt and the like.
    I want to be clear that it would be possible to push this too
    far.
    I genuinely think software engineers stand to learn a lot from
    hackers.
    I just think that software engineering and, more to the point,
    *systems programming* are very different mindsets.

## How Is This Useful Though?

What does this mean for the makeup of software teams, particularly
in large organizations that embrace DevOps, Platform Engineering,
and the like?
I actually think this understanding of *systems programming* fits
quite naturally within these kinds of organizations.
The application developers tasked with writing the value-add business
logic are usefully abstracted away from the system as much as
possible.
The *systems programmers* are the architects, platform engineers,
and DevOps/SRE staff who concern themselves with the rest of the
stack (or, in the case of architects, the *whole* stack).
Indeed, this models comports quite well with the division of labor
advocated by the *[Team Topologies]* crowd.

[Team Topologies]: https://teamtopologies.com

At this point I imagine one might respond to all of this with, "So
what?"
I have basically invented a definition of *systems programming* out
of the blue that just confirms that *Team Topologies* got it right?
Yes. And ...

I think this definition of *systems programming* sheds light on
something I have struggled with.
As someone who *wants* to understand and appreciate the entire
software stack, I am tempted to look down on folks who just want
to write their code and be done with it.
This whole thought experiment has brought to light the fact that
application programmers are necessary too.
Of course they are!
They are the ones writing the value-add business logic that will
make or break the business.
A systems programmer's job is to support an application programmer.
How can that happen if instead we look down our noses at them.
They are our customers!
So elitism within the Platform Engineering community should be
verboten.

This systems/application programmer model might also be a helpful
heuristic for hiring managers.
Ask questions that tease out whether a candidate wants to understand
the entire software stack, or if they would rather focus on writing
their business logic.
Doing so will give you an idea of where they will fit more naturally.
