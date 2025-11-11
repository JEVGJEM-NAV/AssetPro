codeunit 70182387 "JML AP Asset Validation"
{
    /// <summary>
    /// Validates parent asset assignment and checks for circular references.
    /// </summary>
    /// <param name="Asset">The asset record to validate</param>
    procedure ValidateParentAssignment(var Asset: Record "JML AP Asset")
    var
        ParentAsset: Record "JML AP Asset";
    begin
        // Self-reference check
        if Asset."Parent Asset No." = Asset."No." then
            Error(CannotBeOwnParentErr, Asset."No.");

        // Parent must exist
        if not ParentAsset.Get(Asset."Parent Asset No.") then
            Error(ParentAssetNotFoundErr, Asset."Parent Asset No.");

        // Circular reference check
        CheckCircularReference(Asset);
    end;

    /// <summary>
    /// Checks for circular references in the parent-child chain.
    /// Prevents A→B→C→A scenarios.
    /// </summary>
    /// <param name="Asset">The asset record to check</param>
    local procedure CheckCircularReference(var Asset: Record "JML AP Asset")
    var
        CheckAsset: Record "JML AP Asset";
        CurrentParentNo: Code[20];
        IterationCount: Integer;
    begin
        CurrentParentNo := Asset."Parent Asset No.";
        IterationCount := 0;

        // Walk up the parent chain
        while (CurrentParentNo <> '') and (IterationCount < MaxCircularCheckDepth()) do begin
            // If we find ourselves in the chain, it's circular
            if CurrentParentNo = Asset."No." then
                Error(CircularReferenceDetectedErr, Asset."No.");

            // Get next parent
            if CheckAsset.Get(CurrentParentNo) then
                CurrentParentNo := CheckAsset."Parent Asset No."
            else
                CurrentParentNo := '';

            IterationCount += 1;
        end;

        // If we hit max depth, warn about possible issues
        if IterationCount >= MaxCircularCheckDepth() then
            Error(MaxDepthExceededErr, MaxCircularCheckDepth(), Asset."No.");
    end;

    /// <summary>
    /// Returns the maximum depth for circular reference checking.
    /// This is a system constant, not user-configurable.
    /// </summary>
    /// <returns>Maximum depth (100 levels)</returns>
    procedure MaxCircularCheckDepth(): Integer
    begin
        exit(100);
    end;

    /// <summary>
    /// Returns the maximum number of classification levels allowed per industry.
    /// This is a system constant, not user-configurable.
    /// </summary>
    /// <returns>Maximum classification levels (50)</returns>
    procedure MaxClassificationLevels(): Integer
    begin
        exit(50);
    end;

    var
        CannotBeOwnParentErr: Label 'Asset %1 cannot be its own parent.', Comment = '%1 = Asset No.';
        ParentAssetNotFoundErr: Label 'Parent asset %1 does not exist.', Comment = '%1 = Parent Asset No.';
        CircularReferenceDetectedErr: Label 'Circular reference detected: Asset %1 appears in its own parent chain.', Comment = '%1 = Asset No.';
        MaxDepthExceededErr: Label 'Maximum parent chain depth of %1 levels exceeded for asset %2. This may indicate a circular reference or an excessively deep hierarchy.', Comment = '%1 = Maximum depth, %2 = Asset No.';
}
