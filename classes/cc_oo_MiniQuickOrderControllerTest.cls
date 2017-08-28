//ClassName:cc_oo_MiniQuickOrderControllerTest 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         10/29/2016                                      OO-339 - Test class for cc_oo_MiniQuickOrderController
//Samruddhi Gokhale                        11/07/2016                                      OO-49 - Test class for cc_oo_MiniQuickOrderController
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_MiniQuickOrderControllerTest {
    
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
              
               ccrz__E_ProductInventoryItem__c prodInvItem = new ccrz__E_ProductInventoryItem__c
              	(
              		ccrz__ProductItem__c			=cc_lol_TestData.products[0].Id,
              		ccrz__InventoryLocationCode__c	=s.ccrz__SellerId__c,
              		cc_oo_Seller__c					=s.Id,
              		ccrz__Status__c					='Available'
              	);
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
                
                
                ccrz.cc_RemoteActionResult remoteResult = cc_oo_MiniQuickOrderController.addToCartOO(ctx, productDetailMap, skuQuantityMap);
            
              Test.stopTest();
                
                //Validate the test data
               system.assertEquals(remoteResult.success,true);
                if(remoteResult.success){
                    system.assertEquals(remoteResult.data!=null,true);
                    System.assert(remoteResult!=null);
    
                }
          
          }
    }
    
    

}