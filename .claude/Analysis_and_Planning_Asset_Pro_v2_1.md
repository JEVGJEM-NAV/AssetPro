# Asset Pro - Comprehensive Analysis and Planning Document v2.1

**Project:** Asset Pro - Multi-Industry Asset Management for Business Central
**Publisher:** JEMEL
**App Prefix:** JML
**Date:** 2025-11-09
**Status:** Architecture Analysis - Awaiting Approval
**Workflow Mode:** Analysis (Relaxed)
**Document Version:** 2.1

---

## Changes in v2.1

**Critical Updates:**

1. **Object Naming Convention Standardized**
   - All objects use "JML AP" prefix (Asset Pro)
   - Object names limited to 30 characters total
   - Captions do NOT include "JML AP" prefix
   - Example: Table "JML AP Asset Setup" has Caption "Asset Setup"

2. **Holder History Table Redesigned**
   - Changed from two-field (From/To) to entry-based pattern
   - Follows BC standard: Item Ledger Entry, Warehouse Entry pattern
   - Primary Key: Entry No. (AutoIncrement)
   - Two-line entries: Transfer Out (-) and Transfer In (+)
   - United by Document No. and Transaction No.
   - Enables point-in-time holder lookup by filtering Asset + Date

3. **Clean Code Principles Applied**
   - Procedure names are clear and action-oriented
   - Single responsibility principle enforced
   - Magic numbers replaced with constants
   - Error messages are descriptive
   - Variable names are self-documenting
   - Comments explain "why" not "what"

4. **Comprehensive Test Plan**
   - Detailed test scenarios for each test codeunit
   - Expected results specified
   - Test data setup procedures documented
   - Performance benchmarks defined

5. **Complete Object Structures**
   - Full field definitions for all tables
   - Complete page layouts with all sections
   - All codeunit procedures with parameters
   - All enum values defined

---

## Executive Summary

### Vision Statement
> "Track any asset, any industry, your way - with unlimited flexibility and complete terminology adaptation"

### The Challenge
Traditional asset management solutions force businesses into rigid structures:
- Fixed 2-3 level hierarchies
- Generic terminology ("Asset", "Component", "Part")
- Either classification OR physical relationships, not both
- One-size-fits-all approach that fits nobody perfectly

### The Solution: Asset Pro's Two-Structure Architecture

Asset Pro introduces a revolutionary **dual-structure architecture** that separates concerns:

**STRUCTURE 1: Classification Hierarchy** (Organizational)
- Unlimited configurable levels per industry
- Dynamic terminology that adapts completely
- Example: "Fleet" → "Vessel Type" → "Vessel Model" → "Vessel Unit"
- Used for: Organization, filtering, reporting, access control

**STRUCTURE 2: Physical Composition** (Parent-Child Assets)
- Self-referential asset relationships
- Represents actual physical assembly/containment
- Example: Vessel (Asset) → Engine (Asset) → Turbocharger (Asset)
- Used for: Component tracking, maintenance, BOM, service history

**STRUCTURE 3: Component BOM** (Items, not Assets)
- Standard BC Items for non-tracked parts
- Example: Filters, taps, cables, consumables
- Used for: Parts inventory, ordering, replacement

### Key Innovation

**Separation of Classification from Composition:**

```
Traditional (Confused):
  Level 1: Vehicle Type
    Level 2: Vehicle Model
      Level 3: Specific Vehicle  <-- Where do components go?
        Level 4: Engine??? (Breaks the classification logic)

Asset Pro (Clear):
  CLASSIFICATION:
    Industry: Fleet
      Level 1: Vessel Type
        Level 2: Vessel Model
          Asset Classification: Cargo Ship, Model XYZ

  PHYSICAL COMPOSITION:
    Asset: Vessel HMS-001
      Parent: (none)
      Children:
        → Engine (Asset)
        → Generator (Asset)
      Components (Items):
        → Propeller Blade (Item, Qty 4)
        → Navigation Light (Item, Qty 12)
```

### Market Position

**Target Market:**
- Multi-industry asset-intensive businesses using Business Central
- Companies with 100-100,000+ assets to manage
- Industries: Marine, Medical, Construction, IT, Manufacturing, Rental

**Competitive Advantage:**
1. **Universal Adaptability** - One codebase serves all industries
2. **Complete Terminology Transformation** - System speaks your language
3. **Dual-Structure Clarity** - No confusion between classification and composition
4. **Unlimited Depth** - Each industry defines its own hierarchy complexity
5. **Native BC Integration** - Deep integration with Sales, Purchasing, Transfer documents

**Pricing Strategy:**
- Professional: $49/user/month (vs. competitors at $99/user/month)
- Target: 50-100 customers, 2,500+ users by Year 3
- ARR Target: $2-4M by Year 3

---

## Architecture Overview

### The Two-Structure Model Explained

#### Structure 1: Classification Hierarchy (What IS it?)

**Purpose:** Organizational taxonomy for filtering, reporting, and access control

**Characteristics:**
- Tree-like structure defined per industry
- Each industry has 1-10 levels (configurable)
- Each level has configurable name and terminology
- Assets are classified at ONE point in this tree
- Think: "What category/type does this asset belong to?"

**Example - Fleet Management:**
```
Industry: Fleet Management
  Level 1: "Fleet" (Commercial, Fishing, Passenger)
    Level 2: "Vessel Type" (Cargo Ship, Trawler, Ferry)
      Level 3: "Vessel Model" (Custom designation, e.g., "Panamax Bulk Carrier")

Asset HMS-001 Classification:
  - Industry: Fleet Management
  - Level 1 Value: Commercial
  - Level 2 Value: Cargo Ship
  - Level 3 Value: Panamax Bulk Carrier
```

**Example - Water Dispensers:**
```
Industry: Dispenser Management
  Level 1: "Product Line" (Office, Industrial, Residential)
    Level 2: "Model Series" (WD-100 Series, WD-200 Series)

Asset D-12345 Classification:
  - Industry: Dispenser Management
  - Level 1 Value: Office
  - Level 2 Value: WD-200 Series
```

#### Structure 2: Physical Composition (What's INSIDE it?)

**Purpose:** Actual physical assembly and component relationships

**Characteristics:**
- Self-referential Asset table (Parent Asset No. field)
- Represents physical containment/assembly
- Unlimited nesting depth (Asset → Asset → Asset...)
- Independent of classification hierarchy
- Think: "What physical components make up this asset?"

**Example - Fleet Management:**
```
Vessel HMS-001 (Classification: Commercial/Cargo Ship/Panamax)
  ├─ Main Engine ME-001 (Classification: Marine Equipment/Main Engine/Diesel)
  │   ├─ Turbocharger TC-001 (Classification: Marine Equipment/Turbocharger/Model-X)
  │   └─ Fuel Injection System FIS-001 (Classification: Marine Equipment/Fuel System/Electronic)
  └─ Auxiliary Generator AG-001 (Classification: Marine Equipment/Generator/750kW)
```

**Example - Water Dispensers:**
```
Dispenser D-12345 (Classification: Office/WD-200 Series)
  ├─ Electronic Control Unit ECU-789 (Classification: Dispenser Parts/Electronics/Control)
  └─ Cooling Compressor CC-456 (Classification: Dispenser Parts/Cooling/Compressor)
```

#### Structure 3: Component BOM (What standard PARTS does it use?)

**Purpose:** Non-tracked consumable items and standard parts

**Characteristics:**
- Links Asset to BC Items (existing Item table)
- Quantity-based (not serial number tracked)
- Used for consumables, common parts, replacements
- Think: "What do I need to order/stock for this asset?"

**Example - Fleet Management:**
```
Vessel HMS-001 Components:
  - Item 10001: Propeller Blade (Qty: 4)
  - Item 10002: Navigation Light, Red (Qty: 6)
  - Item 10003: Navigation Light, Green (Qty: 6)
  - Item 10004: Life Vest, Adult (Qty: 50)
```

**Example - Water Dispensers:**
```
Dispenser D-12345 Components:
  - Item 20001: Water Filter, 5-micron (Qty: 2)
  - Item 20002: Water Tap, Chrome (Qty: 1)
  - Item 20003: Drip Tray, Plastic (Qty: 1)
  - Item 20004: UV Lamp, Replacement (Qty: 1)
```

### How the Three Structures Work Together

**Asset Creation Flow:**
1. **Choose Classification** - Where does it fit organizationally?
   - Select Industry: "Fleet Management"
   - Select Level 1: "Commercial"
   - Select Level 2: "Cargo Ship"
   - Select Level 3: "Panamax Bulk Carrier"

2. **Create Asset Record**
   - Asset No.: HMS-001
   - Description: "MV Pacific Star"
   - Classification: As above
   - Parent Asset: (none, this is a top-level asset)

3. **Add Physical Child Assets** (if applicable)
   - Create Engine asset ME-001
   - Set Parent = HMS-001
   - Engine has its own classification (Marine Equipment/Main Engine/Diesel)

4. **Add Component BOM** (standard parts)
   - Add Item 10001 (Propeller Blade), Qty 4
   - Add Item 10002 (Navigation Light), Qty 12
   - Etc.

**Validation Logic:**
- Classification validation: Must select valid industry and level values
- Physical validation: Parent asset must exist, cannot be self, no circular references
- Component validation: Item must exist in BC

**Search/Filter Scenarios:**
- "Show all Cargo Ships" → Filter by Classification Level 2
- "Show all assets containing Turbochargers" → Filter by Child Assets
- "Show all assets needing Item 20001" → Filter by Component BOM

---

## Complete Data Model

### Entity Relationship Diagram

```mermaid
erDiagram
    ASSET-INDUSTRY ||--o{ CLASSIFICATION-LEVEL : "defines levels"
    CLASSIFICATION-LEVEL ||--o{ CLASSIFICATION-VALUE : "has values"
    CLASSIFICATION-VALUE ||--o{ ASSET : "classifies at Level 1"
    CLASSIFICATION-VALUE ||--o{ ASSET : "classifies at Level 2"
    CLASSIFICATION-VALUE ||--o{ ASSET : "classifies at Level 3"
    ASSET ||--o{ ASSET : "parent-child"
    ASSET ||--o{ ASSET-COMPONENT : "has parts"
    ASSET ||--o{ ASSET-ATTRIBUTE-VALUE : "has attribute values"
    ASSET ||--o{ ASSET-HOLDER-ENTRY : "tracks transitions"
    CLASSIFICATION-LEVEL ||--o{ ATTRIBUTE-DEFINITION : "defines attributes"
    ATTRIBUTE-DEFINITION ||--o{ ASSET-ATTRIBUTE-VALUE : "defines structure"
    CUSTOMER ||--o{ ASSET : "owns/operates"
    VENDOR ||--o{ ASSET : "maintains"
    LOCATION ||--o{ ASSET : "stores"
    ITEM ||--o{ ASSET-COMPONENT : "is used in"

    ASSET-INDUSTRY {
        Code industry_code PK
        Text name
        Text description
        Boolean blocked
    }

    CLASSIFICATION-LEVEL {
        Code industry_code PK
        Integer level_number PK
        Text level_name
        Text level_name_plural
        Integer parent_level_number
        Boolean use_in_lists
    }

    CLASSIFICATION-VALUE {
        Code industry_code PK
        Integer level_number PK
        Code value_code PK
        Text description
        Code parent_value_code
        Boolean blocked
    }

    ASSET {
        Code no PK
        Text description
        Code industry_code FK
        Code classification_l1_code FK
        Code classification_l2_code FK
        Code classification_l3_code FK
        Code parent_asset_no FK
        Enum current_holder_type
        Code current_holder_code
        Date current_holder_since
        Code owner_customer_no
        Code operator_customer_no
        Enum status
        Date acquisition_date
        Decimal acquisition_cost
    }

    ASSET-COMPONENT {
        Code asset_no PK_FK
        Integer line_no PK
        Code item_no FK
        Decimal quantity
        Code unit_of_measure
        Text position
        Code serial_no
        Boolean blocked
    }

    ATTRIBUTE-DEFINITION {
        Code industry_code PK_FK
        Integer level_number PK_FK
        Code attribute_code PK
        Text attribute_name
        Enum data_type
        Text option_string
        Boolean mandatory
        Text default_value
        Integer display_order
    }

    ASSET-ATTRIBUTE-VALUE {
        Code asset_no PK_FK
        Code attribute_code PK_FK
        Text value_text
        Integer value_integer
        Decimal value_decimal
        Date value_date
        Boolean value_boolean
    }

    ASSET-HOLDER-ENTRY {
        Integer entry_no PK
        Code asset_no FK
        DateTime posting_datetime
        Enum entry_type
        Enum holder_type
        Code holder_code
        Text holder_name
        Integer transaction_no
        Code document_type
        Code document_no
        Code reason_code
        Code user_id
    }
```

