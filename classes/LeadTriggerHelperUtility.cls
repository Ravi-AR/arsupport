public class LeadTriggerHelperUtility {

    
    public void ReParentSurveyResults(Map<Id, Lead> newLead){
        List<Lead> conv_leads = new List<Lead>();
        for(id i : newLead.keySet()){
            system.debug('this is linfo: ' + newLead.get(i));
            if(newLead.get(i).IsConverted == true){
                conv_leads.add(newLead.get(i));
            }
        }
        
        //ConvertedContactId
        if(conv_leads.size() > 0){
        	Lead l = conv_leads[0];
			List<Survey_Results__c> sr = [SELECT id, X18_Digit_Survey_Results_ID__c, Animal_Type__c, Answer__c, Contact__c, Customer_Event__c, Lead__c, Order_Sequence__c, Question__c, Question_Answer_ID__c 
											FROM Survey_Results__c
											WHERE Lead__c =: l.id];
			for(Survey_Results__c s : sr){
				s.Contact__c = l.ConvertedContactId;
			}

			try{
				update sr;
			}catch(DmlException e){
				SYSTEM.DEBUG('Error on update : Survey_Results__c : ' + e.getMessage());
			}
        }
        
        
        
    }
}