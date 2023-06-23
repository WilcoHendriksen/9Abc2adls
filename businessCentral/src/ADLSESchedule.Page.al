// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
page 82576 "ADLSE Schedule"
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
                group(When)
                {
                    Editable = true;
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
                group("time")
                {
                    field(TimeToRun; TimeToRun)
                    {
                        ApplicationArea = All;
                        Caption = 'Job start time';
                        Tooltip = 'At what time should the job should start';

                    }
                    field("MinutesBetweenRuns"; MinutesBetweenRuns)
                    {
                        ApplicationArea = All;
                        Caption = 'Minutes between runs';
                        Tooltip = 'The number of minutes between the job is finished and the next one starts.';
                    }
                }
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
                Tooltip = 'Schedules a job for mulitple companies';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Export;

                trigger OnAction()
                var
                    ADLSESchedule: Codeunit "ADLSE Schedule";
                begin
                    ADLSESchedule.ScheduleMultiExport(RunOnMonday, RunOnTuesDay, RunOnWednesday, RunOnThursday, RunOnFriday, RunOnSaturday, RunOnSunday, TimeToRun, MinutesBetweenRuns);
                    Message('The jobs are scheduled');
                end;
            }
            action(DeleteScheduleMultiCompany)
            {
                ApplicationArea = All;
                Caption = 'Deletes all scheduled jobs';
                Tooltip = 'Deletes all scheduled jobs for multiple companies';
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
                    Message('Delete scheduled jobs');
                end;
            }
        }
    }
    var
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