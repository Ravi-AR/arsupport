@isTest 
private class cc_oo_FooterControllerTest {
    //Test scenario for the constructor
    @isTest 
    static void test_cc_oo_FooterController(){      
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        String dedicatedCustomerOpRepFirstNameInitial = 'W';
        String dedicatedCustomerOpRepLastName = 'Blackburn';
        String dedicatedCustomerOpRepName = 'William';        
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
   		
        system.runas(thisUser){
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.setupOOSettings();
            Profile profile = [SELECT Id FROM Profile WHERE Name = 'Customer Operations' LIMIT 1];
            User UserData = new User(
                Alias                    = 'cctest1',
                Email                    = 'email@abcabc.com',
                EmailEncodingKey         = 'UTF-8',
                FirstName                = 'TestUser2',
                LastName                 = 'TestUser1',
                LanguageLocaleKey        = 'en_US',
                LocaleSidKey             = 'en_US',
                ProfileId                = profile.Id,
                TimeZoneSidKey           = 'GMT',
                Username                 = 'email@abcabc.com',
                isActive                 = true,
                ccrz__CC_CurrencyCode__c = 'USD'
        	);
        	insert UserData;
            Account accData = [select Name, AccountNumber,Email__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.FirstName,Dedicated_Customer_Op_Rep__r.LastName from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
            accData.Name = 'Shivani Account';
            accData.Email__c = 'abc@abc.com';
            accData.Dedicated_Customer_Op_Rep__c = UserData.Id;
            update accData;  
        }
        Test.startTest();       
        cc_oo_FooterController tstCtrl = new cc_oo_FooterController();
        Test.stopTest();
        system.assert(tstCtrl!=null);
    }
}