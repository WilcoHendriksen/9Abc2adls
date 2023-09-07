// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
page 82591 "BirdsEnum"
{
    PageType = List;
    SourceTable = "BirdsEnum";
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
                field(Table; Rec.SourceTable)
                {
                    ApplicationArea = All;
                    Caption = 'Table';
                    Tooltip = 'The table in which the enum is found.';
                }
                field(Field; Rec.ObjectName)
                {
                    ApplicationArea = All;
                    Caption = 'Field';
                    Tooltip = 'The name of the field.';
                }
                field(FieldCaption; Rec.EnumCaption)
                {
                    ApplicationArea = All;
                    Caption = 'OptionCaption';
                    Tooltip = 'The caption of the field.';
                }
                field(OptionIndex; Rec.EnumIndex)
                {
                    ApplicationArea = All;
                    Caption = 'OptionIndex';
                    Tooltip = 'The option members of the enumeration.';
                }
            }

            part(Translations; "BirdsEnumTranslation")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
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
                    BirdsEnum: Codeunit "BirdsEnum";
                begin
                    BirdsEnum.RefreshOptions(LanguageCodes);
                    CurrPage.Update();
                end;
            }
        }
    }
    var
        LanguageCodes: Text;
}
