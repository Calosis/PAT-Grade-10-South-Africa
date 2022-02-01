unit u_Base32Util;

interface

uses
  System.SysUtils;

type
  Base32 = class
  public
    class function Decode(const inString: String): String;
    class function Encode(const inString: String): String;
  end;

  // Allowed Chars to be processed.
const
  cValidChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

implementation

{$REGION 'Base32Functions'}

function Base32Encode(const Input: TBytes): string;
const
  Base64: array [0 .. 63]
    of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  function Encode3Bytes(const Byte1, Byte2, Byte3: Byte): string;
  begin
    Result := Base64[Byte1 shr 2] + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and
      $3F] + Base64[((Byte2 shl 2) or (Byte3 shr 6)) and $3F] +
      Base64[Byte3 and $3F];
  end;

  function EncodeLast2Bytes(const Byte1, Byte2: Byte): string;
  begin
    Result := Base64[Byte1 shr 2] + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and
      $3F] + Base64[(Byte2 shl 2) and $3F] + '=';
  end;

  function EncodeLast1Byte(const Byte1: Byte): string;
  begin
    Result := Base64[Byte1 shr 2] + Base64[(Byte1 shl 4) and $3F] + '==';
  end;

var
  i, iLength: Integer;
begin
  Result := '';
  iLength := Length(Input);
  i := 0;
  while i < iLength do
  begin
    case iLength - i of
      3 .. MaxInt:
        Result := Result + Encode3Bytes(Input[i], Input[i + 1], Input[i + 2]);
      2:
        Result := Result + EncodeLast2Bytes(Input[i], Input[i + 1]);
      1:
        Result := Result + EncodeLast1Byte(Input[i]);
    end;
    Inc(i, 3);
  end;
end;

function Base32Decode(const source: String): String;
var
  UpperSource: String;
  p, i, l, n, j: Integer;
begin
  UpperSource := UpperCase(source);

  l := Length(source);
  n := 0;
  j := 0;
  Result := '';

  for i := 1 to l do
  begin
    n := n shl 5;

    p := Pos(UpperSource[i], cValidChars);
    if p >= 0 then
      n := n + (p - 1);

    j := j + 5; // Number of bits in current buffer.

    if (j >= 8) then
    begin
      j := j - 8;
      Result := Result + chr((n AND ($FF shl j)) shr j);
    end;
  end;
end;

{$ENDREGION}
{ Base32 }

// PUBLIC FUNCTIONS TO BE USED...
class function Base32.Decode(const inString: String): String;
begin
  Result := Base32Decode(inString);
end;

class function Base32.Encode(const inString: String): String;
begin
  Result := Base32Encode(BytesOf(inString));
end;

end.
