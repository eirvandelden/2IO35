object Form1: TForm1
  Left = 255
  Top = 249
  Width = 514
  Height = 478
  Caption = 'Form1'
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
    Left = 368
    Top = 80
    Width = 89
    Height = 13
    Caption = 'Custom Broadcast:'
  end
  object btStart: TButton
    Left = 368
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btStartClick
  end
  object btStop: TButton
    Left = 368
    Top = 40
    Width = 121
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = btStopClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 353
    Height = 425
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object editBroadcast: TEdit
    Left = 368
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object btnBroadcast: TButton
    Left = 368
    Top = 120
    Width = 121
    Height = 25
    Caption = 'Send'
    TabOrder = 4
    OnClick = btnBroadcastClick
  end
  object TCPServer: TIdTCPServer
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 1337
      end>
    CommandHandlers = <
      item
        CmdDelimiter = ' '
        Command = 'dion'
        Disconnect = False
        Name = 'EasterEgg'
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        ReplyNormal.Text.Strings = (
          'dion pwnt de sjit!')
        Tag = 0
      end>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = TCPServerConnect
    OnDisconnect = TCPServerDisconnect
    OnNoCommandHandler = TCPServerNoCommandHandler
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 464
    Top = 408
  end
end
