unit u_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.StdCtrls, Vcl.Buttons, System.NetEncoding, AnsiStrings;

type
  TfrmMain = class(TForm)
    imgBackground: TImage;
    pnlMiddle: TPanel;
    stUsername: TStaticText;
    edtUsername: TEdit;
    edtPassword: TEdit;
    lblSignup: TLabel;
    btnLogin: TBitBtn;
    tOTP: TTimer;
    procedure btnLoginClick(Sender: TObject);
    procedure lblSignupClick(Sender: TObject);
    procedure tOTPTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  // INIT GLOBAL.

  frmMain: TfrmMain;
  iOTP: Integer;
  sToken, sUserOTP, sPath, sSplit1, sUsername: String;

implementation

{$R *.dfm}

uses u_Base32Util, u_GoogleOTPUtil, u_Captcha, u_Register, u_Gen;

// CUSTOM FUNCTIONS:

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

// END CUSTOM FUNCTIONS:

procedure TfrmMain.btnLoginClick(Sender: TObject);
var
  i, iPos: Integer;
  bFound, bUsername, bPassword: Boolean;

  sLine, sEmail, sPassword, sDecodedLine, sEncoded, sSplit2, sSplit3, sSplit4,
    sFinalString: String;

begin

  // GRAB FROM USER.
  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;

  // INIT.
  bFound := false;

  if (bCaptchaPass = True) then
  begin

    // SETUP FOR FILE CONTORL.
    fileName := 'c:\tmp\loginData.txt';
    AssignFile(myFile, fileName);
    Reset(myFile);

    // LOGIC TO READ EVERYTHING IN DATA FILE.
    while not Eof(myFile) do
    begin
      Readln(myFile, sLine);

      sDecodedLine := TNetEncoding.Base64.Decode(sLine);

      iPos := Pos(',', sDecodedLine);
      sSplit1 := Copy(sDecodedLine, 1, iPos - 1);
      sSplit2 := Copy(sDecodedLine, iPos + 1);
      sSplit3 := CutOff(sSplit2, 1);

      // VERIFICATION.
      if (sUsername = sSplit1) AND (sPassword = sSplit3) then
      begin

        bFound := True;
        sFinalString := sDecodedLine;

      end;

    end;

    // CLOSE.
    CloseFile(myFile);

    // 2FA LOGIC IN LOGIN.
    if (bFound = True) then
    begin

      iPos := Pos(',', ReverseString(sFinalString));
      sSplit1 := Copy(ReverseString(sFinalString), 1, iPos - 1);
      sSplit2 := ReverseString(sSplit1);

      sToken := sSplit2;

      sUserOTP := InputBox('2FA:', 'Code:', '');

      if (sUserOTP = NullAsStringValue) then
      begin

        sUserOTP := '1';

      end;

      while (iOTP <> StrToInt(sUserOTP)) do
      begin

        ShowMessage('Incorrect OTP');
        Break;

      end;

      if iOTP = StrToInt(sUserOTP) then
      begin

        frmMain.Hide;
        frmGen.Show;

      end;

    end
    else
    begin
      ShowMessage('Username or password incorrect.');
    end;

  end

  else
  begin

    // CAPTCHA FORM.
    frmMain.Hide;
    frmCaptcha.Show;
  end;

end;

procedure TfrmMain.FormActivate(Sender: TObject);
var
  dataFile: THandle;
  textFile: TStringlist;
begin
  // INIT ON CREATE.

  // HIDE OUR PASSWORDS.
  edtPassword.PasswordChar := '*';

  // LOGIC FOR CREATING ALL FILES AND DIR's NEEDED, ONLY WORKING METHOD?
  if NOT(DirectoryExists('c:\tmp\')) then
  begin

    CreateDir('c:\tmp\');

  end;

  if FileExists('c:\tmp\loginData.txt') = false then
  begin

    textFile := TStringlist.create;
    try
      textFile.SaveToFile('c:\tmp\loginData.txt');
    finally
      textFile.Free
    end;
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin



  frmMain.Position := poScreenCenter;
  RoundCornerOf(pnlMiddle);

end;

procedure TfrmMain.lblSignupClick(Sender: TObject);
begin

  // PROMPT REGISTER.
  frmMain.Hide;
  frmRegister.Show;

end;

procedure TfrmMain.tOTPTimer(Sender: TObject);
begin

  // WORKOUT OTP EVERY 1 SECOND.
  iOTP := CalculateOTP(sToken);

end;

end.
