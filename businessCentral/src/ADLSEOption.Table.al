table 82591 "ADLSE Option"
{
    Caption = 'ADLSE Option';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "LanguageCode"; Text[100])
        {
            Caption = 'LanguageCode';
            DataClassification = ToBeClassified;
        }
        field(2; "Table"; Text[100])
        {
            Caption = 'Table';
            DataClassification = ToBeClassified;
        }
        field(3; "Field"; Text[100])
        {
            Caption = 'Field';
            DataClassification = ToBeClassified;
        }
        field(4; "FieldCaption"; Text[100])
        {
            Caption = 'FieldCaption';
            DataClassification = ToBeClassified;
        }
        field(5; "OptionMember"; Text[100])
        {
            Caption = 'OptionMember';
            DataClassification = ToBeClassified;
        }
        field(6; "OptionCaption"; Text[100])
        {
            Caption = 'OptionCaption';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "LanguageCode", "Table", "Field", "OptionMember")
        {
            Clustered = true;
        }
    }
}
