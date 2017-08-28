@isTest
private class cc_oo_SyncJDEBatchTest {
                           
              @testSetup static void setup() {
                            cc_lol_TestData.setupOOServiceDataSettings();
                           cc_lol_TestData.setupOOSettings();                       
              }

    static testMethod void testSyncJdeBatch() {      
        //cc_lol_TestData.setupTestUser();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];       
        List<ccrz__E_Order__C> testOrders = new List<ccrz__E_Order__C>();
         List<ccrz__E_Order__C> testOrders1 = new List<ccrz__E_Order__C>();
        
        system.runas(thisUser){ 
                      //cc_lol_TestData.setupCatalog();                  
                                //cc_lol_TestData.setupOOServiceDataSettings();
                            //create orders
                                 testOrders=cc_lol_TestData.createOrders(2,true);
            testOrders1=cc_lol_TestData.createOrders(2,true);
            
        }
         system.debug('**********Following Order is created from create Order call ****************');
       for(ccrz__E_Order__c ord :testOrders1){
              
            ord.cc_oo_JDEOrderNumber__c='9848287';
            ord.ccrz__OrderStatus__c='Pending';
              //validate that order created is not synced to JDE
              
        }
       update testOrders1;
        
        Test.startTest();
                      system.debug('Before calling mock service ----> ' );                
                      cc_oo_SyncJDEBatch syncJDE = new cc_oo_SyncJDEBatch();
                      ID batchprocessid = Database.executeBatch(syncJDE);
                      system.debug('Batch Process id --> ' + batchprocessid); 
            cc_oo_ScheduleSyncJDEBatch syncBatch = new cc_oo_ScheduleSyncJDEBatch();
            String cronStr = '0 30 * * * ?';
            System.schedule('Sync Order Sync Job', cronStr, syncBatch); 
        Test.stopTest();
        //Integer countOrders =0;
        for(ccrz__E_Order__C testOrder: testOrders){            
              ccrz__E_Order__c results= [SELECT cc_oo_IsSyncOrder__c FROM ccrz__E_Order__c Where id = :testOrder.id];
                      System.assertEquals(true,results.cc_oo_IsSyncOrder__c); 
              //countOrders++;
              }  
       // System.AssertEquals(countOrders,database.countquery('SELECT COUNT()'+' FROM ccrz__E_Order__c' ));//assert expected number of records are processed
                     
    }
    
    static testMethod void testBatchHelper(){ 
        String jdeResponseBody1 = '{"response":{"status": "success","StatusCode":"200"}}';
        String jdeResponseBody2 =  '{"@environment": "J333","@session": "7500.14192.2",'+
                                                                                                '"@sessionidle": "",'+
                                                                                                '"@type": "callmethod",'+
                                                                                                '"@user": "FMBDV",'+
                                                                                                '"callMethod": {"@app": "JDEXe",'+
                                                                                                                                                       '"@name": "RetreiveNextOrderNumber",'+
                                                                                                                                                       '"returnCode": {"@code": "0"},'+
                                                                                                                                                       '"params": {"mnOrderNumber": "9111285",'+
                                                                                                                                                                                                '"szKeyCompany": "00651",'+
                                                                                                                                                                                                '"szOrderType": "S6",'+
                                                                                                                                                                                                '"BranchPlant": ""}}';
        String jdeResponseBody3 = '{"response":{"status": "success","StatusCode":"200"}}';
        Map<String,String> resHeaders = new Map<String,String>();
               
        //cc_lol_TestData.setupTestUser();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('check LOL Settings ---->'+ LOLSettings__c.getValues('JDEAmendOdrerExpHeader').Value__c);
        List<ccrz__E_Order__C> testOrders = new List<ccrz__E_Order__C>();
        system.runas(thisUser){               
                      //Go with assumption that setupCatalog prepares all necessary data
                      //cc_lol_TestData.setupCatalog();                  
                                //cc_lol_TestData.setupOOServiceDataSettings();
                            //create orders
                            testOrders = cc_lol_TestData.createOrders(2,true);
        }
        system.debug('**********From test Batch Helper ****************');
        for(ccrz__E_Order__c ord :testOrders){
              system.debug('Order Id------>' + ord.id);
              system.debug('Order JdeNumber---->' + ord.cc_oo_JDEOrderNumber__c);
              system.debug('Order Sync to JDE Flag ---->' + ord.cc_oo_IsSyncOrder__c);
              //validate that order created is not synced to JDE
                      system.assertEquals(ord.cc_oo_IsSyncOrder__c,false);
        } 
        //Before we start testing batch job let's create response for our mock objects
        //create fakeResponse for next
      
                           resHeaders.put('Content-Type','application/json'); 
                           cc_oo_MockHttpResponse nextNumber = new cc_oo_MockHttpResponse(200,'success', jdeResponseBody2, resHeaders);
                           cc_oo_MockHttpResponse syncOrder = new cc_oo_MockHttpResponse(200,'success', jdeResponseBody1, resHeaders); 
        cc_oo_MockHttpResponse orderCancel = new cc_oo_MockHttpResponse(200,'success', jdeResponseBody3, resHeaders); 
                           Map<String, HttpCalloutMock> endpoint2TestResp =  new Map<String,HttpCalloutMock>(); 
                            endpoint2TestResp.put('https://wsqa.landolakesinc.com:443/api/RetrieveOrder',nextNumber);
                            endpoint2TestResp.put('https://wsqa.landolakesinc.com:443/api/purina/syncorder',syncOrder);
        endpoint2TestResp.put('https://wsqa.landolakesinc.com/purina/orders/983838',orderCancel);//not sure why this works and below does not
        /*for(ccrz__E_Order__c testOrder:testOrders){
             if(testOrder.ccrz__OrderStatus__c != 'Cancelled'){
                endpoint2TestResp.put('https://wsqa.landolakesinc.com/purina/orders/' + testOrder.cc_oo_JDEOrderNumber__c,orderCancel);
             }
        }*/               
                           HttpCalloutMock multiCalloutMock =  new cc_lol_MultiRequestMock(endpoint2TestResp);                
                           boolean result = false;
                           Test.startTest();
                      system.debug('Setting up things for service call ----> ' );
                      Test.setMock(HttpCalloutMock.class, multiCalloutMock);         
                       for(ccrz__E_Order__c testOrder:testOrders){
                            if(testOrder.ccrz__OrderStatus__c != 'Cancelled'){
                                         result = cc_oo_BatchHelper.syncOrderToJDE(testOrder,testOrder.ccrz__E_OrderItems__r,'9000000','SuperTroOoper');

                            }else {
                                         result = cc_oo_BatchHelper.cancelOrder(testOrder.cc_oo_JDEOrderNumber__c);
                            }
                      system.debug('result of call  ----> ' + result ); 
                      }                         
        Test.stopTest();
              system.assertEquals(false,result);
    }
    
   
}