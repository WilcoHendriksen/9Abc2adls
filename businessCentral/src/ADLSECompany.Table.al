table 82594 "ADLSE Company"
{
    Access = Internal;
    DataClassification = SystemMetadata;
    DataPerCompany = false;

    fields
    {
        field(1; CompanyId; Guid)
        {
            DataClassification = SystemMetadata;
        }
        field(2; Enabled; Boolean)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; CompanyId)
        {
            Clustered = true;
        }
    }

    procedure UpdateCompanies()
    var
        Company: Record Company;
        CompaniesToDeleted: List of [Guid];
        CompanyIdToDelete: Guid;
    begin
        // insert not existing companies
        if Company.FindSet() then
            repeat
                // loop through companies
                Rec.SetRange(CompanyId, Company.Id);
                if not Rec.FindFirst() then begin
                    // The ADLSE company does not exists insert the company
                    Rec.Init();
                    Rec.CompanyId := Company.Id;
                    Rec.Insert();
                end;
            until Company.Next() = 0;

        // because we cannot delete from the list we are iterating save them in a list first.
        Rec.Reset();
        repeat
            Company.SetRange(Id, Rec.CompanyId);
            if not Company.FindFirst() then
                CompaniesToDeleted.Add(Rec.CompanyId);
        until Rec.Next() = 0;
        // and deleted them
        foreach CompanyIdToDelete in CompaniesToDeleted do begin
            Rec.Reset();
            Rec.SetRange(CompanyId, CompanyIdToDelete);
            Rec.Delete();
        end;

    end;
}