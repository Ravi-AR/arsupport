@isTest
private without sharing class cc_oo_OrderHookControllerTest {
    
    private static ccrz__E_Order__c testOrder;
    
    @isTest static void test_fetchOrderHistory() {
        
        ccrz.cc_util_Reflection.createStorefrontSetting('PurinaMills');
        ccrz.cc_util_Reflection.updateStorefrontSettings('PurinaMills', 'ccrz__DefaultLanguage__c', 'en_US');
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Seller__c seller;
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            testOrder = cc_lol_TestData.createOrders(1)[0];
            seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1]; 
        }
        Map<String,Object> inputData = new Map<String,Object>();
        Map<String,Object> outputData = new Map<String,Object>();
        inputData.put('ORDERID',testOrder.Id);
        cc_lol_TestData.setupOOSettings();
        Test.startTest();
        Contact testContact = new Contact();
        testContact.FirstName = 'Test FN';
        testContact.LastName = 'Test LN';
        testContact.Email = 'Testfn@test.com';
        insert testContact;
        ccrz.cc_CallContext.currContact = testContact;
        inputData.put('shipFrom', String.valueOf(seller.Id));
        inputData.put('shipTo',cc_lol_TestData.testAccount.Id);
        inputData.put('toDateStr',(Date.Today()-10).format());
        inputData.put('fromDateStr',Date.Today().format());
        inputData.put('searchOrderInput',1);
        inputData.put('searchOrderStatus','Pending');
        cc_oo_OrderHookController ctrl = new cc_oo_OrderHookController();
        outputData=ctrl.fetchOrderHistory(inputData); 
        Map<String,String> pageParams = new Map<String, String>();
        pageParams.put('orderType','Prebook');
        ccrz.cc_CallContext.currPageParameters = pageParams;
        outputData=ctrl.fetchOrderHistory(inputData); 
        Test.stopTest();
        System.assert(outputData!=NULL);
    }
    
    @isTest 
    static void test_updateOrderplaceMethod(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        ccrz__E_Cart__c testCart1;
        ccrz__E_Seller__c seller;        
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            cc_lol_TestData.setupOOSettings();
            testCart = cc_lol_TestData.createCart();
            testCart1 = cc_lol_TestData.createCart();
            testOrder = cc_lol_TestData.createOrders(1)[0];
            seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];  
        }
        Map<String,Object> inputData = new Map<String,Object>();
        Map<String,Object> inputData1 = new Map<String,Object>();
        
        Map<String,Object> outputData = new Map<String,Object>();
        Map<String,Object> outputData1 = new Map<String,Object>();
         Map<String,String> pageParams = new Map<String, String>();
         
         pageParams.put('sid', String.valueOf(seller.Id));
         ccrz.cc_CallContext.currPageParameters = pageParams;
        inputData.put(ccrz.cc_hk_Order.PARAM_ORDER,testOrder);
        inputData.put(ccrz.cc_hk_Order.PARAM_CART_ID,testCart.Id);
        inputData.put(ccrz.cc_hk_order.PARAM_PLACE_STEP,ccrz.cc_hk_Order.STEP_CREATE_ORDER_POST);
        inputData1.put(ccrz.cc_hk_order.PARAM_PLACE_STEP,ccrz.cc_hk_Order.STEP_END);        
        inputData1.put(ccrz.cc_hk_Order.PARAM_ORDER,testOrder);
        inputData1.put(ccrz.cc_hk_Order.PARAM_CART_ID,testCart.Id); 
        Test.startTest();
        cc_oo_OrderHookController ctrl = new cc_oo_OrderHookController();
        outputData=ctrl.place(inputData); 
        outputData1=ctrl.place(inputData1); 
        inputData1.put(ccrz.cc_hk_Order.PARAM_CART_ID,null);
        testCart.cc_oo_SplitCartType__c='Secondary';
        testCart.cc_oo_SplitCart__c = testCart1.Id;
        update testCart;
        pageParams.put('orderType','Prebook');
        ccrz.cc_CallContext.currPageParameters = pageParams;
        inputData1.put(ccrz.cc_hk_Order.PARAM_CART_ID,testCart1.id);
        outputData1=ctrl.place(inputData1); 
        Test.stopTest();
        System.assert(outputData!=NULL);
        System.assert(outputData1!=NULL);
        
        
        
    }
    
    @isTest 
    static void test_placeTargetMethod(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            testOrder = cc_lol_TestData.createOrders(1)[0];
        }
        Map<String,Object> inputData = new Map<String,Object>();
        Map<String,Object> outputData = new Map<String,Object>();
        inputData.put(ccrz.cc_hk_order.PARAM_PLACE_STEP,ccrz.cc_hk_Order.STEP_CREATE_ORDER_POST);
        inputData.put(ccrz.cc_hk_Order.PARAM_ORDER,testOrder);
        ccrz.cc_CallContext.currURL='https://prebookqa-landolakespartners.cs62.force.com/PurinaMills/ccrz__MyAccount?viewState=myOrders&cclcl=en_US&orderType={}&promotionCode={}&sid=a2s5C000000KyrFQAS&isSameShipto=false&cartID=0b9a66ad-2809-4945-8be4-9f630e8f47b7';
        
        
        Test.startTest();
        cc_oo_OrderHookController ctrl = new cc_oo_OrderHookController();
        outputData=ctrl.placeTarget(inputData); 
        
        Test.stopTest();
        System.assert(outputData!=NULL);
        
        
    }
    
    /*@isTest static void test_sendAckEmailplaceMethod(){
        /*User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            testOrder = cc_lol_TestData.createOrders(1)[0];
        }
        Map<String,Object> inputData = new Map<String,Object>();
        inputData.put(ccrz.cc_hk_order.PARAM_PLACE_STEP,ccrz.cc_hk_Order.STEP_CREATE_ORDER_CHILD_ITEMS_POST);
        inputData.put(ccrz.cc_hk_Order.PARAM_ORDER,testOrder);
        Test.startTest();
        cc_oo_OrderHookController ctrl = new cc_oo_OrderHookController();
        ctrl.place(inputData); 
        Test.stopTest();
        
    }*/
}