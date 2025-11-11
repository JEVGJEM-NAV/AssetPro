table 70182309 "JML AP Comment Line"
{
    Caption = 'Asset Comment Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            ToolTip = 'Specifies which table this comment relates to.';
            OptionMembers = Asset,"Holder Entry";
            OptionCaption = 'Asset,Holder Entry';
        }

        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the record number.';
            TableRelation = if ("Table Name" = const(Asset)) "JML AP Asset";
            NotBlank = true;
        }

        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number.';
            NotBlank = true;
        }

        field(10; Date; Date)
        {
            Caption = 'Date';
            ToolTip = 'Specifies the date of the comment.';
        }

        field(20; Comment; Text[250])
        {
            Caption = 'Comment';
            ToolTip = 'Specifies the comment text.';
        }

        field(30; "User ID"; Code[50])
        {
            Caption = 'User ID';
            ToolTip = 'Specifies who created the comment.';
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
