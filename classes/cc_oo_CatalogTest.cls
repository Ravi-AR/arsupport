@isTest
private class cc_oo_CatalogTest {
     
    @isTest 
    static void filterCatalogDataTestPrebook() {
        
        //Prepare Test Data
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        cc_lol_TestData.setupCatalog();
        cc_lol_TestData.setupTestUser();
        
        System.runAs(cc_lol_TestData.testUser) {    
        //List<ccrz__E_Product__c> products = [SELECT ccrz__SKU__c FROM  ccrz__E_Product__c LIMIT 7];
        List<ccrz__E_Seller__c> sellers =[SELECT ccrz__SellerId__c FROM  ccrz__E_Seller__c LIMIT 1];
        List<String> skulist = new List<String>();
        for(ccrz__E_Product__c prod : ([SELECT ccrz__SKU__c FROM  ccrz__E_Product__c LIMIT 7]))
        {
            skulist.add(prod.ccrz__SKU__c);
        }
        System.debug('skulist'+ skulist);
        PageReference testPage = new PageReference('ccrz__Products');
        Test.setCurrentPage(testPage);

        ApexPages.currentPage().getParameters().put('orderType', 'Prebook'); 
        ApexPages.currentPage().getParameters().put('sid', sellers[0].ccrz__SellerId__c); 
        String orderType= ApexPages.currentPage().getParameters().get('orderType');
        String sellerId= ApexPages.currentPage().getParameters().get('sid');
        System.debug('sellerId'+sellerId);
        Map<String,Object> inputData = new Map<String,Object>();
        inputData.put(ccrz.cc_hk_Catalog.PARAM_SKU_LIST,skulist);
        //Test the scenario
        Test.startTest();
        cc_oo_CatalogController ctrl = new cc_oo_CatalogController();
        Map<String,Object> res=ctrl.filterCatalogData(inputData); 
        System.debug(res);
        Test.stopTest();
        
        
        //Validate the test data
        system.assertEquals(res.isEmpty(),false);
    }
        }
    }
    
    @isTest 
    static void filterCatalogData() {
        
        //Prepare Test Data
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
        cc_lol_TestData.setupCatalog();
        cc_lol_TestData.setupTestUser();
        
        System.runAs(cc_lol_TestData.testUser) {
        //List<ccrz__E_Product__c> products = [SELECT ccrz__SKU__c FROM  ccrz__E_Product__c LIMIT 7];
        List<ccrz__E_Seller__c> sellers =[SELECT ccrz__SellerId__c FROM  ccrz__E_Seller__c LIMIT 1];
        
        List<String> skulist = new List<String>();
        for(ccrz__E_Product__c prod :([SELECT ccrz__SKU__c FROM  ccrz__E_Product__c LIMIT 7]))
        {
            skulist.add(prod.ccrz__SKU__c);
        }
        System.debug('skulist'+ skulist);
        PageReference testPage = new PageReference('ccrz__Products');
        Test.setCurrentPage(testPage);

        ApexPages.currentPage().getParameters().put('sid', sellers[0].ccrz__SellerId__c); 
        String sellerId= ApexPages.currentPage().getParameters().get('sid');
        Map<String,Object> inputData = new Map<String,Object>();
        inputData.put(ccrz.cc_hk_Catalog.PARAM_SKU_LIST,skulist);
        //Test the scenario
        Test.startTest();
        cc_oo_CatalogController ctrl = new cc_oo_CatalogController();
        Map<String,Object> res=ctrl.filterCatalogData(inputData); 
        Test.stopTest();
        
        
        //Validate the test data
        system.assertEquals(res.isEmpty(),false);
    }
        }        
    }
    
    //US- 58 - To test search of products using any part of product Name or SKU
    @isTest 
    static void autoCompleteTest() {
      
      //Prepare Test Data
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runas(thisUser){
        cc_lol_TestData.setupCatalog();
        cc_lol_TestData.setupTestUser();
        
        System.runAs(cc_lol_TestData.testUser) {
	        List<ccrz__E_Seller__c> sellers =[SELECT ccrz__SellerId__c FROM  ccrz__E_Seller__c LIMIT 1];
	        
	        ApexPages.currentPage().getParameters().put('sid', sellers[0].ccrz__SellerId__c); 
	        String sellerId= ApexPages.currentPage().getParameters().get('sid');
	        PageReference testPage = new PageReference('ccrz__Products');
	        Test.setCurrentPage(testPage);
	        
	        String prodName = 'duck';
	        String productNo= '001';
            String prodNameModify = 'product001 Bag';
            List<String> prodNameList = new List<String>();
            prodNameList.add(prodNameModify);
            prodNameList.add(prodName);
            
	        Map<String,Object> inputData = new Map<String,Object>();
	        inputData.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_STRING,prodName);
	         Map<String,Object> inputDataSKU = new Map<String,Object>();
	        inputDataSKU.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_STRING,productNo);
            Map<String,Object> inputDataModify = new Map<String,Object>();
	        inputDataModify.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_RESULTS,prodNameList);
	       
	        //Test the scenario
	        Test.startTest();
	        cc_oo_CatalogController ctrl = new cc_oo_CatalogController();
	        Map<String,Object> outputData=ctrl.autoComplete(inputData); 
	        Map<String,Object> outputDataSKU=ctrl.autoComplete(inputDataSKU);
            Map<String,Object> outputDataModify=ctrl.modifyAutoComplete(inputDataModify); 
	        Map<String,Object> outputDataSKUModify=ctrl.modifyAutoComplete(inputDataSKU);
	        Test.stopTest();
	       
	        
	        //Validate the test data
	        system.assertEquals(outputData.isEmpty(),false);
	        system.assertEquals(outputDataSKU.isEmpty(),false);
            system.assertEquals(outputDataModify.isEmpty(),false);
	        system.assertEquals(outputDataSKUModify.isEmpty(),false);
       }
    }
  }
  
   @isTest 
    static void ExceptionCompleteTest() {
    	
    	Map<String,Object> inputDataModify = new Map<String,Object>();
    	Map<String,Object> inputDataAuto = new Map<String,Object>();
    	Map<String,Object> inputDataFilter = new Map<String,Object>();
    	User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
    	system.runas(thisUser){
        cc_lol_TestData.setupCatalog();
    	}
    	Test.startTest();
    	cc_oo_CatalogController ctrl = new cc_oo_CatalogController();
    	Map<String,Object> outputDataAuto=ctrl.autoComplete(inputDataAuto);
        Map<String,Object> outputDataModify=ctrl.modifyAutoComplete(inputDataModify); 
        Map<String,Object> res=ctrl.filterCatalogData(inputDataFilter); 
        Test.stopTest();
     	system.assertEquals(res.isEmpty(),false);
     	system.assertEquals(outputDataModify.isEmpty(),false);
     	system.assertEquals(outputDataAuto.isEmpty(),false);
    }
}