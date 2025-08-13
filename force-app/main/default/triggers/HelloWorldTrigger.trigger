trigger HelloWorldTrigger on Account__c (before insert) {
	System.debug('Hello World!');
}