@isTest
public class Cancel_VIP_Registration_TESTs {

        static testMethod void testCancelation(){       
            
            
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
                ae.cur_reg.Approval_Status__c = 'Approved ';
                ae.cur_reg.Host_will_be_attending__c = 'Yes';
                update ae.cur_reg;
                
            Test.setCurrentPageReference(new PageReference('Page.Cancel_VIP_Registration')); 
            ApexPages.StandardController ssc = new ApexPages.standardController(ae.cur_reg);
            Cancel_VIP_Reg_Control controls = new Cancel_VIP_Reg_Control(ssc);
            
            controls.cancel_reg();
        }
    
    
}