##  ApoDisKey

ApoDisKey is an implementation of the Apollo Guidance Computer (AGC's) display
and keyboard (DSKY) for Apple platforms.  The NASA Apollo program carried
twenty-four men to the Moon in the late 1960's and early 1970's, twelve of
them descending to explore the lunar surface, and back.  Each mission utilized
two crewed vehicles, the Command Module for transport from the Earth to the Moon
and back, and the Lunar Module for descent to and ascent from the lunar surface.

Both vehicles were equipped with identical computers for navigation and guidance
through all the phases of the missions. A cross-platform AGC simulator was
developed some years ago as part of the Virtual AGC project -- it is the **yaAGC**
program, written in C, in the following GitHub repository.

<https://www.ibiblio.org/apollo/>

The AGC architecture relies on multiple input and output channels to receive
data from radar, rotation and acceleration sensors, etc, and output commands to
jets and engines, etc.  Astronaut interaction with the AGC was via a peripheral
keyboard and display unit (DSKY) connected over these channels.

ApoDisKey's implementation of the DSKY is similarly separated from the actual
AGC and requires a running AGC emulator from above to communicate with. It will
launch and run in the absense of an AGC, but it will be quite uninteresting!

<p align="center"> <img src="https://ramsaycons.com/pix/macOS-DSKY-OV014B.png"
width="800" /> </p>

### Acknowledgments

Virtual AGC:

Zerlina and Gorton fonts:
