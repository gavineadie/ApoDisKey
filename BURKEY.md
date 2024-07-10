#  Ronald Burkey <info@sandroid.org>

### Date: Wed, 10 Jul 2024 03:58:22 -0400

Sir .. A short introduction, and some recent work/play related to virtualagc

I’ve followed manned (and other) spaceflight since I was a teenager [listening
to Mercury, Gemini, Apollo on Voice of America shortwave radio in Scotland];
I’ve been a software engineer of some sort (microcomputers to mainframes) all my
career, most of that working for the University of Michigan after emigrating to
the US in 1979. I retired fifteen years ago and proved to myself I could shake
off the remnants of a latterly mostly managerial role and resurrect my technical
skills by writing and selling an iPhone app for predicting ISS passes. Now
entering my fourth quarter century, I still have the bug!

I’ve fired up Virtual AGC several times over the years — I’m seriously impressed
at the work you and others have put into that project. Recently, as in last
week, I wanted to learn more about Apple’s new interface building software,
SwiftUI, and built, in appearance only, a DSKY application. My platforms of
choice are Apple’s, so it runs on Macs and iPads. I was aiming for as accurate
an appearance as possible and stopped when the trade-off between time spent
versus pixel verisimilitude reached a limit — the result:

![](https://ramsaycons.com/pix/macOS-DSKY-UL094A.png =800x)

The background (outline, screw heads, etc) is a downloaded image, and the fonts
are someone else’s excellent work; the rest I painted (buttons, status lights
and the display). The resulting program is actually quite simple, 90% of the
work was learning the framework, but I’m pleased with the resulting appearance.
___

“So?”, I thought to myself, “What next?”

As it stands, the app is just a pretty face, so I considered adding some
function behind this facade — perhaps pressing the keys could change the display
in some trivial manner. But the best way to bring it to life would be to hook up
yaAGC so I started reading and poking around ..

The Mac build of virtualagc has fallen a little behind the current state of the
art. My efforts to build the whole Virtual AGC for today’s macOS was a struggle.
You mention the env python issue, which was easy enough to get past, but I hit
trouble related to wx (maybe partly 32-bit versus 64-bit, partly wx advancing to
v3.2, and, certainly, partly my ignorance .. frankly, I didn’t dig deep — the wx
trouble was all in yaDSKY which I didn’t need anyway).

I noted your preference for simple build tools, make specifically, but, since my
immediate interest was in yaAGC, and I would want interactive debugging, I
created an Xcode project to build just that — easy enough. 

___

This is already a much longer email than I intended and, if you’ve reached this
far, I appreciate it. My immediate, tentative interest is in hooking yaAGC to my
DSKY — you’ve provided excellent detail regarding the i/o needed and ‘all’ I
need to do is implement that on my side. I’m not asking for any help.

I’m writing this note assuming the above is worth your knowing and, if so, I’ll
report on progress. Also, if this takes me into adjusting the build process for
current Apple arm64 platforms, I’ll share that for the community. With thanks
for your inspiring work and best wishes .. Gavin

Gavin Eadie<br/>Ann Arbor, MI


### Date: Wed, 10 Jul 2024 05:42:09 -0500

Sweet, Gavin!  (I do notice that the lettering is chopped off at the tops of
buttons like VERB, NOUN, KEY REL, etc., which I can sympathize with, since it
has happened to me, and is still happening today!)
___

Yes, the portability difficulties are all concentrated in components that have
user interfaces, since when I started creating those items 20 years ago, there
were few choices for making truly cross-platform GUI programs.  Apple,
unfortunately, doesn't help the situtation too much, since it actively tries to
force developers onto their platform, extracting money at every turn.  I've had
two Macs in that 20-year period, both purchased solely to make sure I could get
Virtual AGC running on them.  I had no other uses for these machines.  In both
instances, Apple eventually stopped supporting those computers with Mac OS
updates, but even before that it had become impossible to update Xcode.  If
Apple just allowed Mac OS to be run in a virtual machine, I could still be
happily updating Virtual AGC for the Mac; indeed, I am able to keep Windows
running in just that manner.  But Apple, no!  For me personally, that's the nail
in the coffin.  And as for the App Store, $100/year to distribute free software?
Whether Mac OS or iOS, I'm not going to keep paying Apple money for the
privilege of developing free software for them.

But I digress!  I'm certainly happy to have (and post) any up-to-date info on
Mac support, as long as it's not me having to collect that info.

In more "modern" times, the Python language has come a long way, and I've
learned (and forgotten) a lot about building peripheral components like the DSKY
using Python.  If I were to start over again today, that's how all of the
peripherals would have been built, on Python, and they would have automatically
been cross-platform.  I admit that that's not terribly helpful if, as you say,
you're interested in the Apple languages and frameworks themselves.
___

If your focus is connecting yaAGC only to the DSKY, some people have found it
helpful not to use the TCP-based interface that I refer to as "virtual wiring". 
I thought the virtual-wiring idea was good choice when the number and type of
peripherals was still unknown, since it was possible to create peripheral
devices as stand-alone programs, and to plug or unplug them from the AGC at
will.  But the virtual-wiring interface is abstracted into a handful of C
functions that can be replaced by something else that use some other
communication mechanism (such as shared memory) which may be more convenient for
you.  The SocketAPI.c file in `yaAGC/` contains the virtual-wiring implementation
of the AGC-peripheral communication mechanism, while `NullAPI.c` contains just the
model functions, empty of content, if you want to create a different
communications mechanism.  The idea is that you could adapt `NullAPI.c` as (say)
"SwiftAPI.c", and then just use `SwiftAPI.c` rather than `SocketAPI.c` when you
build `yaAGC`.

Conversely, if you want to keep SocketAPI.c and virtual-wiring mechanism, it may
be helpful to look at the Python model program piPeripheral/piPeripheral.py as a
model for your AGC-to-DSKY communications, since it connects to yaAGC and can
create/interpret data packets, but doesn't do anything with the data.  (The
folder also contains several perpiherals like piDSKY.py and piDEDA.py that I
built using piPeripheral.py, so don't be confused by their presence.)  The point
is that you could essentially port piPeripheral.py to Swift, and adapt it from
there.

Actually, I think that's not a bad idea!  If you started out — well, you've
already started, but you know what I mean — by creating a model Swift
peripheral, say as "piPeripheral.swift", then you or somebody else could
subsequently use piPeripheral.swift as a basis for implementing "DSKY.swift" or
other AGC peripherals for the Apple platform.

Of course, you didn't ask for my unsolicited and admittely ignorant opinions
about how to implement your own project.  I'm sure they're worth what you paid
for them, so feel free to ignore them.

Ron

### Date: Wed, 10 Jul 2024 15:23:46 -0400

Ron .. First, thanks very much for your long interesting reply which I will read
carefully, more than once!

Second, I didn’t notice those “top-chopped” words (and the digits too, by the
way) till you mentioned it. I had similar trouble with the “seven segment” font,
but different in that the last digit suffered “a right-chop” — I “fixed” that
with a tasteful use of font size and letter spacing!

More when I’ve digested your copious thoughts and have something of substance to
say! Best .. Gavin