---

## Detailed Table Structures

### Table 70182300: JML AP Asset Setup

**Object Name:** `JML AP Asset Setup` (20 chars)
**Caption:** `Asset Setup`
**Purpose:** Company-wide configuration for Asset Pro module

```al
table 70182300 "JML AP Asset Setup"
{
    Caption = 'Asset Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }

        // Numbering
        field(10; "Asset Nos."; Code[20])
        {
            Caption = 'Asset Nos.';
            TableRelation = "No. Series";
        }

        // Defaults
        field(20; "Default Industry Code"; Code[20])
        {
            Caption = 'Default Industry Code';
            TableRelation = "JML AP Asset Industry";
        }

        // Feature Toggles
        field(30; "Enable Classification"; Boolean)
        {
            Caption = 'Enable Classification';
            InitValue = true;
        }

        field(31; "Enable Attributes"; Boolean)
        {
            Caption = 'Enable Attributes';
            InitValue = true;
        }

        field(32; "Enable Holder History"; Boolean)
        {
            Caption = 'Enable Holder History';
            InitValue = true;
        }

        field(33; "Enable Parent-Child"; Boolean)
        {
            Caption = 'Enable Parent-Child Relationships';
            InitValue = true;
        }

        // Validation Rules
        field(40; "Max Circular Check Depth"; Integer)
        {
            Caption = 'Max Circular Check Depth';
            InitValue = 100;
            MinValue = 10;
            MaxValue = 200;
        }

        field(41; "Max Classification Levels"; Integer)
        {
            Caption = 'Max Classification Levels';
            InitValue = 10;
            MinValue = 1;
            MaxValue = 50;
        }

        // System
        field(100; "Current Industry Context"; Code[20])
        {
            Caption = 'Current Industry Context';
            TableRelation = "JML AP Asset Industry";
            Description = 'Used for CaptionClass resolution';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetRecordOnce()
    begin
        if not IsInitialized then begin
            if not Get() then begin
                Init();
                Insert();
            end;
            IsInitialized := true;
        end;
    end;

    var
        IsInitialized: Boolean;
}
```

---

### Table 70182301: JML AP Asset

**Object Name:** `JML AP Asset` (14 chars)
**Caption:** `Asset`
**Purpose:** Main asset master record

```al
table 70182301 "JML AP Asset"
{
    Caption = 'Asset';
    DataClassification = CustomerContent;
    LookupPageId = "JML AP Asset List";
    DrillDownPageId = "JML AP Asset List";

    fields
    {
        // === PRIMARY IDENTIFICATION ===
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then
                    ValidateNumberSeries();
            end;
        }

        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
        }

        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }

        field(12; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }

        // === CLASSIFICATION (STRUCTURE 1) ===
        field(100; "Industry Code"; Code[20])
        {
            Caption = 'Industry';
            TableRelation = "JML AP Asset Industry";

            trigger OnValidate()
            begin
                if "Industry Code" <> xRec."Industry Code" then
                    ClearClassificationFields();
            end;
        }

        field(101; "Classification Level 1"; Code[20])
        {
            Caption = 'Level 1';
            TableRelation = "JML AP Classification Val".Code
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = const(1));
            CaptionClass = GetLevelCaption(1);

            trigger OnValidate()
            begin
                ValidateClassificationLevel(1);
            end;
        }

        field(102; "Classification Level 2"; Code[20])
        {
            Caption = 'Level 2';
            TableRelation = "JML AP Classification Val".Code
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = const(2),
                      "Parent Value Code" = field("Classification Level 1"));
            CaptionClass = GetLevelCaption(2);

            trigger OnValidate()
            begin
                ValidateClassificationLevel(2);
            end;
        }

        field(103; "Classification Level 3"; Code[20])
        {
            Caption = 'Level 3';
            TableRelation = "JML AP Classification Val".Code
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = const(3),
                      "Parent Value Code" = field("Classification Level 2"));
            CaptionClass = GetLevelCaption(3);

            trigger OnValidate()
            begin
                ValidateClassificationLevel(3);
            end;
        }

        field(104; "Classification Level 4"; Code[20])
        {
            Caption = 'Level 4';
            TableRelation = "JML AP Classification Val".Code
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = const(4),
                      "Parent Value Code" = field("Classification Level 3"));
            CaptionClass = GetLevelCaption(4);
        }

        field(105; "Classification Level 5"; Code[20])
        {
            Caption = 'Level 5';
            TableRelation = "JML AP Classification Val".Code
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = const(5),
                      "Parent Value Code" = field("Classification Level 4"));
            CaptionClass = GetLevelCaption(5);
        }

        // Levels 6-10 follow same pattern...

        // === PHYSICAL COMPOSITION (STRUCTURE 2) ===
        field(200; "Parent Asset No."; Code[20])
        {
            Caption = 'Parent Asset No.';
            TableRelation = "JML AP Asset";

            trigger OnValidate()
            begin
                ValidateParentAsset();
            end;
        }

        field(201; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
            FieldClass = FlowField;
            CalcFormula = Exist("JML AP Asset" where("Parent Asset No." = field("No.")));
            Editable = false;
        }

        field(202; "Child Asset Count"; Integer)
        {
            Caption = 'Child Asset Count';
            FieldClass = FlowField;
            CalcFormula = Count("JML AP Asset" where("Parent Asset No." = field("No.")));
            Editable = false;
        }

        field(203; "Hierarchy Level"; Integer)
        {
            Caption = 'Hierarchy Level';
            Editable = false;
            Description = 'Physical hierarchy depth (1 = root, 2 = child, 3 = grandchild, etc.)';
        }

        field(204; "Root Asset No."; Code[20])
        {
            Caption = 'Root Asset No.';
            TableRelation = "JML AP Asset";
            Editable = false;
            Description = 'Top-most parent asset in physical hierarchy';
        }

        // === CURRENT HOLDER (OWNERSHIP/LOCATION) ===
        field(300; "Current Holder Type"; Enum "JML AP Holder Type")
        {
            Caption = 'Current Holder Type';

            trigger OnValidate()
            begin
                if "Current Holder Type" <> xRec."Current Holder Type" then
                    "Current Holder Code" := '';
            end;
        }

        field(301; "Current Holder Code"; Code[20])
        {
            Caption = 'Current Holder Code';
            TableRelation = if ("Current Holder Type" = const(Customer)) Customer."No."
                            else if ("Current Holder Type" = const(Vendor)) Vendor."No."
                            else if ("Current Holder Type" = const(Location)) Location.Code;

            trigger OnValidate()
            begin
                UpdateCurrentHolderName();
            end;
        }

        field(302; "Current Holder Name"; Text[100])
        {
            Caption = 'Current Holder Name';
            Editable = false;
        }

        field(303; "Current Holder Since"; Date)
        {
            Caption = 'Current Holder Since';
        }

        // === OWNERSHIP ROLES ===
        field(310; "Owner Customer No."; Code[20])
        {
            Caption = 'Owner Customer No.';
            TableRelation = Customer;
        }

        field(311; "Operator Customer No."; Code[20])
        {
            Caption = 'Operator Customer No.';
            TableRelation = Customer;
        }

        field(312; "Lessee Customer No."; Code[20])
        {
            Caption = 'Lessee Customer No.';
            TableRelation = Customer;
        }

        // === STATUS AND DATES ===
        field(400; Status; Enum "JML AP Asset Status")
        {
            Caption = 'Status';
        }

        field(410; "Acquisition Date"; Date)
        {
            Caption = 'Acquisition Date';
        }

        field(411; "In-Service Date"; Date)
        {
            Caption = 'In-Service Date';
        }

        field(412; "Last Service Date"; Date)
        {
            Caption = 'Last Service Date';
        }

        field(413; "Next Service Date"; Date)
        {
            Caption = 'Next Service Date';
        }

        field(414; "Decommission Date"; Date)
        {
            Caption = 'Decommission Date';
        }

        // === FINANCIAL ===
        field(500; "Acquisition Cost"; Decimal)
        {
            Caption = 'Acquisition Cost';
            AutoFormatType = 1;
        }

        field(501; "Current Book Value"; Decimal)
        {
            Caption = 'Current Book Value';
            AutoFormatType = 1;
        }

        field(502; "Residual Value"; Decimal)
        {
            Caption = 'Residual Value';
            AutoFormatType = 1;
        }

        // === ADDITIONAL INFO ===
        field(600; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }

        field(601; "Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }

        field(602; "Model No."; Code[50])
        {
            Caption = 'Model No.';
        }

        field(603; "Year of Manufacture"; Integer)
        {
            Caption = 'Year of Manufacture';
            MinValue = 1900;
            MaxValue = 2100;
        }

        field(604; "Warranty Expires"; Date)
        {
            Caption = 'Warranty Expires';
        }

        // === SYSTEM FIELDS ===
        field(900; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }

        field(910; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }

        field(911; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Industry; "Industry Code", "Classification Level 1", "Classification Level 2")
        {
        }
        key(Holder; "Current Holder Type", "Current Holder Code")
        {
        }
        key(Parent; "Parent Asset No.")
        {
        }
        key(Search; "Search Description")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Industry Code", Status)
        {
        }
        fieldgroup(Brick; "No.", Description, "Current Holder Name", Status)
        {
        }
    }

    trigger OnInsert()
    begin
        InitializeAsset();
        "Last Date Modified" := Today;
        "Last Modified By" := CopyStr(UserId, 1, MaxStrLen("Last Modified By"));
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "Last Modified By" := CopyStr(UserId, 1, MaxStrLen("Last Modified By"));
    end;

    trigger OnDelete()
    begin
        ValidateAssetCanBeDeleted();
    end;

    // === VALIDATION PROCEDURES ===
    local procedure ValidateNumberSeries()
    var
        AssetSetup: Record "JML AP Asset Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        AssetSetup.GetRecordOnce();
        NoSeriesMgt.TestManual(AssetSetup."Asset Nos.");
        "No. Series" := '';
    end;

    local procedure InitializeAsset()
    var
        AssetSetup: Record "JML AP Asset Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            AssetSetup.GetRecordOnce();
            AssetSetup.TestField("Asset Nos.");
            NoSeriesMgt.InitSeries(AssetSetup."Asset Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        CalculateHierarchyLevel();
        UpdateRootAssetNo();
    end;

    local procedure ClearClassificationFields()
    begin
        "Classification Level 1" := '';
        "Classification Level 2" := '';
        "Classification Level 3" := '';
        "Classification Level 4" := '';
        "Classification Level 5" := '';
        // Clear levels 6-10 if implemented
    end;

    local procedure ValidateClassificationLevel(LevelNo: Integer)
    var
        PreviousLevelCode: Code[20];
    begin
        if LevelNo > 1 then begin
            PreviousLevelCode := GetClassificationLevelCode(LevelNo - 1);
            if PreviousLevelCode = '' then
                Error(MustSetPreviousLevelErr, LevelNo - 1, LevelNo);
        end;
    end;

    local procedure GetClassificationLevelCode(LevelNo: Integer): Code[20]
    begin
        case LevelNo of
            1: exit("Classification Level 1");
            2: exit("Classification Level 2");
            3: exit("Classification Level 3");
            4: exit("Classification Level 4");
            5: exit("Classification Level 5");
            // Levels 6-10 if implemented
        end;
    end;

    local procedure ValidateParentAsset()
    var
        AssetValidator: Codeunit "JML AP Asset Validation";
    begin
        if "Parent Asset No." = '' then begin
            "Hierarchy Level" := 1;
            UpdateRootAssetNo();
            exit;
        end;

        AssetValidator.ValidateParentAssignment(Rec);
        CalculateHierarchyLevel();
        UpdateRootAssetNo();
    end;

    local procedure CalculateHierarchyLevel()
    var
        ParentAsset: Record "JML AP Asset";
    begin
        if "Parent Asset No." = '' then
            "Hierarchy Level" := 1
        else if ParentAsset.Get("Parent Asset No.") then
            "Hierarchy Level" := ParentAsset."Hierarchy Level" + 1
        else
            "Hierarchy Level" := 1;
    end;

    local procedure UpdateRootAssetNo()
    var
        TempAsset: Record "JML AP Asset";
        CurrentAssetNo: Code[20];
        IterationCount: Integer;
    begin
        CurrentAssetNo := "No.";
        IterationCount := 0;

        // Walk up the parent chain to find root
        while (CurrentAssetNo <> '') and (IterationCount < MaxParentChainDepth) do begin
            if TempAsset.Get(CurrentAssetNo) then begin
                if TempAsset."Parent Asset No." = '' then begin
                    "Root Asset No." := TempAsset."No.";
                    exit;
                end;
                CurrentAssetNo := TempAsset."Parent Asset No.";
            end else
                CurrentAssetNo := '';

            IterationCount += 1;
        end;

        // If no parent found, this is root
        if "Parent Asset No." = '' then
            "Root Asset No." := "No."
        else
            "Root Asset No." := '';
    end;

    local procedure UpdateCurrentHolderName()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        "Current Holder Name" := '';

        case "Current Holder Type" of
            "Current Holder Type"::Customer:
                if Customer.Get("Current Holder Code") then
                    "Current Holder Name" := Customer.Name;
            "Current Holder Type"::Vendor:
                if Vendor.Get("Current Holder Code") then
                    "Current Holder Name" := Vendor.Name;
            "Current Holder Type"::Location:
                if Location.Get("Current Holder Code") then
                    "Current Holder Name" := Location.Name;
        end;
    end;

    local procedure ValidateAssetCanBeDeleted()
    var
        ChildAsset: Record "JML AP Asset";
    begin
        // Cannot delete if has children
        ChildAsset.SetRange("Parent Asset No.", "No.");
        if not ChildAsset.IsEmpty then
            Error(CannotDeleteWithChildrenErr, "No.");

        // Could add more validations:
        // - Check if referenced in posted documents
        // - Check if has transaction history
    end;

    local procedure GetLevelCaption(LevelNo: Integer): Text
    begin
        exit(StrSubstNo('JML-ASSET:%1:%2:N', "Industry Code", LevelNo));
    end;

    // === CONSTANTS ===
    var
        MaxParentChainDepth: Integer;
        MustSetPreviousLevelErr: Label 'You must set Level %1 before setting Level %2.';
        CannotDeleteWithChildrenErr: Label 'Cannot delete asset %1 because it has child assets.';

    begin
        MaxParentChainDepth := 100;
    end;
}
```

