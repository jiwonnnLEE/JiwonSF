public with sharing class CRestaurantTriggerHandler{
	
    //생성자
    public CRestaurantTriggerHandler(){
        
    }
    
    //Insert
    //리턴 값 없는 메소드, 리스트를 매개변수로 받고 있음
    public static void setBeforeInsertCRestaurant(List<Contact_Restaurant__c> newList){
                   
        //객체 생성
        List<Contact> contact = new List<Contact>();        
             
        //반복문 실행
        for(Contact_Restaurant__c cr : newList){
            //객체 생성
            Contact co = new Contact();
            //맵핑
            co.LastName = cr.Name;
            co.Email = cr.Email__c;
            co.Phone = cr.Telephone__c;
            co.Role__c = cr.Role__c;
            
            //삽입
            contact.add(co);
            system.debug('id값!: '+cr.Id);
            system.debug('newList1: '+newList);
        }
              
        if(!contact.isEmpty()){
            //삽입 실행
        	insert contact;
            system.debug('insert contact11: '+contact);
        }
            
        system.debug('newList2: '+newList);
        system.debug('contact 업데이트 전: '+contact);
        
		List<Contact_Restaurant__c> crUpdates = new List<Contact_Restaurant__c>();
        
        for(Integer i=0; i<newList.size(); i++){
            Contact_Restaurant__c crUpdate = new Contact_Restaurant__c(Id = newList[i].id, Contact__c = contact[i].id);
            
            	crUpdates.add(crUpdate);                     
        }
        
        
        system.debug('contact 업데이트 후: '+contact);
        update crUpdates;
        system.debug('crUpdates 업데이트 후: '+crUpdates);       
    }
    
    //
    //public static void setBeforeInsertCRestaurant(List<Contact_Restaurant__c> newLists, Map<Id, Contact_Restaurant__c> newMap){
    	//List<Contact_Restaurant__c> Contact_RestaurantToUpdate = new List<Contact_Restaurant__c>();
    	
        //for(Contact_Restaurant__c newContact_Restaurant : newLists){
          //  Id newContactId = newContact_Restaurant.Contact_c;
            
           // if(newContactId !=null && newMap.containkey(newContactId))
            
        //}
    
    	//if(!Contact_RestaurantToUpdate.isEmpty()){
            //삽입 실행
        //	update Contact_RestaurantToUpdate;
          //  system.debug('');
        //}
	//}
    
    //Insert 후
    //public static void setAfterInsertCRestaurant(Map<Id,Contact_Restaurant__c> newMap){
        
        //newMap 생성
        //List<Contact_Restaurant__c> Contact_Restaurant = new List<Contact_Restaurant__c>();
        //Contact_Restaurant = newMap.values();
        //system.debug('Contact_Restaurant: '+Contact_Restaurant);
        
        //List<Contact> contact = new List<Contact>();
        //List<Contact> relatedContact = [Select id, Contact_Restaurant__c From Contact where Id = : Contact_Restaurant.Id];
        
        //for(Contact_Restaurant__c cr : Contact_Restaurant){

            
            //relatedContact.Contact_Restaurant__c = cr.Id;
			//system.debug('1: '+cr.Id); 
            //system.debug('2: '+Contact_Restaurant__c); 
            
            //contact.add(relatedContact);
            //system.debug('3: '+relatedContact);
       // }
        //system.debug('4: '+contact);
       // update contact;
        
        //if(!contact.isEmpty()){
            //update contact;
            //system.debug(': '+'update contact11');
        //}
              
        //system.debug(': '+contact);
    //}
    
    //public static void setAfterInsertCRestaurant(Map<Id, Contact_Restaurant__c> newMap){
        
        //List<Contact> contact = new List<Contact>();
        //Map<ID,Contact_Restaurant__c> newCrMap = newMap;
        
        //for(Contact_Restaurant__c cr : newMap.values()){
            //contact co = new contact();
            
            //List<Contact> relatedContact = [Select Id, Contact_Restaurant__c From Contact where Contact_Restaurant__c = : cr.Id];
           	//co.Contact_Restaurant__c = cr.Id;
			//system.debug(cr.Id); 
            //system.debug(co.Contact_Restaurant__c); 
            //contact.add(co);
            //system.debug(contact);
       // }
       // system.debug(contact);
        //update contact;
        //system.debug('update contact11');
           // system.debug(contact);
        
        //if(!contact.name == false){
            //update contact;
            //system.debug('update contact11');
            //system.debug(contact);
        //}
    //}

    //Delete
    public static void setBeforeDeleteCRestaurant(List<Contact_Restaurant__c> deleteList){
        List<Contact> contact = new List<Contact>();
        
        for(Contact_Restaurant__c cr : deleteList){
            List<Contact> relatedContact = [Select Id From Contact where Id = : cr.Contact__c];
            contact.addAll(relatedContact);
        }
        
        if(!contact.isEmpty()){
            system.debug('처음 contact: '+contact);
            delete contact;           
            system.debug('나중 contact'+contact);
        }
    }
    
    //Update
    public static void setAfterUpdateCRestaurant(List<Contact_Restaurant__c> oldList, List<Contact_Restaurant__c> newList){     
        List<Contact> contact = new List<Contact>();
        
        Contact_Restaurant__c oldCR;
		Contact_Restaurant__c newCR;
        
        if(oldList[0] != newList[0]){
            
            for(Integer i=0; i < newList.size(); i++){
                oldCR = oldList[i];
                newCR = newList[i];
                system.debug(oldList[0]);
                system.debug('oldCR'+oldCR);
                system.debug(newList[0]);
                system.debug('newCR'+newCR);
        	}
            
            List<Contact> relatedContact = [Select Id, Name, Email, Phone, Role__c From Contact where Id = : newCR.Contact__c];
            //contact.addAll(relatedContact);
            system.debug(relatedContact[0]);
            
            for(Contact c : relatedContact){     
                c.LastName = newCR.Name;
                c.Email = newCR.Email__c;
                c.Phone = newCR.Telephone__c;
                c.Role__c = newCR.Role__c;               
                
                contact.add(c);
                system.debug('1: '+contact[0]);	
              
            }
            system.debug('2: '+contact[0]);	
        }
        
        if(!contact.isEmpty()){
            
            update contact;           
            system.debug('3: '+contact[0]);
        }                 
    }
}