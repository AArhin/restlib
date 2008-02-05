object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'REST Sample for himatch'
  ClientHeight = 452
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 113
    Align = alTop
    TabOrder = 0
    object Label3: TLabel
      Left = 24
      Top = 79
      Width = 20
      Height = 13
      Caption = 'time'
    end
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 36
      Height = 13
      Caption = 'latitude'
    end
    object Label2: TLabel
      Left = 24
      Top = 52
      Width = 44
      Height = 13
      Caption = 'longitude'
    end
    object Edit1: TEdit
      Left = 92
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '35.658632'
    end
    object Edit2: TEdit
      Left = 92
      Top = 49
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '139.745411'
    end
    object ComboBox1: TComboBox
      Left = 92
      Top = 76
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 2
      Text = 'now'
      Items.Strings = (
        'now'
        'today'
        'tomorrow'
        'weekend'
        '2007_summer'
        '2007_xmas'
        '2007_newyear'
        '2008_gw')
    end
    object Button1: TButton
      Left = 270
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Get'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 113
    Width = 428
    Height = 32
    Align = alTop
    TabOrder = 1
    DesignSize = (
      428
      32)
    object lblCount: TLabel
      Left = 13
      Top = 10
      Width = 3
      Height = 13
    end
    object UpDown1: TUpDown
      Left = 369
      Top = 0
      Width = 57
      Height = 32
      Anchors = [akLeft, akTop, akBottom]
      Orientation = udHorizontal
      TabOrder = 0
      OnClick = UpDown1Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 145
    Width = 428
    Height = 307
    Align = alClient
    TabOrder = 2
    object Label4: TLabel
      Left = 24
      Top = 32
      Width = 33
      Height = 13
      Caption = 'UserID'
    end
    object Label5: TLabel
      Left = 25
      Top = 59
      Width = 49
      Height = 13
      Caption = 'UserName'
    end
    object Label6: TLabel
      Left = 25
      Top = 86
      Width = 41
      Height = 13
      Caption = 'Distance'
    end
    object Label7: TLabel
      Left = 25
      Top = 113
      Width = 50
      Height = 13
      Caption = 'AreaName'
    end
    object Label8: TLabel
      Left = 25
      Top = 140
      Width = 39
      Height = 13
      Caption = 'Latitude'
    end
    object Label9: TLabel
      Left = 25
      Top = 167
      Width = 47
      Height = 13
      Caption = 'Longitude'
    end
    object Label10: TLabel
      Left = 24
      Top = 194
      Width = 43
      Height = 13
      Caption = 'PostTime'
    end
    object Label11: TLabel
      Left = 24
      Top = 223
      Width = 45
      Height = 13
      Caption = 'HimaTime'
    end
    object Label12: TLabel
      Left = 24
      Top = 248
      Width = 74
      Height = 13
      Caption = 'CommentCount'
    end
    object Label13: TLabel
      Left = 25
      Top = 276
      Width = 13
      Height = 13
      Caption = 'Url'
    end
    object edtUserId: TEdit
      Left = 112
      Top = 29
      Width = 161
      Height = 21
      TabOrder = 0
    end
    object edtUserName: TEdit
      Left = 112
      Top = 56
      Width = 161
      Height = 21
      TabOrder = 1
    end
    object edtDistance: TEdit
      Left = 112
      Top = 83
      Width = 161
      Height = 21
      TabOrder = 2
    end
    object edtAreaName: TEdit
      Left = 112
      Top = 110
      Width = 161
      Height = 21
      TabOrder = 3
    end
    object edtLat: TEdit
      Left = 112
      Top = 137
      Width = 293
      Height = 21
      TabOrder = 4
    end
    object edtLon: TEdit
      Left = 112
      Top = 164
      Width = 293
      Height = 21
      TabOrder = 5
    end
    object edtPostTime: TEdit
      Left = 112
      Top = 191
      Width = 293
      Height = 21
      TabOrder = 6
    end
    object edtHimaTime: TEdit
      Left = 112
      Top = 218
      Width = 293
      Height = 21
      TabOrder = 7
    end
    object edtCommentCount: TEdit
      Left = 112
      Top = 245
      Width = 293
      Height = 21
      TabOrder = 8
    end
    object edtUrl: TEdit
      Left = 112
      Top = 272
      Width = 233
      Height = 21
      TabOrder = 9
    end
    object Button2: TButton
      Left = 353
      Top = 272
      Width = 60
      Height = 21
      Caption = 'open'
      TabOrder = 10
      OnClick = Button2Click
    end
  end
  object Panel4: TPanel
    Left = 279
    Top = 151
    Width = 141
    Height = 125
    TabOrder = 3
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 139
      Height = 123
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 20
      ExplicitTop = 8
      ExplicitWidth = 300
      ExplicitHeight = 150
      ControlData = {
        4C0000005E0E0000B60C00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
