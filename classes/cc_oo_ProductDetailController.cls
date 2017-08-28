/* 
----------------------------------------------------------------------------------------------------------------------
Author                                      Date                                           Description
----------------------------------------------------------------------------------------------------------------------
Rajesh W                                10/14/2016                                   US:OO-535 The JDE ""2nd description"" shall be displayed under or appended to the product label name.
Murtaza B                               10/25/2016                                   US:OO-59 The VFD flag should be displayed for vfd flagged products.
Piyali M                                10/26/2016                                   US:OO-339 The system will not allow user to add two types of product in the cart. 
Gurleen K                               11/07/2016                                   US:OO-144 Disable add to cart button for discontinued/unavailable products
 */
global without sharing class cc_oo_ProductDetailController {
    public static final string CLASS_NAME = 'cc_oo_ProductDetailController';
    
    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult getProductDetailPrice(final ccrz.cc_RemoteActionContext ctx) {
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult(); 
        res.success = true;
        res.data = 1020.78;        
        return res;
        }
    */
             
      public String e2Description {get; set;}
      public String LeadTime {get; set;}
      
      public cc_oo_ProductDetailController() {
        try{
            //Access Second Description
            String querySKU             =   ApexPages.currentPage().getParameters().get('sku');
            String querySid             =   ApexPages.currentPage().getParameters().get('sid').substring(0,15);
            //Peformance check
            String cartId =   ApexPages.currentPage().getParameters().get('cartId');
            if(cartId == null || cartId == ''){
            	cartId = ApexPages.currentPage().getParameters().get('cartID');
            }//Peformance check
            ccrz__E_Product__c product  =   [SELECT cc_oo_Second_Description__c 
                                             FROM ccrz__E_Product__c 
                                             WHERE ccrz__SKU__c =: querySKU LIMIT 1];
            
            if(!String.isBlank(product.cc_oo_Second_Description__c)){
                e2Description =   product.cc_oo_Second_Description__c;
            }
            
            //Access Lead time
            LeadTime                    = cc_oo_HelperController.GetLeadTime(querySKU,querySid);
            getProductPricingNew(product.Id, cartId , '');//Peformance check
        
        }
        catch(Exception ex){
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('---->' + ex));
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('---->' + ex.getMessage()));
        }                                       
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
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('*********************************************hello im in vfd flag method********************************************'));
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
       
  //US-2521
      public class  cc_oo_RelatedProductsDetails{
        public String relatedProductsType{get;set;}
        public List<cc_oo_RelatedProducts> relprddataList;
     }
      //US-2521
      public class cc_oo_RelatedProducts{
        public String uOMDesc{get; set;}
        public String secondDesc{get; set;}
        public String shortDesc{get; set;}
        public String leadTime{get; set;}
        public String skuId{get; set;}
        public String longdescription{get; set;}
        public String mediaWrapper{get; set;}
        public String name{get;set;}
        public Boolean isVFD{get;set;}
    }
   
       
     /***************************************************************************************************************************************
      Method Name : getProducts
      Description : getProducts is to get the products
      Parameter   : skuId 
                    skuId is the list of product Ids
      Return type : Returns ccrz.cc_RemoteActionResult.
      *************************************************************************************************************************************/
    @RemoteAction
     global static ccrz.cc_RemoteActionResult getProducts(final ccrz.cc_RemoteActionContext ctx,String sellerId,String sku){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success=false;
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('*********************************************hello im in get Products method********************************************'));
        //creating a map to store flag variable corresponding to the id's retrieved
        try{
             List<String> skuIds=new List<String>();
              //US-2521--start
             List<cc_oo_RelatedProducts> seasonalRelatedProducts=new List<cc_oo_RelatedProducts>();
             List<cc_oo_RelatedProducts> replacedRelatedProducts=new List<cc_oo_RelatedProducts>();
             List<cc_oo_RelatedProducts> alternateRelatedProducts=new List<cc_oo_RelatedProducts>();
             List<String> relatedPrdSkuList=new List<String>();
             Map<String,Object> relatedProductDetails=new Map<String,Object>();
             Map<String,String> ProductMediaMap=new Map<String,String>();
             Map<String,String> relPrdTypMap=new Map<String,String>();
             List<ccrz__E_RelatedProduct__c> relatedPrdType=[select ccrz__RelatedProductType__c,ccrz__RelatedProduct__r.ccrz__SKU__c from ccrz__E_RelatedProduct__c where ccrz__Product__r.ccrz__SKU__c =:sku];
             if(relatedPrdType!=null){
                for(ccrz__E_RelatedProduct__c relPrdTyp:relatedPrdType){
                    relPrdTypMap.put(relPrdTyp.ccrz__RelatedProduct__r.ccrz__SKU__c,relPrdTyp.ccrz__RelatedProductType__c);
                    relatedPrdSkuList.add(relPrdTyp.ccrz__RelatedProduct__r.ccrz__SKU__c);
                }
             }
             skuIds=cc_oo_HelperController.getProducts(relatedPrdSkuList);
             List<ccrz__E_ProductMedia__c> productMedia=[select ccrz__URI__c,ccrz__Product__r.ccrz__SKU__c from ccrz__E_ProductMedia__c where ccrz__Product__r.ccrz__SKU__c IN:skuIds and ccrz__MediaType__c='Product Image'];
             if(productMedia!=null){
                for(ccrz__E_ProductMedia__c prdmed:productMedia){
                    ProductMediaMap.put(prdmed.ccrz__Product__r.ccrz__SKU__c,prdmed.ccrz__URI__c);
                }
             }
             
             List<ccrz__E_ProductInventoryItem__c> inventoryItems =[select ccrz__ProductItem__r.ccrz__HazardousFlag__c,ccrz__ProductItem__r.ccrz__ShortDesc__c,
                                                                ccrz__ProductItem__r.ccrz__LongDesc__c,ccrz__ProductItem__r.ccrz__SKU__c,ccrz__ProductItem__r.cc_oo_UoMDesc__c,
                                                                ccrz__ProductItem__r.cc_oo_Second_Description__c,cc_oo_LeadTime__c,ccrz__ProductItem__r.Name
                                                                from ccrz__E_ProductInventoryItem__c
                                                                where ccrz__ProductItem__r.ccrz__SKU__c IN:skuIds and cc_oo_Seller__c=:sellerId];
             if(inventoryItems!=null){
                 for(ccrz__E_ProductInventoryItem__c prdInvDtls:inventoryItems){
                    cc_oo_RelatedProducts prdInv=new cc_oo_RelatedProducts();
                        prdInv.UOMDesc=prdInvDtls.ccrz__ProductItem__r.cc_oo_UoMDesc__c;
                        prdInv.secondDesc=prdInvDtls.ccrz__ProductItem__r.cc_oo_Second_Description__c;
                        prdInv.leadTime=prdInvDtls.cc_oo_LeadTime__c;
                        prdInv.skuId=prdInvDtls.ccrz__ProductItem__r.ccrz__SKU__c;
                        prdInv.Name=prdInvDtls.ccrz__ProductItem__r.Name;
                        prdInv.longdescription=prdInvDtls.ccrz__ProductItem__r.ccrz__LongDesc__c;
                        prdInv.shortDesc=prdInvDtls.ccrz__ProductItem__r.ccrz__ShortDesc__c;
                        prdInv.isVFD=prdInvDtls.ccrz__ProductItem__r.ccrz__HazardousFlag__c;
                        prdInv.mediaWrapper=ProductMediaMap.get(prdInvDtls.ccrz__ProductItem__r.ccrz__SKU__c);
                    if(relPrdTypMap.get(prdInvDtls.ccrz__ProductItem__r.ccrz__SKU__c)=='Seasonal'){
                        seasonalRelatedProducts.add(prdInv);
                    }else if(relPrdTypMap.get(prdInvDtls.ccrz__ProductItem__r.ccrz__SKU__c)=='Replaced'){
                        replacedRelatedProducts.add(prdInv);
                    }else if(relPrdTypMap.get(prdInvDtls.ccrz__ProductItem__r.ccrz__SKU__c)=='Alternate'){
                        alternateRelatedProducts.add(prdInv);
                    }
                 }  
             }
             cc_oo_RelatedProductsDetails seasonalRelatedProductsDetails;
             cc_oo_RelatedProductsDetails replacedRelatedProductsDetails;
             cc_oo_RelatedProductsDetails alternateRelatedProductsDetails;
             List<cc_oo_RelatedProductsDetails> relatedProductsDetailsList=new List<cc_oo_RelatedProductsDetails>();
             if(seasonalRelatedProducts.size()>0){
                 seasonalRelatedProductsDetails=new cc_oo_RelatedProductsDetails();
                 seasonalRelatedProductsDetails.relatedProductsType ='Seasonal';
                 seasonalRelatedProductsDetails.relprddataList=seasonalRelatedProducts;
             }
             if(replacedRelatedProducts.size()>0){
                 replacedRelatedProductsDetails=new cc_oo_RelatedProductsDetails();
                 replacedRelatedProductsDetails.relatedProductsType ='Replaced';
                 replacedRelatedProductsDetails.relprddataList=replacedRelatedProducts;
             }
             if(alternateRelatedProducts.size()>0){
                 alternateRelatedProductsDetails=new cc_oo_RelatedProductsDetails();
                 alternateRelatedProductsDetails.relatedProductsType ='Alternate';
                 alternateRelatedProductsDetails.relprddataList=alternateRelatedProducts;
             }
             relatedProductsDetailsList.add(seasonalRelatedProductsDetails);
             relatedProductsDetailsList.add(replacedRelatedProductsDetails);
             relatedProductsDetailsList.add(alternateRelatedProductsDetails);
             relatedProductDetails.put('skuIds',skuIds);
             relatedProductDetails.put('relatedProducts',relatedProductsDetailsList);
             res.success=true;
             res.data = relatedProductDetails;
              //US-2521-end
             
        }
        
        catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProducts');
              
        }
       return res; 
     }      
     /***************************************************************************************************************************************
      Method Name : addToCartOO
      Description : addToCartOO is to add the product with the correst prices to the cart
      Parameter   : productDetailMap, priceMap
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-339, OO- 56                                                             
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult addToCartOO(final ccrz.cc_RemoteActionContext ctx, Map<string, Object> productDetailMap, Map<String, Object> priceMap) {
        
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('----> addToCartOO started'));
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;
        
        try{
            Map<String, Object> dataMap = new Map<String, Object>();
            
            String skuId;
            Integer quantity=1;
            String cartGUID;
            String primaryCartId;
            String sid;
            String shipTo;
            //US - 1891
            //String isValidSplit;
            Integer addContractQty = 0;
            //Integer contractBalance = 0;
            //Integer remainingQty = 0;
            Integer contractCartQuantity = 0;
            Date shipDate = Date.Today();
            //US-56-Start
            String typeValue;
            Decimal price;
            String contractId;
            String onlyPallet;
            Decimal palletPrice;
            String palletQuantity = '';
            //US-56-End
            
            Id accountId = ccrz.cc_CallContext.currAccountId;
            Id contactId = ccrz.cc_CallContext.currContact.Id;
            Id userId = ccrz.cc_CallContext.currUser.Id;
            Integer tonToLb=Integer.valueOf(LOLSettings__c.getValues('cc_oo_TON_TO_LB').Value__c);
            boolean isfreightincluded;
            // Mapped Data from UI
            if(productDetailMap != null && !productDetailMap.isEmpty()){
                if(productDetailMap.containsKey('sku') && productDetailMap.get('sku') != null)
                    skuId = String.valueOf(productDetailMap.get('sku'));
                
                if(productDetailMap.containsKey('quantity') && productDetailMap.get('quantity') != null)
                    quantity = Integer.valueOf(productDetailMap.get('quantity'));
                
                if(productDetailMap.containsKey('cartId')){
                    cartGUID= String.valueOf(productDetailMap.get('cartId'));
                    primaryCartId=cartGUID; 
                } 
                
                if(productDetailMap.containsKey('sid')){
                    sid = String.valueOf(productDetailMap.get('sid'));
                } 
                
                if(productDetailMap.containsKey('shipTo')){
                    shipTo = String.valueOf(productDetailMap.get('shipTo'));
                } 
                
                if(productDetailMap.containsKey('shipDate') && productDetailMap.get('shipDate') != null && productDetailMap.get('shipDate') != ''){
                    shipDate = Date.parse(String.valueOf(productDetailMap.get('shipDate')));
                }
                if(productDetailMap.containsKey('isfreightIncluded') && productDetailMap.get('isfreightIncluded') != null && productDetailMap.get('isfreightIncluded') != ''){
					isfreightincluded=  Boolean.valueof(productDetailMap.get('isfreightIncluded'));              
                }
                
                //US - 1891
                /*if(productDetailMap.containsKey('isSplit')){
                    isValidSplit = String.valueOf(productDetailMap.get('isSplit'));
                }  */
                
                          
            }
            
            
            // Creation of new Cart when cart is null
            if(cartGUID == null || cartGUID == '' || cartGUID == '{}' || cartGUID.toLowercase()  == 'undefined') {
                ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(sid ,shipTo,false );
                if(cartReturn.ccrz__RequestDate__c == null) {
                    cartReturn.ccrz__RequestDate__c = shipDate;
                }
                update cartReturn;
                cartGUID  = String.valueOf(cartReturn.ccrz__EncryptedId__c);
                primaryCartId = cartGUID;
            }
            
            //Pricing data mapped from UI
            if(priceMap != null && !priceMap.isEmpty()) {
                if(priceMap.containsKey('type') && priceMap.get('type') != null)
                    typeValue= String.valueOf(priceMap.get('type'));
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali test' + priceMap.get('type')));
                
                if(priceMap.containsKey('price') && priceMap.get('price') != null)           
                    price= decimal.valueOf((string)priceMap.get('price'));
                
                if(priceMap.containsKey('contractId') && priceMap.get('contractId') != null){
                    contractId= String.valueOf(priceMap.get('contractId'));
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali Contract ID' +contractId));
                }
                if(priceMap.containsKey('onlyPallet') && priceMap.get('onlyPallet') != null){
                    onlyPallet= String.valueOf(priceMap.get('onlyPallet'));
                }
                // US - 3010
                /*if(priceMap.containsKey('palletPrice') && priceMap.get('palletPrice') != null){
                    palletPrice= decimal.valueOf((string)priceMap.get('palletPrice'));
                }*/
                if(priceMap.containsKey('palletQuantity') && priceMap.get('palletQuantity') != null){
                    palletQuantity= String.valueOf(priceMap.get('palletQuantity'));
                } 
            } 
            
            dataMap.put('isInvalid', false);
           
            
            Integer totalQuantity = quantity;
            
            // to fetch the product type using the sku id
                ccrz__E_Product__c productDetail = [SELECT Id,ccrz__SKU__c, cc_oo_TypeOfProduct__c,ccrz__UnitOfMeasure__c,cc_oo_UoMDesc__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c =:skuId];
            // to fetch inventory item
                List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_LeadTime__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c=:productDetail.Id and cc_oo_Seller__c=:sid];
         
    		
            // to fetch the current cart using the cartId
            //2752
                ccrz__E_Cart__c cartDetails = [SELECT c.ccrz__EncryptedId__c,cc_oo_ShipToAccount__c,cc_oo_AmendedCart__c,c.ccrz__ShipMethod__c,c.Id,ccrz__RequestDate__c,ccrz__ActiveCart__c,cc_oo_SplitCartType__c,cc_oo_SplitCart__c,cc_oo_OriginalCart__c, (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c, ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c, cc_oo_UnitPrice__c FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartGUID LIMIT 1];
                Set<String> typeOfProductList = new Set<String>();
                Boolean isAmended=cartDetails.cc_oo_AmendedCart__c;
                String typeOfProduct=productDetail.cc_oo_TypeOfProduct__c;
                String shippingMethod=cartDetails.ccrz__ShipMethod__c;
                Id shipToAccountNumber=cartDetails.cc_oo_ShipToAccount__c;
                if(String.isNotBlank(shippingMethod)){
                    String[] splitShippingMethod=shippingMethod.split(' - ');
                    if(splitShippingMethod.size() > 1) {
                		shippingMethod=splitShippingMethod[1].deleteWhitespace().toUpperCase();
	                } else {
	                	shippingMethod=splitShippingMethod[0].deleteWhitespace().toUpperCase();
	                }  
                }
                else{
                    shippingMethod=null;    
                }
                
                boolean addLead=cc_oo_HelperController.getCurrentAndCutOffTime(typeOfProduct,sid,shippingMethod);
            //-1719
                for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r){
                    typeOfProductList.add(cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c);
                }
                Date leadDate = Date.today();
                String[] splitLead = (inventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                Integer leadTime = Integer.valueOf(splitLead[0]);
                if(addLead){
                    leadDate = leadDate.addDays(leadTime+1);    
                }
                else {
                    leadDate = leadDate.addDays(leadTime);  
                    
                }
                leadDate = cc_oo_HelperController.getHolidayLeadDate(sid, leadDate);
                List<ccrz__E_Cart__c> secondaryCart = [select id, ccrz__EncryptedId__c, cc_oo_SplitCartType__c,ccrz__ActiveCart__c, cc_oo_SplitCart__r.ccrz__EncryptedId__c,ccrz__RequestDate__c,
                                (SELECT Id, ccrz__Product__r.cc_oo_TypeOfProduct__c FROM ccrz__E_CartItems__r)
                                from ccrz__E_Cart__c where ccrz__Account__c =: accountId and ccrz__User__c =: userId and  ccrz__Contact__c =: contactId and
                                cc_oo_Seller__r.Id =: sid and ccrz__ShipTo__r.cc_oo_BillToShipToID__c =: shipTo and ccrz__CartStatus__c = 'Open'
                                AND ccrz__ActiveCart__c = False AND cc_oo_SplitCartType__c = 'Secondary' AND cc_oo_SplitCart__r.ccrz__EncryptedId__c = :cartGUID];
               		if(!secondaryCart.isEmpty()) {
               			Set<String> typeOfsecondaryProductList = new Set<String>();
                        if(!(secondaryCart[0].ccrz__E_CartItems__r).isEmpty()) {
                            for(ccrz__E_CartItem__c cartItem : secondaryCart[0].ccrz__E_CartItems__r){
                                typeOfsecondaryProductList.add(cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c);
                            }
                            //US - 2408-Start
                            if(((!typeOfsecondaryProductList.isEmpty()) && !(typeOfsecondaryProductList.contains(productDetail.cc_oo_TypeOfProduct__c)))
                                    || ((!typeOfProductList.isEmpty()) && !(typeOfProductList.contains(productDetail.cc_oo_TypeOfProduct__c)))) {            
                                System.debug('----> inside If');
                                res.data = typeOfsecondaryProductList.iterator().next();
                                res.success = false;
                                return res;
                            }
                            //US - 2408-End
                        } else {
                        	if((!typeOfProductList.isEmpty()) && !(typeOfProductList.contains(productDetail.cc_oo_TypeOfProduct__c))) {            
	                            System.debug('----> inside If');
	                            res.data = typeOfProductList.iterator().next();
	                            res.success = false;
	                            return res;
                        	}
                        }
               		}else {
                    	if((!typeOfProductList.isEmpty()) && !(typeOfProductList.contains(productDetail.cc_oo_TypeOfProduct__c))) {            
	                    	System.debug('----> inside If');
	                    	res.data = typeOfProductList.iterator().next();
	                    	res.success = false;
	                    	return res;
                        }
                   	}
               
                if(cartDetails.ccrz__RequestDate__c < leadDate) { 
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',(secondaryCart));
                    if(!secondaryCart.isEmpty()) {
                        /*Set<String> typeOfsecondaryProductList = new Set<String>();
                        if(!(secondaryCart[0].ccrz__E_CartItems__r).isEmpty()) {
                            for(ccrz__E_CartItem__c cartItem : secondaryCart[0].ccrz__E_CartItems__r){
                                typeOfsecondaryProductList.add(cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c);
                            }
                            //US - 2408-Start
                            if((!typeOfsecondaryProductList.isEmpty()) && !(typeOfsecondaryProductList.contains(productDetail.cc_oo_TypeOfProduct__c))
                                    && (!typeOfProductList.isEmpty()) && !(typeOfProductList.contains(productDetail.cc_oo_TypeOfProduct__c))) {            
                                System.debug('----> inside If');
                                res.data = typeOfsecondaryProductList.iterator().next();
                                res.success = false;
                                return res;
                            }
                            //US - 2408-End
                        }*/
        
                        cartGUID = String.valueOf(secondaryCart[0].ccrz__EncryptedId__c);
                        if(secondaryCart[0].ccrz__RequestDate__c < leadDate) {
                            secondaryCart[0].ccrz__RequestDate__c = leadDate;
                            update secondaryCart;
                        }
                    } else {
                        //US - 2408 -start
                         /*if((!typeOfProductList.isEmpty()) && !(typeOfProductList.contains(productDetail.cc_oo_TypeOfProduct__c))) {            
                            System.debug('----> inside If');
                            res.data = typeOfProductList.iterator().next();
                            res.success = false;
                            return res;
                        }*/
                        //US - 2408-End
                        ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(sid ,shipTo, true);
                        cartDetails.cc_oo_SplitCart__c = cartReturn.Id;
                        update cartDetails;
                        cartReturn.cc_oo_SplitCart__c = cartDetails.Id;
                        cartReturn.ccrz__RequestDate__c = leadDate;
                        update cartReturn;
                        cartGUID  = String.valueOf(cartReturn.ccrz__EncryptedId__c);
                    }
                    //2752
                    cartDetails = [SELECT c.ccrz__EncryptedId__c,cc_oo_AmendedCart__c,c.Id,ccrz__RequestDate__c,ccrz__ActiveCart__c,cc_oo_SplitCartType__c,cc_oo_SplitCart__c,cc_oo_OriginalCart__c, (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c, ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c, cc_oo_UnitPrice__c FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartGUID LIMIT 1];
                } 
                
            //1719
            //2752
            List<ccrz__E_CartItem__c> originalCartItem = [SELECT ccrz__Product__r.ccrz__SKU__c, cc_oo_OriginalBagPrice__c, cc_oo_OriginalPalletPrice__c  FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =:cartDetails.cc_oo_OriginalCart__c];
            //2752
            Id cart = cartDetails.Id;
            typeOfProductList = new Set<String>();
            List<ccrz__E_CartItem__c> contractItemsList = new List<ccrz__E_CartItem__c>();
            List<ccrz__E_CartItem__c> listPriceItemsList = new List<ccrz__E_CartItem__c>();
            Set<String> addNewToCartList = new Set<String>();
            
            //to create list with product types in cart, items with list price and contract price
            for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r){
                typeOfProductList.add(cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c);
                addNewToCartList.add(cartItem.ccrz__Product__r.ccrz__SKU__c); 
                if(cartItem.ccrz__Product__r.ccrz__SKU__c.equals(skuId)){
                    if(cartItem.cc_oo_IsListPrice__c && typeValue.equals('list-price')) {
                        listPriceItemsList.add(cartItem);
                        //delete cartItem;
                    } else if(!cartItem.cc_oo_IsListPrice__c && typeValue.equals('contract-price')){
                        contractItemsList.add(cartItem);
                        //delete cartItem;
                    }
                    
                    // to add the quantity added in cart for the input contractId
                    if(cartItem.cc_oo_ContractPrice__c != null && String.valueOf(cartItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c).equals(contractId)) {
                            contractCartQuantity += Integer.valueOf(cartItem.ccrz__Quantity__c);
                    }
                }           
            }
            
            Boolean disabledContract = false;
            // Check Contract Quantity compared to UI quantity and return if less
            cc_oo_ContractPrice__c contract;
            //US - 1891
            if(typeValue == 'contract-price') {
            	Decimal contractNumber = Decimal.valueOf(contractId);
                contract = [SELECT Id, cc_oo_AvailabilityQty__c,cc_oo_isfreightincluded__c  FROM cc_oo_ContractPrice__c WHERE cc_oo_ContractNumber__c=:contractNumber 
                				AND cc_oo_Product__c =:productDetail.Id AND cc_oo_ShipToNumber__c=:shipToAccountNumber
                				AND cc_oo_Seller__c=:sid];
                /*Integer finalQty = contractCartQuantity + quantity;
                // Show message dialog when contract balance is less than quantity entered
                if(isValidSplit == 'false') {
                    if(contract.cc_oo_AvailabilityQty__c < finalQty) {
                        dataMap.put('isInvalid', true);
                        res.data = dataMap;
                        return res;
                    }
                }
                if(finalQty >= (Integer.valueOf(contract.cc_oo_AvailabilityQty__c))) {
                    disabledContract = true;  
                }*/
            }
            
            
            // To check mismatch of type of product in cart
            if((!typeOfProductList.isEmpty()) && !(typeOfProductList.contains(productDetail.cc_oo_TypeOfProduct__c))) {            
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('----> inside If'));
                res.data = typeOfProductList.iterator().next();
                res.success = false;
            } else {
                
                // Condition when Cart is has rows
                if(!addNewToCartList.isEmpty() && addNewToCartList.contains(skuId)) {
                List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
                // When input type is list price
                    if(typeValue.equals('list-price')) {
                        Integer finalQuantity = quantity;
                        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside main else list'));
                        // When cart consistes of list price item
                        if(listPriceItemsList != null && !listPriceItemsList.isEmpty()) {
                            // When product is of only-pallet type
                            if(onlyPallet == 'true') {
                                for(ccrz__E_CartItem__c cartItem : listPriceItemsList){
                                     Decimal unitPrice=cartItem.cc_oo_UnitPrice__c;
                                     String typofPrd=cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c;
                                     if(cartItem.ccrz__Product__r.ccrz__SKU__c.equals(skuId)){
                                        cartItem.ccrz__Quantity__c += quantity;
                                        cartItem.cc_oo_IsListPrice__c = true;
                                        //cc_oo_HelperController.addNewCartRow(skuId,Integer.valueOf(cartItem.ccrz__Quantity__c),cartGUID);
                                        if(isAmended && unitPrice!=null){
                                            cartItem.ccrz__Price__c = unitPrice;
                                            cartItem.cc_oo_UnitPrice__c = unitPrice;
                                            //3752
                                            cartItem.cc_oo_OriginalPalletPrice__c = price;
                                            if(typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
						                            Decimal blkUnitPrice=unitPrice/tonToLb;
						                            cartItem.ccrz__SubAmount__c = blkUnitPrice * cartItem.ccrz__Quantity__c;
                        					}else{
                                           			 cartItem.ccrz__SubAmount__c = unitPrice * cartItem.ccrz__Quantity__c;
                                            }
                                        }else{
                                            cartItem.ccrz__Price__c = price;
                                            cartItem.cc_oo_UnitPrice__c = price;
                                            //2752
                                            cartItem.cc_oo_OriginalPalletPrice__c = price;
                                             if(typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
						                            Decimal blkUnitPrice=price/tonToLb;
						                            cartItem.ccrz__SubAmount__c = blkUnitPrice * cartItem.ccrz__Quantity__c;
                        					}else{
                                            cartItem.ccrz__SubAmount__c = price * cartItem.ccrz__Quantity__c;
                                             }
                                        }
                                        
                                        cartItemList.add(cartItem);
                                    }
                                }
                                update cartItemList;
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('cart item updated' + cartItemList));
                            } else if(onlyPallet == 'false') {
                                // To split the cart entry into pallet and bags
                                //US - 3010 
                                /* if(!String.isBlank(palletQuantity)) {
                                    Integer quotient = 0;
                                    Integer remainder = 0;
                                    
                                    Integer listSize = listPriceItemsList.size();
                                    
                                    ccrz__E_CartItem__c bagPriceItem;
                                    ccrz__E_CartItem__c palletPriceItem;
                                    
                                    if(listSize != 0) {
                                        Integer listQuantity = Integer.valueOf(listPriceItemsList[0].ccrz__Quantity__c);
                                        quotient = listQuantity /(Integer.valueOf(palletQuantity));
                                        remainder = math.mod(listQuantity , Integer.valueOf(palletQuantity));
                                        if(quotient >= 1 && remainder == 0) {
                                            palletPriceItem = listPriceItemsList[0];
                                        } else if(quotient == 0 && remainder >= 1) {
                                            bagPriceItem = listPriceItemsList[0];
                                        }
                                    }
                                    
                                    if(listSize == 2) {
                                    Integer listQuantity = Integer.valueOf(listPriceItemsList[1].ccrz__Quantity__c);
                                        quotient = listQuantity/(Integer.valueOf(palletQuantity));
                                        remainder = math.mod(listQuantity, Integer.valueOf(palletQuantity));
                                        if(quotient >= 1 && remainder == 0) {
                                            palletPriceItem = listPriceItemsList[1];
                                        } else if(quotient == 0 && remainder >= 1) {
                                            bagPriceItem = listPriceItemsList[1];
                                        }
                                    }
                                    
                                    quotient = 0;
                                    remainder = 0;
                                    
                                    if(bagPriceItem != null) {
                                        bagPriceItem.ccrz__Quantity__c += quantity;
                                        quotient = Integer.valueOf(bagPriceItem.ccrz__Quantity__c)/(Integer.valueOf(palletQuantity));
                                        remainder = math.mod(Integer.valueOf(bagPriceItem.ccrz__Quantity__c), Integer.valueOf(palletQuantity));
                                        
                                        if(remainder >= 1) {
                                            bagPriceItem.ccrz__Quantity__c = remainder;
                                            bagPriceItem.cc_oo_IsListPrice__c = true;
                                            Decimal unitPrice=bagPriceItem.cc_oo_UnitPrice__c;
                                            if(isAmended && unitPrice!=null){
                                                system.debug('in amended bag'+unitPrice);
                                                bagPriceItem.ccrz__Price__c = unitPrice;
                                                bagPriceItem.cc_oo_UnitPrice__c = unitPrice;
                                                //2752
                                                //bagPriceItem.cc_oo_OriginalBagPrice__c = price; 
                                                //bagPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                                bagPriceItem.ccrz__SubAmount__c = unitPrice * remainder;
                                                system.debug('in amended bag'+remainder); 
                                            }else{
                                              bagPriceItem.ccrz__Price__c = price;
                                              bagPriceItem.cc_oo_UnitPrice__c = price;
                                              //2752
                                              bagPriceItem.cc_oo_OriginalBagPrice__c = price;
                                              bagPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                              bagPriceItem.ccrz__SubAmount__c = price * remainder;  
                                            }
                                            
                                            cartItemList.add(bagPriceItem);
                                        } else if(remainder == 0){
                                            delete bagPriceItem;
                                        }
                                    }
                                    
                                    if(palletPriceItem != null) {
                                        if(quotient != 0) {
                                            palletPriceItem.ccrz__Quantity__c += quotient * (Integer.valueOf(palletQuantity));
                                            palletPriceItem.cc_oo_IsListPrice__c = true;
                                            Decimal unitPalletPrice=palletPriceItem.cc_oo_UnitPrice__c;
                                             if(isAmended && unitPalletPrice!=null){
                                                system.debug('in amended pallet2'+unitPalletPrice);
                                                palletPriceItem.ccrz__Price__c = unitPalletPrice;
                                                palletPriceItem.cc_oo_UnitPrice__c = unitPalletPrice;
                                                //2752
                                                //palletPriceItem.cc_oo_OriginalBagPrice__c = price;
                                                //palletPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                                palletPriceItem.ccrz__SubAmount__c = unitPalletPrice * palletPriceItem.ccrz__Quantity__c;
                                                system.debug('in amended pallet2'+palletPriceItem.ccrz__SubAmount__c);

                                             }else{
                                                palletPriceItem.ccrz__Price__c = price;
                                                palletPriceItem.cc_oo_UnitPrice__c = price;
                                                //2752
                                                palletPriceItem.cc_oo_OriginalBagPrice__c = price;
                                                palletPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                                palletPriceItem.ccrz__SubAmount__c = price * (quotient * (Integer.valueOf(palletQuantity)));
                                             }

                                            
                                            cartItemList.add(palletPriceItem);
                                        } else if(quotient == 0 && remainder == 0){
                                            Integer total = Integer.valueOf(palletPriceItem.ccrz__Quantity__c) + quantity;
                                            Integer localQuotient = total/(Integer.valueOf(palletQuantity));
                                            Integer localRemainder = math.mod(total, Integer.valueOf(palletQuantity));
                                            
                                            Integer localQuantity = 0;
                                            if(localQuotient != 0) {
                                                localQuantity = localQuotient * (Integer.valueOf(palletQuantity));
                                            }
                                            
                                            if(localQuantity != palletPriceItem.ccrz__Quantity__c) {
                                                palletPriceItem.ccrz__Quantity__c = localQuantity;
                                                palletPriceItem.cc_oo_IsListPrice__c = true;
                                                Decimal unitPalletPrice=palletPriceItem.cc_oo_UnitPrice__c;
                                                if(isAmended && unitPalletPrice!=null){
                                                    system.debug('in amended unitpallet'+unitPalletPrice);
                                                    palletPriceItem.ccrz__Price__c = unitPalletPrice;
                                                    palletPriceItem.cc_oo_UnitPrice__c = unitPalletPrice;
                                                    //2752
                                                    //palletPriceItem.cc_oo_OriginalBagPrice__c = price;
                                                    //palletPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                                    palletPriceItem.ccrz__SubAmount__c = unitPalletPrice * localQuantity;
                                                    system.debug('in amended unitpallet'+palletPriceItem.ccrz__SubAmount__c);

                                                }else{
                                                    palletPriceItem.ccrz__Price__c = palletPrice;
                                                    palletPriceItem.cc_oo_UnitPrice__c = palletPrice;
                                                    //2752
                                                    palletPriceItem.cc_oo_OriginalBagPrice__c = price;
                                                    palletPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                                    palletPriceItem.ccrz__SubAmount__c = palletPrice * localQuantity;
                                                }
                                                
                                                cartItemList.add(palletPriceItem);
                                            }
                                            
                                            if(localRemainder != 0 && bagPriceItem == null) {
                                                //2752
                                                if(isAmended) {
                                                    for(ccrz__E_CartItem__c originalItem : originalCartItem) {
                                                        if(originalItem.ccrz__Product__r.ccrz__SKU__c == skuId) {
                                                            price = originalItem.cc_oo_OriginalBagPrice__c;
                                                            cc_oo_HelperController.addNewCartItem(skuId,localRemainder ,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice));
                                                        }
                                                    }
                                                } else {
                                                    cc_oo_HelperController.addNewCartItem(skuId,localRemainder ,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice) );
                                                }
                                            }
                                        }
                                    } else if(palletPriceItem == null && quotient >= 1){
                                        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali Test' + quotient * (Integer.valueOf(palletQuantity))));
                                        if(isAmended) {
                                            for(ccrz__E_CartItem__c originalItem : originalCartItem) {
                                                if(originalItem.ccrz__Product__r.ccrz__SKU__c == skuId) {
                                                    palletPrice = originalItem.cc_oo_OriginalPalletPrice__c;
                                                    cc_oo_HelperController.addNewCartItem(skuId,quotient * (Integer.valueOf(palletQuantity)) ,cart,palletPrice,true,null,sid,String.valueOf(price),String.valueOf(palletPrice));
                                                }
                                            }
                                        }else {
                                            cc_oo_HelperController.addNewCartItem(skuId,quotient * (Integer.valueOf(palletQuantity)) ,cart,palletPrice,true,null,sid,String.valueOf(price),String.valueOf(palletPrice));
                                        }
                                    }
                                } */
                                
                                //else if(String.isBlank(palletQuantity)) {
                                    
                                    Integer listSize = listPriceItemsList.size();                                   
                                    ccrz__E_CartItem__c bagPriceItem;
                                    
                                    if(listSize != 0) {
                                        bagPriceItem = listPriceItemsList[0];
                                        String typofPrd=bagPriceItem.ccrz__Product__r.cc_oo_TypeOfProduct__c;
                                        bagPriceItem.ccrz__Quantity__c += quantity;
                                        bagPriceItem.cc_oo_IsListPrice__c = true;
                                        Decimal unitBagPrice=bagPriceItem.cc_oo_UnitPrice__c;
                                        //2752
                                        if(isAmended && unitBagPrice!=null){
                                            system.debug('in amended bag again'+unitBagPrice);
                                            bagPriceItem.ccrz__Price__c = unitBagPrice;
                                            bagPriceItem.cc_oo_UnitPrice__c = unitBagPrice;
                                            //2752
                                            //bagPriceItem.cc_oo_OriginalBagPrice__c = price;
                                            //bagPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                            if(typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
						                            Decimal blkUnitPrice=unitBagPrice/tonToLb;
						                            bagPriceItem.ccrz__SubAmount__c = blkUnitPrice * bagPriceItem.ccrz__Quantity__c;
                        					}else{
                                            bagPriceItem.ccrz__SubAmount__c = unitBagPrice * bagPriceItem.ccrz__Quantity__c;
                                            }
                                            system.debug('in amended bag again'+bagPriceItem.ccrz__SubAmount__c);

                                        }else{
                                            bagPriceItem.ccrz__Price__c = price;
                                            bagPriceItem.cc_oo_UnitPrice__c = price;
                                            //2752
                                            bagPriceItem.cc_oo_OriginalBagPrice__c = price;
                                            bagPriceItem.cc_oo_OriginalPalletPrice__c = palletPrice;
                                            if(typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
						                            Decimal blkUnitPrice=price/tonToLb;
						                            bagPriceItem.ccrz__SubAmount__c = blkUnitPrice * bagPriceItem.ccrz__Quantity__c;
                        					}else{
                                            	bagPriceItem.ccrz__SubAmount__c = price * bagPriceItem.ccrz__Quantity__c;
                                            }
                                        }

                                        
                                        
                                        update bagPriceItem;
                                    }
                                //}                                  
                            }
                        }else {
                            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside list price add new'));
                            //US - 3010                           
                            //if(String.isBlank(palletQuantity)) {
                                     cc_oo_HelperController.addNewCartItem(skuId,quantity,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice),inventoryItems[0].cc_oo_LeadTime__c,isfreightincluded,null); 
                                //} 
                                /*else {
                                    Integer quotient = finalQuantity/(Integer.valueOf(palletQuantity));
                                    Integer remainder = math.mod(finalQuantity, Integer.valueOf(palletQuantity));
                                    
                                    if(quotient >= 1) {
                                         cc_oo_HelperController.addNewCartItem(skuId,(quotient * Integer.valueOf(palletQuantity)),cart,palletPrice,true,null,sid,String.valueOf(price),String.valueOf(palletPrice) ); 
                                    }
                                    
                                    if(remainder >= 1) {
                                        cc_oo_HelperController.addNewCartItem(skuId,remainder,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice)) ;
                                    }  
                                }*/                             
                        }
                        
                    } else if (typeValue == 'contract-price') {
                        // When input is of contract type
                        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside contract price add 1' + listPriceItemsList));
                        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside contract price add 1' + contractItemsList));
                        // When user clicks on the split button when quantity exceeds contract quantity
                        //US - 1891
                        /*if(isValidSplit == 'true') {
                            addContractQty = Integer.valueOf(contract.cc_oo_AvailabilityQty__c) - (contractCartQuantity); 
                            remainingQty = quantity - addContractQty;
                        } else {
                            addContractQty = quantity;
                        }*/
                        addContractQty = quantity; // US - 1891
                        ccrz.ccLog.log('Hi'+Integer.ValueOf(contract.cc_oo_AvailabilityQty__c));
                        ccrz.ccLog.log('Hi'+addContractQty);
                       
                        cartItemList.addAll(addContractItem(cart, contractId, addContractQty,  contractItemsList, price, skuId, contract,sid));
                        //contractBalance = Integer.ValueOf(contract.cc_oo_AvailabilityQty__c) - addContractQty;
                    }
                    update cartItemList;
                } else {
                    // When the cart has no cartitem
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside main else'));
                    if(typeValue == 'list-price') {
                        //US - 3010
                        //if(onlyPallet == 'true') {
                            cc_oo_HelperController.addNewCartItem(skuId,quantity,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice),inventoryItems[0].cc_oo_LeadTime__c,isfreightincluded,null);
                       /* } else if(onlyPallet == 'false') {
                            if(String.isBlank(palletQuantity)) {
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside main list for new non pallet without quantity'));
                                cc_oo_HelperController.addNewCartItem(skuId,quantity,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice));
                            } else {
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside pallet else' + totalQuantity));
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside pallet else' + palletQuantity));
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside pallet else' + Integer.valueOf(palletQuantity)));
                                Integer quantityQuotient = (totalQuantity/Integer.valueOf(palletQuantity));
                                Integer quantityRemainder = math.mod(totalQuantity, Integer.valueOf(palletQuantity));
                                
                                if(quantityQuotient >= 1) {
                                    cc_oo_HelperController.addNewCartItem(skuId,(quantityQuotient * Integer.valueOf(palletQuantity)),cart,palletPrice,true,null,sid,String.valueOf(price),String.valueOf(palletPrice) );
                                }
                                
                                if(quantityRemainder >= 1) {                        
                                    cc_oo_HelperController.addNewCartItem(skuId,quantityRemainder,cart,price,true,null,sid,String.valueOf(price),String.valueOf(palletPrice) );
                                }
                            }
                        }*/
                        //US - 3010
                    } else if(typeValue == 'contract-price') {
                        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside main contract for new'));
                        
                        /*if(isValidSplit == 'true') {
                            addContractQty = Integer.valueOf(contract.cc_oo_AvailabilityQty__c); 
                            remainingQty = quantity - Integer.valueOf(contract.cc_oo_AvailabilityQty__c);
                        } else {
                            addContractQty = quantity;
                        }*/
                        addContractQty = quantity; // US - 1891
                        cc_oo_HelperController.addNewCartItem(skuId,addContractQty,cart,price,false,contract.Id,sid,null,null,inventoryItems[0].cc_oo_LeadTime__c,isfreightincluded,null);
                        //US - 1891
                        /*contractBalance = Integer.valueOf(contract.cc_oo_AvailabilityQty__c) - addContractQty;
                        if(contractBalance <= 0) {
                            disabledContract = true;
                        } else {
                            disabledContract = false;
                        }*/
                    }
                }
                            
                //Map<String, Object> dataMap = new Map<String, Object>();
                //2495 - recover
                if(cartDetails.cc_oo_SplitCartType__c == 'Primary') {
                    dataMap.put('cartType', 'Cart 1');
                } else if (cartDetails.cc_oo_SplitCartType__c == 'Secondary') {
                    dataMap.put('cartType', 'Cart 2');
                }
                dataMap.put('quantity', quantity);
                dataMap.put('UOM', productDetail.cc_oo_UoMDesc__c);
                //2495
                dataMap.put('cartId', primaryCartId);
                //dataMap.put('remainingQuantity', remainingQty);
                dataMap.put('disableContract', disabledContract);
                res.success = true;
                
                String pUOM = cc_oo_pluralUOM__c.getValues(productDetail.ccrz__UnitOfMeasure__c).plural__c;
                dataMap.put('pUOM', pUOM);
                
                res.data = dataMap;
            
            }
        }catch(Exception ex){
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'addToCartOO');

        }
        
        return res;
        
    } 
    
    /***************************************************************************************************************************************
      Method Name : addContractItem
      Description : addContractItem is to add the product with the contract prices to the cart
      Parameter   : cartId, contractId, quantity, contractItemList, price, skuId, contract 
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-339, OO- 56                                                             
      *************************************************************************************************************************************/
    public static List<ccrz__E_CartItem__c> addContractItem(Id cart, String contractId, Integer quantity
                                ,List<ccrz__E_CartItem__c> contractItemsList, Decimal price, String skuId, cc_oo_ContractPrice__c contract, String sid) {
        
        List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
        List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_LeadTime__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__r.ccrz__SKU__c=:skuId and cc_oo_Seller__c=:sid];              
        if(contractItemsList != null && !contractItemsList.isEmpty()) {
            Set<String> contractIdList = new Set<String>();
            for(ccrz__E_CartItem__c contractItem : contractItemsList) {
                contractIdList.add(String.valueOf(contractItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c)); 
            }
            Integer tonToLb=Integer.valueOf(LOLSettings__c.getValues('cc_oo_TON_TO_LB').Value__c);
            if(contractIdList.contains(contractId)) {
                for(ccrz__E_CartItem__c contractItem : contractItemsList) {
                    if(contractItem.ccrz__Product__r.ccrz__SKU__c.equals(skuId) && String.valueOf(contractItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c).equals(contractId)) {
                        //if(contractItem.cc_oo_ContractPrice__r.Name.equals(contractId)) {
                            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside contract price add when same price' + price + contractItem.ccrz__Price__c));
                            contractItem.ccrz__Quantity__c += quantity;
                            String typofPrd=contractItem.ccrz__Product__r.cc_oo_TypeOfProduct__c;
                            contractItem.cc_oo_IsListPrice__c = false;
                            contractItem.cc_oo_ContractPrice__c = contract.Id;
                            if(typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typofPrd.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
							        Decimal blkUnitPrice=contractItem.ccrz__Price__c/tonToLb;
							        contractItem.ccrz__SubAmount__c = blkUnitPrice * contractItem.ccrz__Quantity__c;
                        	}else{
                            		contractItem.ccrz__SubAmount__c = contractItem.ccrz__Price__c * contractItem.ccrz__Quantity__c;
                            }
                            cartItemList.add(contractItem);
                        //}   
                    }
                }
            } else {
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('New Creation for Contract'));
                cc_oo_HelperController.addNewCartItem(skuId,quantity,cart,price,false,contract.Id,sid,null,null,inventoryItems[0].cc_oo_LeadTime__c,contract.cc_oo_isfreightincluded__c,null);
            }
        }else {
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Inside contract price add new'));
            cc_oo_HelperController.addNewCartItem(skuId,quantity,cart,price,false,contract.Id,sid,null,null,inventoryItems[0].cc_oo_LeadTime__c,contract.cc_oo_isfreightincluded__c,null);                      
        }
        
        return cartItemList;
    }
    
   /*     @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductInventoryDtls(final ccrz.cc_RemoteActionContext ctx, String productId){

        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
           List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select ccrz__ProductItem__c,cc_oo_PalletSize__c,ccrz__ProductItem__r.ccrz__UnitOfMeasure__c 
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c = :productId AND ccrz__ProductItem__r.ccrz__UnitOfMeasure__c='BG'];
        
            if(inventoryItems!=null && inventoryItems.size()>0){
                res.data=inventoryItems.get(0);
                 res.success = true;
            }
            
              return res;
              
        }catch (Exception error)
        {
              ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',(error);
        }
        return null;
    }*/
    //US:144 Disable Add to Cart button for Unavaible/Discontinued project
    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult getStatus(final ccrz.cc_RemoteActionContext ctx,list<string> productId){
         ccrz.cc_CallContext.initRemoteContext(ctx);
         ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
         res.success= true;
        try
        { 
            
            list<ccrz__E_ProductInventoryItem__c> inventoryStatus = [select ccrz__Status__c
                                         from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c = :productId];
        
             if(inventoryStatus!=null && inventoryStatus.size()>0) {
                 if(inventoryStatus.get(0).ccrz__Status__c !='Available' ){
                   
                   res.success=true;
                   
                 }else{
                    res.success=false;
                 } 
             }else{
                 res.success=false;
             }
              return res;
              
        }catch (Exception error)
        {
              ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',(error);

        }
      return null;
    }*/
    
   /*@RemoteAction
   global static ccrz.cc_RemoteActionResult palletForBags(final ccrz.cc_RemoteActionContext ctx, Map<string, string> productDetailMap){
        
        String skuId;
        Integer quantity=1;
        Interger palletForBags=1;
        
        if(productDetailMap != null && !productDetailMap.isEmpty()){
            if(productDetailMap.containsKey('SKU') && productDetailMap.get('SKU') != null){
                skuId = productDetailMap.get('SKU');
            }
            if(productDetailMap.containsKey('Quantity') && productDetailMap.get('Quantity') != null){
                quantity = Integer.valueOf(productDetailMap.get('Quantity'));
            }
        } 
     
        List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select ccrz__ProductItem__c,Pallet_Size__c from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c = :skuId ];
                        
            if(!inventoryItems.isEmpty){
                for(ccrz__E_ProductInventoryItem__c inventoryItem : inventoryItems){
                    palletSize=inventoryItem.Pallet_Size__c;
        if(quantity>palletSize){
            Integer Quotient  = quantity/palletSize;
            Integer Remainder =mod(quantity, palletSize);
            if(Remainder==0){
                palletForBags=Quotient;
            }else if(Remainder<=palletSize){
                palletForBags=Quotient++;
            }else if(Remainder>palletSize){
                palletForBags=Quotient+2;   
            }
         }
       }
     res.success = true;
     res.data = palletForBags;
   } 
     return res;*/
     
      /***************************************************************************************************************************************
      Method Name : getProductInventoryDtls
      Description : getProductInventoryDtls is to get the ProductInventoryDtls for corresponding products
      Parameter   : cartId ,  sellerId 
                    cartId is the list of product Ids
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-49 -Allow for product minimum quantities and pallet increments.                                                               

                    
      *************************************************************************************************************************************/
      
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductDetails(final ccrz.cc_RemoteActionContext ctx, string productId, String sellerId){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus----');      
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        
        try
        { 
         ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus try----');
         Map<String, Object> dataMap = new Map<String, Object>();
         List<String> prdlst=new List<String>();
         prdlst.add(productId);
         //updated for common logic-US-2008
         List<ccrz__E_ProductInventoryItem__c> inventoryItems = cc_oo_HelperController.getProductInventoryItemDetails(prdlst,sellerId);
         if(inventoryItems != null && !inventoryItems.isEmpty()){
            if(inventoryItems[0].cc_oo_IsOnlyPalletProduct__c){
                    if(inventoryItems[0].cc_oo_PalletSize__c!=null && inventoryItems[0].cc_oo_MinQuantity__c!=null){
                        Integer minorder=inventoryItems[0].cc_oo_MinQuantity__c >inventoryItems[0].cc_oo_PalletSize__c?Integer.valueOf(inventoryItems[0].cc_oo_MinQuantity__c):Integer.valueOf(inventoryItems[0].cc_oo_PalletSize__c);
                        dataMap.put('MinOrder',minorder);
                    }else {
                        dataMap.put('MinOrder',inventoryItems[0].cc_oo_PalletSize__c);
                    }
             }else{
                dataMap.put('MinOrder',inventoryItems[0].cc_oo_MinQuantity__c);
             }
              dataMap.put('fullPalletReq',inventoryItems[0].cc_oo_IsOnlyPalletProduct__c);
              String singularUOM=inventoryItems[0].ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
              String pluralUOM = cc_oo_pluralUOM__c.getValues(singularUOM).plural__c;
              dataMap.put('pluralUOM',pluralUOM);
              //to display Unit of discription-US-2008
              dataMap.put('UOMDesc',inventoryItems[0].ccrz__ProductItem__r.cc_oo_UoMDesc__c);
              //US:144 Disable Add to Cart button for Unavaible/Discontinued project
              dataMap.put('Status',inventoryItems[0].ccrz__Status__c);
              dataMap.put('AvailabilityMessage',inventoryItems[0].ccrz__AvailabilityMessage__c);
              //updated overidden code defect-OO-2720
              dataMap.put('PalletSize',inventoryItems[0].cc_oo_PalletSize__c);
              dataMap.put('UOM',inventoryItems[0].ccrz__ProductItem__r.ccrz__UnitOfMeasure__c);
              dataMap.put('TypeOfProduct',inventoryItems[0].ccrz__ProductItem__r.cc_oo_TypeOfProduct__c);
              dataMap.put('MinQuantity',inventoryItems[0].cc_oo_MinQuantity__c);
              res.success = true;
          }
          res.data = dataMap;
          ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus try end----');
        }catch (Exception ex){
           cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductDetails');
           res.data= ex.getMessage();
           
        }
       return res;
    } 
   
 
    
    /***************************************************************************************************************************************
      Method Name : getProductPricing
      Description : getProductPricing is to get the list price and contract prices corresponding to the product.
      Parameter   : productId ,  sellerId
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-56 - To fetch and display list price and contract price for products.                                                               

                    
      *************************************************************************************************************************************/    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductPricing(final ccrz.cc_RemoteActionContext ctx, String productId, String sellerId, String cartId, String selectedShipToId, String shipDate){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing----'); 
        
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali SellerId' + sellerId));
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        Map<String, Object> dataMap = new Map<String, Object>();
        List<cc_oo_ErrorLog__c> logs = new List<cc_oo_ErrorLog__c>();
        try
        { 
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing try----');
            //Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
            // Creation of new Cart when cart is null
            if(cartId == null || cartId == '' || cartId == '{}' || cartId.toLowercase()  == 'undefined') {
                ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(sellerId ,selectedShipToId,false );
                if(cartReturn.ccrz__RequestDate__c == null) {
                    cartReturn.ccrz__RequestDate__c =  Date.parse(shipDate);
                }
                update cartReturn;
                cartId  = String.valueOf(cartReturn.ccrz__EncryptedId__c);
            }
            
            List<ccrz__E_Cart__c> cartDetails = [SELECT c.ccrz__EncryptedId__c,c.Id, c.cc_oo_Seller__r.ccrz__sellerId__c,
                                                    cc_oo_ShipToAccount__c, ccrz__RequestDate__c,
                                                     (SELECT Id,cc_oo_IsListPrice__c
                                                    , ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c
                                                    ,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c FROM ccrz__E_CartItems__r) 
                                                    FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartId LIMIT 1];
        
            Id contactId = ccrz.cc_CallContext.currContact.Id;
            
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Pricing Test'+ selectedShipToId));
            String accountId = selectedShipToId;
            //OO-1883
            Id shipToSFID = cartDetails[0].cc_oo_ShipToAccount__c;
            string sellerCode = cartDetails[0].cc_oo_Seller__r.ccrz__sellerId__c;
            string productSKU;
            string productUOM;
            string productUOMDesc;//US-2377
            String producttype;
            //US - 2429
            /*String dealerAccount = '';
            List<Contact> ParentAccount=new List<Contact>();
            ParentAccount=[SELECT Account.ID,Account.ParentId FROM Contact WHERE Id=:contactId];
            for(Contact c:ParentAccount){
                if(c.Account.ParentId!=NULL){
                    dealerAccount=c.Account.ParentId;
                    break;
                } else {
                    dealerAccount=c.Account.ID;
                    break;
                }
            } */
            //US - 2429
            //US - 2377
            List<ccrz__E_ProductInventoryItem__c> inventoryStatus = [SELECT ccrz__Status__c, cc_oo_PalletSize__c,cc_oo_IsOnlyPalletProduct__c,
                                                                                        ccrz__ProductItem__r.ccrz__sku__c,ccrz__ProductItem__r.ccrz__UnitOfMeasure__c ,ccrz__ProductItem__r.cc_oo_UoMDesc__c,
                                                                                        ccrz__ProductItem__r.cc_oo_TypeOfProduct__c 
                                                                                        FROM ccrz__E_ProductInventoryItem__c
                                                                                        WHERE ccrz__ProductItem__c = :productId
                                                                                        AND cc_oo_Seller__c = :sellerId];
            
             if(!inventoryStatus.isEmpty()) {
                productSKU = inventoryStatus.get(0).ccrz__ProductItem__r.ccrz__sku__c;
                productUOM = inventoryStatus.get(0).ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
                productUOMDesc = inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_UoMDesc__c; //US-2377
                producttype= inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;
                if(inventoryStatus.get(0).ccrz__Status__c =='Available' ){
                    
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali priceList'));
                    Date expireLimit = Date.today();
                    List<cc_oo_PriceList__c> listPriceOption = [SELECT Id, cc_oo_NetListPrice__c,cc_oo_isfreightincluded__c
                                                                            //, cc_oo_PalletPrice__c// US - 3010
                                                                            /*cc_oo_Product__r.ccrz__UnitOfMeasure__c,
                                                                            cc_oo_Product__r.cc_oo_UoMDesc__c,
                                                                            cc_oo_Product__r.ccrz__SKU__c,
                                                                            cc_oo_Seller__r.ccrz__SellerId__c,
                                                                            cc_oo_ShipTo__r.AccountNumber*/
                                                                            FROM cc_oo_PriceList__c 
                                                                            WHERE cc_oo_Seller__c=:sellerId 
                                                                            AND cc_oo_ShipTo__c =: shipToSFID
                                                                            AND cc_oo_Product__c=:productId
                                                                            AND cc_oo_EffectiveDate__c <=:expireLimit
                                                                            /*AND cc_oo_ExpirationDate__c >=:expireLimit
                                                                            ORDER BY cc_oo_ExpirationDate__c ASC*/];
                    //ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali priceOption' + priceOption );
                    Map<String, Object> listPrice = new Map<String, Object>();
                    cc_oo_PriceList__c priceOption = new cc_oo_PriceList__c();
                    cc_oo_ServiceData__c priceServiceData = cc_oo_ServiceData__c.getValues('RetrievePrice');
                    string jdeDownMsg = ccrz.cc_CallContext.pageLabels.get('JDEDownPirceMessage');//OO-3125
                    if(listPriceOption.size() > 0){
                        priceOption = listPriceOption[0];                        
                        if(priceOption != null) {
                            if(priceOption.cc_oo_NetListPrice__c!= null && priceOption.cc_oo_NetListPrice__c != 0) {
                                listPrice.put('price', String.valueOf(priceOption.cc_oo_NetListPrice__c));                         
                            }else{
                                //if(inventoryStatus.get(0).cc_oo_IsOnlyPalletProduct__c == false){ //OO-2515
                                    //OO-324 get JDE Price - start
                                    cc_oo_JDEPriceRequest.Params paramsReq = new cc_oo_JDEPriceRequest.Params();
                                    paramsReq.AN8_ShipToNUmber = accountId; //priceOption.cc_oo_ShipTo__r.AccountNumber;//OO-4183
                                    paramsReq.MCU_BranchPlant = sellerCode; //priceOption.cc_oo_Seller__r.ccrz__SellerId__c;//OO-4183
                                    paramsReq.DCTO_OrderType = priceServiceData.cc_oo_OrderType__c;
                                    paramsReq.LITM_ItemNumber = productSKU; //priceOption.cc_oo_Product__r.ccrz__SKU__c;//OO-4183
                                    paramsReq.VERS_P4210Version = priceServiceData.cc_oo_P4210Version__c;
                                    //paramsReq.szFreightHandlingCode = priceServiceData.cc_oo_szFreightHandlingCode__c;
    
                                    
                                    cc_oo_JDEPriceRequest priceReq = new cc_oo_JDEPriceRequest();
                                    priceReq.params = paramsReq;
    
                                    //cc_oo_JDEPriceResponse resp = cc_oo_servicePriceCallOut.getProductPrice(priceReq);
                                    Map<string, Object> responseData = cc_oo_servicePriceCallOut.getProductPrice(priceReq);

                                    cc_oo_JDEPriceResponse resp = (cc_oo_JDEPriceResponse)responseData.get('response');
                                    if(responseData.get('logs') != null){
                                        logs.addAll((List<cc_oo_ErrorLog__c>)responseData.get('logs'));
                                    }
                                    if(resp != null){
                                        if(resp.callMethod.errors == null){
                                            if(resp.callMethod.Params != null){//OO-3125
                                            	String SecUOM=resp.callMethod.Params.UOM_Pricing;
                                            	//defect#4543
 												 if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                                    listPrice.put('price', String.valueOf((decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2)));//Pricing Update -4392
                                                    priceOption.cc_oo_IsJDEPriceUpdated__c = true;
                                                    priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2);//Pricing Update -4392
                                                }else{
                                                    listPrice.put('price', String.valueOf((decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2)));//Pricing Update - Shri
                                                    priceOption.cc_oo_IsJDEPriceUpdated__c = true;
                                                    priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2);//Pricing Update - Shri
                                                }
                                                update priceOption;
                                            }else{//OO-3125
                                                listPrice.put('jDEPrice', jdeDownMsg);
                                            }
                                        }else{//OO-3125
                                            listPrice.put('jDEPrice', jdeDownMsg);
                                        }
                                    }else{//OO-3125
                                        listPrice.put('jDEPrice', jdeDownMsg);
                                    }//OO-3125//OO-324 get JDE Price - Ends
                                //}//OO-2515
                                
                            }
                            // US - 3010
                            /*if(priceOption.cc_oo_PalletPrice__c != null) {
                                listPrice.put('palletPrice', String.valueOf(priceOption.cc_oo_PalletPrice__c));                         
                            }*/
                            
                            listPrice.put('palletQuantity', String.valueOf(inventoryStatus.get(0).cc_oo_PalletSize__c));
                            listPrice.put('uom', productUOM);//priceOption.cc_oo_Product__r.ccrz__UnitOfMeasure__c);//OO-4183
                            listPrice.put('onlyPallet', inventoryStatus.get(0).cc_oo_IsOnlyPalletProduct__c);
                            if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK'))|| producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                            	 listPrice.put('uomDesc', ccrz.cc_CallContext.pageLabels.get('TON'));
                            }else{
                           		 listPrice.put('uomDesc', productUOMDesc);//priceOption.cc_oo_Product__r.cc_oo_UoMDesc__c);//OO-4183
                            }
                            listPrice.put('producttype', producttype);
                        }
                    }else{

                        //if(inventoryStatus.get(0).cc_oo_IsOnlyPalletProduct__c == false){ //OO-2515
                            //OO-1883 get JDE Price - start
                            cc_oo_JDEPriceRequest.Params paramsReq = new cc_oo_JDEPriceRequest.Params();
                            paramsReq.AN8_ShipToNUmber = selectedShipToId;
                            paramsReq.MCU_BranchPlant = sellerCode;
                            paramsReq.DCTO_OrderType = priceServiceData.cc_oo_OrderType__c;
                            paramsReq.LITM_ItemNumber = productSKU;
                            paramsReq.VERS_P4210Version = priceServiceData.cc_oo_P4210Version__c;
                            //paramsReq.szFreightHandlingCode = priceServiceData.cc_oo_szFreightHandlingCode__c;
    
                            
                            cc_oo_JDEPriceRequest priceReq = new cc_oo_JDEPriceRequest();
                            priceReq.params = paramsReq;
    
                            //cc_oo_JDEPriceResponse resp = cc_oo_servicePriceCallOut.getProductPrice(priceReq);
                            Map<string, Object> responseData = cc_oo_servicePriceCallOut.getProductPrice(priceReq);

                            cc_oo_JDEPriceResponse resp = (cc_oo_JDEPriceResponse)responseData.get('response');
                            if(responseData.get('logs') != null){
                                logs.addAll((List<cc_oo_ErrorLog__c>)responseData.get('logs'));
                            }
                            if(resp != null){
                                if(resp.callMethod.errors == null){
                                    if(resp.callMethod.Params != null){//OO-3125
                                    	String SecUOM=resp.callMethod.Params.UOM_Pricing;
                                    	//defect#4543
 										 if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                            listPrice.put('price',String.valueOf((decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2)));//Pricing Update -4392
                                        }else{
                                            listPrice.put('price', String.valueOf((decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2)));//Pricing Update - Shri
                                        }
                                        listPrice.put('palletQuantity', String.valueOf(inventoryStatus.get(0).cc_oo_PalletSize__c));
                                        listPrice.put('uom', productUOM);
                                        listPrice.put('onlyPallet', inventoryStatus.get(0).cc_oo_IsOnlyPalletProduct__c);
                                        if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK'))|| producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                			 listPrice.put('uomDesc', ccrz.cc_CallContext.pageLabels.get('TON'));
                            			}else{
                                       	 listPrice.put('uomDesc', productUOMDesc);
                                        }
                                        listPrice.put('producttype', producttype);
                                        //Create new PriceList record
                                        priceOption.cc_oo_Seller__c = sellerId;
                                        priceOption.cc_oo_Product__c = productId;
                                        priceOption.cc_oo_ShipTo__c = shipToSFID; 
                                        priceOption.cc_oo_EffectiveDate__c = Date.today(); 
                                        //priceOption.cc_oo_ExpirationDate__c = Date.today() + 7; 
                                        priceOption.cc_oo_IsJDEPriceUpdated__c = true;
                                        //defect#4543
 										if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                            listPrice.put('price', String.valueOf((decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2)));//Pricing Update -4392
                                            priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2);
                                        }else{
                                        	listPrice.put('price',String.valueOf((decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2)));
                                            priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2);//Pricing Update - Shri
                                        }
                                        insert priceOption;
                                    }else{//OO-3125
                                        listPrice.put('jDEPrice', jdeDownMsg);
                                    }
                                }else{//OO-3125
                                    listPrice.put('jDEPrice', jdeDownMsg);
                                }
                            }else{
                                listPrice.put('jDEPrice', jdeDownMsg);
                            }//OO-3125
                            //OO-1883 get JDE Price - Ends
                        //}//OO-2515
                    }
                    
                    //OO-1180-  ShipDate and Contract expiredate check
                    //US - 2377
                    expireLimit = cartDetails[0].ccrz__RequestDate__c;
                    System.debug('Account to start' + accountId + 'Product' + productId + 'Seller' + sellerId);
                    List<cc_oo_ContractPrice__c> contractPriceList = [SELECT Name, cc_oo_ExpireDate__c, cc_oo_ContractPrice__c,cc_oo_QuantityUpdateDate__c,
                                                                                        cc_oo_ContractUoM__c, cc_oo_ConversionValue__c,
                                                                                        cc_oo_isfreightincluded__c, //US - 1773
                                                                                        cc_oo_ContractUoMDesc__c,cc_oo_AvailabilityQtyUoMContract__c,
                                                                                        /*cc_oo_ContractQty__c,*/ cc_oo_AvailabilityQty__c,
                                                                                        cc_oo_EffectiveDate__c, cc_oo_EndUserName__c,
                                                                                        cc_oo_ContractNumber__c
                                                                                        FROM cc_oo_ContractPrice__c
                                                                                        WHERE cc_oo_Product__c = :productId 
                                                                                        AND cc_oo_Seller__c=:sellerId
                                                                                        AND cc_oo_ShipToNumber__c =: shipToSFID //OO-4183
                                                                                        AND cc_oo_AvailabilityQty__c>0
                                                                                        /*AND cc_oo_ContractQty__c>0*/
                                                                                        AND cc_oo_EffectiveDate__c <=:expireLimit
                                                                                        AND cc_oo_ExpireDate__c >=:expireLimit
                                                                                        ORDER BY cc_oo_ExpireDate__c ASC];
                    
                    //Map<String, Integer> contractBalance = new Map<String, Integer>();
                    /*for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r) {
                        System.debug('cartItem' + cartItem.ccrz__Product__r.ccrz__SKU__c + 'product' + productId + !cartItem.cc_oo_IsListPrice__c);
                        if((String.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c).equals(priceOption.cc_oo_Product__r.ccrz__SKU__c)) && !cartItem.cc_oo_IsListPrice__c) {
                            System.debug('Inside to add contractbalance');
                            contractBalance.put(cartItem.cc_oo_ContractPrice__r.Name, Integer.valueOf(cartItem.ccrz__Quantity__c));
                        }
                    } */                                                                   
                    System.debug('contract' + contractPriceList );
                    List<cc_oo_ContractPrice> contractPrice = new List<cc_oo_ContractPrice> ();
                    if(!contractPriceList.isEmpty()) {
                        cc_oo_ContractDetail detail;
                        cc_oo_ContractPrice contract;
                        String lastUpdated, expiry_Date, effective_Date ;
                        Date Myexpiry_Date, Myeffective_Date;
                        Decimal roundedPrice; 
                        for(cc_oo_ContractPrice__c contractPrices : contractPriceList) {
                            contract = new cc_oo_ContractPrice();
                            detail = new cc_oo_ContractDetail();
                            contract.contractId = String.valueOf(contractPrices.cc_oo_ContractNumber__c);
                            lastUpdated='';
                            if(contractPrices!=null && contractPrices.cc_oo_QuantityUpdateDate__c!=null){
                            String lastModified=String.valueOf(contractPrices.cc_oo_QuantityUpdateDate__c);
                            DateTime myFinalDate = DateTime.valueOf(lastModified);
                            lastUpdated=myFinalDate.format('MM/dd/YYYY HH:mm');
                            }
                            detail.lastModifiedDate=lastUpdated;
                            expiry_Date = String.valueOf(contractPrices.cc_oo_ExpireDate__c);
                            Myexpiry_Date = Date.valueOf(expiry_Date);
                            contract.expiryDate=Myexpiry_Date.format();
                            detail.isfreightincluded = contractPrices.cc_oo_isfreightincluded__c;
                            
                            effective_Date =String.valueOf(contractPrices.cc_oo_EffectiveDate__c);
                            Myeffective_Date = Date.valueOf(effective_Date);
                            detail.effectiveDate=Myeffective_Date.format();
                            String typeofprd=inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;
                           	detail.productUOMDesc = inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_UoMDesc__c;//US-2377
                            detail.AvailabilityQtyUoMContract =String.valueOf(contractPrices.cc_oo_AvailabilityQtyUoMContract__c);//US-2377                                                      
                            detail.availableBalance=String.valueOf(contractPrices.cc_oo_AvailabilityQty__c);
                            detail.contractUom = String.valueOf(contractPrices.cc_oo_ContractUoMDesc__c);
                            detail.jdeEndUser = String.valueOf(contractPrices.cc_oo_EndUserName__c);
                            contract.contractDetails=detail;
                            //dataMap.put(contract.contractId,contract);
                            //contract.contractQty = Integer.valueOf(contractPrices.cc_oo_ContractQty__c);
                            System.debug('Hi' + contractPrices.cc_oo_AvailabilityQty__c);
                            /*if(contractBalance != null) {
                                if(contractBalance.get(contractPrices.Name) >= (contractPrices.cc_oo_AvailabilityQty__c)) {
                                    contract.disableContract = true;
                                } else {
                                    contract.disableContract = false;
                                }
                            } else {
                                contract.disableContract = false;
                            }*/
                            /*if(!((priceOption.cc_oo_Product__r.ccrz__UnitOfMeasure__c).equals(contractPrices.cc_oo_ContractUoM__c))) {
                                roundedPrice=(contractPrices.cc_oo_ContractPrice__c)/(contractPrices.cc_oo_ConversionValue__c);
                                roundedPrice=roundedPrice.setscale(2);
                                contract.contractPrice = String.valueOf(roundedPrice);
                                //contract.contractPrice = String.valueOf((contractPrices.cc_oo_ContractPrice__c)/contractPrices.cc_oo_ConversionValue__c);
                            } else {*/
                                contract.contractPrice = String.valueOf(contractPrices.cc_oo_ContractPrice__c); 
                            //}                            
                            contractPrice.add(contract);
                        }
                    }             
                    
                    if(logs.size() > 0){
                        insert logs;
                    }
                    res.success = true;
                    dataMap.put('listPrice', listPrice);
                    dataMap.put('contractPrice', contractPrice);
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('dataMap' + dataMap ));
                    res.data = dataMap;
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing try end----');
                    
                 }
             }
        }catch (Exception ex)
        {
          cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductPricing');
        }
        return res; 
    }

    /***************************************************************************************************************************************
      Method Name : checkProductPricing
      Description : checkProductPricing is to check the list price 
      Parameter   : productId ,  sellerId, shipToId
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1883 - To check the availibilty of NetListPrice
    ****************************************************************************************************************************************/  
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkProductPricing(final ccrz.cc_RemoteActionContext ctx, String productId, String sellerId,String selectedShipToId){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing----');
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;

        try{
            List<ccrz__E_ProductInventoryItem__c> inventoryStatus = [SELECT ccrz__Status__c, Id, ccrz__ProductItem__r.ccrz__sku__c, cc_oo_IsOnlyPalletProduct__c                                                                                        
                                                                                        FROM ccrz__E_ProductInventoryItem__c
                                                                                        WHERE ccrz__ProductItem__r.ccrz__sku__c = :productId
                                                                                        AND cc_oo_Seller__c = :sellerId
                                                                                        AND ccrz__Status__c = 'Available'];
            if(inventoryStatus.size() > 0 && inventoryStatus[0].ccrz__ProductItem__r.ccrz__sku__c == productId && inventoryStatus.get(0).cc_oo_IsOnlyPalletProduct__c == false){//OO-2515                                                                            
                    Date expireLimit = Date.today();
                    List<cc_oo_PriceList__c> listPriceOption = [SELECT cc_oo_NetListPrice__c, id,cc_oo_isfreightincluded__c
                                                                            FROM cc_oo_PriceList__c 
                                                                            WHERE cc_oo_Seller__c=:sellerId 
                                                                            AND cc_oo_ShipTo__r.AccountNumber=:selectedShipToId
                                                                            AND cc_oo_Product__r.ccrz__sku__c=:productId
                                                                            AND cc_oo_EffectiveDate__c <=:expireLimit];
                                                                            /*AND cc_oo_ExpirationDate__c >=:expireLimit
                                                                            ORDER BY cc_oo_ExpirationDate__c ASC];*/
                    if(listPriceOption.size() > 0){   
                        cc_oo_PriceList__c priceOption = listPriceOption[0];                                                                     
                        if(priceOption.cc_oo_NetListPrice__c != null && priceOption.cc_oo_NetListPrice__c != 0){
                            res.data = true;
                            res.success = true;
                        }else{
                            res.success = true;
                            res.data = false;
                        }
                    }else{
                        res.success = true;
                        res.data = false;
                    }
            }
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'checkProductPricing');
        }
        return res;
    }
     //US-2008-minqty error-validate secondary cart qty.
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getSecondaryCartProductQtyDetails(final ccrz.cc_RemoteActionContext ctx, String cartId){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing----');
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        Map<String,Object> secPrdQtyMap;
        List<ccrz__E_CartItem__c> secondaryCartList;
        try{
        List<ccrz__E_Cart__c> cart1=[select cc_oo_SplitCart__c from  ccrz__E_Cart__c where ccrz__EncryptedId__c =: cartId and ccrz__CartStatus__c='Open'];
            if(cart1.size() != 0 && cart1 != null && !cart1.isEmpty() && cart1[0].cc_oo_SplitCart__c != null){
                secondaryCartList = [select id, ccrz__Product__c,ccrz__Product__r.ccrz__sku__c,
                                                        ccrz__Quantity__c from ccrz__E_CartItem__c where ccrz__Cart__c =:cart1[0].cc_oo_SplitCart__c];
            }
            if(secondaryCartList!=null && secondaryCartList.size() != 0 && !secondaryCartList.isEmpty()){
                for(ccrz__E_CartItem__c secondaryCart:secondaryCartList){
                    if(secPrdQtyMap == null){
                                //create map of product sku and qty for secondary cart
                                secPrdQtyMap=new Map<String,Object>();
                                secPrdQtyMap.put(secondaryCart.ccrz__Product__r.ccrz__sku__c,secondaryCart.ccrz__Quantity__c);
                             }else{ 
                                 if(!secPrdQtyMap.containsKey(secondaryCart.ccrz__Product__r.ccrz__sku__c)){
                                    secPrdQtyMap.put(secondaryCart.ccrz__Product__r.ccrz__sku__c,secondaryCart.ccrz__Quantity__c);
                                 }else{
                                    Integer prevQty=Integer.valueOf(secPrdQtyMap.get(secondaryCart.ccrz__Product__r.ccrz__sku__c));
                                    Integer currentQty=Integer.valueOf(secondaryCart.ccrz__Quantity__c);
                                    Integer total=prevQty+currentQty;
                                    secPrdQtyMap.put(secondaryCart.ccrz__Product__r.ccrz__sku__c,total);
                                 }
                    }
                }
                res.success=true;
                res.data=secPrdQtyMap;
                system.debug('secondMapValueAdded'+secPrdQtyMap);
            }
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getSecondaryCartProductQtyDetails');
        }
        return res;
    }
    
    public class cc_oo_ContractPrice {
        public String contractId{get; set;}
        public String contractPrice{get; set;}
        public String expiryDate{get; set;}
        public Integer contractQty{get; set;}
        public Boolean disableContract{get; set;}
        public cc_oo_ContractDetail contractDetails{get; set;}
    }
    
        public class cc_oo_ContractDetail {
        public String effectiveDate{get; set;}
        public String availableBalance{get; set;}
        public String contractUom{get; set;}
        public String jdeEndUser{get; set;}
        public String lastModifiedDate{get; set;}
        public String AvailabilityQtyUoMContract{get;set;}//US - 2377
        public String productUOMDesc{get; set;}//US-2377-Rajeev       
        public Boolean isfreightincluded{get; set;} // US - 1773
        
        
    } 
    
    //US - 56 - End   
    /***************************************************************************************************************************************
      Method Name : getProductPricingNew
      Description : getProductPricingNew is to get the list price and contract prices corresponding to the product- Changes to load the price
      Parameter   : productId ,  sellerId
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-56 - To fetch and display list price and contract price for products.                                                               

                    
    *************************************************************************************************************************************/    
    public Map<String, Object> dataMapProduct{get;set;}
    public string dataMapProductString {get;set;}
    public string dataLogs {get; set;}
    public void getProductPricingNew(String productId, String cartId, String shipDate){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing----'); 
        system.debug('cartId--->' + cartId);

        dataMapProduct = new Map<String, Object>();
        List<cc_oo_ErrorLog__c> logs = new List<cc_oo_ErrorLog__c>();
        try
        { 
            
            List<ccrz__E_Cart__c> cartDetails = [SELECT c.ccrz__EncryptedId__c,c.Id, c.cc_oo_Seller__r.ccrz__sellerId__c,
                                                    cc_oo_ShipToAccount__c,cc_oo_ShipToAccount__r.AccountNumber, ccrz__RequestDate__c,cc_oo_Seller__c,
                                                     (SELECT Id,cc_oo_IsListPrice__c
                                                    , ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c
                                                    ,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c FROM ccrz__E_CartItems__r) 
                                                    FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartId LIMIT 1];
                                                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing try----');
            /* 4183 */
            string selectedShipToId = '';
            string sellerId = '';
            if(cartDetails.size() > 0){
                selectedShipToId = cartDetails[0].cc_oo_ShipToAccount__r.AccountNumber;
                sellerId = cartDetails[0].cc_oo_Seller__c;
            }
            /* 4183 */
            
            //Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
            // Creation of new Cart when cart is null
            if(cartId == null || cartId == '' || cartId == '{}' || cartId.toLowercase()  == 'undefined') {
                ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(sellerId ,selectedShipToId,false );
                if(cartReturn.ccrz__RequestDate__c == null) {
                    cartReturn.ccrz__RequestDate__c =  Date.parse(shipDate);
                }
                update cartReturn;
                cartId  = String.valueOf(cartReturn.ccrz__EncryptedId__c);
            }
        
            Id contactId = ccrz.cc_CallContext.currContact.Id;
            
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Pricing Test'+ selectedShipToId));
            String accountId = selectedShipToId;
            //OO-1883
            Id shipToSFID = cartDetails[0].cc_oo_ShipToAccount__c;
            string sellerCode = cartDetails[0].cc_oo_Seller__r.ccrz__sellerId__c;
            string productSKU;
            string productUOM;
            string productUOMDesc;//US-2377
            String producttype;

            cc_oo_JDEPrice jdeObj = new cc_oo_JDEPrice();
            jdeObj.sellerId = cartDetails[0].cc_oo_Seller__r.ccrz__sellerId__c;
            jdeObj.sellerSFId = cartDetails[0].cc_oo_Seller__c;
            jdeObj.shipToId = cartDetails[0].cc_oo_ShipToAccount__r.AccountNumber;
            jdeObj.shipToSFId = cartDetails[0].cc_oo_ShipToAccount__c;
            
            //US - 2429
            /*String dealerAccount = '';
            List<Contact> ParentAccount=new List<Contact>();
            ParentAccount=[SELECT Account.ID,Account.ParentId FROM Contact WHERE Id=:contactId];
            for(Contact c:ParentAccount){
                if(c.Account.ParentId!=NULL){
                    dealerAccount=c.Account.ParentId;
                    break;
                } else {
                    dealerAccount=c.Account.ID;
                    break;
                }
            } */
            //US - 2429
            //US - 2377
            List<ccrz__E_ProductInventoryItem__c> inventoryStatus = [SELECT ccrz__Status__c, cc_oo_PalletSize__c,cc_oo_IsOnlyPalletProduct__c,
                                                                                        ccrz__ProductItem__r.ccrz__sku__c,ccrz__ProductItem__r.ccrz__UnitOfMeasure__c ,ccrz__ProductItem__r.cc_oo_UoMDesc__c,
                                                                                        ccrz__ProductItem__r.cc_oo_TypeOfProduct__c 
                                                                                        FROM ccrz__E_ProductInventoryItem__c
                                                                                        WHERE ccrz__ProductItem__c = :productId
                                                                                        AND cc_oo_Seller__c = :sellerId];
            
            if(!inventoryStatus.isEmpty()) {
                productSKU = inventoryStatus.get(0).ccrz__ProductItem__r.ccrz__sku__c;
                productUOM = inventoryStatus.get(0).ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
                productUOMDesc = inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_UoMDesc__c; //US-2377
                producttype = inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;

                jdeObj.skuId = inventoryStatus.get(0).ccrz__ProductItem__r.ccrz__sku__c;
                jdeObj.skuSFId = inventoryStatus.get(0).ccrz__ProductItem__c;
                jdeObj.typeOfProduct = inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;
                Map<String, Object> listPrice = new Map<String, Object>();
                List<cc_oo_ContractPrice> contractPrice = new List<cc_oo_ContractPrice> ();

                listPrice.put('palletQuantity', String.valueOf(inventoryStatus.get(0).cc_oo_PalletSize__c));
                listPrice.put('uom', productUOM);
                listPrice.put('onlyPallet', inventoryStatus.get(0).cc_oo_IsOnlyPalletProduct__c);                               
                if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK'))|| producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                    listPrice.put('uomDesc', ccrz.cc_CallContext.pageLabels.get('TON'));
                }else{
                    listPrice.put('uomDesc', productUOMDesc);//priceOption.cc_oo_Product__r.cc_oo_UoMDesc__c);//OO-4183
                }
                listPrice.put('producttype', producttype);

                if(inventoryStatus.get(0).ccrz__Status__c =='Available' ){
                    
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('Piyali priceList'));
                    Date expireLimit = Date.today();
                    List<cc_oo_PriceList__c> listPriceOption = [SELECT Id, cc_oo_NetListPrice__c,cc_oo_isfreightincluded__c
                                                                            FROM cc_oo_PriceList__c 
                                                                            WHERE cc_oo_Seller__c=:sellerId 
                                                                            AND cc_oo_ShipTo__c =: shipToSFID
                                                                            AND cc_oo_Product__c=:productId
                                                                            AND cc_oo_EffectiveDate__c <=:expireLimit];
                                                                            
                    cc_oo_PriceList__c priceOption = new cc_oo_PriceList__c();
                    cc_oo_ServiceData__c priceServiceData = cc_oo_ServiceData__c.getValues('RetrievePrice');
                    string jdeDownMsg = ccrz.cc_CallContext.pageLabels.get('JDEDownPirceMessage');//OO-3125
                    system.debug('listPriceOption-->' + listPriceOption);
                    if(listPriceOption.size() > 0){
                        priceOption = listPriceOption[0];                        
                        if(priceOption != null) {
                            if(priceOption.cc_oo_NetListPrice__c!= null && priceOption.cc_oo_NetListPrice__c != 0 ) {
                                listPrice.put('price', String.valueOf(priceOption.cc_oo_NetListPrice__c));
                                listPrice.put('isfreightincluded', priceOption.cc_oo_isfreightincluded__c);  
                            }else{
                                jdeObj.priceListId = priceOption.Id;
                            }
                        }
                    

                    
                        //OO-1180-  ShipDate and Contract expiredate check
                        //US - 2377
                        expireLimit = cartDetails[0].ccrz__RequestDate__c;
                        System.debug('Account to start' + accountId + 'Product' + productId + 'Seller' + sellerId);
                        List<cc_oo_ContractPrice__c> contractPriceList = [SELECT Name, cc_oo_ExpireDate__c, cc_oo_ContractPrice__c,cc_oo_QuantityUpdateDate__c,
                                                                                            cc_oo_ContractUoM__c, cc_oo_ConversionValue__c,
                                                                                            cc_oo_isfreightincluded__c, //US - 1773
                                                                                            cc_oo_ContractUoMDesc__c,cc_oo_AvailabilityQtyUoMContract__c,
                                                                                            /*cc_oo_ContractQty__c,*/ cc_oo_AvailabilityQty__c,
                                                                                            cc_oo_EffectiveDate__c, cc_oo_EndUserName__c,
                                                                                            cc_oo_ContractNumber__c
                                                                                            FROM cc_oo_ContractPrice__c
                                                                                            WHERE cc_oo_Product__c = :productId 
                                                                                            AND cc_oo_Seller__c=:sellerId
                                                                                            AND cc_oo_ShipToNumber__c =: shipToSFID //OO-4183
                                                                                            AND cc_oo_AvailabilityQty__c>0
                                                                                            /*AND cc_oo_ContractQty__c>0*/
                                                                                            AND cc_oo_EffectiveDate__c <=:expireLimit
                                                                                            AND cc_oo_ExpireDate__c >=:expireLimit
                                                                                            ORDER BY cc_oo_ExpireDate__c ASC];
                        
                        //Map<String, Integer> contractBalance = new Map<String, Integer>();
                        /*for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r) {
                            System.debug('cartItem' + cartItem.ccrz__Product__r.ccrz__SKU__c + 'product' + productId + !cartItem.cc_oo_IsListPrice__c);
                            if((String.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c).equals(priceOption.cc_oo_Product__r.ccrz__SKU__c)) && !cartItem.cc_oo_IsListPrice__c) {
                                System.debug('Inside to add contractbalance');
                                contractBalance.put(cartItem.cc_oo_ContractPrice__r.Name, Integer.valueOf(cartItem.ccrz__Quantity__c));
                            }
                        } */                                                                   
                        System.debug('contract' + contractPriceList );
                        
                        if(!contractPriceList.isEmpty()) {
                            cc_oo_ContractDetail detail;
                            cc_oo_ContractPrice contract;
                            String lastUpdated, expiry_Date, effective_Date ;
                            Date Myexpiry_Date, Myeffective_Date;
                            Decimal roundedPrice; 
                            for(cc_oo_ContractPrice__c contractPrices : contractPriceList) {
                                contract = new cc_oo_ContractPrice();
                                detail = new cc_oo_ContractDetail();
                                contract.contractId = String.valueOf(contractPrices.cc_oo_ContractNumber__c);
                                lastUpdated='';
                                if(contractPrices!=null && contractPrices.cc_oo_QuantityUpdateDate__c!=null){
                                String lastModified=String.valueOf(contractPrices.cc_oo_QuantityUpdateDate__c);
                                DateTime myFinalDate = DateTime.valueOf(lastModified);
                                lastUpdated=myFinalDate.format('MM/dd/YYYY HH:mm');
                                }
                                detail.lastModifiedDate=lastUpdated;
                                expiry_Date = String.valueOf(contractPrices.cc_oo_ExpireDate__c);
                                Myexpiry_Date = Date.valueOf(expiry_Date);
                                contract.expiryDate=Myexpiry_Date.format();
                                detail.isfreightincluded = contractPrices.cc_oo_isfreightincluded__c;
                                
                                effective_Date =String.valueOf(contractPrices.cc_oo_EffectiveDate__c);
                                Myeffective_Date = Date.valueOf(effective_Date);
                                detail.effectiveDate=Myeffective_Date.format();
                                String typeofprd=inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;
                                 detail.productUOMDesc = inventoryStatus.get(0).ccrz__ProductItem__r.cc_oo_UoMDesc__c;//US-2377
                                detail.AvailabilityQtyUoMContract =String.valueOf(contractPrices.cc_oo_AvailabilityQtyUoMContract__c);//US-2377                                                      
                                detail.availableBalance=String.valueOf(contractPrices.cc_oo_AvailabilityQty__c);
                                detail.contractUom = String.valueOf(contractPrices.cc_oo_ContractUoMDesc__c);
                                detail.jdeEndUser = String.valueOf(contractPrices.cc_oo_EndUserName__c);
                                contract.contractDetails=detail;
                                //dataMap.put(contract.contractId,contract);
                                //contract.contractQty = Integer.valueOf(contractPrices.cc_oo_ContractQty__c);
                                System.debug('Hi' + contractPrices.cc_oo_AvailabilityQty__c);
                                /*if(contractBalance != null) {
                                    if(contractBalance.get(contractPrices.Name) >= (contractPrices.cc_oo_AvailabilityQty__c)) {
                                        contract.disableContract = true;
                                    } else {
                                        contract.disableContract = false;
                                    }
                                } else {
                                    contract.disableContract = false;
                                }*/
                                /*if(!((priceOption.cc_oo_Product__r.ccrz__UnitOfMeasure__c).equals(contractPrices.cc_oo_ContractUoM__c))) {
                                    roundedPrice=(contractPrices.cc_oo_ContractPrice__c)/(contractPrices.cc_oo_ConversionValue__c);
                                    roundedPrice=roundedPrice.setscale(2);
                                    contract.contractPrice = String.valueOf(roundedPrice);
                                    //contract.contractPrice = String.valueOf((contractPrices.cc_oo_ContractPrice__c)/contractPrices.cc_oo_ConversionValue__c);
                                } else {*/
                                    contract.contractPrice = String.valueOf(contractPrices.cc_oo_ContractPrice__c); 
                                //}                            
                                contractPrice.add(contract);
                            }
                        }             
                        
                        
                        
                    }

                    dataMapProduct.put('listPrice', listPrice);
                    dataMapProduct.put('contractPrice', contractPrice);
                    dataMapProduct.put('jdePriceObject',jdeObj);
                    dataLogs = JSON.serialize(logs);

                    dataMapProductString = JSON.serialize(dataMapProduct);
                    system.debug('dataMapProduct------>' + dataMapProduct);
                    system.debug('dataMapProductString------>' + dataMapProductString);
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',('dataMapProduct' + dataMapProduct ));
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductPricing try end----');
                    
                }
            }
        }catch (Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, 'cc_oo_ProductDetailController', 'testerrorlog');
        }
         
    }
	
	public class cc_oo_JDEPrice{
        public string sellerId{get; set;}
        public string sellerSFId{get; set;}
        public string shipToId{get; set;}
        public string shipToSFId{get; set;}
        public string skuId{get; set;}
        public string skuSFId{get; set;}
        public string priceListId{get; set;}
        public string typeOfProduct{get; set;}
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult createPriceRecord(final ccrz.cc_RemoteActionContext ctx,string priceDetails){
        ccrz.cc_RemoteActionResult res =  new ccrz.cc_RemoteActionResult();
        try{
            string[] price = priceDetails.split(':');
            cc_oo_PriceList__c priceOption =  new cc_oo_PriceList__c();
            priceOption.cc_oo_Seller__c = price[0];
            priceOption.cc_oo_Product__c = price[1];
            priceOption.cc_oo_ShipTo__c = price[2]; 
            priceOption.cc_oo_EffectiveDate__c = Date.today(); 
            priceOption.cc_oo_NetListPrice__c = Decimal.valueOf(price[3]);
            priceOption.cc_oo_IsJDEPriceUpdated__c = true;
            priceOption.cc_oo_isfreightincluded__c = Boolean.valueOf(price[4]);

            if(price.size() > 5){
                if(price[5] != null && price[5] != ''){
                    priceOption.Id = price[5];
                }
            }
            upsert priceOption;
            res.data = true;
            return res;
        }catch(Exception ex){
            cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();           
            errorLog.cc_oo_Description__c   = 'Exception type caught: ' + ex.getTypeName() + ' '
                                                 + 'Message: '          + ex.getMessage() + ' '
                                                 + 'Cause: '            + ex.getCause() + ' ' 
                                                 + 'Stack trace: '      + ex.getStackTraceString();
            errorLog.cc_oo_ApexClass__c     = 'cc_oo_ProductDetailController';
            errorLog.cc_oo_MethodName__c    = 'getProductPricingNew';
            insert errorLog; 
            res.data = false;
            return res;
        }
    }

    @RemoteAction
    global static ccrz.cc_RemoteActionResult createPriceLog(final ccrz.cc_RemoteActionContext ctx,string logs){
        ccrz.cc_RemoteActionResult res =  new ccrz.cc_RemoteActionResult();
        try{
            system.debug('logs-->' + logs);
            JSONParser parserLogs = JSON.createParser(logs);
            system.debug('parserLogs-->' + parserLogs);
            List<cc_oo_ErrorLog__c> priceLogs = (List<cc_oo_ErrorLog__c>)parserLogs.readValueAs(List<cc_oo_ErrorLog__c>.class);
            system.debug('priceLogs--->' + priceLogs);
            insert priceLogs;
            res.data = true;
            return res;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, 'c_oo_ProductDetailController', 'createPriceLog'); 
            res.data = false;
            return res;
        }
    }
    //Performance changes 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getJDEPrice(final ccrz.cc_RemoteActionContext ctx, string jdePriceData){
        ccrz.cc_RemoteActionResult res =  new ccrz.cc_RemoteActionResult();
        JSONParser parserData = JSON.createParser(jdePriceData);
        Map<String, string> dataMapProduct = new Map<String, string>();
        cc_oo_JDEPrice jdeObj = (cc_oo_JDEPrice)JSON.deserialize(jdePriceData, cc_oo_JDEPrice.class);
        string netListPrice=''; 
        boolean isfreightincluded = false;   
        Map<string, Object> mapData = new Map<string, Object>();
        string jdeDownMsg = ccrz.cc_CallContext.pageLabels.get('JDEDownPirceMessage');//OO-3125
        try{
            cc_oo_ServiceData__c priceServiceData = cc_oo_ServiceData__c.getValues('RetrievePrice');
            cc_oo_PriceList__c priceOption = new cc_oo_PriceList__c();
            
            cc_oo_JDEPriceRequest.Params paramsReq = new cc_oo_JDEPriceRequest.Params();
            paramsReq.AN8_ShipToNUmber = jdeObj.shipToId;
            paramsReq.MCU_BranchPlant = jdeObj.sellerId;
            paramsReq.DCTO_OrderType = priceServiceData.cc_oo_OrderType__c;
            paramsReq.LITM_ItemNumber = jdeObj.skuId;
            paramsReq.VERS_P4210Version = priceServiceData.cc_oo_P4210Version__c;
            /*paramsReq.AN8_ShipToNUmber = '315136';
            paramsReq.MCU_BranchPlant = 'SFSD';
            paramsReq.DCTO_OrderType = priceServiceData.cc_oo_OrderType__c;
            paramsReq.LITM_ItemNumber = '0032986';
            paramsReq.VERS_P4210Version = priceServiceData.cc_oo_P4210Version__c;*/

            cc_oo_JDEPriceRequest priceReq = new cc_oo_JDEPriceRequest();
            priceReq.params = paramsReq;
            Map<string, Object> responseData = cc_oo_servicePriceCallOut.getProductPrice(priceReq);

            cc_oo_JDEPriceResponse resp = (cc_oo_JDEPriceResponse)responseData.get('response');
            List<cc_oo_ErrorLog__c> listLog = (List<cc_oo_ErrorLog__c>)responseData.get('logs');
            if(listLog.size() > 0){
                insert listLog;
            }
            if(resp != null){
                if(resp.callMethod.errors == null){
                    if(resp.callMethod.Params != null){
                        if(jdeObj.priceListId != null){
                            cc_oo_PriceList__c price = new cc_oo_PriceList__c();
                            price.Id = jdeObj.priceListId;
                            String SecUOM=resp.callMethod.Params.UOM_Pricing;
                            if(jdeObj.typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || jdeObj.typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                price.cc_oo_IsJDEPriceUpdated__c = true;
                                price.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2);//Pricing Update -4323
                                netListPrice=String.valueOf((decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2));
                            }else{
                                price.cc_oo_IsJDEPriceUpdated__c = true;
                                price.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2);
                                netListPrice = String.valueOf((decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2));
                            }
                            if(resp.callMethod.Params.szFreightHandlingCode == '1') {
                                price.cc_oo_isfreightincluded__c = true;
                                isfreightincluded = true;
                            } else {
                                price.cc_oo_isfreightincluded__c = false;
                                isfreightincluded = false;
                            }
                            update price; 
                            
                        }else {
                            priceOption.cc_oo_Seller__c = jdeObj.sellerSFId;
                            priceOption.cc_oo_Product__c = jdeObj.skuSFId;
                            priceOption.cc_oo_ShipTo__c = jdeObj.shipToSFID; 
                            priceOption.cc_oo_EffectiveDate__c = Date.today(); 
                            priceOption.cc_oo_IsJDEPriceUpdated__c = true;
                            String SecUOM=resp.callMethod.Params.UOM_Pricing;
                            if(jdeObj.typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || jdeObj.typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2);//Pricing Update - 4323
                                netListPrice =String.valueOf((decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2));
                            }else{
                                priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2);//Pricing Update - Shri
                                netListPrice = String.valueOf((decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2));
                            }
                            if(resp.callMethod.Params.szFreightHandlingCode == '1') {
                                priceOption.cc_oo_isfreightincluded__c = true;
                                isfreightincluded = true;
                            } else {
                                priceOption.cc_oo_isfreightincluded__c = false;
                                isfreightincluded = false;
                            }
                            insert priceOption;
                        }
                        mapData.put('price', netListPrice);
                        mapData.put('isfreightincluded', isfreightincluded);
                    }else{
                        mapData.put('jDEPrice', jdeDownMsg);
                    }
                }else{
                    mapData.put('jDEPrice', jdeDownMsg);
                }
            }else{
                mapData.put('jDEPrice', jdeDownMsg);
            }
            if(String.isEmpty(netListPrice)){
                mapData.put('jDEPrice', jdeDownMsg);
            }
            res.data = mapData;
            res.success = true;
            return res;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getJDEPrice');
        }
        res.data = null;
        res.success = false;
        return res;
    }
  
}