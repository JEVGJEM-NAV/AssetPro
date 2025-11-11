codeunit 70182384 "JML AP Attribute Mgmt"
{
    /// <summary>
    /// Validates that all mandatory attributes have values for an asset.
    /// </summary>
    procedure ValidateMandatoryAttributes(AssetRec: Record "JML AP Asset"): Boolean
    var
        AttributeDefn: Record "JML AP Attribute Defn";
        AttributeValue: Record "JML AP Attribute Value";
        MissingAttributes: Text;
    begin
        // Get mandatory attributes for this asset's industry/level
        AttributeDefn.SetRange("Industry Code", AssetRec."Industry Code");
        AttributeDefn.SetRange(Mandatory, true);

        if AttributeDefn.FindSet() then
            repeat
                // Check if value exists
                AttributeValue.SetRange("Asset No.", AssetRec."No.");
                AttributeValue.SetRange("Attribute Code", AttributeDefn."Attribute Code");
                if AttributeValue.IsEmpty then begin
                    if MissingAttributes <> '' then
                        MissingAttributes += ', ';
                    MissingAttributes += AttributeDefn."Attribute Name";
                end;
            until AttributeDefn.Next() = 0;

        if MissingAttributes <> '' then
            Error(MandatoryAttributesMissingErr, MissingAttributes);

        exit(true);
    end;

    /// <summary>
    /// Applies default values to attributes for a new asset.
    /// </summary>
    procedure ApplyDefaultValues(AssetRec: Record "JML AP Asset")
    var
        AttributeDefn: Record "JML AP Attribute Defn";
        AttributeValue: Record "JML AP Attribute Value";
    begin
        AttributeDefn.SetRange("Industry Code", AssetRec."Industry Code");
        AttributeDefn.SetFilter("Default Value", '<>%1', '');

        if AttributeDefn.FindSet() then
            repeat
                // Check if value already exists
                if not AttributeValue.Get(AssetRec."No.", AttributeDefn."Attribute Code") then begin
                    AttributeValue.Init();
                    AttributeValue."Asset No." := AssetRec."No.";
                    AttributeValue."Attribute Code" := AttributeDefn."Attribute Code";
                    AttributeValue.SetValueFromText(AttributeDefn."Default Value");
                    AttributeValue.Insert(true);
                end;
            until AttributeDefn.Next() = 0;
    end;

    var
        MandatoryAttributesMissingErr: Label 'The following mandatory attributes are missing: %1', Comment = '%1 = List of missing attribute names';
}
