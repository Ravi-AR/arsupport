@isTest
private class cc_oo_ContactUSEmailTest{
    @isTest
    static void sendEmailDetailsTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;   
            testCart = cc_lol_TestData.createCart();
            Account accData = [select Id, Name, AccountNumber,Email__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.Name from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
            accData.Name = 'Shivani Account';
            
            update accData;  
        }
        cc_lol_TestData.setupOOSettings();
        Test.startTest(); 
        System.debug('Starting remote');              
        cc_oo_HelperController helperCtrl = new cc_oo_HelperController();
        helperCtrl.sendEmail('abc@gmail.com','xyz@gmail.com','Subject','Message');
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_ContactUSEmailController.sendEmailDetails(ctx,'abc');
        System.debug('Send email details: '+ remoteResult1.data);
        Test.stopTest();
        system.assertEquals(remoteResult1.data!=null,true);
    }
    @isTest
    static void sendEmailDetailsTest1(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;   
            testCart = cc_lol_TestData.createCart();
            Account accData = [select Id, Name, AccountNumber,Email__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.Name from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
            accData.Name = 'Shivani Account';
            
            update accData;  
        }
        cc_lol_TestData.setupOOSettings();
        Test.startTest(); 
        System.debug('Starting remote');              
        cc_oo_HelperController helperCtrl = new cc_oo_HelperController();
        helperCtrl.sendEmail('abc@gmail.com','xyz@gmail.com','Subject','Message');
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_ContactUSEmailController.sendEmailDetails(ctx,null);
        System.debug('Send email details: '+ remoteResult1.data);
        Test.stopTest();
        system.assertEquals(remoteResult1.data!=null,true);
    }
     //Test scenario for the constructor
    @isTest 
    static void test_cc_oo_ContactUSEmail(){      
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;
            testCart = cc_lol_TestData.createCart();
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
        // Custom Setting for CSR Email Address and Phone Number
        cc_lol_TestData.setupOOSettings();
        Test.startTest();
        cc_oo_ContactUSEmailController tstCtrl = new cc_oo_ContactUSEmailController();
        Test.stopTest();
        system.assert(tstCtrl!=null);
    }
}