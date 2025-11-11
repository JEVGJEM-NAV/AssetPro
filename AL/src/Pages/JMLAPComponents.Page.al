page 70182340 "JML AP Components"
{
    Caption = 'Components';
    PageType = ListPart;
    SourceTable = "JML AP Component";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Components)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position.';
                }
            }
        }
    }
}
