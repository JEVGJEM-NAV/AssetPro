page 70182338 "JML AP Attributes FB"
{
    Caption = 'Attributes';
    PageType = ListPart;
    SourceTable = "JML AP Attribute Value";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Attributes)
            {
                field("Attribute Code"; Rec."Attribute Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the attribute code.';
                }
                field("Value Text"; Rec."Value Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the text value.';
                }
            }
        }
    }
}
