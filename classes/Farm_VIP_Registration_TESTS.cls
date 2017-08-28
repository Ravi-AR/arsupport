@isTest
public class Farm_VIP_Registration_TESTS {

//VIP ROUTING CONTROLS TEST PAGE.
	static testMethod void testRouting_controls_contact(){
			Account a = new Account();
			a.Name = 'test name ';
			insert a;

			Contact con = new Contact();
			con.firstName = 'testname';
			con.lastName = 'testtest';
			con.AccountId = a.id;
			insert con;

		    Test.setCurrentPageReference(new PageReference('Page.VIP_Events_Router'));
            System.currentPageReference().getParameters().put('contactid', con.id);

            VIP_Events_Router_Controller cc = new VIP_Events_Router_Controller();
            cc.route();
            SYSTEM.assert(con != null);
	}

	static testMethod void testRouting_controls_opportunity(){

			Account a = new Account();
			a.Name = 'test name ';
			insert a;

			Opportunity opp = new Opportunity();
			opp.Name = 'testname';
			opp.AccountId = a.id;
			opp.Total_Head__c = 3.0;
            opp.StageName = 'Prospecting';
			opp.closeDate = System.today();
			insert opp;

		    Test.setCurrentPageReference(new PageReference('Page.VIP_Events_Router'));
            System.currentPageReference().getParameters().put('opportunityid', opp.id);

            VIP_Events_Router_Controller cc = new VIP_Events_Router_Controller();
            cc.route();
            SYSTEM.assert(opp != null);
	}
    
// ACCOUNT ERRROR PAGE TESTS
    static testmethod void Account_errorPage_opportunity(){
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();

        //VIP_Purina_Account__c test_custom = new VIP_Purina_Account__c();
        //test_custom.AccountId__c = '001g000000d9FPQAA2';
        //test_custom.Contact_Owner_ID__c = '005g0000002FcvxAAC';
        //test_custom.Contact_Record_Type__c = '012g0000000DTQOAA4';
        //test_custom.Contact_Influencer_Type__c = 'Influencer,'; 
        insert test_custom;
        
        Account a = new Account();
        a.Name = 'test name ';
        insert a;

        Opportunity opp = new Opportunity();
        opp.Name = 'testname';
        opp.AccountId = a.id;
        opp.Total_Head__c = 3.0;
        opp.StageName = 'Prospecting';
        opp.closeDate = System.today();
        insert opp;	

        Animal_Count_Lifestage__c acl = new Animal_Count_Lifestage__c();
        acl.Account__c = a.id;
        acl.Animal_Count__c = 3;
        acl.Animals_Served__c = 3;
        acl.Animal_Type__c = 'Cattle';
        acl.Lifestage__c = 'Cattle';
        insert acl;
        
        Test.setCurrentPageReference(new PageReference('Page.Account_Error_Page'));
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        System.currentPageReference().getParameters().put('acc_id', a.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a);
        Account_Error_Page_Controller ae = new Account_Error_Page_Controller(sc);
		
    }
    
    static testmethod void Account_errorPage_contact(){
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();

        //VIP_Purina_Account__c test_custom = new VIP_Purina_Account__c();
        //test_custom.AccountId__c = '001g000000d9FPQAA2';
        //test_custom.Contact_Owner_ID__c = '005g0000002FcvxAAC';
        //test_custom.Contact_Record_Type__c = '012g0000000DTQOAA4';
        //test_custom.Contact_Influencer_Type__c = 'Influencer,'; 
        insert test_custom;

        Account a = new Account();
        a.Name = 'test name ';
        insert a;

        Contact con = new Contact();
        con.firstName = 'testname';
        con.lastName = 'testtest';
        con.AccountId = a.id;
        insert con;

        Animal_Count_Lifestage__c acl = new Animal_Count_Lifestage__c();
        acl.Account__c = a.id;
        acl.Animal_Count__c = 3;
        acl.Animals_Served__c = 3;
        acl.Animal_Type__c = 'Cattle';
        acl.Lifestage__c = 'Cattle';
        insert acl;
        
        Test.setCurrentPageReference(new PageReference('Page.Account_Error_Page'));
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('acc_id', a.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a);
        Account_Error_Page_Controller ae = new Account_Error_Page_Controller(sc);
        
        Opportunity o = new Opportunity();
        o.Name = 'tempname';
        o.AccountId = a.id;
        o.Total_Head__c = 3.0;
        o.StageName = 'Prospecting';
        o.CloseDate = system.today();
        insert o;
            
        for(Account_Error_Page_Controller.list_Opp_item oo : ae.Selected_OppList){
            oo.selected = true;
        }
        ae.current_opp = o;
        ae.sel_conid = con.id;
        ae.selectContact();
        
        ae.showPopUp();
        ae.closePopUp();
        
        //ae.registerVIP();
        //ae.insertOpportunityRecord();
        ae.insertAnimalRecord();
		ae.createNewContact();
        ae.popupError = 'error';
    }
    
