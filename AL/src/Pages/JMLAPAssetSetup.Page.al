page 70182330 "JML AP Asset Setup"
{
    Caption = 'Asset Setup';
    PageType = Card;
    SourceTable = "JML AP Asset Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Asset Nos."; Rec."Asset Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for assets.';
                }
                field("Default Industry Code"; Rec."Default Industry Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default industry code for new assets.';
                }
            }

            group(Features)
            {
                Caption = 'Features';

                field("Enable Attributes"; Rec."Enable Attributes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether custom attributes are enabled.';
                }
                field("Enable Holder History"; Rec."Enable Holder History")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether holder history tracking is enabled.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