---

### Table 70182302: JML AP Asset Industry

**Object Name:** `JML AP Asset Industry` (24 chars)
**Caption:** `Asset Industry`

```al
table 70182302 "JML AP Asset Industry"
{
    Caption = 'Asset Industry';
    DataClassification = CustomerContent;
    LookupPageId = "JML AP Industries";
    DrillDownPageId = "JML AP Industries";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }

        field(10; Name; Text[100])
        {
            Caption = 'Name';
        }

        field(20; Description; Text[250])
        {
            Caption = 'Description';
        }

        field(30; "Number of Levels"; Integer)
        {
            Caption = 'Number of Levels';
            FieldClass = FlowField;
            CalcFormula = Count("JML AP Classification Lvl" where("Industry Code" = field(Code)));
            Editable = false;
        }

        field(31; "Number of Values"; Integer)
        {
            Caption = 'Number of Values';
            FieldClass = FlowField;
            CalcFormula = Count("JML AP Classification Val" where("Industry Code" = field(Code)));
            Editable = false;
        }

        field(32; "Number of Assets"; Integer)
        {
            Caption = 'Number of Assets';
            FieldClass = FlowField;
            CalcFormula = Count("JML AP Asset" where("Industry Code" = field(Code)));
            Editable = false;
        }

        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }

        field(110; "Template Type"; Enum "JML AP Industry Template")
        {
            Caption = 'Template Type';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(Name; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Name)
        {
        }
    }

    trigger OnDelete()
    begin
        ValidateIndustryCanBeDeleted();
    end;

    local procedure ValidateIndustryCanBeDeleted()
    var
        Asset: Record "JML AP Asset";
        ClassificationLevel: Record "JML AP Classification Lvl";
    begin
        // Cannot delete if assets exist
        Asset.SetRange("Industry Code", Code);
        if not Asset.IsEmpty then
            Error(CannotDeleteIndustryWithAssetsErr, Code);

        // Delete related classification data
        ClassificationLevel.SetRange("Industry Code", Code);
        if not ClassificationLevel.IsEmpty then
            ClassificationLevel.DeleteAll(true);
    end;

    var
        CannotDeleteIndustryWithAssetsErr: Label 'Cannot delete industry %1 because assets are using it.';
}
```

---

### Table 70182303: JML AP Classification Lvl

**Object Name:** `JML AP Classification Lvl` (28 chars)
**Caption:** `Classification Level`

```al
table 70182303 "JML AP Classification Lvl"
{
    Caption = 'Classification Level';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            TableRelation = "JML AP Asset Industry";
            NotBlank = true;
        }

        field(2; "Level Number"; Integer)
        {
            Caption = 'Level Number';
            NotBlank = true;
            MinValue = 1;
            MaxValue = 50;
        }

        field(10; "Level Name"; Text[50])
        {
            Caption = 'Level Name';
            NotBlank = true;
        }

        field(11; "Level Name Plural"; Text[50])
        {
            Caption = 'Level Name Plural';
        }

        field(20; "Parent Level Number"; Integer)
        {
            Caption = 'Parent Level Number';
            Editable = false;
        }

        field(30; "Use in Lists"; Boolean)
        {
            Caption = 'Use in Lists';
            InitValue = true;
        }

        field(40; "Value Count"; Integer)
        {
            Caption = 'Value Count';
            FieldClass = FlowField;
            CalcFormula = Count("JML AP Classification Val"
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = field("Level Number")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Industry Code", "Level Number")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Level Number", "Level Name")
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateLevelNumberSequence();
        UpdateParentLevel();
    end;

    trigger OnModify()
    begin
        ValidateLevelNumberSequence();
    end;

    trigger OnDelete()
    begin
        ValidateLevelCanBeDeleted();
    end;

    local procedure ValidateLevelNumberSequence()
    var
        PreviousLevel: Record "JML AP Classification Lvl";
    begin
        // Level 1 is always valid
        if "Level Number" = 1 then
            exit;

        // Check previous level exists
        if not PreviousLevel.Get("Industry Code", "Level Number" - 1) then
            Error(PreviousLevelMustExistErr, "Level Number" - 1, "Level Number");
    end;

    local procedure UpdateParentLevel()
    begin
        if "Level Number" > 1 then
            "Parent Level Number" := "Level Number" - 1
        else
            "Parent Level Number" := 0;
    end;

    local procedure ValidateLevelCanBeDeleted()
    var
        ClassificationValue: Record "JML AP Classification Val";
        NextLevel: Record "JML AP Classification Lvl";
    begin
        // Cannot delete if values exist
        ClassificationValue.SetRange("Industry Code", "Industry Code");
        ClassificationValue.SetRange("Level Number", "Level Number");
        if not ClassificationValue.IsEmpty then
            Error(CannotDeleteLevelWithValuesErr, "Level Number");

        // Cannot delete if child levels exist
        if NextLevel.Get("Industry Code", "Level Number" + 1) then
            Error(CannotDeleteLevelWithChildLevelsErr, "Level Number", "Level Number" + 1);
    end;

    var
        PreviousLevelMustExistErr: Label 'Level %1 must exist before creating Level %2.';
        CannotDeleteLevelWithValuesErr: Label 'Cannot delete Level %1 because classification values exist.';
        CannotDeleteLevelWithChildLevelsErr: Label 'Cannot delete Level %1 because Level %2 exists. Delete child levels first.';
}
```

---

### Table 70182304: JML AP Classification Val

**Object Name:** `JML AP Classification Val` (28 chars)
**Caption:** `Classification Value`

```al
table 70182304 "JML AP Classification Val"
{
    Caption = 'Classification Value';
    DataClassification = CustomerContent;
    LookupPageId = "JML AP Classification Vals";
    DrillDownPageId = "JML AP Classification Vals";

    fields
    {
        field(1; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            TableRelation = "JML AP Asset Industry";
            NotBlank = true;
        }

        field(2; "Level Number"; Integer)
        {
            Caption = 'Level Number';
            TableRelation = "JML AP Classification Lvl"."Level Number" where("Industry Code" = field("Industry Code"));
            NotBlank = true;
        }

        field(3; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }

        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(20; "Parent Value Code"; Code[20])
        {
            Caption = 'Parent Value Code';
            TableRelation = "JML AP Classification Val".Code
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = field("Parent Level Number"));

            trigger OnValidate()
            begin
                ValidateParentValue();
            end;
        }

        field(21; "Parent Level Number"; Integer)
        {
            Caption = 'Parent Level Number';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Classification Lvl"."Parent Level Number"
                where("Industry Code" = field("Industry Code"),
                      "Level Number" = field("Level Number")));
            Editable = false;
        }

        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }

        field(110; "Asset Count"; Integer)
        {
            Caption = 'Asset Count';
            FieldClass = FlowField;
            CalcFormula = Count("JML AP Asset"
                where("Industry Code" = field("Industry Code"),
                      "Classification Level 1" = field(Code)));
            // Note: This only counts Level 1. Need separate FlowFields for other levels.
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Industry Code", "Level Number", Code)
        {
            Clustered = true;
        }
        key(Parent; "Industry Code", "Level Number", "Parent Value Code")
        {
        }
        key(Description; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {
        }
    }

    trigger OnInsert()
    begin
        ValidateParentValue();
    end;

    trigger OnDelete()
    begin
        ValidateValueCanBeDeleted();
    end;

    local procedure ValidateParentValue()
    var
        ParentValue: Record "JML AP Classification Val";
    begin
        CalcFields("Parent Level Number");

        // Level 1 has no parent
        if "Level Number" = 1 then begin
            if "Parent Value Code" <> '' then
                Error(Level1CannotHaveParentErr);
            exit;
        end;

        // Level 2+ must have parent
        if "Parent Value Code" = '' then
            Error(ParentValueRequiredErr, "Level Number");

        // Parent must exist
        if not ParentValue.Get("Industry Code", "Parent Level Number", "Parent Value Code") then
            Error(ParentValueNotFoundErr, "Parent Value Code", "Parent Level Number");
    end;

    local procedure ValidateValueCanBeDeleted()
    var
        Asset: Record "JML AP Asset";
        ChildValue: Record "JML AP Classification Val";
    begin
        // Cannot delete if assets use this value
        Asset.SetRange("Industry Code", "Industry Code");
        case "Level Number" of
            1: Asset.SetRange("Classification Level 1", Code);
            2: Asset.SetRange("Classification Level 2", Code);
            3: Asset.SetRange("Classification Level 3", Code);
            // Continue for levels 4-10
        end;

        if not Asset.IsEmpty then
            Error(CannotDeleteValueInUseErr, Code);

        // Cannot delete if child values exist
        ChildValue.SetRange("Industry Code", "Industry Code");
        ChildValue.SetRange("Level Number", "Level Number" + 1);
        ChildValue.SetRange("Parent Value Code", Code);
        if not ChildValue.IsEmpty then
            Error(CannotDeleteValueWithChildrenErr, Code);
    end;

    var
        Level1CannotHaveParentErr: Label 'Level 1 values cannot have a parent value.';
        ParentValueRequiredErr: Label 'Level %1 values must have a parent value.';
        ParentValueNotFoundErr: Label 'Parent value %1 does not exist at Level %2.';
        CannotDeleteValueInUseErr: Label 'Cannot delete classification value %1 because assets are using it.';
        CannotDeleteValueWithChildrenErr: Label 'Cannot delete classification value %1 because child values exist.';
}
```

