trigger QuotelistSet on Quote (before update) {

 

   for(Quote Opp : Trigger.New){

 

       if(Opp.Status == '견적 확정' && Opp.Status != Trigger.OldMap.get(Opp.Id).Status){

 

           List<Quote> quote = [select Id, OpportunityId ,name,Status from Quote where OpportunityId  != null  and

                                OpportunityId =:Opp.OpportunityId and Id !=: Opp.Id and Status ='견적 확정' limit 1];

 

           if(quote.size() > 0){

               Trigger.New[0].addError('이미 확정된 다른 견적이 있습니다!!');

           } else {

               Opp.ExpirationDate = date.today() + 28; //만료일자 자동 표기 + 4주

           }

 

       } else if(Opp.Status != '견적 확정') {

           Opp.ExpirationDate = null; //견적 확정이 아닌경우 만료일자는 빈칸으로 변경

       }

   }

}