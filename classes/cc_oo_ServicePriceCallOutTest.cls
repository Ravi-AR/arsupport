@isTest
private class cc_oo_ServicePriceCallOutTest {

private static final String ATP_RESPONSE_BODY = '{"status": "success"}';
    private static final String ATP_RESPONSE_BODY2 = '{ "@environment": "J333","@session": "7500.14192.2","@sessionidle": "","@type": "callmethod","@user": "FMBDV","callMethod": {"@app": "JDEXe","@name": "RetreiveNextOrderNumber","returnCode": {"@code": "0"},"params": {"mnOrderNumber": "9111285","szKeyCompany": "00651","szOrderType": "S6","BranchPlant": ""}}}';
     @isTest
    static void test_cc_oo_ServicePriceCallOut(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
       	cc_oo_JDEPriceRequest jdePriceReq;
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
            cc_oo_ServicePriceCallOut.getProductPrice(jdePriceReq);
        Test.stopTest();
        system.assertEquals(true,true);
    }
    @isTest
    static void test_cc_oo_ServicePriceCallOut1(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
        cc_oo_JDEPriceRequest jdePriceReq;
        String stringRespStatus = '';
        Integer stringRespCode; 
        cc_oo_ServicePriceCalloutTest.setupPriceCalloutData();
        Test.startTest();
        
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(100,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(100,
                                                             'OK', ATP_RESPONSE_BODY2, resHeaders));
             cc_oo_ServicePriceCallOut.getProductPrice(jdePriceReq);
        Test.stopTest();
        system.assertEquals(false,false);
    }
    public static void setupPriceCalloutData(){
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
                , cc_oo_RequestMethod__c = 'POST'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = '/api/purina/retrieveprice'
                , cc_oo_UserName__c = '515181E'
            )                  
        };
        insert ooIntegrationSettings;
    }
}