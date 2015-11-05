
#include md5.ahk
SetWorkingDir %A_ScriptDir%
if(%0%<=0){
	Msgbox, 拖放文件至图标，Please.
	ExitApp
}
path=%1%

SplitPath, % path, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive

SetFormat, Integer, HEX

hash:=substr(MD5_File(path),-5)
hFile:=fileOpen(path,"r")
hBinary:=fileOpen(OutNameNoExt "_" hash ".bin","w")


VarSetCapacity(binary, 0x20000, 0xFF)
while(!hFile.AtEOF){
	LineParse(hFile.ReadLine())
}
hBinary.RawWrite(binary, 0x20000)
hFile.close()
hBinary.close()
Msgbox, 完成
ExitApp

LineParse(line)
{
	global binary
	; S224(4bytes)+addr(6bytes)+content(32bytes)+check(1bytes)
	addr:=strToHex(SubStr(line, 5, 6))
	offset:=addr-0x8000
	loop, 32
	{
		NumPut(strToHex(SubStr(line, 2*(A_Index-1)+11, 2)), binary,offset, "UChar")
		offset+=1
	}
	
}

strToHex(str)
{
	hex:="0x" str
	hex+=0
	return hex
}

F5:: ExitApp
