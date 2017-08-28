//<ClassName:cc_oo_MiniWishListController
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                          10/25/2016                                     US-339 The system will not allow the user to add two types of products in the cart.
//Samruddhi Gokhale                         11/03/2016                                     US-49 Allow for product minimum quantities and pallet increments.
//Saloni Kale                               11/21/2016                                     Defect: OO-313 Adding long description on Wishlist
global without sharing class cc_oo_MiniWishListController {
    
    // US - 339 - System will not allow bag vs bulk vs liquid products to reside in the same cart
    @RemoteAction
    global static ccrz.cc_RemoteActionResult addToCartOO(final ccrz.cc_RemoteActionContext ctx, Map<string, string> productDetailMap, Map<string, string> skuQuantityMap,String sellerId){
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;
        
        Map<String,Object> response = cc_oo_HelperController.addToCartMini(productDetailMap, skuQuantityMap, sellerId);
        
        res.data = response;
        
        return res;
    } 
    
    // Defect OO-313 Adding long description on the wishlist
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetails(final ccrz.cc_RemoteActionContext ctx, List<string> productIds){
        
        System.debug('/////////'+productIds);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
              // Creating map of dataMap to store the long description value
              //Map<String,ccrz__E_Product__c> dataMap = new Map<String,ccrz__E_Product__c>();
              Map<String,String> dataMap1 = new Map<String, String>();
              // Creating list of products to get the record
              //List<ccrz__E_Product__c> cc_ProductList = [Select c.Id, c.ccrz__SKU__c,
                                     // c.ccrz__LongDesc__c From ccrz__E_Product__c c WHERE c.ccrz__SKU__c IN :productIds];
                
            
              // Iterating through product item and the product record
              
              for(ccrz__E_Product__c productItem : [Select c.Id, c.ccrz__SKU__c,
                                      c.ccrz__LongDesc__c From ccrz__E_Product__c c WHERE c.ccrz__SKU__c IN :productIds]){  
                  // Comparing the SKU value and Long description and adding it to dataMap
                  //dataMap.put(string.valueOf(productItem.ccrz__SKU__c),productItem);
                  dataMap1.put(productItem.ccrz__SKU__c, productItem.ccrz__LongDesc__c);
              }            
              res.success = true;
              // Returning the result
              //res.data = dataMap;
              res.data = dataMap1; 
              
              
        }catch (Exception error)
        {
              System.debug(error);
        }
       return res;
    }

}