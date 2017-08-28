//ClassName:cc_oo_OrderViewControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                               10/4/2016                                      OO-372 - Test class for cc_oo_OrderViewPrebookController
//Samruddhi Gokhale                         10/5/2016                                      OO-211 - Test class for saving alternate email address       
// Saloni Kale                              11/21/2016                                     Test class for cc_oo_OrderItemsController for getOrderDetails() method
//-----------------------------------------------------------------------------------------------------------------------
@isTest
public without sharing class cc_oo_OrderItemsControllerTest {
    
  //Test scenario for the constructor
    @isTest 
    static void test_cc_oo_OrderItemsController(){   
      //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        cc_oo_OrderItemsController tstCtrl;
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();      
          Test.startTest(); 
          ccrz.cc_CallContext.currAccountId= cc_lol_TestData.testAccount.Id;
            tstCtrl = new cc_oo_OrderItemsController();
          Test.stopTest();
          
        }   
        System.assert(tstCtrl!=NULL);
    } 
    
    @isTest 
    static void getProductsDetailsTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart,testCart1;
         ccrz__E_Order__c testOrder;
        ccrz__E_CartItem__c cartitem;
        system.runas(thisUser){
        cc_lol_TestData.setupCatalog();
        cc_lol_TestData.setupTestUser();
        testCart = cc_lol_TestData.createCart(); 
        testCart1 = cc_lol_TestData.createCart(); 
        ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
        Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
        cartitem=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,12,200.00);
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = thisUser.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
            testOrder = cc_lol_TestData.createOrders(1)[0];
            testOrder.ccrz__OriginatedCart__c=testCart1.id;
            testOrder.cc_oo_Seller__c=seller.id;
            testOrder.cc_oo_ShipToAccount__c= cc_lol_TestData.testAccount.Id;
            testCart.cc_oo_Seller__c=seller.id;
            testCart.cc_oo_ShipToAccount__c= cc_lol_TestData.testAccount.Id;
            testCart1.cc_oo_Seller__c=seller.id;
            testCart1.cc_oo_ShipToAccount__c= cc_lol_TestData.testAccount.Id;
            cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[7].Id,18,200.00);
            //cc_lol_TestData.testOrderItems(testOrder,cc_lol_TestData.products[0].Id,200.00);
            update testOrder;
      
        //Test the scenario
        Test.startTest(); 
                      
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.getProductsDetails(ctx,testCart.id);
       
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_OrderItemsController.getProductsDetailsCheckout(ctx,testCart.id);
        cartitem.cc_oo_IsListPrice__c=true;
        update cartitem;
        remoteResult1 = cc_oo_OrderItemsController.getProductsDetailsCheckout(ctx,testCart.id);
        remoteResult1 = cc_oo_OrderItemsController.getProductsDetailsCheckout(ctx,testCart1.id);
        remoteResult = cc_oo_OrderItemsController.getProductsDetails(ctx,null);
        remoteResult1 = cc_oo_OrderItemsController.getProductsDetailsCheckout(ctx,null);
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success,true);
        /*if(remoteResult.success){
            Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            system.assertEquals(mapProductData.size()>0,true);
        }*/
    }
    }
    @isTest 
    static void saveAlternateEmailTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
        Test.startTest(); 
                      
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.saveAlternateEmail(ctx,testCart.id,'abc@xyz.com');
        remoteResult = cc_oo_OrderItemsController.saveAlternateEmail(ctx,null,'abc@xyz.com');
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success,true);
        system.assert(remoteResult!=null);
    }
    @isTest
    static void getOrderDetailsTest(){
       //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            testCart.cc_oo_AmendedCart__c=true;
            testCart.cc_oo_JDEPreviousOrderNumber__c='123467890123';
            update testCart;
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
        Test.startTest(); 
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.getOrderDetails(ctx,testCart.id);
         ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_OrderItemsController.getOrderDetails(ctx,null);
        
        Test.stopTest();
        
        //Validate the test data
        //system.assertEquals(remoteResult.success,true);
    system.assertEquals(remoteResult.success,true);
        system.assert(remoteResult!=null);            
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
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.getVfdFlag(ctx,productIdList);
            ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_OrderItemsController.getVfdFlag(ctx,null);
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            ///if(remoteResult.success){
            //    Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            //    system.assertEquals(mapProductData.size()>0,true);
            //}
        }
    }
    @isTest
    static void getOrderReViewDetailsTest(){
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        cc_lol_TestData.setupOOSettings();
        Test.startTest();               
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.getOrderReViewDetails(ctx,testCart.id);   
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_OrderItemsController.getOrderReViewDetails(ctx,null);   
        Test.stopTest();    
        //Validate the test data
        system.assertEquals(remoteResult.success,true);
    }
    @isTest
    static void getOrderReViewLeadTimeDetailsTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod:([select id from ccrz__E_Product__c LIMIT 3])){
                productIdList.add(prod.Id);
            }
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__Status__c='Available',ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_LeadTime__c='3 Days',cc_oo_Seller__c=seller.id);
            insert prodInvItem;
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult =cc_oo_OrderItemsController.getOrderReViewLeadTimeDetails(ctx,productIdList);
            ccrz.cc_RemoteActionResult remoteResult1 =cc_oo_OrderItemsController.getOrderReViewLeadTimeDetails(ctx,null);
            system.assertEquals(remoteResult.success,true);
            
            Test.stopTest();
             //Validate the test data      
       system.assertEquals(remoteResult.success,true);
            
        }
    }
    @isTest      
  static void getCommentsFromOrderInfoTest(){      
    // Prepare Test Data      
      ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();      
    User thisUser = [Select Id from User where Id =:UserInfo.getUserId()];      
      ccrz__E_Cart__c testCart;      
    ccrz__E_Order__c testOrder;      
    system.runas(thisUser){      
      cc_lol_TestData.setupCatalog();      
        testCart = cc_lol_TestData.createCart();      
        cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
          //testOrder = cc_lol_TestData.createOrders(1)[0];      
          //update testOrder;
      }
          //Test the scenario      
     Test.startTest();      
     ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.getCommentsFromOrderInfo(ctx,testCart.id);
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_OrderItemsController.getCommentsFromOrderInfo(ctx,null);
     Test.stopTest();      
     //Validate the test data      
     system.assertEquals(remoteResult.success,true);    
    }
    @isTest      
  static void getDeliveryInstructionsTest(){      
    // Prepare Test Data      
      ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();      
    User thisUser = [Select Id from User where Id =:UserInfo.getUserId()];      
      //ccrz__E_Cart__c testCart;      
    //ccrz__E_Order__c testOrder;  
        
        ccrz.cc_CallContext.currAccountId= cc_lol_TestData.testAccount.Id;
    system.runas(thisUser){      
      cc_lol_TestData.setupCatalog();      
        //testCart = cc_lol_TestData.createCart();      
        //cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
          //testOrder = cc_lol_TestData.createOrders(1)[0];      
          //update testOrder;
      }
          //Test the scenario  
       //String shipToId = testAccount.Id;
       //cc_oo_ShipToAccount__c shipToId = new cc_oo_ShipToAccount__c();
       //String shipToId = String.valueOf(cc_lol_TestData.testAccount.Id);
       Account testShipToAccount = new Account();
       testShipToAccount.Name = 'testShipToAccount';
       insert testShipToAccount;
       
       Account testBillToAccount = new Account();
       testBillToAccount.Name = 'testBillToAccount';
       insert testBillToAccount;
       
       Account testAccount = new Account();
       testAccount.Name = 'testAccount';
       testAccount.AccountNumber = testShipToAccount.Id;
       testAccount.BillTo_Account__c = testBillToAccount.Id;
       testAccount.Delivery_Instruction_1__c = 'Delivery instructions 1';
         testAccount.Delivery_Instruction_2__c = 'Delivery instructions 2';
         testAccount.cc_oo_IsPORequired__c = true;
       
       insert testAccount;
     
     Test.startTest();      
     ccrz.cc_RemoteActionResult remoteResult = cc_oo_OrderItemsController.getDeliveryInstructions(ctx,testShipToAccount.Id);  
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_OrderItemsController.getDeliveryInstructions(ctx,null);  
     Test.stopTest();      
     //Validate the test data      
     system.assertEquals(remoteResult.success,true);    
    }
    
}