public class CampaignTriggerHandler{
    public static boolean isCampaignRecursive = false;
    public static boolean isCampaignOppTrgRecursive = false; //INC2447541 Fix
    public static void CampaignAPI(List<Campaign> newList,List<Campaign> oldList,Map<id,Campaign> oldMap,boolean isInsert,
            boolean isUpdate,boolean isDelete,boolean isAfter){
                
                System.debug( '{{ CampaignTriggerHandler.CampaignAPI() in code body }}');
        List<Campaign> lstCampaign = new List<Campaign>();
        //After Insert or Update Campaign
        if(((isInsert || isUpdate ) && isAfter))
        {
            lstCampaign = new List<Campaign>([select Id,Name,Event_Zip__c,Type,Digigraph_Active__c,
                IsEventCreated__c, Specie_Focus__c, Date_of_Event__c, EndDate, Campaign.Owner.email, Allow_13to17__c  from Campaign Where Id in: newList]);
            System.debug( '{{ CampaignTriggerHandler.CampaignAPI() establish the trigger data set. }}');
        } 
        else if(isDelete) 
        {
            lstCampaign = new List<Campaign>([select Id,Name,Event_Zip__c,Type,Digigraph_Active__c, IsEventCreated__c, Specie_Focus__c, Date_of_Event__c, EndDate, Campaign.Owner.email, Allow_13to17__c  from Campaign Where Id in: oldList]);
        }
                
        Integer intCount = 0;
        List<Campaign> lstCampaignToUpdate = new List<Campaign>();
        if(lstCampaign != null && lstCampaign.size() > 0)
        {
            System.debug( '{{ CampaignTriggerHandler.CampaignAPI() lstCampaign is not null and size > 0 }}');
            for(Campaign objInsert : lstCampaign)
            {
                System.debug( '{{ CampaignTriggerHandler.CampaignAPI() inside the for loop }}');
                if(intCount < 10) 
                {
                    System.debug( '{{ CampaignTriggerHandler.CampaignAPI() intCount is < 10 }}');
                    if(isDelete || isInsert || (objInsert.Event_Zip__c != oldMap.get(objInsert.Id).Event_Zip__c || objInsert.name != oldMap.get(objInsert.Id).name || objInsert.Specie_Focus__c != oldMap.get(objInsert.Id).Specie_Focus__c || objInsert.Digigraph_Active__c != oldMap.get(objInsert.Id).Digigraph_Active__c || objInsert.Date_of_Event__c != oldMap.get(objInsert.Id).Date_of_Event__c || objInsert.EndDate != oldMap.get(objInsert.Id).EndDate) || objInsert.Owner.email != oldMap.get(objInsert.Id).Owner.email || objInsert.Allow_13to17__c != oldMap.get(objInsert.Id).Allow_13to17__c ) 
                    {
                        System.debug( '{{ CampaignTriggerHandler.CampaignAPI() isDelete || isInsert  }}');
                        
                        intCount++;
                        if(!objInsert.IsEventCreated__c)
                        {
                            if(!Test.IsRunningTest()) 
                            {
                                DigigrapghAPI.CreateEvent(objInsert.id,objInsert.Event_Zip__c,objInsert.name,objInsert.Specie_Focus__c,objInsert.Digigraph_Active__c, objInsert.Date_of_Event__c, objInsert.EndDate, objInsert.Owner.email + ',' + objInsert.Allow_13to17__c );
                            }
                            objInsert.IsEventCreated__c = true;
                        } 
                        else 
                        {
                            System.debug('( {{ CampaignTriggerHandler.CampaignAPI() :: IsEventCreated__c == true -- this is an edit.');
                            if(isDelete) 
                            {
                                System.debug( '{{ CampaignTriggerHandler.CampaignAPI() if(isDelete) == true  }}');
                                objInsert.Digigraph_Active__c = false;
                            }
                            if(!Test.IsRunningTest()) 
                            {
                                System.debug( '{{ CampaignTriggerHandler.CampaignAPI() about to call -> DigigraphAPI.EditEvent() }}');
                                DigigrapghAPI.EditEvent(objInsert.id,objInsert.Event_Zip__c,objInsert.name,objInsert.Specie_Focus__c, objInsert.Digigraph_Active__c,isDelete,  objInsert.Date_of_Event__c, objInsert.EndDate, objInsert.Owner.email + ',' + objInsert.Allow_13to17__c );
                                System.debug( '{{ CampaignTriggerHandler.CampaignAPI() returned from -> DigigraphAPI.EditEvent() }}');
                            }
                        }
                        lstCampaignToUpdate.add(objInsert);
                    }
                }
            }
        }
        if(lstCampaignToUpdate.size() > 0) 
        {
            CampaignTriggerHandler.isCampaignRecursive = true;
            update lstCampaignToUpdate;
        }
    }
}