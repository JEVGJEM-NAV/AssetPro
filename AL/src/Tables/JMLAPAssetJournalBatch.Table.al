table 70182311 "JML AP Asset Journal Batch"
{
    Caption = 'Asset Journal Batch';
    DataClassification = CustomerContent;
    LookupPageId = "JML AP Asset Journal Batches";
    DrillDownPageId = "JML AP Asset Journal Batches";

    fields
    {
        field(1; "Name"; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(3; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }

        field(10; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    if "No. Series" = "Posting No. Series" then
                        Error(NoSeriesSameErr, FieldCaption("No. Series"), FieldCaption("Posting No. Series"));
                end;
            end;
        }

        field(11; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    if "Posting No. Series" = "No. Series" then
                        Error(NoSeriesSameErr, FieldCaption("Posting No. Series"), FieldCaption("No. Series"));
                end;
            end;
        }
    }

    keys
    {
        key(PK; "Name")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        AssetJnlLine: Record "JML AP Asset Journal Line";
    begin
        AssetJnlLine.SetRange("Journal Batch Name", Name);
        AssetJnlLine.DeleteAll(true);
    end;

    var
        NoSeriesSameErr: Label '%1 and %2 must be different.';
}
