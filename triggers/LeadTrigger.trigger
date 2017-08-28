trigger LeadTrigger on Lead (after update) {
	LeadTriggerHelperUtility lth = new LeadTriggerHelperUtility();
    
    if(trigger.isUpdate && trigger.isAfter){
		lth.ReParentSurveyResults(trigger.newMap);
    }
}