/*
----------------------------------------------------------------------------------------------------------------------
Author                                      Date                                           Description
----------------------------------------------------------------------------------------------------------------------
Rajesh W                                10/14/2016                                   US:OO-325 Display Lead time.
*/
@isTest
private class cc_oo_HelperControllerTest{
    
    @isTest
    static void testLeadTime(){ 
         ccrz__E_Product__c newProduct  =   new ccrz__E_Product__c(
                                                    Name                       = 'tesTname',
                                                    //id                           = '',
                                                    ccrz__SKU__c               = '762345',
                                                    ccrz__ProductId__c         = '762345',
                                                    ccrz__ProductStatus__c     = 'Released',
                                                    ccrz__UnitOfMeasure__c     = '006',
                                                    ccrz__StartDate__c         = Date.today().addDays(-7),
                                                    ccrz__EndDate__c           = Date.today().addDays(7),
                                                    ccrz__Storefront__c        = 'xyz',
                                                    ccrz__ProductWeight__c     = 500,
                                                    cc_oo_Second_Description__c= 'test Second Description 762345'                     
                                            );
        insert newProduct;
        ccrz__E_Seller__c seller        =   new ccrz__E_Seller__c(
                                            cc_oo_Address_Line_1__c =   'abc', ccrz__EffectiveStart__c = Date.today().addDays(-1),
            ccrz__EffectiveEnd__c = Date.today().addDays(1), cc_oo_state__c = 'CA', ccrz__SellerId__c = 'ABDN'
                                            );
        insert seller;
        ccrz__E_ProductInventoryItem__c newInvItem  =   new ccrz__E_ProductInventoryItem__c(
                                                            ccrz__AvailabilityMessage__c    =   'Message',
                                                            cc_oo_LeadTime__c               =   '98765',
                                                            ccrz__ProductItem__c            =   newProduct.id, 
                                                            cc_oo_Seller__c                 =   seller.id,
                                                            ccrz__Status__c              =   'Available'
                                                        );
        insert newInvItem;
        
        Test.startTest();
        Map<String, String> dataMap = new   Map<String, String>();
        List<String>    prodIds     = new   List<String>();
        prodIds.add(newProduct.id);
        dataMap.put(newProduct.id,'98765');
        system.assert((cc_oo_HelperController.GetLeadTime('762345',seller.id)=='98765') && (cc_oo_HelperController.GetLeadTime(null,null)==null) && (cc_oo_HelperController.GetLeadTimeforAllProducts(prodIds,seller.id)==dataMap) && (cc_oo_HelperController.GetLeadTimeforAllProducts(null,null)==null) );
        Test.stopTest();
        
    }
     @isTest
    static void sendEmailTest(){
    	cc_lol_TestData.setupOOSettings();
        Test.startTest(); 
        cc_oo_HelperController email = new cc_oo_HelperController();
        email.sendEmail('abc@gmail.com','xyz@gmail.com','This is a subject','Hello');
        Test.stopTest();
    }
    @isTest 
    static void updateJDEOrderNumber(){   		
        
        String jdeResponseBody1 = '{"status": "success"}';
        String jdeResponseBody2 = '{ "@environment": "J333","@session": "7500.14192.2","@sessionidle": "","@type": "callmethod","@user": "FMBDV","callMethod": {"@app": "JDEXe","@name": "RetreiveNextOrderNumber","returnCode": {"@code": "0"},"params": {"mnOrderNumber": "9111285","szKeyCompany": "00651","szOrderType": "S6","BranchPlant": ""}}}';
        Map<String,String> resHeaders = new Map<String,String>();
        string nextOrderNumberString = null;
        List<ccrz__E_Order__C> testOrder = new List<ccrz__E_Order__C>();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        system.runas(thisUser){
            System.debug('Set catalog - scaffold test realted data');
            system.debug('***************Setting up Required Data*****************');
            cc_lol_TestData.setupOOServiceDataSettings();
	        //Query the data to get NextOrder Specif API information
	        cc_oo_ServiceData__c svcData = cc_oo_ServiceData__c.getValues('RetrieveOrder');
			system.debug('Auth-->' + svcData.cc_oo_AuthMechanism__c);
			system.debug('URI--->' + svcData.cc_oo_URI__c);
            //cc_lol_TestData.setupCatalog(); 
            testOrder = cc_lol_TestData.createOrders(1);          
        }
        ccrz__E_Order__c testOrder1 =  [select cc_oo_JDEOrderNumber__c,cc_oo_IsSyncOrder__c, id from ccrz__E_Order__c where id = :testOrder[0].id] ;
        system.debug('This should be Web Order Number --->' + testOrder1.cc_oo_JDEOrderNumber__c); //this is generated by Trigger 
        system.debug('IsSyncOrder to JDE--->' + testOrder1.cc_oo_IsSyncOrder__c);        
        Test.startTest(); 
        system.debug('Order initially created wihtout JDEOrder Number ---------> ' + testOrder[0].cc_oo_JDEOrderNumber__c ); //why 
        System.assertEquals(false,testOrder1.cc_oo_IsSyncOrder__c);
        //make a mock call to getNextOrder service - response is expected to come null
        if(nextOrderNumberString == null){        	
        	resHeaders.put('Content-Type','application/json');        	
        	Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', jdeResponseBody2, resHeaders));
             cc_oo_JDERetrieveNextOrderRequest orderReq = new cc_oo_JDERetrieveNextOrderRequest();
             system.debug('Before calling mock service ----> ' );
             nextOrderNumberString = cc_oo_HelperController.updateJDEOrderNumber(testOrder[0]);//we are testing this, which has call out to Service.              
             system.debug('After calling mock service ----> ' );
             system.debug('NextNumber----------->'+ nextOrderNumberString);//this is returned next number after calling mock service
                       
             if (nextOrderNumberString!=null){             	
	             system.debug('Expected Next Number ----------->' + nextOrderNumberString);
	             testOrder[0].cc_oo_JDEOrderNumber__c =  nextOrderNumberString;//expected nextNumber 9111285
	             upsert  testOrder[0];    
             }                                               
                                                  
        } 
        Id testId= testOrder[0].id;
        ccrz__E_Order__C orderObj = [select id,cc_oo_JDEOrderNumber__c from ccrz__E_Order__c where id = :testId];
        if(orderObj!=null){        	
	        system.debug('JDE nextOrderNumber Number ---------> ' + nextOrderNumberString );
	        system.debug('jdeOrderNumber Order Number ---------> ' + orderObj.cc_oo_JDEOrderNumber__c );	        		        
	        Test.stopTest();
	        System.assertEquals(nextOrderNumberString,orderObj.cc_oo_JDEOrderNumber__c);//validate jdeNextOrder is created appropriately and persisted  
        }
    	
    }
    // new method added
    @isTest
    static void syncOrderToJDETest(){
        String jdeResponseBody1 = '{"status": "success"}';
        String jdeResponseBody2 = '{ "@environment": "J333","@session": "7500.14192.2","@sessionidle": "","@type": "callmethod","@user": "FMBDV","callMethod": {"@app": "JDEXe","@name": "RetreiveNextOrderNumber","returnCode": {"@code": "0"},"params": {"mnOrderNumber": "9111285","szKeyCompany": "00651","szOrderType": "S6","BranchPlant": ""}}}';
        //Map<String,String> resHeaders = new Map<String,String>();
        string nextOrderNumberString = null;
        List<ccrz__E_Order__c> testOrder = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c testOrder1;
        List<ccrz__E_OrderItem__c> orderItems;
        String jdeOrderNumber = '47479';
        string portalUser = ccrz.cc_CallContext.currPageParameters.get('portalUser');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        cc_oo_JDESyncOrderRequest syncReq;
        String stringRespStatus = '200';
        Integer stringRespCode; 
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        system.runas(thisUser){
            System.debug('Set catalog - scaffold test realted data');
            system.debug('***************Setting up Required Data*****************');
            cc_oo_ServiceData__c svcData = cc_oo_ServiceData__c.getValues('SyncOrder');
			system.debug('Auth-->' + svcData.cc_oo_AuthMechanism__c);
			system.debug('URI--->' + svcData.cc_oo_URI__c);
			testOrder = cc_lol_TestData.createOrders(1); 
        }
        Test.startTest();
        // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', jdeResponseBody1, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', jdeResponseBody2, resHeaders));
            cc_oo_HelperController.syncOrderToJDE(testOrder1,orderItems,jdeOrderNumber,portalUser);
        Test.stopTest();
    }
    @isTest 
    static void getVfdFlagForAllTest(){
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
            Test.startTest(); 
            cc_oo_HelperController.getVfdFlagForAll(productIdList);
            Test.stopTest();
        }
    }
    @isTest         
    static void shuffleCartTest(){         
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
        cc_oo_HelperController.shuffleCart(cartid,'3/2/2017','Pickup',true);         
        Test.stopTest();            
    }
    @isTest 
    static void getSellersAllTest(){
        
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
            String url='https://onlordqa-landolakespartners.cs13.force.com/PurinaMills';
            
            ccrz__E_Category__c prebookCat=[select Name,ccrz__CategoryID__c from ccrz__E_Category__c limit 1];
            prebookCat.Name='Prebook';
            update prebookCat;
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
            cc_oo_HelperController.getSellersAll('212121');
            Test.stopTest();
        }
    }
    @isTest
    static void addNewCartRowTest(){
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
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        Test.startTest();
        String skuID = 'test623';
        Integer quantity = 10;
        String cartId = String.valueOf(testCart.Id); 
        cc_oo_HelperController.addNewCartRow(skuID,quantity,cartId);
        Test.stopTest();
    }
    @isTest
    static void getKeyFromValueTest(){
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
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        Test.startTest();
        Map<String,String> mp = new Map<String,String>();
        mp.put('keyCode','TestABC');
        String value = '10';
        cc_oo_HelperController.getKeyFromValue(mp,value);
        Test.stopTest();
    }
    @isTest
    static void getCountryTextTest(){
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
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        Test.startTest();
        String countryCode = '3873Test';
        cc_oo_HelperController.getCountryText(countryCode);
        Test.stopTest();
    }
    @isTest
    static void getStateTextTest(){
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
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        Test.startTest();
        String stateCode = '411038';
        cc_oo_HelperController.getStateText(stateCode);
        Test.stopTest();
    }
    /*@isTest
    static void addNewCartListItemTest(){
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();            
        ccrz.cc_CallContext.initRemoteContext(ctx);         
        ccrz__E_Cart__c testCart;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];         
        system.runas(thisUser){         
            System.debug('Set catalog');            
            cc_lol_TestData.setupCatalog();         
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id;         
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;  
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        Test.startTest();
        String skuId = '13343';
        Integer quantity = 10;
        String cartGUID = '47dvd'; 
        Decimal price = 100.0;
        cc_oo_HelperController.addNewCartListItem(skuId,quantity,cartGUID,price);
        Test.stopTest();
    }*/
    @isTest
    static void modifyOrderCheckTest(){
        String encryptedId = '';
        ccrz__E_Cart__c testCart;
    	ccrz__E_Cart__c oldTestCart;
    	ccrz__E_Cart__c testCart1;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Order__c newOrder;
        ccrz__E_Order__c OldOrder;
        system.runas(thisUser){         
            cc_lol_TestData.setupTestUser();
            List<ccrz__E_Order__c> orders = cc_lol_TestData.createOrders(3);
            List<ccrz__E_Order__c> order = [SELECT Id, ccrz__EncryptedId__c,cc_oo_JDEOrderNumber__c,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.cc_oo_AmendedCart__c,ccrz__OriginatedCart__r.cc_oo_OriginalCart__c FROM ccrz__E_Order__c WHERE Id = :orders[0].Id];
            List<ccrz__E_Order__c> order1=[SELECT Id, ccrz__EncryptedId__c,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.Id,cc_oo_JDEOrderNumber__c FROM ccrz__E_Order__c WHERE Id = :orders[2].Id];
            newOrder=order[0];
            OldOrder=order1[0];
            encryptedId = newOrder.ccrz__EncryptedId__c;
            testCart = cc_lol_TestData.createCart();
            testCart1 = cc_lol_TestData.createCart();
        	oldTestCart=cc_lol_TestData.createCart();
        	ccrz__E_CartItem__c cartItemNew = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        	ccrz__E_CartItem__c cartItemOld = cc_lol_TestData.addCartItem(oldTestCart, cc_lol_TestData.products[1].Id,10,100.00);
            ccrz__E_CartItem__c cartItemOld3=cc_lol_TestData.addCartItem(oldTestCart, cc_lol_TestData.products[1].Id,8,200.00);
            cartItemOld.cc_oo_IsListPrice__c=true;
            cartItemOld3.cc_oo_IsListPrice__c=true;
            update cartItemOld;
            update cartItemOld3;
        	testCart.cc_oo_OriginalCart__c=oldTestCart.id;
       		testCart.cc_oo_AmendedCart__c=true;
       		testCart.ccrz__CartStatus__c='open';
       		oldTestCart.ccrz__CartStatus__c='open';
       		testCart1.ccrz__CartStatus__c='open';
       		testCart1.cc_oo_SplitCart__c=testCart.id;
       		testCart.cc_oo_OriginalOrder__c=newOrder.id;
       		oldTestCart.cc_oo_OriginalOrder__c=OldOrder.id;
       		OldOrder.ccrz__OriginatedCart__c=oldTestCart.id;
       		OldOrder.ccrz__OriginatedCart__r.Id=oldTestCart.id;
       		newOrder.cc_oo_JDEOrderNumber__c=null;
       		OldOrder.cc_oo_JDEOrderNumber__c='983838';
       		newOrder.ccrz__OriginatedCart__c=testCart.id;
       		newOrder.ccrz__OriginatedCart__r.Id=testCart.id;
       		newOrder.ccrz__OriginatedCart__r.cc_oo_OriginalCart__c=oldTestCart.id;
       		system.debug('OldOrder.id'+OldOrder.id);
       		update OldOrder;
       		update testCart;
       		update oldTestCart;
        	update newOrder;
        	update testCart1;
        }
        
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        ApexPages.currentPage().getParameters().put('o', encryptedId);
        Test.startTest();
        cc_oo_HelperController.modifyOrderCheck(newOrder.id,OldOrder.id,'683833',true);
        Test.stopTest();
    }
}