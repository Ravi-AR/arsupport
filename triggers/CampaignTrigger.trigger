trigger CampaignTrigger on Campaign (after insert, after update, after delete,before delete) {
    
    System.debug('** Campaign Trigger called **');
    
    if(!CampaignTriggerHandler.isCampaignRecursive){
        
        System.debug( '** CampaignTriggerHandler to be called **');
        
        CampaignTriggerHandler.CampaignAPI(Trigger.New,Trigger.Old,Trigger.OldMap,Trigger.isInsert,Trigger.isUpdate,
                Trigger.isDelete,Trigger.isAfter);
        
        System.debug( '** CampaignTriggerHandler.CampaignAPI() was called and returned **');
    }
    LOL_Campaign_Rollup utility_helper = new LOL_Campaign_Rollup();
    if(!CampaignTriggerHandler.isCampaignOppTrgRecursive){  //INC2447541  Fix
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        utility_helper.rollUpCampaigns_campaign(trigger.new);
    }

    if(trigger.isAfter && trigger.isDelete){
        utility_helper.rollUpCampaigns_campaign(trigger.old);
    }
   }  //INC2447541  Fix
}