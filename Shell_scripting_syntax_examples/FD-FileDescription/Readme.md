these standard file descriptors and file descriptors air a way for us to formally open and close a file and references to it, and that they become a little bit more important as we deal with file streams and functions. So I want to be sure that we understand what file descriptors are. File descriptors are simply
a numeric representation of a file that we want to read, write or read and write Thio, and we can determine how we open that file at runtime.


In simple words, when you open a file, the operating system creates an entry to represent that file and store the information about that opened file. So if there are 100 files opened in your OS then there will be 100 entries in OS (somewhere in kernel). These entries are represented by integers like (...100, 101, 102....). This entry number is the file descriptor. So it is just an integer number that uniquely represents an opened file in operating system. If your process opens 10 files then your Process table will have 10 entries for file descriptors.

Similarly when you open a network socket, it is also represented by an integer and it is called Socket Descriptor. I hope you understand.