    static testmethod void Account_errorPage_contact_Success(){
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();
        
        //VIP_Purina_Account__c test_custom = new VIP_Purina_Account__c();
        //test_custom.AccountId__c = '001g000000d9FPQAA2';
        //test_custom.Contact_Owner_ID__c = '005g0000002FcvxAAC';
        //test_custom.Contact_Record_Type__c = '012g0000000DTQOAA4';
        //test_custom.Contact_Influencer_Type__c = 'Influencer,'; 
        insert test_custom;

        Account a = new Account();
        a.Name = 'test name ';
        insert a;

        Contact con = new Contact();
        con.firstName = 'testname';
        con.lastName = 'testtest';
        con.Contact_Type__c = 'Influencer';
        con.AccountId = a.id;
        insert con;
		
        Opportunity opp = new Opportunity();
        opp.Name = 'testname';
        opp.AccountId = a.id;
        opp.Total_Head__c = 3.0;
        opp.StageName = 'Prospecting';
        opp.closeDate = System.today();
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'testname';
        opp1.AccountId = a.id;
        opp1.Total_Head__c = 3.0;
        opp1.StageName = 'Prospecting';
        opp1.closeDate = System.today();
        insert opp1;
        
        Animal_Count_Lifestage__c acl = new Animal_Count_Lifestage__c();
        acl.Account__c = a.id;
        acl.Animal_Count__c = 3;
        acl.Animals_Served__c = 3;
        acl.Animal_Type__c = 'Cattle';
        acl.Lifestage__c = 'Cattle';
        insert acl;
        
        Test.setCurrentPageReference(new PageReference('Page.Account_Error_Page'));
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('acc_id', a.id);
        ApexPages.StandardController sc = new ApexPages.standardController(a);
        Account_Error_Page_Controller ae = new Account_Error_Page_Controller(sc);
        
        Opportunity o = new Opportunity();
        o.Name = 'tempname';
        o.AccountId = a.id;
        o.Total_Head__c = 3.0;
        o.StageName = 'Prospecting';
        o.CloseDate = system.today();
        insert o;
            
        for(Account_Error_Page_Controller.list_Opp_item oo : ae.Selected_OppList){
            oo.selected = true;
        }
        ae.current_opp = o;
        ae.sel_conid = con.id;
        ae.selectContact();
        
        ae.showPopUp();
        ae.closePopUp();
        
        ae.registerVIP();
        //ae.insertOpportunityRecord();
        ae.insertAnimalRecord();
    }
// DONE WITH ACCOUNT ERORR PAGES.   
    

// CONTACT SELECT PAGE 
    static testmethod void Select_Contact_Page(){
        Account a = new Account();
        a.Name = 'test name ';
        insert a;

        Contact con = new Contact();
        con.firstName = 'testname';
        con.lastName = 'testtest';
        con.Contact_Type__c = 'Influencer';
        con.AccountId = a.id;
        insert con;
        
		RecordType r = [select id, developername from RecordType WHERE developerName = 'Farm_VIP_Event'];
        Campaign c = new Campaign();
        c.Name = 'Test Farm vip event';
        c.Date_of_Event__c  = date.today();
        insert c;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Contact_Select'));
        System.currentPageReference().getParameters().put('event_id', c.id);
        VIP_Contact_Select_Controller sc = new VIP_Contact_Select_Controller();
        sc.reg_info.Registrant__c = con.id;
        sc.setOpportunitiesList();
        sc.redirect_or_error();
    }
    
