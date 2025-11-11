enum 70182402 "JML AP Asset Status"
{
    Caption = 'Asset Status';
    Extensible = true;

    value(0; Active)
    {
        Caption = 'Active';
    }
    value(1; Inactive)
    {
        Caption = 'Inactive';
    }
    value(2; Maintenance)
    {
        Caption = 'Maintenance';
    }
    value(3; Decommissioned)
    {
        Caption = 'Decommissioned';
    }
    value(4; "In Transit")
    {
        Caption = 'In Transit';
    }
}
