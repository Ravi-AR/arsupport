@isTest
private class cc_oo_MyAccountCartsControllerTest{ 
    
    private static ccrz__E_Cart__c testCart;

   /* @isTest static void test_getCartDetails() {
        //setupTestData();
        // Prepare Test data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        final List<String> cartIds = new List<String> { testCart.ccrz__EncryptedId__c };
        System.runAs(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart= cc_lol_TestData.createCarts(1)[0];     
        }
        Test.startTest();
            ccrz.cc_RemoteActionResult rar = cc_oo_MyAccountCartsController.getCartDetails(ctx, cartIds);
        Test.startTest();
        System.assert(rar != null);
        System.assert(rar.data != null);
        Map<String,String> dataMap = (Map<String,String>) rar.data; 
        System.assert(dataMap.containsKey(testCart.ccrz__EncryptedId__c));
    } */
    @isTest
    static void getCartDetailsTest(){
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        List<String> cartIds = new List<String>(); 
        system.runas(thisUser){
        	ccrz.ccLog.log('Set catalog');
            cc_lol_TestData.setupCatalog(); 
            testCart = cc_lol_TestData.createCart();
            cartIds.add(testCart.ccrz__EncryptedId__c);
            
        }
        Test.startTest();
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountCartsController.getCartDetails(ctx,cartIds);
        Test.stopTest();
        System.assert(remoteResult.data != null);
    }
   /* private static void setupTestData() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.setupCatalog();
        }
        
    } */
    
    /* Test method for getAllShipValues() method */
    @isTest
    static void test_getAllShipValues(){
              // Prepare Test data
              ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
              User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
              
              List<ccrz__E_Cart__c> testShipToShipFrom;
              List<ccrz__E_Cart__c> test1ShipToShipFrom;
               system.runAs(thisUser){
                cc_lol_TestData.setupTestUser();
        
                 System.runAs(cc_lol_TestData.testUser) 
               {
              cc_lol_TestData.setupCatalog();
              testShipToShipFrom = cc_lol_TestData.createCarts(3);
                   for(ccrz__E_Cart__c test1:testShipToShipFrom){
                       
                   }
              // Create Seller
            List<ccrz__E_Seller__c> seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 3];
              Test.startTest(); 
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountCartsController.getAllShipValues(ctx);
            ccrz.ccLog.log(remoteResult);
            Test.stopTest();
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
        }
               }      
    }
}