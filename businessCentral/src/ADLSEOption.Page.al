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
                    Tooltip = 'The language codes for which the option table will be filled. The codes need to comma seperated and can be found in the language table.';
                    Editable = true;
                }
            }

            repeater(Control1)
            {
                Editable = false;
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'SystemId';
                    Tooltip = 'The system Id of the record.';
                    Visible = false;
                }
                field(LanguageCode; Rec.LanguageCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'LanguageCode';
                    Tooltip = 'The LanguageCode.';
                }
                field(Table; Rec.Table)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Table';
                    Tooltip = 'The table in which the enum is found.';
                }
                field(Field; Rec.Field)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Field';
                    Tooltip = 'The name of the field.';
                }
                field(FieldCaption; Rec.FieldCaption)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'FieldCaption';
                    Tooltip = 'The caption of the field.';
                }
                field(OptionMember; Rec.OptionMembers)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'OptionMember';
                    Tooltip = 'The option members of the enumeration.';
                }
                field(OptionCaptions; Rec.OptionCaptions)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'OptionCaptions';
                    Tooltip = 'The option captions of the enumeration.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'SystemModifiedAt';
                    Tooltip = 'The SystemModifiedAt of the record.';
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'SystemModifiedBy';
                    Tooltip = 'The SystemModifiedBy of the record.';
                    Visible = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'SystemCreatedBy';
                    Tooltip = 'The SystemCreatedBy of the record.';
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'SystemCreatedAt';
                    Tooltip = 'The SystemCreatedAt of the record.';
                    Visible = false;
                }
                field(SystemRowVersion; Rec.SystemRowVersion)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'SystemRowVersion';
                    Tooltip = 'The SystemRowVersion of the record.';
                    Visible = false;
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
