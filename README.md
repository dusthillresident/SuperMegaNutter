# SuperMegaNutter

Random number generator written in scheme that can pass PractRand test

**PLEASE NOTE:** *This project is purely for research and educational purposes, it must **NOT** be used for any practical purposes or applications. I'm posting it here for discussion, as a potential example of what NOT to do, and just as an interesting curiosity. I developed this function in the hopes that it will NEVER be used.*

*For practical purposes, you should **NEVER** attempt to write your own pseudo-random number generator, even if you are a highly experienced mathematician. It's very easy to make something with serious biases, and the consequences could be very serious.*

Hello,

Recently I've been experimenting with 'dieharder' and 'practrand' statistical testing suite software, and researching different methods that are used to generate pseudo-random numbers, and I independently developed a technique that I've been calling "nutting".

'Nutting' is to take the result of a multiplication fmod 1.0.
This design uses two state variables which increase at different rates, and eventually wrap back around. (The wrap-around event is known as the 'sideways nutting action'.)
I tested it with a C implementation that writes a stream of 32bit integers to stdout, and fed that into 'practrand'. I also ran in parallel a separate version of it with the output bits in reverse order, and tested that with practrand too.

Both instances passed the full 32TB of testing from practrand. This is the point where you should be especially uncomfortable and suspicious, because it doesn't mean there aren't serious problems, it just means that practrand was not able to detect them.

The source code for the C implementation is included in the repository too.

A bbc basic version is available here: https://www.bbcbasic.net/forum/viewtopic.php?t=1572
