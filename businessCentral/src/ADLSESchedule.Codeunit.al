// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 82592 "ADLSE Schedule"
{
    var
        JobCategoryCodeTxt: Label 'ADLSEMC';
        JobCategoryDescriptionTxt: Label 'Export to Azure Data Lake MC';

    /// <summary>
    ///  Schedule a job for multiple companies
    /// </summary>
    procedure ScheduleMultiExport(
        Monday: Boolean;
        Tuesday: Boolean;
        Wednesday: Boolean;
        Thursdays: Boolean;
        Friday: Boolean;
        Saturday: Boolean;
        Sunday: Boolean;
        TimeToRun: DateTime;
        MinBetweenRuns: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
        Company: Record Company;
        ADLSEExecution: Codeunit "ADLSE Execution";
        ScheduleAJob: Page "Schedule a Job";
        CurrCompany: Text;
    begin
        if not Company.FindSet() then
            exit;

        CurrCompany := CompanyName;
        repeat
            if Company.Name <> '' then begin
                JobQueueEntry.ChangeCompany(Company.Name);
                CreateJobQueueEntry(JobQueueEntry, Monday, Tuesday, Wednesday, Thursdays, Friday, Saturday, Sunday, TimeToRun, MinBetweenRuns);
                Commit();
                Clear(JobQueueEntry.ID); // "Job Queue - Enqueue" defines it on the real record insert
                CODEUNIT.Run(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
            end
        until Company.Next() = 0;
        JobQueueEntry.ChangeCompany(CurrCompany);
    end;

    local procedure CreateJobQueueEntry(var JobQueueEntry: Record "Job Queue Entry";
        Monday: Boolean;
        Tuesday: Boolean;
        Wednesday: Boolean;
        Thursdays: Boolean;
        Friday: Boolean;
        Saturday: Boolean;
        Sunday: Boolean;
        TimeToRun: DateTime;
        MinBetweenRuns: Integer)
    var
        JobQueueCategory: Record "Job Queue Category";
    begin
        JobQueueCategory.InsertRec(JobCategoryCodeTxt, JobCategoryDescriptionTxt);
        if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"ADLSE Execution") then
            exit;
        JobQueueEntry.Init();
        JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
        JobQueueEntry.Description := JobQueueCategory.Description;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"ADLSE Execution";
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := Monday;
        JobQueueEntry."Run on Tuesdays" := Tuesday;
        JobQueueEntry."Run on Wednesdays" := Wednesday;
        JobQueueEntry."Run on Thursdays" := Thursdays;
        JobQueueEntry."Run on Fridays" := Friday;
        JobQueueEntry."Run on Saturdays" := Saturday;
        JobQueueEntry."Run on Sundays" := Sunday;
        JobQueueEntry."No. of Minutes between Runs" := MinBetweenRuns;
        JobQueueEntry."Earliest Start Date/Time" := TimeToRun;
        JobQueueEntry."Expiration Date/Time" := TimeToRun + (7 * 24 * 60 * 60 * 1000); // 7 days from now
    end;

    /// <summary>
    ///  Delete the scheduled job for all companies
    /// </summary>
    procedure DeleteScheduleMultiExport()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
        Company: Record Company;
        ADLSEExecution: Codeunit "ADLSE Execution";
    begin
        if Company.FindSet() then
            repeat
                if Company.Name <> '' then begin
                    JobQueueEntry.ChangeCompany(Company.Name);
                    if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"ADLSE Execution") then
                        JobQueueEntry.Delete();
                end
            until Company.Next() = 0;
    end;
}