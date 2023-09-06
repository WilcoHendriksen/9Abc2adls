page 82593 "BirdsEnumTranslation"
{
    Caption = 'Translations';
    SourceTable = "BirdsEnumTranslation";
    LinksAllowed = false;
    PageType = ListPart;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field(Language; Rec.Language)
                {
                    ApplicationArea = All;
                    Caption = 'Language';
                    Tooltip = 'The Language';
                }
                field(Table; Rec.Table)
                {
                    ApplicationArea = All;
                    Caption = 'Table';
                    Tooltip = 'The table in which the enum is found.';
                }
                field(Field; Rec.Field)
                {
                    ApplicationArea = All;
                    Caption = 'Field';
                    Tooltip = 'The name of the field.';
                }
                field(FieldCaption; Rec.Caption)
                {
                    ApplicationArea = All;
                    Caption = 'FieldCaption';
                    Tooltip = 'The caption of the field.';
                }
                field(OptionIndex; Rec.Index)
                {
                    ApplicationArea = All;
                    Caption = 'OptionMember';
                    Tooltip = 'The option members of the enumeration.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Tooltip = 'The index of the option members of the enumeration.';
                }
            }
        }
    }
}
