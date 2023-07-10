// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
page 82592 "ADLSE Schedule"
{
    PageType = Card;
    Caption = 'Schedule multi company export';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group("Schedule")
            {
                group("Time")
                {
                    field(TimeToRun; TimeToRun)
                    {
                        ApplicationArea = All;
                        Caption = 'Job start time';
                        Tooltip = 'At what time should the job should start';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            DateTimeDialog: Page "Date-Time Dialog";
                        begin
                            DateTimeDialog.SetDateTime(TimeToRun);
                            if DateTimeDialog.RunModal() = Action::OK then
                                TimeToRun := DateTimeDialog.GetDateTime();
                            exit;
                        end;
                    }
                }
                group(Recurring)
                {
                    field(RecurringJob; RecurringJob)
                    {
                        ApplicationArea = All;
                        Caption = 'Recurring job';
                        Tooltip = 'Is the job recurring';
                    }
                    field("MinutesBetweenRuns"; MinutesBetweenRuns)
                    {
                        ApplicationArea = All;
                        Caption = 'Minutes between runs';
                        Tooltip = 'The number of minutes between the job is finished and the next one starts.';
                    }
                }
                group(When)
                {
                    Enabled = RecurringJob;
                    Editable = RecurringJob;
                    field(RunOnMonday; RunOnMonday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on monday';
                        Tooltip = 'The job should run on monday';
                    }
                    field(RunOnTuesDay; RunOnTuesDay)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on tuesday';
                        Tooltip = 'The job should run on tuesday';
                    }
                    field(RunOnWednesday; RunOnWednesday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on wednesday';
                        Tooltip = 'The job should run on wednesday';
                    }
                    field(RunOnThursday; RunOnThursday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on thursday';
                        Tooltip = 'The job should run on thursday';
                    }
                    field(RunOnFriday; RunOnFriday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on friday';
                        Tooltip = 'The job should run on friday';
                    }
                    field(RunOnSaturday; RunOnSaturday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on saturday';
                        Tooltip = 'The job should run on saturday';
                    }
                    field(RunOnSunday; RunOnSunday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on sunday';
                        Tooltip = 'The job should run on sunday';
                    }
                }
            }
            part(Companies; "ADLSE Setup Companies")
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
            action(ScheduleMultiCompany)
            {
                ApplicationArea = All;
                Caption = 'Schedule multi company';
                Tooltip = 'Schedules a job for multiple companies';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Calendar;

                trigger OnAction()
                var
                    ADLSESchedule: Codeunit "ADLSE Schedule";
                begin
                    ADLSESchedule.ScheduleMultiExport(RecurringJob, RunOnMonday, RunOnTuesDay, RunOnWednesday, RunOnThursday, RunOnFriday, RunOnSaturday, RunOnSunday, TimeToRun, MinutesBetweenRuns);
                    Message('The one or more jobs are scheduled for the selected companies');
                end;
            }
            action(DeleteScheduleMultiCompany)
            {
                ApplicationArea = All;
                Caption = 'Deletes all scheduled jobs';
                Tooltip = 'Deletes all scheduled jobs for all companies';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Delete;

                trigger OnAction()
                var
                    ADLSESchedule: Codeunit "ADLSE Schedule";
                begin
                    ADLSESchedule.DeleteScheduleMultiExport();
                    Message('Deleted all scheduled jobs for all companies');
                end;
            }
        }
    }

    trigger OnInit()
    var
        ADLSECurrentSession: Record "ADLSE Current Session";
    begin
        // set defaults
        RecurringJob := true;
        RunOnMonday := true;
        RunOnTuesDay := true;
        RunOnWednesday := true;
        RunOnThursday := true;
        RunOnFriday := true;
        RunOnSaturday := false;
        RunOnSunday := false;
        TimeToRun := CurrentDateTime() + (60 * 1000); // in 1 minute
        MinutesBetweenRuns := 15;
    end;

    var
        RecurringJob: Boolean;
        RunOnMonday: Boolean;
        RunOnTuesDay: Boolean;
        RunOnWednesday: Boolean;
        RunOnThursday: Boolean;
        RunOnFriday: Boolean;
        RunOnSaturday: Boolean;
        RunOnSunday: Boolean;
        TimeToRun: DateTime;
        MinutesBetweenRuns: Integer;
}