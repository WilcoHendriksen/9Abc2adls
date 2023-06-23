// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 82576 "ADLSE Schedule"
{
    var
        JobCategoryCodeTxt: Label 'ADLSEMC';
        JobCategoryDescriptionTxt: Label 'Export to Azure Data Lake MC';
    /// <summary>
    ///  Schedule a job for multiple companies
    /// </summary>
    procedure ScheduleMultiExport(Monday: Boolean; Tuesday: Boolean; Wednesday: Boolean; Thursdays: Boolean; Friday: Boolean; Saturday: Boolean; Sunday: Boolean; TimeToRun: DateTime; MinBetweenRuns: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
        Company: Record Company;
        ADLSEExecution: Codeunit "ADLSE Execution";
        foundJobQueCat: Record "Job Queue Category";
        ScheduleAJob: Page "Schedule a Job";
        CurrCompany: Text;
    begin
        if not Company.FindSet() then
            exit;

        CurrCompany := CompanyName;
        repeat
            if Company.Name <> '' then begin
                JobQueueEntry.ChangeCompany(Company.Name);
                JobQueueCategory.ChangeCompany(Company.Name);
                CreateJobQueueEntry(JobQueueEntry);
                ScheduleAJob.SetJob(JobQueueEntry);
                Commit(); // above changes go into the DB before RunModal
                if ScheduleAJob.RunModal() = Action::OK then
                    Message('scheduled for company ' + Company.Name);
            end
        until Company.Next() = 0;
        JobQueueEntry.ChangeCompany(CurrCompany);
        JobQueueCategory.ChangeCompany(CurrCompany);
    end;

    local procedure CreateJobQueueEntry(var JobQueueEntry: Record "Job Queue Entry")
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
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime(); // now
        JobQueueEntry."Expiration Date/Time" := CurrentDateTime() + (7 * 24 * 60 * 60 * 1000); // 7 days from now
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