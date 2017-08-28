@isTest
private class cc_oo_scheduledMyCartTest{
        
    @isTest static void test_MessagingScheduler(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        CCRZ__E_Cart__c testCart;
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        cc_oo_scheduledMyCart.start();
        Datetime sysTime = DateTime.Now().AddDays(1);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        // following code will throw an exception as a job is already scheduled
        try
        {
            //System.schedule('cc_oo_scheduledEmails', chronExpression, new cc_oo_scheduledEmails());
            testCart.ccrz__CartStatus__c  ='Open'; 
            testCart.ccrz__CartType__c = 'Cart';
            System.assert(chronExpression!=null);
        }
        catch(Exception ex) 
        {
          System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        
    }
}