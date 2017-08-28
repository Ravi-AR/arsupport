// Farm_VIP_Approval_TESTS
// VIP Test Class
// ------------------------------------------------------------------
// Author Date Description
// ------------------------------------------------------------------
// Justin Gerstl  08/16/2015 Created
//
@isTest
public class Farm_VIP_Approval_TESTS {
    // TEST THE REGISTRATION PAGE AND CONTROLLER. 

    static testMethod void testApprovalProcessInfluencer(){     
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
        con.FirstName = '111first';
        con.LastName = '11last';
        con.AccountId = acc.id;
        con.Contact_Type__c = 'Influencer';
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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Event_Register'));
        System.currentPageReference().getParameters().put('acc_id', acc.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        System.currentPageReference().getParameters().put('multiOppIds', opp.id);        
        System.currentPageReference().getParameters().put('camp_id', c.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Event_Register_Controller ae = new VIP_Event_Register_Controller(sc);
        

//        ae.cur_reg.Animals_Influenced__c = 3;
//        ae.cur_reg.Approval_Date__c = Date.today();
//        ae.cur_reg.Notes__c  = 'registration notes';
//        ae.cur_reg.Host_will_be_attending__c = 'Yes';
//      ae.cur_reg.Farm_VIP_Event__c = c.id;
        ae.cur_event = c;        
        ae.cur_account = acc;
        ae.cur_opportunity = opp;
        ae.cur_contact = con;
        
        //insert ae.cur_reg;
        
        ae.overrideSave();
        Farm_VIP_Registration__c ll = [SELECT id, Notes__c, Farm_VIP_Event__c FROM Farm_VIP_Registration__c WHERE Farm_VIP_Event__c =: c.id];
        system.assert(ll != null);
    }

    static testMethod void testApprovalProcess(){   
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
        con.FirstName = '22first';
        con.LastName = '22last';
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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Event_Register'));
        System.currentPageReference().getParameters().put('acc_id', acc.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        System.currentPageReference().getParameters().put('multiOppIds', opp.id);        
        System.currentPageReference().getParameters().put('camp_id', c.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Event_Register_Controller ae = new VIP_Event_Register_Controller(sc);

        ae.cur_event = c;        
        ae.cur_account = acc;
        ae.cur_opportunity = opp;
        ae.cur_contact = con;

        ae.overrideSave();
    }
    
    
    static testMethod void ApproveRecord(){
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
        con.FirstName = '33first';
        con.LastName = '33last';
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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Event_Register'));
        System.currentPageReference().getParameters().put('acc_id', acc.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        System.currentPageReference().getParameters().put('multiOppIds', opp.id);        
        System.currentPageReference().getParameters().put('camp_id', c.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Event_Register_Controller ae = new VIP_Event_Register_Controller(sc);

        ae.cur_event = c;        
        ae.cur_account = acc;
        ae.cur_opportunity = opp;
        ae.cur_contact = con;

        ae.overrideSave();
        
        Farm_VIP_Registration__c approve_reg = [SELECT id, Approval_Status__c, Host_will_be_attending__c 
                                                FROM Farm_VIP_Registration__c
                                                WHERE id =: ae.cur_reg.id];
        approve_reg.Approval_Status__c = 'Approved ';
        approve_reg.Host_will_be_attending__c = 'Yes';
        update approve_reg;
    }

    // Will need test methods for the -- creat new contact portion of the test. 
    static testMethod void addMoreContacts(){
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
        con.FirstName = '44first';
        con.LastName = '44last';
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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Event_Register'));
        System.currentPageReference().getParameters().put('acc_id', acc.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        System.currentPageReference().getParameters().put('multiOppIds', opp.id);        
        System.currentPageReference().getParameters().put('camp_id', c.id);
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Event_Register_Controller ae = new VIP_Event_Register_Controller(sc);

        ae.cur_event = c;        
        ae.cur_account = acc;
        ae.cur_opportunity = opp;
        ae.cur_contact = con;

        ae.showAddContacts();
        ae.createRelatedContact();
        ae.addContacttoList();
        ae.overridePhonepop();
        ae.MakeInfluencer();
        ae.unMakeInfluencer();

        //ae.overrideSave();
        
        //ae.cur_reg.Approval_Status__c = 'Approved ';
        //ae.cur_reg.Host_will_be_attending__c = 'Yes';
        //update ae.cur_reg;
    }

    // Will need test methods for the -- creat new contact portion of the test. 
    static testMethod void testSelectOpportunityController(){
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
        con.FirstName = '55first';
        con.LastName = '55last';
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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        
        Test.setCurrentPageReference(new PageReference('Page.VIP_Farm_Events_Invite'));
        System.currentPageReference().getParameters().put('acc_id', acc.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Select_Opportunity_Controller ae = new VIP_Select_Opportunity_Controller(sc);

        ae.selectOpp();
    }    
    
    static testMethod void testVIPContactsController(){
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();
        insert test_custom;
        
        Account acc = new Account();
        acc.Name = 'test account';
        insert acc;
        
        Contact con1 = new Contact();
        con1.FirstName = '66first';
        con1.LastName = '66last';
        con1.AccountId = acc.id;
        insert con1;
        
        Contact con2 = new Contact();
        con2.FirstName = '77first';
        con2.LastName = '77last';
        con2.AccountId = acc.id;
        insert con2;
        
        String contacts = con1.Id + ',' + con2.Id;
        
        RecordType farm_event = [SELECT id, developerName from RecordType where developerName = 'Farm_VIP_Event'];
        Campaign c = new Campaign();
        c.Name = 'Test Farm vip event';
        c.Date_of_Event__c  = date.today();
        c.Status = 'Registration Open';
        c.RecordTypeId = farm_event.id;
        insert c;
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        reg.Registrant__c = con1.id;
        reg.Related_Contact_Ids__c = contacts;
        insert reg;
                
        System.currentPageReference().getParameters().put('id', reg.id);
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Contacts_Control ae = new VIP_Contacts_Control(sc);
        
        ae.conClick = con1.Id;
        ae.gotoContact();
    }

    static testMethod void addRelatedContactIDs(){
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
        
        List<Contact> l_related_contacts = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = '88first';
        con.LastName = '88last';
        con.User_Record__c = UserInfo.getUserId();
        con.AccountId = acc.id;
        l_related_contacts.add( con );

        Contact con2 = new Contact();
        con2.FirstName = '99first';
        con2.LastName = '99last';
        con2.User_Record__c = UserInfo.getUserId();
        con2.AccountId = acc.id;
        l_related_contacts.add( con2 );

        Contact con3 = new Contact();
        con3.FirstName = 'first';
        con3.LastName = 'last';
        con3.User_Record__c = UserInfo.getUserId();
        con3.AccountId = acc.id;
        l_related_contacts.add( con3 );
        
        insert l_related_contacts;
        
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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = c.id;
        cm.Status = 'Sent';
        cm.ContactId = con2.id;
        insert cm;

        Test.setCurrentPageReference(new PageReference('Page.VIP_Event_Register'));
        System.currentPageReference().getParameters().put('acc_id', acc.id);
        System.currentPageReference().getParameters().put('con_id', con.id);
        System.currentPageReference().getParameters().put('opp_id', opp.id);
        System.currentPageReference().getParameters().put('multiOppIds', opp.id);        
        System.currentPageReference().getParameters().put('camp_id', c.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(reg);
        VIP_Event_Register_Controller ae = new VIP_Event_Register_Controller(sc);

        ae.cur_event = c;        
        ae.cur_account = acc;
        ae.cur_opportunity = opp;
        ae.cur_contact = con;

        String temp_id = con2.id + ',' + con3.id + ',';
        reg.Related_Contact_Ids__c = temp_id;

        ae.overrideSave();        
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'testname';
        opp1.AccountId = acc.id;
        opp1.Total_Head__c = 3.0;
        opp1.StageName = 'Prospecting';
        opp1.closeDate = System.today();
        opp1.Farm_VIP_Registration__c = reg.id;
        insert opp1;

        // before we send this record through the approval status - need to add contacts to create campaign members.
        Farm_VIP_Registration__c approve_reg = [SELECT id, Approval_Status__c, Host_will_be_attending__c 
                                                FROM Farm_VIP_Registration__c
                                                WHERE id =: ae.cur_reg.id];
        approve_reg.Approval_Status__c = 'Approved ';
        approve_reg.Host_will_be_attending__c = 'Yes';
        update approve_reg;


    }

    static testMethod void convertLead(){
        Lead l = new Lead();
        l.lastName = 'test';
        l.Company = 'test';
        l.Status = 'Open';
        insert l;

        Question__c q = new Question__c();
        q.Animal_Count_Update__c = true;
        q.Animal_Type__c         = 'Cattle';
        insert q;

        Answer__c a = new Answer__c();
        a.Question__c = q.id;
        a.Answer_Option__c = '100-200';
        insert a;

        Survey_Results__c sr        = new Survey_Results__c();
        sr.Question_Answer_ID__c    = q.id;
        sr.Answer_Lookup__c         = a.id;
        sr.Lead__c                  = l.id;
        insert sr;

        Lead ll = [SELECT id, isConverted FROM Lead WHERE id =: l.id];

        //l.convert();
         Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(ll.id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = null;
        lcr = Database.convertLead(lc);
    }

    static testMethod void deleteAnimalCounts(){
        Account acc = new Account();
        acc.Name='testAcc';
        insert acc;

        Animal_Count_Lifestage__c acl = new Animal_Count_Lifestage__c();
        acl.Account__c = acc.id;
        acl.Animal_Count__c = 3;
        acl.Animals_Served__c = 3;
        acl.Animal_Type__c = 'Cattle';
        acl.Lifestage__c = 'Cattle';
        insert acl; 

        List<Animal_Count_Lifestage__c> cur_acl = [SELECT id from Animal_Count_Lifestage__c
                                                    WHERE id =: acl.id];
        delete cur_acl;
    }
    
}