unit u_Register;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, System.NetEncoding, Vcl.ComCtrls;

type
  TfrmRegister = class(TForm)
    imgBackground: TImage;
    pnlMiddle: TPanel;
    lbHave: TLabel;
    stPassword: TStaticText;
    stUsername: TStaticText;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnRegister: TBitBtn;
    StaticText1: TStaticText;
    edtConfirmPassword: TEdit;
    rtError: TRichEdit;
    lblAdmin: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lbBackClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure lblAdminClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var

  // PUBLIC VAR.
  frmRegister: TfrmRegister;
  bUsername, bPassword: Boolean;
  srOTP, srUsername, srPassword, srPasswordConfirm, fileName, data, s, Encoded,
    sCipher, sCipher2, sEncodedForCipher, sQRUsername: String;

  Base64: TBase64Encoding;
  iCipher: Integer;
  iOrd: Integer;
  myFile: TextFile;

implementation

{$R *.dfm}

uses u_Main, u_Base32Util, u_GoogleOTPUtil, u_CipherUtil, u_CaptchaHelp,
  u_Admin;
// CUSTOM FUNCTIONS:

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

procedure TfrmRegister.btnRegisterClick(Sender: TObject);
var
  bCaptical, bNumber, bSpecial, bRegistedUsername: Boolean;
  I, iPos: Integer;
  sLine, sDecodedLine, sSplit1: String;

begin

  // CLEAR SO WE DON'T HAVE OLD DATA.
  rtError.Lines.Clear;

  // INIT VARS.
  bPassword := false;
  bUsername := false;

  bCaptical := false;
  bNumber := false;
  bSpecial := false;

  srUsername := edtUsername.Text;
  srPassword := edtPassword.Text;
  srPasswordConfirm := edtConfirmPassword.Text;

  bUsername := false;
  bRegistedUsername := false;

  // READY FOR FILE USE.
  fileName := 'c:\tmp\loginData.txt';
  AssignFile(myFile, fileName);
  Reset(myFile);

  // LOGIC TO SEE IF THE USERNAME EXISTS.
  while not Eof(myFile) do
  begin
    Readln(myFile, sLine);

    sDecodedLine := TNetEncoding.Base64.Decode(sLine);

    iPos := Pos(',', sDecodedLine);
    sSplit1 := Copy(sDecodedLine, 1, iPos - 1);
    sQRUsername := srUsername;

    if (sSplit1 = srUsername) then
    begin

      bRegistedUsername := True;

    end;

  end;
  // CLOSE.
  CloseFile(myFile);

  if (bRegistedUsername = True) then
  begin

    ShowMessage('Username is taken.');
    edtUsername.SetFocus;

  end
  else
  begin


    // LOGIC FOR USERNAME AND PASSWORD REQ.

    if (srUsername.Length >= 4) AND (srUsername.Length <= 16) then

    begin
      bUsername := True;
    end
    else
    begin

      case srUsername.Length of

        0:
          ShowMessage('Please enter a username!');
        1 .. 3:
          rtError.Lines.Add('Username must be longer than 3 char.');
        16 .. MaxInt:
          rtError.Lines.Add('Username must be less than 16 char.');

      end;

    end;

    if (srPassword.Length > 0) AND (srPasswordConfirm.Length > 0) then
    begin

      if (srPassword = srPasswordConfirm) then

      begin

        for I := 1 to Length(srPassword) do
          case srPassword[I] of
            'A' .. 'Z':
              bCaptical := True;
            '0' .. '9':
              bNumber := True;
            '!', '#', '%', '&', '*', '@':
              bSpecial := True;
          end;

        if (bCaptical = True) AND (bNumber = True) AND (bSpecial = True) then
        begin

          bPassword := True;

        end;

        case bCaptical of

          false:
            rtError.Lines.Add('Password must contain 1 uppercase.');

        end;

        case bNumber of

          false:
            rtError.Lines.Add('Password must contain 1 number.');

        end;

        case bSpecial of

          false:
            rtError.Lines.Add('Password must contain 1 special char.');

        end;

      end

      else

      begin

        ShowMessage('Passwords do not match.');
        edtConfirmPassword.SetFocus;

        edtPassword.Font.Color := clRed;
        edtConfirmPassword.Font.Color := clRed;

      end;

    end
    else
    begin

      // NULL CHECK.
      ShowMessage('Please enter a password.');
      edtPassword.SetFocus;
    end;

    if (bUsername = True) AND (bPassword = True) then
    begin

      if FileExists(fileName) = false then
      begin

        ReWrite(myFile);
        Append(myFile);
        CloseFile(myFile);

      end;

      // GENERATE UNIQUE OTP SECRET FOR USER.
      srOTP := GenerateOTPSecret(16);

      // BASE64
      s := srUsername + ',' + srPasswordConfirm + ',' + srOTP;
      Base64 := TBase64Encoding.Create(10, '');
      Encoded := Base64.Encode(s);

      // PREP FOR WRITING.
      Append(myFile);
      WriteLn(myFile, Encoded);
      CloseFile(myFile);

      ShowMessage('Created Account!');
      Reset(myFile);

      // CLEAR SO WE DON'T HAVE OLD DATA.
      edtUsername.Clear;
      edtPassword.Clear;
      edtConfirmPassword.Clear;

      // BACK TO MAIN.
      frmRegister.Hide;
      frmMain.Show;

      rtError.Clear;
      rtError.Font.Color := clBlack;

      frmCaptchaHelp.Show;

    end;
  end;
end;

procedure TfrmRegister.FormCreate(Sender: TObject);
begin

  // INIT ON CREATION.
  frmRegister.Position := poScreenCenter;
  RoundCornerOf(pnlMiddle);
  edtPassword.PasswordChar := '*';
  edtConfirmPassword.PasswordChar := '*';
  rtError.Clear;
  rtError.Font.Color := clRed;

end;

procedure TfrmRegister.lbBackClick(Sender: TObject);
begin

  // GO BACK TO MAIN.
  frmRegister.Hide;
  frmMain.Show;
  rtError.Clear;
  rtError.Font.Color := clBlack;

end;

procedure TfrmRegister.lblAdminClick(Sender: TObject);
begin

  frmRegister.Hide;
  frmAdmin.Show;
  rtError.Clear;

end;

end.
