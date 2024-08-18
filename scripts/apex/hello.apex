// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// List <Opportunity> opps = [SELECT AccountId, Id, Primary_Contact__c FROM Opportunity WHERE Primary_Contact__c = null];
// System.debug(opps);

List<Opportunity> opps = new List<Opportunity>();
opps.add(new Opportunity(Name = 'Test Opp 4', CloseDate = Date.newInstance(2022, 10, 25), Amount = 10000, StageName = 'Closed Won'));
opps.add(new Opportunity(Name = 'Test Opp 5', CloseDate = Date.newInstance(2022, 10, 25), Amount = 10000, StageName = 'Closed Won'));
opps.add(new Opportunity(Name = 'Test Opp 6', CloseDate = Date.newInstance(2022, 10, 25), Amount = 10000, StageName = 'Closed Won'));

// Insert Opps
insert opps;