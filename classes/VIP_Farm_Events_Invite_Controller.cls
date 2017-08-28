public with sharing class VIP_Farm_Events_Invite_Controller {

	//List<Farm_VIP_Registration__c> master_events {get;set;}
	public List<Campaign> master_events {get;set;}


	public String contact_id			{get;set;}
	public String account_id			{get;set;}
	public String opportunity_id		{get;set;}
	public String multioppids 			{get;set;}

	public ID tempid{
		get;

		set{
			tempid = value;
		}
	}

     public VIP_Farm_Events_Invite_Controller(){
		// 	only grab the Farm VIP events.
		contact_id = ApexPages.currentpage().getParameters().get('con_id');
		account_id = ApexPages.currentpage().getParameters().get('acc_id');
		opportunity_id = ApexPages.currentpage().getParameters().get('opp_id');
		multioppids = ApexPages.currentpage().getParameters().get('multiOppIds');


		RecordType farm_rec = [SELECT id, Name FROM Recordtype WHERE Name = 'Farm VIP Event'];
		List<Campaign> all_campaigns = [SELECT id, Name, ParentId, Date_of_Event__c, Specie_Focus__c, Registration_Opens__c, RecordTypeId, Status, Description
										FROM Campaign WHERE RecordTypeId =: farm_rec.id AND Status = 'Registration Open' ];
		master_events = all_campaigns;
    }


    public PageReference register(){

    	system.debug('this ist he temp id ' + tempid);
    	PageReference ret_page;

    	if(contact_id == null && opportunity_id == null){
    		ret_page = new PageReference('/apex/VIP_Contact_Select');
    		ret_page.getParameters().put('event_id', tempid);
    		ret_page.setRedirect(true);

		}else{
			ret_page = new PageReference('/apex/VIP_Event_Register?camp_id='+tempid);
	    	ret_page.getParameters().put('acc_id', account_id);
	    	ret_page.getParameters().put('con_id', contact_id);
	    	ret_page.getParameters().put('opp_id', opportunity_id);
	    	ret_page.getParameters().put('multiOppIds', multiOppids);
	    	ret_page.setRedirect(true);
		}
    

    	return ret_page;
    }

    
    

}