table 70182307 "JML AP Component"
{
    Caption = 'Asset Component';
    DataClassification = CustomerContent;
    LookupPageId = "JML AP Components";
    DrillDownPageId = "JML AP Components";

    fields
    {
        // === PRIMARY KEY ===
        field(1; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            ToolTip = 'Specifies the asset number.';
            TableRelation = "JML AP Asset";
            NotBlank = true;
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number.';
            NotBlank = true;
        }

        // === ITEM INFORMATION ===
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            ToolTip = 'Specifies the item number.';
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
            ToolTip = 'Specifies the item description.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }

        field(12; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            ToolTip = 'Specifies the variant code.';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }

        // === QUANTITY ===
        field(20; Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Specifies the quantity (positive for Install/Add, negative for Remove).';
            DecimalPlaces = 0:5;
        }

        field(21; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            ToolTip = 'Specifies the unit of measure code.';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }

        // === PHYSICAL DETAILS ===
        field(30; Position; Text[50])
        {
            Caption = 'Position';
            ToolTip = 'Specifies the physical location within the asset (e.g., "Front Panel", "Engine Bay").';
        }

        field(40; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            ToolTip = 'Specifies the serial number for serialized components.';
        }

        field(41; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            ToolTip = 'Specifies the lot number.';
        }

        // === DATES ===
        field(50; "Installation Date"; Date)
        {
            Caption = 'Installation Date';
            ToolTip = 'Specifies the installation date.';
        }

        field(51; "Next Replacement Date"; Date)
        {
            Caption = 'Next Replacement Date';
            ToolTip = 'Specifies the next scheduled replacement date.';
        }

        // === DOCUMENT TRACKING ===
        field(60; "Document Type"; Enum "JML AP Document Type")
        {
            Caption = 'Document Type';
            ToolTip = 'Specifies the document type.';
        }

        field(61; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            ToolTip = 'Specifies the document number.';
        }

        field(62; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            ToolTip = 'Specifies the document line number.';
        }

        field(63; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date.';
        }

        field(64; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            ToolTip = 'Specifies the external document number.';
        }

        // === ENTRY TYPE ===
        field(70; "Entry Type"; Enum "JML AP Component Entry Type")
        {
            Caption = 'Entry Type';
            ToolTip = 'Specifies the entry type (Install, Remove, Replace, Adjustment).';
        }

        field(71; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            ToolTip = 'Specifies the reason code.';
            TableRelation = "Reason Code";
        }

        // === SYSTEM ===
        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies whether the component is blocked.';
        }

        field(110; "Created Date"; Date)
        {
            Caption = 'Created Date';
            ToolTip = 'Specifies the date when the record was created.';
            Editable = false;
        }

        field(111; "Created By"; Code[50])
        {
            Caption = 'Created By';
            ToolTip = 'Specifies who created the record.';
            Editable = false;
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
        key(Document; "Document Type", "Document No.", "Document Line No.")
        {
        }
        key(Installation; "Installation Date")
        {
        }
    }

    trigger OnInsert()
    begin
        "Created Date" := Today;
        "Created By" := CopyStr(UserId, 1, MaxStrLen("Created By"));
    end;

    local procedure GetItemDefaults()
    var
        Item: Record Item;
    begin
        if Item.Get("Item No.") then begin
            if "Unit of Measure Code" = '' then
                "Unit of Measure Code" := Item."Base Unit of Measure";
            CalcFields("Item Description");
        end;
    end;
}
