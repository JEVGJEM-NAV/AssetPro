page 70182332 "JML AP Asset List"
{
    Caption = 'Assets';
    PageType = List;
    SourceTable = "JML AP Asset";
    CardPageId = "JML AP Asset Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Assets)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the asset.';
                }
                field("Industry Code"; Rec."Industry Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the industry code.';
                }
                field("Classification Code"; Rec."Classification Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the classification code.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the asset.';
                }
                field("Current Holder Type"; Rec."Current Holder Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current holder type.';
                }
                field("Current Holder Code"; Rec."Current Holder Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current holder code.';
                }
                field("Current Holder Name"; Rec."Current Holder Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current holder name.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(HolderHistory)
            {
                ApplicationArea = All;
                Caption = 'Holder History';
                ToolTip = 'View the holder history for this asset.';
                Image = History;
                RunObject = page "JML AP Holder Entries";
                RunPageLink = "Asset No." = field("No.");
            }
        }
        area(Processing)
        {
            action(TransferAsset)
            {
                ApplicationArea = All;
                Caption = 'Transfer Asset';
                ToolTip = 'Transfer this asset to a new holder.';
                Image = TransferOrder;

                trigger OnAction()
                begin
                    Message('Transfer functionality will be implemented via page extension.');
                end;
            }
        }
    }
}
