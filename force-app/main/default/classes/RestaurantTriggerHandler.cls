public with sharing class RestaurantTriggerHandler {
	
    public RestaurantTriggerHandler(){
        
    }
    
    public static void run(){
        
    }
    
         
    public static void setBeforeInsertRestaurant(List<Contact_Restaurant__c> newList){
        
        List<Contact_Restaurant__c> cRestaurant = new List<Contact_Restaurant__c>();
        List<Contact> contact = new List<Contact>();
        
        for(Contact_Restaurant__c cr : newList){
            if(cr <> null){
                //contact.add(cr);
            }      
        }
        
    }
}