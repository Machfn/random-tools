This is a collection of random tools I made which I use somewhat often when working in WSL<br/>
**Please run setup.sh as it will compile the files into a folder ~/bin, you will need to add this to path (optionally go into the file and change the output destination of the compilers/linkers)

binaryConverter (C++)
  - converts either unsigned or signed ints to binary representations (max 32 bits for unsigned, and 31 for signed ints)
  USAGE:<br/>
    binary u [number] -> converts an unsigned int to binary representation<br/>
    binary s [number] -> converts a signed into to binary representation (2's compilment)<br/>

writeTo (ASM)
 - NOTE: This was written using 32 bit x86 assembly, I cannot guarantee it will work on every system
 - adds a string to a new line in a pre-existing file<br/>
USAGE:<br/>
    writeTo [fileName] [string] -> make sure you add " around strings with spaces<br/>

sendTo (GO)
  - sends http requests to web servers, I made it to send simple test messages to API's
  - NOTE: post requests use json files, add the path to json file as 3rd arguement<br/>
  USAGE:<br/>
    sendTo get [webAddress] -> prints the response from the web address (web address must be given with http:// or https://)<br/>
	sendTo post [webAddress] [jsonPath] -> sends post data and prints the response (web address must be given with http:// or https://)<br/>
