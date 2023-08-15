// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
page 82595 "ADLSE Run2"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ADLSE Run";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'Execution logs for exports to Azure Data Lake Storage';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field(TableCaption; NameOfTable)
                {
                    ApplicationArea = All;
                    Caption = 'Table';
                    Tooltip = 'Specifies the caption of the table whose data was exported.';
                }

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Companyname';
                }

                field(State; Rec.State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the state of the execution of export.';
                }

                field(Started; Rec.Started)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the export was started.';
                }

                field(Ended; Rec.Ended)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the export was started.';
                }

                field(Error; Rec.Error)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error if the execution had any.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Clear)
            {
                ApplicationArea = All;
                Caption = 'Clear execution log';
                Tooltip = 'Removes the history of the export executions. This should be done periodically to free up storage space.';
                Image = ClearLog;
                Enabled = LogsFound;

                trigger OnAction()
                var
                    ADLSERun: Record "ADLSE Run";
                begin
                    LogsFound := false;
                    ADLSERun.DeleteOldRuns(Rec."Table ID");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Rec.SetCurrentKey(Started);
        Rec.SetAscending(Started, false); // the last log at the top
    end;

    trigger OnAfterGetRecord()
    var
        ADLSEUtil: Codeunit "ADLSE Util";
    begin
        NameOfTable := ADLSEUtil.GetTableCaption(Rec."Table ID");
        LogsFound := true;
    end;

    var
        NameOfTable: Text;
        LogsFound: Boolean;
}