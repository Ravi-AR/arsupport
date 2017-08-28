//ClassName:cc_oo_CartControllerTest  
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Murtaza Beejwala                          10/9/2016                                      OO-513 - Test class for cc_oo_CheckoutSHippingController.
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_CheckoutShippingControllerTest {
    // New method
    private static final String ATP_RESPONSE_BODY = '{"status": "success"}';
    private static final String ATP_RESPONSE_BODY2 = '{"timeZone":"AKST","DockDoorTimeslotCollection":{"DockDoorTimeslot":[{"pickupTime":"08:30 AM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"09:00 AM","shipToNumber":"250287","orderNumber":1,"isBooked":1},{"pickupTime":"09:30 AM","shipToNumber":"301030","orderNumber":1,"isBooked":1},{"pickupTime":"10:00 AM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"10:30 AM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"11:00 AM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"11:30 AM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"12:30 PM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"01:00 PM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"01:30 PM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"02:00 PM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"02:30 PM","shipToNumber":"0","orderNumber":0,"isBooked":0},{"pickupTime":"03:00 PM","shipToNumber":"0","orderNumber":0,"isBooked":0}]}}';
    @isTest
    static  void getshipDateTest() {
        // TO DO: implement unit test
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
            System.debug('Add cart Items');
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        //Test the scenario
        Date shipDateOrderInfo;
        String shipDateString;
        String cartId=String.valueOf(testCart.Id);
        shipDateOrderInfo = Date.today();
        shipDateString = '3/3/2017';
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.getShipDate(ctx,cartId);
        Test.stopTest();
        system.assert(remoteResult!=Null);          
    }
    // End of new method
    
     @isTest
    static  void isPORequiredTest() {
        // TO DO: implement unit test
         ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
         System.debug('Fetching User');
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
         Account testAccount =  cc_lol_TestData.testAccount;
         Account testAcc2 =  new Account();
         system.runas(thisUser){
             System.debug('Set AccountNumber');
             testAccount.AccountNumber='250287';
             //Create Account
             testAcc2.ShipTo_Flag__c = true;
            //testAccount.Billing_Account__c = true;
            testAcc2.AccountNumber = '212121';
            testAcc2.Name                    = 'Test Account';
            //testAccount.ccrz__E_AccountGroup__c = testAccountGroup.Id;
            testAcc2.Type                    = 'Customer';
            testAcc2.BillingStreet           = cc_lol_TestData.generateRandomString(32);
            testAcc2.BillingCity             = cc_lol_TestData.generateRandomString(32);
            testAcc2.BillingCountry          = 'United States';
            testAcc2.BillTo_Account__c   = testAccount.id;
            testAcc2.cc_oo_IsPORequired__c   = true;
            insert testAcc2;
            testAccount.cc_oo_IsPORequired__c=  true;       
            update testAccount;     
         }
        //Test the scenario
         ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.isPORequired(ctx,testAcc2.AccountNumber);
         testAcc2.BillTo_Account__c=null;
         update testAcc2;
         remoteResult = cc_oo_CheckoutShippingController.isPORequired(ctx,testAcc2.AccountNumber);
         testAcc2.BillTo_Account__c=testAccount.id;
         update testAcc2;
         Test.startTest(); 
         System.debug('Starting remote');              
         System.debug('Account shipping/billing address Items'+ remoteResult.data);
         Test.stopTest();
         //Validate the test data
         system.assertNotEquals(remoteResult.data,null); //US-1644 
         //system.assertEquals(remoteResult.data,remoteResult.success);
    }
    
    //to test the payment detail scenario   
    @isTest
    static  void PurchaseOrderNumberTest() {
        // TO DO: implement unit test
         ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
         System.debug('Fetching User');
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
         ccrz__E_Cart__c testCart;
         system.runas(thisUser){
             System.debug('Set cart');
             testCart =  cc_lol_TestData.createCart();
             }
        //Test the scenario
         String cartid=String.valueOf(testCart.Id);
          String pickupTime = '7:00 AM';
          String shippingMethodOptions = 'Pickup';
          String timeZone = 'CST';
         //US-1644
         String modifiedDelvIns='Shipping instructions';
         String modifiedShipNotes = 'Shipping comments';
         ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.PurchaseOrderNumber(ctx,'123456789','PO12345',modifiedDelvIns,modifiedShipNotes,pickupTime,shippingMethodOptions,timeZone);
         remoteResult = cc_oo_CheckoutShippingController.PurchaseOrderNumber(ctx,cartid,'PO12345',modifiedDelvIns,modifiedShipNotes,pickupTime,shippingMethodOptions,timeZone);
         remoteResult = cc_oo_CheckoutShippingController.PurchaseOrderNumber(ctx,cartid,'PO34567',modifiedDelvIns,modifiedShipNotes,pickupTime,shippingMethodOptions,timeZone);
         System.debug('Account shipping/billing address Items'+ remoteResult.data);
         system.assertEquals(remoteResult.success,true);
         Test.startTest(); 
         System.debug('Starting remote');              
         
         Test.stopTest();
        
    }
    //to test purchaseOrderNumberCheck
    @isTest
    static  void PurchaseOrderNumberCheckTest() {
        // TO DO: implement unit test
         ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
         System.debug('Fetching User');
         User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
         ccrz__E_Cart__c testCart;
         system.runas(thisUser){
             System.debug('Set cart');
             testCart =  cc_lol_TestData.createCart();
             cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);

             }
        //Test the scenario
         String cartid=String.valueOf(testCart.Id);
         ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.PurchaseOrderNumberCheck(ctx,cartid);
         remoteResult = cc_oo_CheckoutShippingController.PurchaseOrderNumberCheck(ctx,'123456789');
         Test.startTest(); 
         System.debug('Starting remote');              
         System.debug('Account shipping/billing address Items'+ remoteResult.data);
         Test.stopTest();
        //Validate the test data
         system.assertEquals(remoteResult.data,remoteResult.success);
    }
    @isTest 
    static  void getShippingDetailsTest() {         
        // TO DO: implement unit test           
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();            
        String plantId, productType,shipping;           
        Decimal aggregateCartOrderWeight = 10000.0;         
        System.debug('Fetching User');          
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];         
        ccrz__E_Cart__c testCart;           
        system.runas(thisUser){         
            System.debug('Set cart');           
            testCart =  cc_lol_TestData.createCart();           
            System.debug('Add cart items');         
           
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
        }           
        //Test the scenario         
        String cartid=String.valueOf(testCart.Id);          
        cc_lol_TestData.setupOOServiceDataSettings();           
        Test.startTest();           
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.getShippingDetails(ctx,'ABDN',cartid,'Pickup');          
        Test.stopTest();            
        system.assertEquals(remoteResult.data!=null,true);          
    }
    @isTest                         
    static  void getPickupTimeTest() {                                  
        // TO DO: implement unit test                                   
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();                                    
        System.debug('Fetching User');                                  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];                                 
        ccrz__E_Cart__c testCart;                                   
        system.runas(thisUser){                                 
            System.debug('Set cart');                                   
            testCart =  cc_lol_TestData.createCart();           
            System.debug('Add cart item');
            testCart.cc_oo_AmendedCart__c=true;
            update testCart;
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
        }                                   
        //Test the scenario                                 
        String cartid=String.valueOf(testCart.Id);                  
        cc_lol_TestData.setupOOServiceDataSettings();           
        Test.startTest();      
        // build responseHeaders
        final Map<String,String> resHeaders = new Map<String,String>();
        resHeaders.put('Content-Type','application/json');
        // setup mock response
        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY, resHeaders));
        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY2, resHeaders));                              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.getPickupTime(ctx,cartid);                                   
        cc_oo_CheckoutShippingController.cc_oo_PickUpTime pickupTime = new cc_oo_CheckoutShippingController.cc_oo_PickUpTime();                                 
        pickupTime.pickUpTime = 'Pick Up';                                  
        pickupTime.enabled = true;                                  
        cc_oo_ServiceDockDoorCalloutController serviceDockDoor = new cc_oo_ServiceDockDoorCalloutController();                                  
        cc_oo_ServiceDockDoorCalloutController.getPickupTime('ABDN', 'BAG', '250287', Date.today(), testCart.Id);                                    
        cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean collectionBean = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean();                                 
        cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollection collection = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollection();
        collectionBean.timeZone = 'PM';  
        
        cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot timeSlot = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot();
        timeSlot.pickupTime = 'Pick Up';
        timeSlot.shipToNumber = '250287';
        timeSlot.isBooked = '0';
        timeSlot.orderNumber = '0'; 
        // new lines added        
        List<cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot> collectiontimeSlot = new List<cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot>();
        collectiontimeSlot.add(timeSlot);
        collection.DockDoorTimeslot = collectiontimeSlot;
        collectionBean.DockDoorTimeslotCollection = collection;
        // end of new lines added
        Test.stopTest();                                    
        system.assertEquals(remoteResult.data!=null,true);                                  
    }  
    
    @isTest                         
    static  void getPickupTimeTest1() {                                 
        // TO DO: implement unit test                                   
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();                                    
        System.debug('Fetching User');                                  
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];                                 
        ccrz__E_Cart__c testCart;                                   
        system.runas(thisUser){                                 
            System.debug('Set cart');                                   
            testCart =  cc_lol_TestData.createCart();           
            System.debug('Add cart item');          
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
        }                                   
        //Test the scenario                                 
        String cartid=String.valueOf(testCart.Id);                  
        cc_lol_TestData.setupOOServiceDataSettings();           
        Test.startTest();      
        // build responseHeaders
        final Map<String,String> resHeaders = new Map<String,String>();
        resHeaders.put('Content-Type','application/json');
        // setup mock response
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.getPickupTime(ctx,cartid);     

        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY, resHeaders));
        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY2, resHeaders));                              
        ccrz.cc_RemoteActionResult remoteResult2 = cc_oo_CheckoutShippingController.getPickupTime(ctx,cartid);                                  
        //cc_oo_CheckoutShippingController.cc_oo_PickUpTime pickupTime = new cc_oo_CheckoutShippingController.cc_oo_PickUpTime();                                   
        //pickupTime.pickUpTime = 'Pick Up';                                    
        //pickupTime.enabled = false;                                   
        //cc_oo_ServiceDockDoorCalloutController serviceDockDoor = new cc_oo_ServiceDockDoorCalloutController();                                    
        //cc_oo_ServiceDockDoorCalloutController.getPickupTime('ABDN', 'BAG', '250287', Date.today());                                  
        //cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean collectionBean = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean();                                   
        //cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollection collection = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollection();
        //collectionBean.timeZone = 'PM';  
        
        //cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot timeSlot = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot();
        //timeSlot.pickupTime = 'Pick Up';
        //timeSlot.shipToNumber = '250287';
        //timeSlot.isBooked = '0';
        //timeSlot.orderNumber = '0'; 
        // new lines added        
        //List<cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot> collectiontimeSlot = new List<cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot>();
        //collectiontimeSlot.add(timeSlot);
        //collection.DockDoorTimeslot = collectiontimeSlot;
        //collectionBean.DockDoorTimeslotCollection = collection;
        // end of new lines added
        Test.stopTest();                                    
        system.assertEquals(remoteResult.data!=null,true);                                  
    } 
                        
    @isTest         
    static void test_shuffle(){         
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
        }                   
        String cartid=String.valueOf(testCart.Id);          
        Test.startTest();           
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.shuffle(ctx,cartid,'3/2/2017','Pickup');         
        Test.stopTest();            
        system.assert(remoteResult!=null);          
    }
    @isTest         
    static void test_isCartUpdated(){           
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
        }                   
        String cartid=String.valueOf(testCart.Id);          
        Test.startTest();           
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CheckoutShippingController.isCartUpdated(ctx,cartid,'3/2/2017','Pickup');           
        Test.stopTest();            
        system.assert(remoteResult!=null);          
    }
    @isTest         
    static void test_cc_oo_CheckoutShippingController(){            
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
            System.debug('Add cart Items');
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);            
        }           
        Test.startTest();           
        cc_oo_CheckoutShippingController cntrl = new cc_oo_CheckoutShippingController();            
        Test.stopTest();            
        system.assert(cntrl!=Null);         
    } 
}