public with sharing class OpptyController {
    @AuraEnabled
    public static List<Opportunity> getOpptyRecord() {
        List<Opportunity> oppty = [SELECT Id, Name, Account.Name, StageName, CloseDate, Owner.Name FROM Opportunity];
        System.debug(oppty);
        return oppty;
    }
}