public class Cancel_VIP_Reg_Control {
	
	public Farm_VIP_Registration__c cur_reg {get;set;}
    
    public Cancel_VIP_Reg_Control(ApexPages.StandardController controller){
    	ID cur_id = controller.getId();
        cur_reg = [SELECT id, Approval_Status__c FROM Farm_VIP_Registration__c WHERE id =: cur_id];
    }

    public PageReference cancel_reg(){

    	// determine status of the record.
    	String TEMP_1 = 'temp1';
    	String TEMP_2 = 'temp2'; 
    	String TEMP_3 = 'temp3';
    	String TEMP_4 = 'temp4';

    	if(cur_reg.Approval_Status__c == 'Approved'){
    		ApprovedRoute();
    	} 
    	
    	cur_reg.Approval_Status__c = 'Canceled';
    	try{
    		update cur_reg;
		}catch(DmlException e){
			System.debug('Error on update occured (Farm_VIP_Registration__c object) : ' + e.getMessage());
		}
    	return new PageReference('/'+cur_reg.id);
    }

    public void ApprovedRoute(){

    	List<Opportunity> opps_for_update = new List<Opportunity>();
    	List<CampaignMember> cms_for_update = new List<CampaignMember>();
    	// get all of the campaing members assoicated to to the registration record.
    	List<CampaignMember> campmems = [SELECT id, CampaignId, ContactId, Farm_VIP_Registration__c, Status 
    										FROM CampaignMember 
    										WHERE Farm_VIP_Registration__c =: cur_reg.id];

    	List<Opportunity> opps = [SELECT id, Farm_VIP_Registration__c, CampaignId 
    								FROM Opportunity 
    								WHERE Farm_VIP_Registration__c =: cur_reg.id];

    	for(CampaignMember c : campmems){
    		c.Status = 'Canceled';
    		cms_for_update.add(c);
    	}

    	// Set the look up Campaign on Opportunity to nothing. 
    	if(opps != null){
    		for(Opportunity o : opps){
    			o.campaignId = null;
    			opps_for_update.add(o);
    		}
    	}

        SYSTEM.DEBUG('these are the campaign members for update: ' + cms_for_update);
    	try{
    		update cms_for_update;
		}catch(DmlException e){
			SYSTEM.DEBUG('Error occured on update (CmapaignMembers) ' + e.getMessage());
		}

		try{
			update opps_for_update;
		}catch(DmlException e){
			SYSTEM.DEBUG('Error occured on update (Opportunities) ' + e.getMessage());
		}

    }



}