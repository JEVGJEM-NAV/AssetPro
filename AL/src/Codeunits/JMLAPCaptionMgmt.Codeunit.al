codeunit 70182382 "JML AP Caption Mgmt"
{
    /// <summary>
    /// Gets the caption for a classification level based on industry terminology.
    /// </summary>
    procedure GetLevelCaption(IndustryCode: Code[20]; LevelNo: Integer): Text[50]
    var
        ClassLevel: Record "JML AP Classification Lvl";
    begin
        if ClassLevel.Get(IndustryCode, LevelNo) then
            exit(ClassLevel."Level Name");
        exit(CopyStr('Level ' + Format(LevelNo), 1, 50));
    end;

    /// <summary>
    /// Gets the plural caption for a classification level.
    /// </summary>
    procedure GetLevelCaptionPlural(IndustryCode: Code[20]; LevelNo: Integer): Text[50]
    var
        ClassLevel: Record "JML AP Classification Lvl";
    begin
        if ClassLevel.Get(IndustryCode, LevelNo) then begin
            if ClassLevel."Level Name Plural" <> '' then
                exit(ClassLevel."Level Name Plural");
            exit(CopyStr(ClassLevel."Level Name" + 's', 1, 50));
        end;
        exit(CopyStr('Level ' + Format(LevelNo) + 's', 1, 50));
    end;
}
