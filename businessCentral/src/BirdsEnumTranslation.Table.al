table 82593 BirdsEnumTranslation
{
    Caption = 'BirdsEnumTranslation';
    fields
    {
        field(1; Language; Text[50])
        {
            DataClassification = SystemMetadata;
            Description = 'Language';
        }
        field(2; EnumType; Text[50])
        {
            DataClassification = SystemMetadata;
            Description = 'EnumType';
        }
        field(3; Table; Text[50])
        {
            DataClassification = SystemMetadata;
            Description = 'Table';
        }
        field(4; Field; Text[50])
        {
            DataClassification = SystemMetadata;
            Description = 'Field';
        }
        field(6; Index; Integer)
        {
            DataClassification = SystemMetadata;
            Description = 'Index';
        }
        field(7; Caption; Text[2048])
        {
            DataClassification = SystemMetadata;
            Description = 'Caption';
        }
        field(8; Value; Text[2048])
        {
            DataClassification = SystemMetadata;
            Description = 'Value';
        }
    }
    keys
    {
        key(PrimaryKey; Language, Table, Field, Index, Caption)
        {
        }
    }

    procedure InsertEnumTrans(Language: Text; TableName: Text; FieldName: Text; Index: Integer; OptionName: Text; OptionValue: Text)
    begin
        Rec.Init();
        Rec.Language := Language;
        Rec.EnumType := 'Option';
        Rec.Table := TableName;
        Rec.Field := FieldName;
        Rec.Index := Index;
        Rec.Caption := OptionName;
        Rec.Value := OptionValue;
        Rec.Insert();
    end;
}
