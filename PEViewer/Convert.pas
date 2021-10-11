UNIT Convert;


INTERFACE
{$H-}
{Integer to Hexadecimal Convertion }
FUNCTION Hex8(n:byte):String;
FUNCTION Hex16(n:Word):String;
FUNCTION Hex32(n:LongInt):String;
FUNCTION Hex( N:Longint):String;
FUNCTION Bin2Hex(Const b :array of byte; n:integer; Spacer:String):String;
procedure Hex2Bin(Const s:String;var n:integer;var tab:Array of byte);

{Integer to Binary Convertion }
FUNCTION Bin8(n:byte):String;
FUNCTION Bin16(n:Word):String;
FUNCTION Bin32(n:Longint):String;

FUNCTION Hex2Long(Const h:String):LongInt;
FUNCTION Dec2Long(Const h:String):LongInt;
FUNCTION Bin2Long(Const h:String):LongInt;
FUNCTION Oct2Long(Const h:String):longint;

IMPLEMENTATION

{###########################################################################}
{###########################################################################}
Const HexChars:Array[0..15]OF char='0123456789ABCDEF';

FUNCTION Hex8(n:byte):String;
Begin
  Hex8[0]:=Char(2);
  Hex8[1]:=HexChars[n shr 4];
  Hex8[2]:=HexChars[n and $F];
End;

FUNCTION Hex16(n:Word):String;
Begin
  Hex16[0]:= Char(4);
  Hex16[1]:= HexChars[(N shr 12)       ];
  Hex16[2]:= HexChars[(N shr  8) and $F];
  Hex16[3]:= HexChars[(N shr  4) and $F];
  Hex16[4]:= HexChars[(N       ) and $F];
End;

FUNCTION Hex32(n:LongInt):String;
Begin
  Hex32:= Hex16((n shr 16) and $FFFF) + Hex16(n and $FFFF);
End;

FUNCTION Hex( N:Longint):String;
Var     Shift,a:Byte;
        Rt:String;
Begin
  Shift:=32-4;
  Rt:='';
  Repeat
   A:= (N shr Shift)and $F;
   if (Rt<>'') or (a<>0) Then Rt:=Rt+HexChars[A];
   Dec(Shift,4);
  Until Shift=0;
  Rt:=Rt+HexChars[n and $F];
  Hex:=Rt;
End;


FUNCTION Bin2Hex(Const b :array of byte; n:integer; Spacer:String):String;
 var i: integer;
     s:string;
begin
 s:='';
 for i:=0 to (n-1) do
  begin
   if s<>'' then s:=s+Spacer;
   s:=s+Hex8(b[i]);
  End;
 Result:=S;
end;

procedure Hex2Bin(Const s:String;var n:integer;var tab:Array of byte);

function Hex2Dec(c:char):byte;
begin
 Case c of
   '0'..'9': Result:= ord(c)-Ord('0');
   'a'..'f': Result:= ord(c)-Ord('a')+10;
   'A'..'F': Result:= ord(c)-Ord('A')+10;
 End;
end;

 Var Rt:LongInt;
     i:Byte;
Begin
 Rt:=0;
 i:=1; n:=0;
 while (i<=length(s)) do
  begin
   if (s[i] in['0'..'9','a'..'z','A'..'Z']) then
    begin
     if (s[i+1] in['0'..'9','a'..'z','A'..'Z']) then
      begin
       tab[n]:= Hex2Dec(s[i])*$10 + Hex2Dec(s[i+1]);
       inc(i,2); inc(n);
      end
     else
      begin
       tab[n]:= Hex2Dec(s[i]);
       inc(i); inc(n);
      end;
    end
   else inc(i);
  end;
End;

{###########################################################################}
{###########################################################################}
FUNCTION Bin8(n:byte):String;
Var S:String;
var i:byte;
Begin
  S:='';
  For i:=7 downto 0 do s:= s + Chr( ord('0')+( (n shr i) and 1 ));
  bin8:=s;
End;

FUNCTION Bin16(n:Word):String;
Begin
 Bin16:= Bin8(n shr 8)+bin8(n and $0f);
End;

FUNCTION Bin32(n:Longint):String;
Begin
 Bin32:= Bin16(n shr 16)+bin16(n and $FF);
End;


{###########################################################################}
{##########################################################################}
FUNCTION Hex2Long(Const h:String):LongInt;
 Var Rt:LongInt;
     i:Byte;
Begin
 Rt:=0;
 For i:=1 to Length(h) do
    Case h[i] of
     '0'..'9': Rt:=Rt shl 4 + ord(h[i])-Ord('0');
     'a'..'f': Rt:=Rt shl 4 + ord(h[i])-Ord('a')+10;
     'A'..'F': Rt:=Rt shl 4 + ord(h[i])-Ord('A')+10;
    End;
 Hex2Long:=Rt;
End;

FUNCTION Dec2Long(Const h:String):LongInt;
 Var    Rt      :LongInt;
        Count   :Byte;
        Signed  :Boolean;
Begin
 Rt:=0;
 Count:=1;
 Signed:=False;
 While Count<=Length(h) do
  Begin
    Case h[Count] of
        '0'..'9': Rt:=Rt * 10 + ord(h[Count])-Ord('0');
        '-'     : if Count=1 Then Signed:=True;
    End;
    inc(Count);
  End;
 if Signed Then Rt:=-Rt;
 Dec2Long:=Rt;
End;

FUNCTION Bin2Long(Const h:String):LongInt;
 Var Rt:LongInt;
     i:Byte;
Begin
 Rt:=0;
 For i:=1 to Length(h) do
   if h[i] in['0','1'] Then  Rt:=Rt * 2 + Ord(h[i])-Ord('0');
 Bin2Long:=Rt;
End;

FUNCTION Oct2Long(Const h:String):longint;
{ Converts an octal string to longint }
 Var    Rt      : Longint;
        i       : Byte;
Begin
  Rt:=0;
  For i:=1 to Length(h) do
     if h[i] in ['0'..'7'] then Rt:=(Rt shl 3) + (Byte(h[i])-Byte('0'));
  Oct2Long:=Rt;
End;



END.

