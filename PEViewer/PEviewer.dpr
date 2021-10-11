{$APPTYPE CONSOLE}
{$H-}
USES	Convert,SysUtils;
{ PE = Portable Executable }
{ RVA = Relative Virtual Addresses }

{$i PEheader}
{$i PEnames}


function LtJustify(s:String;n:byte):String;
 var i:byte;
begin
 result:='';
 for i:=1 to n-length(s) do result:=result+' ';
 result:=result+s;
end;

VAR	PEfile	:file;
    PEname	:String;
	EXEhead	:tEXEheader;
	PEhead	:tPEheader;
	PEopthead:tPEoptheader;

PROCEDURE OpenFile;
Begin
  if Paramcount<1 Then begin
    Writeln('Usage: PEviewer <Nom Fichier>.exe');
    Writeln;
    Writeln('Appuyer sur ENTREE pour terminer.');
    Readln;
    Halt;
  end;
  PEname:=Paramstr(1);
  fileMode:=0;
 {$I-}
  Assign(PEfile,PEname);
  Reset(PEfile,1);
 {$I+}
 if IOresult<>0 Then
   Begin
      Writeln(' FILE  NOT  FOUND  ',PEname);
      Halt(1);
   End;
End;

PROCEDURE WriteEXEhead(Const Exehead:tEXEheader);
Begin
 Writeln('Header Information of '+PEname);
 With EXEhead do begin
  Writeln('MS-DOS Header');
  Writeln(LtJustify('Signature: ',40)+Signature);
  Writeln(LtJustify('Last PAGE Size: ',40)+ Hex16(LengthRem));
  Writeln(LtJustify('Total PAGES in File: ',40)+ Hex16(LengthPages));
  Writeln(LtJustify('Number of relocation items: ',40)+ Hex16(NumReloc));
  Writeln(LtJustify('Size in paragraphs of EXE header: ',40)+ hex16(HeaderSize));

  Writeln(LtJustify('Minimum Extra Paragraphs: ',40)+ hex16(MinHeap));
  Writeln(LtJustify('Maximum Extra Paragraphs: ',40)+ hex16(MaxHeap));

  Writeln(LtJustify('Initial Stack Segment: ',40)+ hex16(InitSSeg));
  Writeln(LtJustify('Initial Stack Pointer: ',40)+ hex16(InitSPtr));
  Writeln(LtJustify('Complemented Checksum: ',40)+ hex16(CheckSum));
  Writeln(LtJustify('Initial Instruction Pointer: ',40)+ hex16(InitIPtr));
  Writeln(LtJustify('Initial Code Segment: ',40)+ hex16(InitCSeg));

  Writeln(LtJustify('Relocation Table Offset: ',40)+ hex16(OfsReloc));
  Writeln(LtJustify('Overlay Number: ',40)+ hex16(OverlayNum));
 End;
End;                  

