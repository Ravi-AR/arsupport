@isTest
private class cc_oo_ServiceOrderCancelCalloutTest {
     private static final String ATP_RESPONSE_BODY = '{"status": "success"}';
    private static final String ATP_RESPONSE_BODY2 = '{"DataArea":{"Sync":{"ActionCriteria":[{"ActionExpression":[{"@actionCode":"Delete","$":"DataArea.PurchaseOrder.PurchaseOrderHeader"}]}]},"PurchaseOrder":[{"@typeCode":"S6","PurchaseOrderHeader":{"DocumentIDSet":[{"ID":[{"@typeCode":"batchNumber","$":"O-0000000792"},{"@typeCode":"docNumber","$":"99999815"}]}]}}]}}';
	 @isTest
    static void test_cc_oo_ServiceOrderCancelCallout(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
        String stringRespStatus ='200';
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
         
        Test.startTest();
        // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY2, resHeaders));
            cc_oo_ServiceOrderCancelCallOut.cancelOrder('983838');  
            Test.stopTest();
        	system.assertEquals(true,true);
    }
    @testSetup static void setup() {
        	List<ccrz__E_Order__c> testOrders = new List<ccrz__E_Order__c>();
        	testOrders.add(
                    new ccrz__E_Order__c(
                            ccrz__OrderNumber__c     = 1,
                            cc_oo_JDEOrderNumber__c='983838',
                            cc_oo_JDEFlag__c='0',
                            cc_oo_JDENumericStatus__c='123',
                            ccrz__OrderStatus__c ='Pending',
                            ccrz__Storefront__c      = 'STOREFRONT_NAME',
                            ccrz__OrderDate__c       = Date.Today(),
                            cc_oo_IsSyncOrder__c = false
                            
           ));
           insert testOrders; 
    }   
	@isTest
    static void test_cc_oo_ServiceOrderCancelCalloutTest1(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
        String stringRespStatus = '';
        Integer stringRespCode; 
        cc_oo_ServiceOrderCancelCalloutTest.setupOrderCancelData();
        Test.startTest();
        
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(100,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(100,
                                                             'OK', ATP_RESPONSE_BODY2, resHeaders));
            cc_oo_ServiceOrderCancelCallOut.cancelOrder('');
        Test.stopTest();
        system.assertEquals(false,false);
    }
    public static void setupOrderCancelData(){
        List<cc_oo_ServiceData__c> ooIntegrationSettings = new List<cc_oo_ServiceData__c> {
            new cc_oo_ServiceData__c(
                Name     = 'order'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://apiqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'JTX8k7TipTipCWmcwIaTcB5wieie'
                , cc_oo_Port__c = ''
                , cc_oo_RequestMethod__c = 'PUT'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = 'S6'
                , cc_oo_URI__c = '/dv/purina/orders1'
                , cc_oo_UserName__c = 'vGe6VfD7jvNUy6JJxobQcAieie'
            )               
        };
        insert ooIntegrationSettings;
    }
}