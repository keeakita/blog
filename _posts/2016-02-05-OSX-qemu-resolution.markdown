---
layout: post
title:  "Changing OS X's resolution in qemu"
date:   2016-02-05 14:24:00
tags:   tech linux osx qemu
categories: tech
---

I'm posting this to my blog because this is information that took me a long time
to find.

If you're using OS X inside Qemu (you can find guides on this online elsewhere),
you may notice that under most setups, resolution is limited to 1024x768. This
is terrible for Xcode development and was a major pain for me. When I searched
for a solution earlier, I only found general information about resolution issues
in Linux or Windows VMs that mentioned either patching Qemu or changing graphics
drivers. Neither of these seemed very relevant, so I gave up for a while.

Turns out this is a setting you can change via OS X, just not through the GUI.
Edit the file `/Extra/org.chameleon.boot.plist`, and either add (or adjust) the
file to contain the following:

    <key>Graphics Mode</key>
    <string>1920x1080x32</string>

This should get things up and running at 1080p. I'm not sure if it's relevant,
but I also have the vmware tools installed and am using `-vga vmware` in my qemu
options.

Fix thanks to Christian Simon in the comment section of [this blog
post](http://blog.ostanin.org/2014/02/11/playing-with-mac-os-x-on-kvm/) (if you
use NoScript or Ghostery you'll need to allow Disqus to run).