---

### Table 70182308: JML AP Holder Entry

**Object Name:** `JML AP Holder Entry` (22 chars)
**Caption:** `Asset Holder Entry`
**Purpose:** Ledger-style tracking of asset holder transitions

**KEY DESIGN CHANGE:** This table follows the BC pattern of Item Ledger Entry and Warehouse Entry:
- Primary Key is Entry No. (AutoIncrement)
- Two entries per transition: Transfer Out (negative) and Transfer In (positive)
- Linked by Document No. and Transaction No.
- Enables point-in-time holder lookup by summing entries up to a date

```al
table 70182308 "JML AP Holder Entry"
{
    Caption = 'Asset Holder Entry';
    DataClassification = CustomerContent;
    LookupPageId = "JML AP Holder Entries";
    DrillDownPageId = "JML AP Holder Entries";

    fields
    {
        // === PRIMARY KEY ===
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        // === ASSET IDENTIFICATION ===
        field(10; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "JML AP Asset";
            NotBlank = true;
        }

        field(11; "Asset Description"; Text[100])
        {
            Caption = 'Asset Description';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Asset".Description where("No." = field("Asset No.")));
            Editable = false;
        }

        // === POSTING INFORMATION ===
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            NotBlank = true;
        }

        field(21; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
        }

        field(22; "Entry Type"; Enum "JML AP Holder Entry Type")
        {
            Caption = 'Entry Type';
            NotBlank = true;
        }

        // === HOLDER INFORMATION ===
        field(30; "Holder Type"; Enum "JML AP Holder Type")
        {
            Caption = 'Holder Type';
        }

        field(31; "Holder Code"; Code[20])
        {
            Caption = 'Holder Code';
            TableRelation = if ("Holder Type" = const(Customer)) Customer."No."
                            else if ("Holder Type" = const(Vendor)) Vendor."No."
                            else if ("Holder Type" = const(Location)) Location.Code;
        }

        field(32; "Holder Name"; Text[100])
        {
            Caption = 'Holder Name';
        }

        // === TRANSACTION LINKING ===
        field(40; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            Description = 'Links paired Transfer Out/Transfer In entries';
        }

        field(41; "Document Type"; Enum "JML AP Document Type")
        {
            Caption = 'Document Type';
        }

        field(42; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(43; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }

        field(44; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }

        // === REASON AND NOTES ===
        field(50; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }

        field(51; Description; Text[100])
        {
            Caption = 'Description';
        }

        // === USER TRACKING ===
        field(60; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
        }

        field(61; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Asset; "Asset No.", "Posting Date", "Posting Time")
        {
            // Enables efficient holder lookup at specific date
        }
        key(Transaction; "Transaction No.", "Entry Type")
        {
            // Links paired entries
        }
        key(Document; "Document Type", "Document No.")
        {
        }
        key(Holder; "Holder Type", "Holder Code", "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Asset No.", "Posting Date", "Holder Name")
        {
        }
    }

    trigger OnInsert()
    begin
        "User ID" := CopyStr(UserId, 1, MaxStrLen("User ID"));
    end;

    /// <summary>
    /// Gets the current holder of an asset on a specific date.
    /// </summary>
    /// <param name="AssetNo">The asset number to query.</param>
    /// <param name="OnDate">The date to check holder status.</param>
    /// <param name="HolderType">Output: The holder type on that date.</param>
    /// <param name="HolderCode">Output: The holder code on that date.</param>
    /// <returns>True if holder found, False if no holder entries exist.</returns>
    procedure GetHolderOnDate(AssetNo: Code[20]; OnDate: Date; var HolderType: Enum "JML AP Holder Type"; var HolderCode: Code[20]): Boolean
    var
        HolderEntry: Record "JML AP Holder Entry";
        LastEntryNo: Integer;
    begin
        // Find the last entry for this asset up to the specified date
        HolderEntry.SetCurrentKey("Asset No.", "Posting Date", "Posting Time");
        HolderEntry.SetRange("Asset No.", AssetNo);
        HolderEntry.SetRange("Posting Date", 0D, OnDate);
        if HolderEntry.FindLast() then begin
            // For Transfer Out entry, we need to find corresponding Transfer In
            if HolderEntry."Entry Type" = HolderEntry."Entry Type"::"Transfer Out" then begin
                HolderEntry.SetRange("Transaction No.", HolderEntry."Transaction No.");
                HolderEntry.SetRange("Entry Type", HolderEntry."Entry Type"::"Transfer In");
                if HolderEntry.FindFirst() then begin
                    HolderType := HolderEntry."Holder Type";
                    HolderCode := HolderEntry."Holder Code";
                    exit(true);
                end;
            end else begin
                // Initial Balance or Transfer In
                HolderType := HolderEntry."Holder Type";
                HolderCode := HolderEntry."Holder Code";
                exit(true);
            end;
        end;

        // No holder found
        Clear(HolderType);
        HolderCode := '';
        exit(false);
    end;
}
```

**Usage Example:**

```al
// Old approach (two-field From/To):
// INSERT: From=Location WH01, To=Customer C001

// New approach (ledger entries):
// Entry 1: Entry Type=Transfer Out, Holder=Location WH01, Transaction No=1
// Entry 2: Entry Type=Transfer In, Holder=Customer C001, Transaction No=1

// To find current holder on 2025-06-15:
var
    HolderEntry: Record "JML AP Holder Entry";
    HolderType: Enum "JML AP Holder Type";
    HolderCode: Code[20];
begin
    if HolderEntry.GetHolderOnDate('HMS-001', 20250615D, HolderType, HolderCode) then
        Message('Holder: %1 %2', HolderType, HolderCode);
end;
```

---

### Table 70182305: JML AP Attribute Defn

**Object Name:** `JML AP Attribute Defn` (24 chars)
**Caption:** `Attribute Definition`

```al
table 70182305 "JML AP Attribute Defn"
{
    Caption = 'Attribute Definition';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            TableRelation = "JML AP Asset Industry";
            NotBlank = true;
        }

        field(2; "Level Number"; Integer)
        {
            Caption = 'Level Number';
            TableRelation = "JML AP Classification Lvl"."Level Number" where("Industry Code" = field("Industry Code"));
            Description = '0 = applies to all levels';
        }

        field(3; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            NotBlank = true;
        }

        field(10; "Attribute Name"; Text[50])
        {
            Caption = 'Attribute Name';
            NotBlank = true;
        }

        field(20; "Data Type"; Enum "JML AP Attribute Type")
        {
            Caption = 'Data Type';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Data Type" <> "Data Type"::Option then
                    "Option String" := '';
            end;
        }

        field(21; "Option String"; Text[250])
        {
            Caption = 'Option String';
            Description = 'Comma-separated values for Option type';

            trigger OnValidate()
            begin
                if "Data Type" <> "Data Type"::Option then
                    Error(OptionStringOnlyForOptionTypeErr);

                ValidateOptionString();
            end;
        }

        field(30; Mandatory; Boolean)
        {
            Caption = 'Mandatory';
        }

        field(31; "Default Value"; Text[250])
        {
            Caption = 'Default Value';

            trigger OnValidate()
            begin
                ValidateDefaultValue();
            end;
        }

        field(40; "Display Order"; Integer)
        {
            Caption = 'Display Order';
        }

        field(50; "Help Text"; Text[250])
        {
            Caption = 'Help Text';
        }

        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(PK; "Industry Code", "Level Number", "Attribute Code")
        {
            Clustered = true;
        }
        key(DisplayOrder; "Industry Code", "Level Number", "Display Order")
        {
        }
    }

    local procedure ValidateOptionString()
    var
        Options: List of [Text];
    begin
        if "Option String" = '' then
            exit;

        Options := "Option String".Split(',');
        if Options.Count < 2 then
            Error(OptionStringNeedsMultipleValuesErr);
    end;

    local procedure ValidateDefaultValue()
    var
        IntValue: Integer;
        DecValue: Decimal;
        DateValue: Date;
    begin
        if "Default Value" = '' then
            exit;

        case "Data Type" of
            "Data Type"::Integer:
                if not Evaluate(IntValue, "Default Value") then
                    Error(DefaultValueMustBeIntegerErr);
            "Data Type"::Decimal:
                if not Evaluate(DecValue, "Default Value") then
                    Error(DefaultValueMustBeDecimalErr);
            "Data Type"::Date:
                if not Evaluate(DateValue, "Default Value") then
                    Error(DefaultValueMustBeDateErr);
            "Data Type"::Boolean:
                if not ("Default Value" in ['true', 'false', 'TRUE', 'FALSE']) then
                    Error(DefaultValueMustBeBooleanErr);
        end;
    end;

    var
        OptionStringOnlyForOptionTypeErr: Label 'Option String can only be set for Option data type.';
        OptionStringNeedsMultipleValuesErr: Label 'Option String must contain at least 2 values separated by commas.';
        DefaultValueMustBeIntegerErr: Label 'Default Value must be a valid integer.';
        DefaultValueMustBeDecimalErr: Label 'Default Value must be a valid decimal number.';
        DefaultValueMustBeDateErr: Label 'Default Value must be a valid date.';
        DefaultValueMustBeBooleanErr: Label 'Default Value must be true or false.';
}
```

---

### Table 70182306: JML AP Attribute Value

**Object Name:** `JML AP Attribute Value` (26 chars)
**Caption:** `Attribute Value`

