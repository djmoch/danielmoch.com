title: Zsh Compinit ... RTFM
author: Daniel Moch
copyright: 2018, Daniel Moch
date: 2018-11-09 06:04:08 UTC-05:00
category: technology
description: Slow start times in Zsh are probably a sign of poor configuration

This week I dealt with a problem that had been bugging me. I noticed
that the time a took to start a new [Zsh](https://www.zsh.org)
terminal session went from essentially instant to around 4
seconds[^it]. I take some pride in running a lightweight system, so
the thought of having to wait a few seconds for my terminal emulator
to display a prompt feels like a personal affront. My system wasn't
just behaving badly, it was challenging me by way of insult.

Accepting the challenge laid before me, I took to `my favorite search
engine`_ to see what tools were available to help me understand what
was suddenly performing so poorly. Oh, okay. [This
post](https://xebia.com/blog/profiling-zsh-shell-scripts/) says that
Zsh includes a script profiler. All I need to do is turn it on in my
``.zshrc`` file, like so:

		zmodload zsh/zprof

Maybe this challenge won't be so challenging after all. So I restart my
shell and run the ``zprof`` command, and I see this::

		num  calls                time                       self            name
		-----------------------------------------------------------------------------------
		 1)    1         203.91   203.91   45.30%    203.91   203.91   45.30%  compdump
		 2)  744         109.84     0.15   24.40%    109.84     0.15   24.40%  compdef
		 3)    1         448.41   448.41   99.62%    108.01   108.01   24.00%  compinit
		 4)    2          26.75    13.38    5.94%     26.75    13.38    5.94%  compaudit
		 5)    1           1.37     1.37    0.30%      1.37     1.37    0.30%  colors
		 6)    2           0.12     0.06    0.03%      0.12     0.06    0.03%  set_title
		 7)    1           0.15     0.15    0.03%      0.08     0.08    0.02%  preexec
		 8)    1           0.07     0.07    0.02%      0.03     0.03    0.01%  precmd

Okay, so initializing the completion system (i.e., all of the items with
names beginning with "comp") is taking a combined 99.64% of the startup
time. No need to do any fancy pareto analysis here. Something is getting
borked initializing Zsh's much-vaunted completion system.

So I [DuckDuckWent](https://duckduckgo.com)[^jk] and found some
results that purported to fix the issue, except that they really only
half fixed it for me (literally cutting my start time in half ... an
improvement for sure, but not good enough). All of the advice[^ad]
seemed to point in the same direction, which was basically:

		autoload -Uz compinit
		if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
		  compinit
		else
		  compinit -C
		fi

The effect of which is to only check ``.zcompdump`` when it's more than
24 hours old, and otherwise to simply initialize the completion system
without referring to it. But wait, why should this be necessary? The
whole point of ``.zcompdump`` is to speed up compinit. If ignoring it
becomes the fix for slow compinit, then why should I ever use it?

So I read the effing manual, and indeed my instincts were correct. To
quote:

> To speed up the running of compinit, it can be made to produce a
> dumped configuration that will be read in on future invocations. ...
> The dumped file is .zcompdump ...

But why is it not working the way the manual describes? And why do so
many other people seem to see similar behavior to me? Let's read a
little further.

> If the number of completion files changes, compinit will recognise
> this and produce a new dump file.

Aha! So by implication one needs to be careful how they go about
initializing the completion system. If you do something stupid like,
say, eval a completion script (effectively initializing the completion
system) before you update your ``fpath``[^fp]_ and otherwise run
``compinit``, then the number of completion files Zsh sees will differ
by one between when you eval the completion script and when you later
call ``compinit``, meaning you'll fully run ``compdump`` every time you
source your ``.zshrc`` ... twice.

Once I understood this, the fix was obvious. Take the completion script
I was manually eval-ing, turn it into a function script, and add it to
my ``fpath`` before running ``compinit`` so it gets picked up with the
rest of the completion system initialization. Now the ``.zcompdump``
isn't updated every time a spawn a new shell, and the initialization
time dropped down to 60-90 ms for an improvement of over 90% in the
worst case.

Sidebar: Oh My Zsh
------------------

[Oh My Zsh](https://ohmyz.sh/) seems by all accounts to be a very
popular framework for managing your Zsh configuration, but while I
don't personally use it, my impression is that it gives you enough
rope to hang yourself with in this respect. I could see how it would
be easy were I to source a bunch of third-party helper scripts in my
``.zshrc`` that were written by a half-dozen different people for the
completion system initialization to end up in a similar state. Just
something to keep in mind if the themes, plugins, and other candy
offered by Oh My Zsh is too much for you to pass up.

[^it]: Later measurement indicated the actual time was 1.0-1.5s, but
either way it felt like forever.

[^jk]: https://octodon.social/@jordyd/100189663891719203

[^ad]: Probably the best written example I found was at
https://carlosbecker.com/posts/speeding-up-zsh/, from which I pulled
the above quote.

[^fp]: ``fpath`` is the Zsh function path, which is similar to your
system path, but for sourcing function scripts rather than executables
