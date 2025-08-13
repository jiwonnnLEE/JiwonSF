global class Util {

  //https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/connectapi_examples_post_feed_element_mention.htm

   //constants new line 

   global static String NL = '\n';

      

    //chatter posting

   @future(callout=false)

   global static void chat(String Msg, Id recordId, List<Id> userIdList){

       ConnectApi.FeedItemInput feed = new ConnectApi.FeedItemInput();

       ConnectApi.MentionSegmentInput mentionSegment;

       ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();

       ConnectApi.TextSegmentInput textSegment;

       Integer body_length = 0;

      

       messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

       //text segment

       textSegment = new ConnectApi.TextSegmentInput();

       textSegment.text = '[알림] '+Msg + Util.NL;

      messageInput.messageSegments.add(textSegment);

       body_length += textSegment.text.length();

       //mension segment

       // mention to user

       for(Id userId : userIdList){

           mentionSegment = new ConnectApi.MentionSegmentInput();

           mentionSegment.id = userId;

          messageInput.messageSegments.add(mentionSegment);

           textSegment = new ConnectApi.TextSegmentInput();

           textSegment.text = ' ';

          messageInput.messageSegments.add(textSegment);

       }

      

       feed.body = messageInput;

       //feed type

       feed.feedElementType = ConnectApi.FeedElementType.FeedItem;

       // Use a record ID for the subject ID.

       feed.subjectId = recordId ; //a.Id is the record ID

       if(!Test.isRunningTest()){

           ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(

               Network.getNetworkId(),

               feed

           );

       }

   }

}