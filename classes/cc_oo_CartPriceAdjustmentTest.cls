//ClassName:cc_oo_CartPriceAdjustmentTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                           12/01/2016                                     Test class for cc_oo_CartPriceAdjustment
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_CartPriceAdjustmentTest {
    private static ccrz__E_Cart__c testCart;
    private static ccrz__E_Cart__c isShipdateexttestCart;
    private static ccrz__E_Cart__c oldTestCart;
     private static ccrz__E_Cart__c EmptytestCart;
    private static ccrz.cc_bean_CartSummary cartSummary;
    private static ccrz.cc_bean_CartSummary cartSummary2;
    private static ccrz.cc_bean_CartSummary isExtendedCartSummary;
    private static CC_OO_PlantHolidayCalendar__c holidaycalender;
    private static final String ATP_RESPONSE_BODY = '{"@environment" : "JQA7333","@session" : "5476.1491915171.4","@sessionidle" : "1800","@type" : "callmethod","@user" : "FMWOSBQA","callMethod" : {"@app" : "JDEXe","@name" : "PriceRetreivalForCustomer","returnCode" : {"@code" : "0"},"params" : {"AN8_ShipToNUmber" : "502979","MCU_BranchPlant" : "HARR","DCTO_OrderType" : "SO","UPRC_UnitPrice" : "1087.1","LITM_ItemNumber" : "3003484-324","VERS_P4210Version" : "FDOB5701","szFreightHandlingCode" : "F","UOM_Input" : "BG","UOM1_Primary" : "BG","mnAmountExtendedPrice" : "19.02","UOM_Pricing" : "TN"}}}';
    /**
     *
     * description
     *
     * @result the key result
     */
    @isTest static void setupTestData() {
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            cc_lol_TestData.setupOOSettings();
            ccrz.cc_CallContext.pageLabels=cc_lol_TestData.pageLabels;
             final Map<String,String> resHeaders = new Map<String,String>();
            holidaycalender=cc_lol_TestData.holidayCalendar[0];
            resHeaders.put('Content-Type','application/json');
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
        cc_lol_TestData.setupOOServiceDataSettings(); 
            testCart = cc_lol_TestData.createCart();
            oldTestCart=cc_lol_TestData.createCart();
            
            ccrz__E_Product__c prd=cc_lol_TestData.products[0];
            ccrz__E_Product__c prd1=cc_lol_TestData.products[8];
            prd.cc_oo_TypeOfProduct__c='BULK';
            update prd;
            ccrz__E_CartItem__c cartItemNew = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            ccrz__E_CartItem__c cartItemJdePrice = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[2].Id,12,200.00);
        	ccrz__E_CartItem__c cartItemNew1=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[7].Id,30,2000.00);
            ccrz__E_CartItem__c cartItemNew2=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,8,200.00);
            ccrz__E_CartItem__c cartItemNew3=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,8,200.00);
            ccrz__E_CartItem__c cartItemNew4=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,8,300.00);
        	ccrz__E_CartItem__c cartItemOld = cc_lol_TestData.addCartItem(oldTestCart, cc_lol_TestData.products[1].Id,10,100.00);
        	ccrz__E_CartItem__c cartItemOld1=cc_lol_TestData.addCartItem(oldTestCart, cc_lol_TestData.products[7].Id,30,2000.00);
            ccrz__E_CartItem__c cartItemOld2=cc_lol_TestData.addCartItem(oldTestCart, cc_lol_TestData.products[0].Id,8,200.00);
            ccrz__E_CartItem__c cartItemOld3=cc_lol_TestData.addCartItem(oldTestCart, cc_lol_TestData.products[1].Id,8,200.00);
            ccrz__E_CartItem__c cartItemOld4=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,8,200.00);
            ccrz__E_CartItem__c cartItemOld5=cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,8,300.00);
            //Date expirationDate = Date.newInstance(2016, 6, 6);
            cartItemOld.cc_oo_IsListPrice__c=true;
            cartItemOld1.cc_oo_IsListPrice__c=true;
            cartItemJdePrice.cc_oo_IsListPrice__c=true;
            cartItemOld2.cc_oo_IsListPrice__c=true;
            cartItemOld3.cc_oo_IsListPrice__c=true;
            cartItemOld4.cc_oo_IsListPrice__c=false;
            cartItemOld5.cc_oo_IsListPrice__c=true;
            update cartItemOld;
            update cartItemOld1;
            update cartItemOld2;
            update cartItemOld3;
            update cartItemOld4;
            update cartItemOld5;
            update cartItemJdePrice;
            cartItemNew.cc_oo_IsListPrice__c=true;
            cartItemNew1.cc_oo_IsListPrice__c=false;
            cartItemNew1.cc_oo_ContractPrice__c=null;
            cartItemNew2.cc_oo_IsListPrice__c=true;
            cartItemNew3.cc_oo_IsListPrice__c=false;
            cartItemNew4.cc_oo_IsListPrice__c=true;
            update cartItemNew;
            update cartItemNew1;
            update cartItemNew2;
            update cartItemNew3;
            update cartItemNew4;
            cartSummary = new ccrz.cc_bean_CartSummary(testCart);
            
            List<ccrz.cc_bean_CartItem> cartItems = new List<ccrz.cc_bean_CartItem>();
            
            ccrz.cc_bean_CartItem cartItem = new ccrz.cc_bean_CartItem();
            cartItem.itemID = cartItemNew.Id;       
            cartItem.ItemStatus = 'Valid';
            cartItem.quantity = 20;
            
            cartItem.mockProduct=new ccrz.cc_bean_MockProduct();
            cartItem.mockProduct.id=cc_lol_TestData.products[0].Id;
            cartItem.mockProduct.sku = cc_lol_TestData.products[0].ccrz__SKU__c;
            
            ccrz.cc_bean_CartItem cartItem1 = new ccrz.cc_bean_CartItem();
            cartItem1.itemID = cartItemNew1.Id; 
            cartItem1.ItemStatus = 'Valid';
            cartItem1.quantity = 22;
            
            cartItem1.mockProduct=new ccrz.cc_bean_MockProduct();
            cartItem1.mockProduct.id=cc_lol_TestData.products[7].Id;
            cartItem1.mockProduct.sku = cc_lol_TestData.products[7].ccrz__SKU__c;
            
            ccrz.cc_bean_CartItem cartItem2 = new ccrz.cc_bean_CartItem();
            cartItem2.itemID = cartItemNew2.Id; 
            cartItem2.ItemStatus = 'Valid';
            cartItem2.quantity = 10;
            
            cartItem2.mockProduct=new ccrz.cc_bean_MockProduct();
            cartItem2.mockProduct.id=cc_lol_TestData.products[0].Id;
            cartItem2.mockProduct.sku = cc_lol_TestData.products[0].ccrz__SKU__c;
            
            ccrz.cc_bean_CartItem cartItem3 = new ccrz.cc_bean_CartItem();
            cartItem3.itemID = cartItemNew3.Id; 
            cartItem3.ItemStatus = 'Valid';
            cartItem3.quantity = 20;
            
            cartItem3.mockProduct=new ccrz.cc_bean_MockProduct();
            cartItem3.mockProduct.id=cc_lol_TestData.products[8].Id;
            cartItem3.mockProduct.sku = cc_lol_TestData.products[8].ccrz__SKU__c;
            
            cartItems.add(cartItem);
            cartItems.add(cartItem1);
            cartItems.add(cartItem2);
            cartItems.add(cartItem3);
            cartSummary.cartItems = cartItems; 
            
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
            
            Test.startTest();
            System.debug('\n\nTestCart --> ' +testCart.ccrz__EncryptedId__c);
            
            cc_oo_CartPriceAdjustment cartPriceAdjustment = new cc_oo_CartPriceAdjustment();
            
            Map<String, Object> inputData = new Map<String, Object>();
            inputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN, cartSummary);
            Map<String, Object> result = cartPriceAdjustment.computePricingCart(inputData);
            
            cc_oo_CartPriceAdjustment cartPriceAdjustment1 = new cc_oo_CartPriceAdjustment();
            cartItem.quantity = 11;
            Map<String, Object> result2 = cartPriceAdjustment1.computePricingCart(inputData);
            
            cc_oo_CartPriceAdjustment cartPriceAdjustment2 = new cc_oo_CartPriceAdjustment();
            cartItem.quantity = 9;
            Map<String, Object> result3 = cartPriceAdjustment2.computePricingCart(inputData);
            
            cartItemNew = cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[1].Id,12,200.00);
            cartItem.itemID = cartItemNew.Id;       
            cartItem.ItemStatus = 'Valid';
            cartItem.quantity = 2;
            
            cartItem.mockProduct=new ccrz.cc_bean_MockProduct();
            cartItem.mockProduct.id=cc_lol_TestData.products[1].Id;
            cartItem.mockProduct.sku = cc_lol_TestData.products[1].ccrz__SKU__c;
            
            cartItems.add(cartItem);
            cartSummary.cartItems = cartItems;
            Map<String, Object> result4 = cartPriceAdjustment2.computePricingCart(inputData); 
            
            testCart.cc_oo_OriginalCart__c=oldTestCart.id;
            testCart.cc_oo_SplitCartType__c='Primary';
            testCart.cc_oo_AmendedCart__c=true;
            update testcart;
            cartItemNew.cc_oo_IsListPrice__c=true;
            cartItemNew1.cc_oo_IsListPrice__c=true;
            cartItemNew.cc_oo_OriginalCartItem__c=cartItemOld.id;
            cartItemNew1.cc_oo_OriginalCartItem__c=cartItemOld1.id;
            update cartItemNew;
            update cartItemNew1;
            cartSummary2 = new ccrz.cc_bean_CartSummary(testCart);
            Map<String, Object> inputData2 = new Map<String, Object>();
            inputData2.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN, cartSummary2);
            Map<String, Object> Amendresult = cartPriceAdjustment.computePricingCart(inputData2);
            
            EmptytestCart = cc_lol_TestData.createCart();
            isShipdateExtTestCart= cc_lol_TestData.createCart();
            ccrz__E_CartItem__c cartItemNewtest = cc_lol_TestData.addCartItem(isShipdateExtTestCart, cc_lol_TestData.products[1].Id,12,200.00);
			update cartItemNewtest;
            
            EmptytestCart.cc_oo_ShipToAccount__c=cc_lol_TestData.testAccount.id;
			EmptytestCart.cc_oo_Seller__c=seller.id;
            isShipdateExtTestCart.cc_oo_Seller__c=seller.id;
			EmptytestCart.ccrz__Contact__c = testContact.Id;
			EmptytestCart.ccrz__Account__c = cc_lol_TestData.testAccount.Id; 
            isShipdateExtTestCart.cc_oo_SplitCartType__c='Secondary';
            isShipdateExtTestCart.ccrz__CartStatus__c = 'Open';
            isShipdateExtTestCart.cc_oo_AmendedCart__c=false;
			EmptytestCart.cc_oo_SplitCart__c=isShipdateExtTestCart.Id;
            isShipdateExtTestCart.cc_oo_SplitCart__c=EmptytestCart.Id;
            EmptytestCart.ccrz__ShipMethod__c='Delivery - 1';
			isShipdateExtTestCart.ccrz__RequestDate__c=Date.Today()+10;
            isShipdateExtTestCart.ccrz__ActiveCart__c=false;
			update isShipdateExtTestCart;
			update EmptytestCart;
			ccrz.cc_CallContext.currAccountId = testcart.ccrz__Account__r.Id;
			ccrz.cc_CallContext.currUser.Id = testcart.ccrz__User__r.Id;
		    Map<String, Object> IsShipdateExtendedinputData = new Map<String, Object>();
            isExtendedCartSummary = new ccrz.cc_bean_CartSummary(EmptytestCart);
            ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__Status__c='Available',ccrz__ProductItem__c=cc_lol_TestData.products[1].Id,ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_LeadTime__c='13 Days',cc_oo_Seller__c=seller.id);
            insert prodInvItem;
            
			IsShipdateExtendedinputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN, isExtendedCartSummary);
            
			//ccrz__E_Cart__c testcar=[select ];
          
			Map<String, Object> IsShipdateExtendedresult = cartPriceAdjustment.computePricingCart(IsShipdateExtendedinputData);
                                
            Test.stopTest();
            System.assert(result !=NULL);
        }
    }
}