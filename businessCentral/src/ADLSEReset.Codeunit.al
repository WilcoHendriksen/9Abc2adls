// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 82593 "ADLSE Reset"
{
    var
        TablesResetTxt: Label 'Table(s) are reset for %1 companies', Comment = '%1 = number of companies that were reset';
    /// <summary>
    ///     Reset all tables for all companies, everything will be exported again when an export starts
    /// </summary>
    procedure ResetAll()
    var
        Company: Record "Company";
        Counter: Integer;
    begin
        // find all companies and iterate through them
        if Company.FindSet() then
            repeat
                // skip the empty one
                if Company.Name <> '' then
                    ResetAllForAllCompany(Company.Name);
                Counter += 1;
            until Company.Next() = 0;
        Message(TablesResetTxt, Counter);
    end;

    /// <summary>
    ///     Reset all tables for a company
    /// </summary>
    /// <param name="CompanyName">Company name for which this is resetted.</param>
    local procedure ResetAllForAllCompany(CompanyName: Text)
    var
        ADLSEDeletedRecord: Record "ADLSE Deleted Record";
        ADLSETableLastTimestamp: Record "ADLSE Table Last Timestamp";
        ADLSETable: Record "ADLSE Table";
    begin
        // change to the correct company
        ADLSETableLastTimestamp.ChangeCompany(CompanyName);
        ADLSEDeletedRecord.ChangeCompany(CompanyName);
        // loop through records of the "table" table
        if ADLSETable.FindSet(true) then
            repeat
                // set enabled on true(default value)
                ADLSETable.Enabled := true;
                ADLSETable.Modify();
                // set update and deleted on 0
                ADLSETableLastTimestamp.SaveUpdatedLastTimestamp(ADLSETable."Table ID", 0);
                ADLSETableLastTimestamp.SaveDeletedLastEntryNo(ADLSETable."Table ID", 0);
                // deleted the "deleted records"
                ADLSEDeletedRecord.DeleteAll();
            until ADLSETable.Next() = 0;
    end;
}