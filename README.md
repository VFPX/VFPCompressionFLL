# VFPCompressionFLL

Project Manager: John Ryan

This project is intended as a drop-in replacement for the excellent vfpcompression.fll that has been a wonderful VFP resource for compression / decompression needs. However, the FLL is no longer supported by its author (Craig Boyd), it relies on obsolete VC++ libraries, and it is incompatible with x64 VFP development.

The code is based on the ZLib functions and samples created by Carlos Alloatti, here: https://github.com/calloatti/ZLIB covered by MIT license.

This PRG uses the **zlibwapi.dll** DLL that is a 32/64bit Windows DLL module for ZLib compression/decompression. Zlibwapi.dll is a special build of the ZLib library developed by Jean-loup Gailly & Mark Adler. Information including Distribution License can be found here: https://zlib.net/

*Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:*
  1. *The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.*
...
...

It is possible that equivalent functionality could be provided by the Windows compression API without an extra DLL. However, experimentation could not deliver the FLL's ZLib deflate functionality with custom liLevel encryption level. Perhaps some other contributor can find a way!

To use this PRG, replace:

```
SET LIBRARY TO vfpcompression.fll
```

with:

```
SET PROCEDURE TO vfpcompressionfll.prg
```

## Departures from vfpencryption.fll:

* Initial release only provides ZipString and UnzipString functionality, since that is all the original author needed. Other functions should be possible by following declarations and samples provided by Carlos Alloatti.

The following documentation is derived from the original FLL documentation, with any changes in **bold**. There are no documentation changes for ZipString() and UnzipString().

## Function Zipstring()
Signature: ZipString(cString[, nLevel])

Parameters:

* cString – The character string you wish to compress

* nLevel – The compression level to use which is 1 through 9 (1 is the fastest, while 9 is the best compression). The default value for this parameter is 6.

Return Value:

Character Data – the compressed version of cString.

## Function UnzipString()
Signature: UnzipString(cString)

Parameters:

* cString – The compressed string you wish to uncompress.

Return Value:

Character Data – the extracted version of cString.

Remarks:

The string to be extracted must have been compressed with the ZipString() function or other compression function that is compatible with the compress or compress2 functions in zlib.


