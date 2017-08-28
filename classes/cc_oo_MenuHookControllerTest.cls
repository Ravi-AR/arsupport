//ClassName: cc_oo_MenuHookControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali M                                 1/31/2017                                       Test class for cc_oo_MenuHookController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_MenuHookControllerTest {

      @isTest static void test_fetch() {
      ccrz.cc_util_Reflection.createStorefrontSetting('PurinaMills');
      ccrz.cc_util_Reflection.updateStorefrontSettings('PurinaMills', 'ccrz__DefaultLanguage__c', 'en_US');
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
        	cc_lol_TestData.setupCatalog();
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            cc_lol_TestData.setupTestUser();
            Map<String,String> pageParams = new Map<String, String>();
            pageParams.put('portalUser', String.valueOf(thisUser.Id));
            pageParams.put('sid', String.valueOf(seller.Id));
            ccrz.cc_CallContext.currPageParameters = pageParams;
            ccrz.cc_CallContext.storefront   = 'PurinaMills';
            Map<String, Object> storeFrontSetting = new Map<String, Object>(); 
            storeFrontSetting.put('PurinaMills', 'PurinaMills');
            ccrz.cc_CallContext.storeFrontSettings    = storeFrontSetting; 
            
        }
       Map<String,Object> inputData = new Map<String,Object>();
       Map<String,Object> outputData = new Map<String,Object>();
       
       ccrz.cc_bean_MenuItem menuQuickOrder = new ccrz.cc_bean_MenuItem ();
       menuQuickOrder.displayName=  'QuickOrder';
       //ccrz__StoreID__c   =   'PurinaMills',
       menuQuickOrder.menuId        =   'QuickOrder';
       
       List<ccrz.cc_bean_MenuItem> menuList = new List<ccrz.cc_bean_MenuItem>();
       menuList.add(menuQuickOrder);
      
       inputData.put('PARAM_MENU',menuList);
       
       Test.startTest();
       cc_oo_MenuHookController ctrl = new cc_oo_MenuHookController();
       outputData=ctrl.fetch(inputData);
       
       ccrz.cc_bean_MenuItem menuQuickOrderCSR = new ccrz.cc_bean_MenuItem();
       menuQuickOrderCSR.displayName=   'QuickOrderCSR';
       //ccrz__StoreID__c   =   'PurinaMills',
       menuQuickOrderCSR.menuId     =   'QuickOrderCSR';
       menuList.add(menuQuickOrderCSR);
       inputData.put('PARAM_MENU',menuList);
       outputData=ctrl.fetch(inputData);  
       Test.stopTest();
       
        System.assert(outputData!=NULL);
      }
      
    
}