table 70182306 "JML AP Attribute Value"
{
    Caption = 'Attribute Value';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            ToolTip = 'Specifies the asset number.';
            TableRelation = "JML AP Asset";
            NotBlank = true;
        }

        field(2; "Attribute Code"; Code[20])
        {
            Caption = 'Attribute Code';
            ToolTip = 'Specifies the attribute code.';
            NotBlank = true;
        }

        // Value storage fields (only one is used based on data type)
        field(10; "Value Text"; Text[250])
        {
            Caption = 'Value Text';
            ToolTip = 'Specifies the text value.';
        }

        field(11; "Value Integer"; Integer)
        {
            Caption = 'Value Integer';
            ToolTip = 'Specifies the integer value.';
        }

        field(12; "Value Decimal"; Decimal)
        {
            Caption = 'Value Decimal';
            ToolTip = 'Specifies the decimal value.';
            DecimalPlaces = 0:5;
        }

        field(13; "Value Date"; Date)
        {
            Caption = 'Value Date';
            ToolTip = 'Specifies the date value.';
        }

        field(14; "Value Boolean"; Boolean)
        {
            Caption = 'Value Boolean';
            ToolTip = 'Specifies the boolean value.';
        }

        // FlowFields for display
        field(100; "Attribute Name"; Text[50])
        {
            Caption = 'Attribute Name';
            ToolTip = 'Specifies the attribute name.';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Attribute Defn"."Attribute Name"
                where("Attribute Code" = field("Attribute Code")));
            Editable = false;
        }

        field(101; "Data Type"; Enum "JML AP Attribute Type")
        {
            Caption = 'Data Type';
            ToolTip = 'Specifies the data type.';
            FieldClass = FlowField;
            CalcFormula = Lookup("JML AP Attribute Defn"."Data Type"
                where("Attribute Code" = field("Attribute Code")));
            Editable = false;
        }

        field(102; "Option String"; Text[250])
        {
            Caption = 'Option String';
            ToolTip = 'Specifies the option string.';
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
            for i := 1 to Options.Count do
                if "Value Text" = Options.Get(i).Trim() then
                    OptionFound := true;

            if not OptionFound then
                Error(ValueNotInOptionStringErr, "Value Text", "Option String");
        end;
    end;

    var
        InvalidIntegerValueErr: Label '%1 is not a valid integer value.', Comment = '%1 = Invalid value text';
        InvalidDecimalValueErr: Label '%1 is not a valid decimal value.', Comment = '%1 = Invalid value text';
        InvalidDateValueErr: Label '%1 is not a valid date value.', Comment = '%1 = Invalid value text';
        InvalidBooleanValueErr: Label '%1 is not a valid boolean value. Use true or false.', Comment = '%1 = Invalid value text';
        ValueNotInOptionStringErr: Label 'Value %1 is not in the allowed options: %2', Comment = '%1 = Invalid value, %2 = Valid options';
}
