/**
 * @description       : 
 * @author            : jiwon.lee@dkbmc.com
 * @group             : 
 * @last modified on  : 2024-10-18
 * @last modified by  : jiwon.lee@dkbmc.com
**/
public with sharing class FileUploadController {
    public FileUploadController() {

    }

    @AuraEnabled
    public static void insertRecords(List<Map<String, Object>> records) {
        List<Company__c> recordsToInsert = new List<Company__c>();
        
        try{
            for (Map<String, Object> recordData : records) {
                Company__c obj = new Company__c();
                
                // 데이터 있는지 체크 후 넣어주기
                if (recordData.containsKey('Name') && recordData.get('Name') != null) {
                    obj.Name = (String)recordData.get('Name');
                }
                if (recordData.containsKey('Material__c') && recordData.get('Material__c') != null) {
                    obj.Material__c = (String)recordData.get('Material__c');
                }
                if (recordData.containsKey('Site__c') && recordData.get('Site__c') != null) {
                    obj.Site__c = (String)recordData.get('Site__c');
                }
                // if (recordData.containsKey('Account_Name__c') && recordData.get('Account_Name__c') != null) {
                //     obj.Account_Name__c = (String)recordData.get('Account_Name__c');
                // }

                // Account Name 처리 (ID 또는 이름)
                if (recordData.containsKey('Account_Name__c') && recordData.get('Account_Name__c') != null) {
                    String accountNameOrId = (String)recordData.get('Account_Name__c');
                    
                    // 18자리 ID인지 확인 (ID라면 그대로 사용)
                    if (accountNameOrId.length() == 18 && accountNameOrId.startsWith('001')) {
                        obj.Account_Name__c = accountNameOrId;
                    } else {
                        // Account 이름으로 ID 조회
                        Account account = [SELECT Id FROM Account WHERE Name = :accountNameOrId LIMIT 1];
                        if (account != null) {
                            obj.Account_Name__c = account.Id;
                        }
                    }
                }

                if (recordData.containsKey('Nationality__c') && recordData.get('Nationality__c') != null) {
                    obj.Nationality__c = (String)recordData.get('Nationality__c');
                }
                if (recordData.containsKey('Rating__c') && recordData.get('Rating__c') != null) {
                    obj.Rating__c = (String)recordData.get('Rating__c');
                }
                if (recordData.containsKey('Industry__c') && recordData.get('Industry__c') != null) {
                    obj.Industry__c = (String)recordData.get('Industry__c');
                }
                if (recordData.containsKey('AnnualRevenue__c') && recordData.get('AnnualRevenue__c') != null) {
                    obj.AnnualRevenue__c = (Decimal)recordData.get('AnnualRevenue__c');
                }
                if (recordData.containsKey('Phone__c') && recordData.get('Phone__c') != null) {
                    obj.Phone__c = (String)recordData.get('Phone__c');
                }

                System.debug('Company Record: ' + obj); // 디버깅
                recordsToInsert.add(obj);
            }
            
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert; // 레코드 삽입
            }
        }catch(Exception e){
            System.debug('Error inserting records: ' + e.getMessage());
            throw new AuraHandledException('Error inserting records: ' + e.getMessage());
        }
    }
}