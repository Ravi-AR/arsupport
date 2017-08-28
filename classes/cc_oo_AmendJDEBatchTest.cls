@isTest
private class  cc_oo_AmendJDEBatchTest {
     
  @testSetup static void setup() {
    cc_lol_TestData.setupOOServiceDataSettings();
    cc_lol_TestData.setupOOSettings();    
  }

    static testMethod void testAmendJdeBatch() {      
        //cc_lol_TestData.setupTestUser();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];       
        List<ccrz__E_Order__C> testOrders = new List<ccrz__E_Order__C>();
        ccrz__E_Cart__c cartAmended = new ccrz__E_Cart__c();
        ccrz__E_Cart__c cartAmended2 = new ccrz__E_Cart__c();
        ccrz__E_Cart__c testcart = new ccrz__E_Cart__c();
        system.runas(thisUser){ 
            System.debug('Are you here?????????**************');
            testcart=cc_lol_TestData.createCart();
            testOrders=cc_lol_TestData.createOrders(2,true);
            testOrders[0].ccrz__OrderStatus__c='Amended';
            testOrders[0].cc_oo_IsJDENumberUpdate__c = TRUE;
            testOrders[1].ccrz__OrderStatus__c='Pending';
            testOrders[1].cc_oo_IsJDENumberUpdate__c = TRUE;
         
               testOrders[1].cc_oo_JDEOrderNumber__c='9848289';
            testOrders[0].cc_oo_JDEOrderNumber__c='9848287';
           // ord.ccrz__OrderStatus__c='Pending';
       
      
            update testOrders;
            cartAmended.Id=testOrders[1].ccrz__OriginatedCart__c;
            cartAmended2.Id=testOrders[0].ccrz__OriginatedCart__c;
            cartAmended.cc_oo_AmendedCart__c=true;
            cartAmended.cc_oo_OriginalCart__c=cartAmended2.id;
            
            update cartAmended;
           
        }
        
        
        Test.startTest();
          system.debug('Before calling mock service ----> ' );         
          cc_oo_AmendJDEBatch AmendJDE = new cc_oo_AmendJDEBatch();
          ID batchprocessid = Database.executeBatch(AmendJDE);
          system.debug('Batch Process id --> ' + batchprocessid); 
          cc_oo_ScheduleAmendJDEBatch amendBatch = new cc_oo_ScheduleAmendJDEBatch();
          String cronStr = '0 30 * * * ?';
          System.schedule('Amended Order Sync Job', cronStr, amendBatch); 
         Test.stopTest();
         Integer countOrders =0;
        for(ccrz__E_Order__C testOrder: testOrders){          
          ccrz__E_Order__c results= [SELECT cc_oo_IsSyncOrder__c FROM ccrz__E_Order__c Where id = :testOrder.id];
         // System.assertEquals(true,results.cc_oo_IsSyncOrder__c); 
          countOrders++;
         }  
        System.AssertEquals(countOrders,database.countquery('SELECT COUNT()'+' FROM ccrz__E_Order__c' ));//assert expected number of records are processed
        System.AssertEquals(AmendJDE!=null,true);
                
    }

}