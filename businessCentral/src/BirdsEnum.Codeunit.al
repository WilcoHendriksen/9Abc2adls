codeunit 82591 "BirdsEnum"
{
    var
        PlsConfigureCompaniesTxt: Label 'Enable companies in the multi company scheduler page';
        PlsConfigureTablesTxt: Label 'Add tables in the table section.';

    /// <summary>
    ///     Refreshes all options in the ADLSE option table
    /// </summary>
    /// <param name="LangCodes">Comma seperated languageCodes "NLD,ENU,DEU", for the code slook into the language table</param>
    procedure RefreshOptions(LangCodes: Text)
    var
        ADLSETable: Record "ADLSE Table";
        ADLSECompany: Record "ADLSE Company";
        Company: Record Company;
        BirdsEnum: Record BirdsEnum;
        BirdsEnumTrans: Record BirdsEnumTranslation;
        "Field": Record Field;
        LanguageCode: Text;
        LanguageCodes: List of [Text];
        Language: Record Language;
        OldLanuageId: Integer;
        i: Integer;
        RecRef: RecordRef;
        FRef: FieldRef;
    begin
        // split the languageIDs
        LanguageCodes := LangCodes.Split(',');
        ADLSECompany.SetRange(Enabled, true);

        if ADLSECompany.FindSet() then begin
            // loop through enabled companies
            repeat
                Company.SetRange(Id, ADLSECompany.CompanyId);
                if Company.FindFirst() then begin
                    BirdsEnum.ChangeCompany(Company.Name);
                    BirdsEnumTrans.ChangeCompany(Company.Name);

                    // empty the tables
                    BirdsEnum.DeleteAll();
                    BirdsEnumTrans.DeleteAll();

                    // Find all tables that are configured
                    if ADLSETable.FindSet() then begin
                        // loop through tables
                        repeat
                            // Find all option fields from the selected table
                            "Field".SetRange(TableNo, ADLSETable."Table ID");
                            "Field".SetRange("Type", "Field"."Type"::Option);
                            "Field".SetFilter(ObsoleteState, '<>%1', "Field".ObsoleteState::Removed);
                            RecRef.Open(ADLSETable."Table ID");
                            if "Field".FindSet() then begin
                                // loop through the options
                                repeat
                                    FRef := RecRef.Field("Field"."No.");
                                    for i := 1 to FRef.EnumValueCount() do begin
                                        BirdsEnum.InsertEnum(Field.TableName, Field.FieldName, FRef.GetEnumValueOrdinal(i), FRef.GetEnumValueName(i));
                                        // loop through the languages
                                        foreach LanguageCode in LanguageCodes do begin
                                            if Language.Get(LanguageCode) then begin
                                                // save old language and set new one
                                                OldLanuageId := GlobalLanguage();
                                                GlobalLanguage(Language."Windows Language ID");

                                                // insert translation record
                                                BirdsEnumTrans.InsertEnumTrans(LanguageCode, Field.TableName, Field.FieldName, FRef.GetEnumValueOrdinal(i), FRef.GetEnumValueName(i), FRef.GetEnumValueCaption(i));

                                                // set old language
                                                GlobalLanguage(OldLanuageId);
                                            end else
                                                Message(LanguageCode + ' not found.');
                                        end;
                                    end;
                                until "Field".Next = 0;
                            end;
                            RecRef.Close();
                        until ADLSETable.Next = 0;
                    end else
                        Message(PlsConfigureTablesTxt);
                end else
                    Message(PlsConfigureCompaniesTxt);
            until ADLSECompany.Next() = 0;
        end;
    end;
}
