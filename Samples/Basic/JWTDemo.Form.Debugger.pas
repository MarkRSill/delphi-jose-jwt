{******************************************************************************}
{                                                                              }
{  Delphi JOSE Library                                                         }
{  Copyright (c) 2015-2017 Paolo Rossi                                         }
{  https://github.com/paolo-rossi/delphi-jose-jwt                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}

unit JWTDemo.Form.Debugger;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  JOSE.Core.JWT,
  JOSE.Core.JWS,
  JOSE.Core.JWE,
  JOSE.Core.JWK,
  JOSE.Core.JWA,
  JOSE.Types.JSON,
  JOSE.Encoding.Base64;

type
  TfrmDebugger = class(TForm)
    lblEncoded: TLabel;
    lblAlgorithm: TLabel;
    lblDecoded: TLabel;
    lblHMAC: TLabel;
    memoHeader: TMemo;
    memoPayload: TMemo;
    richEncoded: TRichEdit;
    cbbDebuggerAlgo: TComboBox;
    edtKey: TEdit;
    chkKeyBase64: TCheckBox;
    shpStatus: TShape;
    lblStatus: TLabel;
    lblHeader: TLabel;
    lblPayload: TLabel;
    lblSignature: TLabel;
    VerifySig: TFlowPanel;
    HSVerifySig: TPanel;
    RSVerifySig: TPanel;
    lblRSA: TLabel;
    RSAPublicKey: TMemo;
    RSAPrivateKey: TMemo;
    procedure cbbDebuggerAlgoChange(Sender: TObject);
    procedure chkKeyBase64Click(Sender: TObject);
    procedure edtKeyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memoHeaderChange(Sender: TObject);
    procedure memoPayloadChange(Sender: TObject);
    procedure VerifySigResize(Sender: TObject);
    procedure richEncodedChange(Sender: TObject);
    procedure RSAPrivateKeyChange(Sender: TObject);
  private
    FJWT: TJWT;
    FAlg: TJOSEAlgorithmId;

    procedure GenerateToken;
    procedure WriteCompactHeader(const AHeader: string);
    procedure WriteCompactClaims(const AClaims: string);
    procedure WriteCompactSignature(const ASignature: string);
    procedure WriteCompactSeparator;
    procedure SetStatus(AVerified: Boolean);
    procedure SetErrorJSON;
    function VerifyToken(AKey: TJWK): Boolean;
    procedure DoVerifyToken;
    procedure WriteDefault;
  public
    { Public declarations }
  end;

var
  frmDebugger: TfrmDebugger;

implementation

uses
  System.NetEncoding;

{$R *.dfm}

procedure TfrmDebugger.cbbDebuggerAlgoChange(Sender: TObject);
begin
  case cbbDebuggerAlgo.ItemIndex of
    0: FAlg := TJOSEAlgorithmId.HS256;
    1: FAlg := TJOSEAlgorithmId.HS384;
    2: FAlg := TJOSEAlgorithmId.HS512;
    3: FAlg := TJOSEAlgorithmId.RS256;
    4: FAlg := TJOSEAlgorithmId.RS384;
    5: FAlg := TJOSEAlgorithmId.RS512;
  end;
  case cbbDebuggerAlgo.ItemIndex of
    0..2: begin
      ClientHeight := 578;
      HSVerifySig.Visible := True;
      RSVerifySig.Visible := False;
    end;
    3..5: begin
      ClientHeight := 778;
      HSVerifySig.Visible := False;
      RSVerifySig.Visible := True;
    end;
  end;
  GenerateToken;
end;

procedure TfrmDebugger.chkKeyBase64Click(Sender: TObject);
begin
  GenerateToken;
end;

procedure TfrmDebugger.DoVerifyToken;
var
  LKeyPub: TJWK;
begin
  case cbbDebuggerAlgo.ItemIndex of
    0..2: begin
      if chkKeyBase64.Checked then
        LKeyPub := TJWK.Create(TBase64.Decode(edtKey.Text))
      else
        LKeyPub := TJWK.Create(edtKey.Text);
    end;
    else LKeyPub := TJWK.Create(RSAPublicKey.Text);
  end;

  try
    SetStatus(VerifyToken(LKeyPub));
  finally
    LKeyPub.Free;
  end;
end;

procedure TfrmDebugger.edtKeyChange(Sender: TObject);
var
  LKey: TJWK;
begin
  if richEncoded.Tag <> 0 then
    Exit;

  if chkKeyBase64.Checked then
    LKey := TJWK.Create(TBase64.Decode(edtKey.Text))
  else
    LKey := TJWK.Create(edtKey.Text);

  try
    SetStatus(VerifyToken(LKey));
  finally
    LKey.Free;
  end;
end;

procedure TfrmDebugger.FormDestroy(Sender: TObject);
begin
  FJWT.Free;
end;

procedure TfrmDebugger.FormCreate(Sender: TObject);
begin
  FJWT := TJWT.Create(TJWTClaims);

  FJWT.Header.JSON.Free;
  FJWT.Header.JSON := TJSONObject(TJSONObject.ParseJSONValue(memoHeader.Lines.Text));

  FJWT.Claims.JSON.Free;
  FJWT.Claims.JSON := TJSONObject(TJSONObject.ParseJSONValue(memoPayload.Lines.Text));

  FAlg := TJOSEAlgorithmId.HS256;

  WriteDefault;
end;

procedure TfrmDebugger.GenerateToken;
var
  LSigner: TJWS;
  LKey: TJWK;
  LKeyPub: TJWK;
begin
  richEncoded.Tag := 1;
  try
    richEncoded.Lines.Clear;
    if Assigned(FJWT.Header.JSON) and Assigned(FJWT.Claims.JSON) then
    begin
      richEncoded.Color := clWindow;

      LSigner := TJWS.Create(FJWT);

      case cbbDebuggerAlgo.ItemIndex of
        0..2: begin
          if chkKeyBase64.Checked then
            LKey := TJWK.Create(TBase64.Decode(edtKey.Text))
          else
            LKey := TJWK.Create(edtKey.Text);
          LKeyPub := LKey;
        end;
        3..5: begin
          LKey := TJWK.Create(RSAPrivateKey.Text);
          LKeyPub := TJWK.Create(RSAPublicKey.Text);
        end;
      end;

      try
        LSigner.SkipKeyValidation := True;
        LSigner.Sign(LKey, FAlg);

        WriteCompactHeader(LSigner.Header);
        WriteCompactSeparator;
        WriteCompactClaims(LSigner.Payload);
        WriteCompactSeparator;
        WriteCompactSignature(LSigner.Signature);

        SetStatus(VerifyToken(LKeyPub));
      finally
        if LKeyPub <> LKey then
          LKeyPub.Free;
        LKey.Free;
        LSigner.Free;
      end;
    end
    else
    begin
      richEncoded.Color := $00CACAFF;
      SetErrorJSON;
    end;
  finally
    richEncoded.Tag := 0;
  end;
end;

procedure TfrmDebugger.memoHeaderChange(Sender: TObject);
begin
  if richEncoded.Tag <> 0 then
    Exit;
  FJWT.Header.JSON.Free;
  FJWT.Header.JSON := TJSONObject(TJSONObject.ParseJSONValue((Sender as TMemo).Lines.Text));
  GenerateToken;
end;

procedure TfrmDebugger.memoPayloadChange(Sender: TObject);
begin
  if richEncoded.Tag <> 0 then
    Exit;
  FJWT.Claims.JSON.Free;
  FJWT.Claims.JSON := TJSONObject(TJSONObject.ParseJSONValue((Sender as TMemo).Lines.Text));
  GenerateToken;
end;

procedure TfrmDebugger.richEncodedChange(Sender: TObject);
var
  token: string;
  parts: TArray<string>;
  json: TJSONValue;
begin
  if richEncoded.Tag <> 0 then
    Exit;

  richEncoded.Tag := 2;
  try
    // decode token into Header and Payload
    token := richEncoded.Text;
    parts := token.Split(['.']);

    if Length(Parts) = 3 then
    try
      richEncoded.Lines.Clear;
      WriteCompactHeader(parts[0]);
      WriteCompactSeparator;
      WriteCompactClaims(parts[1]);
      WriteCompactSeparator;
      WriteCompactSignature(parts[2]);

      memoHeader.Text := TNetEncoding.Base64.Decode(parts[0]);
      memoPayload.Text := TNetEncoding.Base64.Decode(parts[1]);
    except
    end;

    DoVerifyToken;
  finally
    richEncoded.Tag := 0;
  end;
end;

procedure TfrmDebugger.RSAPrivateKeyChange(Sender: TObject);
begin
  if richEncoded.Tag <> 0 then
    Exit;
  if (RSAPublicKey.Text > '') and (RSAPrivateKey.Text > '') then
    GenerateToken
  else if RSAPublicKey.Text > '' then
    DoVerifyToken;
end;

procedure TfrmDebugger.SetErrorJSON;
begin
  shpStatus.Brush.Color := clRed;
  lblStatus.Caption := 'JSON Data Error';
end;

procedure TfrmDebugger.SetStatus(AVerified: Boolean);
begin
  if AVerified then
  begin
    shpStatus.Brush.Color := $00F5C647;
    lblStatus.Caption := 'Signature Verified';
  end
  else
  begin
    shpStatus.Brush.Color := clRed;
    lblStatus.Caption := 'Invalid Signature';
  end;
end;

procedure TfrmDebugger.VerifySigResize(Sender: TObject);
begin
  RSVerifySig.Width := VerifySig.Width - 2;
end;

function TfrmDebugger.VerifyToken(AKey: TJWK): Boolean;
var
  LToken: TJWT;
  LSigner: TJWS;
  LCompactToken: string;
begin
  Result := False;
  LCompactToken := StringReplace(richEncoded.Lines.Text, sLineBreak, '', [rfReplaceAll]);

  LToken := TJWT.Create;
  try
    LSigner := TJWS.Create(LToken);
    LSigner.SkipKeyValidation := True;
    try
      LSigner.SetKey(AKey);
      LSigner.CompactToken := LCompactToken;
      LSigner.VerifySignature;
    finally
      LSigner.Free;
    end;

    if LToken.Verified then
      Result := True;
  finally
    LToken.Free;
  end;
end;

procedure TfrmDebugger.WriteCompactClaims(const AClaims: string);
begin
  richEncoded.SelAttributes.Color := clFuchsia;
  richEncoded.SelText := AClaims;
end;

procedure TfrmDebugger.WriteCompactHeader(const AHeader: string);
begin
  richEncoded.SelAttributes.Color := clRed;
  richEncoded.SelText := AHeader;
end;

procedure TfrmDebugger.WriteCompactSeparator;
begin
  richEncoded.SelAttributes.Color := clBlack;
  richEncoded.SelText := '.';
end;

procedure TfrmDebugger.WriteCompactSignature(const ASignature: string);
begin
  richEncoded.SelAttributes.Color := clTeal;
  richEncoded.SelText := ASignature;
end;

procedure TfrmDebugger.WriteDefault;
begin
  richEncoded.Tag := 1;
  try
    richEncoded.Lines.Clear;
    WriteCompactHeader('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    WriteCompactSeparator;
    WriteCompactClaims('eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9');
    WriteCompactSeparator;
    WriteCompactSignature('TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ');

    SetStatus(True);
  finally
    richEncoded.Tag := 0;
  end;
end;

end.
