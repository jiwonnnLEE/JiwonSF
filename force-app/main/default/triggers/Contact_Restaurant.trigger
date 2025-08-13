trigger Contact_Restaurant on Contact_Restaurant__c (after insert, before delete, after update) {
	
    if(Trigger.IsInsert){
                    
        //static 메소드 사용, Trigger.new를 매개변수로 전달
        CRestaurantTriggerHandler.setBeforeInsertCRestaurant(Trigger.new);        
    }
     
    if(Trigger.isDelete){
        //Trigger.old를 매개변수로 전달
        CRestaurantTriggerHandler.setBeforeDeleteCRestaurant(Trigger.old);
    }
    
            
    if(Trigger.isUpdate){
        CRestaurantTriggerHandler.setAfterUpdateCRestaurant(Trigger.old, Trigger.new);
    }        
    
}