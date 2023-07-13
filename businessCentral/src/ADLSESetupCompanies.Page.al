// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
page 82594 "ADLSE Setup Companies"
{
    Caption = 'Companies for scheduling';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "ADLSE Company";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(CompanyName; CompName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Company name';
                    Tooltip = 'Specifies the caption of the company whose data is to exported.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Enabled';
                    Tooltip = 'Specifies the state of the company. Set this checkmark to export this company, otherwise not.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Company: Record Company;
    begin
        Company.SetRange(Id, Rec.CompanyId);
        if Company.FindFirst() then
            CompName := Company.Name;
    end;

    var
        CompName: Text;
}