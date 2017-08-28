/*
----------------------------------------------------------------------------------------------------------------------
Author                                      Date                                           Description
----------------------------------------------------------------------------------------------------------------------
Rajesh W                                10/14/2016                                   US:OO-535 The JDE ""2nd description"" shall be displayed under or appended to the product label name.
Piyali M                                10/28/2016                                   US:OO-339 The system will not allow user to enter two products types in a cart.
*/
@isTest
private class cc_oo_ProductDetailControllerTest{
    
    //private static final String ATP_RESPONSE_BODY = '{"@environment":"JDV7333","@session":"7008.1481791831.3","@sessionidle":"","@type":"callmethod","@user":"FMWOSBDV","callMethod":{"-app":"app5","-name":"PriceRetreivalForCustomer","returnCode":{"-code":"0"},"params":{"AN8_ShipToNUmber":"321321","MCU_BranchPlant":"IGH","DCTO_OrderType":"SO","UPRC_UnitPrice":"58.4500","LITM_ItemNumber":"1486010-106","szFreightHandlingCode":"F","UOM_Input":"BG","UOM1_Primary":"BG","mnAmountExtendedPrice":"58.45","UOM_Pricing":"BG"}}}';
    public static final String STOREFRONT_NAME  = 'PurinaMills';
    public static final String ACCOUNT_NAME     = 'TestAccount';
    public static final String ACCOUNTGROUP_NAME = 'TestAccountGroup';
    public static final String ANON_ACCOUNT_NAME  = 'CCAnonymous';
    public static final String ANON_ACCOUNTGROUP_NAME = 'Anonymous';
    public static final String CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME = 'CloudCraze Customer Community User';
    public static final String USER_LANGUAGE = 'en_US';
    public static final Decimal DEFAULT_PRICE = 100.00;
    private static final String ATP_RESPONSE_BODY = '{"@environment" : "JQA7333","@session" : "5476.1491915171.4","@sessionidle" : "1800","@type" : "callmethod","@user" : "FMWOSBQA","callMethod" : {"@app" : "JDEXe","@name" : "PriceRetreivalForCustomer","returnCode" : {"@code" : "0"},"params" : {"AN8_ShipToNUmber" : "502979","MCU_BranchPlant" : "HARR","DCTO_OrderType" : "SO","UPRC_UnitPrice" : "1087.1","LITM_ItemNumber" : "3003484-324","VERS_P4210Version" : "FDOB5701","szFreightHandlingCode" : "F","UOM_Input" : "BG","UOM1_Primary" : "BG","mnAmountExtendedPrice" : "19.02","UOM_Pricing" : "TN"}}}';
    private static final String ATP_RESPONSE_BODY1 = '{"params":{"VERS_P4210Version":"FDOB5701","MCU_BranchPlant":"ABDN","LITM_ItemNumber":"3003340-308","DCTO_OrderType":"S6","AN8_ShipToNUmber":"250287"}}';
	private static final String ATP_RESPONSE_BODY2 = '{"@environment" : "JQA7333","@session" : "5476.1491915171.4","@sessionidle" : "1800","@type" : "callmethod","@user" : "FMWOSBQA","callMethod" : {"@app" :"JDEXe","@name" : "PriceRetreivalForCustomer","returnCode" : {"@code" : "0"},"params" : {"AN8_ShipToNUmber" : "502979","MCU_BranchPlant" : "HARR","DCTO_OrderType" : "SO","UPRC_UnitPrice" : "1087.1","LITM_ItemNumber" : "3003484-324","VERS_P4210Version" : "FDOB5701","szFreightHandlingCode" : "F","UOM_Input" : "BG","UOM1_Primary" : "BG","mnAmountExtendedPrice" : "19.02","UOM_Pricing" : "TN"}}}';
	
