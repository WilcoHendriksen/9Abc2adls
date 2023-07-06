codeunit 82591 "ADLSE Option"
{
    /// <summary>
    ///     Refreshes all options in the ADLSE option table
    /// </summary>
    /// <param name="LangCodes">Comma seperated languageCodes "NLD,ENU,DEU"</param>
    procedure RefreshOptions(LangCodes: Text)
    var
        ADLSETable: Record "ADLSE Table";
        ADLSEOption: Record "ADLSE Option";
        "Field": Record Field;
        LanguageCode: Text;
        LanguageCodes: List of [Text];
        FieldCaption: Text;
        OptionMembers: List of [Text];
        OptionCaptions: List of [Text];
        ArrayToUse: List of [Text];
        i: Integer;
    begin
        // empty the table
        ADLSEOption.DeleteAll();
        // split the languageIDs
        LanguageCodes := LangCodes.Split(',');

        // Find all tables that are configured
        if ADLSETable.FindSet() then begin
            // loop through tables
            repeat
                // Find all option fields from the selected table
                "Field".SetRange(TableNo, ADLSETable."Table ID");
                "Field".SetRange("Type", "Field"."Type"::Option);
                "Field".SetFilter(ObsoleteState, '<>%1', "Field".ObsoleteState::Removed);
                if "Field".FindSet() then begin
                    // loop through the options
                    repeat
                        // loop through the languages
                        foreach LanguageCode in LanguageCodes do begin
                            // get translations for selected option
                            GetOptionTranslations(LanguageCode, ADLSETable."Table ID", "Field"."No.", FieldCaption, OptionMembers, OptionCaptions);

                            // for each member create a record in the ADLSE option table
                            for i := 1 to OptionMembers.Count do Begin
                                ADLSEOption.Init();
                                ADLSEOption.LanguageCode := LanguageCode.ToUpper();
                                ADLSEOption.Table := Field.TableName;
                                ADLSEOption.Field := Field.FieldName;
                                ADLSEOption.FieldCaption := FieldCaption;
                                ADLSEOption.OptionMember := OptionMembers.Get(i);
                                ADLSEOption.OptionCaption := OptionCaptions.Get(i);
                                ADLSEOption.Insert();
                            End;

                        end;
                    until "Field".Next = 0;
                end;
            until ADLSETable.Next = 0;
        end;
    end;

    /// <summary>
    ///     Get the translations for an option field
    /// </summary>
    /// <param name="LanguageCode"></param>
    /// <param name="TableId"></param>
    /// <param name="FieldId"></param>
    /// <param name="FieldCaption">reference parameter which holds the FieldCaption</param>
    /// <param name="OptionMembers">reference parameter which holds a list of OptionMembers</param>
    /// <param name="OptionCaptions">reference parameter which holds a list of OptionCaptions</param>
    procedure GetOptionTranslations(LanguageCode: Text; TableId: Integer; FieldId: Integer; var FieldCaption: Text; var OptionMembers: List of [Text]; var OptionCaptions: List of [Text])
    var
        RecRef: RecordRef;
        FRef: FieldRef;
        i: Integer;
        Language: Record Language;
        OldLanuageId: Integer;
    begin
        // get the language
        if Language.Get(LanguageCode) then begin
            // open the table and find the field reference
            RecRef.Open(TableId);
            FRef := RecRef.Field(FieldId);
            // save old language
            OldLanuageId := GlobalLanguage();
            // set new language
            GlobalLanguage(Language."Windows Language ID");
            // clear variables
            Clear(FieldCaption);
            Clear(OptionMembers);
            Clear(OptionCaptions);
            // set values on variables
            FieldCaption := FRef.Caption;
            for i := 1 to FRef.EnumValueCount() do begin
                OptionCaptions.Add(FRef.GetEnumValueCaption(i));
                OptionMembers.Add(FRef.GetEnumValueName(i));
            end;
            // set old language back
            GlobalLanguage(OldLanuageId);
            exit;
        end;
    end;
}