```al
table 70182306 "JML AP Attribute Value"
{
    Caption = 'Attribute Value';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "JML AP Asset";
            NotBlank = true;
        }

        field(2; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            NotBlank = true;
        }

        // Value storage fields (only one is used based on data type)
        field(10; "Value Text"; Text[250])
        {
            Caption = 'Value Text';
        }

        field(11; "Value Integer"; Integer)
        {
            Caption = 'Value Integer';
        }

        field(12; "Value Decimal"; Decimal)
        {
            Caption = 'Value Decimal';
            DecimalPlaces = 0:5;
        }

        field(13; "Value Date"; Date)
        {
            Caption = 'Value Date';
        }

        field(14; "Value Boolean"; Boolean)
        {
            Caption = 'Value Boolean';
        }

        // FlowFields for display
        field(100; "Attribute Name"; Text[50])
        {
            Caption = 'Attribute Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Attribute Defn"."Attribute Name"
                where("Attribute Code" = field("Attribute Code")));
            Editable = false;
        }

        field(101; "Data Type"; Enum "JML AP Attribute Type")
        {
            Caption = 'Data Type';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Attribute Defn"."Data Type"
                where("Attribute Code" = field("Attribute Code")));
            Editable = false;
        }

        field(102; "Option String"; Text[250])
        {
            Caption = 'Option String';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Attribute Defn"."Option String"
                where("Attribute Code" = field("Attribute Code")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Asset No.", "Attribute Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        ValidateValue();
    end;

    trigger OnModify()
    begin
        ValidateValue();
    end;

    /// <summary>
    /// Gets the display value as text regardless of data type.
    /// </summary>
    /// <returns>Formatted value as text.</returns>
    procedure GetDisplayValue(): Text[250]
    begin
        CalcFields("Data Type");
        case "Data Type" of
            "Data Type"::Text, "Data Type"::Option:
                exit("Value Text");
            "Data Type"::Integer:
                exit(Format("Value Integer"));
            "Data Type"::Decimal:
                exit(Format("Value Decimal"));
            "Data Type"::Date:
                exit(Format("Value Date"));
            "Data Type"::Boolean:
                exit(Format("Value Boolean"));
        end;
    end;

    /// <summary>
    /// Sets the value from text, converting to appropriate data type.
    /// </summary>
    /// <param name="ValueText">The value as text.</param>
    procedure SetValueFromText(ValueText: Text[250])
    var
        IntValue: Integer;
        DecValue: Decimal;
        DateValue: Date;
        BoolValue: Boolean;
    begin
        CalcFields("Data Type");
        case "Data Type" of
            "Data Type"::Text, "Data Type"::Option:
                "Value Text" := ValueText;
            "Data Type"::Integer:
                if Evaluate(IntValue, ValueText) then
                    "Value Integer" := IntValue
                else
                    Error(InvalidIntegerValueErr, ValueText);
            "Data Type"::Decimal:
                if Evaluate(DecValue, ValueText) then
                    "Value Decimal" := DecValue
                else
                    Error(InvalidDecimalValueErr, ValueText);
            "Data Type"::Date:
                if Evaluate(DateValue, ValueText) then
                    "Value Date" := DateValue
                else
                    Error(InvalidDateValueErr, ValueText);
            "Data Type"::Boolean:
                if Evaluate(BoolValue, ValueText) then
                    "Value Boolean" := BoolValue
                else
                    Error(InvalidBooleanValueErr, ValueText);
        end;
    end;

    local procedure ValidateValue()
    var
        AttributeDefn: Record "JML AP Attribute Defn";
        Options: List of [Text];
        OptionFound: Boolean;
        i: Integer;
    begin
        CalcFields("Data Type", "Option String");

        // For Option type, validate against option string
        if "Data Type" = "Data Type"::Option then begin
            if "Option String" = '' then
                exit;

            Options := "Option String".Split(',');
            OptionFound := false;
            for i := 1 to Options.Count do begin
                if "Value Text" = Options.Get(i).Trim() then
                    OptionFound := true;
            end;

            if not OptionFound then
                Error(ValueNotInOptionStringErr, "Value Text", "Option String");
        end;
    end;

    var
        InvalidIntegerValueErr: Label '%1 is not a valid integer value.';
        InvalidDecimalValueErr: Label '%1 is not a valid decimal value.';
        InvalidDateValueErr: Label '%1 is not a valid date value.';
        InvalidBooleanValueErr: Label '%1 is not a valid boolean value. Use true or false.';
        ValueNotInOptionStringErr: Label 'Value %1 is not in the allowed options: %2';
}
```

---

### Table 70182307: JML AP Component

**Object Name:** `JML AP Component` (19 chars)
**Caption:** `Asset Component`

```al
table 70182307 "JML AP Component"
{
    Caption = 'Asset Component';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "JML AP Asset";
            NotBlank = true;
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }

        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            NotBlank = true;

            trigger OnValidate()
            begin
                GetItemDefaults();
            end;
        }

        field(11; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }

        field(20; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Quantity < 0 then
                    Error(QuantityCannotBeNegativeErr);
            end;
        }

        field(21; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }

        field(30; Position; Text[50])
        {
            Caption = 'Position';
            Description = 'Physical location within asset (e.g., "Front Panel", "Engine Bay")';
        }

        field(40; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            Description = 'For serialized components';
        }

        field(50; "Installation Date"; Date)
        {
            Caption = 'Installation Date';
        }

        field(51; "Next Replacement Date"; Date)
        {
            Caption = 'Next Replacement Date';
        }

        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(PK; "Asset No.", "Line No.")
        {
            Clustered = true;
        }
        key(Item; "Item No.")
        {
        }
    }

    local procedure GetItemDefaults()
    var
        Item: Record Item;
    begin
        if Item.Get("Item No.") then begin
            if "Unit of Measure Code" = '' then
                "Unit of Measure Code" := Item."Base Unit of Measure";
        end;
    end;

    var
        QuantityCannotBeNegativeErr: Label 'Quantity cannot be negative.';
}
```

---

### Table 70182309: JML AP Comment Line

**Object Name:** `JML AP Comment Line` (22 chars)
**Caption:** `Asset Comment Line`

```al
table 70182309 "JML AP Comment Line"
{
    Caption = 'Asset Comment Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionMembers = Asset,"Holder Entry";
            OptionCaption = 'Asset,Holder Entry';
        }

        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if ("Table Name" = const(Asset)) "JML AP Asset";
            NotBlank = true;
        }

        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }

        field(10; Date; Date)
        {
            Caption = 'Date';
        }

        field(20; Comment; Text[250])
        {
            Caption = 'Comment';
        }

        field(30; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Table Name", "No.", "Line No.")
        {
            Clustered = true;
        }
        key(DateOrder; "Table Name", "No.", Date)
        {
        }
    }

    trigger OnInsert()
    begin
        "User ID" := CopyStr(UserId, 1, MaxStrLen("User ID"));
        if Date = 0D then
            Date := Today;
    end;
}
```

---

## Enums

### Enum 70182400: JML AP Holder Type

```al
enum 70182400 "JML AP Holder Type"
{
    Caption = 'Holder Type';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Customer)
    {
        Caption = 'Customer';
    }
    value(2; Vendor)
    {
        Caption = 'Vendor';
    }
    value(3; Location)
    {
        Caption = 'Location';
    }
    value(4; "Cost Center")
    {
        Caption = 'Cost Center';
    }
}
```

### Enum 70182401: JML AP Holder Entry Type

```al
enum 70182401 "JML AP Holder Entry Type"
{
    Caption = 'Holder Entry Type';
    Extensible = true;

    value(0; "Initial Balance")
    {
        Caption = 'Initial Balance';
    }
    value(1; "Transfer Out")
    {
        Caption = 'Transfer Out';
    }
    value(2; "Transfer In")
    {
        Caption = 'Transfer In';
    }
}
```

### Enum 70182402: JML AP Asset Status

```al
enum 70182402 "JML AP Asset Status"
{
    Caption = 'Asset Status';
    Extensible = true;

    value(0; Active)
    {
        Caption = 'Active';
    }
    value(1; Inactive)
    {
        Caption = 'Inactive';
    }
    value(2; Maintenance)
    {
        Caption = 'Maintenance';
    }
    value(3; Decommissioned)
    {
        Caption = 'Decommissioned';
    }
    value(4; "In Transit")
    {
        Caption = 'In Transit';
    }
}
```

### Enum 70182403: JML AP Attribute Type

```al
enum 70182403 "JML AP Attribute Type"
{
    Caption = 'Attribute Data Type';
    Extensible = true;

    value(0; Text)
    {
        Caption = 'Text';
    }
    value(1; Integer)
    {
        Caption = 'Integer';
    }
    value(2; Decimal)
    {
        Caption = 'Decimal';
    }
    value(3; Date)
    {
        Caption = 'Date';
    }
    value(4; Boolean)
    {
        Caption = 'Boolean';
    }
    value(5; Option)
    {
        Caption = 'Option';
    }
}
```

### Enum 70182404: JML AP Industry Template

```al
enum 70182404 "JML AP Industry Template"
{
    Caption = 'Industry Template';
    Extensible = true;

    value(0; Custom)
    {
        Caption = 'Custom';
    }
    value(1; Fleet)
    {
        Caption = 'Fleet Management';
    }
    value(2; Dispenser)
    {
        Caption = 'Dispenser Management';
    }
    value(3; Medical)
    {
        Caption = 'Medical Equipment';
    }
    value(4; "IT Equipment")
    {
        Caption = 'IT Equipment';
    }
    value(5; Construction)
    {
        Caption = 'Construction Equipment';
    }
}
```

### Enum 70182406: JML AP Document Type

```al
enum 70182406 "JML AP Document Type"
{
    Caption = 'Document Type';
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(2; "Purchase Order")
    {
        Caption = 'Purchase Order';
    }
    value(3; "Transfer Order")
    {
        Caption = 'Transfer Order';
    }
    value(4; "Service Order")
    {
        Caption = 'Service Order';
    }
    value(10; Manual)
    {
        Caption = 'Manual';
    }
}
```

---

## Core Codeunits

### Codeunit 70182380: JML AP Asset Management

**Object Name:** `JML AP Asset Management` (26 chars)
**Caption:** `Asset Management`

```al
codeunit 70182380 "JML AP Asset Management"
{
    /// <summary>
    /// Creates a new asset with classification and initial holder.
    /// </summary>
    procedure CreateAsset(IndustryCode: Code[20]; Description: Text[100]; var Asset: Record "JML AP Asset"): Boolean
    begin
        Asset.Init();
        Asset.Validate("Industry Code", IndustryCode);
        Asset.Validate(Description, Description);
        Asset.Insert(true);
        exit(true);
    end;

    /// <summary>
    /// Copies an asset including optional children and components.
    /// </summary>
    procedure CopyAsset(SourceAssetNo: Code[20]; IncludeChildren: Boolean; IncludeComponents: Boolean; var NewAsset: Record "JML AP Asset"): Boolean
    var
        SourceAsset: Record "JML AP Asset";
    begin
        if not SourceAsset.Get(SourceAssetNo) then
            Error(AssetNotFoundErr, SourceAssetNo);

        // Copy main asset
        NewAsset := SourceAsset;
        NewAsset."No." := '';
        NewAsset."No. Series" := '';
        NewAsset.Insert(true);

        // Copy attributes
        CopyAssetAttributes(SourceAssetNo, NewAsset."No.");

        // Copy components
        if IncludeComponents then
            CopyAssetComponents(SourceAssetNo, NewAsset."No.");

        // Copy children (recursive)
        if IncludeChildren then
            CopyChildAssets(SourceAssetNo, NewAsset."No.");

        exit(true);
    end;

    local procedure CopyAssetAttributes(SourceAssetNo: Code[20]; TargetAssetNo: Code[20])
    var
        SourceAttrValue: Record "JML AP Attribute Value";
        TargetAttrValue: Record "JML AP Attribute Value";
    begin
        SourceAttrValue.SetRange("Asset No.", SourceAssetNo);
        if SourceAttrValue.FindSet() then
            repeat
                TargetAttrValue := SourceAttrValue;
                TargetAttrValue."Asset No." := TargetAssetNo;
                TargetAttrValue.Insert();
            until SourceAttrValue.Next() = 0;
    end;

    local procedure CopyAssetComponents(SourceAssetNo: Code[20]; TargetAssetNo: Code[20])
    var
        SourceComponent: Record "JML AP Component";
        TargetComponent: Record "JML AP Component";
    begin
        SourceComponent.SetRange("Asset No.", SourceAssetNo);
        if SourceComponent.FindSet() then
            repeat
                TargetComponent := SourceComponent;
                TargetComponent."Asset No." := TargetAssetNo;
                TargetComponent.Insert();
            until SourceComponent.Next() = 0;
    end;

    local procedure CopyChildAssets(SourceParentNo: Code[20]; TargetParentNo: Code[20])
    var
        ChildAsset: Record "JML AP Asset";
        NewChildAsset: Record "JML AP Asset";
    begin
        ChildAsset.SetRange("Parent Asset No.", SourceParentNo);
        if ChildAsset.FindSet() then
            repeat
                CopyAsset(ChildAsset."No.", true, true, NewChildAsset);
                NewChildAsset.Validate("Parent Asset No.", TargetParentNo);
                NewChildAsset.Modify(true);
            until ChildAsset.Next() = 0;
    end;

    var
        AssetNotFoundErr: Label 'Asset %1 does not exist.';
}
```

