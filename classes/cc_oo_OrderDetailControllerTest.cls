//ClassName:cc_oo_OrderDetailControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                               10/6/2016                                      OO-207 - Test class for cc_oo_OrderDetailController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_OrderDetailControllerTest {
              /* For cc_oo_OrderDetailController() constructor */              
    @isTest                                      
                  static void test_cc_oo_OrderDetailController(){                                         
                      //Prepare Test Data                                         
                      ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();                            
                      ccrz.cc_CallContext.initRemoteContext(ctx);                            
                      ccrz__E_Cart__c testCart;                               
                      ccrz__E_Order__c testOrder;                                        
                      String secondaryCartId;                                   
                      String urlOrderId;                               
                      String jdeOrderNo;                             
                      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];                                     
                      system.runas(thisUser){                                   
                          System.debug('Set catalog');                                     
                          cc_lol_TestData.setupCatalog();                               
                          ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id;                             
                          ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;                             
                          testCart = cc_lol_TestData.createCart();                               
                          cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);                                      
                          ApexPages.currentPage().getParameters().put('cartID', testCart.ccrz__EncryptedId__c);                             
                                                       
                          testOrder = cc_lol_TestData.createOrders(1)[0];                                    
                          ApexPages.currentPage().getParameters().put('o', testOrder.ccrz__EncryptedId__c);                                        
                          update testOrder;                                        
                      }                                
                      cc_lol_TestData.setupOOSettings();                             
                      Test.startTest();                                  
                      cc_oo_OrderDetailController tstCtrl = new cc_oo_OrderDetailController();                              
                      Test.stopTest();                                   
                      system.assert(tstCtrl!=null);                            
                                                       
                  }                                    
              
    /*
    This method is the test method which is used in the cc_oo_OrderDetailController class
    */    
    @isTest 
    static void getProductsDetailsTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart,testCart1;
        ccrz__E_Order__c testOrder;
        //String promotionCode;//OO-3252
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            cc_lol_TestData.setupTestUser();
            Account testAccount =  cc_lol_TestData.testAccount;
            testCart = cc_lol_TestData.createCart(); 
            testCart1=cc_lol_TestData.createCart();
         	ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = thisUser.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
            testOrder = cc_lol_TestData.createOrders(1)[0];
            testOrder.ccrz__OriginatedCart__c=testCart1.id;
            testOrder.cc_oo_Seller__c=seller.id;
            testOrder.cc_oo_ShipToAccount__c= cc_lol_TestData.testAccount.Id;
            cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[7].Id,18,200.00);
            update testOrder;
        }  
            
        //Test the scenario
        Test.startTest(); 
                      
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderDetailController.getProductsDetails(ctx,testOrder.id);
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success,true);
    }
    
     @isTest static void get_Order_DetailsTest() {
        List<ccrz__E_Order__c> orders;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Order__c testOrder;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            orders = cc_lol_TestData.createOrders(1);
            orders[0].cc_oo_JDEOrderNumber__c = '12345';
            update orders[0];
        }
        testOrder = [SELECT id,cc_oo_JDEOrderNumber__c,ccrz__OrderNumber__c FROM ccrz__E_Order__c WHERE
                                    Id = :orders[0].Id LIMIT 1];
        Test.startTest();
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        ccrz.cc_RemoteActionResult rar = cc_oo_OrderDetailController.getOrderDetails(ctx,String.valueof(testOrder.ccrz__OrderNumber__c));
        Test.stopTest();
        System.assert(rar != null);
        System.assert(rar.data != null);
        Map<String,String> dataMap = (Map<String,String>) rar.data;
        System.assert(dataMap.containsKey('cc_oo_JDEOrderNumber__c'));
        System.assertEquals(dataMap.get('cc_oo_JDEOrderNumber__c'), [SELECT cc_oo_JDEOrderNumber__c FROM ccrz__E_Order__c WHERE Id = :testOrder.Id LIMIT 1][0].cc_oo_JDEOrderNumber__c);
    }
    
    //to test the vfd flag product
    @isTest 
    static void getProductsVfdFlagTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            //ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            //PageReference pageRef = Page.ccrz__HomePage;
            //Test.setCurrentPageReference(pageRef);
            //ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            //ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_LeadTime__c='3 Days');
            //insert prodInvItem;
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderDetailController.getVfdFlag(ctx,productIdList);
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            ///if(remoteResult.success){
            //    Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            //    system.assertEquals(mapProductData.size()>0,true);
            //}
        }
    }
   // Test method for getPONumber() in cc_oo_OrderDetailController.cls          
   @isTest          
    static void getPONumberTest(){          
    // Prepare Test Data            
    ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();            
    User thisUser = [Select Id from User where Id =:UserInfo.getUserId()];          
    ccrz__E_Cart__c testCart;           
    ccrz__E_Order__c testOrder;         
    system.runas(thisUser){         
        cc_lol_TestData.setupCatalog();         
        testCart = cc_lol_TestData.createCart();            
        cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
        testOrder = cc_lol_TestData.createOrders(1)[0];         
        //cc_lol_TestData.testOrderItems(testOrder,cc_lol_TestData.products[0].Id,200.00);          
        update testOrder; 
        Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = thisUser.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
    }           
    //Test the scenario         
     Test.startTest();          
     ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderDetailController.getPONumber(ctx,testOrder.id);           
     Test.stopTest();           
     //Validate the test data           
     system.assert(remoteResult!=null); 
}
@isTest         
    static void getOrderConfirmationDetailsTest(){          
    // Prepare Test Data            
    ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();            
    User thisUser = [Select Id from User where Id =:UserInfo.getUserId()];          
    ccrz__E_Cart__c testCart;           
    ccrz__E_Order__c testOrder;         
    system.runas(thisUser){         
        cc_lol_TestData.setupCatalog(); 
        cc_lol_TestData.setupOOSettings();      
        testCart = cc_lol_TestData.createCart();            
        cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
        testOrder = cc_lol_TestData.createOrders(1)[0];         
        //cc_lol_TestData.testOrderItems(testOrder,cc_lol_TestData.products[0].Id,200.00);          
        update testOrder;           
    }           
    //Test the scenario         
     Test.startTest();          
     ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderDetailController.getOrderConfirmationDetails(ctx,testOrder.id);           
     Test.stopTest();           
     //Validate the test data           
     system.assertEquals(remoteResult.success,true);        
}
    @isTest         
    static void getOrderTotalWeightTest(){          
        // Prepare Test Data            
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();            
        User thisUser = [Select Id from User where Id =:UserInfo.getUserId()];          
        ccrz__E_Cart__c testCart;           
        ccrz__E_Order__c testOrder;         
        system.runas(thisUser){         
            cc_lol_TestData.setupCatalog();         
            testCart = cc_lol_TestData.createCart();            
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
            testOrder = cc_lol_TestData.createOrders(1)[0];         
            //cc_lol_TestData.testOrderItems(testOrder,cc_lol_TestData.products[0].Id,200.00);          
            update testOrder;           
        }           
        //Test the scenario         
         Test.startTest();          
         ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderDetailController.getOrderTotalWeight(ctx,testOrder.id);           
         Test.stopTest();           
         //Validate the test data           
         system.assertEquals(remoteResult.success,true);        
    }    
}