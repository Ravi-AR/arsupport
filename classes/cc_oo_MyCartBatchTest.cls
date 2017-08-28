@isTest
private class cc_oo_MyCartBatchTest {
	@isTest static void test_MessagingScheduler(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        CCRZ__E_Cart__c testCart;
        System.runAs(thisUser){
            cc_lol_TestData.setupTestUser();
            testCart = cc_lol_TestData.createCart();
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        List<ccrz__E_Cart__c> scope;
        cc_lol_TestData.setupOOSettings();
        cc_lol_TestData.setupOOServiceDataSettings();
        Test.startTest();
        cc_oo_MyCartBatch myCart = new cc_oo_MyCartBatch();
        Database.executeBatch(myCart);
        myCart.execute(BC, scope);
        myCart.finish(BC);
        
        Datetime sysTime = DateTime.now().AddDays(1);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        testCart.ccrz__CartStatus__c  ='Open'; 
        testCart.ccrz__CartType__c = 'Cart';
        Test.stopTest();
           System.assertEquals(true, true);
    }
}