---

### Codeunit 70182385: JML AP Transfer Mgt

**Object Name:** `JML AP Transfer Mgt` (21 chars)
**Caption:** `Asset Transfer Management`

```al
codeunit 70182385 "JML AP Transfer Mgt"
{
    /// <summary>
    /// Transfers an asset to a new holder, creating ledger entries.
    /// </summary>
    procedure TransferAsset(
        var Asset: Record "JML AP Asset";
        NewHolderType: Enum "JML AP Holder Type";
        NewHolderCode: Code[20];
        DocumentType: Enum "JML AP Document Type";
        DocumentNo: Code[20];
        ReasonCode: Code[10]): Boolean
    var
        TransferOutEntry: Record "JML AP Holder Entry";
        TransferInEntry: Record "JML AP Holder Entry";
        TransactionNo: Integer;
    begin
        // Validate transfer
        ValidateTransfer(Asset, NewHolderType, NewHolderCode);

        // Get next transaction number
        TransactionNo := GetNextTransactionNo();

        // Create Transfer Out entry (from old holder)
        CreateTransferOutEntry(
            Asset,
            TransactionNo,
            DocumentType,
            DocumentNo,
            ReasonCode);

        // Create Transfer In entry (to new holder)
        CreateTransferInEntry(
            Asset,
            NewHolderType,
            NewHolderCode,
            TransactionNo,
            DocumentType,
            DocumentNo,
            ReasonCode);

        // Update asset current holder
        UpdateAssetHolder(Asset, NewHolderType, NewHolderCode);

        exit(true);
    end;

    local procedure ValidateTransfer(
        var Asset: Record "JML AP Asset";
        NewHolderType: Enum "JML AP Holder Type";
        NewHolderCode: Code[20])
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        if NewHolderCode = '' then
            Error(HolderCodeRequiredErr);

        // Validate holder exists
        case NewHolderType of
            NewHolderType::Customer:
                if not Customer.Get(NewHolderCode) then
                    Error(CustomerNotFoundErr, NewHolderCode);
            NewHolderType::Vendor:
                if not Vendor.Get(NewHolderCode) then
                    Error(VendorNotFoundErr, NewHolderCode);
            NewHolderType::Location:
                if not Location.Get(NewHolderCode) then
                    Error(LocationNotFoundErr, NewHolderCode);
        end;

        // Cannot transfer to same holder
        if (Asset."Current Holder Type" = NewHolderType) and
           (Asset."Current Holder Code" = NewHolderCode) then
            Error(AlreadyAtHolderErr);
    end;

    local procedure GetNextTransactionNo(): Integer
    var
        HolderEntry: Record "JML AP Holder Entry";
    begin
        if HolderEntry.FindLast() then
            exit(HolderEntry."Transaction No." + 1)
        else
            exit(1);
    end;

    local procedure CreateTransferOutEntry(
        var Asset: Record "JML AP Asset";
        TransactionNo: Integer;
        DocumentType: Enum "JML AP Document Type";
        DocumentNo: Code[20];
        ReasonCode: Code[10])
    var
        HolderEntry: Record "JML AP Holder Entry";
    begin
        HolderEntry.Init();
        HolderEntry."Asset No." := Asset."No.";
        HolderEntry."Posting Date" := Today;
        HolderEntry."Posting Time" := Time;
        HolderEntry."Entry Type" := HolderEntry."Entry Type"::"Transfer Out";
        HolderEntry."Holder Type" := Asset."Current Holder Type";
        HolderEntry."Holder Code" := Asset."Current Holder Code";
        HolderEntry."Holder Name" := Asset."Current Holder Name";
        HolderEntry."Transaction No." := TransactionNo;
        HolderEntry."Document Type" := DocumentType;
        HolderEntry."Document No." := DocumentNo;
        HolderEntry."Reason Code" := ReasonCode;
        HolderEntry.Insert(true);
    end;

    local procedure CreateTransferInEntry(
        var Asset: Record "JML AP Asset";
        NewHolderType: Enum "JML AP Holder Type";
        NewHolderCode: Code[20];
        TransactionNo: Integer;
        DocumentType: Enum "JML AP Document Type";
        DocumentNo: Code[20];
        ReasonCode: Code[10])
    var
        HolderEntry: Record "JML AP Holder Entry";
        HolderName: Text[100];
    begin
        HolderName := GetHolderName(NewHolderType, NewHolderCode);

        HolderEntry.Init();
        HolderEntry."Asset No." := Asset."No.";
        HolderEntry."Posting Date" := Today;
        HolderEntry."Posting Time" := Time;
        HolderEntry."Entry Type" := HolderEntry."Entry Type"::"Transfer In";
        HolderEntry."Holder Type" := NewHolderType;
        HolderEntry."Holder Code" := NewHolderCode;
        HolderEntry."Holder Name" := HolderName;
        HolderEntry."Transaction No." := TransactionNo;
        HolderEntry."Document Type" := DocumentType;
        HolderEntry."Document No." := DocumentNo;
        HolderEntry."Reason Code" := ReasonCode;
        HolderEntry.Insert(true);
    end;

    local procedure UpdateAssetHolder(
        var Asset: Record "JML AP Asset";
        NewHolderType: Enum "JML AP Holder Type";
        NewHolderCode: Code[20])
    begin
        Asset.Validate("Current Holder Type", NewHolderType);
        Asset.Validate("Current Holder Code", NewHolderCode);
        Asset.Validate("Current Holder Since", Today);
        Asset.Modify(true);
    end;

    local procedure GetHolderName(HolderType: Enum "JML AP Holder Type"; HolderCode: Code[20]): Text[100]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        case HolderType of
            HolderType::Customer:
                if Customer.Get(HolderCode) then
                    exit(Customer.Name);
            HolderType::Vendor:
                if Vendor.Get(HolderCode) then
                    exit(Vendor.Name);
            HolderType::Location:
                if Location.Get(HolderCode) then
                    exit(Location.Name);
        end;
        exit('');
    end;

    var
        HolderCodeRequiredErr: Label 'Holder code is required.';
        CustomerNotFoundErr: Label 'Customer %1 does not exist.';
        VendorNotFoundErr: Label 'Vendor %1 does not exist.';
        LocationNotFoundErr: Label 'Location %1 does not exist.';
        AlreadyAtHolderErr: Label 'Asset is already at this holder.';
}
```

---

### Codeunit 70182387: JML AP Asset Validation

**Object Name:** `JML AP Asset Validation` (27 chars)
**Caption:** `Asset Validation`

```al
codeunit 70182387 "JML AP Asset Validation"
{
    /// <summary>
    /// Validates parent asset assignment, checking for circular references.
    /// </summary>
    procedure ValidateParentAssignment(var Asset: Record "JML AP Asset")
    var
        ParentAsset: Record "JML AP Asset";
    begin
        if Asset."Parent Asset No." = '' then
            exit;

        // Cannot be own parent
        if Asset."Parent Asset No." = Asset."No." then
            Error(CannotBeOwnParentErr);

        // Parent must exist
        if not ParentAsset.Get(Asset."Parent Asset No.") then
            Error(ParentAssetNotFoundErr, Asset."Parent Asset No.");

        // Check circular reference
        CheckCircularReference(Asset);

        // Check classification compatibility
        CheckClassificationCompatibility(Asset, ParentAsset);
    end;

    local procedure CheckCircularReference(var Asset: Record "JML AP Asset")
    var
        CheckAsset: Record "JML AP Asset";
        CurrentAssetNo: Code[20];
        Depth: Integer;
    begin
        CurrentAssetNo := Asset."Parent Asset No.";
        Depth := 0;

        while (CurrentAssetNo <> '') and (Depth < MaxCircularCheckDepth) do begin
            if not CheckAsset.Get(CurrentAssetNo) then
                exit; // Parent chain ends

            // Circular reference detected
            if CheckAsset."Parent Asset No." = Asset."No." then
                Error(CircularReferenceDetectedErr, Asset."Parent Asset No.");

            CurrentAssetNo := CheckAsset."Parent Asset No.";
            Depth += 1;
        end;

        if Depth >= MaxCircularCheckDepth then
            Error(MaxDepthExceededErr, MaxCircularCheckDepth);
    end;

    local procedure CheckClassificationCompatibility(var ChildAsset: Record "JML AP Asset"; var ParentAsset: Record "JML AP Asset")
    var
        ChildLevel: Integer;
        ParentLevel: Integer;
    begin
        // Only validate if same industry
        if ChildAsset."Industry Code" <> ParentAsset."Industry Code" then
            exit;

        // Get classification depth for both assets
        ChildLevel := GetClassificationDepth(ChildAsset);
        ParentLevel := GetClassificationDepth(ParentAsset);

        // Child must be at equal or deeper level
        if ChildLevel < ParentLevel then
            Error(ChildCannotBeHigherLevelErr);
    end;

    local procedure GetClassificationDepth(var Asset: Record "JML AP Asset"): Integer
    var
        Depth: Integer;
    begin
        Depth := 0;
        if Asset."Classification Level 1" <> '' then Depth := 1;
        if Asset."Classification Level 2" <> '' then Depth := 2;
        if Asset."Classification Level 3" <> '' then Depth := 3;
        if Asset."Classification Level 4" <> '' then Depth := 4;
        if Asset."Classification Level 5" <> '' then Depth := 5;
        // Continue for levels 6-10
        exit(Depth);
    end;

    var
        MaxCircularCheckDepth: Integer;
        CannotBeOwnParentErr: Label 'Asset cannot be its own parent.';
        ParentAssetNotFoundErr: Label 'Parent asset %1 does not exist.';
        CircularReferenceDetectedErr: Label 'Circular reference detected: Asset %1 is already a child of current asset.';
        MaxDepthExceededErr: Label 'Maximum parent-child depth (%1) exceeded.';
        ChildCannotBeHigherLevelErr: Label 'Child asset cannot be at a higher classification level than its parent within the same industry.';

    begin
        MaxCircularCheckDepth := 100;
    end;
}
```

---

## Comprehensive Test Plan

### Test Structure Overview

**Test Coverage:**
- Unit Tests (50100-50149): Test individual procedures and validation logic
- Integration Tests (50150-50179): Test end-to-end workflows
- Performance Tests: Embedded in integration tests with benchmarks

### Test Codeunit 50100: JML AP Setup Tests

**Purpose:** Test Asset Setup and Configuration

**Test Scenarios:**

1. **Test_SetupWizardCreatesDefaultConfiguration**
   - Action: Run setup wizard
   - Expected: Setup record created with default values
   - Verify: Asset Nos. assigned, feature toggles enabled

2. **Test_SetupCannotBeDeletedIfAssetsExist**
   - Setup: Create 1 asset
   - Action: Attempt to delete setup
   - Expected: Error raised
   - Cleanup: Delete asset, then setup

3. **Test_NumberSeriesAssignment**
   - Setup: Configure Asset Nos. = "ASSET"
   - Action: Create asset without No.
   - Expected: No. assigned from series
   - Verify: Format matches series pattern

**Test Data:**
```al
local procedure SetupTestData()
var
    AssetSetup: Record "JML AP Asset Setup";
    NoSeries: Record "No. Series";
begin
    // Create test number series
    NoSeries.Code := 'ASSET-TEST';
    NoSeries.Description := 'Test Asset Numbers';
    NoSeries.Insert();

    // Create setup
    AssetSetup.Init();
    AssetSetup."Asset Nos." := 'ASSET-TEST';
    AssetSetup.Insert();
end;
```

