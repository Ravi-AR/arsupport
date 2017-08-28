/**
*   @Author:    Heena Tanna
*   @Date:      11.01.2017
*   @Jira:      LPDCR-1732
*   @Purpose:   Sharing Account with Dealer Community user
* 
*/


trigger AccountContactRelationTrigger on AccountContactRelation (after insert,after update,before update,before delete)
 {
  List<AccountContactRelation> acr = Trigger.isDelete ? Trigger.old : Trigger.new ;
  if(trigger.isAfter){//after event
    
    if(trigger.isInsert || trigger.IsUpdate)
    {
       LPDCR_AccountContactRelationHandler.insertAccountShare(acr);
    }
  }
   
   if(trigger.IsBefore){ 
    if(trigger.IsUpdate)//Remove access
        {
            LPDCR_AccountContactRelationHandler.deleteAccountShareOnUpdate(acr);
        
        }
        
        if(trigger.isDelete)//Remove access
        {
           LPDCR_AccountContactRelationHandler.deleteAccountShareOnDelete(acr); 
        }
    
   }
   }