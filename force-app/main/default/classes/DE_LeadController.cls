public class DE_LeadController {

    @AuraEnabled
    public static Map<String, Object> getLeadList(){
        Map<String, Object> resultMap = new Map<String, Object>();
        
        List<Lead> LeadList = queryLead('');
        try {

            if(LeadList.size() > 0){
                resultMap.put('RESULT','S');
                resultMap.put('VALUE',LeadList);
            }else{
                resultMap.put('RESULT','W');
            }
        } catch (Exception e) {
            resultMap.put('RESULT','E');
            resultMap.put('MESSAGE','[' + e.getLineNumber() + ']' + e.getMessage());
        }  
        return resultMap;
    }

    private static List<Lead> queryLead(String recordId){

        String query = '';
        query = 'SELECT Id';
        query += '    , Name'; //Contact Name
        query += '    , Title';
        query += '    , Company';
        query += '    , Phone';
        query += '    , Email';
        query += ' FROM Lead';
        if(recordId != ''){
            query += ' WHERE Id =: recordId';
        }else{
            query += ' ORDER BY CreatedDate DESC';
        }

        List<Lead> leadList = Database.query(query);
        return leadList;
    }
}