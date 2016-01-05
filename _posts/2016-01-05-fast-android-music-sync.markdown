---
layout: post
title:  "Fast Network Music Sync Using rsync on Android"
date:   2016-01-05 16:45:50
tags:   tech android ssh linux
categories: tech
---

Over the years of owning various Android devices, one thing has regularly been a
pain for me: syncing my music library to my phone. Ever since Android made the
switch from Mass Storage to MTP (Media Transfer Protocol), things have been
really rough. On most of the Linux distros I've used, the support for MTP
devices was pretty bad. To sync, I wrote a rather complicated script to mount
the device using `go-mtpfs`, check that things were sane, then rsync them over.
The results ranged anywhere from slow to buggy to completely unusable. When I
got my shiny OnePlus One in the middle of last year, it got so bad that I was
getting entirely different results using the same software on the same distro
between my desktop and my laptop. I ended up going months with my phone library
out of date.

It was around then I began to consider going over the network, since other than
MTP I really didn't have a good option besides maybe hacking something together
with ADB (ew). Desktop and laptop were syncing fine over [Syncthing][], which is
a really cool project that I recommend you check out. Unfortunately, Syncthing
on Android was also slightly buggy for me, due to some know issues with Android
and having access to file modification times. I was already using rsync before,
and I knew rsync could work over the network. Why not see if I could do that
with Android as the target?

The answer I found was a (free and open source!) app in the Google Play store
called [SSHelper][]. SSHelper runs an SSH server on your device and through that
can do things like transfer files and run rsync. I was amazed when I actually
tried it out: rsync over the network was running *faster* than over USB. A
really cool benefit of doing it this way versus with an MTP FUSE module is that
since rsync is running locally on the phone, it can do things like look at
timestamps or compute checksums on its own, without the file being transfered.
With the USB setup, the file has to be read in order to learn these things,
which brings it over the cable (slowly, in my experience). This is important
since rsync does a lot of checking of what's already present in the target in
order to determine which files to update. This is such a significant speedup for
me that it runs about twice as fast over the network versus USB, even though
intuition would say that a physical connection should be faster.

## TL;DR:
The process is relatively straightforward:

1. Install and run [SSHelper][]. It'll generate SSH keys at first, just let it
   finish. It'll automatically start the SSH server listening on port 2222.
2. **It is highly recommended to change the default password**, since it
   defaults to "admin". This means anyone on your local network can see the
   contents of your phone's storage until you change this. Click the wrench tab
   at the top to adjust the password and other settings. This will also show
   your phone's IP address.
3. Once you've set a new password and know your phone's IP address, the command
   you're probably looking for is:

   `rsync -rdv --delete-after --size-only /home/{you}/Music {phone ip}:SDCard/ -e 'ssh -p 2222'`

   This assumes that your phone's music is stored in `SDCard/Music` and your
   computer has it stored in `/home/your-user/Music`. If you need to change
   these be careful! Rsync is very sensitive about things like trailing slashes.
   If you want to exclude some folders (Like `.stversions`, for Syncthing
   users), you can add `--exclude=.stversions`. Excludes are done relative to
   the source path.
4. When you're done, click the dots in the top right and select 'Stop Server &
   Quit'. No sense running the server and wasting battery or risking having
   someone SSH into your phone when you're out and about.

With this setup the command to sync is simpler than my old hacked together
script, it runs faster, and it avoids buggy MTP implementations.

I tend to be pretty passionate (read: opinionated) about how I organize and
store my music library, so I might write some more posts about it in the future.
I really would like to put my thoughts out there about managing a hybrid
lossy/lossless library.

[Syncthing]: https://syncthing.net/
[SSHelper]:  http://arachnoid.com/android/SSHelper/
