Id oppId = '006aj0000010W8NAAU';
List<OpportunityLineItem> olis = [SELECT Id, Name, Quantity, UnitPrice, OpportunityID, PriceBookEntryID
                                    FROM OpportunityLineItem
                                    WHERE OpportunityId = :oppId];

List<OpportunityLineItem> clonedOLis = new List<OpportunityLineItem>();
for (OpportunityLineItem oli : olis) {
OpportunityLineItem newOli = oli.clone(false, false, false, false);
//newOli.Quantity = oli.Quantity;
newOli.UnitPRice = oli.UnitPrice + 1337;
//newOli.OpportunityId = oli.OpportunityId;
//newOli.PricebookEntryId = oli.PricebookEntryId;
clonedOLis.add(newOli);
}

insert clonedOLis;