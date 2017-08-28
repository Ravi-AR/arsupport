trigger OpportunityTrigger on Opportunity (after insert, after update, after delete) {

	LOL_Campaign_Rollup utility_helper = new LOL_Campaign_Rollup();
	
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        //utility_helper.rollupOpportunities(trigger.new);
        utility_helper.CalculatePoints(trigger.new);
        utility_helper.rollUpCampaigns_Opportunities(trigger.new);

        if(trigger.isUpdate){
            utility_helper.rollUpCampaigns_Opportunities(trigger.newMap, trigger.oldMap);
        }
    }

    if(trigger.isAfter && trigger.isDelete){
    	utility_helper.rollUpCampaigns_Opportunities(trigger.old);
    }

}