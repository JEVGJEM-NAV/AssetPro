table 70182305 "JML AP Attribute Defn"
{
    Caption = 'Attribute Definition';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            ToolTip = 'Specifies the industry this attribute belongs to.';
            TableRelation = "JML AP Asset Industry";
            NotBlank = true;
        }

        field(2; "Level Number"; Integer)
        {
            Caption = 'Level Number';
            ToolTip = 'Specifies the classification level this attribute applies to (0 = all levels).';
            TableRelation = "JML AP Classification Lvl"."Level Number" where("Industry Code" = field("Industry Code"));
        }

        field(3; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            ToolTip = 'Specifies the unique code for this attribute.';
            NotBlank = true;
        }

        field(10; "Attribute Name"; Text[50])
        {
            Caption = 'Attribute Name';
            ToolTip = 'Specifies the name of the attribute.';
            NotBlank = true;
        }

        field(20; "Data Type"; Enum "JML AP Attribute Type")
        {
            Caption = 'Data Type';
            ToolTip = 'Specifies the data type of the attribute.';
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
            ToolTip = 'Specifies comma-separated values for Option type attributes.';

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
            ToolTip = 'Specifies whether this attribute is mandatory.';
        }

        field(31; "Default Value"; Text[250])
        {
            Caption = 'Default Value';
            ToolTip = 'Specifies the default value for the attribute.';

            trigger OnValidate()
            begin
                ValidateDefaultValue();
            end;
        }

        field(40; "Display Order"; Integer)
        {
            Caption = 'Display Order';
            ToolTip = 'Specifies the display order of the attribute.';
        }

        field(50; "Help Text"; Text[250])
        {
            Caption = 'Help Text';
            ToolTip = 'Specifies help text for the attribute.';
        }

        field(100; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies whether this attribute is blocked from use.';
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
