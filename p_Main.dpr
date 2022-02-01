program p_Main;

uses
  Vcl.Forms,
  u_Main in 'u_Main.pas' {frmMain},
  u_Base32Util in 'u_Base32Util.pas',
  u_GoogleOTPUtil in 'u_GoogleOTPUtil.pas',
  u_Captcha in 'u_Captcha.pas' {frmCaptcha},
  u_Register in 'u_Register.pas' {frmRegister},
  u_CaptchaHelp in 'u_CaptchaHelp.pas' {frmCaptchaHelp},
  u_Gen in 'u_Gen.pas' {frmGen},
  u_QRCodeUtil in 'u_QRCodeUtil.pas',
  u_Admin in 'u_Admin.pas' {frmAdmin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmCaptcha, frmCaptcha);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmCaptchaHelp, frmCaptchaHelp);
  Application.CreateForm(TfrmGen, frmGen);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.Run;
end.
