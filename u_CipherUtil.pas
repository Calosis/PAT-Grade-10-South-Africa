unit u_CipherUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, System.NetEncoding, Vcl.ComCtrls;

type
  Cipher = class
  public
    class function Decode(const inString: String): String;
    class function Encode(const inString: String): String;
  end;

implementation

{$REGION 'CipherFunctions'}

function CipherEncode(const Input: TBytes): String;
var
  I: Integer;
  iOrd : Byte;
  sCipher: String;
begin
  // OWN CIPHER
  iOrd := 0;
  sCipher := '';

  for I := 0 to Length(Input) -1 do
  begin

    iOrd := Ord(Input[I]);


    iOrd := iOrd xor 2;

    sCipher := sCipher + Char(iOrd);

  end;
  ShowMessage(sCipher);
  Result := sCipher;
end;

function CipherDecode(const source: String): String;
var
  I: Integer;
  sCipher: String;
  iOrd : Byte;
begin
  // OWN CIPHER
  iOrd := 0;
  sCipher := '';

  for I := 0 to Length(source) -1 do
  begin

    // ODD
    iOrd := Ord(source[I]);

    iOrd := iOrd xor 2;

    sCipher := sCipher + Char(iOrd);

  end;

Result := sCipher;
end;

{$ENDREGION}
{ Cipher }

// PUBLIC FUNCTIONS TO BE USED...
class function Cipher.Decode(const inString: String): String;
begin
  Result := CipherDecode(inString);
end;

class function Cipher.Encode(const inString: String): String;
begin
  Result := CipherEncode(BytesOf(inString));
end;

end.
