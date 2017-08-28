//ClassName:cc_oo_ProductsIncRDControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                               10/4/2016                                      OO-372 - Test class for cc_oo_ProductsIncRD2Controller
//Samruddhi Gokhale                         10/20/2016                                     US-166 Show Availability message on PDP page
//Piyali Mukherjee                          10/28/2016                                     US-339 The systen will not allow user to enter two types of products in a cart.
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_ProductsIncRDControllerTest {
     
    @isTest 
    static void getProductsDetailsTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c
            (
            	ccrz__Status__c='Available',
            	ccrz__ProductItem__c=productIdList[0],
            	ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,
            	cc_oo_Seller__c=seller.Id
            );
            insert prodInvItem;
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductsIncRDController.getProductsDetails(ctx,productIdList);
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            //if(remoteResult.success){
            //    Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            //    system.assertEquals(mapProductData.size()>0,true);
            //}
        }
    }
    
    
    //to test the product lead time 
    
    @isTest 
    static void getProductsLeadTimeTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__Status__c='Available',ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_LeadTime__c='3 Days',cc_oo_Seller__c=seller.id);
            insert prodInvItem;
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductsIncRDController.getProductsLeadTime(ctx,productIdList);
            system.assertEquals(remoteResult.success,true);
            
            Test.stopTest();
            
            //Validate the test data
            //system.assertEquals(remoteResult.success,true);
            //if(remoteResult.success){
            //    Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            //    system.assertEquals(mapProductData.size()>0,true);
            //}
        }
    }
    
    //to test the vfd flag product
    @isTest 
    static void getProductsVfdFlagTest(){
      
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
            List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: products){
                productIdList.add(prod.Id);
            }
            //ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            //PageReference pageRef = Page.ccrz__HomePage;
            //Test.setCurrentPageReference(pageRef);
            //ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            //ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c,cc_oo_LeadTime__c='3 Days');
            //insert prodInvItem;
            
            //Test the scenario
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_ProductsIncRDController.getVfdFlag(ctx,productIdList);
            
            Test.stopTest();
            
            //Validate the test data
            system.assertEquals(remoteResult.success,true);
            ///if(remoteResult.success){
            //    Map<String, string> mapProductData = (Map<String, string>)remoteResult.data;
            //    system.assertEquals(mapProductData.size()>0,true);
            //}
        }
    }
}