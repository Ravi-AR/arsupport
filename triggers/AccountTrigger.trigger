trigger AccountTrigger on Account (after insert, before insert, before update, after update ) {


    if(trigger.isInsert){
        
        if(trigger.isBefore) {
            AccountTriggerHandler.beforeInsert(trigger.new);    
        }
        
        if(trigger.isAfter){
            AccountTriggerHandler.afterInsert (trigger.new);
        }
        
    } // End: insert if
    
    if(trigger.isUpdate) {
        
        if(trigger.isBefore) {
            AccountTriggerHandler.beforeUpdate(trigger.new);
        }
        
        if(trigger.isAfter)
        {
        String errorMessage = AccountTriggerHandler.accountApprovers(trigger.newMap,trigger.oldMap);
        AccountTriggerHandler.updateProcessInstance(trigger.newMap,trigger.oldMap);
            
            if(errorMessage != null
                && errorMessage != '0')
            {
               for(Account acc:Trigger.new) {
                    acc.addError(errorMessage);
               }
            }
        }
        
    } // End: update if
    
    
} // End: AccountTrigger