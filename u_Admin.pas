unit u_Admin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.NetEncoding, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TfrmAdmin = class(TForm)
    imgBackground: TImage;
    pnlMiddle: TPanel;
    lblBack: TLabel;
    stPassword: TStaticText;
    stUsername: TStaticText;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnLogin: TBitBtn;
    rtOut: TRichEdit;
    btnLoginData: TButton;
    btnRaw: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure lblBackClick(Sender: TObject);
    procedure btnLoginDataClick(Sender: TObject);
    procedure btnRawClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;
  bAdminAccount: Boolean;
  myAdminFile: TextFile;
  fileAdminName: String;

implementation

{$R *.dfm}

uses u_Main, u_Register;

// CUSTOM FUNCTIONS.
function CutOff(const s: string; n: Integer): string;
var
  i, k: Integer;
begin
  k := 0;
  for i := 1 to n do
  begin
    k := Pos(',', s, k + 1);
    if k = 1 then
      Exit;
  end;
  Result := Copy(s, 1, k - 1);
end;

// END CUSTOM FUNCTIONS.

procedure TfrmAdmin.btnLoginClick(Sender: TObject);
var
  sLine, sDecodedLine, sSplit1, sSplit2: String;
  iPos, iLines: Integer;
  bFound: Boolean;

begin

  // INIT.
  iLines := 0;
  bFound := false;

  fileAdminName := 'c:\tmp\adminData.txt';
  AssignFile(myAdminFile, fileAdminName);
  Reset(myAdminFile);

  while not Eof(myAdminFile) do
  begin
    Readln(myAdminFile, sLine);

    sDecodedLine := TNetEncoding.Base64.Decode(sLine);

    iPos := Pos(',', sDecodedLine);
    sSplit1 := Copy(sDecodedLine, 1, iPos - 1);
    sSplit2 := Copy(sDecodedLine, iPos + 1);

    if (sSplit1 = edtUsername.Text) AND (sSplit2 = edtPassword.Text) then
    begin

      bFound := true;

    end;

  end;

  CloseFile(myAdminFile);

  if bFound = true then
  begin

    ShowMessage('Found account!');
    btnLoginData.Enabled := true;
    btnRaw.Enabled := true;

    fileName := 'c:\tmp\loginData.txt';
    AssignFile(myFile, fileName);
    Reset(myFile);

    while not Eof(myFile) do
    begin
      Readln(myFile, sLine);
      inc(iLines);

      sDecodedLine := TNetEncoding.Base64.Decode(sLine);

      iPos := Pos(',', sDecodedLine);
      sSplit1 := Copy(sDecodedLine, 1, iPos - 1);

      rtOut.Lines.Add(sSplit1);
    end;

    rtOut.Lines.Add('Total users registerd: ' + IntToStr(iLines));

    CloseFile(myFile);

  end
  else
  begin

    ShowMessage('No admin account with these details');

  end;

end;

procedure TfrmAdmin.btnLoginDataClick(Sender: TObject);
begin

  // RESET LOGIC.

  DeleteFile('c:\tmp\loginData.txt');
  ShowMessage('Removed data file.');

end;

procedure TfrmAdmin.btnRawClick(Sender: TObject);
var
  sLine, sDecodedLine, sSplit1, sSplit2, sSplit3: String;
  iPos: Integer;

begin

  // RESET LOGIC.
  // SETUP FOR FILE CONTORL.
  fileName := 'c:\tmp\loginData.txt';
  AssignFile(myFile, fileName);
  Reset(myFile);

  rtOut.Clear;

  // LOGIC TO READ EVERYTHING IN DATA FILE.
  while not Eof(myFile) do
  begin
    Readln(myFile, sLine);

    sDecodedLine := TNetEncoding.Base64.Decode(sLine);

    iPos := Pos(',', sDecodedLine);
    sSplit1 := Copy(sDecodedLine, 1, iPos - 1);
    sSplit2 := Copy(sDecodedLine, iPos + 1);
    sSplit3 := CutOff(sSplit2, 1);

    rtOut.Lines.Add('U: ' + sSplit1);
    rtOut.Lines.Add('P: ' + sSplit2);
    rtOut.Lines.Add('O: ' + sSplit3);
    rtOut.Lines.Add('--------------------------');

  end;

  Reset(myFile);
  CloseFile(myFile);

end;

procedure TfrmAdmin.FormActivate(Sender: TObject);
begin

  btnLoginData.Enabled := false;
  btnRaw.Enabled := false;

end;

procedure TfrmAdmin.FormCreate(Sender: TObject);
var
  dataFile: THandle;
  TextFile: TStringlist;
  s1, s2, s, Encoded: String;
  Base64: TBase64Encoding;

begin

  // INIT ON CREATE.
  frmAdmin.Position := poScreenCenter;
  rtOut.Clear;
  edtUsername.Clear;
  edtPassword.Clear;
  edtPassword.PasswordChar := '*';

  // SET ALLOWING ONLY FOR 1 ACCOUNT.
  bAdminAccount := false;

  // LOGIC FOR ADMIN CHECKING. ONLY 1 ACCOUNT ALLOWED.

  if FileExists('c:\tmp\adminData.txt') = false then
  begin

    TextFile := TStringlist.create;
    try
      TextFile.SaveToFile('c:\tmp\adminData.txt');
    finally
      TextFile.Free
    end;
  end
  else
  begin

    bAdminAccount := true;

  end;

  if (bAdminAccount = false) then
  begin



    // LOGIC TO SAVE DETAILS.

    s1 := InputBox('Admin account setup:', 'Username', '');

    while (s1 = NullAsStringValue) = true do

    begin

      s1 := InputBox('Admin account setup:', 'Username', '');

    end;

    s2 := InputBox('Admin account setup:', 'Password', '');

    while (s1 = NullAsStringValue) = true do

    begin

      s2 := InputBox('Admin account setup:', 'Password', '');

    end;

    s := s1 + ',' + s2;

    Base64 := TBase64Encoding.create(10, '');
    Encoded := Base64.Encode(s);

    // PREP FOR WRITING.

    // READY FOR FILE USE.
    fileAdminName := 'c:\tmp\adminData.txt';
    AssignFile(myAdminFile, fileAdminName);

    Append(myAdminFile);
    WriteLn(myAdminFile, Encoded);
    CloseFile(myAdminFile);

    ShowMessage('Created Account!');
    Reset(myAdminFile);

  end;

end;

procedure TfrmAdmin.lblBackClick(Sender: TObject);
begin

  // CLEAR.

  edtUsername.Clear;
  edtPassword.Clear;
  rtOut.Clear;

  // GO BACK.
  frmAdmin.Hide;
  frmMain.Show;

end;

end.
