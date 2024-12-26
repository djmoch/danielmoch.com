---
title: Complexity Is Leaky, or, Roger Peppé Gets It
author: Daniel Moch
copyright: 2024, Daniel Moch
date: 2024-07-27T08:19:00-04:00
lastmod: 2024-12-26T11:43:00-05:00
categories: [technology]
description: Hyper-configurable tools are a source of cognitive burden
params:
  social:
    bluesky: https://bsky.app/profile/danielmoch.com/post/3kybbd3sqi723
    mastodon: https://discuss.systems/@djmoch/112858457561155145
    linkedin: https://www.linkedin.com/posts/djmoch_complexity-is-leaky-or-roger-pepp%C3%A9-gets-activity-7222942429979549696-O-v-
---
Over the past year or so I've been collecting quotes about simplicity.
Here is a short collection of my favorites:

- Einstein: "Everything should be as simple as possible, but no
  simpler."

- "Even the simplest solution is bound to have something wrong with
  it."

- Grady Booch:, "The function of good software is to make the complex
  appear to be simple."

- C.A.R. Hoare: "There are two ways of constructing a software
  design: One way is to make it so simple that there are obviously
  no deficiencies and the other way is to make it so complicated
  that there are no obvious deficiencies."

The pretty clear impression anyone would get from listening to
[Roger Peppé discuss his work environment][rp] is that he values
simplicity.
If you think I'm overstating things, consider the title the folks
at Sourcegraph opted to give their conversation with him.
The video is worth viewing.
I'll use the rest of this post to talk about what benefit I've
personally seen since deciding to pay the cost of simplicity for
myself.

[rp]: https://about.sourcegraph.com/blog/dev-tool-time-roger-peppe/

To begin with, my approach to simplicity is not too different from
Peppé's.
I have plan9port installed on my laptop.
I pretty much live in Acme, having embraced its pared back approach
to editing for a little more than two years now.
Before that I was an avid Vim user.

The thing about Vim is that it's complicated, and that complexity
has a cost.
Most of the cost is maintenance.
Vim has support for syntax highlighting, so that needs to be updated
every time a new language comes out or an old one gets updated.
The same goes for the compiler plugins, each of which needs to
understand how to parse output from its compiler into Vim's Quickfix
window.
I'm not saying these are hard things to do given some background
knowledge.
But they need to be done.
And I haven't even mentioned all of the code in Vim to deal with
different types of terminals and terminal emulators[^te].

Vim has a lot of maintainers, so if you use it, you'll probably
never see any of that complexity.
It's the maintainers who do.
And they're working for free, because they presumably love Vim.
So it's a win-win, right?
You get the joy of using Vim, and the maintainers get the joy of
maintaining it.

Except it's not really true that you'll never see that complexity.
You almost definitely will.
You'll realize Vim has a plugin system, and so you'll want to learn
how to leverage that to make the experience a little better.
You'll learn that there are a lot of third-party color themes out
there, so you'll put time into finding just the right one.
You'll join the ranks of folks online who compete to have the longest
`.vimrc` file.
Or maybe you'll join the group that rolls their eyes at those people
and competes for the shortest.

I can say this with some confidence, because this was me.
And Vim
is just one example.
I've used [plenty] [of] [tools] that boast being hyper-configurable.
My experience has been that that very configurability is a source
of cognitive burden.

[plenty]: https://awesomewm.org/
[of]: https://irssi.org/
[tools]: https://www.ocf.berkeley.edu/~ckuehl/tmux/

[Yak shaving] has a hallowed tradition in computer programming, but
it seems to have expanded to encompass tasks that bear no obvious
relationship to the task at hand _and add no value to it_.
Looking back, I can see that having endlessly configurable tools
gave me endless opportunity to fiddle with them.
And this felt important!
Maybe I'm more prone to distraction than most, but I got to a point
where I couldn't really handle language keywords being displayed
to me in the wrong shade of blue.
If I know I can change the color, then why not change it?

[Yak shaving]: https://www.techopedia.com/definition/15511/yak-shaving

Fast-forward to today: I use a text editor with no syntax highlighting,
and doesn't even have a config file.
Meanwhile, professionally I've had probably the most productive
years of my life.
Simplicity has a cost, but I've found it to be much less than the
cost of complexity.

[^te]: I could talk more about developers romanticizing doing
    everything possible in a terminal window, but that's a post
    for another time.