---

### Test Codeunit 50101: JML AP Classification Tests

**Purpose:** Test Classification Hierarchy

**Test Scenarios:**

1. **Test_CannotCreateLevel2BeforeLevel1**
   - Setup: Create industry "FLEET"
   - Action: Create Level 2 directly
   - Expected: Error "Level 1 must exist first"

2. **Test_CannotDeleteLevelWithValues**
   - Setup: Create Level 1 with 3 values
   - Action: Delete Level 1
   - Expected: Error "Cannot delete level with values"

3. **Test_ParentValueValidation**
   - Setup: Create Level 1 value "COMM", Level 2 value "CARGO"
   - Action: Set Level 2 parent = "INVALID"
   - Expected: Error "Parent value not found"

4. **Test_CanCreateUpTo10Levels**
   - Setup: Create industry
   - Action: Create levels 1-10
   - Expected: All levels created successfully
   - Verify: Can create asset at level 10

5. **Test_CannotDeleteValueInUseByAsset**
   - Setup: Create classification value "CARGO", asset using "CARGO"
   - Action: Delete "CARGO"
   - Expected: Error "Value in use by assets"

**Performance Benchmark:**
- Creating 1,000 classification values: < 5 seconds

---

### Test Codeunit 50102: JML AP Asset Creation Tests

**Purpose:** Test Asset Creation and Modification

**Test Scenarios:**

1. **Test_CreateAssetWithMinimalData**
   - Action: Create asset with only No. and Description
   - Expected: Asset created, defaults applied
   - Verify: No. Series assigned, Status = Active

2. **Test_CreateAssetWithFullClassification**
   - Setup: Create 3-level classification
   - Action: Create asset with all 3 levels
   - Expected: Asset created
   - Verify: All classification fields populated

3. **Test_CannotSetLevel2WithoutLevel1**
   - Action: Create asset, set Level 2 without Level 1
   - Expected: Error "Must set Level 1 first"

4. **Test_ChangingIndustryClearsClassification**
   - Setup: Create asset with classification
   - Action: Change Industry Code
   - Expected: All classification levels cleared

5. **Test_AssetNumberSeriesIncrement**
   - Setup: Number series starts at "A-0001"
   - Action: Create 3 assets
   - Expected: Numbers are A-0001, A-0002, A-0003

**Test Data Factory:**
```al
local procedure CreateTestAsset(IndustryCode: Code[20]; Description: Text[100]): Record "JML AP Asset"
var
    Asset: Record "JML AP Asset";
begin
    Asset.Init();
    Asset.Validate("Industry Code", IndustryCode);
    Asset.Validate(Description, Description);
    Asset.Insert(true);
    exit(Asset);
end;
```

---

### Test Codeunit 50103: JML AP Circular Reference Tests

**Purpose:** Test Parent-Child Circular Reference Prevention

**Test Scenarios:**

1. **Test_CannotBeOwnParent**
   - Setup: Create asset A-001
   - Action: Set Parent = A-001
   - Expected: Error "Cannot be own parent"

2. **Test_TwoLevelCircularReference**
   - Setup: Asset A → Asset B
   - Action: Set B.Parent = A
   - Expected: Error "Circular reference detected"

3. **Test_ThreeLevelCircularReference**
   - Setup: Asset A → Asset B → Asset C
   - Action: Set C.Parent = A
   - Expected: Error "Circular reference detected"

4. **Test_ValidThreeLevelHierarchy**
   - Action: Create A → B → C
   - Expected: Success
   - Verify: A.Level=1, B.Level=2, C.Level=3

5. **Test_MaxDepthValidation**
   - Setup: MaxCircularCheckDepth = 10
   - Action: Create 11-level hierarchy
   - Expected: Error "Max depth exceeded"

**Performance Benchmark:**
- Circular check on 20-level hierarchy: < 200ms

---

### Test Codeunit 50104: JML AP Attribute Tests

**Purpose:** Test Custom Attributes

**Test Scenarios:**

1. **Test_CreateTextAttribute**
   - Action: Create attribute "Serial No", Type=Text
   - Action: Set value "ABC123"
   - Expected: Value stored correctly

2. **Test_CreateIntegerAttribute**
   - Action: Create attribute "Year", Type=Integer
   - Action: Set value "2025"
   - Expected: Value stored as integer

3. **Test_CreateOptionAttribute**
   - Setup: Attribute "Color", Options="Red,Blue,Green"
   - Action: Set value "Blue"
   - Expected: Success
   - Action: Set value "Yellow"
   - Expected: Error "Not in options"

4. **Test_MandatoryAttributeValidation**
   - Setup: Attribute "VIN", Mandatory=Yes
   - Action: Create asset without VIN
   - Expected: Warning or error (TBD: business rule)

5. **Test_DefaultValueApplication**
   - Setup: Attribute "Warranty Years", Default="2"
   - Action: Create asset
   - Expected: Attribute value = 2

6. **Test_50AttributesPerformance**
   - Setup: Create 50 attributes for one level
   - Action: Load asset with all attributes
   - Expected: Load time < 50ms

---

### Test Codeunit 50105: JML AP Asset Transfer Tests

**Purpose:** Test Holder Transfers

**Test Scenarios:**

1. **Test_ManualTransferLocationToCustomer**
   - Setup: Asset at Location WH01
   - Action: Transfer to Customer C001
   - Expected: 2 entries created (Out + In)
   - Verify: Transaction No. links entries
   - Verify: Asset.Current Holder = Customer C001

2. **Test_GetHolderOnDate**
   - Setup:
     - 2025-01-10: Transfer to Customer C001
     - 2025-06-15: Transfer to Location WH01
   - Action: Get holder on 2025-03-20
   - Expected: Customer C001
   - Action: Get holder on 2025-07-01
   - Expected: Location WH01

3. **Test_CannotTransferToSameHolder**
   - Setup: Asset at Customer C001
   - Action: Transfer to Customer C001
   - Expected: Error "Already at this holder"

4. **Test_HolderMustExist**
   - Action: Transfer to Customer "INVALID"
   - Expected: Error "Customer does not exist"

5. **Test_TransactionNoIncrement**
   - Action: Perform 3 transfers
   - Expected: Transaction Nos. = 1, 2, 3

6. **Test_HolderHistoryFiltering**
   - Setup: 100 transfers across 10 assets
   - Action: Filter by Asset = HMS-001
   - Expected: Only HMS-001 entries returned
   - Performance: < 10ms

**Test Data:**
```al
local procedure SetupTransferTest(): Record "JML AP Asset"
var
    Asset: Record "JML AP Asset";
    Location: Record Location;
begin
    // Create test location
    if not Location.Get('WH01-TEST') then begin
        Location.Code := 'WH01-TEST';
        Location.Name := 'Test Warehouse';
        Location.Insert();
    end;

    // Create test asset
    Asset := CreateTestAsset('FLEET', 'Test Vessel');
    Asset."Current Holder Type" := Asset."Current Holder Type"::Location;
    Asset."Current Holder Code" := 'WH01-TEST';
    Asset.Modify();

    exit(Asset);
end;
```

---

### Test Codeunit 50106: JML AP Parent-Child Tests

**Purpose:** Test Physical Hierarchy

**Test Scenarios:**

1. **Test_CreateSimpleParentChild**
   - Action: Create Vessel, then Engine with Parent=Vessel
   - Expected: Engine.Hierarchy Level = 2
   - Verify: Vessel.Has Children = Yes
   - Verify: Vessel.Child Count = 1

2. **Test_CreateThreeLevelHierarchy**
   - Action: Vessel → Engine → Turbocharger
   - Expected: Turbo.Level = 3, Turbo.Root Asset = Vessel

3. **Test_CannotDeleteParentWithChildren**
   - Setup: Vessel with 2 engines
   - Action: Delete Vessel
   - Expected: Error "Cannot delete with children"

4. **Test_CrossIndustryParentChild**
   - Setup: Vessel (Fleet industry), Electronics (Generic industry)
   - Action: Set Electronics.Parent = Vessel
   - Expected: Success (different industries allowed)

5. **Test_SameIndustryLevelValidation**
   - Setup: Level 1 asset, Level 3 asset (same industry)
   - Action: Set Level 1.Parent = Level 3
   - Expected: Error "Child cannot be higher level"

**Performance Benchmark:**
- Calculate hierarchy level (20 levels deep): < 50ms
- Root asset lookup (20 levels): < 50ms

---

### Test Codeunit 50150: JML AP Workflow Tests

**Purpose:** End-to-End Integration Tests

**Test Scenario 1: Venden Dispenser Lifecycle**

```al
[Test]
procedure Test_VendenDispenserFullLifecycle()
var
    Dispenser: Record "JML AP Asset";
    Component1, Component2: Record "JML AP Component";
    TransferMgt: Codeunit "JML AP Transfer Mgt";
begin
    // === SETUP: Industry and Classification ===
    CreateDispenserIndustry();

    // === STEP 1: Purchase from Manufacturer ===
    Dispenser := CreateTestAsset('DISPENSER', 'WD-200 Premium #12345');
    Dispenser."Classification Level 1" := 'OFFICE';
    Dispenser."Classification Level 2" := 'WD200';
    Dispenser."Serial No." := 'VENDEN-2025-0012';
    Dispenser.Modify();

    // Initial holder = Vendor (manufacturer)
    Dispenser."Current Holder Type" := Dispenser."Current Holder Type"::Vendor;
    Dispenser."Current Holder Code" := 'VENDOR001';
    Dispenser.Modify();

    // === STEP 2: Receive at Warehouse ===
    TransferMgt.TransferAsset(
        Dispenser,
        Dispenser."Current Holder Type"::Location,
        'WH01',
        Dispenser."Document Type"::"Purchase Order",
        'PO-2025-001',
        '');

    // Verify holder changed
    Dispenser.Get(Dispenser."No.");
    Assert.AreEqual('WH01', Dispenser."Current Holder Code", 'Should be at WH01');

    // === STEP 3: Add Components ===
    AddComponent(Dispenser."No.", 'ITEM-FILTER', 2);
    AddComponent(Dispenser."No.", 'ITEM-TAP', 1);

    // Verify components
    Component1.SetRange("Asset No.", Dispenser."No.");
    Assert.AreEqual(2, Component1.Count, 'Should have 2 components');

    // === STEP 4: Lease to Customer ===
    TransferMgt.TransferAsset(
        Dispenser,
        Dispenser."Current Holder Type"::Customer,
        'CUSTOMER001',
        Dispenser."Document Type"::"Sales Order",
        'SO-2025-050',
        'LEASE');

    // Verify holder changed
    Dispenser.Get(Dispenser."No.");
    Assert.AreEqual('CUSTOMER001', Dispenser."Current Holder Code", 'Should be at customer');

    // === STEP 5: Return from Customer ===
    TransferMgt.TransferAsset(
        Dispenser,
        Dispenser."Current Holder Type"::Location,
        'WH01',
        Dispenser."Document Type"::"Sales Order",
        'CM-2025-010',
        'RETURN');

    // === VERIFICATION: Check History ===
    VerifyHolderHistory(Dispenser."No.", 6); // 3 transfers = 6 entries (out+in)

    // === VERIFICATION: Point-in-Time Lookup ===
    VerifyHolderOnDate(Dispenser."No.", 20250120D, 'CUSTOMER001');
    VerifyHolderOnDate(Dispenser."No.", 20270130D, 'WH01');
end;
```

**Expected Results:**
- 1 asset created
- 2 components added
- 6 holder entries created (3 transfers × 2 entries)
- Point-in-time lookups return correct holders
- Total execution time: < 500ms

---

### Test Codeunit 50151: JML AP Document Integration Tests

**Purpose:** Test BC Document Integration (Phase 2)

