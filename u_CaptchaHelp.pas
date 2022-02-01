unit u_CaptchaHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, shellapi, Vcl.Imaging.pngimage;

type
  TfrmCaptchaHelp = class(TForm)
    imgBackground: TImage;
    pnlMiddle: TPanel;
    lblClose: TLabel;
    Label6: TLabel;
    Image3: TImage;
    Image4: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    pbQR: TPaintBox;
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pbQRPaint(Sender: TObject);
    procedure lblCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  // PULBIC VAR.
  frmCaptchaHelp: TfrmCaptchaHelp;
  QRCodeBitmap: TBitmap;

implementation

{$R *.dfm}

uses u_Register, u_QRCodeUtil, u_Main;

procedure TfrmCaptchaHelp.FormActivate(Sender: TObject);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin

  Label11.Caption := '5.) Enter your key:' + #9 + srOTP;

  // QR CODE LOGIC.
  // CREATE BITMAP FOR QRCODE.
  QRCodeBitmap := TBitmap.Create;

  // INIT.
  QRCode := TDelphiZXingQRCode.Create;

  try
    // CONTENT OF QR.
    QRCode.Data := 'otpauth://totp/PAT ' + sQRUsername + '?secret=' + srOTP +
      '&issuer=' + sUsername;

    QRCode.Encoding := TQRCodeEncoding(0);
    QRCode.QuietZone := StrToIntDef('Auto', 4);
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);

    // INIT OF QR BASICS.
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end
        else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
  pbQR.Repaint;
end;

procedure TfrmCaptchaHelp.FormCreate(Sender: TObject);
begin

  // INIT/
  frmCaptchaHelp.Position := poScreenCenter;

end;

procedure TfrmCaptchaHelp.Image1Click(Sender: TObject);
var
  sURL: string;
begin

  // OPEN BROWSER ON CLICK.
  sURL := 'https://apps.apple.com/us/app/google-authenticator/id388497605';
  ShellExecute(self.WindowHandle, 'open', PChar(sURL), nil, nil, SW_SHOWNORMAL);

end;

procedure TfrmCaptchaHelp.Image2Click(Sender: TObject);
var
  sURL: string;
begin

  // OPEN BROWSER ON CLICK.
  sURL := 'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_ZA&gl=US';
  ShellExecute(self.WindowHandle, 'open', PChar(sURL), nil, nil, SW_SHOWNORMAL);

end;

procedure TfrmCaptchaHelp.lblCloseClick(Sender: TObject);
begin

  // CLOSE.
  frmCaptchaHelp.Hide;

end;

procedure TfrmCaptchaHelp.pbQRPaint(Sender: TObject);
var
  Scale: Double;
begin

  // SCALE OF QR CODE - TAKEN FROM DELPHIQR EXAMPLE.

  pbQR.Canvas.Brush.Color := clWhite;
  pbQR.Canvas.FillRect(Rect(0, 0, pbQR.Width, pbQR.Height));
  if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
  begin
    if (pbQR.Width < pbQR.Height) then
    begin
      Scale := pbQR.Width / QRCodeBitmap.Width;
    end
    else
    begin
      Scale := pbQR.Height / QRCodeBitmap.Height;
    end;
    pbQR.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width),
      Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);

  end;
end;

end.
