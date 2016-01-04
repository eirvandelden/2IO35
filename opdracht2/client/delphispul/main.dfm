object Form1: TForm1
  Left = 192
  Top = 122
  Width = 818
  Height = 710
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 672
    Top = 88
    Width = 47
    Height = 13
    Caption = 'Occupant'
  end
  object Label2: TLabel
    Left = 672
    Top = 48
    Width = 56
    Height = 13
    Caption = 'Coordinates'
  end
  object Label3: TLabel
    Left = 672
    Top = 8
    Width = 63
    Height = 13
    Caption = 'Key Direction'
  end
  object DrawGrid1: TDrawGrid
    Left = 8
    Top = 8
    Width = 657
    Height = 657
    ColCount = 50
    DefaultColWidth = 12
    DefaultRowHeight = 12
    FixedCols = 0
    RowCount = 50
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = DrawGrid1DrawCell
    OnSelectCell = DrawGrid1SelectCell
  end
  object EditKey: TEdit
    Left = 672
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object EditSelectionX: TEdit
    Left = 672
    Top = 64
    Width = 57
    Height = 21
    TabOrder = 2
  end
  object EditSelectionY: TEdit
    Left = 736
    Top = 64
    Width = 57
    Height = 21
    TabOrder = 3
  end
  object EditOccupant: TEdit
    Left = 672
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object EditIP: TEdit
    Left = 672
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '127.0.0.1'
  end
  object EditPort: TEdit
    Left = 672
    Top = 208
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '1337'
  end
  object ButtonConnect: TButton
    Left = 672
    Top = 240
    Width = 121
    Height = 25
    Caption = 'Connect'
    TabOrder = 7
    OnClick = ButtonConnectClick
  end
  object PlayerClient: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    OnConnected = PlayerClientConnected
    Port = 0
    Left = 752
    Top = 408
  end
end
