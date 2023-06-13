// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 82574 "ADLSE Import config"
{
    Access = Internal;

    var
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
        ProgressText: Label 'Importing #1';
        Errors: Text;
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
        Progress.Open(ProgressText, TableNameToken);

        // itterate over table definitions        
        foreach JsonTableDefinitionToken in JsonTableDefinitionsToken.AsArray() do begin
            if not JsonTableDefinitionToken.SelectToken('TableName', TableNameToken) then
                Errors += CouldNotReadTableName;

            // update the dialog with the new table name
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
        Progress.Close();

        // show errors
        if StrLen(Errors) > 0 then
            Message(Errors);
    end;
}