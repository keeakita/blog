---
layout: post
title:  "Urxvt and Terminfo: 'unknown terminal type rxvt-unicode-256color'"
date:   2016-08-28 16:05:00
tags:   tech linux
categories: tech
---

Keeping in the spirit of reproducing hard-to-find information on my blog, here's
something I recently discovered when trying to get my terminal working properly
with a Linux server at school.

I use [rxvt-unicode]() as my terminal emulator on Linux for its light weight
nature and text based configuration. Unfortunately, sometimes when I SSH into
some machines (like the OSU CSE department's `stdlinux`), I get a message like
this:

```
tput: unknown terminal "rxvt-unicode-256color"
tcsh: No entry for terminal type "rxvt-unicode-256color"
tcsh: using dumb terminal settings
```

What's happening is that a lot of machines don't understand how to properly
interact with my terminal emulator. Different terminals have different support
for certain features, and they way that they communicate this is by setting the
environment variable `$TERM`. The system then has definitions for various
`$TERM` values about what features are supported, and shells and other programs
can use this information to help their output appear correct. These mapping
files, called `terminfo` files, are missing for rxvt-unicode on many systems.

Luckily, `terminfo` files can be stored in your home directory in `~/.terminfo`,
so all you should have to do is copy the file from the computer you installed
rxvt-unicode on to the machine that's complaining.

```bash
ssh stdlinux mkdir -p ~/.terminfo/r
scp /usr/share/terminfo/r/rxvt-unicode-256color stdlinux:.terminfo/r/
```

Thanks to [Tom Ryder's original
post](https://sanctum.geek.nz/arabesque/term-strings/), which lead me to this
solution and goes into a lot more detail about terminal strings, for the
curious.

