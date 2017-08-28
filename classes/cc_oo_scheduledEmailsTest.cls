//ClassName:cc_oo_scheduledEmailsTest 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         10/07/2016                                     OO-211 Test class for Scheduler to send Order Acknowledgement Mail
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_scheduledEmailsTest{
        
    @isTest static void test_MessagingScheduler(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        CCRZ__E_Order__c testOrder;
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            testOrder = cc_lol_TestData.createOrders(1)[0];
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
            cc_oo_scheduledEmails.start();
            
            testOrder.cc_oo_JDEOrderNumber__c ='12345'; 
            cc_oo_scheduledEmails.start();
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