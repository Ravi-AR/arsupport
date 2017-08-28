//<ClassName:cc_oo_MiniCartDetailsController
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         11/03/2016                                     US-49 Allow for product minimum quantities and pallet increments.
global class cc_oo_MiniCartDetailsController {
    
    public static String errorMessage {get{
            if(errorMessage == null)
                return 'Default Value';
            return errorMessage;
    }set;}
    // US - 339 - System will not allow bag vs bulk vs liquid products to reside in the same cart
    @RemoteAction
    global static ccrz.cc_RemoteActionResult validateMinimumQuantity(final ccrz.cc_RemoteActionContext ctx, Map<string, string> skuQuantityMap){
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        Map<String, Object> dataMap = new Map<String, Object>();
        //res.data = dataMap;

         Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            String sellerId =   null;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
        
        List<String> skuIdList = new List<String>(); 
        
        If(skuQuantityMap != null && !skuQuantityMap.isEmpty()) {
            for (String sku : skuQuantityMap.keySet()){
                skuIdList.add(sku);
            }
        }
        // to fetch the product type using the sku id
        List<ccrz__E_Product__c> productDetailList = [SELECT id, ccrz__SKU__c, cc_oo_TypeOfProduct__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c IN :skuIdList];
        
        // Start - Implementation for OO- 49 
        List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_MinQuantity__c,ccrz__ProductItem__r.cc_oo_TypeOfProduct__c,
        														ccrz__ProductItem__r.ccrz__UnitOfMeasure__c,ccrz__ProductItem__r.ccrz__SKU__c,
        														cc_oo_IsOnlyPalletProduct__c,cc_oo_PalletSize__c,ccrz__ProductItem__r.Name
                                                                from ccrz__E_ProductInventoryItem__c
                                                                where ccrz__ProductItem__r.ccrz__SKU__c IN:skuIdList and  cc_oo_Seller__c=:sellerId];

        if(inventoryItems != null){
            for(ccrz__E_ProductInventoryItem__c invItem: inventoryItems){ 
            	//defect#OO-1893
            	String UOM =invItem.ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
            	if(String.isNotBlank(UOM)) {
            		String pUOM = cc_oo_pluralUOM__c.getValues(UOM).plural__c;
            		invItem.ccrz__ProductItem__r.cc_oo_UoMDesc__c=pUOM;
            	}
                dataMap.put(invItem.ccrz__ProductItem__r.ccrz__SKU__c,invItem); //OO-1594                       
            }
            res.success = true;
        }
        
        // End - Implementation for OO- 49
        
        res.data = dataMap;
        return res;
    } 
    
}