    static testmethod void Select_Contact_Page_error(){
        Account a = new Account();
        a.Name = 'test name ';
        insert a;

		RecordType r = [select id, developername from RecordType WHERE developerName = 'Farm_VIP_Event'];
        Campaign c = new Campaign();
        c.Name = 'Test Farm vip event';
        c.Date_of_Event__c  = date.today();
        insert c;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Contact_Select'));
        System.currentPageReference().getParameters().put('event_id', c.id);
        VIP_Contact_Select_Controller sc = new VIP_Contact_Select_Controller();
		sc.temp = '';
        sc.setOpportunitiesList();
        sc.redirect_or_error();
    }
// DONE CONTACT SELECT PAGES.

// VIP FARM EVENTS INVITE
	static testmethod void VIP_Farm_Events_Invite_t1(){
		Account a = new Account();
        a.Name = 'test name ';
        insert a;

        Contact con = new Contact();
        con.firstName = 'testname';
        con.lastName = 'testtest';
        con.Contact_Type__c = 'Influencer';
        con.AccountId = a.id;
        insert con;
        
		RecordType r = [select id, developername from RecordType WHERE developerName = 'Farm_VIP_Event'];
        Campaign c = new Campaign();
        c.Name = 'Test Farm vip event';
        c.Date_of_Event__c  = date.today();
        insert c;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'testname';
        opp1.AccountId = a.id;
        opp1.Total_Head__c = 3.0;
        opp1.StageName = 'Prospecting';
        opp1.closeDate = System.today();
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'blah blah';
        opp2.AccountId = a.id;
        opp2.Total_Head__c = 3.0;
        opp2.StageName = 'Prospecting';
        opp2.closeDate = System.today();
        insert opp2;
        
        String tempOpps = opp1.id + ';' + opp2.id;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Farm_Events_Invite'));
        System.currentPageReference().getParameters().put('acc_id', a.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('multiOppIds', tempOpps);
        
        VIP_Farm_Events_Invite_Controller sc = new VIP_Farm_Events_Invite_Controller();
        sc.tempid = c.id;
        sc.register();        
    }
    
    static testmethod void VIP_Farm_Events_Invite_t2(){        
		RecordType r = [select id, developername from RecordType WHERE developerName = 'Farm_VIP_Event'];
        Campaign c = new Campaign();
        c.Name = 'Test Farm vip event';
        c.Date_of_Event__c  = date.today();
        insert c;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Farm_Events_Invite'));
        
        VIP_Farm_Events_Invite_Controller sc = new VIP_Farm_Events_Invite_Controller();
        sc.tempid = c.id;
        sc.register();        
    }
// DONE VIP FARM EVENTS INVITE

// Create New contact Section.
    static testmethod void createnewContact(){        
		RecordType r = [select id, developername from RecordType WHERE developerName = 'Farm_VIP_Event'];
        Account a = new Account();
        a.Name = 'test name ';
        insert a;
        
        Contact cc = new Contact();
        
        Test.setCurrentPageReference(new PageReference('Page.Account_Error_CreateContact'));
        ApexPages.StandardController sc = new ApexPages.standardController(cc);
        sc.save();
        //Account_Error_CreateNewContactController aec = new Account_Error_CreateNewContactController(sc);
    }

    static testmethod void VIP_Animals_Controller_Test_Page(){  
        // Set up registration record and set up the page itself.
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();
        
        //VIP_Purina_Account__c test_custom = new VIP_Purina_Account__c();
        //test_custom.AccountId__c = '001g000000d9FPQAA2';
        //test_custom.Contact_Owner_ID__c = '005g0000002FcvxAAC';
        //test_custom.Contact_Record_Type__c = '012g0000000DTQOAA4';
        //test_custom.Contact_Influencer_Type__c = 'Influencer,';
        insert test_custom;

        Account acc = new Account();
        acc.Name = 'test account';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'first';
        con.LastName = 'last';
        con.AccountId = acc.id;
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'testname';
        opp.AccountId = acc.id;
        opp.Total_Head__c = 3.0;
        opp.StageName = 'Prospecting';
        opp.closeDate = System.today();
        insert opp; 

        Animal_Count_Lifestage__c acl = new Animal_Count_Lifestage__c();
        acl.Account__c = acc.id;
        acl.Animal_Count__c = 3;
        acl.Animals_Served__c = 3;
        acl.Animal_Type__c = 'Cattle';
        acl.Lifestage__c = 'Cattle';
        insert acl;  
        
        RecordType farm_event = [SELECT id, developerName from RecordType where developerName = 'Farm_VIP_Event'];
        Campaign c = new Campaign();
        c.Name = 'Test Farm vip event';
        c.Date_of_Event__c  = date.today();
        c.Status = 'Registration Open';
        c.RecordTypeId = farm_event.id;
        insert c;

        Farm_VIP_Registration__c reg_rec = new Farm_VIP_Registration__c();
        reg_rec.Animals_Influenced__c = 3;
        reg_rec.Approval_Date__c = Date.today();
        reg_rec.Notes__c  = 'registration notes';
        reg_rec.Host_will_be_attending__c = 'Yes';
        reg_rec.Farm_VIP_Event__c = c.id;
        reg_rec.Registrant__c = con.id;
        insert reg_rec;

        Test.setCurrentPageReference(new PageReference('Page.VIP_Animals'));
        ApexPages.StandardController sc = new ApexPages.standardController(reg_rec);
        VIP_Animals_Controller ac = new VIP_Animals_Controller(sc);

    }
    
    

}