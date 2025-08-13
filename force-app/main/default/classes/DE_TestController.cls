public class DE_TestController {
    
    @AuraEnabled
    public static Map<String, Object> getTestList(){
        Map<String, Object> resultMap = new Map<String, Object>();
        
        List<Lead> TestList = queryLead('');
        try {

            if(TestList.size() > 0){
                resultMap.put('RESULT','S');
                resultMap.put('VALUE',TestList);
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

        List<Lead> testList = Database.query(query);
        return testList;
    }

}