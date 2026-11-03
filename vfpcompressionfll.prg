*!*	Parts of the following code are based on ZLib code published under MIT license by Carlos Alloatti here: https://github.com/calloatti/ZLIB 
*!*	Where relevant:
*!*	Copyright (c) 2020 Carlos Alloatti
*!*	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*!*	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#if .t.
*----create a ZipString TEST!

lcSource="This is a test "+TRANSFORM(DATETIME())

SET LIBRARY TO 

CLEAR
? "API:Zip"
lczlibZip=zipstring(m.lcSource)
? lcsource,LEN(lcsource),lczlibZip,LEN(lczlibZip)

? "API:UnZip"
lczlibunzip=unzipstring(lczlibZip)
? lcsource,LEN(lcsource),lczlibunzip,LEN(lczlibunzip)

SET LIBRARY TO vfpcompression.fll
? "FLL:Zip"
lcfllZip=zipstring(m.lcSource)
? lcsource,LEN(lcsource),lcfllZip,LEN(lcfllZip)

? "FLL:UnZip"
lcfllunzip=unzipstring(lcfllZip)
? lcsource,LEN(lcsource),lcfllunzip,LEN(lcfllunzip)

IF lczlibZip==lcfllZip
	? "Zip matches"
ELSE
	? "Zip mismatch"
	SET STEP ON
endif
IF m.lczlibunzip==lcfllunzip
	? "Unzip matches"
ELSE
	? "Unzip mismatch"
	SET STEP ON
ENDIF
#endif


*!* Return codes for the compression/decompression functions. Negative values
*!* are errors, positive values are used for special but normal events.

*---note: DECLARE functions unpathed since DLL should be in launch folder

#DEFINE Z_ZLIB1			zlibwapi.dll
*zlib1.dll
#Define Z_OK			0
#Define Z_STREAM_END	1
#Define Z_NEED_DICT		2
#Define Z_ERRNO			(-1)
#Define Z_STREAM_ERROR	(-2)
#Define Z_DATA_ERROR	(-3)
#Define Z_MEM_ERROR		(-4)
#Define Z_BUF_ERROR		(-5)
#Define Z_VERSION_ERROR	(-6)


*******************************************************************************************************
FUNCTION zipstring(lcString,liLevel)
*---mimics zipstring in vfpcompression.fll
LOCAL lcDest,liDestlen,liResult
*lcstring=
*lilevel=
*lcDest=
*liDestlen=
*liResult=

lidestlen=LEN(m.lcstring)+20	&&small strings don't compress much, so allow space for header
lcDest=SPACE(m.lidestlen)
IF EMPTY(m.liLevel)
	liLevel=6
endif
liResult=_zlibapicompress2(@lcdest, @m.lidestlen, m.lcString,LEN(m.lcString),m.liLevel)
IF EMPTY(m.liresult)
	RETURN LEFT(m.lcDest,m.liDestlen)
ELSE
	*---save error for calling function...
	TRY
		ERROR "Zipstring API returned "+TRANSFORM(m.liresult)
	CATCH
	ENDTRY
	RETURN ""
ENDIF

********************************************************************************************************
FUNCTION unzipstring(lcString)
*lcString=
LOCAL lcDest,liDestlen,liMultiplier,lilen,liResult
*lcDest=
*liDestlen=
*liMultiplier=
*lilen=
*liResult=

STORE LEN(m.lcstring) TO liDestlen,lilen

*---don't know length of sourcestring so start with *2 and increase as needed

liresult=Z_BUF_ERROR

DO WHILE m.liResult=Z_BUF_ERROR
	liDestlen=m.lilen+m.liDestlen
	lcDest=SPACE(m.liDestlen)
	liresult=_zlibapiuncompress(@m.lcdest, @m.lidestlen, m.lcString, m.lilen)
ENDDO
IF EMPTY(m.liresult)
	RETURN LEFT(m.lcDest,m.lidestlen)	
ELSE
	TRY
	*---save error for calling function...
		ERROR "Unzipstring threw API Error "+TRANSFORM(m.liresult)
	CATCH
	ENDTRY
	RETURN ""
ENDIF

FUNCTION _zlibapicompress2(dest, destlen, Source, sourcelen, nlevel)

*#beautify keyword_nochange

Declare Integer compress2 In Z_ZLIB1 As _zlibapicompress2 ;
	String  @Dest, ;
	Integer @destlen, ;
	String  Source, ;
	Integer sourcelen, ;
	Integer nlevel

*#beautify

Return _zlibapicompress2(@m.dest, @m.destlen, m.source, m.sourcelen, m.nlevel)

FUNCTION _zlibapiuncompress(dest, destlen, source, sourcelen)

declare integer uncompress in Z_ZLIB1 as _zlibapiuncompress ;
	string  @dest, ;
	integer @destlen, ;
	string  source, ;
	integer sourcelen

return _zlibapiuncompress(@m.dest, @m.destlen, m.source, m.sourcelen)