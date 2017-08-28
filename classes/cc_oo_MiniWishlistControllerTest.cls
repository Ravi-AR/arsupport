//ClassName:cc_oo_MiniWishlistControllerTest 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         10/29/2016                                      OO-339 - Test class for cc_oo_MiniWishListController
//Samruddhi Gokhale                        11/07/2016                                      OO-49 - Test class for cc_oo_MiniWishListController
// Saloni Kale                            11/21/2016                                      Defect: OO-313 Test class for cc_oo_MiniWishListController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_MiniWishlistControllerTest {

    //US- 339 - Test method to test add to cart validation
    
    @isTest 
    static void addToCartOOTest(){
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              testCart = cc_lol_TestData.createCart();
              cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
              ccrz__E_Seller__c s = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
              ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__Status__c='Available',ccrz__ProductItem__c=cc_lol_TestData.products[0].Id,ccrz__InventoryLocationCode__c=s.ccrz__SellerId__c,cc_oo_Seller__c=s.Id);
              insert prodInvItem;                   
              Test.startTest();
              
                String quantity = '1';
                String cartId = testCart.ccrz__EncryptedId__c;
                String sku = 'test002'; 
                String sku2 = 'test001';
                String sku3 = 'test003'; 
              
                Map<String,String> productDetailMap = new Map<String, String>();
                productDetailMap.put('CartId', cartId);
                
                Map<String,String> skuQuantityMap = new Map<String, String>();
                skuQuantityMap.put(sku, quantity);
                skuQuantityMap.put(sku2, quantity);
                skuQuantityMap.put(sku3, quantity);
                
                
                ccrz.cc_RemoteActionResult remoteResult = cc_oo_MiniWishListController.addToCartOO(ctx, productDetailMap, skuQuantityMap, s.Id);
            
              Test.stopTest();
                
                //Validate the test data
                system.assertEquals(remoteResult.success,true);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                }
          
          }
    
    }
    
    //US-339 - test empty cart scenario
    @isTest 
    static void addToEmptyCartOOTest(){
    //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              testCart = cc_lol_TestData.createCart();
                                     
              Test.startTest();
              
                String quantity = '1';
                String cartId = testCart.ccrz__EncryptedId__c;
                String sku = 'test002'; 
                String sku2 = 'test001'; 
              
                Map<String,String> productDetailMap = new Map<String, String>();
                productDetailMap.put('CartId', cartId);
                
                Map<String,String> skuQuantityMap = new Map<String, String>();
                skuQuantityMap.put(sku, quantity);
                skuQuantityMap.put(sku2, quantity);
                ccrz__E_Seller__c s = [select id from ccrz__E_Seller__c LIMIT 1];
                ccrz.cc_RemoteActionResult remoteResult = cc_oo_MiniWishListController.addToCartOO(ctx, productDetailMap, skuQuantityMap, s.Id);
            
              Test.stopTest();
                
                //Validate the test data
                system.assertEquals(remoteResult.success,true);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                }
          
          }
    
    }
    
    // Defect OO-313 Adding long description on Wishlist
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
            //List<ccrz__E_Product__c> products = [select id from ccrz__E_Product__c LIMIT 3];
            List<Id> productIdList = new List<Id>();
            for(ccrz__E_Product__c prod: [select id from ccrz__E_Product__c LIMIT 3]){
                productIdList.add(prod.Id);
            }
           /* ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
            PageReference pageRef = Page.ccrz__HomePage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.CurrentPage().getparameters().put('sid', seller.Id);
            ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c(ccrz__ProductItem__c=productIdList[0],ccrz__InventoryLocationCode__c=seller.ccrz__SellerId__c);
            insert prodInvItem;*/
            
            //Test the scenario
            
            Test.startTest(); 
                          
            ccrz.cc_RemoteActionResult remoteResult = cc_oo_MiniWishListController.getProductsDetails(ctx,productIdList);
            
            
            Test.stopTest();
            system.assertEquals(remoteResult.success,true);
        }
    }
    
}