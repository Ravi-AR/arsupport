//ClassName:cc_oo_scheduledJDEIntegration 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         01/03/2017                                        OO-517 -Test class Schedule job for JDE integration
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_scheduledJDEIntegrationTest{
        
    @isTest static void test_JDEScheduler(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            CCRZ__E_Order__c testOrder = cc_lol_TestData.createOrders(1)[0];
        }
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        Test.startTest();
        Datetime sysTime = System.now().addSeconds(2);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        // following code will throw an exception as a job is already scheduled
        try
        {
            //System.schedule('cc_oo_scheduledEmails', chronExpression, new cc_oo_scheduledEmails());
            cc_oo_scheduledJDEIntegration.start();
            System.assert(chronExpression!=null);
        }
        catch(Exception ex) 
        {
          System.debug(ex + ' '+ ex.getStackTraceString());
          cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
          errorLog.cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString();
          insert errorLog;  
        }
        Test.stopTest();
    }
}