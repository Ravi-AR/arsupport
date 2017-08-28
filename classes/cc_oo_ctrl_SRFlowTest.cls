@isTest
private class cc_oo_ctrl_SRFlowTest {
	
	@isTest
    static void test_getIsActiveUser() {
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        Contact contactCC = new Contact(
                FirstName = 'CloudCraze',
                LastName  = 'TestUser',
                Email = 'abc@xyz.com',
                AccountId = cc_lol_TestData.testAccount.Id,
                MailingStreet = 'abc'
                
        );
        insert contactCC;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(contactCC);
        
        User thisUser = [SELECT Id, IsActive FROM User WHERE Id = :UserInfo.getUserId()];
        
        Test.startTest(); 
        cc_oo_ctrl_SRFlow testCtrl = new cc_oo_ctrl_SRFlow(sc);
        testCtrl.getIsActiveUser();
        
        Test.stopTest();
        System.assertequals(thisUser.isActive,true);
    }
    
    @isTest
    static void test_getIsActiveUserNegative() {
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        cc_oo_ctrl_SRFlow testCtrl = new cc_oo_ctrl_SRFlow();
        User thisUser = [SELECT Id,IsActive FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
        	cc_lol_TestData.setupTestUser();
        }
        Test.startTest(); 
        testCtrl.getIsActiveUser();
        
        Test.stopTest();
        System.assertequals(thisUser.isActive,true);
    }
    
    @isTest
    static void test_forward() {    
    	//Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
         
        
        ApexPages.Standardcontroller sc;
        
    	User thisUser = [SELECT Id, IsActive FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){	
        	cc_lol_TestData.setupTestUser();
        	Contact contactCC = [select id from Contact limit 1];
        	sc = new ApexPages.Standardcontroller(contactCC);
        }
        
        
        Test.startTest(); 
    	PageReference testPage = new PageReference('HomePage');
	    Test.setCurrentPage(testPage);
	    Test.stopTest();
	    cc_oo_ctrl_SRFlow testCtrl = new cc_oo_ctrl_SRFlow(sc);
        pageReference pr1=testCtrl.forward();
       
        System.assert(pr1!=NULL);
      
     
    }
    
}