    @isTest
    static void testE2Description(){ 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              cc_lol_TestData.setupTestUser();
              cc_lol_TestData.setupOOSettings();
             cc_lol_TestData.setupOOServiceDataSettings();                     
        ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
        PageReference testPage          = new PageReference('HomePage');
        Test.setCurrentPage(testPage);
        testCart = cc_lol_TestData.createCart();
        ccrz__E_CartItem__c cartItem1  = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        List<ccrz__E_Product__c> products = [select id,ccrz__SKU__c,ccrz__ProductId__c,cc_oo_Second_Description__c from ccrz__E_Product__c LIMIT 1];
        ApexPages.currentPage().getParameters().put('sku', products[0].ccrz__SKU__c);
        List<ccrz__E_Cart__c> cartDetails = [SELECT c.ccrz__EncryptedId__c,c.Id, c.cc_oo_Seller__r.ccrz__sellerId__c,
                                             cc_oo_ShipToAccount__c,cc_oo_ShipToAccount__r.AccountNumber, ccrz__RequestDate__c,cc_oo_Seller__c,
                                             (SELECT Id,cc_oo_IsListPrice__c, ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c FROM ccrz__E_CartItems__r) 
                                             FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:testCart.ccrz__EncryptedId__c LIMIT 1];
        System.debug('cartDetails'+cartDetails); 
        testCart.cc_oo_Seller__c=seller.id;
        update testCart;
        String sid=cartDetails[0].cc_oo_Seller__c;
        System.debug('cartDetails[0].cc_oo_Seller__c'+cartDetails[0].cc_oo_Seller__c);
        List<ccrz__E_ProductInventoryItem__c> inventoryStatus = [SELECT ccrz__Status__c, cc_oo_PalletSize__c,cc_oo_IsOnlyPalletProduct__c,
					ccrz__ProductItem__r.ccrz__sku__c,ccrz__ProductItem__r.ccrz__UnitOfMeasure__c ,ccrz__ProductItem__r.cc_oo_UoMDesc__c,
                    ccrz__ProductItem__r.cc_oo_TypeOfProduct__c FROM ccrz__E_ProductInventoryItem__c
                    WHERE ccrz__ProductItem__c = :products[0].id AND cc_oo_Seller__c = :sid];
            
        System.debug('inventoryStatus'+inventoryStatus);      
        ApexPages.currentPage().getParameters().put('sid',sid);
        ApexPages.currentPage().getParameters().put('cartId', testCart.ccrz__EncryptedId__c);
            ccrz.cc_CallContext.currContact = cc_lol_TestData.testUser.Contact;
                ccrz.cc_CallContext.currUser.id=thisUser.id;
                ccrz.cc_CallContext.currAccountId=cc_lol_TestData.testAccount.Id;
        }
        Test.startTest();
        // build responseHeaders
        final Map<String,String> resHeaders = new Map<String,String>();
        resHeaders.put('Content-Type','application/json');
        // setup mock response
        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY, resHeaders));
        cc_oo_ProductDetailController testObject    =   new     cc_oo_ProductDetailController();
        ApexPages.currentPage().getParameters().put('cartId', '');
        cc_oo_ProductDetailController testObject1 = new cc_oo_ProductDetailController();
        testCart.cc_oo_Seller__c=null;
        update testCart;
        testObject1 = new cc_oo_ProductDetailController();
        ApexPages.currentPage().getParameters().put('sku', 'products[0].ccrz__SKU__c');
        testObject1    =   new     cc_oo_ProductDetailController();
        system.assert(testObject.e2Description=='product001 Bag');
        Test.stopTest(); 
    }
    //US - 339 - Test class to test add to cart validation
    @isTest 
    static void addToCartOOTest(){
    //Prepare Test Data
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        ccrz.cc_RemoteActionContext ctx2 = new ccrz.cc_RemoteActionContext(); 
        
        ccrz__E_Cart__c testCart;
        ccrz__E_Cart__c testCart1;
        ccrz__E_Cart__c testCart2;
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              cc_lol_TestData.setupTestUser();
              cc_lol_TestData.setupOOSettings();
              ccrz.cc_CallContext.pageLabels=cc_lol_TestData.pageLabels;
              testCart = cc_lol_TestData.createCart();
              testCart1 = cc_lol_TestData.createCart();
              testCart2 = cc_lol_TestData.createCart(); 
              
              System.runAs(cc_lol_TestData.testUser) {
                 ccrz__E_CartItem__c cartItem1  = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
                 cartItem1.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[2].Id;
                 update cartItem1;
                 ccrz__E_CartItem__c cartItem2  = cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[7].Id,12,200.00);
                 cartItem2.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[0].Id;
                 update cartItem2;
                 ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
                 testCart.cc_oo_Seller__c=seller.id;
                 testCart.ccrz__ShipTo__c=cc_lol_TestData.shipToAddress.Id;
                 testCart.cc_oo_SplitCart__c=testCart2.Id;
                 testCart1.cc_oo_Seller__c=seller.id;
                 testCart1.ccrz__ShipTo__c=cc_lol_TestData.shipToAddress.Id;
                 testCart1.cc_oo_SplitCart__c=testCart.Id;
              	String sellerId = String.valueOf(seller.Id);
                ccrz.cc_CallContext.currContact = cc_lol_TestData.testUser.Contact;
                ccrz.cc_CallContext.currUser=cc_lol_TestData.testUser;
                ccrz.cc_CallContext.currAccountId=cc_lol_TestData.testAccount.Id;
                Account acct = cc_lol_TestData.testAccount;
                testCart.ccrz__Account__c= cc_lol_TestData.testAccount.Id;
                testCart.ccrz__Contact__c=cc_lol_TestData.testUser.Contact.Id;
                testCart.OwnerId =cc_lol_TestData.testUser.Id;
                
                ccrz__E_CartItem__c cartItem3 = cc_lol_TestData.addCartItem(testCart2, cc_lol_TestData.products[8].Id,12,200.00);
                cartItem2.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[1].Id;
                update cartItem3;
                
                testCart2.ccrz__Account__c= cc_lol_TestData.testAccount.Id;
                testCart2.ccrz__Contact__c=cc_lol_TestData.testUser.Contact.Id;
                testCart2.OwnerId           =cc_lol_TestData.testUser.Id;
                testCart2.ccrz__ShipTo__c=cc_lol_TestData.shipToAddress.Id;
                
                update testCart;
                update testCart1;          
                update testCart2;
                String quantity = '15';
                String cartId = testCart2.ccrz__EncryptedId__c;
                String cartId1 = testCart.ccrz__EncryptedId__c;
                String cartID2=testCart1.ccrz__EncryptedId__c;
                String sku = 'test002'; 
                String sku2 = 'test001';
                String sku1='0001823';
                String type = 'list-price';
                String price = '20';
                String palletPrice = '10';
                Decimal contractId = 456;
                String palletQuantity = '10';
                String dateShip=date.today().addDays(10).format();
                String shipTo = String.valueOf(acct.AccountNumber);
                Boolean isShipto = false;
              
                Map<String,Object> productDetailMap = new Map<String, Object>();
                productDetailMap.put('sku', sku2);
                productDetailMap.put('quantity', quantity);
                productDetailMap.put('cartId', cartId);
                productDetailMap.put('sid', sellerId);
                productDetailMap.put('isSplit',isShipto);
                productDetailMap.put('shipTo',shipTo);
               	productDetailMap.put('shipDate',dateShip);
                
                Map<String,Object> priceMap= new Map<String, Object>();
                priceMap.put('type', type);
                priceMap.put('price', price);
                priceMap.put('contractId', contractId);
                priceMap.put('onlyPallet', true);
                priceMap.put('palletPrice', palletPrice);
                priceMap.put('palletQuantity', palletQuantity);
                  
                ccrz__E_Product__c productDetail = [SELECT Id,ccrz__SKU__c, cc_oo_TypeOfProduct__c,ccrz__UnitOfMeasure__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c =:sku2];
                productDetail.cc_oo_TypeOfProduct__c='Bulk';
                update productDetail;
                System.debug('productDetail'+productDetail);
                List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_LeadTime__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c=:productDetail.Id and cc_oo_Seller__c=:sellerId];
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
                testCart.cc_oo_SplitCartType__c='Secondary';
                testCart.ccrz__ActiveCart__c=False;
                update testCart;
               
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[1].Id,12,200.00);
                ccrz__E_CartItem__c cartitem=[select Id,cc_oo_IsListPrice__c,cc_oo_ContractPrice__c,ccrz__Product__c from ccrz__E_CartItem__c where ccrz__Cart__c=:testCart.Id and ccrz__Product__c=:cc_lol_TestData.products[0].Id limit 1];
                cartitem.cc_oo_IsListPrice__c=true;
                update cartitem;
               	testCart.cc_oo_SplitCartType__c='Primary';
                testCart.ccrz__ActiveCart__c=true;
                update testCart;                
                ccrz.cc_RemoteActionResult remoteResult;
                ccrz.cc_RemoteActionResult remoteResult2;
                Test.startTest();
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap, priceMap );
                //productDetailMap.put('cartId','');
                dateShip=date.today().format();
                //remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap, priceMap );
                Map<String,Object> productDetailMap2 = new Map<String, Object>();
                productDetailMap2.put('sku', sku);
                productDetailMap2.put('quantity', quantity);
                productDetailMap2.put('cartId', cartId1);
                productDetailMap2.put('sid', sellerId);
                productDetailMap2.put('isSplit',isShipto);
                productDetailMap2.put('shipTo',shipTo);
                productDetailMap2.put('shipDate',dateShip);
                Map<String,Object> priceMap2= new Map<String, Object>();
                priceMap2.put('type', 'contract-price');
                priceMap2.put('price', price);
                priceMap2.put('contractId', contractId);
                priceMap2.put('onlyPallet', false);
                priceMap2.put('palletPrice', palletPrice);
                priceMap2.put('palletQuantity', palletQuantity);
                remoteResult2 = cc_oo_ProductDetailController.addToCartOO(ctx2, productDetailMap2, priceMap2 );    
                
                testCart.cc_oo_SplitCartType__c='Primary';
                testCart.ccrz__ActiveCart__c=true;
                update testCart;
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2);   
                
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2);
                //productDetailMap2.put('sku', 'test003');
                //remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2);    
                productDetailMap2.put('cartId', cartID1);
                productDetailMap.put('cartId','');
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2 );                
                Test.stopTest();
                System.assert(remoteResult !=NULL);
                  if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                }
                
              }
              
          }
    
    }
    //US - 339 - Test class to test add to cart validation
    @isTest 
    static void addToCartOOTestCoverage(){
    //Prepare Test Data
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        ccrz.cc_RemoteActionContext ctx2 = new ccrz.cc_RemoteActionContext(); 
        
        ccrz__E_Cart__c testCart;
        ccrz__E_Cart__c testCart2;
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              cc_lol_TestData.setupTestUser();
              cc_lol_TestData.setupOOSettings();
              testCart = cc_lol_TestData.createCart();
              testCart2 = cc_lol_TestData.createCart(); 
              
              System.runAs(cc_lol_TestData.testUser) {
                 ccrz__E_CartItem__c cartItem1  = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
                 cartItem1.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[2].Id;
                 update cartItem1;
                 ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
                 testCart.cc_oo_Seller__c=seller.id;
                 testCart.ccrz__ShipTo__c=cc_lol_TestData.shipToAddress.Id;
                 testCart.cc_oo_SplitCart__c=testCart2.Id;
              	String sellerId = String.valueOf(seller.Id);
                ccrz.cc_CallContext.currContact = cc_lol_TestData.testUser.Contact;
                ccrz.cc_CallContext.currUser=cc_lol_TestData.testUser;
                ccrz.cc_CallContext.currAccountId=cc_lol_TestData.testAccount.Id;
                Account acct = cc_lol_TestData.testAccount;
                testCart.ccrz__Account__c= cc_lol_TestData.testAccount.Id;
                testCart.ccrz__Contact__c=cc_lol_TestData.testUser.Contact.Id;
                testCart.OwnerId            =cc_lol_TestData.testUser.Id;
                
                ccrz__E_CartItem__c cartItem2 = cc_lol_TestData.addCartItem(testCart2, cc_lol_TestData.products[0].Id,12,200.00);
                cartItem2.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[2].Id;
                update cartItem2;
                
                testCart2.ccrz__Account__c= cc_lol_TestData.testAccount.Id;
                testCart2.ccrz__Contact__c=cc_lol_TestData.testUser.Contact.Id;
                testCart2.OwnerId           =cc_lol_TestData.testUser.Id;
                testCart2.ccrz__ShipTo__c=cc_lol_TestData.shipToAddress.Id;
                
                update testCart;          
                update testCart2;
                String quantity = '15';
                String cartId = testCart2.ccrz__EncryptedId__c;
                String cartId1 = testCart.ccrz__EncryptedId__c;
                String sku = '3003340-303'; 
                String sku2 = 'test001';
                
                String type = 'contract-price';
                String price = '20';
                String palletPrice = '10';
                Decimal contractId = 456;
                String palletQuantity = '10';
                
                String shipTo = String.valueOf(acct.AccountNumber);
                Boolean isShipto = false;
              
                Map<String,Object> productDetailMap = new Map<String, Object>();
                productDetailMap.put('sku', sku2);
                productDetailMap.put('quantity', quantity);
                productDetailMap.put('cartId', cartId);
                productDetailMap.put('sid', sellerId);
                productDetailMap.put('isSplit',isShipto);
                productDetailMap.put('shipTo',shipTo);
               
                
                Map<String,Object> priceMap= new Map<String, Object>();
                priceMap.put('type', type);
                priceMap.put('price', price);
                priceMap.put('contractId', contractId);
                priceMap.put('onlyPallet', false);
                priceMap.put('palletPrice', palletPrice);
                priceMap.put('palletQuantity', palletQuantity);
                  
                ccrz__E_Product__c productDetail = [SELECT Id,ccrz__SKU__c, cc_oo_TypeOfProduct__c,ccrz__UnitOfMeasure__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c =:sku2];
                System.debug('productDetail'+productDetail);
                List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_LeadTime__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c=:productDetail.Id and cc_oo_Seller__c=:sellerId];
               
                testCart.cc_oo_SplitCartType__c='Primary';
                testCart.ccrz__ActiveCart__c=true;
                testCart.cc_oo_AmendedCart__c=true;
                update testCart;
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
                cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[1].Id,12,200.00);
                ccrz__E_CartItem__c cartitem=[select Id,cc_oo_IsListPrice__c,cc_oo_ContractPrice__c,ccrz__Product__c from ccrz__E_CartItem__c where ccrz__Cart__c=:testCart.Id and ccrz__Product__c=:cc_lol_TestData.products[0].Id limit 1];
                cartitem.cc_oo_IsListPrice__c=false;
                update cartitem;
               
                                
                ccrz.cc_RemoteActionResult remoteResult;
                ccrz.cc_RemoteActionResult remoteResult2;
                Test.startTest();
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap, priceMap );
                
                Map<String,Object> productDetailMap2 = new Map<String, Object>();
                productDetailMap2.put('sku', sku);
                productDetailMap2.put('quantity', quantity);
                productDetailMap2.put('cartId', cartId1);
                productDetailMap2.put('sid', sellerId);
                productDetailMap2.put('isSplit',isShipto);
                productDetailMap2.put('shipTo',shipTo);
                Map<String,Object> priceMap2= new Map<String, Object>();
                priceMap2.put('type', 'list-price');
                priceMap2.put('price', price);
                priceMap2.put('contractId', contractId);
                priceMap2.put('onlyPallet', false);
                priceMap2.put('palletPrice', palletPrice);
                priceMap2.put('palletQuantity', palletQuantity);
                remoteResult2 = cc_oo_ProductDetailController.addToCartOO(ctx2, productDetailMap2, priceMap2 );    
                
                testCart.cc_oo_SplitCartType__c='Secondary';
                testCart.ccrz__ActiveCart__c=false;
                update testCart;
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2);   
                productDetailMap.put('cartId','');
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap, priceMap );
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2);
                productDetailMap2.put('sku', 'test003');
                remoteResult = cc_oo_ProductDetailController.addToCartOO(ctx, productDetailMap2, priceMap2);                   
                Test.stopTest();
                System.assert(remoteResult !=NULL);
                  if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                }
                
              }
              
          }
    
    }
    
     //to test the vfd flag product
     @isTest 
     static void getProductsVfdFlagTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            User user2 =cc_lol_TestData.testUser;
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<ccrz__E_Product__c> products = [select id,ccrz__SKU__c from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            ApexPages.CurrentPage().getparameters().put('sku', products[0].ccrz__SKU__c);            
            /*ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_LeadTime__c='3 Days');
            insert prodInvItem;*/
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.getVfdFlag(ctx,productIdList);
          
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
    private static void getProductsTest(){
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
                            
       system.runas(thisUser){
              cc_lol_TestData.setupOOSettings();
            cc_lol_TestData.setupCatalog();
            cc_lol_TestData.setupTestUser();
            testCart = cc_lol_TestData.createCart();
            Account testAccount =  cc_lol_TestData.testAccount;
              ccrz.cc_CallContext.currAccountGroup=cc_lol_TestData.testAccountGroup;
              Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];                            
              ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
            testCart = cc_lol_TestData.createCart();
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];                      
            ccrz.cc_CallContext.pageLabels=cc_lol_TestData.pageLabels;
              Map<String,String> pageParams = new Map<String, String>();
           pageParams.put('cartID', String.valueOf(testCart.ccrz__EncryptedId__c));
            pageParams.put('sid', String.valueOf(seller.Id));
            ccrz.cc_CallContext.currPageParameters = pageParams;
            
        Test.startTest();
         ccrz.cc_RemoteActionResult remoteResult =   cc_oo_ProductDetailController.getProducts(ctx,seller.id,cc_lol_TestData.products[9].ccrz__SKU__c);
        Test.stopTest();
        
        system.assertEquals(remoteResult.success,true);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                } 
              
    }
    }
    // New method added
    @isTest
    private static void getaddContractItem(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
           cc_lol_TestData.setupOOSettings(); 
            Account testAccount =  cc_lol_TestData.testAccount;
            
            cc_lol_TestData.setupTestUser();
            testCart = cc_lol_TestData.createCart();
            ccrz__E_CartItem__c cartItem =  cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            cartItem.cc_oo_ContractPrice__c = cc_lol_TestData.contractprice[2].Id;
            update cartItem;
            
            List<cc_oo_ContractPrice__c> contract = [SELECT Id, cc_oo_AvailabilityQty__c, cc_oo_ContractNumber__c,cc_oo_isfreightincluded__c FROM cc_oo_ContractPrice__c WHERE ID =:cc_lol_TestData.contractprice[2].Id];
            
            Integer quantity = 20;
            Decimal price = 20.0; 
            String contractNumber= String.valueOf(contract[0].cc_oo_ContractNumber__c); 
            System.debug('contractNumber'+contractNumber);
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            List<ccrz__E_CartItem__c> contractItemsList = new List<ccrz__E_CartItem__c>();
            contractItemsList.add(cartItem);
            
            System.runAs(cc_lol_TestData.testUser) {
                Test.startTest();
				List<ccrz__E_CartItem__c> contractItemsListResult=cc_oo_ProductDetailController.addContractItem(testAccount.Id,contractNumber,20, contractItemsList,price,cc_lol_TestData.products[0].ccrz__SKU__c,contract[0],(string)seller.id);
                Test.stopTest();
                system.assertEquals(contractItemsListResult!=null,true);
            }
        }
    }
    // New method added
    @isTest
    private static void getSecondaryCartProductQtyDetailsTest(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        ccrz__E_Cart__c testCart,testCart1;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            Account testAccount =  cc_lol_TestData.testAccount;
            
            cc_lol_TestData.setupTestUser();
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            testCart1=cc_lol_TestData.createCart();
            testCart.cc_oo_SplitCart__c=testCart1.Id;
            cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[1].Id,22,2000.00);
            cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[7].Id,20,200.00);
            
            update testCart;
            List<ccrz__E_CartItem__c> cartItemList = [select Id from ccrz__E_CartItem__c where ccrz__Cart__c = :testCart.Id];
            System.runAs(cc_lol_TestData.testUser) {
                Test.startTest();
                 ccrz.cc_RemoteActionResult remoteResult=cc_oo_ProductDetailController.getSecondaryCartProductQtyDetails(ctx,testCart.ccrz__EncryptedId__c);
                cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[1].Id,23,1000.00);
                remoteResult=cc_oo_ProductDetailController.getSecondaryCartProductQtyDetails(ctx,testCart.ccrz__EncryptedId__c);
                ccrz.cc_RemoteActionResult remoteResult1=cc_oo_ProductDetailController.getSecondaryCartProductQtyDetails(ctx,null);
                Test.stopTest();
                system.assertEquals(remoteResult.success,true);
              if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
            } 
            }
        }
    }
    // New Method added
    @isTest
    private static void getProductDetailsTest(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            cc_lol_TestData.setupTestUser();
            cc_lol_TestData.setupOOSettings();
            cc_lol_TestData.setupOOServiceDataSettings();
            testCart = cc_lol_TestData.createCart(); 
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c limit 3];
            List<String> productIdList = new List<String>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__Status__c='Available',ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_Seller__c =seller.Id);
            insert prodInvItem;
            Test.startTest();
            ccrz.cc_RemoteActionResult remoteResult=cc_oo_ProductDetailController.getProductDetails(ctx,productIdList[0],seller.Id);
            Test.stopTest();
            system.assertEquals(remoteResult.success,true);
            if(remoteResult.success){
                system.assertEquals(remoteResult.data!=null,true);
            } 
        } 
    }
    
    /* @isTest
    private static void getProductDetailsTest(){
        cc_lol_TestData.setupCatalog();
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c limit 3];
        List<Id> productIdList = new List<Id>();
        for(ccrz__E_Product__c prod: products){
            productIdList.add(prod.Id);
        }
        ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
        PageReference pageRef = Page.ccrz__HomePage;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
        ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__Status__c='Available',ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_Seller__c =seller.Id);
        insert prodInvItem;
        Test.startTest();
        ccrz.cc_RemoteActionResult remoteResult=cc_oo_ProductDetailController.getProductDetails(ctx,productIdList[0],seller.Id);
        
        Test.stopTest();
        system.assertEquals(remoteResult.success,false);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,false);
                }          
    }*/

    //US - 56 - Test class to test add to cart price validation
    @isTest 
    static void getProductPricingTest(){
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
         
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              cc_lol_TestData.setupTestUser();
              testCart = cc_lol_TestData.createCart();
             Account acct = cc_lol_TestData.testAccount;
              acct.ShipTo_Flag__c = true;
              update acct;
              
              System.runAs(cc_lol_TestData.testUser) {
              ccrz__E_Seller__c s = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
              
              /*Account acct = cc_lol_TestData.testAccount;
              acct.ShipTo_Flag__c = true;
              update acct;*/
              
              String sku2 = 'test001';
              ccrz__E_Product__c products = [select id,ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c=:sku2];
              ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__ProductItem__c=products.Id,cc_oo_Seller__c =s.Id,ccrz__Status__c='Available');
              insert prodInvItem;
              //*********************** *******************************************************
        // INSERT final PriceList and contract price
        //******************************************************************************
        final List<cc_oo_PriceList__c> customPriceLists = new List<cc_oo_PriceList__c> {
                new cc_oo_PriceList__c(
                       
                        cc_oo_NetListPrice__c    =  10,
                        cc_oo_PalletPrice__c     =  20,
                        cc_oo_Product__c         = products.Id,
                        cc_oo_Seller__c          = s.Id,
                        cc_oo_ExpirationDate__c  = Date.today().addDays(7),
                        cc_oo_EffectiveDate__c   = Date.today().addDays(-7),
                        cc_oo_ShipTo__c          = acct.Id
                )
        };
        insert customPriceLists;
        
        final List<cc_oo_ContractPrice__c> customContractPriceLists = new List<cc_oo_ContractPrice__c> {
                new cc_oo_ContractPrice__c(
                        
                        cc_oo_Product__c         =  products.Id,
                        cc_oo_ContractQty__c     =  10,
                        cc_oo_ContractUoM__c     =  '001',
                        cc_oo_ConversionValue__c =  10,
                        cc_oo_ExpireDate__c      = Date.today().addDays(7),
                        cc_oo_EffectiveDate__c   = Date.today().addDays(-7),
                        cc_oo_ContractPrice__c   = 20,
                        cc_oo_Seller__c          = s.Id,
                        cc_oo_contractPriceID__c = '111078-LANS-131529-3001498-415'
                )
        };
        insert customContractPriceLists;  
        cc_lol_TestData.setupOOSettings();
        // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
        // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
        cc_lol_TestData.setupOOServiceDataSettings();                     
              Test.startTest();
    
                String cartId = testCart.ccrz__EncryptedId__c;
                ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.getProductPricing(ctx, products.Id, s.Id,  cartId, acct.AccountNumber, null);
                ccrz.cc_RemoteActionResult remoteResult1 = cc_oo_ProductDetailController.getProductPricing(ctx, products.Id, s.Id,  null, acct.AccountNumber, null);
               //ccrz.cc_RemoteActionResult remoteResult1=cc_oo_ProductDetailController.getProductDetails(ctx,products.Id,s.Id);
               ccrz.cc_RemoteActionResult remoteResult2 =  cc_oo_ProductDetailController.checkProductPricing(ctx,products.ccrz__SKU__c, s.Id,acct.AccountNumber);
               customPriceLists[0].cc_oo_NetListPrice__c = 0;
               update customPriceLists;
               ccrz.cc_RemoteActionResult remoteResult3 =  cc_oo_ProductDetailController.checkProductPricing(ctx,products.ccrz__SKU__c, s.Id,acct.AccountNumber); 
               ccrz.cc_RemoteActionResult remoteResult4 =  cc_oo_ProductDetailController.checkProductPricing(ctx,null, null,null); 
              Test.stopTest();
                
                //Validate the test data
                system.assertEquals(remoteResult.success,true);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                } 
                if(remoteResult2.success){
                    system.assertEquals(remoteResult2.data!=null,true);
                } 
                if(remoteResult3.success){
                    system.assertEquals(remoteResult3.data!=null,true);
                }          
                 if(remoteResult4.success){
                    system.assertEquals(remoteResult4.data!=null,true);
                }          
          }
        }
    }
    
    @isTest 
    static void getProductPricingTestJde(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
             cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart();
            ccrz__E_CartItem__c cartItemNew = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            
            //Create Contact
            Contact testContact = new Contact();
            testContact.FirstName = 'Test FN';
            testContact.LastName = 'Test LN';
            testContact.Email = 'Testfn@test.com';
            testContact.AccountId = testcart.ccrz__Account__r.Id;
            insert testContact;
            testcart.cc_oo_ShipToAccount__c=cc_lol_TestData.testAccount.id;
            testcart.cc_oo_Seller__c=seller.id;
            testcart.ccrz__Contact__c = testContact.Id;
            testcart.ccrz__Account__c = cc_lol_TestData.testAccount.Id; 
            update testcart;
            
            ccrz.cc_CallContext.currAccountId = testcart.ccrz__Account__r.Id;
            ccrz.cc_CallContext.currContact = testContact;
            ccrz.cc_CallContext.currAccount = cc_lol_TestData.testAccount;
            ccrz.cc_CallContext.currUser.Id = testcart.ccrz__User__r.Id;
            Map<String,String> pageParams = new Map<String, String>();
            pageParams.put('sid', String.valueOf(seller.Id));
            ccrz.cc_CallContext.currPageParameters = pageParams;
            ccrz.cc_CallContext.currAccountGroup = cc_lol_TestData.testAccountGroup;
            List<cc_oo_PriceList__c> priceList = [Select Id,cc_oo_NetListPrice__c from cc_oo_PriceList__c where cc_oo_Seller__c =:seller.id];
            priceList[0].cc_oo_NetListPrice__c =0;
            update priceList;
            
            List<ccrz__E_ProductInventoryItem__c> inventory = [Select Id,cc_oo_IsOnlyPalletProduct__c,ccrz__ProductItem__c from ccrz__E_ProductInventoryItem__c where cc_oo_Seller__c=:seller.id];
            for(ccrz__E_ProductInventoryItem__c item : inventory) {
                item.cc_oo_IsOnlyPalletProduct__c = false;
            }
            update inventory;
            cc_lol_TestData.setupOOSettings();
            cc_lol_TestData.setupOOServiceDataSettings();
            
            Test.startTest();
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            
            List<cc_oo_ContractPrice__c> contract1 = [Select cc_oo_Product__c,cc_oo_Seller__c from cc_oo_ContractPrice__c LIMIT 1];
            contract1[0].cc_oo_Product__c = cc_lol_TestData.products[0].Id;
            contract1[0].cc_oo_Seller__c = seller.Id;
            update contract1;
            
            List<cc_oo_ContractPrice__c> contractParent1 = [Select cc_oo_ShipToNumber__c from cc_oo_ContractPrice__c LIMIT 1];
            contractParent1[0].cc_oo_ShipToNumber__c = testcart.ccrz__Account__r.Id;
            update contractParent1;
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.getProductPricing(ctx, cc_lol_TestData.products[0].Id, seller.id,  testCart.ccrz__EncryptedId__c, cc_lol_TestData.testAccount.AccountNumber,null);
            ccrz.cc_RemoteActionResult remoteResult2 = cc_oo_ProductDetailController.getProductPricing(ctx, cc_lol_TestData.products[0].Id, seller.id,  testCart.ccrz__EncryptedId__c, cc_lol_TestData.testAccount.AccountNumber,null);
            
            for(ccrz__E_ProductInventoryItem__c item : inventory) {
                item.ccrz__ProductItem__c = cc_lol_TestData.products[0].Id;
            }
            update inventory;
            
            priceList[0].cc_oo_NetListPrice__c =0;
            priceList[0].cc_oo_Product__c =cc_lol_TestData.products[0].Id;
            update priceList;
            ccrz.cc_RemoteActionResult remoteResult4 =  cc_oo_ProductDetailController.checkProductPricing(ctx,cc_lol_TestData.products[0].ccrz__SKU__c, seller.id,cc_lol_TestData.testAccount.AccountNumber);
            List<cc_oo_ContractPrice__c> contract = [Select cc_oo_Product__c,cc_oo_Seller__c from cc_oo_ContractPrice__c LIMIT 1];
            contract[0].cc_oo_Product__c = cc_lol_TestData.products[0].Id;
            contract[0].cc_oo_Seller__c = seller.Id;
            update contract;
            
            List<cc_oo_ContractPrice__c> contractParent = [Select cc_oo_ShipToNumber__c from cc_oo_ContractPrice__c LIMIT 1];
            contractParent[0].cc_oo_ShipToNumber__c = testcart.ccrz__Account__r.Id;
            update contractParent;
            delete priceList;
            ccrz.cc_RemoteActionResult remoteResult3 = cc_oo_ProductDetailController.getProductPricing(ctx, cc_lol_TestData.products[0].Id, seller.id,  testCart.ccrz__EncryptedId__c, cc_lol_TestData.testAccount.AccountNumber,null);
            ccrz.cc_RemoteActionResult remoteResult5 = cc_oo_ProductDetailController.getProductPricing(ctx, cc_lol_TestData.products[0].Id, seller.id,  null, cc_lol_TestData.testAccount.AccountNumber,null);
            Test.stopTest();
            System.assert(remoteResult !=NULL);
            System.assert(remoteResult2 !=NULL);
            System.assert(remoteResult3 !=NULL);
            System.assert(remoteResult4 !=NULL);
             System.assert(remoteResult5 !=NULL);
        }
   }
    @isTest
    static void createPriceRecordTest(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz__E_Cart__c testCart;
        
        system.runas(thisUser){
             cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart();
            Account testAccount = cc_lol_TestData.testAccount;
            ccrz__E_CartItem__c cartItemNew = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c limit 1];
            List<ccrz__E_Seller__c> sellers = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            List<cc_oo_PriceList__c> priceList = [Select Id,cc_oo_Seller__c,cc_oo_Product__c,cc_oo_ShipTo__c,cc_oo_EffectiveDate__c,cc_oo_NetListPrice__c,cc_oo_IsJDEPriceUpdated__c from cc_oo_PriceList__c where cc_oo_Seller__c =:sellers[0].id];
            
            Test.startTest();
            String priceDetails = 'ABDN:0012432:250287:100.00:dgfhfh:448ffgh';
            String price = 'ABDN:0012432:250287:100.00:dgfhfh:448ffgh';
            //cc_oo_ProductDetailController.createPriceRecord(sellers[0].id,products[0].id,testAccount.Id,100.00); // calling future method
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.createPriceRecord(ctx, priceDetails);
            Test.stopTest();
            System.assert(remoteResult!=Null);
        }
    }
    @isTest
    static void createPriceRecordTest1(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz__E_Cart__c testCart;
        Test.startTest();
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.createPriceRecord(ctx, null);
        Test.stopTest();
        system.assertEquals(remoteResult==null,false);
    }
    @isTest
    static void createPriceLogTest(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz__E_Cart__c testCart;
        String logs = 'This is a test log';
        system.runas(thisUser){
             cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart();
            List<cc_oo_ErrorLog__c> priceLogs = [select cc_oo_Description__c,cc_oo_ApexClass__c,cc_oo_MethodName__c from cc_oo_ErrorLog__c LIMIT 1];
        }
        Test.startTest();
        final Map<String,String> resHeaders = new Map<String,String>();
        resHeaders.put('Content-Type','application/json');
        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY, resHeaders));
    
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.createPriceLog(ctx, logs);
        Test.stopTest();
        System.assert(remoteResult!=Null);
    }
    @isTest
    static void getJDEPriceTest(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz__E_Cart__c testCart;
        
        system.runas(thisUser){
             cc_lol_TestData.setupCatalog();
             cc_lol_TestData.setupOOSettings();
             cc_lol_TestData.setupOOServiceDataSettings();
             ccrz.cc_CallContext.pageLabels=cc_lol_TestData.pageLabels;
            testCart = cc_lol_TestData.createCart();
        }
        Test.startTest();
        String jdePriceData = '{"@environment" : "JQA7333","@session" : "5476.1491915171.4","@sessionidle" : "1800","@type" : "callmethod","@user" : "FMWOSBQA","callMethod" : {"@app" :"JDEXe","@name" : "PriceRetreivalForCustomer","returnCode" : {"@code" : "0"},"params" : {"AN8_ShipToNUmber" : "502979","MCU_BranchPlant" : "HARR","DCTO_OrderType" : "SO","UPRC_UnitPrice" : "1087.1","LITM_ItemNumber" : "3003484-324","VERS_P4210Version" : "FDOB5701","szFreightHandlingCode" : "F","UOM_Input" : "BG","UOM1_Primary" : "BG","mnAmountExtendedPrice" : "19.02","UOM_Pricing" : "TN"}}}';
        final Map<String,String> resHeaders = new Map<String,String>();
        resHeaders.put('Content-Type','application/json');
        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY2, resHeaders));
    
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.getJDEPrice(ctx, jdePriceData);
        Test.stopTest();
        System.assert(remoteResult!=Null);
    }
    //US - 56 - Test class to test add to cart price validation
    /*@isTest 
    static void getProductStatusTest(){
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
         
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              cc_lol_TestData.setupTestUser();
              System.runAs(cc_lol_TestData.testUser) {
              ccrz__E_Seller__c s = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
              
              String sku2 = 'test001';
              ccrz__E_Product__c products = [select id from ccrz__E_Product__c where ccrz__SKU__c=:sku2];
              List<String> productList = new List<String>();
              productList.add(String.valueOf(products.Id));
              ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__ProductItem__c=products.Id,cc_oo_Seller__c =s.Id,ccrz__Status__c='Available');
              insert prodInvItem;
                                   
              Test.startTest();
      
                ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductDetailController.getStatus(ctx, productList );
            
              Test.stopTest();
                
                //Validate the test data
                system.assertEquals(remoteResult.success,false);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                }          
          }
        }
    }*/
    
    //73
}