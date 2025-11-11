codeunit 70182383 "JML AP Classification Mgt"
{
    /// <summary>
    /// Gets all child classification values under a parent.
    /// </summary>
    procedure GetChildValues(IndustryCode: Code[20]; ParentLevelNo: Integer; ParentValueCode: Code[20]; var TempClassValue: Record "JML AP Classification Val" temporary)
    var
        ClassValue: Record "JML AP Classification Val";
    begin
        TempClassValue.Reset();
        TempClassValue.DeleteAll();

        ClassValue.SetRange("Industry Code", IndustryCode);
        ClassValue.SetRange("Level Number", ParentLevelNo + 1);
        ClassValue.SetRange("Parent Value Code", ParentValueCode);

        if ClassValue.FindSet() then
            repeat
                TempClassValue := ClassValue;
                TempClassValue.Insert();
            until ClassValue.Next() = 0;
    end;

    /// <summary>
    /// Gets the full path of parent values for a classification.
    /// </summary>
    procedure GetParentPath(IndustryCode: Code[20]; LevelNo: Integer; ValueCode: Code[20]): Text[250]
    var
        ClassValue: Record "JML AP Classification Val";
        Path: Text[250];
        CurrentCode: Code[20];
        CurrentLevel: Integer;
    begin
        CurrentCode := ValueCode;
        CurrentLevel := LevelNo;

        while (CurrentLevel > 0) and (CurrentCode <> '') do
            if ClassValue.Get(IndustryCode, CurrentLevel, CurrentCode) then begin
                if Path = '' then
                    Path := CopyStr(ClassValue.Description, 1, 250)
                else
                    Path := CopyStr(ClassValue.Description + ' / ' + Path, 1, 250);

                CurrentCode := ClassValue."Parent Value Code";
                CurrentLevel -= 1;
            end else
                CurrentCode := '';

        exit(Path);
    end;
}
