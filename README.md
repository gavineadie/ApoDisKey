## ApoDisKey

<p align="center"> <img src="https://ramsaycons.com/pix/macOS-DSKY-EC234A.png"
width="400" /> </p>

### Context

__ApoDisKey__ is an emulation, for Apple platforms, of the NASA Apollo
spacecraft's Guidance Computer (AGC) display and keyboard (DSKY) hardware.

In the late 1960's and early 1970's, the NASA Apollo program carried
twenty-seven men to the Moon, twelve of them descending to explore the lunar
surface, and back. Each mission utilized two crewed vehicles, the _Command
Module_ (CM) for transport from the Earth to the Moon and back, and the _Lunar
Module_ (LM) for descent to and ascent from the lunar surface.

Both vehicles were equipped with identical computers for navigation and guidance
through all the phases of the missions. The Apollo astronaunts communicated with
the AGC using a display/keyboard (DSKY) peripheral (two on the CM and one on the
LM).

The AGC itself deserves a solid place in computing history for innovations in
hardware and software on its delivery in 1966.  Of particular note was the
sofware design for a multitasking executive running the many necessary tasks in
a fail-safe mode. The AGC's performance was about equivalent to an Apple II.

The AGC architecture relies on multiple input and output channels to receive
data from radar, rotation, acceleration and other sensors, and output commands
to jets and engines, etc. The peripheral keyboard and display unit (DSKY) also
connected over these channels.

### Apollo Guidance Computer

ApoDisKey's implementation of the DSKY is similarly separated from the actual
AGC and requires a running AGC emulator (no remaining real AGC being available)
to communicate with.

A huge effort started several years ago, and continues, to preserve the details of the AGC. The
original engineering and manufacturing documents have been preserved and much of
the software has been recovered from listings or dumped from AGC memory boards.
This work is documented and preserved at: [The Virtual AGC
Project](https://www.ibiblio.org/apollo/).

Included in the Virtual AGC Project is cross-platform AGC simulator which was
developed some years ago as part of the Virtual AGC project -- it is the `yaAGC`
program, written in C, in the Virtual AGC [GitHub
repository](https://github.com/virtualagc/virtualagc).

### Connecting ApoDisKey to `yaAGC`

ApoDisKey will launch and run in the absense of an `yaAGC`, but it will be quite
uninteresting -- rather like an unplugged regular computer keyboard.  The
emphasis here is that ApoDisKey without `yaAGC` is nothing more than a pretty
face!

When running on a Mac, the Virtual AGC project will detect the presence of 
ApoDisKey and make it an option to be used in place of the provided DSKY application.
Obtaining, [building and running Virtual AGC on macOS](https://www.ibiblio.org/apollo/download.html#Sequoia) 
is well described in that project's documentation.

Questions, issues and concerns that are related to ApoDisKey specifically should
come to this author via this project's [issues](https://github.com/gavineadie/ApoDisKey/issues)
page.

### supported macOS versions

ApoDisKey will run on macOS versions 14 (Sonoma) and 15 (Sequoia).  Because the 
regular version uses new features of SwiftUI, there is a separate
version that will run on macOS 12 (Monterey) and 13 (Ventura). 

### Acknowledgments

[The Virtual AGC Project](https://www.ibiblio.org/apollo/)

[Zerlina and Gorton fonts](https://github.com/ehdorrii/dsky-fonts)
