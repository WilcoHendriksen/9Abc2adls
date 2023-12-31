// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
                    Caption = 'OptionCaption';
                    Tooltip = 'The option member caption.';
                }
                field(OptionIndex; Rec.Index)
                {
                    ApplicationArea = All;
                    Caption = 'OptionIndex';
                    Tooltip = 'The option member index.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    Tooltip = 'The translated value of the option members.';
                }
            }
        }
    }
}
