@isTest
private class cc_oo_MyAccountOrdersControllerTest {
    
    @isTest
    private static void amendOrderTest(){
         //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        List<ccrz__E_Order__c> orders;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            orders = cc_lol_TestData.createOrders(1);
            orders[0].ccrz__OriginatedCart__c = testCart.id;
            orders[0].ccrz__User__c = thisUser.id;
            update orders[0];
        }  
            
        //Test the scenario
        Test.startTest();            
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountOrdersController.amendOrder(ctx,orders[0].Id);
        orders[0].ccrz__OriginatedCart__c = null;
        update orders[0];
        remoteResult = cc_oo_MyAccountOrdersController.amendOrder(ctx,orders[0].Id);
        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.data!=null,true);
    }
    
    /*@isTest
    private static void getOrderDetailsTest(){
         //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        List<ccrz__E_Order__c> orders;
        ccrz__E_Order__c newOrder;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            orders = cc_lol_TestData.createOrders(1);
            orders[0].cc_oo_JDEOrderNumber__c = '12345';
            newOrder = [Select ccrz__Account__r.AccountNumber,cc_oo_JDEFlag__c,ccrz__OrderStatus__c ,cc_oo_Seller__r.ccrz__SellerId__c from ccrz__E_Order__c where Id=:orders[0].Id LIMIT 1];
            newOrder.ccrz__Account__c = cc_lol_TestData.testAccount.Id;
            newOrder.cc_oo_Seller__c = [Select Id from ccrz__E_Seller__c LIMIT 1].Id;
            
            update newOrder;
        }  
        List<Id> orderIds = new List<Id>();
        orderIds.add(orders[0].Id);
        //Test the scenario
        Test.startTest();            
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountOrdersController.getOrderDetails(ctx,orderIds,'');
        newOrder.cc_oo_JDEFlag__c='1';
        update newOrder;
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_MyAccountOrdersController.getOrderDetails(ctx,orderIds,'');
        newOrder.cc_oo_JDEFlag__c='2';
        neworder.ccrz__OrderStatus__c='done';
        update newOrder;
        ccrz.cc_RemoteActionResult remoteResult2 = cc_oo_MyAccountOrdersController.getOrderDetails(ctx,orderIds,'');
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.data!=null,true);
    }*/
    
    // Method added for getAllShipValues() method
    @isTest
    static void test_getAllShipValues(){
              // Prepare Test data
              ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
              User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
              ccrz__E_Cart__c testCart;
              List<ccrz__E_Order__c> orders;
              ccrz__E_Order__c orders1;
               system.runAs(thisUser){   
                cc_lol_TestData.setupCatalog();
                orders= cc_lol_TestData.createOrders(3);
                   System.debug(orders.size());
                   Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
                  testCart = cc_lol_TestData.createCart();
                  cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00); 
                   
                   orders[0].ccrz__Contact__c =  contactCC.Id;
                   orders[0].ccrz__Account__c =cc_lol_TestData.testAccount.Id;
                   orders[0].ccrz__User__c=thisUser.Id;
                   update orders;                        
                   ccrz.cc_CallContext.currContact = contactCC; 
                    ccrz.cc_CallContext.currContact.Id = contactCC.Id;
                    ccrz.cc_CallContext.currAccount = cc_lol_TestData.testAccount; 
                    ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
                    ccrz.cc_CallContext.currUserId = thisUser.Id; 
                    ccrz.cc_CallContext.currAccountGroup = cc_lol_TestData.testAccountGroup; 
                  
               }
               
              Test.startTest(); 
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountOrdersController.getAllShipValues(ctx);
            system.debug(remoteResult);
            Test.stopTest();
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
                          
    }
     @isTest
    private static void cancelOrderTest(){
         //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        List<ccrz__E_Order__c> orders;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            orders = cc_lol_TestData.createOrders(1);
            orders[0].ccrz__OriginatedCart__c = testCart.id;
            orders[0].ccrz__User__c = thisUser.id;
            update orders[0];
        }  
            
        //Test the scenario
        Test.startTest();            
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountOrdersController.cancelOrder(ctx,orders[0].Id);
        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.data!=null,true);
    }
    
    @isTest
    private static void getRedirectUrlTest(){
         //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        String shipDString='01/27/2017';
        
        List<ccrz__E_Order__c> orders;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            orders = cc_lol_TestData.createOrders(1);
            orders[0].ccrz__OriginatedCart__c = testCart.id;
            orders[0].ccrz__User__c = thisUser.id;
            update orders[0];
            Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
            ccrz.cc_CallContext.currContact = contactCC; 
            ccrz.cc_CallContext.currContact.Id = contactCC.Id;
            ccrz.cc_CallContext.currAccount = cc_lol_TestData.testAccount; 
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = thisUser.Id; 
            ccrz.cc_CallContext.currAccountGroup = cc_lol_TestData.testAccountGroup; 
          	
            
            
        }  
        Account testAccount =  cc_lol_TestData.testAccount;
        
        ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
          
        
        //Test the scenario
        Test.startTest();            
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountOrdersController.getReorderUrl(ctx,orders[0].Id,testCart.ccrz__EncryptedId__c, testAccount.AccountNumber, orders[0].cc_oo_Seller__c, shipDString);   
        
        Map<String,String> pageParams = new Map<String, String>();
        pageParams.put('cartID', String.valueOf(testCart.ccrz__EncryptedId__c));
        pageParams.put('sid', String.valueOf(seller.Id));
        ccrz.cc_CallContext.currPageParameters = pageParams;
        ccrz.cc_CallContext.currURL = 'https://prebookqa-landolakespartners.cs62.force.com/PurinaMills/ccrz__MyAccount?viewState=myOrders&cclcl=en_US&orderType={}&promotionCode={}&sid=a2s5C000000KyrFQAS&isSameShipto=false&cartID=0b9a66ad-2809-4945-8be4-9f630e8f47b7';
            
		remoteResult = cc_oo_MyAccountOrdersController.getReorderUrl(ctx,orders[0].Id,testCart.ccrz__EncryptedId__c, testAccount.AccountNumber, seller.Id, shipDString);   
                        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.data!=null,true);
    }
}