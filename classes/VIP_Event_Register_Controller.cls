public class VIP_Event_Register_Controller {

	public Contact 				cur_contact		{get;set;}
	public Opportunity 			cur_opportunity	{get;set;}
	public Account				cur_account 	{get;set;}
	public Campaign 			cur_event		{get;set;}
	public User 				cur_user		{get;set;}
	public Farm_VIP_Registration__c cur_reg		{get;set;}

	public List<Opportunity> 	cur_opps		{get;set;}

	public boolean invite_contacts {get;set;}
	public Contact temp_con {get;set;}
	public List<Contact> relatedcontacts {get;set;} 	// Contacts that are going to be added to the current account.
	public List<Contact> cons_related_account {get;set;}
	public ID sel_conid {get;set;}

	String a_id {get;set;}
	String c_id {get;set;}
	String o_id {get;set;}
	String e_id {get;set;}
	String multiopps {get;set;}

	public Boolean influencerContact{get;set;}
	public VIP_Required_Fields__c req_fields {get;set;}	// Custom settings to determine which fields need to be required.
	// Custom settings
	VIP_Purina_Account__c Purina_Account{get;set;}

	public VIP_Event_Register_Controller(ApexPages.StandardController controller){

		Purina_Account = VIP_Purina_Account__c.getOrgDefaults();
        Map<String, String> influecerPath = new Map<String, String>();
        if(Purina_Account.Contact_Influencer_Type__c != null){
        	List<String> con_types_infl = Purina_Account.Contact_Influencer_Type__c.split(',');
	        for(String s : con_types_infl){
	            influecerPath.put(s, s);
	        }
        }

		invite_contacts = false;
		//temp_con = new Contact();
		//relatedcontacts = new List<Contact>();
		SYSTEM.debug('HIT CONSTRUCTOR' );
		a_id = ApexPages.currentpage().getParameters().get('acc_id');
		c_id = ApexPages.currentpage().getParameters().get('con_id');
		o_id = ApexPages.currentpage().getParameters().get('opp_id');
		e_id = ApexPages.currentpage().getParameters().get('camp_id');
		multiopps = ApexPages.currentPage().getParameters().get('multiOppIds');

		req_fields = VIP_Required_Fields__c.getOrgDefaults();

		List<String> oppids = new List<String>();
		if(multiopps != null && multiopps != ''){
			oppids = multiopps.split(';');
		}
		if(oppids.size() > 0){
			cur_opps = [SELECT id, Name, StageName, Farm_VIP_Registration__c, CampaignId
										FROM Opportunity
										WHERE id IN : oppids ];
		}

		cur_reg = new Farm_VIP_Registration__c();

		cur_event = [SELECT id, Name, ParentId, Date_of_Event__c, Specie_Focus__c, Registration_Opens__c, RecordTypeId
					FROM Campaign 
					WHERE id =: e_id];

		if(o_id != null && o_id != ''){
			cur_opportunity = [SELECT id, Name, StageName, Farm_VIP_Registration__c, CampaignId
										FROM Opportunity
										WHERE id =: o_id];
		}
		
		if(c_id != null && c_id != ''){
			cur_contact = [SELECT id, Name, FirstName, LastName, Title, Salutation, MailingStreet, MailingCity, MailingState, MailingStateCode, MailingCountryCode, MailingPostalCode, MobilePhone, Email, Contact_Type__c, Role__c, Reason_No_Phone__c, Reason_No_Email__c, Override_Phone__c, Override_Email__c
							FROM Contact
							WHERE id =: c_id];
			//if(influecerPath.containsKey(cur_contact.Contact_Type__c)){
			if(cur_contact.Contact_Type__c == 'Influencer'){
				influencerContact = true;
			}else{
				influencerContact = false;
			}
		}else{
			influencerContact = false;
		}
		
		if(a_id != null && a_id != ''){
			cur_account = [SELECT id, Name, RecordTypeId, AccountNumber
						FROM Account
						WHERE id =: a_id];
		}
		
		ID u_id = UserInfo.getuserId();
		cur_user = [SELECT id, Name, FirstName, LastName, MobilePhone, Email, Sales_Division__c, Employee_Number__c
					FROM User 
					WHERE id =: u_id];					

	} 	// END  constructor. 

//Method to save all objects (look up values) Account, Contact, Opportunity, Campaign? VIP Event, VIP_registration.
	public PageReference overrideSave(){

		cur_reg.Registrant__c = cur_contact.id;
		cur_reg.Farm_VIP_Event__c = cur_event.id;		
        //WILL NEED TO REMOVE RELATIONSHIP OF OPPORTUNITY.
		if(cur_opportunity != null){
			//cur_reg.Opportunity__c = cur_opportunity.id;	
		}		

		try{
			update cur_contact;
		}catch(DMLException e){
			SYSTEM.DEBUG('Error occured on insert ' + e.getMessage());
		}
		SYSTEM.DEBUG('this is the cur contact (after)' + cur_contact);

		//ASSOCIATE ALL THE RELATED CONTACTS TO THE FARM VIP REGISTRATION RECORD
        if( relatedcontacts != null){
        	try{
        		upsert relatedcontacts;
    		}catch(DMLException e){
    			SYSTEM.DEBUG('Error Occured on upsert contacts: ' + e.getMessage());
    		}
        }
		cur_reg.Related_Contact_Ids__c = '';
		if(relatedcontacts != null){
			for(Contact c : relatedcontacts){
	        	cur_reg.Related_Contact_Ids__c += c.id + ',' ;
	        }

		}


		try{
			insert cur_reg;
		}catch(DmlException e){
			System.debug('Error on insert OBJECT : Farm_VIP_Registration__c: ' + e.getMessage());
		}
		
		if(Test.isRunningTest() == false){
			Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
			req.setObjectId(cur_reg.id);
			req.setComments('Submitting request for approval via button on Farm VIP Registration page.');
			req.setProcessDefinitionNameOrId('Farm_VIP_Nomination_Approval');
			Approval.ProcessResult res = Approval.process(req);
		}
		

        //ASSOCIATE ALL THE OPPORTUNITIES 
        if(cur_reg.id != null && cur_opps != null){
            for(Opportunity o : cur_opps){
                o.Farm_VIP_Registration__c = cur_reg.id;
            }
            try{
                update cur_opps;
            }catch(DMLException e){
                System.debug('Error on insert OBJECT : Opportuntiy: ' + e.getMessage());
            }
        }

        PageReference l_page;
        if(cur_reg.id != null){
			l_page = new PageReference('/'+cur_reg.id);            
        }else{
            l_page = null;
        }
        return l_page;
	}

	public PageReference overridePhonepop(){
		return null;
	}

	public PageReference MakeInfluencer(){
		influencerContact = true;
		return null;
	}

	public PageReference unMakeInfluencer(){
		influencerContact = false;
		return null;
	}

//------------METHODS USED FOR ADDING RELATED CONTACTS TO THE RECORD -------------------------------------------
	public void showAddContacts(){
		invite_contacts = true;
		cons_related_account = [SELECT ID, Name, FirstName, LastName, Phone, Email, Contact_Type__c, Role__c, AccountId FROM Contact WHERE AccountId =: cur_account.id];
		temp_con = new Contact();
		temp_con.Contact_Type__c = 'Producer';
	}

	public void createRelatedContact(){
		SYSTEM.DEBUG('this is the related contacts ' + relatedcontacts);
		temp_con.AccountId = cur_account.id;
		if(relatedcontacts == null){
			relatedcontacts = new List<Contact>();
		}
		relatedcontacts.add(temp_con);
		temp_con = new Contact();
	}

	public void addContacttoList(){
		Contact con_add;
		Map<ID, Contact> id_list = new Map<ID, Contact>();
		if(relatedcontacts != null){
			for(Contact cc :relatedcontacts){
				id_list.put(cc.id, cc);
			}
		}else{
			relatedcontacts = new List<Contact>();
		}
		Boolean dup = false;
		for(Contact c : cons_related_account){
			if(c.id == sel_conid){
				con_add = c;
				if(id_list.containsKey(con_add.id)){
					dup = true;
				}
			}
		}
		if(dup == false){
			relatedcontacts.add(con_add);	
		}
	}
//------------METHODS USED FOR ADDING RELATED CONTACTS TO THE RECORD -------------------------------------------

}