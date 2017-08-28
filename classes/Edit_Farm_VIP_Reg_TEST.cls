@isTest
public class Edit_Farm_VIP_Reg_TEST {

    static testMethod void testEdit(){
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();
        
        //VIP_Purina_Account__c test_custom = new VIP_Purina_Account__c();
        //test_custom.AccountId__c = '001g000000d9FPQAA2';
        //test_custom.Contact_Owner_ID__c = '005g0000002FcvxAAC';
        //test_custom.Contact_Record_Type__c = '012g0000000DTQOAA4';
        //test_custom.Contact_Influencer_Type__c = 'Influencer,';
        //insert test_custom;

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
        
        Farm_VIP_Registration__c reg = new Farm_VIP_Registration__c();
        reg.Animals_Influenced__c = 3;
        reg.Approval_Date__c = Date.today();
        reg.Notes__c  = 'registration notes';
        reg.Host_will_be_attending__c = 'Yes';
        reg.Farm_VIP_Event__c = c.id;
        reg.Approval_Status__c = 'Approved';
        reg.Registrant__c = con.id;
        insert reg;

        Farm_VIP_Registration__c cur_reg = [SELECT id, Approval_Status__c FROM Farm_VIP_Registration__c WHERE id =: reg.id];
            
        Test.setCurrentPageReference(new PageReference('Page.Edit_Farm_VIP_Reg')); 
        ApexPages.StandardController ssc = new ApexPages.standardController(cur_reg);
        Edit_Farm_VIP_Reg_Control controls = new Edit_Farm_VIP_Reg_Control(ssc);
        
        controls.saveAndUpdate();
        controls.cancelEdit();
    }
    
}