PROCEDURE WritePEhead;
Begin
 With PEhead do begin
  Writeln('');
  Writeln('PE Header');
  Writeln(LtJustify('Magic: ',40)+ Magic);
  Writeln(LtJustify('Machine: ',40)+ PE_MachineName(Machine));
  Writeln(LtJustify('Number of Sections: ',40)+ hex16(NumberOfSections) );
  Writeln(LtJustify('Time Date Stamp: ',40)+ hex32(TimeDateStamp) );
  Writeln(LtJustify('Pointer To SymbolTable: ',40)+ hex32(PointerToSymbolTable) );
  Writeln(LtJustify('Number Of Symbols: ',40)+ hex32(NumberOfSymbols) );
  Writeln(LtJustify('Size Of Optional Header: ',40)+ hex16(SizeOfOptionalHeader) );
  Writeln(LtJustify('Characteristics: ',40)+ hex16(Characteristics) );
 End;

 With PEopthead do begin
  Writeln('');
  Writeln(' Optional Header:');
  Writeln(LtJustify('Magic: ',40)+ hex16(Magic) );
  Writeln(LtJustify('Linker Version: ',40)+hex(MajorLinkerVersion)+'.'+hex8(MinorLinkerVersion) );
  Writeln(LtJustify('Size of Code: ',40)+ hex32(SizeOfCode) );
  Writeln(LtJustify('Size of Initialized Data: ',40)+ hex32(SizeOfInitializedData) );
  Writeln(LtJustify('Size of Uninitialized Data: ',40)+ hex32(SizeOfUninitializedData) );
  Writeln(LtJustify('Address of Entry Point: ',40)+ hex32(AddressOfEntryPoint) );
  Writeln(LtJustify('Base of Code: ',40)+ hex32(BaseOfCode));
  Writeln(LtJustify('Base of Data: ',40)+ hex32(BaseOfData));
  Writeln(LtJustify('Image Base: ',40)+ hex32(ImageBase));
  Writeln(LtJustify('Section Alignment: ',40)+ hex32(SectionAlignment));
  Writeln(LtJustify('File Alignment: ',40)+ hex32(FileAlignment));
  Writeln(LtJustify('Operating System Version: ',40)+ hex(MajorOperatingSystemVersion)
				+'.'+hex16(MinorOperatingSystemVersion));
  Writeln(LtJustify('Image Version: ',40)+ hex(MajorImageVersion)
				+'.'+ hex16(MinorImageVersion));
  Writeln(LtJustify('Subsystem Version: ',40)+ hex(MajorSubsystemVersion)
				+'.'+ hex16(MinorSubsystemVersion));
  Writeln(LtJustify('Reserved1: ',40)+ hex32(Reserved1));
  Writeln(LtJustify('Size of Image: ',40)+ hex32(SizeOfImage));
  Writeln(LtJustify('Size of Headers: ',40)+ hex32(SizeOfHeaders));
  Writeln(LtJustify('CheckSum: ',40)+ hex32(CheckSum));
  Writeln(LtJustify('Subsystem: ',40)+ PE_SubSystemName(Subsystem));
  Writeln(LtJustify('Dll Characteristics: ',40)+ hex16(DllCharacteristics));
  Writeln(LtJustify('Size of StackReserve: ',40)+ hex32(SizeOfStackReserve));
  Writeln(LtJustify('Size of StackCommit: ',40)+ hex32(SizeOfStackCommit));
  Writeln(LtJustify('Size of HeapReserve: ',40)+ hex32(SizeOfHeapReserve));
  Writeln(LtJustify('Size of HeapCommit: ',40)+ hex32(SizeOfHeapCommit));
  Writeln(LtJustify('Loader Flags: ',40)+ hex32(LoaderFlags));
  Writeln(LtJustify('Size of data directory: ',40)+ hex32(NumberOfRvaAndSizes));
  {Writeln(''+ DataDirectory : array[1..16] of tPEdirectory;{ 16 directory }
 End;
End;

PROCEDURE ReadHeader;
Begin
 {EXE Header}
  {Verify file Size}
  if FileSize(PEfile)<SizeOf(tEXEheader) then
   Begin
    Writeln(' File too short');
    Halt(1);
   End;

  BlockRead(PEfile, EXEHead, SizeOf(tEXEheader));
  WriteEXEhead( EXEhead );
  if (EXEhead.Signature<>'MZ')AND(EXEhead.Signature<>'ZM') Then
   Begin
    Writeln(' Not Executable File ');
    Halt(1);
   End;
 {PEheader}
  if EXEhead.OfsReloc<>$0040 then
   Begin
    Writeln(' Not Portable Executable File ');
    Halt(1);
   End;

  Seek (PEfile, EXEhead.OfstPEheader);
  BlockRead (PEfile, PEhead, SizeOf(tPEheader));
  if PEhead.Magic<>'PE'#0#0 Then
   Begin
    Writeln(' Not Portable Executable File ');
    Halt(1);
   End;
  BlockRead (PEfile, PEopthead, SizeOf(tPEoptheader));
  WritePEhead;
End;

Procedure WriteDirectories;
 Var i:Byte;
begin
  With PEopthead do
  begin { Affiche les 16 RVA et taille }

   for i := 1 to 16 do
    with Directory[i] do
     if (Rva<>0) or (Taille<>0) then
     begin
       Writeln('');
       Writeln(PE_DirectoryName(i)+':');
       Writeln(LtJustify('RVA: ',40) +hex32(RVA) );
       Writeln(LtJustify('Size: ',40)+hex32(Taille) );
     End;

  End;
End;

procedure WriteSections;
 Var PESection:tPESection;
     i:Word;
begin
 With PEhead do
  for i:=1 to NumberOfSections do
  Begin
    BlockRead (PEfile, PESection, SizeOf(tPEsection));
    Writeln('');
    Writeln('Section '+IntToStr(i)+'   Name: '+PEsection.Name);
    Writeln(LtJustify('Virtual Size: ',40)+  hex32(PEsection.VirtualSize));
    Writeln(LtJustify('Virtual Address: ',40)+  hex32(PEsection.VirtualAddress));
    Writeln(LtJustify('Size of raw data: ',40)+  hex32(PEsection.SizeofRawData));
    Writeln(LtJustify('Pointer to Raw Data: ',40)+  hex32(PEsection.PtrtoRawData));
    Writeln(LtJustify('Pointer to Relocations: ',40)+  hex32(PEsection.PtrtoRelocations));
    Writeln(LtJustify('Pointer to Line Numbers: ',40)+  hex32(PEsection.PtrtoLineNumbers));
    Writeln(LtJustify('Number of Relocations: ',40)+  hex16(PEsection.NbrRelocations));
    Writeln(LtJustify('Number of Line Numbers: ',40)+  hex16(PEsection.NbrlineNumbers));
    Writeln(LtJustify('Characteristics: ',40)+ hex32(PEsection.Characteristics));
    { Characteristics:
	$60000020:Contains code,Executable,Readable = 'code'
	$40000040:Contains Initialized Data, Readable ='donn‚es'
	$42000040:Contains InitData,discarded,readable .reloc
	$50000040 'donn‚es partag‚es'
	$C0000040 'variables'
	$C0000000 'Lecture + ‚criture'
	$E0000020 'CODE (+ variables)'
	}
  End;
End;

Begin
 OpenFile;
 ReadHeader;
 WriteDirectories;
 WriteSections;
 Close(PEfile);
 Readln;
End.