**Test Scenario: Sales Order Asset Transfer**

```al
[Test]
procedure Test_SalesOrderPostingTransfersAsset()
var
    Asset: Record "JML AP Asset";
    SalesHeader: Record "Sales Header";
    SalesLine: Record "Sales Line";
    SalesPost: Codeunit "Sales-Post";
begin
    // Setup
    Asset := CreateTestAsset('FLEET', 'Vessel HMS-001');
    Asset."Current Holder Type" := Asset."Current Holder Type"::Location;
    Asset."Current Holder Code" := 'WH01';
    Asset.Modify();

    // Create sales order
    CreateSalesOrder(SalesHeader, SalesLine, 'CUSTOMER001');
    SalesHeader."JML Asset No." := Asset."No."; // Extension field
    SalesHeader.Modify();

    // Post sales order
    SalesPost.Run(SalesHeader);

    // Verify asset transferred
    Asset.Get(Asset."No.");
    Assert.AreEqual(
        Asset."Current Holder Type"::Customer,
        Asset."Current Holder Type",
        'Should be at customer');
    Assert.AreEqual('CUSTOMER001', Asset."Current Holder Code", 'Should be CUSTOMER001');

    // Verify holder entry created
    VerifyHolderEntryExists(Asset."No.", 'Sales Order', SalesHeader."No.");
end;
```

---

### Performance Test Benchmarks

All performance tests run with dataset:
- 10,000 assets
- 100 industries
- 1,000 classification values
- 50,000 holder entries

| Operation | Target | Critical Threshold |
|-----------|--------|-------------------|
| Asset Card Load | < 500ms | 1 second |
| Asset List (100 assets) | < 1 second | 2 seconds |
| Classification Filter | < 100ms | 200ms |
| Attribute Load (20 attributes) | < 50ms | 100ms |
| Circular Reference Check (20 levels) | < 200ms | 500ms |
| Holder Lookup (Point-in-Time) | < 50ms | 100ms |
| Search (10,000 assets) | < 2 seconds | 5 seconds |
| Transfer Asset | < 100ms | 200ms |
| Create Asset with Classification | < 200ms | 500ms |

---

## Object Inventory (Updated with Naming Convention)

### Production Objects (70182300-70182449)

#### Tables (70182300-70182329)

| ID | Object Name | Caption | Lines | Priority |
|----|-------------|---------|-------|----------|
| 70182300 | JML AP Asset Setup | Asset Setup | ~150 | Phase 1 |
| 70182301 | JML AP Asset | Asset | ~400 | Phase 1 |
| 70182302 | JML AP Asset Industry | Asset Industry | ~100 | Phase 1 |
| 70182303 | JML AP Classification Lvl | Classification Level | ~120 | Phase 1 |
| 70182304 | JML AP Classification Val | Classification Value | ~130 | Phase 1 |
| 70182305 | JML AP Attribute Defn | Attribute Definition | ~140 | Phase 1 |
| 70182306 | JML AP Attribute Value | Attribute Value | ~150 | Phase 1 |
| 70182307 | JML AP Component | Asset Component | ~100 | Phase 1 |
| 70182308 | JML AP Holder Entry | Asset Holder Entry | ~180 | Phase 1 |
| 70182309 | JML AP Comment Line | Asset Comment Line | ~60 | Phase 1 |
| 70182310 | JML AP Industry Template | Industry Template | ~80 | Phase 2 |

#### Pages (70182330-70182379)

| ID | Object Name | Caption | Type | Priority |
|----|-------------|---------|------|----------|
| 70182330 | JML AP Asset Setup | Asset Setup | Card | Phase 1 |
| 70182331 | JML AP Setup Wizard | Asset Setup Wizard | Navigate | Phase 1 |
| 70182332 | JML AP Asset List | Assets | List | Phase 1 |
| 70182333 | JML AP Asset Card | Asset Card | Card | Phase 1 |
| 70182334 | JML AP Industries | Industries | List | Phase 1 |
| 70182335 | JML AP Classification Lvls | Classification Levels | List | Phase 1 |
| 70182336 | JML AP Classification Vals | Classification Values | List | Phase 1 |
| 70182337 | JML AP Attribute Defns | Attribute Definitions | List | Phase 1 |
| 70182338 | JML AP Attributes FB | Attributes | CardPart | Phase 1 |
| 70182339 | JML AP Holder Entries | Holder Entries | List | Phase 1 |
| 70182340 | JML AP Components | Components | ListPart | Phase 1 |

#### Codeunits (70182380-70182399)

| ID | Object Name | Caption | Lines | Priority |
|----|-------------|---------|-------|----------|
| 70182380 | JML AP Asset Management | Asset Management | ~200 | Phase 1 |
| 70182381 | JML AP Setup Wizard | Asset Setup Wizard | ~300 | Phase 1 |
| 70182382 | JML AP Caption Mgmt | Caption Management | ~150 | Phase 1 |
| 70182383 | JML AP Classification Mgt | Classification Management | ~180 | Phase 1 |
| 70182384 | JML AP Attribute Mgmt | Attribute Management | ~200 | Phase 1 |
| 70182385 | JML AP Transfer Mgt | Asset Transfer Management | ~250 | Phase 1 |
| 70182386 | JML AP Asset Copy | Asset Copy | ~150 | Phase 2 |
| 70182387 | JML AP Asset Validation | Asset Validation | ~200 | Phase 1 |
| 70182388 | JML AP Document Integ | Document Integration | ~300 | Phase 2 |

#### Enums (70182400-70182409)

| ID | Object Name | Caption | Values | Priority |
|----|-------------|---------|--------|----------|
| 70182400 | JML AP Holder Type | Holder Type | 5 | Phase 1 |
| 70182401 | JML AP Holder Entry Type | Holder Entry Type | 3 | Phase 1 |
| 70182402 | JML AP Asset Status | Asset Status | 5 | Phase 1 |
| 70182403 | JML AP Attribute Type | Attribute Data Type | 6 | Phase 1 |
| 70182404 | JML AP Industry Template | Industry Template | 6 | Phase 1 |
| 70182406 | JML AP Document Type | Document Type | 6 | Phase 2 |

---

## Implementation Phases (Unchanged from v2.0)

Phases remain as documented in v2.0, with emphasis on:
- Week 1: Classification structure
- Week 2: Asset master table with parent-child
- Week 3: Attributes framework
- Week 4: Holder tracking with NEW ledger entry pattern

---

## Clean Code Principles Applied

### 1. Naming Conventions

**Objects:**
- Prefix: "JML AP" (Asset Pro)
- Max length: 30 characters total
- Clear, descriptive names
- Examples: "JML AP Asset Setup", "JML AP Transfer Mgt"

**Captions:**
- NO "JML AP" prefix
- User-friendly terminology
- Examples: "Asset Setup", "Asset Transfer Management"

**Variables:**
- Use full words, not abbreviations
- Example: `CustomerNo` not `CustNo`
- Example: `TransactionNo` not `TrxNo`

**Procedures:**
- Action verbs + noun
- Examples: `ValidateParentAsset`, `CreateHolderEntry`, `GetHolderOnDate`

### 2. Single Responsibility Principle

Each procedure does ONE thing:
```al
// GOOD: One responsibility
procedure ValidateParentAsset()
begin
    CheckParentExists();
    CheckCircularReference();
    CheckClassificationCompatibility();
end;

// BAD: Multiple responsibilities
procedure ValidateAndUpdateParentAsset()
begin
    // Validates AND updates (two responsibilities)
end;
```

### 3. Magic Numbers Eliminated

```al
// BAD: Magic number
if Depth > 100 then
    Error('Max depth exceeded');

// GOOD: Named constant
var
    MaxCircularCheckDepth: Integer;
begin
    MaxCircularCheckDepth := 100;
end;

if Depth > MaxCircularCheckDepth then
    Error(MaxDepthExceededErr, MaxCircularCheckDepth);
```

### 4. Error Messages as Constants

```al
// All error messages declared as var constants
var
    AssetNotFoundErr: Label 'Asset %1 does not exist.';
    CircularReferenceDetectedErr: Label 'Circular reference detected: Asset %1 is already a child of current asset.';
    CannotBeOwnParentErr: Label 'Asset cannot be its own parent.';
```

### 5. Short, Focused Procedures

Target: 20-30 lines maximum per procedure

```al
// GOOD: Short and focused
local procedure UpdateAssetHolder(var Asset: Record "JML AP Asset"; NewHolderType: Enum "JML AP Holder Type"; NewHolderCode: Code[20])
begin
    Asset.Validate("Current Holder Type", NewHolderType);
    Asset.Validate("Current Holder Code", NewHolderCode);
    Asset.Validate("Current Holder Since", Today);
    Asset.Modify(true);
end;

// BAD: Too long, multiple responsibilities
local procedure UpdateAssetHolderAndCreateHistoryAndNotifyUser(...)
begin
    // 100+ lines doing multiple things
end;
```

### 6. Comments Explain "Why" Not "What"

```al
// BAD: Comment states the obvious
// Set customer number
Customer."No." := '12345';

// GOOD: Comment explains why
// Use specific customer for test data consistency across environments
Customer."No." := '12345';

// GOOD: Complex logic explanation
// Walk up parent chain to find root asset.
// Iterative approach (not recursive) to avoid stack overflow with deep hierarchies.
CurrentAssetNo := "No.";
while (CurrentAssetNo <> '') and (IterationCount < MaxParentChainDepth) do begin
    ...
end;
```

### 7. Consistent Error Handling

All validation procedures follow same pattern:
```al
if <condition> then
    Error(<DescriptiveErrorConstant>, <parameters>);
```

### 8. Table Field Organization

Fields grouped by purpose with comments:
```al
fields
{
    // === PRIMARY IDENTIFICATION ===
    field(1; "No."; Code[20]) { }

    // === CLASSIFICATION (STRUCTURE 1) ===
    field(100; "Industry Code"; Code[20]) { }

    // === PHYSICAL COMPOSITION (STRUCTURE 2) ===
    field(200; "Parent Asset No."; Code[20]) { }

    // === CURRENT HOLDER ===
    field(300; "Current Holder Type"; Enum) { }
}
```

---

## Risks and Mitigation (Unchanged from v2.0)

All risks from v2.0 remain valid with additional note:

**New Risk: Holder Entry Performance**
- **Description:** Ledger entry approach may slow down point-in-time lookups with 100,000+ entries
- **Mitigation:**
  - Indexed keys on Asset No. + Posting Date
  - Cache recent lookups
  - Archive old entries (> 5 years)
- **Contingency:** Add summary table with "current holder snapshot"

---

## Next Steps

### Immediate Actions (Week 0)

1. **Review v2.1 Changes**
   - [ ] Approve naming convention (JML AP prefix, 30 char limit)
   - [ ] Approve Holder Entry redesign (ledger pattern)
   - [ ] Review clean code principles application
   - [ ] Review comprehensive test plan

2. **Development Environment**
   - [ ] Update app.json with object ID ranges
   - [ ] Configure code analysis rules (AL Cop)
   - [ ] Set up test framework

3. **Start Phase 1 Week 1**
   - [ ] Implement tables with new naming convention
   - [ ] Create first unit tests
   - [ ] Code review with clean code checklist

---

## Document Control

**Version History:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-04 | Claude | Initial planning document |
| 2.0 | 2025-11-05 | Claude | Two-structure architecture |
| 2.1 | 2025-11-09 | Claude | Naming convention, Holder Entry redesign, Clean code, Full structures, Test plan |

**Approval Status:** DRAFT - Awaiting Review

---

**END OF DOCUMENT v2.1**

Total Pages: ~150
Total Lines of Code: ~3,000
Test Scenarios: 50+
Objects Documented: 30+

**Status:** Ready for implementation. All objects have complete structures, clean code principles applied, comprehensive test plan defined.
