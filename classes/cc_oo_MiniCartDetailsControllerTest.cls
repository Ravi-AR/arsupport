//<ClassName:cc_oo_MiniCartDetailsControllerTest
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         11/07/2016                                     Test class for US-49 Allow for product minimum quantities and pallet increments.
@isTest
private class cc_oo_MiniCartDetailsControllerTest {
    
    //US- 49 - test method to validate minimum quantity in my cart
    @isTest
    private static void validateMinimumQuantityTest(){
          //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        
          system.runas(thisUser){
              cc_lol_TestData.setupCatalog();
              cc_lol_TestData.setupOOSettings();
              testCart = cc_lol_TestData.createCart();
              cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[7].Id,12,200.00);
              cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[8].Id,12,200.00);
              cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
              ccrz__E_Seller__c seller = [select id,ccrz__SellerId__c from ccrz__E_Seller__c LIMIT 1];
              testcart.cc_oo_Seller__c=seller.id;
              testcart.ccrz__Account__c = cc_lol_TestData.testAccount.Id; 
              update testcart;
              List<String> prd=new List<String>();
              prd.add(cc_lol_TestData.products[7].ccrz__SKU__c);
              prd.add(cc_lol_TestData.products[8].ccrz__SKU__c);
              prd.add(cc_lol_TestData.products[0	].ccrz__SKU__c);
	           	List<ccrz__E_ProductInventoryItem__c> inventory = [select cc_oo_MinQuantity__c,ccrz__ProductItem__r.cc_oo_TypeOfProduct__c,
        														ccrz__ProductItem__r.ccrz__UnitOfMeasure__c,ccrz__ProductItem__r.ccrz__SKU__c,
        														cc_oo_IsOnlyPalletProduct__c,cc_oo_PalletSize__c,ccrz__ProductItem__r.Name,
        														cc_oo_Seller__c from ccrz__E_ProductInventoryItem__c where ccrz__ProductItem__r.ccrz__SKU__c IN: prd];
	            for(ccrz__E_ProductInventoryItem__c inv: inventory){
	            inv.cc_oo_Seller__c = (string)seller.Id;
	            system.debug('inv.ccrz__UnitOfMeasure__c...'+inv.ccrz__ProductItem__r.ccrz__UnitOfMeasure__c);
	            }
	            update inventory; 
	            Map<String,String> pageParams = new Map<String, String>();
	            pageParams.put('sid', String.valueOf(seller.Id));
	            ccrz.cc_CallContext.currPageParameters = pageParams;
	            ccrz.cc_CallContext.currAccountGroup = cc_lol_TestData.testAccountGroup;                 
              Test.startTest();
              
                String quantity = '12';
                String cartId = testCart.ccrz__EncryptedId__c;
                String sku = cc_lol_TestData.products[7].ccrz__SKU__c; 
                String sku2 = cc_lol_TestData.products[8].ccrz__SKU__c; 
                String sku3 = cc_lol_TestData.products[0].ccrz__SKU__c;
              
                
                
                Map<String,String> skuQuantityMap = new Map<String, String>();
                skuQuantityMap.put(sku, quantity);
                skuQuantityMap.put(sku2, quantity);
                skuQuantityMap.put(sku3, quantity);
                String str=cc_oo_MiniCartDetailsController.errorMessage;
                ccrz.cc_RemoteActionResult remoteResult = cc_oo_MiniCartDetailsController.validateMinimumQuantity(ctx, skuQuantityMap);
                
            
              Test.stopTest();
              System.assertEquals(remoteResult.success,true);
                
          }
    }
	
}