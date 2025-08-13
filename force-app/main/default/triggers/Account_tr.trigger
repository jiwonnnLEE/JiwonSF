trigger Account_tr on Account__c (before insert, after insert) {
    List<Account> accountLists = new List<Account>();
    List<Account__c> oldData = Trigger.old;
    List<Account__c> newData = Trigger.new; 
    
    if(trigger.isInsert){
        if(trigger.isBefore){

            for(Account__c a : trigger.new){
                Account acc = new Account(
                    Name = a.Name,
                    Site = a.Site__c,
                    Phone = a.Phone__c
                    );
                    accountLists.add(acc);
                }
                if(!accountLists.isEmpty()){
                    insert accountLists;
                    newData[0].sAccount__c = accountLists[0].id;
                }
        }else if(trigger.isAfter){
            String search = newData[0].sAccount__c;
            Account acc = [SELECT id FROM Account WHERE id =:search  LIMIT 1];
            acc.cAccount__c = newData[0].id;
            update acc;
        }
    }
    
    
}