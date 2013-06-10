object Form1: TForm1
  Left = 189
  Top = 167
  Width = 444
  Height = 384
  Caption = 'Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 48
    Width = 47
    Height = 13
    Caption = 'Server-IP:'
  end
  object Label2: TLabel
    Left = 32
    Top = 24
    Width = 113
    Height = 13
    Caption = 'Status: nicht verbunden'
  end
  object Label3: TLabel
    Left = 32
    Top = 80
    Width = 31
    Height = 13
    Caption = 'Name:'
    Visible = False
  end
  object Edit1: TEdit
    Left = 112
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '192.168.1.103'
  end
  object Button1: TButton
    Left = 248
    Top = 48
    Width = 113
    Height = 25
    Caption = 'Verbindung herstellen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 112
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'test'
    Visible = False
  end
  object Button2: TButton
    Left = 248
    Top = 80
    Width = 113
    Height = 25
    Caption = 'anmelden'
    TabOrder = 3
    Visible = False
    OnClick = Button2Click
  end
  object ChatMemo: TMemo
    Left = 32
    Top = 120
    Width = 225
    Height = 129
    Enabled = False
    Lines.Strings = (
      'ChatMemo')
    ScrollBars = ssVertical
    TabOrder = 4
    Visible = False
  end
  object Edit3: TEdit
    Left = 32
    Top = 256
    Width = 185
    Height = 21
    TabOrder = 5
    Visible = False
  end
  object Button3: TButton
    Left = 224
    Top = 256
    Width = 33
    Height = 25
    Caption = 'OK'
    TabOrder = 6
    Visible = False
    OnClick = Button3Click
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnRead = ClientSocket1Read
    Left = 192
    Top = 8
  end
end
