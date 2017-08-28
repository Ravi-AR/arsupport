trigger SurveyResultsTrigger on Survey_Results__c (after insert) {
	SurveyResultsTrigger_Utility util = new SurveyResultsTrigger_Utility();
    if(trigger.isInsert && trigger.isAfter){
        util.checkSurveyResult(trigger.new);
    }
}