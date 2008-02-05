object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'REST Sample for Livedoor Weather'
  ClientHeight = 592
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 0
    Top = 77
    Width = 355
    Height = 515
    Align = alClient
    Indent = 19
    TabOrder = 0
    ExplicitTop = 74
    ExplicitHeight = 518
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 355
    Height = 77
    Align = alTop
    TabOrder = 1
    object ComboBox1: TComboBox
      Left = 8
      Top = 16
      Width = 145
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 0
    end
    object Button1: TButton
      Left = 197
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Get'
      TabOrder = 1
      OnClick = Button1Click
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 47
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 2
      Text = 'today'
      Items.Strings = (
        'today'
        'tomorrow'
        'dayaftertomorrow')
    end
  end
end
