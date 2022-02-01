unit u_Gen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Math, Vcl.Samples.Spin;

type
  TfrmGen = class(TForm)
    imgBackground: TImage;
    pnlMiddle: TPanel;
    btnLogout: TBitBtn;
    rtGenLoad: TRichEdit;
    cmbGenType: TComboBox;
    rtOutputGen: TRichEdit;
    stTitle: TStaticText;
    btnSave: TButton;
    btnLoad: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogoutClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure cmbGenTypeSelect(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  // GLOBAL VAR.
  frmGen: TfrmGen;
  sToSave: String;
  textFile: TStringlist;

implementation

{$R *.dfm}

uses u_Main, u_Register, u_Base32Util;


// CUSTOM FUNCTIONS.
// BY - https://edn.embarcadero.com/article/28325

function EnDeCrypt(const Value: String): String;
var
  CharIndex: Integer;
begin
  Result := Value;
  for CharIndex := 1 to Length(Value) do
    Result[CharIndex] := chr(not(ord(Value[CharIndex])));
end;

function genPassword(Length: Integer): String;
var
  sString: String;
  iRandom, iLength: Integer;

begin
  Randomize;

  sString :=
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!@#$%^&*()';

  Result := '';

  iLength := sString.Length;
  iRandom := RandomRange(1, iLength + 1);

  repeat
    Result := Result + sString[iRandom];
    iRandom := RandomRange(1, iLength + 1);
  until Result.Length = Length;

end;

procedure RoundCornerOf(Control: TWinControl);
var
  Rect: TRect;
  Rgn: HRGN;

  // Function by: https://stackoverflow.com/users/1062933/please-dont-bully-me-so-lords
begin
  with Control do

  begin
    Rect := ClientRect;

    Rgn := CreateRoundRectRgn(Rect.Left, Rect.Top, Rect.Right,
      Rect.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@Rect));

    InflateRect(Rect, -4, -4);
    Perform(EM_SETRECTNP, 0, lParam(@Rect));
    SetWindowRgn(Handle, Rgn, True);
    Invalidate;

  end;

end;


// END CUSTOM FUNCTIONS.

procedure TfrmGen.btnLogoutClick(Sender: TObject);
begin

  // CLEAR.
  frmGen.Hide;
  frmMain.Show;

  rtGenLoad.Clear;
  rtOutputGen.Clear;

end;

procedure TfrmGen.btnSaveClick(Sender: TObject);
begin

  // NULL CHECK.
  if sToSave = NullAsStringValue then
  begin

    ShowMessage('Please generate something before saving!');

  end
  else
  begin
    // PREP FOR DATA FILE.
    Append(myFile);
    WriteLn(myFile, sToSave);
    CloseFile(myFile);

    ShowMessage('Saved!');
    Reset(myFile);
    sToSave := '';
  end;

end;

procedure TfrmGen.btnLoadClick(Sender: TObject);
var
  sLine: String;

begin

  rtGenLoad.Clear;

  // READ ALL DATA.

  while not Eof(myFile) do
  begin
    Readln(myFile, sLine);
    rtGenLoad.Lines.Add(sLine);

  end;

  // CLOSE.
  CloseFile(myFile);
  Reset(myFile);

end;

procedure TfrmGen.cmbGenTypeSelect(Sender: TObject);
var
  bPassword, bCode, bUsername: Boolean;
  iSelect, I, iRandom: Integer;
  sPasswordGen, sCode, sSelected, sGenUsername: String;

begin
  // MAKE SURE EVERYTHING IS RANDOM.
  Randomize;

  // INIT SET.
  bPassword := false;
  bCode := false;
  bUsername := false;

  // GRAB DATA FROM USER.
  iSelect := cmbGenType.ItemIndex;

  // SET.
  case iSelect of

    0:
      bPassword := True;
    1:
      bCode := True;
    2:
      bUsername := True;

  end;

  // PASSWORD GEN LOGIC.
  if (bPassword = True) then
  begin

    sPasswordGen := genPassword(16);

    rtOutputGen.Lines.Add(sPasswordGen);

    sToSave := sPasswordGen;

    bPassword := false;
    bUsername := false;
    bCode := false;

  end;

  // CODE GEN LOGIC.
  if (bCode = True) then
  begin

    for I := 1 to 6 do
    begin

      sCode := sCode + IntToStr(RandomRange(1, 9 + 1));

    end;

    sToSave := sCode;
    rtOutputGen.Lines.Add(sToSave);

    bPassword := false;
    bUsername := false;
    bCode := false;

  end;

  // LOGIC FOR USERNAME GEN.
  if (bUsername = True) then
  begin

    iRandom := RandomRange(1, 10 + 1);

    case iRandom of

      1:
        sSelected := 'Groovy';
      2:
        sSelected := 'Fantastic';
      3:
        sSelected := 'Awesome';
      4:
        sSelected := 'Silent';

      5:
        sSelected := 'Iam';

      6:
        sSelected := 'Space';
      7:
        sSelected := 'Jumpy';
      8:
        sSelected := 'Salty';
      9:
        sSelected := 'Comfortable';
      10:
        sSelected := 'Alert';

    end;

    sGenUsername := sSelected + sUsername + IntToStr(RandomRange(1, 100 + 1));

    sToSave := sGenUsername;
    rtOutputGen.Lines.Add(sToSave);

    bPassword := false;
    bUsername := false;
    bCode := false;
  end;

end;

procedure TfrmGen.FormActivate(Sender: TObject);
const
  cVersion = '2';

begin

  frmGen.Caption := 'Welcome ' + sUsername + ' to generation: v' + cVersion;

  // CREATE TEXT FILE FOR USER FOR STORING DATA.

  sPath := 'c:\tmp\' + sUsername + '.txt';

  if FileExists(sPath) = false then
  begin

    textFile := TStringlist.create;
    try
      textFile.SaveToFile(sPath);
    finally
      textFile.Free
    end;

  end;

  fileName := sPath;
  AssignFile(myFile, fileName);

end;

procedure TfrmGen.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  // FIX FOR MULTI FORM APP.
  Application.Terminate;

end;

procedure TfrmGen.FormCreate(Sender: TObject);
var
  sPath: String;

begin

  // INIT ON CREATION.
  frmGen.Position := poScreenCenter;

  RoundCornerOf(pnlMiddle);

  rtGenLoad.Clear;
  rtOutputGen.Clear;

end;

procedure TfrmGen.FormDeactivate(Sender: TObject);
begin

  // CLEAR FOR NEXT USER.
  sUsername := '';
  rtGenLoad.Clear;
  rtOutputGen.Clear;

end;

end.
