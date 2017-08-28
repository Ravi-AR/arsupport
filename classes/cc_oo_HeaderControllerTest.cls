//ClassName:cc_oo_HeaderControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Murtaza Beejwala                           10/16/2016                                       Test class for cc_oo_HeaderController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_HeaderControllerTest {
    
    //Test scenario for the constructor
    @isTest 
    static void test_cc_oo_HeaderController(){      
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Set catalog');
            //System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            Contact contactCC = new Contact(
                FirstName = 'CloudCrazeUser',
                LastName  = 'TestUser2',
                Email = 'abcde@xyz.com',
                AccountId = cc_lol_TestData.testAccount.Id,
                MailingStreet = 'abc'
        );
        insert contactCC;
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currContact=contactCC;     
            testCart = cc_lol_TestData.createCart();
            PageReference testPage = new PageReference('HomePage');
            Test.setCurrentPage(testPage);
            ApexPages.currentPage().getParameters().put('cartId', testCart.ccrz__EncryptedId__c);
        }
        // Custom Setting for CSR Email Address and Phone Number
        cc_lol_TestData.setupOOSettings();
        Test.startTest();
        cc_oo_HeaderController tstCtrl = new cc_oo_HeaderController();
        Test.stopTest();
        system.assert(tstCtrl!=null);
        
    }
    
    // The test scenario tests the method getTotalWeight of the class cc_pm_ctrl_Cart  
    @isTest 
    static void getTotalWeight(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Fetching User');
        //System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Set catalog');
        //System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Create Cart');
            //System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
        Test.startTest();
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Starting remote'); 
        //System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_HeaderController.getTotalWeight(ctx,testCart.ccrz__EncryptedId__c);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','total Weight'+remoteResult.data);
        //System.debug('total Weight'+ remoteResult.data);
        
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
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Set catalog');
        //System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            testCart = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
        Test.startTest();
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Starting remote'); 
        //System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_HeaderController.getCartItems(ctx,testCart.ccrz__EncryptedId__c);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Cart Items'+remoteResult.data);
        //System.debug('Cart Items'+ remoteResult.data);
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
    }
    
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
            cc_lol_TestData.setupOOSettings();
            testCart = cc_lol_TestData.createCart(); 
            
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
            testContact.AccountId = testAccount.Id;
            insert testContact;
            testcart.cc_oo_ShipToAccount__c=testAccount.id;
            testcart.cc_oo_Seller__c=seller.id;
            update testcart;
            //Create customer Freight 
            CC_OO_Customer_Freight__c testCF = new CC_OO_Customer_Freight__c();
            testCF.Plant_Name__c = seller.id;
            //testCF.ShipTo_Address_ID__c = '212121';
            testCF.Product_Type__c = 'Bag';
            insert testCF;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','testCF-->' + testCF);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','testAccount.AccountNumber-->' + testAccount.AccountNumber);
           
            string portalId = '';
            //string promotionCode = '';//OO-3252
            ccrz.cc_CallContext.currAccountId = testAccount.Id;
            ccrz.cc_CallContext.currContact = testContact;
            ccrz.cc_CallContext.currAccount = testAccount;
            
            
            cc_oo_HeaderController.getShipTos(ctx);
            cc_oo_HeaderController.getSellers(ctx, '212121');
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_HeaderController.redirect(ctx,testCart.ccrz__EncryptedId__c, url, (string)seller.Id, testAccount.AccountNumber,'true',portalId,'false','09/22/2017',false);//OO-3252
            cc_oo_HeaderController.getShipToSellerInfo(ctx, seller.id,'212121', testCart.ccrz__EncryptedId__c );
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
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
            cc_lol_TestData.setupOOSettings();
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
            
            
            cc_oo_HeaderController.getShipTos(ctx);
            cc_oo_HeaderController.getSellers(ctx, '212121');
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_HeaderController.redirect(ctx,testCart.ccrz__EncryptedId__c, url, (string)seller.Id, testAccount.AccountNumber,'true',portalId,'false','01/22/2017',false);
            ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_HeaderController.getCartDetails(ctx,(string)seller.Id, testAccount.AccountNumber,testCart.ccrz__EncryptedId__c, true,'01/22/2017',true);
            //cc_oo_CartController.getShipToSellerInfo(ctx, seller.id ,'212121', testCart.ccrz__EncryptedId__c );
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
            }
        }
    }
    
}