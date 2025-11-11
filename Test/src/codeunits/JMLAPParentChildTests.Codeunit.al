codeunit 50106 "JML AP Parent-Child Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        IsInitialized: Boolean;
        CannotDeleteAssetWithChildrenErr: Label 'Cannot delete asset %1 because it has child assets.', Comment = '%1 = Asset No.';

    [Test]
    procedure Test_CreateSimpleParentChild()
    var
        Vessel, Engine: Record "JML AP Asset";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [WHEN] Create Vessel, then Engine with Parent=Vessel
        CreateTestAsset(Vessel, 'MV Prosperity');
        CreateTestAsset(Engine, 'Main Engine');

        Engine.Validate("Parent Asset No.", Vessel."No.");
        Engine.Modify();

        // [THEN] Hierarchy correct
        Engine.Get(Engine."No.");
        Assert.AreEqual(2, Engine."Hierarchy Level", 'Engine should be level 2');
        Assert.AreEqual(Vessel."No.", Engine."Root Asset No.", 'Root should be Vessel');
    end;

    [Test]
    procedure Test_CreateThreeLevelHierarchy()
    var
        Vessel, Engine, Turbocharger: Record "JML AP Asset";
    begin
        // [GIVEN] Initialize
        Initialize();

        // [WHEN] Create Vessel ? Engine ? Turbocharger
        CreateTestAsset(Vessel, 'MV Prosperity');

        CreateTestAsset(Engine, 'Main Engine');
        Engine.Validate("Parent Asset No.", Vessel."No.");
        Engine.Modify();

        CreateTestAsset(Turbocharger, 'Turbocharger');
        Turbocharger.Validate("Parent Asset No.", Engine."No.");
        Turbocharger.Modify();

        // [THEN] Hierarchy levels correct
        Vessel.Get(Vessel."No.");
        Engine.Get(Engine."No.");
        Turbocharger.Get(Turbocharger."No.");

        Assert.AreEqual(1, Vessel."Hierarchy Level", 'Vessel should be level 1');
        Assert.AreEqual(2, Engine."Hierarchy Level", 'Engine should be level 2');
        Assert.AreEqual(3, Turbocharger."Hierarchy Level", 'Turbocharger should be level 3');

        Assert.AreEqual(Vessel."No.", Turbocharger."Root Asset No.", 'Root should be Vessel');
    end;

    [Test]
    procedure Test_CannotDeleteParentWithChildren()
    var
        Vessel, Engine1, Engine2: Record "JML AP Asset";
    begin
        // [GIVEN] Vessel with 2 engines
        Initialize();
        CreateTestAsset(Vessel, 'MV Prosperity');

        CreateTestAsset(Engine1, 'Main Engine 1');
        Engine1.Validate("Parent Asset No.", Vessel."No.");
        Engine1.Modify();

        CreateTestAsset(Engine2, 'Main Engine 2');
        Engine2.Validate("Parent Asset No.", Vessel."No.");
        Engine2.Modify();

        // [WHEN] Delete Vessel
        // [THEN] Error expected
        asserterror Vessel.Delete(true);
        Assert.ExpectedError(StrSubstNo(CannotDeleteAssetWithChildrenErr, Vessel."No."));
    end;

    [Test]
    procedure Test_RemoveParent()
    var
        Parent, Child: Record "JML AP Asset";
    begin
        // [GIVEN] Parent-child relationship
        Initialize();
        CreateTestAsset(Parent, 'Parent Asset');
        CreateTestAsset(Child, 'Child Asset');

        Child.Validate("Parent Asset No.", Parent."No.");
        Child.Modify();

        // [WHEN] Remove parent
        Child.Validate("Parent Asset No.", '');
        Child.Modify();

        // [THEN] Hierarchy reset
        Child.Get(Child."No.");
        Assert.AreEqual('', Child."Parent Asset No.", 'Parent should be cleared');
        Assert.AreEqual(1, Child."Hierarchy Level", 'Level should be 1');
        Assert.AreEqual('', Child."Root Asset No.", 'Root should be cleared');
    end;

    [Test]
    procedure Test_MultipleChildrenSameParent()
    var
        Parent, Child1, Child2, Child3: Record "JML AP Asset";
        ChildAsset: Record "JML AP Asset";
        ChildCount: Integer;
    begin
        // [GIVEN] One parent
        Initialize();
        CreateTestAsset(Parent, 'Parent Vessel');

        // [WHEN] Create 3 children
        CreateTestAsset(Child1, 'Engine 1');
        Child1.Validate("Parent Asset No.", Parent."No.");
        Child1.Modify();

        CreateTestAsset(Child2, 'Engine 2');
        Child2.Validate("Parent Asset No.", Parent."No.");
        Child2.Modify();

        CreateTestAsset(Child3, 'Propeller');
        Child3.Validate("Parent Asset No.", Parent."No.");
        Child3.Modify();

        // [THEN] All children linked to parent
        ChildAsset.SetRange("Parent Asset No.", Parent."No.");
        ChildCount := ChildAsset.Count();
        Assert.AreEqual(3, ChildCount, '3 children should exist');
    end;

    local procedure Initialize()
    var
        Asset: Record "JML AP Asset";
        HolderEntry: Record "JML AP Holder Entry";
        AssetSetup: Record "JML AP Asset Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if IsInitialized then
            exit;

        // Clean test data
        HolderEntry.DeleteAll();
        Asset.DeleteAll();
        NoSeriesLine.DeleteAll();
        NoSeries.DeleteAll();
        AssetSetup.DeleteAll();

        // Create basic setup
        CreateTestNumberSeries(NoSeries, NoSeriesLine);

        AssetSetup.Init();
        AssetSetup."Asset Nos." := NoSeries.Code;
        AssetSetup."Enable Attributes" := true;
        AssetSetup."Enable Holder History" := true;
        AssetSetup.Insert();

        IsInitialized := true;
        Commit();
    end;

    local procedure CreateTestAsset(var Asset: Record "JML AP Asset"; Description: Text[100])
    begin
        Asset.Init();
        Asset.Validate(Description, Description);
        Asset.Insert(true);
    end;

    local procedure CreateTestNumberSeries(var NoSeries: Record "No. Series"; var NoSeriesLine: Record "No. Series Line")
    begin
        NoSeries.Init();
        NoSeries.Code := 'ASSET-TEST';
        NoSeries.Description := 'Test Asset Numbers';
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := true;
        if NoSeries.Insert() then;

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := 'AT-0001';
        NoSeriesLine."Ending No." := 'AT-9999';
        NoSeriesLine."Increment-by No." := 1;
        if NoSeriesLine.Insert() then;
    end;
}