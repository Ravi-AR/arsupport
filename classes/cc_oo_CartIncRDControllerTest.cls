//ClassName:cc_oo_CartIncRDControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Murtaza Beejwala                           10/16/2016                                       Test class for cc_oo_CartIncRDController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_CartIncRDControllerTest {
    
    // The test scenario tests the method getTotalWeight of the class cc_pm_ctrl_Cart  
    @isTest 
    static void getTotalWeight(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
       Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartIncRDController.getTotalWeight(ctx,testCart.ccrz__EncryptedId__c);
        System.debug('total Weight'+ remoteResult.data);
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartIncRDController.getTotalWeight(ctx,null);

        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
    }
    
     // 215 - Ship To Plant selection coverage
    
    // The test scenario tests the method getCartType of the class cc_pm_ctrl_Cart  
    @isTest 
    static void getCartType(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            testCart.ccrz__CartType__c = 'Prebook';
            update testCart;
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartIncRDController.getCartType(ctx,testCart.Id);
         ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartIncRDController.getCartType(ctx,null);
        
        Test.stopTest();
        system.assertEquals(remoteResult.success,true);
        if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
        }
    }
    
    // The test scenario tests the method validateOrderMinimumWeight of the class cc_pm_ctrl_Cart  
    @isTest 
    static void validateOrderMinimumWeight(){
    
        cc_oo_prebook_minimum_weight__c custom = new cc_oo_prebook_minimum_weight__c();
        custom.prebook_minimum_weight__c = 1;
        custom.Name = 'prebook_minimum_weight';
        insert custom;
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
        
        Map<string,Integer> cartItemMap = new Map<string,Integer>();
        ccrz__E_CartItem__c cartItem = [SELECT Id, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: testCart.id limit 1];
        
        cartItemMap.put(cartItem.Id, Integer.ValueOf(cartItem.ccrz__Quantity__c));
                    
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartIncRDController.validateOrderMinimumWeight(ctx,testCart.id,cartItemMap);
        System.debug('validate minimum order'+ remoteResult.data);
       ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartIncRDController.validateOrderMinimumWeight(ctx,null,cartItemMap);
        

        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success, true);
    }
    
    //OO-333(OO-796)  Test method for "checkForMinimumWeight" 
    @isTest 
    static void checkForMinimumWeightTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
        system.runas(thisUser){
        System.debug('Set catalog');
           
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            //testCart.cc_oo_ShipToAccount__c 
            System.debug('Add cart item'); 

            ccrz__E_Seller__c seller = new ccrz__E_Seller__c();
            seller.Name = 'ABDN Test';
            seller.ccrz__EffectiveStart__c = Date.today().addDays(-1);
            seller.ccrz__EffectiveEnd__c = Date.today().addDays(1);
            seller.ccrz__Enabled__c = true;
            seller.ccrz__SellerId__c = 'ABDN';
            seller.ccrz__Storefront__c = 'PurinaMills';
            seller.cc_oo_state__c = 'CA';
            insert seller;
            
            //Create Account
            Account testAccount =  new Account();
            testAccount.ShipTo_Flag__c = true;
            //testAccount.Billing_Account__c = true;
            testAccount.AccountNumber = '212121';
            testAccount.Name                    = 'Test Account';
            //testAccount.ccrz__E_AccountGroup__c = testAccountGroup.Id;
            testAccount.Type                    = 'Customer';
            testAccount.BillingStreet           = cc_lol_TestData.generateRandomString(32);
            testAccount.BillingCity             = cc_lol_TestData.generateRandomString(32);
            testAccount.BillingCountry          = 'United States';
            insert testAccount;
            
            //Create Contact
            Contact testContact = new Contact();
            testContact.FirstName = 'Test FN';
            testContact.LastName = 'Test LN';
            testContact.Email = 'Testfn@test.com';
            testContact.AccountId = testAccount.Id;
            insert testContact;

            testcart.cc_oo_ShipToAccount__c=testAccount.id;
            testcart.cc_oo_Seller__c=seller.id;
            update testcart;

            ccrz__E_Product__c testProd = new ccrz__E_Product__c();
            if(cc_lol_TestData.products.size() > 0 && cc_lol_TestData.products[0] != null){
                    testProd = cc_lol_TestData.products[0];
                    testProd.cc_oo_TypeOfProduct__c = 'BAG';
                    testProd.ccrz__ProductWeight__c = 10;
                    update testProd;
            }
            //cc_lol_TestData.addCartItem(testCart, testProd.Id,12,200.00);
            //cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
            cartItem.ccrz__Cart__c = testCart.Id;
            cartItem.ccrz__Product__c = testProd.Id;
            cartItem.ccrz__Quantity__c = 12;
            cartItem.ccrz__Price__c = 200;
            insert cartItem;
            

            cc_oo_PlantCutOff__c plantCutOff1 = new cc_oo_PlantCutOff__c();
            plantCutOff1.cc_oo_OrderMinumum__c = 1000;
            plantCutOff1.cc_oo_Plant__c = 'ABDN';
            plantCutOff1.cc_oo_ProductType__c = 'BAG';
            plantCutOff1.cc_oo_ShippingMethod__c = 'DELIVERY';
            insert plantCutOff1;

            cc_oo_PlantCutOff__c plantCutOff2 = new cc_oo_PlantCutOff__c();
            plantCutOff2.cc_oo_OrderMinumum__c = 2000;
            plantCutOff2.cc_oo_Plant__c = 'ABDN';
            plantCutOff2.cc_oo_ProductType__c = 'BAG';
            plantCutOff2.cc_oo_ShippingMethod__c = 'PICKUP';
            insert plantCutOff2;
        }  

        Test.startTest(); 
       
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartIncRDController.checkForMinimumWeight(ctx,'121212');
        ccrz.cc_RemoteActionResult remoteResult2 = cc_oo_CartIncRDController.checkForMinimumWeight(ctx,testCart.Id);
        

        Test.stopTest();
        system.assertEquals(remoteResult1.success,false);
        system.assertEquals(remoteResult2.success,true);
        string resMessage = string.valueOf(remoteResult2.data);
        system.assertEquals(resMessage.contains(Label.cc_oo_RouteTruckOrdMinWeightMsgBag.replace('__','1000')),true);
        system.assertEquals(resMessage.contains(Label.cc_oo_PickUpOrdMinWeightMsg.replace('__','2000')),true);

    }
    
    // The test scenario tests the method savenotes of the class cc_oo_CartIncRDController  
    @isTest 
    static void saveNotesTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        ccrz__E_CartItem__c cartitem ;
        system.runas(thisUser){
        System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            cartitem    =[select Id from ccrz__E_CartItem__c where ccrz__Cart__r.Id=:testCart.Id];
        }  
            
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');  
        String notes='a message is commented';            
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartIncRDController.saveNotes(ctx,cartitem.Id,notes);
        ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartIncRDController.saveNotes(ctx,null,null);
        System.debug('Cart Items'+ remoteResult.success);
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.success!=null,true);
            
       }
    
    
}