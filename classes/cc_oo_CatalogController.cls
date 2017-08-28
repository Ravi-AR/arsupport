//ClassName:cc_oo_CatalogController
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shivani Singh                              9/20/2016                                      OO-195 - Dsiplay prebook products on Homepage
//-----------------------------------------------------------------------------------------------------------------------
//Shrivaths K                                10/03/2016                                     OO-215 - Ship To Plant selection
//-----------------------------------------------------------------------------------------------------------------------
//Gurleen Kaur                               10/19/2016                                     OO-346 - Filter out Bag and Pallete in the search selection 
//-------------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                           10/30/2016                                     OO-58  - Need the ability to search for a product using any 
//                                                                                                   part of the 'Product No' and 'Product Name'.
//-----------------------------------------------------------------------------------------------------------------------
global without sharing class cc_oo_CatalogController extends ccrz.cc_hk_Catalog {
	
    public static final String BAG_MARKER = 'BG';
    public static final String PALLET_MARKER = 'PAL';
     
    global override Map<String,Object> filterCatalogData(Map<String,Object> inputData) {
    	try{
		    	String orderType=ApexPages.currentPage().getParameters().get('orderType');
		        List<String> skus = (List<String>) inputData.get(ccrz.cc_hk_Catalog.PARAM_SKU_LIST);
		        if(orderType=='Prebook'){
		
		        List<String> skuIds = cc_oo_HelperController.getProducts(skus);
		        inputData.put(ccrz.cc_hk_Catalog.PARAM_SKU_LIST, skuIds);
		        return inputData;
		        }
		        else{
		        List<String> filteredSkus = new List<String>();
		        for (String sku : skus) {
		            if (!sku.endsWith(PALLET_MARKER) && !sku.endsWith(BAG_MARKER)) {
		                filteredSkus.add(sku);
		
		
		            }
		        }
		        List<String> skuIds = cc_oo_HelperController.getProducts(filteredSkus);
		        inputData.put(ccrz.cc_hk_Catalog.PARAM_SKU_LIST, skuIds);
		        }
			}catch(Exception ex){
		 	 List<String> skuIds=new List<String>();
		 	 inputData.put(ccrz.cc_hk_Catalog.PARAM_SKU_LIST, skuIds);
        }
         return inputData;
    }



    //US-346 - Filtering out pallet and bag in product search
    global override Map<String,Object> modifyAutoComplete(Map<String,Object> inputDataModify){
     try{
	        List<String> prodNameList = (List<String>) inputDataModify.get(ccrz.cc_hk_Catalog.PARAM_SEARCH_RESULTS);
	        
	        List<String> filteredprods = new List<String>();
	        for (String product: prodNameList ) {
	        String productName = product.toLowerCase();
	            if (!productName.contains('pallet') && !productName.contains('bag') &&  !productName.contains('container')) {
	                filteredprods.add(product);
	            }
	        }
	        
	        inputDataModify.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_RESULTS, filteredprods);
		}catch(Exception ex){
    		
    		  List<String> filteredprods = new List<String>();
    		  inputDataModify.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_RESULTS, filteredprods);
        }
		return inputDataModify;
    }
    
    //US-58 - To enable product search by any part of the product name, product No., second description, long description, short description
    global override Map<String,Object> autoComplete(Map<String,Object> inputData){
       try{    
	        System.debug('Piyali' + inputData.get(ccrz.cc_hk_Catalog.PARAM_SEARCH_STRING));
	        String prodName = (String)inputData.get(ccrz.cc_hk_Catalog.PARAM_SEARCH_STRING);
	        
	        /*ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
	        ccrz.cc_CallContext.initRemoteContext(ctx);*/
	        
	        Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
	        List<ccrz__E_Cart__c> sellerShipCode=new List<ccrz__E_Cart__c>();
	        system.debug('pageparams'+pageParams.get('sid'));
	        String cartId;
	        String sellerId = null;
	        String orderId;
	        String sellerCode;
	        Decimal accountId;
	        if(pageParams != null){
	            sellerId = pageParams.get('sid');
	            cartId = pageParams.get('cartID')!=null ? pageParams.get('cartID')  : pageParams.get('cartId'); 
	            orderId = pageParams.get('o');
	        }
	     
	        
	        if(String.isEmpty(cartId) && !String.isEmpty(orderId)) {
	        	List<ccrz__E_Order__c> orders = [select Id,ccrz__EncryptedId__c, ccrz__RequestDate__c
	                                                , cc_oo_ShipToAccount__r.AccountNumber
	                                                , ccrz__OriginatedCart__r.ccrz__EncryptedId__c
	                                                from ccrz__E_Order__c where ccrz__EncryptedId__c=:orderId LIMIT 1];
	                                                
	            sellerShipCode= [select cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c=:orders[0].ccrz__OriginatedCart__r.ccrz__EncryptedId__c LIMIT 1];
	        } else {
	        	sellerShipCode= [select cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId LIMIT 1];
	        }
	        
	         System.debug(sellerShipCode);
	        if(!sellerShipCode.isEmpty()){
		         sellerCode=sellerShipCode[0].cc_oo_Seller__r.ccrz__SellerId__c;
		         accountId=Decimal.valueOf(sellerShipCode[0].cc_oo_ShipToAccount__r.AccountNumber);
	        }
	        Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
	        
	        Id contactId = ccrz.cc_CallContext.currContact.Id;
	        String shipToPricelistName;
	        shipToPricelistName=String.valueOf(accountId) + '-'+sellerCode;
	        prodName = '%' + prodName + '%'; 
	        
	        System.debug('Test Piyali' + prodName);
	        
	        //List<ccrz__E_Product__c> productList = [SELECT Name, ccrz__SKU__c, ccrz__LongDesc__c,ccrz__ShortDesc__c,cc_oo_Second_Description__c FROM ccrz__E_Product__c WHERE (Name LIKE :prodName OR ccrz__SKU__c LIKE :prodName)];
	        Date expireLimit = Date.today();
	                    
	        List<ccrz__E_PriceListItem__c> productList=[SELECT ccrz__Product__r.Name, ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_PriceListItem__c WHERE 
	            ((ccrz__Product__r.Name LIKE :prodName OR ccrz__Product__r.ccrz__SKU__c LIKE :prodName) AND ccrz__Product__r.ccrz__StartDate__c <=:expireLimit
	             AND ccrz__Product__r.ccrz__EndDate__c >=:expireLimit) 
	            AND ccrz__Pricelist__c IN 
	            (SELECT ccrz__Pricelist__c FROM ccrz__E_AccountGroupPriceList__c WHERE ccrz__Pricelist__r.ccrz__Seller__c=:sellerId and ccrz__Pricelist__r.ccrz__Enabled__c=true AND ccrz__AccountGroup__c=:accGroup  AND (ccrz__Pricelist__r.ccrz__PricelistId__c=:sellerCode OR ccrz__Pricelist__r.ccrz__PricelistId__c=:shipToPricelistName )AND (ccrz__Pricelist__r.cc_oo_ShipToNumber__c=NULL OR ccrz__Pricelist__r.cc_oo_ShipToNumber__c=:accountId )) AND cc_oo_IsPreBook__c=false AND ccrz__EndDate__c>=:expireLimit];
	        List<String> filteredprods = new List<String>();
	        
	        if(productList.size() > 0) {
	            for(ccrz__E_PriceListItem__c prodductName : productList) {
	                filteredprods.add(prodductName.ccrz__Product__r.Name);
	            }
	        }
	        
	        Set<String> filteredSet = new Set<String>(filteredprods);
	        
	        List<String> filteredproducts = new List<String>();
	        filteredproducts.addAll(filteredSet);
	        
	        System.debug('Piyali filtered' + filteredproducts);
	        
	        
	        inputData.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_RESULTS, filteredproducts);
	        }catch(Exception ex){
    		
    		  List<String> filteredprods = new List<String>();
    		  inputData.put(ccrz.cc_hk_Catalog.PARAM_SEARCH_RESULTS, filteredprods);

        }
        return inputData;
	
	    }
	    
}