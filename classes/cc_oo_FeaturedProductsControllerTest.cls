//ClassName:cc_oo_FeaturedProductsControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shivani Singh	                         03/14/2016                                       Test class for cc_oo_FeaturedProductsController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_FeaturedProductsControllerTest {
    //Test scenario for the constructor
    @isTest 
    static void getSpotlightProductsTest(){      
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            //Create Contact
            Contact contactCC = new Contact(
                FirstName = 'CloudCraze',
                LastName  = 'TestUser1',
                Email = 'abcd@xyz.com',
                AccountId = cc_lol_TestData.testAccount.id,
                MailingStreet = 'abc'
       		 );
        	insert contactCC;
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
            testCart = cc_lol_TestData.createCart();
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            
            Map<String,String> pageParams = new Map<String, String>();
            pageParams.put('cartID', String.valueOf(testCart.ccrz__EncryptedId__c));
            pageParams.put('sid', String.valueOf(seller.Id));
            ccrz.cc_CallContext.currPageParameters = pageParams;
        }
        // Custom Setting for CSR Email Address and Phone Number
        cc_lol_TestData.setupOOSettings();
        Test.startTest();
		ccrz.cc_RemoteActionResult remoteResult =cc_oo_FeaturedProductsController.getSpotlightProducts(ctx);
        Test.stopTest();
        system.assert(remoteResult.data!=null,true);
    }
}