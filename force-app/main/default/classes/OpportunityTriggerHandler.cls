public with sharing class OpportunityTriggerHandler {

    public static void amountValidation(List<Opportunity> opps){
if (Trigger.isUpdate && Trigger.isBefore){
    for(Opportunity opp : opps){
    System.debug('you are inside the for loop of the amountValidation method!!!');
        if(opp.Amount < 5000){
            opp.addError('Opportunity amount must be greater than 5000');
        }
    }
    }
    }

    public static void deleteCloseWonOpportunity(List<Opportunity> opps){
    if(Trigger.isDelete){         
   
        System.debug('good news ::: the deleteCloseWonOpportunity method has started');
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id IN :Trigger.old)]);
        for(Opportunity opp : opps){
            if(opp.StageName == 'Closed Won'){
                if(accounts.get(opp.AccountId).Industry == 'Banking'){
                    opp.addError('Cannot delete closed opportunity');
                    }
                }
            }
           }
        }

        public static void setPrimaryContact(Map<ID, Opportunity> Map1){

           if (Trigger.isBefore && Trigger.isUpdate){  
                System.debug('the setPrimaryContact method has started!!!');
                //Get contacts related to the opportunity account
                Set<Id> accountIds = new Set<Id>();
                for(Opportunity opp : Map1.values()){
                    System.debug('the first for loop in setPrimaryContact method has started!!!');
                    accountIds.add(opp.AccountId);
                }
                
                Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, FirstName, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' ORDER BY FirstName ASC]);
                Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();
        
                for (Contact cont : contacts.values()) {
                    System.debug('the second for loop in setPrimaryContact method has started!!!');
                    if (!accountIdToContact.containsKey(cont.AccountId)) {
                        accountIdToContact.put(cont.AccountId, cont);
                    }
                }
        
                for(Opportunity opp : Map1.values()){
                    System.debug('the third for loop in setPrimaryContact method has started!!!');
                    if(opp.Primary_Contact__c == null){
                        if (accountIdToContact.containsKey(opp.AccountId)){
                            opp.Primary_Contact__c = accountIdToContact.get(opp.AccountId).Id;
                        }
                    }
                } 
        }  
        }

public static void setType(List<Opportunity> opps){
if (Trigger.isBefore && Trigger.isInsert){
     // Set default Type for new Opportunities
     System.debug('the SetType method is starting to run');
       for( Opportunity opp : opps){
        if (opp.Type == null){
            opp.Type = 'New Customer';
        }    
    }
}
}

public static void validateCloseOpportunity(List<Opportunity> opps){

if (Trigger.isDelete){
            // Prevent deletion of closed Opportunities
            for (Opportunity oldOpp : opps){
                if (oldOpp.IsClosed){
                    oldOpp.addError('Cannot delete closed opportunity');
                }
            }
        }
        }

public static void updateDescriptionFromStage(Map<ID, Opportunity> Map1){
            if (Trigger.isUpdate && trigger.isBefore){
            System.debug('the updateDescriptionFromStage method has started');
                        // Append Stage changes in Opportunity Description
                        List <Opportunity> oppsToUpdate = new List<Opportunity>();
                        for (Opportunity opp : Map1.values()){
                            for (Opportunity oldOpp : oppsToUpdate){
                            System.debug('the for loop in the updateDescriptionFromStage method has started');
                                if (opp.StageName != null){  
                                    opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
                                    //oppsToUpdate.add(opp.Description); // experimenting by adding this line to support the update DML statement at the end
                                System.debug('The opp.Description contains: ' + opp.Description);    
                                }
                            }                
                        }
                        System.debug('Map1 contains these values: ' + Map1.values());
                        update Map1.values();
                        
            }
        }
}

/*
  Set<Id> accountIds = new Set<Id>();
                for(Opportunity opp : Map1.values()){
                    System.debug('the first for loop in setPrimaryContact method has started!!!');
                    accountIds.add(opp.AccountId);
                    */