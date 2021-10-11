CONST
  PEoptionStr: Array[0..15]of String[60] = (
	{00}'Have Reallocated info',
	{01}'Executable file',
	{02}'line number information is stripped',
	{03}'Contient des informations sur les symboles locaux',
	{04}'Le systŠme d''exploitation est cens‚ ''trim the working',
	{05}'',
	{06}'',
	{07}'Les octets doivent ˆtre ‚chang‚s mot/mot',
	{08}'Programme 32 bits',
	{09}'Ne contient pas d''information de d‚bogage',
	{10}'Ne doit pas ˆtre lanc‚ depuis un suport ‚changeable (CD-Rom)',
	{11}'Ne doit pas ˆtre lanc‚ depuis un r‚seau',
	{12}'C''est un fichier systŠme (pilote)',
	{13}'C''est une DLL',
	{14}'Ne supporte pas les systŠmes multi-processeurs',
	{15}''
        );

FUNCTION PE_MachineName  (Machine: Word) : String;
Begin
 Case Machine of
   $0000: PE_MachineName  := 'UNKNOWN';
   $014C: PE_MachineName  := 'Intel 80386';
   $014D: PE_MachineName  := 'Intel 80486';
   $014E: PE_MachineName  := 'Intel Pentium';
   $0160: PE_MachineName  := 'R3000 (MIPS), big endian';
   $0162: PE_MachineName  := 'R3000 (MIPS), little endian';
   $0166: PE_MachineName  := 'R4000 (MIPS), little endian';
   $0168: PE_MachineName  := 'R10000 (MIPS), little endian';
   $0169: PE_MachineName  := 'MIPS little-endian WCE v2';
   $0184: PE_MachineName  := 'DEC Alpha AXP';
   $01F0: PE_MachineName  := 'IBM Power PC, little endian';
   $01A2: PE_MachineName  := 'SH3 little-endian';
   $01A4: PE_MachineName  := 'SH3E little-endian';
   $01A6: PE_MachineName  := 'SH4 little-endian';
   $01C0: PE_MachineName  := 'ARM Little-Endian';
   $01C2: PE_MachineName  := 'THUMB';
   $0200: PE_MachineName  := 'Intel 64';
   $0266: PE_MachineName  := 'MIPS16';
   $0366: PE_MachineName  := 'MIPS FPU';
   $0466: PE_MachineName  := 'MIPS FPU16';
   $0284: PE_MachineName  := 'ALPHA64';
   $C0EF: PE_MachineName  := 'IMAGE_FILE_MACHINE_CEF';
   Else PE_MachineName :='';
  End;
End;

{ Directory Entries }
FUNCTION PE_DirectoryName  (IndexRep: Byte) : String;
 var TmpTxt: String[3];
begin
  Case IndexRep of
   1: PE_DirectoryName  := 'Export Directory';
   2: PE_DirectoryName  := 'Import Directory';
   3: PE_DirectoryName  := 'Resource Directory';
   4: PE_DirectoryName  := 'Exception Directory';
   5: PE_DirectoryName  := 'Security Directory';
   6: PE_DirectoryName  := 'Base Relocation Table';
   7: PE_DirectoryName  := 'Debug Directory';
   8: PE_DirectoryName  := '(X86 usage)';
   9: PE_DirectoryName  := 'Architecture Specific Data'; { MIPS GP }
  10: PE_DirectoryName  := 'RVA of GP';
  11: PE_DirectoryName  := 'Load Configuration Directory';
  12: PE_DirectoryName  := 'Bound Import Directory in headers';
  13: PE_DirectoryName  := 'Import Address Table';
  14: PE_DirectoryName  := 'Delay Load Import Descriptors';
  15: PE_DirectoryName  := 'COM Runtime descriptor';
  else begin
    Str (IndexRep,TmpTxt);
    PE_DirectoryName  := 'inconnu (='+TmpTxt+')';
  end end;
End;

function PE_ResourceName  (IndexRes: LongInt) : String;
 var TmpTxt: String[12];
begin
  Case IndexRes of
   -1: PE_ResourceName  := '-und‚finie-';
    1: PE_ResourceName  := 'Curseur';
    2: PE_ResourceName  := 'Bitmap';
    3: PE_ResourceName  := 'Ic“ne';
    4: PE_ResourceName  := 'Menu';
    5: PE_ResourceName  := 'Dialogue';
    6: PE_ResourceName  := 'ChaŒne de caractŠres';
    7: PE_ResourceName  := 'R‚pertoire de polices';
    8: PE_ResourceName  := 'Police';
    9: PE_ResourceName  := 'Acc‚l‚rateurs';
   10: PE_ResourceName  := 'Donn‚e non-format‚e';
   11: PE_ResourceName  := 'Table des messages';
   12: PE_ResourceName  := 'Groupe de curseurs';
   14: PE_ResourceName  := 'Groupe d''ic“ne';
   16: PE_ResourceName  := 'Informations de version';
  241: PE_ResourceName  := 'Barre des tƒches';
  else begin
    Str (IndexRes,TmpTxt);
    PE_ResourceName  := 'inconnu='+TmpTxt;
  end end;
end;

function PE_SubSystemName (SubSystem: Word) : String;
Begin
 PE_SubSystemName:= '';
 Case SubSystem of
  1: PE_SubSystemName := 'Aucun';
  2: PE_SubSystemName := '(Gui) Graphic Windows';
  3: PE_SubSystemName := '(Cui) Console Windows';
  4: PE_SubSystemName := 'Console OS/2';
  5: PE_SubSystemName := 'Console POSIX';
 End;
End;
