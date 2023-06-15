page 82575 "ADLSE Option"
{
    PageType = List;
    SourceTable = "ADLSE Option";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group("Language codes")
            {
                Editable = true;
                field(LanguageCodes; LanguageCodes)
                {
                    ApplicationArea = All;
                    Caption = 'Language codes';
                    Tooltip = 'The language codes for which the option table will be filled. The codes need to be comma seperated and can be found in the language table.';
                    Editable = true;
                }
            }

            repeater(Control1)
            {
                Editable = false;
                field(LanguageCode; Rec.LanguageCode)
                {
                    ApplicationArea = All;
                    Caption = 'LanguageCode';
                    Tooltip = 'The LanguageCode.';
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
                field(FieldCaption; Rec.FieldCaption)
                {
                    ApplicationArea = All;
                    Caption = 'FieldCaption';
                    Tooltip = 'The caption of the field.';
                }
                field(OptionMember; Rec.OptionMember)
                {
                    ApplicationArea = All;
                    Caption = 'OptionMember';
                    Tooltip = 'The option members of the enumeration.';
                }
                field(OptionCaption; Rec.OptionCaption)
                {
                    ApplicationArea = All;
                    Caption = 'OptionCaptions';
                    Tooltip = 'The option captions of the enumeration.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RefreshEnumeration)
            {
                ApplicationArea = All;
                Caption = 'Refresh enumerations';
                Tooltip = 'Fills the ADLSE option table, which then can be used to export enumerations';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Export;

                trigger OnAction()
                var
                    ADLSEOption: Codeunit "ADLSE Option";
                begin
                    ADLSEOption.RefreshOptions(LanguageCodes);
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        LanguageCodes: Text;
}
