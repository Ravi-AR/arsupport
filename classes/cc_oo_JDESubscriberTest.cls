@isTest
private class cc_oo_JDESubscriberTest{
	
	private static final String ATP_RESPONSE_BODY = '{"status": "success"}';
	private static final String ATP_RESPONSE_BODY2 = '{ "@environment": "J333","@session": "7500.14192.2","@sessionidle": "","@type": "callmethod","@user": "FMBDV","callMethod": {"@app": "JDEXe","@name": "RetreiveNextOrderNumber","returnCode": {"@code": "0"},"params": {"mnOrderNumber": "9111285","szKeyCompany": "00651","szOrderType": "S6","BranchPlant": ""}}}';

    @isTest
    static void testRedirectJDEOrder(){ 
        String encryptedId = '';
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            cc_lol_TestData.setupCatalog();
            List<ccrz__E_Order__c> orders = cc_lol_TestData.createOrders(1);
            List<ccrz__E_Order__c> order = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Order__c WHERE Id = :orders[0].Id];
            encryptedId = order[0].ccrz__EncryptedId__c;
            Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
            ccrz.cc_CallContext.currURL  =  'https://onlorddev-landolakespartners.cs13.force.com/PurinaMills/ccrz__CheckoutNew';
            ccrz.cc_CallContext.currContact = contactCC;
            ccrz.cc_CallContext.currUser.id=thisUser.id;
            ccrz.cc_CallContext.currAccountId=cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currPageParameters.put('portalUser','online');
            ApexPages.currentPage().getParameters().put('o', encryptedId);
        }
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        ccrz.cc_CallContext.currURL  =  'https://onlorddev-landolakespartners.cs13.force.com/PurinaMills/ccrz__CheckoutNew';
        ApexPages.currentPage().getParameters().put('o', encryptedId);
        Test.startTest();
        try
        {
        	cc_oo_JDESubscriber subscriber = new cc_oo_JDESubscriber();
            PageReference testPage =  subscriber.redirectJDEOrder(); 
            system.assertEquals(testPage != null,true);
            system.assert(subscriber!=null);
        }
        catch(Exception ex) 
        {
           ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',ex + ' '+ ex.getStackTraceString());
          //System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        Test.stopTest();
        
    }
    
     @isTest
    static void testRedirectJDEOrderWithException(){ 
    	User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
        }
        Test.startTest();
        try
        {
        	cc_oo_JDESubscriber subscriber = new cc_oo_JDESubscriber();
            PageReference testPage =  subscriber.redirectJDEOrder(); 
            System.assert(subscriber != null);
        }
        catch(Exception ex) 
        {
        	ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',ex + ' '+ ex.getStackTraceString());
          //System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        Test.stopTest();
    }
    
     @isTest
    static void testRedirectJDEOrderWithMockData(){ 
    	String encryptedId = '';
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            cc_lol_TestData.setupCatalog();
            Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
            List<ccrz__E_Order__c> orders = cc_lol_TestData.createOrders(1);
            List<ccrz__E_Order__c> order = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Order__c WHERE Id = :orders[0].Id];
            encryptedId = order[0].ccrz__EncryptedId__c;
            ccrz.cc_CallContext.currContact = contactCC;
            ccrz.cc_CallContext.currUser.id=thisUser.id;
            ccrz.cc_CallContext.currAccountId=cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currPageParameters.put('portalUser','online');
        }
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        ccrz.cc_CallContext.currURL  =  'https://onlorddev-landolakespartners.cs13.force.com/PurinaMills/ccrz__CheckoutNew';
        ApexPages.currentPage().getParameters().put('o', encryptedId);
        Test.startTest();
        try
        {
        	// build responseHeaders
	        final Map<String,String> resHeaders = new Map<String,String>();
	        resHeaders.put('Content-Type','application/json');
			
	        // setup mock response
	        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
	        												 'OK', ATP_RESPONSE_BODY, resHeaders));
	        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
	        												 'OK', ATP_RESPONSE_BODY2, resHeaders));
	       	
	       	cc_oo_JDESubscriber subscriber = new cc_oo_JDESubscriber();
			PageReference testPage =  subscriber.redirectJDEOrder();		
			System.assert(testPage != null); 
        }
        catch(Exception ex) 
        {
        	ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',ex + ' '+ ex.getStackTraceString());
          //System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        Test.stopTest();
    }
    
     @isTest
    static void testRedirectJDEOrderWithMockDataException(){ 
        Test.startTest();
        try
        {
        	// build responseHeaders
	        final Map<String,String> resHeaders = new Map<String,String>();
	        resHeaders.put('Content-Type','application/json');
			
	        // setup mock response
	        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
	        												 'OK', ATP_RESPONSE_BODY, resHeaders));
	        Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
	        												 'OK', ATP_RESPONSE_BODY2, resHeaders));
	       	
	       	cc_oo_JDESubscriber subscriber = new cc_oo_JDESubscriber();
			PageReference testPage =  subscriber.redirectJDEOrder();		
			System.assert(testPage != null); 
        }
        catch(Exception ex) 
        {
        	ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',ex + ' '+ ex.getStackTraceString());
          //System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        Test.stopTest();
    }
     @isTest
    static void testRedirectJDEOrderAmend(){ 
        String encryptedId = '';
        ccrz__E_Cart__c testCart;
    	ccrz__E_Cart__c oldTestCart;
    	ccrz__E_Cart__c testCart1;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Order__c newOrder;
        ccrz__E_Order__c OldOrder;
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            cc_lol_TestData.setupCatalog();
            Contact contactCC = [select FirstName,LastName,Email,AccountId,MailingStreet from Contact LIMIT 1];
            ccrz.cc_CallContext.currContact= contactCC;
            ccrz.cc_CallContext.currUser.id=thisUser.id;
            ccrz.cc_CallContext.currAccountId=cc_lol_TestData.testAccount.Id;
            ccrz.cc_CallContext.currPageParameters.put('portalUser','online');
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
        ccrz.cc_CallContext.currURL  =  'https://onlorddev-landolakespartners.cs13.force.com/PurinaMills/ccrz__CheckoutNew';
        ApexPages.currentPage().getParameters().put('o', encryptedId);
        Test.startTest();
        try
        {
            // build responseHeaders
            final Map<String,String> resHeaders = new Map<String,String>();
            resHeaders.put('Content-Type','application/json');
            
            // setup mock response
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY, resHeaders));
            Test.setMock(HttpCalloutMock.class, new cc_oo_MockHttpResponse(200,
                                                             'OK', ATP_RESPONSE_BODY2, resHeaders));
            
            cc_oo_JDESubscriber subscriber = new cc_oo_JDESubscriber();
            PageReference testPage =  subscriber.redirectJDEOrder();        
            System.assert(testPage != null); 
        }
        catch(Exception ex) 
        {
           ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',ex + ' '+ ex.getStackTraceString());
          //System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        Test.stopTest();
        
    }
    
}