unit u_Captcha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Math, Vcl.Imaging.pngimage;

type
  TfrmCaptcha = class(TForm)
    imgBackground: TImage;
    btnVerify: TBitBtn;
    imgCaptcha: TImage;
    lblHeading: TStaticText;
    btnExit: TBitBtn;
    procedure btnExitClick(Sender: TObject);
    procedure btnVerifyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  // GLOBAL VAR.
  frmCaptcha: TfrmCaptcha;
  sCaptcha1, sCaptcha2, sCaptcha3, sCaptcha4, sCaptcha5, sCaptcha6, sCaptcha7,
    sCaptcha8, sCaptcha9, sCaptcha10, sCaptcha11, sCaptcha12, sCaptcha13,
    sCaptcha14, sCaptcha15, sCaptcha16, sCaptcha17, sCaptcha18, sCaptcha19,
    sCaptcha20, sCaptcha21, sCaptcha22, sCaptcha23, sCaptcha24, sCaptcha25,
    sCaptcha26, sCaptcha27, sCaptcha28, sCaptcha29, sCaptcha30, SelectedCaptcha,
    sCurrentFile, sFinal: String;

  bCaptchaPass: Boolean;
  iCaptchaNum: Integer;

implementation

{$R *.dfm}

uses u_Main;

// CUSTOM FUNCTION.
function genCaptcha(const source: String): String;
begin

  // DEFINE OUR CAPTCHA VALUES.
  sCaptcha1 := 'LUEPPJ';
  sCaptcha2 := 'HJZTPZ';
  sCaptcha3 := 'EUVOJZ';
  sCaptcha4 := 'FJZIFW';
  sCaptcha5 := 'CFAHIT';
  sCaptcha6 := 'FALOYU';
  sCaptcha7 := 'OWETSS';
  sCaptcha8 := 'LVJELI';
  sCaptcha9 := 'YYHJCL';
  sCaptcha10 := 'CCSPUF';
  sCaptcha11 := 'ABOPMO';
  sCaptcha12 := 'ADNVVA';
  sCaptcha13 := 'DIDSIV';
  sCaptcha14 := 'EHYEXH';
  sCaptcha15 := 'FOOEYI';
  sCaptcha16 := 'HAITAP';
  sCaptcha17 := 'HMLPCI';
  sCaptcha18 := 'HPIJZS';
  sCaptcha19 := 'IXLODS';
  sCaptcha20 := 'JSJDTE';
  sCaptcha21 := 'MUTSOT';
  sCaptcha22 := 'MXVXUX';
  sCaptcha23 := 'TXLIWA';
  sCaptcha24 := 'TZLONJ';
  sCaptcha25 := 'UEPNAE';
  sCaptcha26 := 'VZILJM';
  sCaptcha27 := 'WISVPC';
  sCaptcha28 := 'WOLJLM';
  sCaptcha29 := 'YIUULA';
  sCaptcha30 := 'ZACVAA';

  iCaptchaNum := RandomRange(1, 30 + 1);

  // ASSIGN.
  case iCaptchaNum of

    1:
      sFinal := sCaptcha1;
    2:
      sFinal := sCaptcha2;
    3:
      sFinal := sCaptcha3;
    4:
      sFinal := sCaptcha4;
    5:
      sFinal := sCaptcha5;
    6:
      sFinal := sCaptcha6;
    7:
      sFinal := sCaptcha7;
    8:
      sFinal := sCaptcha8;
    9:
      sFinal := sCaptcha9;
    10:
      sFinal := sCaptcha10;
    11:
      sFinal := sCaptcha11;
    12:
      sFinal := sCaptcha12;
    13:
      sFinal := sCaptcha13;
    14:
      sFinal := sCaptcha14;
    15:
      sFinal := sCaptcha15;
    16:
      sFinal := sCaptcha16;
    17:
      sFinal := sCaptcha17;
    18:
      sFinal := sCaptcha18;
    19:
      sFinal := sCaptcha19;
    20:
      sFinal := sCaptcha20;
    21:
      sFinal := sCaptcha21;
    22:
      sFinal := sCaptcha22;
    23:
      sFinal := sCaptcha23;
    24:
      sFinal := sCaptcha24;
    25:
      sFinal := sCaptcha25;
    26:
      sFinal := sCaptcha26;
    27:
      sFinal := sCaptcha27;
    28:
      sFinal := sCaptcha28;
    29:
      sFinal := sCaptcha29;
    30:
      sFinal := sCaptcha30;
  end;

end;

// END CUSTOM FUNCTION.

procedure TfrmCaptcha.btnExitClick(Sender: TObject);
begin

  // CLOSE.
  frmCaptcha.Hide;
  frmMain.Show;

end;

procedure TfrmCaptcha.btnVerifyClick(Sender: TObject);
var
  sUser: String;

begin

  imgCaptcha.Stretch := true;

  // GEN CAPTCHA.
  genCaptcha(sFinal);

  // HAVE TO DO THIS ELSE DELPHI THROWS A ERROR.
  sCurrentFile := IntToStr(iCaptchaNum) + '.png';

  imgCaptcha.Picture.LoadFromFile(sCurrentFile);

  sUser := InputBox('Enter Captcha:', '->', '');

  // NULL CHECK.
  if sUser = NullAsStringValue then
  begin

    ShowMessage('Please enter a value!');

  end
  else
  begin

    // ERROR + REGEN.
    while sUser <> sFinal do
    begin

      ShowMessage('Failed, please try again.');
      iCaptchaNum := RandomRange(1, 30 + 1);
      genCaptcha(sFinal);
      imgCaptcha.Stretch := true;

      // HAVE TO DO THIS ELSE DELPHI THROWS A ERROR.
      sCurrentFile := IntToStr(iCaptchaNum) + '.png';

      imgCaptcha.Picture.LoadFromFile(sCurrentFile);

      sUser := InputBox('Enter Captcha:', '->', '');

    end;

    // ACCEPT.
    if (sUser = sFinal) then
    begin

      bCaptchaPass := true;

      frmCaptcha.Hide;
      frmMain.Show;

    end;
  end;

end;

procedure TfrmCaptcha.FormCreate(Sender: TObject);
begin

  // INIT ON CREATION.
  frmCaptcha.Position := poScreenCenter;

end;

end.
