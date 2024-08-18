public with sharing class OpportunityTriggerHandler {

    public static void amountValidation(List<Opportunity> opps){
if (Trigger.isUpdate && Trigger.isBefore){
    for(Opportunity opp : opps){
        if(opp.Amount < 5000){
        opp.addError('Opportunity amount must be greater than 5000');
        }
    }
    }
    }

    public static void deleteCloseWonOpportunity(List<Opportunity> opps){
           
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id IN :Trigger.old)]);
        for(Opportunity opp : opps){
            if(opp.StageName == 'Closed Won'){
                if(accounts.get(opp.AccountId).Industry == 'Banking'){
                    opp.addError('Cannot delete closed opportunity');
                    }
                }
            }
           
        }

        public static void setPrimaryContact(Map<ID, Opportunity> Map1){

           if (Trigger.isBefore && Trigger.isUpdate){  
                
                //Get contacts related to the opportunity account
                Set<Id> accountIds = new Set<Id>();
                for(Opportunity opp : Map1.values()){
                    
                    accountIds.add(opp.AccountId);
                }
                
                Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, FirstName, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' ORDER BY FirstName ASC]);
                Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();
        
                for (Contact cont : contacts.values()) {
                    
                    if (!accountIdToContact.containsKey(cont.AccountId)) {
                        accountIdToContact.put(cont.AccountId, cont);
                    }
                }
        
                for(Opportunity opp : Map1.values()){
                    
                    if(opp.Primary_Contact__c == null){
                        if (accountIdToContact.containsKey(opp.AccountId)){
                            opp.Primary_Contact__c = accountIdToContact.get(opp.AccountId).Id;
                        }
                    }
                } 
        }  
        }

public static void setType(List<Opportunity> opps){
     // Set default Type for new Opportunities
     System.debug('the SetType method is starting to run');
       for( Opportunity opp : opps){
        if (opp.Type == null){
            opp.Type = 'New Customer';
        }    
    }
}
//}

public static void validateCloseOpportunity(List<Opportunity> opps){

         // Prevent deletion of closed Opportunities
            for (Opportunity oldOpp : opps){
                if (oldOpp.IsClosed){
                    oldOpp.addError('Cannot delete closed opportunity');
                }
            }
        }
        

public static void updateDescriptionFromStage(List<Opportunity> opps){
            //if (Trigger.isUpdate && trigger.isBefore){ // this trigger logic doesn't need to be here so it should be removed. It should be in OpportunityTrigger only.
            System.debug('the updateDescriptionFromStage method has started');
                        // Append Stage changes in Opportunity Description
                        List <Opportunity> oppsToUpdate = new List<Opportunity>();
                        for (Opportunity opp : opps){
                            //for (Opportunity oldOpp : oppsToUpdate){ // this for loop was causing confusion... so commented it out. This was looping through an empty loop.
                            System.debug('the for loop in the updateDescriptionFromStage method has started');
                                if (opp.StageName != null){  
                                    opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();  // this line updates the local variable - it is before update
                                    //oppsToUpdate.add(opp.Description); // experimenting by adding this line to support the update DML statement at the end
                                System.debug('The opp.Description contains: ' + opp.Description);    
                                }
                            //}                
                        }
                        System.debug('the opps List contains: ' + opps);
                       // update opps; // DML statement line is not needed because this is a BEFORE UPDATE context. We don't want to do a DML statement here because it will
                       // cause an infinite loop. The conclusion: When using any BEFORE situation, no DML statement is needed at the END. DML statements are needed for AFTER UPDATE trigger.
                       
            }
        //}


        //assignPrimaryContact:
        //- Assigns a primary contact with the title of 'VP Sales' to undeleted Opportunities.
        //- Only updates the Opportunities that don't already have a primary contact.
        
        public static void assignPrimaryContact(Map<Id,Opportunity> oppNewMap) {  // ok
            System.debug('the assignPrimaryContact method has started!!!');       
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
            Set<Id> oppAccountIDs = new Set<Id>();
            for (Opportunity opp : oppNewMap.values()){
                oppAccountIDs.add(opp.AccountId);
            }
            List<Contact> primaryContacts = [SELECT Id, AccountId FROM Contact WHERE Title = 'VP Sales' AND AccountId IN :oppAccountIDs];
            Map<Id, Contact> accountIDToContactMap = new Map<ID, Contact>();
            for (Contact cont : primaryContacts){
                accountIDToContactMap.put(cont.AccountId, cont);
            }

            for (Opportunity opp : oppNewMap.values()){      
                if (opp.Primary_Contact__c == null){
                    Opportunity oppToUpdate = new Opportunity(Id = opp.Id);
                    Contact primaryContact = accountIDToContactMap.get(opp.AccountId);
                    oppToUpdate.Primary_Contact__c = primaryContact.Id;
                    oppMap.put(opp.Id, oppToUpdate);
                }
            }
            
            update oppMap.values();
        }
    

        public static void insertTask(List<Opportunity> opps){
        System.debug('the insertTask method has started');
        List<Task> taskList = new List<Task>();
           // Create a new Task for newly inserted Opportunities
                for (Opportunity opp : opps){
                    Task tsk = new Task();
                    tsk.Subject = 'Call Primary Contact';
                    tsk.WhatId = opp.Id;
                    tsk.WhoId = opp.Primary_Contact__c;
                    tsk.OwnerId = opp.OwnerId;
                    tsk.ActivityDate = Date.today().addDays(3);
                    taskList.add(tsk);  
                }
                insert taskList;
            }

    }