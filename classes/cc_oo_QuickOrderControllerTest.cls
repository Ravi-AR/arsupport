//ClassName:cc_oo_QuickOrderControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shivani Singh                              02/18/2017                                     US-1716 Quick Order 
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_QuickOrderControllerTest {
    private static final String ATP_RESPONSE_BODY = '{"@environment":"JDV7333","@session":"7008.1481791831.3","@sessionidle":"","@type":"callmethod","@user":"FMWOSBDV","callMethod":{"-app":"app5","-name":"PriceRetreivalForCustomer","returnCode":{"-code":"0"},"params":{"AN8_ShipToNUmber":"321321","MCU_BranchPlant":"IGH","DCTO_OrderType":"SO","UPRC_UnitPrice":"58.4500","LITM_ItemNumber":"1486010-106","szFreightHandlingCode":"F","UOM_Input":"BG","UOM1_Primary":"BG","mnAmountExtendedPrice":"58.45","UOM_Pricing":"BG"}}}';  
    @isTest 
    static void parseCsvTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        String fileName='temp.csv';
        String strDate='03/18/2017';
                            
       system.runas(thisUser){
              cc_lol_TestData.setupOOSettings();
            cc_lol_TestData.setupCatalog();
            cc_lol_TestData.setupTestUser();
            cc_lol_TestData.setupOOServiceDataSettings();
            testCart = cc_lol_TestData.createCart();
            Account testAccount =  cc_lol_TestData.testAccount;
              testAccount.AccountNumber='250287';
              update testAccount;
                                         ccrz.cc_CallContext.currAccountGroup=cc_lol_TestData.testAccountGroup;
                                         Contact contactCC = new Contact(
                FirstName = 'CloudCrazeUser71',
                LastName  = 'TestUser71',
                Email = 'abcdefghij@xyz1.com',
                AccountId = testAccount.Id,
                MailingStreet = 'abc'
                            );
              insert contactCC;
                                         
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
            
            
            //Test the scenario
            Test.startTest(); 
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,'OK', ATP_RESPONSE_BODY, resHeaders));
            Date shipDate = Date.parse(strDate);
              Date expireLimit = shipDate;
            String csvBlob='PRODUCTNO,QTY'+'\r\n'+'1823,10'+'\r\n'+'3003340-303,10'+'\r\n'+'126556,10'+'\r\n'+'612435,10'+'\r\n'+'72369,10'+'\r\n'+'43166,10'+'\r\n'+'16251652,10'+'\r\n'+'97827,10a';
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);                                                                                                      
            
            csvBlob=null;
            remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);
            
            csvBlob='PRODUCTNUMBER,QTY'+'\r\n'+'1823,10';
            remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);
            
            csvBlob='PRODUCTNO,QTY,NUMBER'+'\r\n'+'1823,10'; 
            remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);
            
            csvBlob='PRODUCTNO,QTY'+'\r\n'+'1823,10'+'\r\n'+'3003340-303,10'+'\r\n'+'126556,10'+'\r\n'+'612435,10'+'\r\n'+'72369,10'+'\r\n'+'43166,10'+'\r\n'+'16251652,10'+'\r\n'+'97827,10a'+'\r\n'+'97827,10a'+'\r\n'+'97827,10a'+'\r\n'+'97827,10a'+'\r\n'+'97827,10a'+'\r\n'+'97827,10a';
            remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);                                                                                                      
            
            csvBlob='PRODUCTNO,QTY,NUMBER'+'\r\n'+'1823,'; 
            remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);
            
            fileName='temp.xls';
            csvBlob='PRODUCTNO,QTY,NUMBER'+'\r\n'+'1823,10'; 
            remoteResult = cc_oo_QuickOrderController.parseCsv(ctx,csvBlob,fileName,seller.id,testAccount.AccountNumber,strDate,testCart.ccrz__EncryptedId__c);
            
            
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            if(remoteResult.success){
            Map<String, object> mapProductData = (Map<String, object>)remoteResult.data;
            system.assertEquals(mapProductData.size()>0,true);
            }
        }
    }
    
    @isTest
    static void getCartDetailsTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        Date strDate=Date.today().addDays(-7);
        String shipDatefinal=strDate.format();
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        ccrz__E_Cart__c testCart1;
        system.runas(thisUser){
        System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Craete Cart');
            Account testAccount =  cc_lol_TestData.testAccount;
              testAccount.AccountNumber='250287';
              update testAccount;
              Contact contactCC = new Contact(
                FirstName = 'CloudCrazeUser82',
                LastName  = 'TestUser82',
                Email = 'abc123@xyz2.com',
                AccountId = testAccount.Id,
                MailingStreet = 'abc'
                            );
              insert contactCC;
            testCart = cc_lol_TestData.createCart();
            testCart1 = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[0].Id,12,200.00);
            
            testCart1.cc_oo_SplitCartType__c = 'Secondary';
            testCart1.cc_oo_SplitCart__c = testCart.Id;
            testCart.cc_oo_SplitCart__c = testCart1.Id;
            
            update testCart;
            update testCart1;
            System.debug(testCart.ccrz__EncryptedId__c+'encrypt cart');
            
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = thisUser.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
            
        
            
       ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
        
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_QuickOrderController.getCartDetails(ctx,testCart.ccrz__EncryptedId__c,seller.id,testAccount.AccountNumber,shipDatefinal);
        System.debug('Cart Items'+ remoteResult.data);
        remoteResult = cc_oo_QuickOrderController.getCartDetails(ctx,null,seller.id,testAccount.AccountNumber,shipDatefinal);
        strDate=Date.today().addDays(+7);
        shipDatefinal=strDate.format();
        remoteResult = cc_oo_QuickOrderController.getCartDetails(ctx,null,seller.id,testAccount.AccountNumber,shipDatefinal);
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
        }
    }
    
    @isTest
    static void getOrderDetailsTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        String shipDString='03/18/2017';
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        List<ccrz__E_Order__c> orders;
        ccrz__E_Order__c newOrder;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            orders = cc_lol_TestData.createOrders(1);
            orders[0].cc_oo_JDEOrderNumber__c = '12345';
            Account testAccount =  cc_lol_TestData.testAccount;
            Contact contactCC = new Contact(
                FirstName = 'CloudCrazeUser93',
                LastName  = 'TestUser93',
                Email = 'abc1@xyz3.com',
                AccountId = cc_lol_TestData.testAccount.id,
                MailingStreet = 'abc'
                            );
              insert contactCC;
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
            testCart = cc_lol_TestData.createCart();
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            
            Map<String,String> pageParams = new Map<String, String>();
            pageParams.put('cartID', String.valueOf(testCart.ccrz__EncryptedId__c));
            pageParams.put('sid', String.valueOf(seller.Id));
            ccrz.cc_CallContext.currPageParameters = pageParams;
          
        
        //Test the scenario
        Test.startTest();            
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_QuickOrderController.getOrderDetails(ctx, orders[0].id,seller.id, testAccount.AccountNumber,  shipDString,  testCart.ccrz__EncryptedId__c);
        remoteResult = cc_oo_QuickOrderController.getOrderDetails(ctx, orders[0].id,seller.id, testAccount.AccountNumber,  '',  testCart.ccrz__EncryptedId__c);
                           remoteResult = cc_oo_QuickOrderController.getOrderDetails(ctx, orders[0].id,seller.id, testAccount.AccountNumber,  '03/18/20176',  testCart.ccrz__EncryptedId__c);
                           
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.data!=null,true);
    }}
    
    @isTest
    static void insertCartItemsTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        System.debug('Fetching User');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        ccrz__E_Cart__c testCart1;
        
        system.runas(thisUser){
            System.debug('Set catalog');
            cc_lol_TestData.setupCatalog();
            System.debug('Create Cart');
            testCart = cc_lol_TestData.createCart();
            testCart1 = cc_lol_TestData.createCart();
            System.debug('Add cart item'); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            cc_lol_TestData.addCartItem(testCart1, cc_lol_TestData.products[0].Id,12,200.00);
            
            testCart1.cc_oo_SplitCartType__c = 'Secondary';
            testCart1.cc_oo_SplitCart__c = testCart.Id;
            testCart.cc_oo_SplitCart__c = testCart1.Id;
            
            update testCart;
            update testCart1;
        
       ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
        // Create Product Details
        cc_oo_ProductPrice prodPrice = new cc_oo_ProductPrice();
        prodPrice.netListPrice = '20';
        prodPrice.palletPrice = '18';
        prodPrice.quantityPerUnit = '1';
        prodPrice.unitOfMeasure = 'BG';
        List<cc_oo_ContractPrice> conList = new List<cc_oo_ContractPrice>();
        cc_oo_ContractPrice conPrice = new cc_oo_ContractPrice();
        conPrice.contractSFId=cc_lol_TestData.contractprice[0].Id;
        conPrice.contractId=cc_lol_TestData.contractprice[0].Id;
        conPrice.contractPrice='20';
        conList.add(conPrice);
        
        cc_oo_Product prod= new cc_oo_Product();
        prod.productId= cc_lol_TestData.products[7].Id;// Assign SFID
        prod.sku='0001823';
        prod.quantity= '20';
        prod.typeOfProduct='BAG';
        prod.palletSize ='20';
        prod.status ='Available';
        prod.availabilityMessage ='';
        prod.errorMessage ='';
        prod.UOMD ='BAG';
        prod.minQuantity ='10';
        //prod.quantityErrorMessage='BG';
        prod.UOM='BG';
        prod.leadTime ='1 Business Day';
        prod.shortDescription ='product007';
        prod.priceOption ='ListPrice';
        //prod.contracts ='BG';
        prod.price = prodPrice;
        prod.contracts=conList;
        Map<string,cc_oo_Product> mapProducts = new Map<string,cc_oo_Product>();
        mapProducts.put('0001823', prod);
        String finalProducts = JSON.serialize(mapProducts);
        Date shipDDate=Date.today().addDays(-7);
        //Create cart details
        cc_oo_cart cart= new cc_oo_cart();
        cart.sku='0001823';
        cart.cartId=testCart.Id;
        cart.storeID = 'PurinaMills';
        cart.product = cc_lol_TestData.products[7].Id;
        cart.seller = seller.Id;
        cart.quantity = '200';
        cart.price = '18';
        cart.unitPrice = '18';
        cart.isListPrice = 'true';
        cart.bagPrice = '10';
        cart.contractId=cc_lol_TestData.contractprice[0].Id;
        cart.palletPrice ='10';
        cart.unitOfMeasure = 'BG';
        cart.productType = 'BAG';
        cart.requestDate = shipDDate.format();
        cart.leadTime = '1';
        Map<string,cc_oo_cart> mapCartItems = new Map<string,cc_oo_cart>();
        mapCartItems.put('p0', cart);
        String mapCartItemsString = JSON.serialize(mapCartItems);
        String shipNewDate=Date.today().format();

        
        Account testAccount =  cc_lol_TestData.testAccount;
        testAccount.AccountNumber='250287';
        update testAccount;
        
        Contact contactCC = new Contact(
                FirstName = 'CloudCrazeUser102',
                LastName  = 'TestUser102',
                Email = 'abc1234@xyz2.com',
                AccountId = cc_lol_TestData.testAccount.id,
                MailingStreet = 'abc'
                            );
              insert contactCC;
            ccrz.cc_CallContext.currAccountId = cc_lol_TestData.testAccount.Id; 
            ccrz.cc_CallContext.currUserId = cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currAccountGroup.Id =cc_lol_TestData.testAccountGroup.Id;
            ccrz.cc_CallContext.currContact=contactCC;
        
        //String finalProducts=JSON.serialize('{"3003340-305":{"availabilityMessage":"The product is available","contracts":[{"contractDetails":{"availableBalance":50,"effectiveDate":"2017-01-19"},"contractId":"A-0013","contractPrice":"10.00","contractQty":100,"contractSFId":"a3YW0000000CqaSMAS","expiryDate":"2020-01-19","jdeEndUser":"aberdeen"}],"errorMessage":"","fullPalletReq":"true","index":"p0","leadTime":"12","minQuantity":"0","palletSize":"10","price":{"netListPrice":"34.00","palletPrice":"30.00","quantityPerUnit":"1.000000","unitOfMeasure":"BG"},"priceOption":"List Price","productId":"a2XW00000001bxTMAQ","quantityErrorMessage":false,"shortDescription":"FLK RAISER CR 40LB","sku":"3003340-305","status":"Available","typeOfProduct":"BAG","UOM":"BG","UOMD":"BAG","quantity":"30"}}');
        //Test the scenario
        Test.startTest(); 
        System.debug('Starting remote');              
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_QuickOrderController.insertCartItems(ctx,mapCartItemsString,'2',finalProducts,testCart.ccrz__EncryptedId__c,seller.id,testAccount.AccountNumber,shipNewDate);
        
        cart.requestDate = Date.today().addDays(+25).format();
        mapCartItems.put('p0', cart);
        mapCartItemsString = JSON.serialize(mapCartItems);
        remoteResult = cc_oo_QuickOrderController.insertCartItems(ctx,mapCartItemsString,'2',finalProducts,testCart.ccrz__EncryptedId__c,seller.id,testAccount.AccountNumber,shipNewDate);
        
        cart.leadTime='abc';
        mapCartItems.put('p0', cart);
        mapCartItemsString = JSON.serialize(mapCartItems);
        remoteResult = cc_oo_QuickOrderController.insertCartItems(ctx,mapCartItemsString,'2',finalProducts,testCart.ccrz__EncryptedId__c,'abc',testAccount.AccountNumber,shipNewDate);
        
        testCart1.cc_oo_SplitCartType__c = null;
        testCart1.cc_oo_SplitCart__c = null;
        remoteResult = cc_oo_QuickOrderController.insertCartItems(ctx,mapCartItemsString,'2',finalProducts,testCart.ccrz__EncryptedId__c,'abc',testAccount.AccountNumber,shipNewDate);
        
        cart.leadTime='abc';
        mapCartItems.put('p0', cart);
        mapCartItemsString = JSON.serialize(mapCartItems);
        remoteResult = cc_oo_QuickOrderController.insertCartItems(ctx,mapCartItemsString,'2',finalProducts,testCart.ccrz__EncryptedId__c,'abc',testAccount.AccountNumber,shipNewDate);
        
        remoteResult = cc_oo_QuickOrderController.insertCartItems(ctx,mapCartItemsString,'2','1',testCart.ccrz__EncryptedId__c,'abc',testAccount.AccountNumber,shipNewDate);
        
        
        Test.stopTest();
        
        //Validate the test data
            system.assertEquals(remoteResult.data!=null,true);
        }
            
    }
    
    
    public class cc_oo_Product{
        public string productId{get; set;}
        public string index{get; set;}
        public string sku{get; set;}
        public string quantity{get; set;}
        public string typeOfProduct{get; set;}
        public string UOM{get; set;}
        public string minQuantity{get; set;}
        public string palletSize{get; set;}
        public string status{get; set;}
        public string availabilityMessage{get; set;}
        public string fullPalletReq{get; set;}
        public string isToteProduct{get; set;}
        public string leadTime{get; set;}
        public string shortDescription{get; set;}
        public string priceOption{get; set;}
        public string listPrice{get; set;}
        public string errorMessage{get; set;}
        public string quantityErrorMessage{get;set;}
        public string UOMD{get;set;}

        public cc_oo_ProductPrice price{get; set;}
        public List<cc_oo_ContractPrice> contracts{get; set;}
    }

    /*
        Bean - cc_oo_ProductPrice
        To hold the product price details data
    **/
    public class cc_oo_ProductPrice{
        public string netListPrice{get; set;}
        public string palletPrice{get; set;}
        public string quantityPerUnit{get; set;}
        public string unitOfMeasure{get; set;}
        //public string palletSize{get; set;}
    }

    /*
        Bean - cc_oo_ContractPrice
        To hold the cotract price details
    **/
    public class cc_oo_ContractPrice {
        public String contractSFId{get; set;}
        public String contractId{get; set;}
        public String contractPrice{get; set;}
        public string expiryDate{get; set;}
        public String jdeEndUser{get; set;}
        public Integer contractQty{get; set;}
        public Boolean disableContract{get; set;}
        public cc_oo_ContractDetail contractDetails{get; set;}
    }
    
    /*
        Bean - cc_oo_ContractPrice
        To hold the cotract price details
    **/
    public class cc_oo_ContractDetail {
        public string effectiveDate{get; set;}
        public String contractUom{get; set;}
        public Integer availableBalance{get; set;}
        public string lastModifiedDate{get; set;}     
    }

    /*
        Bean - cc_oo_cart
        To hold the cart details
    **/
    public class cc_oo_cart{
        public string Id {get;set;}//OO-2244
        public string sku {get; set;}
        public string cartId {get; set;}
        public string storeID {get; set;}
        public string product {get; set;}
        public string bagPrice {get; set;}
        public string palletPrice {get; set;}
        public string seller {get; set;}
        public string quantity {get; set;}
        public string price {get; set;}
        public string unitPrice {get; set;}
        public string isListPrice {get; set;}
        //2752
        public string unitOfMeasure {get; set;}
        public string productType {get; set;}
        public string requestDate {get; set;}
        public string contractId {get; set;}
        public string leadTime {get; set;}
    }
    
    
  }