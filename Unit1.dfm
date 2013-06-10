object Form1: TForm1
  Left = 391
  Top = 388
  Width = 319
  Height = 190
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
  object Label1: TLabel
    Left = 32
    Top = 80
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 32
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 184
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Allgemein'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Set Losgeld'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 184
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Set Kaution'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 32
    Top = 48
    Width = 139
    Height = 25
    Caption = 'Lese Spielbrett'
    TabOrder = 4
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Left = 16
    Top = 8
  end
  object ServerSocket1: TServerSocket
    Active = True
    Port = 1337
    ServerType = stNonBlocking
    OnAccept = ServerSocket1Accept
    OnClientRead = ServerSocket1ClientRead
    Left = 16
    Top = 104
  end
end
