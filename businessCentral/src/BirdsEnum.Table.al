table 82591 BirdsEnum
{
    Caption = 'BirdsEnum';
    fields
    {
        field(1; EnumType; Text[50])
        {
            DataClassification = SystemMetadata;
            Description = 'EnumType';
        }
        field(2; SourceTable; Text[100])
        {
            DataClassification = SystemMetadata;
            Description = 'SourceTable';
        }
        field(3; ObjectName; Text[100])
        {
            DataClassification = SystemMetadata;
            Description = 'ObjectName';
        }
        field(4; EnumIndex; Integer)
        {
            DataClassification = SystemMetadata;
            Description = 'EnumIndex';
        }
        field(5; EnumCaption; Text[100])
        {
            DataClassification = SystemMetadata;
            Description = 'EnumCaption';
        }
    }
    keys
    {
        key(PrimaryKey; SourceTable, ObjectName, EnumIndex, EnumCaption)
        {
        }
    }

    procedure InsertEnum(TableName: Text; FieldName: Text; Index: Integer; OptionName: Text)
    begin
        Rec.Init();
        Rec.EnumType := 'Option';
        Rec.SourceTable := TableName;
        Rec.ObjectName := FieldName;
        Rec.EnumIndex := Index;
        Rec.EnumCaption := OptionName;
        Rec.Insert();
    end;
}
