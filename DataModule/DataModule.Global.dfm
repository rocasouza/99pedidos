object DmGlobal: TDmGlobal
  OnCreate = DataModuleCreate
  Height = 480
  Width = 349
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    AfterConnect = ConnAfterConnect
    BeforeConnect = ConnBeforeConnect
    Left = 56
    Top = 32
  end
end
