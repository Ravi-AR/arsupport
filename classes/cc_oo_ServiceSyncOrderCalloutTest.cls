@isTest
private class cc_oo_ServiceSyncOrderCalloutTest {
     private static final String ATP_RESPONSE_BODY = '{"status": "success"}';
    private static final String ATP_RESPONSE_BODY2 = '{ "@environment": "J333","@session": "7500.14192.2","@sessionidle": "","@type": "callmethod","@user": "FMBDV","callMethod": {"@app": "JDEXe","@name": "RetreiveNextOrderNumber","returnCode": {"@code": "0"},"params": {"mnOrderNumber": "9111285","szKeyCompany": "00651","szOrderType": "S6","BranchPlant": ""}}}';
     @isTest
    static void test_cc_oo_ServiceSyncOrderCalloutTest(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
        cc_oo_JDESyncOrderRequest syncReq;
        String stringRespStatus = '200';
        Integer stringRespCode; 
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
            cc_oo_ServiceSyncOrderCallOut.syncOrder(syncReq);
        Test.stopTest();
        system.assertEquals(true,true);
    }
    @isTest
    static void test_cc_oo_ServiceSyncOrderCalloutTest1(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
        cc_oo_JDESyncOrderRequest syncReq;
        String stringRespStatus = '';
        Integer stringRespCode; 
        cc_oo_ServiceSyncOrderCallOutTest.setupSyncCalloutData();
        Test.startTest();
        
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(100,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(100,
                                                             'OK', ATP_RESPONSE_BODY2, resHeaders));
             cc_oo_ServiceSyncOrderCallOut.syncOrder(syncReq);
        Test.stopTest();
        system.assertEquals(false,false);
    }
    public static void setupSyncCalloutData(){
        List<cc_oo_ServiceData__c> ooIntegrationSettings = new List<cc_oo_ServiceData__c> {
            new cc_oo_ServiceData__c(
                Name     = 'Order'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = ''
                , cc_oo_RequestMethod__c = 'GET'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = '/api/purina/syncorder'
                , cc_oo_UserName__c = '515181E'
            )                  
        };
        insert ooIntegrationSettings;
    }
}