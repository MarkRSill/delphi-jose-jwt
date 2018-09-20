object frmDebugger: TfrmDebugger
  Left = 0
  Top = 0
  Caption = 'Debugger'
  ClientHeight = 578
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    773
    578)
  PixelsPerInch = 96
  TextHeight = 13
  object lblEncoded: TLabel
    Left = 8
    Top = 47
    Width = 68
    Height = 19
    Caption = 'Encoded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblAlgorithm: TLabel
    Left = 272
    Top = 9
    Width = 63
    Height = 16
    Alignment = taCenter
    Anchors = [akTop]
    Caption = 'Algorithm'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblDecoded: TLabel
    Left = 463
    Top = 47
    Width = 70
    Height = 19
    Caption = 'Decoded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object shpStatus: TShape
    Left = 8
    Top = 505
    Width = 757
    Height = 65
    Anchors = [akLeft, akRight, akBottom]
    Brush.Color = 16107079
  end
  object lblStatus: TLabel
    Left = 265
    Top = 523
    Width = 244
    Height = 29
    Anchors = [akBottom]
    Caption = 'Signature Verified'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblHeader: TLabel
    Left = 463
    Top = 72
    Width = 189
    Height = 16
    Caption = 'Header: Algorithm && Token Type'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblPayload: TLabel
    Left = 463
    Top = 206
    Width = 79
    Height = 16
    Caption = 'Payload: Data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblSignature: TLabel
    Left = 462
    Top = 352
    Width = 97
    Height = 16
    Caption = 'Verify Signature:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object memoHeader: TMemo
    Left = 463
    Top = 91
    Width = 302
    Height = 107
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      '{'
      '  "alg": "HS256",'
      '  "typ": "JWT"'
      '}')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = memoHeaderChange
  end
  object memoPayload: TMemo
    Left = 463
    Top = 224
    Width = 302
    Height = 123
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clFuchsia
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      '{'
      '  "sub": "1234567890",'
      '  "name": "John Doe",'
      '  "admin": true'
      '}')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = memoPayloadChange
  end
  object richEncoded: TRichEdit
    Left = 8
    Top = 72
    Width = 448
    Height = 427
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Consolas'
    Font.Style = [fsBold]
    HideSelection = False
    HideScrollBars = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    WantReturns = False
    Zoom = 100
    OnChange = richEncodedChange
  end
  object cbbDebuggerAlgo: TComboBox
    Left = 341
    Top = 8
    Width = 101
    Height = 21
    Style = csDropDownList
    Anchors = [akTop]
    ItemIndex = 0
    TabOrder = 3
    Text = 'HS256'
    OnChange = cbbDebuggerAlgoChange
    Items.Strings = (
      'HS256'
      'HS384'
      'HS512'
      'RS256'
      'RS384'
      'RS512')
  end
  object VerifySig: TFlowPanel
    Left = 459
    Top = 371
    Width = 311
    Height = 134
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 4
    OnResize = VerifySigResize
    DesignSize = (
      311
      134)
    object HSVerifySig: TPanel
      Left = 0
      Top = 0
      Width = 308
      Height = 128
      BevelOuter = bvNone
      TabOrder = 0
      object lblHMAC: TLabel
        Left = 3
        Top = 3
        Width = 297
        Height = 114
        Caption = 
          'HMACSHA256('#13#10'  base64UrlEncode(header) + "." +'#13#10'  base64UrlEncod' +
          'e(payload),'#13#10#13#10#13#10')'
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
      end
      object chkKeyBase64: TCheckBox
        Left = 22
        Top = 100
        Width = 238
        Height = 17
        ParentCustomHint = False
        Caption = 'secret base64 encoded'
        Color = clBtnFace
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = [fsBold]
        ParentColor = False
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnClick = chkKeyBase64Click
      end
      object edtKey: TEdit
        Left = 22
        Top = 64
        Width = 279
        Height = 27
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = 'secret'
        OnChange = edtKeyChange
      end
    end
    object RSVerifySig: TPanel
      Left = 0
      Top = 128
      Width = 308
      Height = 236
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        308
        236)
      object lblRSA: TLabel
        Left = 3
        Top = 3
        Width = 297
        Height = 228
        Caption = 
          'RSASHA256('#13#10'  base64UrlEncode(header) + "." +'#13#10'  base64UrlEncode' +
          '(payload),'#13#10#13#10#13#10#13#10','#13#10#13#10#13#10#13#10#13#10')'
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
      end
      object RSAPublicKey: TMemo
        Left = 21
        Top = 63
        Width = 279
        Height = 61
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WordWrap = False
        OnChange = RSAPrivateKeyChange
      end
      object RSAPrivateKey: TMemo
        Left = 21
        Top = 142
        Width = 279
        Height = 71
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = ANSI_CHARSET
        Font.Color = clTeal
        Font.Height = -16
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        WordWrap = False
        OnChange = RSAPrivateKeyChange
      end
    end
  end
end
