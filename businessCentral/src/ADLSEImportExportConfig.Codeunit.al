// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 82574 "ADLSE Import/Export config"
{
    Access = Internal;

    var
        SuccessfulExport: Label 'Successfully exported to config.json!';
        FailedToExport: Label 'Failed export to config.json';
        SelectConfigFileTitle: Label 'Select a configuration file';
        JsonFilesFilterTxt: Label 'json files (*.json)|*.json', Locked = true;
        tempFileName: Label 'config.json';
        ConfirmImport: Label 'Are you sure you want to remove all configured tables and fields?';
        CouldNotReadJson: Label 'Could not read json.';
        CouldNotReadTableDef: Label 'Could not read property "TableDefinitions".';
        TableDefIsNotAnArray: Label '"TableDefinitions" is not an array';
        CouldNotReadTableName: Label 'Could not read property "TableName".\';
        CouldNotReadColumns: Label 'Could not read property "ColumnNames".\';
        ColumnIsNotFound: Label 'Column "%1"."%2" is not found.\';
        TableIsNotFound: Label 'Table "%1" is not found.\';
        ProgressText: Label 'Importing #1\#2';


    /// <summary>
    ///     Export tables and columns from a json file
    /// </summary>
    procedure Export()
    var
        InStr: Instream;
        OutStr: OutStream;
        Content: BigText;
        JsonFile: JsonObject;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
        ContentAsText: Text;
    begin
        // get json
        GetConfigAsJson(JsonFile);
        // write it to Text
        JsonFile.WriteTo(ContentAsText);
        // write it to BigText
        Content.AddText(ContentAsText);
        TempBLOB.CreateOutStream(OutStr);
        Content.Write(OutStr);
        TempBLOB.CreateInStream(InStr);
        filename := 'config.json';
        // file is saved in "downloads" directory
        if not File.DownloadFromStream(Instr, '', '', '', filename) then begin
            Message(FailedToExport);
        end;
        Message(SuccessfulExport);
    end;

    /// <summary>
    ///     Import tables and columns from a json file
    /// </summary>
    procedure Import()
    var
        InStr: Instream;
        tempFileName: Text;
        FileManagement: Codeunit "File Management";
        JsonFile: JsonObject;
        JsonTableDefinitionsToken: JsonToken;
        i: Integer;
        JsonTableDefinitionToken: JsonToken;
        TableNameToken: JsonToken;
        TableName: Text;
        ColumnNamesToken: JsonToken;
        ColumnNameToken: JsonToken;
        ColumnName: Text;
        Progress: Dialog;
        ALDSETable: Record "ADLSE Table";
        ALDSEField: Record "ADLSE Field";
        TableTable: Record "Table Metadata";
        FieldTable: Record "Field";
        Errors: Text;
        ProgressUpdate: Text;
    begin
        // are you sure? dialog
        if not Dialog.Confirm(ConfirmImport) then
            exit;

        // empty tables
        ALDSEField.DeleteAll();
        ALDSETable.DeleteAll();

        // ask user to select a json file
        if not File.UploadIntoStream(SelectConfigFileTitle, '', JsonFilesFilterTxt, tempFileName, InStr) then
            Exit; // when cancelled

        // read into a json object
        if not JsonFile.ReadFrom(InStr) then
            Error(CouldNotReadJson);

        // check if the "TableDefinitions" token exists
        if not JsonFile.SelectToken('TableDefinitions', JsonTableDefinitionsToken) then
            Error(CouldNotReadTableDef);

        // check if table definitions is an array
        if not JsonTableDefinitionsToken.IsArray then
            Error(TableDefIsNotAnArray);

        // open progress dialog
        ProgressUpdate := Format(i) + ' of ' + Format(JsonTableDefinitionsToken.AsArray().Count);
        Progress.Open(ProgressText, ProgressUpdate, TableNameToken);

        // itterate over table definitions
        for i := 1 to JsonTableDefinitionsToken.AsArray().Count do begin
            if JsonTableDefinitionsToken.AsArray().Get(i, JsonTableDefinitionToken) then begin
                if not JsonTableDefinitionToken.SelectToken('TableName', TableNameToken) then
                    Errors += CouldNotReadTableName;

                // update the dialog with the new table name
                ProgressUpdate := Format(i) + ' of ' + Format(JsonTableDefinitionsToken.AsArray().Count);
                Progress.Update();
                TableName := TableNameToken.AsValue().AsText();
                TableTable.SetRange(Name, TableName);
                if (StrLen(TableName) > 0) and TableTable.FindSet() then begin
                    // if the table is found add it
                    ALDSETable.Add(TableTable.ID);
                    ALDSETable.Get(TableTable.ID);
                    // add all fields in the field table, but they are still disabled
                    ALDSEField.InsertForTable(ALDSETable);
                    // iterate over the columns
                    if JsonTableDefinitionToken.SelectToken('ColumnNames', ColumnNamesToken) then
                        foreach ColumnNameToken in ColumnNamesToken.AsArray() do begin
                            ColumnName := ColumnNameToken.AsValue().AsText();
                            ALDSEField.SetRange(FieldCaption, ColumnName);
                            ALDSEField.SetRange("Table ID", TableTable.ID);
                            if (StrLen(ColumnName) > 0) and ALDSEField.FindSet() then begin
                                // if the column is found enabled it
                                ALDSEField.Enabled := true;
                                ALDSEField.Modify();
                            end
                            else
                                Errors += StrSubstNo(ColumnIsNotFound, TableName, ColumnName);
                        end
                    else
                        Errors += CouldNotReadColumns;
                end
                else
                    Errors += StrSubstNo(TableIsNotFound, TableName);
            end;
        end;
        Progress.Close();

        // show errors
        if StrLen(Errors) > 0 then
            Message(Errors);
    end;

    /// <summary>
    ///  Get the JsonObject from the tables
    /// </summary>
    local procedure GetConfigAsJson(var JsonFile: JsonObject)
    var
        ALDSETable: Record "ADLSE Table";
        ALDSEField: Record "ADLSE Field";
        Field: Record Field;
        TableMetadata: Record "Table Metadata";
        FieldArray: JsonArray;
        TableDef: JsonObject;
        TableDefs: JsonArray;
    begin
        // clear json file and table definitions
        Clear(JsonFile);
        Clear(TableDefs);

        // only export enabled tables
        ALDSETable.SetRange("Enabled", true);
        if ALDSETable.FindSet() then begin
            repeat
                // clear table def and field arrays
                Clear(TableDef);
                Clear(FieldArray);

                // select all enabled fields from the table
                ALDSEField.SetRange("Table ID", ALDSETable."Table ID");
                ALDSEField.SetRange("Enabled", true);
                if ALDSEField.FindSet() then begin
                    repeat
                        // select the field from the "field" table for the name.
                        Field.SetRange(TableNo, ALDSEField."Table ID");
                        Field.SetRange("No.", ALDSEField."Field ID");
                        if Field.FindSet() then
                            // add the field to the array
                            FieldArray.Add(Field."Field Caption");
                    until ALDSEField.Next() = 0;
                end;
                // select the table metadata for the name
                TableMetadata.Get(ALDSETable."Table ID");
                // add them to the tabledef
                TableDef.Add('TableName', TableMetadata.Name);
                TableDef.Add('ColumnNames', FieldArray);
                // add tabledef to tabledefs array
                TableDefs.Add(TableDef);
            until ALDSETable.Next() = 0;
            // add to the tabledefs
            JsonFile.Add('TableDefinitions', TableDefs);
        end;
    end;
}