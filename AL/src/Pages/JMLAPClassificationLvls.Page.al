page 70182335 "JML AP Classification Lvls"
{
    Caption = 'Classification Levels';
    PageType = List;
    SourceTable = "JML AP Classification Lvl";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Levels)
            {
                field("Industry Code"; Rec."Industry Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the industry code.';
                }
                field("Level Number"; Rec."Level Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level number.';
                }
                field("Level Name"; Rec."Level Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the level name.';
                }
                field("Level Name Plural"; Rec."Level Name Plural")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the plural level name.';
                }
                field("Use in Lists"; Rec."Use in Lists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to use in lists.';
                }
            }
        }
    }
}
