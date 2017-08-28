//ClassName:cc_oo_CartControllerTest 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         9/22/2016                                      OO-202 - Test class for cc_pm_ctrl_Cart
//Shivani Singh                            10/05/2016                                     OO-492 - Test class for cc_pm_ctrl_Cart
//                                                                                                (to view the total weight of an order under the header)
//                                                                                        OO-195 - To show the prebook products on the homepage
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_CartControllerTest {
    
    //Test scenario for the constructor
    @isTest 
    static void test_cc_oo_CartController(){        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            System.debug('Set catalog');
            cc_lol_TestData.setupCatalog(); 
            testCart = cc_lol_TestData.createCart();
            PageReference testPage = new PageReference('HomePage');
            Test.setCurrentPage(testPage);
            ApexPages.currentPage().getParameters().put('cartId', testCart.ccrz__EncryptedId__c);
        }
        Test.startTest(); 
        cc_oo_CartController tstCtrl = new cc_oo_CartController();
        Test.stopTest();
        System.assert(tstCtrl!=NULL);
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
            
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.validateOrderMinimumWeight(ctx,testCart.id);
        System.debug('validate minimum order'+ remoteResult.data);
        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success, true);
    }
   
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
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.getTotalWeight(ctx,testCart.ccrz__EncryptedId__c);
        System.debug('total Weight'+ remoteResult.data);
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
    }
    
    // The test scenario tests the method getCartItems of the class cc_pm_ctrl_Cart  
    @isTest 
    static void getCartItems(){
        
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
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.getCartItems(ctx,testCart.ccrz__EncryptedId__c);
        System.debug('Cart Items'+ remoteResult.data);
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
    }
    
    // The test scenario tests the method redirect of the class cc_pm_ctrl_Cart  
    /*@isTest 
    static void redirectTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        cc_lol_TestData.setupCatalog();
        testCart = cc_lol_TestData.createCart(); 
        
        String orderType='Prebook';
        String url='https://onlordqa-landolakespartners.cs13.force.com/PurinaMills';
        
        ccrz__E_Category__c prebookCat = new ccrz__E_Category__c(
                Name                = 'Prebook',
                ccrz__CategoryID__c = 'a1eW0000000j6y1',
                ccrz__StartDate__c  = Date.today().addDays(-1),
                ccrz__EndDate__c    = Date.today().addDays(1)
        );
        insert prebookCat;
        //Test the scenario
        Test.startTest(); 
                      
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.redirect(ctx,testCart.id,orderType,url,'1','2','3','4','true');
        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success,true);
        if(remoteResult.success){
            system.assertEquals(remoteResult.data!=null,true);
        }
        }
    }*/
    
    /* 215 - Ship To Plant selection coverage*/
    
   @isTest 
    static void shipToSelectionTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
        PageReference testPage = new PageReference('HomePage');
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('isCSRFlow', 'true');
        
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            //String orderType='Prebook';//OO-3252
            String url='https://onlordqa-landolakespartners.cs13.force.com/PurinaMills';
            
            ccrz__E_Category__c prebookCat=[select Name,ccrz__CategoryID__c from ccrz__E_Category__c limit 1];
            
            prebookCat.Name='Prebook';
            update prebookCat;
            //Test the scenario
            
            Test.startTest(); 
            
            //Create Seller
            ccrz__E_Seller__c seller = new ccrz__E_Seller__c();
            seller.Name = 'ABDN Test';
            seller.ccrz__EffectiveStart__c = Date.today().addDays(-1);
            seller.ccrz__EffectiveEnd__c = Date.today().addDays(1);
            seller.ccrz__Enabled__c = true;
            seller.ccrz__SellerId__c = 'ABDN';
            seller.ccrz__Storefront__c = 'PurinaMills';
            seller.cc_oo_State__c='AZ';
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
            testContact.AccountId = testcart.ccrz__Account__r.Id;
            insert testContact;
            testcart.cc_oo_ShipToAccount__c=testAccount.id;
            testcart.cc_oo_Seller__c=seller.id;
            testcart.ccrz__Contact__c = testContact.Id;
            testcart.ccrz__Account__c = testAccount.Id; 
            update testcart;
            //Create customer Freight 
            CC_OO_Customer_Freight__c testCF = new CC_OO_Customer_Freight__c();
            testCF.Plant_Name__c = seller.id;
            //testCF.ShipTo_Address_ID__c = '212121';
            testCF.Product_Type__c = 'Bag';
            insert testCF;
            system.debug('testCF-->' + testCF);
            system.debug('testAccount.AccountNumber-->' + testAccount.AccountNumber);
           
            string portalId = '';
            //string promotionCode = '';//OO-3252
            testCart = [SELECT Id, ccrz__User__c,ccrz__User__r.Id,ccrz__Account__r.Id,ccrz__Contact__r.Id,ccrz__Contact__c,ccrz__Account__c, ccrz__EncryptedId__c
                        FROM ccrz__E_Cart__c WHERE Id = :testCart.Id];
            ccrz.cc_CallContext.currAccountId = testcart.ccrz__Account__r.Id;
            ccrz.cc_CallContext.currContact = testContact;
            ccrz.cc_CallContext.currAccount = testAccount;
            ccrz.cc_CallContext.currUser.Id = testcart.ccrz__User__r.Id;
            cc_lol_TestData.setupOOSettings();
            cc_oo_HeaderController.getShipTos(ctx);
            cc_oo_HeaderController.getSellers(ctx, '212121');
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_HeaderController.redirect(ctx,testCart.ccrz__EncryptedId__c, url, (string)seller.Id, testAccount.AccountNumber,'true',portalId,'false','01/22/2017',false);//OO-3252
            cc_oo_HeaderController.getShipToSellerInfo(ctx, seller.id,'212121', testCart.ccrz__EncryptedId__c );
            List<ccrz__E_ProductInventoryItem__c> inventory = [Select cc_oo_Seller__c from ccrz__E_ProductInventoryItem__c where ccrz__ProductItem__r.ID =:cc_lol_TestData.products[0].Id ];
            inventory[0].cc_oo_Seller__c = (string)seller.Id;
            update inventory;
            ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartController.getCartDetails(ctx,(string)seller.Id,'250287',testCart.ccrz__EncryptedId__c,null, String.valueOf(Date.today()));
            testCart.cc_oo_SplitCartType__c = 'Secondary';
            update testCart;
            ccrz.cc_RemoteActionResult remoteResult0 = cc_oo_CartController.getCartDetails(ctx,(string)seller.Id,'250287',testCart.ccrz__EncryptedId__c,null,String.valueOf(Date.today()));
            ccrz.cc_RemoteActionResult remoteResult2 = cc_oo_CartController.splitProductOnDate(ctx,testCart.ccrz__EncryptedId__c,'01/22/2017');
            ccrz.cc_RemoteActionResult remoteResult3 = cc_oo_CartController.getProductInventoryDtls(ctx,testCart.Id);
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
            }
            system.assertEquals(remoteResult0.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult0.data!=null,true);
            }
            system.assertEquals(remoteResult1.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult1.data!=null,true);
            }
            system.assertEquals(remoteResult2.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult2.data!=null,true);
            }
           
        }
    }
    
    
    /* 215 - Ship To Plant selection coverage with Orders*/
    @isTest 
    static void shipToSelectionTestWithOrders(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            
            String orderType='Prebook';
            String url='https://onlordqa-landolakespartners.cs13.force.com/PurinaMills';
            
            ccrz__E_Category__c prebookCat=[select Name,ccrz__CategoryID__c from ccrz__E_Category__c limit 1];
            
            prebookCat.Name='Prebook';
            update prebookCat;
            //Test the scenario
            
            ccrz__E_Cart__c testCart2 = cc_lol_TestData.createCart(); 
            Account testAccount2 = cc_lol_TestData.testAccount;
            testAccount2.AccountNumber = '212121';
            update testAccount2;
            testCart2.cc_oo_ShipToAccount__c = testAccount2.id;
            testCart2.ccrz__CartStatus__c = 'Open'; 
            testCart2.cc_oo_CartType__c= 'Prebook';
            update testCart2; 
            List<ccrz__E_Order__c> orders = cc_lol_TestData.createOrders(1);
            orders[0].ccrz__OriginatedCart__c = testCart2.id;
            orders[0].ccrz__User__c = thisUser.id;
            update orders[0];
            
            Test.startTest(); 
            
            //Create Seller
            ccrz__E_Seller__c seller = new ccrz__E_Seller__c();
            seller.Name = 'ABDN Test';
            seller.ccrz__EffectiveStart__c = Date.today().addDays(-1);
            seller.ccrz__EffectiveEnd__c = Date.today().addDays(1);
            seller.ccrz__Enabled__c = true;
            seller.ccrz__SellerId__c = 'ABDN';
            seller.ccrz__Storefront__c = 'PurinaMills';
            seller.cc_oo_State__c='AZ';
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
            testcart.cc_oo_ShipToAccount__c=testAccount.id;
            testcart.cc_oo_Seller__c=seller.id;
            update testcart;
            //Create Contact
            Contact testContact = new Contact();
            testContact.FirstName = 'Test FN';
            testContact.LastName = 'Test LN';
            testContact.Email = 'Testfn@test.com';
            testContact.AccountId = testAccount.Id;
            insert testContact;
            
            //Create customer Freight 
            CC_OO_Customer_Freight__c testCF = new CC_OO_Customer_Freight__c();
            testCF.Plant_Name__c = seller.id;
            //testCF.ShipTo_Address_ID__c = '212121';
            testCF.Product_Type__c = 'Bag';
            insert testCF;
            system.debug('testCF-->' + testCF);
            system.debug('testAccount.AccountNumber-->' + testAccount.AccountNumber);
           
            string portalId = '';
            //string promotionCode = '';//OO-3252
            ccrz.cc_CallContext.currAccountId = testAccount.Id;
            ccrz.cc_CallContext.currContact = testContact;
            ccrz.cc_CallContext.currAccount = testAccount;
            
            
            cc_oo_CartController.getShipTos(ctx);
            cc_oo_CartController.getSellers(ctx, '212121');
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.redirect(ctx,testCart.ccrz__EncryptedId__c, url, (string)seller.Id, testAccount.AccountNumber,'true',portalId, 'false','01/22/2017');//OO-3252
            cc_oo_CartController.getShipToSellerInfo(ctx, seller.id ,'212121', testCart.ccrz__EncryptedId__c );
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
            }
        }
    }
    
   
    /* 215 - Ship To Plant selection coverage*/
    
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
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.getCartType(ctx,testCart.Id);
        System.debug('--------------------'+remoteResult);
        Test.stopTest();
        system.assertEquals(remoteResult.success,true);
        if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
        }
    }
    
     //to test the product lead time 
   @isTest 
    static void getProductsLeadTimeTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            //List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
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
                          
            ccrz.cc_RemoteActionResult remoteResult =cc_oo_CartController.getProductsLeadTime(ctx,productIdList);
            system.assertEquals(remoteResult.success,true);
            
            Test.stopTest();
            
            //Validate the test data
            //system.assertEquals(remoteResult.success,true);
            //if(remoteResult.success){
            //    Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            //    system.assertEquals(mapProductData.size()>0,true);
            //}
        }
    }
    
    
    // to test the vfd flagged product. 
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
            //List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: ([select id from ccrz__E_Product__c LIMIT 3])){
                productIdList.add(prod.Id);
            }
            
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.getVfdFlag(ctx,productIdList);
            
            Test.stopTest();
            
            //Validate the test data
             system.assertEquals(remoteResult.success,true);
            
        }
    }
     /*@isTest 
    static void cancelContractTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        Map<String, String> cartDetailMap= new Map<String, String>();
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            //List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: ([select id from ccrz__E_Product__c LIMIT 3])){
                productIdList.add(prod.Id);
            }
                List<ccrz__E_CartItem__c> cartItemList = [select Id from ccrz__E_CartItem__c where ccrz__Cart__c = :testCart.Id];
                String quantity = '1';
                String cartId = cartItemList[0].Id;
                String sku = 'test002'; 
                String sku2 = 'test001';
                
                String isGlobal='false';
                String price = '20';
                String palletPrice = '10';
                String contractId = 'A-000';
                String palletQuantity = '10';
                
                cartDetailMap.put('sku', sku);
                cartDetailMap.put('quantity', quantity);
                cartDetailMap.put('cartId', cartId);
                cartDetailMap.put('isGlobal',isGlobal);
                cartDetailMap.put('contractId',contractId);
            
        }
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.cancelContract(ctx,cartDetailMap);
        Test.stopTest();
        
        
      
    }*/
    /*@isTest 
    static void splitContractTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        Map<String, String> cartDetailMap= new Map<String, String>();
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
           
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: ([select id from ccrz__E_Product__c LIMIT 3])){
                productIdList.add(prod.Id);
            }
                List<ccrz__E_CartItem__c> cartItemList = [select Id from ccrz__E_CartItem__c where ccrz__Cart__c = :testCart.Id];
                String quantity = '1';
                String cartId = cartItemList[0].Id;
                String sku = 'test002'; 
                String sku2 = 'test001';
                
                String isGlobal='true';
                String price = '20';
                String palletPrice = '10';
                String contractId = 'A-000';
                String palletQuantity = '10';
                
                cartDetailMap.put('sku', sku);
                cartDetailMap.put('quantity', quantity);
                cartDetailMap.put('cartId', cartId);
                cartDetailMap.put('isGlobal',isGlobal);
                cartDetailMap.put('contractId',contractId);
            
        }
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.splitContract(ctx,cartDetailMap);
        Test.stopTest();
        
        
      
    }*/
    @isTest 
    static void validateContractQuantityTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        Map<String, String> cartDetailMap= new Map<String, String>();
        Map<String, String> quantityMap= new Map<String, String>();
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            ccrz__E_CartItem__c cartItem = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            cartItem.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[2].Id;
            update cartItem;
            cc_oo_ContractPrice__c contract = [Select Name,cc_oo_EffectiveDate__c,cc_oo_ExpireDate__c,cc_oo_ContractNumber__c from cc_oo_ContractPrice__c where cc_oo_Product__c = :cc_lol_TestData.products[0].Id];
            //List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            String sellerID=seller.Id;
            for(ccrz__E_Product__c prod: ([select id from ccrz__E_Product__c LIMIT 3])){
                productIdList.add(prod.Id);
            }
               
                String quantity = '40';
                String cartId = testCart.ccrz__EncryptedId__c;
               String sku = 'test001'; 
                String sku2 = 'test002';
                
                String isGlobal='true';
                String price = '20';
                String palletPrice = '10';
                String contractId =String.valueOf(contract.cc_oo_ContractNumber__c);
                String passQuantity = '30';
                Date shipdate=Date.today();
                String shipDatefinal=shipdate.format();
                cartDetailMap.put('sku', sku);
                cartDetailMap.put('quantity', quantity);
                cartDetailMap.put('cartId', cartId);
                cartDetailMap.put('isGlobal',isGlobal);
                cartDetailMap.put('sellerId',sellerID);
                cartDetailMap.put('contractId',contractId);
                cartDetailMap.put('shipDate',shipDatefinal);
                quantityMap.put('passQuantity',passQuantity);
                quantityMap.put(String.valueOf(cartItem.Id),'15');
            
            Test.startTest(); 
            System.debug('Starting remote');              
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.validateContractQuantity(ctx,cartDetailMap,quantityMap);
            isGlobal='false';
            cartDetailMap.put('isGlobal',isGlobal);
            ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_CartController.validateContractQuantity(ctx,cartDetailMap,quantityMap);   
            contract.cc_oo_EffectiveDate__c = Date.today().addDays(+10);
            update contract;
           isGlobal='true';
            cartDetailMap.put('shipDate',String.valueOf(Date.today()));
            ccrz.cc_RemoteActionResult remoteResult2 = cc_oo_CartController.validateContractQuantity(ctx,cartDetailMap,quantityMap);   
            Test.stopTest();
            system.assert(remoteResult1 !=NULL);
            system.assert(remoteResult !=NULL);
            system.assert(remoteResult2 !=NULL);
        }
        
      
    }
    
    //OO-333(OO-796)  Test method for "checkForMinimumWeight" 
    /*@isTest 
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
             
            System.debug('Add cart item'); 

            ccrz__E_Seller__c seller = new ccrz__E_Seller__c();
            seller.Name = 'ABDN Test';
            seller.ccrz__EffectiveStart__c = Date.today().addDays(-1);
            seller.ccrz__EffectiveEnd__c = Date.today().addDays(1);
            seller.ccrz__Enabled__c = true;
            seller.ccrz__SellerId__c = 'ABDN';
            seller.ccrz__Storefront__c = 'PurinaMills';
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
            
            //Create customer Freight 
            CC_OO_Customer_Freight__c testCF = new CC_OO_Customer_Freight__c();
            testCF.Plant_Name__c = seller.id;
            testCF.ShipTo_Account_Number__c = 212121;
            testCF.Product_Type__c = 'Bag';
            insert testCF;

            testcart.cc_oo_ShipToAccount__c=testAccount.id;
            testcart.cc_oo_Seller__c=seller.id;
            update testcart;

            ccrz__E_Product__c testProd = new ccrz__E_Product__c();
            if(cc_lol_TestData.products.size() > 0){
                if(cc_lol_TestData.products[0] != null){
                    testProd = cc_lol_TestData.products[0];
                    testProd.cc_oo_TypeOfProduct__c = 'BAG';
                    update testProd;
                }
            }
            cc_lol_TestData.addCartItem(testCart, testProd.Id,12,200.00);
        }  
        string encId = [select id,ccrz__EncryptedId__c from ccrz__E_Cart__c where id=:testCart.id].ccrz__EncryptedId__c;
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.checkForMinimumWeight(ctx,encId);
        
        Test.stopTest();
    }*/
   @isTest 
    static void getProductInventoryDtlsTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        String cartId;
        system.runas(thisUser){
                cc_lol_TestData.setupCatalog();
                testCart = cc_lol_TestData.createCart(); 
                ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
                testcart.cc_oo_ShipToAccount__c=cc_lol_TestData.testAccount.id;
                testcart.cc_oo_Seller__c=seller.id;
                testcart.ccrz__Account__c = cc_lol_TestData.testAccount.Id; 
                update testcart;
                ccrz.cc_CallContext.currAccountId=ccrz.cc_CallContext.currAccountId = testcart.ccrz__Account__r.Id;
                cartId=testcart.id;
                ccrz.ccLog.log('cartId');
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[7].Id,30,2000.00);
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,8,200.00);
                List<ccrz__E_CartItem__c> cartItm=[select ccrz__Cart__c,cc_oo_IsListPrice__c from ccrz__E_CartItem__c where ccrz__Cart__c=: testCart.Id];
                cartItm[0].cc_oo_IsListPrice__c=true;
                cartItm[1].cc_oo_IsListPrice__c=false;
                update cartItm;
                Map<String,String> pageParams = new Map<String, String>();
                pageParams.put('sid', String.valueOf(testCart.cc_oo_Seller__c));
                ccrz.cc_CallContext.currPageParameters = pageParams;
                ccrz.cc_CallContext.currAccountGroup = cc_lol_TestData.testAccountGroup;
                cc_lol_TestData.setupOOSettings();
                Test.startTest(); 
                ccrz.ccLog.log('Starting remote');
                ccrz.cc_RemoteActionResult remoteResult3 = cc_oo_CartController.getProductInventoryDtls(ctx,cartId);
                Test.stopTest();
                system.assert(remoteResult3 !=NULL);
            }
    }
   @isTest 
    static void DeleteAmendedCartTest(){
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        ccrz__E_Cart__c testCart1;
        String cartId;
        system.runas(thisUser){
                cc_lol_TestData.setupCatalog();
                testCart = cc_lol_TestData.createCart();
                testCart1 = cc_lol_TestData.createCart(); 
                ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
                
                testcart.cc_oo_ShipToAccount__c=cc_lol_TestData.testAccount.id;
                testcart.cc_oo_Seller__c=seller.id;
                testcart.ccrz__Account__c = cc_lol_TestData.testAccount.Id; 
                testcart.cc_oo_AmendedCart__c=true;
                testcart.cc_oo_SplitCart__c=testCart1.Id;
                testcart.ccrz__CartStatus__c = 'Open';  
              ccrz.cc_CallContext.currUserId = testcart.ccrz__User__r.Id;
                update testcart;
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[7].Id,30,2000.00);
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,8,200.00);
                List<ccrz__E_Cart__c> amendedCarts = [select id,ccrz__EncryptedId__c,cc_oo_OriginalCart__c,cc_oo_OriginalOrder__c,ccrz__ShipTo__c,ccrz__BillTo__c,cc_oo_AmendedCart__c,cc_oo_SplitCart__c from ccrz__E_Cart__c where cc_oo_AmendedCart__c=true AND ccrz__CartStatus__c = 'Open'AND ccrz__User__c =: ccrz.cc_CallContext.currUserId ];
                System.debug('amendedCarts'+amendedCarts);
                ccrz.cc_CallContext.currAccountId=ccrz.cc_CallContext.currAccountId = testcart.ccrz__Account__r.Id;
                Test.startTest(); 
                ccrz.ccLog.log('Starting remote');
             
            ccrz.cc_RemoteActionResult remoteResult3 = cc_oo_CartController.DeleteAmendedCart(ctx, testCart.cc_oo_Seller__c, testcart.ccrz__Account__r.Id,amendedCarts[0].ccrz__EncryptedId__c);
            remoteResult3 = cc_oo_CartController.DeleteAmendedCart(ctx, testCart.cc_oo_Seller__c, null,null); 
            Test.stopTest();
            
                system.assert(remoteResult3 !=NULL);
            }
    }
              @isTest 
    static void getProductsDetailsTest(){
        
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
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartController.getProductsDetails(ctx,testCart.ccrz__EncryptedId__c,null);
        System.debug('total Weight'+ remoteResult.data);
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
    }
}