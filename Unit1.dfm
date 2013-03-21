object Form1: TForm1
  Left = 391
  Top = 388
  Width = 305
  Height = 168
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 56
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 184
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Allgemein'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Set Losgeld'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 184
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Set Kaution'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 56
    Top = 64
    Width = 115
    Height = 25
    Caption = 'Lese Spielbrett'
    TabOrder = 4
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Left = 16
    Top = 24
  end
end
