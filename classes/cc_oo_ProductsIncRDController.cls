//<ClassName:cc_oo_ctrl_ProductsIncRD>
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                                9/6/2016                                      US:OO-90 Created and added getProductsDetails() method
//                                                                                         which will give the long description in product list page
//                                           9/28/2016                                     US: OO-371 Created and added E2 description in the product list page
//                                                                                         Used the same method getProductsDetails()
//Samruddhi Gokhale                         10/20/2016                                     US-166 Show Availability message on PDP page
//Murtaza Beejwala                          10/24/2016                                     US-59 Show vfd flag for vfd flagged products.
//Piyali Mukherjee                          10/25/2016                                     US-339 The system will not allow the user to add two types of products in the cart.
//Gurleen Kaur                              11/11/2016                                     US-144
global without sharing class cc_oo_ProductsIncRDController{
    public static final string CLASS_NAME = 'cc_oo_ProductsIncRDController';
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetails(final ccrz.cc_RemoteActionContext ctx, List<string> productIds){
        System.debug('/////////'+productIds);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
            // Creating map of dataMap to store the long description value
            // Map<String, string> dataMap = new Map<String, string>();
            Map<String,ccrz__E_Product__c> dataMap = new Map<String,ccrz__E_Product__c>();
            // Creating list of products to get the record
            Map<Id,ccrz__E_Product__c> cc_ProductsMap = new Map<Id,ccrz__E_Product__c>([Select c.Id, c.Name, c.ccrz__ProductId__c, c.ccrz__SKU__c,c.cc_oo_UoMDesc__c,c.ccrz__AvailabilityMessage__c,ccrz__AlternateName__c,
                                    c.ccrz__LongDesc__c,c.cc_oo_Second_Description__c,c.CC_OO_BrandCode__r.cc_oo_LogoURL__c From ccrz__E_Product__c c WHERE c.Id IN :productIds]);
            String sellerId = null;
            Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
            ccrz__E_Seller__c seller;
            if(sellerId != null){
                seller = [select ccrz__SellerId__c from ccrz__E_Seller__c where id=:sellerId LIMIT 1];
            }
            String sellerCode = (seller != null) ? seller.ccrz__SellerId__c:'';
            List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select ccrz__AvailabilityMessage__c,ccrz__InventoryLocationCode__c,ccrz__QtyAvailable__c,ccrz__Status__c,ccrz__ProductItem__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c IN:productIds and cc_oo_Seller__c=:sellerId ];
                //setting inventory status to alternate name in product
                System.debug('inventory-'+inventoryItems);
                if(!inventoryItems.isEmpty()){ 
                    for(ccrz__E_ProductInventoryItem__c inventoryItem:inventoryItems){
                        ccrz__E_Product__c prod = cc_ProductsMap.get(inventoryItem.ccrz__ProductItem__c);
                        prod.ccrz__AvailabilityMessage__c = inventoryItem.ccrz__AvailabilityMessage__c;
                        prod.ccrz__AlternateName__c       = inventoryItem.ccrz__Status__c;
                        system.debug('sku'+inventoryItem.ccrz__ProductItem__c+'data'+prod);
                        cc_ProductsMap.put(inventoryItem.ccrz__ProductItem__c,prod);
                    }
                }
              // Iterating through product item and the product record
              for(ccrz__E_Product__c productItem : cc_ProductsMap.values()){  
                  // Comparing the SKU value and Long description and adding it to dataMap
                  dataMap.put(string.valueOf(productItem.ccrz__SKU__c),productItem);
                  system.debug('sku11'+productItem.ccrz__SKU__c+'data'+productItem.CC_OO_BrandCode__r.cc_oo_LogoURL__c);
              }            
              res.success = true;
              // Returning the result
              res.data = dataMap;
              //res.data = dataMap1;
              return res;
              
        }catch (Exception ex)
        {              
        	cc_oo_HelperController.CreateErrorLog(ex,CLASS_NAME,'getProductsDetails');
              
        }
        return null;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsLeadTime (final ccrz.cc_RemoteActionContext ctx, List<string> productIds){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
        String sellerId =   null;
        if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
        res.success = false; 
        
        try{
             Map<String, String> dataMap = new Map<String, String>();
             dataMap        =   cc_oo_HelperController.GetLeadTimeforAllProducts(productIds, sellerId);
             res.success    = true; 
             res.data = dataMap;
             // US-144
             /*list<ccrz__E_ProductInventoryItem__c> inventoryStatusPL = [select ccrz__Status__c
                                         from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c = :productIds];
        
             if(inventoryStatusPL!=null && inventoryStatusPL.size()>0) {
                 if(inventoryStatusPL.get(0).ccrz__Status__c !='Available' ){
                   
                   res.success=true;
                   
                 }else{
                   res.success=false;
                 } 
             }else{
                 res.success=false;
             }*/
        }
        catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductsLeadTime');
              
        }
        return res;
    }

    /***************************************************************************************************************************************
    Method Name : getVfdFlag
    Description : getVfdFlag is to get the vfd flag for corresponding products
    Parameter   : sfIds 
                sfIds is the list of product Ids
    Return type : Returns ccrz.cc_RemoteActionResult.
    UserStory   : OO-59 - vfd products shall be flagged.                                                              
    *************************************************************************************************************************************/ 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getVfdFlag(final ccrz.cc_RemoteActionContext ctx,list<String> sfids){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        System.debug('*********************************************hello im in vfd flag method********************************************');
        //creating a map to store flag variable corresponding to the id's retrieved
        try{
             Map<String,boolean> dataMap = new Map<String,boolean>();
             dataMap        =   cc_oo_HelperController.getVfdFlagForAll(sfids);
             res.success    = true; 
             res.data = dataMap;
             
        }
        
        catch (Exception ex)
        {
        	  cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getVfdFlag');              
             
        }
        return res;
    }   
    
}