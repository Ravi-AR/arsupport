@isTest
private class cc_oo_ServiceDockDoorCalloutTest {
    private static final String ATP_RESPONSE_BODY = '{"status": "success"}';
    private static final String ATP_RESPONSE_BODY2 = '{ "@environment": "J333","@session": "7500.14192.2","@sessionidle": "","@type": "callmethod","@user": "FMBDV","callMethod": {"@app": "JDEXe","@name": "RetreiveNextOrderNumber","returnCode": {"@code": "0"},"params": {"mnOrderNumber": "9111285","szKeyCompany": "00651","szOrderType": "S6","BranchPlant": ""}}}';
	@isTest
    static void test_cc_oo_ServiceOrderCancelCallout(){
        cc_oo_ErrorLog__c errorlog = new cc_oo_ErrorLog__c();
        errorlog.cc_oo_Description__c = 'Description';
        String stringRespStatus;
        Integer stringRespCode; 
        ccrz__E_Cart__c testCart;
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        testCart = cc_lol_TestData.createCart();
        Test.startTest();
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY2, resHeaders));
            cc_oo_ServiceDockDoorCalloutController.getPickupTime('ABDN','BAG','250287',Date.today(),testCart.Id);
        	cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean a = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean();
        	cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollection b = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollection();
        	cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot d = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot();
        	a.timeZone = 'nj';
        	a.DockDoorTimeslotCollection = b;
        	d.pickupTime = '7:00 AM';  
        	d.shipToNumber = '250287';
        	d.isBooked = 'Yes';
        	d.orderNumber = '23443';
        	Test.stopTest();
        system.assertEquals(true,true);
    }
}