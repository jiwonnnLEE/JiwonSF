trigger restaurant on Restaurant__c (before insert) {
	
    RestaurantTriggerHandler.run();
    if(Trigger.IsInsert == true){
        RestaurantTriggerHandler.setBeforeInsertRestaurant(Trigger.new);
    }

}