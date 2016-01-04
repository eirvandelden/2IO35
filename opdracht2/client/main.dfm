object Form1: TForm1
  Left = 262
  Top = 187
  Width = 553
  Height = 411
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblIP: TLabel
    Left = 16
    Top = 8
    Width = 13
    Height = 13
    Caption = 'IP:'
  end
  object lblClient: TLabel
    Left = 8
    Top = 32
    Width = 22
    Height = 13
    Caption = 'Port:'
  end
  object lblCommand: TLabel
    Left = 168
    Top = 8
    Width = 50
    Height = 13
    Caption = 'Command:'
  end
  object ebIP: TEdit
    Left = 32
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object ebPort: TEdit
    Left = 32
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '1337'
  end
  object btConnect: TButton
    Left = 8
    Top = 56
    Width = 145
    Height = 25
    Caption = 'Connect'
    TabOrder = 2
    OnClick = btConnectClick
  end
  object btDisconnect: TButton
    Left = 8
    Top = 88
    Width = 145
    Height = 25
    Caption = 'Disconnect'
    Enabled = False
    TabOrder = 3
    OnClick = btDisconnectClick
  end
  object ebCommand: TEdit
    Left = 224
    Top = 8
    Width = 249
    Height = 21
    TabOrder = 4
    Text = 'ebCommand'
  end
  object messages: TMemo
    Left = 224
    Top = 32
    Width = 281
    Height = 313
    Enabled = False
    Lines.Strings = (
      'messages')
    TabOrder = 5
  end
  object btSend: TButton
    Left = 472
    Top = 8
    Width = 33
    Height = 17
    Caption = 'Send'
    TabOrder = 6
    OnClick = btSendClick
  end
  object TCPClient: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnDisconnected = TCPClientDisconnected
    OnConnected = TCPClientConnected
    Port = 0
    Left = 104
    Top = 152
  end
end
