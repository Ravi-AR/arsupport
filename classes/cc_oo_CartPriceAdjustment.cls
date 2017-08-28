//ClassName:cc_oo_CartPriceAdjustment
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                           12/01/2016                                     OO-56  - Update Cart pricing
//-----------------------------------------------------------------------------------------------------------------------
global without sharing class cc_oo_CartPriceAdjustment extends ccrz.cc_api_PriceAdjustment{
    public static final string CLASS_NAME = 'cc_oo_CartPriceAdjustment';
    global override Map<String, Object> computePricingCart(Map<String, Object> inputData){
        
        System.debug('compute Cart price adjustment -->');
        ccrz.cc_bean_CartSummary cartBean;
        try{ 
            Set<String> prdlst=new Set<String>();
            Map<String,List<ccrz.cc_bean_CartItem>> prdCartMap;
            List<ccrz.cc_bean_CartItem> crtprlst;
            Id cartId;
            List<ccrz.cc_bean_CartItem> ShufflecartItems= new List<ccrz.cc_bean_CartItem>();
            Map<String,ccrz__E_CartItem__c> updatedCartMap=new Map<String,ccrz__E_CartItem__c>();
            Map<String,ccrz.cc_bean_CartItem> updatedCartBeanMap=new Map<String,ccrz.cc_bean_CartItem>();
            Map<String,ccrz__E_ProductInventoryItem__c> prdInvMap=new Map<String,ccrz__E_ProductInventoryItem__c>();
            Map<String,cc_oo_PriceList__c> prdPirceMap=new Map<String,cc_oo_PriceList__c>();
            List<ccrz__E_CartItem__c> toDeleteCartItem=new List<ccrz__E_CartItem__c>();
            cartBean = (ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN); 
            
            ccrz__E_Cart__c cart = [SELECT ccrz__EncryptedId__c,cc_oo_SplitCart__c,cc_oo_ShipToAccount__r.Id,cc_oo_ShipToAccount__r.AccountNumber,cc_oo_Seller__r.ccrz__sellerId__c, cc_oo_AmendedCart__c,cc_oo_OriginalCart__r.ccrz__EncryptedId__c,cc_oo_OriginalCart__c,cc_oo_SplitCartType__c,
            (SELECT Id,cc_oo_IsListPrice__c,cc_oo_OriginalCartItem__c,cc_oo_OriginalCartItem__r.ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Id,cc_oo_OriginalCartItem__r.cc_oo_UnitPrice__c,
            cc_oo_OriginalCartItem__r.ccrz__Quantity__c,cc_oo_OriginalCartItem__r.ccrz__Price__c,ccrz__Product__r.ccrz__SKU__c,cc_oo_ContractPrice__r.cc_oo_ContractPrice__c,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c,
            ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.cc_oo_TypeOfProduct__c,cc_oo_ContractPrice__r.cc_oo_ContractUoM__c,cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__UnitOfMeasure__c,
            cc_oo_ContractPrice__r.cc_oo_ConversionValue__c,ccrz__SubAmount__c, ccrz__Price__c,ccrz__Quantity__c,cc_oo_UnitPrice__c 
            ,cc_oo_OriginalBagPrice__c,cc_oo_OriginalPalletPrice__c,cc_oo_ContractPrice__r.Name // 2752
            FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c 
            WHERE c.ccrz__EncryptedId__c =:cartBean.encryptedId LIMIT 1];
            ccrz__E_Cart__c oldcart;
              ccrz__E_Cart__c splitcart;
            if(cart!=null && cart.cc_oo_SplitCart__c!=null && cart.cc_oo_SplitCartType__c == 'Primary'){
                 splitcart=[SELECT ccrz__EncryptedId__c,ccrz__RequestDate__c,(SELECT Id  FROM ccrz__E_CartItems__r)FROM ccrz__E_Cart__c where id=:cart.cc_oo_SplitCart__c];
                   system.debug('splitcart-----'+ splitcart.ccrz__RequestDate__c);
            }
            if(cart!=null && splitcart!=null  && cart.cc_oo_SplitCartType__c == 'Primary'){
                if(cart.ccrz__E_CartItems__r!=null && splitcart.ccrz__E_CartItems__r!=null && cart.ccrz__E_CartItems__r.isEmpty() &&! splitcart.ccrz__E_CartItems__r.isEmpty()){
                    String shippingMethod=cc_oo_HelperController.getShippingMethod(cart.ccrz__EncryptedId__c);
                    Map<String, Object> dataMap=cc_oo_HelperController.shuffleCart(cart.ccrz__EncryptedId__c,splitcart.ccrz__RequestDate__c.format(),shippingMethod,false); 
                    system.debug('shuffle cart completed');

                    cart = [SELECT ccrz__EncryptedId__c,cc_oo_isShipDateExtended__c,cc_oo_SplitCart__c,cc_oo_ShipToAccount__r.Id,cc_oo_ShipToAccount__r.AccountNumber,cc_oo_Seller__r.ccrz__sellerId__c,cc_oo_AmendedCart__c,cc_oo_OriginalCart__r.ccrz__EncryptedId__c,cc_oo_OriginalCart__c,cc_oo_SplitCartType__c,
                            (SELECT Id,cc_oo_IsListPrice__c,cc_oo_OriginalCartItem__c,cc_oo_OriginalCartItem__r.ccrz__Product__r.ccrz__SKU__c,cc_oo_OriginalCartItem__r.cc_oo_UnitPrice__c,
                            cc_oo_OriginalCartItem__r.ccrz__Quantity__c,cc_oo_OriginalCartItem__r.ccrz__Price__c,ccrz__Product__r.ccrz__SKU__c,cc_oo_ContractPrice__r.cc_oo_ContractPrice__c,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c,
                            ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.name,ccrz__Product__r.cc_oo_TypeOfProduct__c,cc_oo_ContractPrice__r.cc_oo_ContractUoM__c,cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__UnitOfMeasure__c,
                            cc_oo_ContractPrice__r.cc_oo_ConversionValue__c,ccrz__SubAmount__c, ccrz__Price__c,ccrz__Quantity__c,cc_oo_UnitPrice__c 
                            ,cc_oo_OriginalBagPrice__c,cc_oo_OriginalPalletPrice__c,cc_oo_ContractPrice__r.Name // 2752
                            FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c 
                            WHERE c.ccrz__EncryptedId__c =:cartBean.encryptedId LIMIT 1];
                            if(cart.cc_oo_SplitCart__c != null) {
                            	ccrz__E_Cart__c deleteSecondaryCart = new ccrz__E_Cart__c();
	                            deleteSecondaryCart.Id = cart.cc_oo_SplitCart__c;
	                            delete deleteSecondaryCart;
                            }
                            
                            cart.cc_oo_isShipDateExtended__c=true;
                            cart.cc_oo_SplitCart__c = null;
                            update cart;
                            for(ccrz__E_CartItem__c cartItem :cart.ccrz__E_CartItems__r){
                                ccrz.cc_bean_CartItem ShufflecartItem = new ccrz.cc_bean_CartItem();
                                ShufflecartItem.itemID=cartItem.id;
                                ShufflecartItem.ItemStatus = 'Available';
                                ShufflecartItem.cartId = cart.Id;
                                                              
                            system.debug('ShufflecartItem id----->'+ShufflecartItem.itemID);
                            ShufflecartItem.mockProduct=new ccrz.cc_bean_MockProduct();
                            ShufflecartItem.mockProduct.id=cartItem .ccrz__Product__r.Id;
                            //OO-2022 Product image on Cart page
                            //cartItemBeannew.mediaWrapper = updatedCartBeanMap.get(cartItemId1).mediaWrapper;
                            //OO-2022 Product image on Cart page-ends 
                            ShufflecartItem.mockProduct.name=cartItem.ccrz__Product__r.name;
                            ShufflecartItem.mockProduct.sku = cartItem.ccrz__Product__r.ccrz__SKU__c ;
                            ShufflecartItem.price = cartItem.cc_oo_UnitPrice__c;
                            ShufflecartItem.subAmount = cartItem.ccrz__SubAmount__c;
                            ShufflecartItem.quantity = Integer.valueOf(cartItem.ccrz__Quantity__c);
                            //cartItemBeannew.mediaWrapper = updatedCartBeanMap.get(cartItemId1).mediaWrapper;
                            //cartItemBeannew.qtySkipIncrement = updatedCartBeanMap.get(cartItemId1).qtySkipIncrement;
                            //Defect#OO-5126
                            ShufflecartItem.qtyIncrement=1;
                                ShufflecartItems.add(ShufflecartItem);
                                }
                            cartBean.cartItems=ShufflecartItems;
                            system.debug('after shuffle cart bean----'+cartBean);
                }
                system.debug('after shuffle cart------------------'+cart );
            }
            if(cart!=null){
                if(cart.cc_oo_AmendedCart__c){

                    oldcart = [SELECT c.ccrz__EncryptedId__c,cc_oo_ShipToAccount__r.AccountNumber,cc_oo_Seller__r.ccrz__sellerId__c,
                    (SELECT Id,cc_oo_IsListPrice__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Id,ccrz__Quantity__c,cc_oo_ContractPrice__r.cc_oo_ContractPrice__c,
                    cc_oo_ContractPrice__r.cc_oo_ContractUoM__c,cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__UnitOfMeasure__c,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c,
                    cc_oo_ContractPrice__r.cc_oo_ConversionValue__c,ccrz__SubAmount__c,ccrz__Price__c,cc_oo_UnitPrice__c,
                    cc_oo_OriginalBagPrice__c,cc_oo_OriginalPalletPrice__c,cc_oo_ContractPrice__r.Name //2752
                    ,ccrz__Product__r.cc_oo_TypeOfProduct__c
                    FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c 
                    WHERE c.ccrz__EncryptedId__c =:cart.cc_oo_OriginalCart__r.ccrz__EncryptedId__c LIMIT 1];
                }
            }
            map<String,String> oldCartId = new map<String,String>();
            map<String,Integer> oldIdQuantity=new map<String,Integer>();
            map<String,Decimal> oldIdUnitPrice=new map<String,Decimal>();
            map<String,List<String>> oldPrdCartMap;
            List<String> oldCrtprlst;
            
            Boolean listPrice = false;
            Boolean contractPrice = false;
            Boolean isUpdate = false;
            Boolean isAmended=false;
            Boolean toChange=false;
            Boolean isPrimary=false;
            cartId=cartBean.sfid;
            system.debug('cartId ------------------------------>'+cartId);
            //oo-1273 Amended Cart
            isAmended=cart.cc_oo_AmendedCart__c==true?true:false;
            isPrimary=cart.cc_oo_SplitCartType__c=='Primary'?true:false;
            List<String> skuList = new List<String>();
            Set<Decimal> contractNumberList = new Set<Decimal>();
            List<ccrz__E_CartItem__c> cartItemListForPrice =  new List <ccrz__E_CartItem__c>();
            //2752
            Map<String, ccrz__E_CartItem__c> oldItemPriceMap = new Map<String, ccrz__E_CartItem__c>();
            Map<String, ccrz__E_CartItem__c> oldItemMap = new Map<String, ccrz__E_CartItem__c>();
            if(oldcart!=null){
            for(ccrz__E_CartItem__c cartItem :oldcart.ccrz__E_CartItems__r){
                if(isAmended && isPrimary){
                    oldItemMap.put(cartItem.Id,cartItem);
                if(cartItem.cc_oo_IsListPrice__c){
                 oldIdQuantity.put(cartItem.Id,Integer.valueOf(cartItem.ccrz__Quantity__c));
                 oldIdUnitPrice.put(cartItem.Id,cartItem.cc_oo_UnitPrice__c);
                 //2752
                 oldItemPriceMap.put(cartItem.ccrz__Product__r.ccrz__SKU__c,cartItem);
                    if(oldPrdCartMap == null){
                                //create map of product sku and ccrz.cc_bean_CartItem
                                oldPrdCartMap=new Map<String,List<String>>();
                                oldCrtprlst=new List<String>();
                                oldCrtprlst.add(cartItem.Id);
                                oldPrdCartMap.put(cartItem.ccrz__Product__r.ccrz__SKU__c, oldCrtprlst);
                                system.debug('MapCreated'+oldPrdCartMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                             }else{ 
                                 if(!oldPrdCartMap.containsKey(cartItem.ccrz__Product__r.ccrz__SKU__c)){
                                    oldCrtprlst=new List<String>();
                                    oldCrtprlst.add(cartItem.Id);
                                    oldPrdCartMap.put(cartItem.ccrz__Product__r.ccrz__SKU__c, oldCrtprlst);
                                    system.debug('MapValueAdded'+oldPrdCartMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                                 }else{
                                    oldCrtprlst=oldPrdCartMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                                    oldCrtprlst.add(cartItem.Id);
                                    oldPrdCartMap.put(cartItem.ccrz__Product__r.ccrz__SKU__c, oldCrtprlst);
                                    system.debug('secondMapValueAdded'+oldPrdCartMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                                 }
                            }
                }}
            }}
            String UOM;
            for(ccrz__E_CartItem__c cartItem : cart.ccrz__E_CartItems__r){
                skuList.add(cartItem.ccrz__Product__r.ccrz__SKU__c);
                contractNumberList.add(cartItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
                UOM=cartItem.ccrz__Product__r.ccrz__UnitOfMeasure__c;
                oldCartId.put(cartItem.Id,cartItem.cc_oo_OriginalCartItem__c);
                //this should be a map
                if(cartItem.cc_oo_IsListPrice__c == true) {
                   listPrice = true; 
                }
                
                if(cartItem.cc_oo_IsListPrice__c == false) {
                    if(cartItem.cc_oo_ContractPrice__c != null) {
                        contractPrice = true;
                    } else {
                        listPrice = true;
                        isUpdate = true;
                        cartItem.cc_oo_IsListPrice__c = true;
                        cartItemListForPrice.add(cartItem); 
                    }
                    
                }
            }
            
            if(isUpdate) {
                update cartItemListForPrice;
                
                cart = [SELECT c.ccrz__EncryptedId__c,cc_oo_ShipToAccount__r.Id,cc_oo_OriginalOrder__c,cc_oo_AmendedCart__c,cc_oo_OriginalCart__c,cc_oo_SplitCartType__c,
                (SELECT Id,cc_oo_IsListPrice__c,cc_oo_OriginalCartItem__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Id, cc_oo_ContractPrice__r.cc_oo_ContractPrice__c,
                cc_oo_ContractPrice__r.cc_oo_ContractUoM__c,cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__UnitOfMeasure__c,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c,
                cc_oo_ContractPrice__r.cc_oo_ConversionValue__c,ccrz__SubAmount__c, ccrz__Price__c, ccrz__Quantity__c, cc_oo_UnitPrice__c,cc_oo_ContractPrice__r.Name,
                ccrz__Product__r.cc_oo_TypeOfProduct__c 
                FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c 
                WHERE c.ccrz__EncryptedId__c =:cartBean.encryptedId LIMIT 1];   
            }
            
            System.debug('\n\n\n Cart in cart pricing ---------->'+cart); 
            
            Id contactId = ccrz.cc_CallContext.currContact.Id;
        
            String accountId;
            List<Contact> ParentAccount=new List<Contact>();
            ParentAccount=[SELECT Account.Parent_Account_Number__c,Account.AccountNumber FROM Contact WHERE Id=:contactId];
            for(Contact c:ParentAccount){
                if(c.Account.Parent_Account_Number__c!=NULL){
                    accountId=c.Account.Parent_Account_Number__c;
                    break;
                }
                else{
                    accountId=c.Account.AccountNumber;
                }
            }
            
            Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            system.debug('pageparams'+pageParams.get('sid'));
            String sellerId = null;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
                System.debug('sellerid'+sellerId);
            }
             Date expireLimit = Date.today();
             
             //Map<String,cc_oo_PriceList__c> productPriceMap = new Map<String,cc_oo_PriceList__c>();
             //Map<String, Decimal> palletSizeMap = new Map<String, Decimal>();
             /* if(listPrice) {
             
                 List<ccrz__E_ProductInventoryItem__c> inventoryStatus = [SELECT ccrz__Status__c, cc_oo_PalletSize__c,cc_oo_IsOnlyPalletProduct__c,
                                                                                        ccrz__ProductItem__r.ccrz__SKU__c 
                                                                                        FROM ccrz__E_ProductInventoryItem__c
                                                                                        WHERE ccrz__ProductItem__r.ccrz__SKU__c  IN :skuList
                                                                                        AND cc_oo_Seller__c = :sellerId];
                 
                 System.debug('Piyali' + inventoryStatus );
                 System.debug('Piyali' + skuList);
                 for(ccrz__E_ProductInventoryItem__c palletSize : inventoryStatus) {
                     palletSizeMap.put(palletSize.ccrz__ProductItem__r.ccrz__SKU__c, palletSize.cc_oo_PalletSize__c);
                 }
                 
                 List<cc_oo_PriceList__c> priceOption = [SELECT cc_oo_NetListPrice__c, cc_oo_PalletPrice__c,
                                                         cc_oo_Product__r.ccrz__UnitOfMeasure__c,
                                                         cc_oo_Product__r.ccrz__SKU__c 
                                                         FROM cc_oo_PriceList__c 
                                                         WHERE cc_oo_Seller__c=:sellerId 
                                                         AND cc_oo_Product__r.ccrz__SKU__c IN :skuList
                                                         AND cc_oo_EffectiveDate__c <=:expireLimit
                                                         AND cc_oo_ExpirationDate__c >=:expireLimit
                                                         ORDER BY cc_oo_ExpirationDate__c ASC];
                 
                 System.debug('Piyali' + priceOption);
                 for(cc_oo_PriceList__c productPrice :  priceOption) {
                     productPriceMap.put(productPrice.cc_oo_Product__r.ccrz__SKU__c , productPrice);
                 } 
             } */
             
                //defect-2768 
                 List<cc_oo_ContractPrice__c> contractPriceList = [SELECT Name, cc_oo_ContractPrice__c,cc_oo_ContractUoM__c,
                                                                         cc_oo_Product__r.ccrz__UnitOfMeasure__c,
                                                                         cc_oo_Product__r.ccrz__SKU__c,
                                                                         cc_oo_ConversionValue__c
                                                                         FROM cc_oo_ContractPrice__c
                                                                         WHERE 
                                                                         cc_oo_Product__r.ccrz__SKU__c IN :skuList
                                                                         AND cc_oo_Seller__c=:sellerId
                                                                         AND cc_oo_ShipToNumber__r.AccountNumber=:accountId
                                                                         AND cc_oo_EffectiveDate__c <=:expireLimit
                                                                         AND cc_oo_ExpireDate__c >=:expireLimit
                                                                         AND cc_oo_ContractNumber__c IN :contractNumberList
                                                                         //AND cc_oo_ContractUoM__c=:UOM
                                                                         ORDER BY cc_oo_ExpireDate__c ASC];
                                                                         
                 Map<String, cc_oo_ContractPrice__c> productContractPriceMap = new Map<String,cc_oo_ContractPrice__c>();
                 
                 for(cc_oo_ContractPrice__c productContractPrice :  contractPriceList) {
                     productContractPriceMap.put(productContractPrice.Name , productContractPrice);
                 }
                 system.debug('****************************productContractPriceMap'+productContractPriceMap);
            List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
            Map<String, Id> productSKUIdMap = new Map<String,Id>();
            for(ccrz.cc_bean_CartItem cartItemBean : cartBean.cartItems){
                for(ccrz__E_CartItem__c cartItem : cart.ccrz__E_CartItems__r) {
                    if(cartItem.Id == cartItemBean.itemID) {
                         //Annapurna 1601 split list price items
                        updatedCartMap.put(cartItem.id,cartItem);
                        updatedCartBeanMap.put(cartItemBean.itemID,cartItemBean);
                        if(cartItem.cc_oo_IsListPrice__c){
                            prdlst.add(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            productSKUIdMap.put(cartItem.ccrz__Product__r.ccrz__SKU__c, cartItem.ccrz__Product__r.Id);
                        //prdlst.add(cartItemBean.mockProduct.sku);
                       
                            if(prdCartMap == null){
                                //create map of product sku and ccrz.cc_bean_CartItem
                                prdCartMap=new Map<String,List<ccrz.cc_bean_CartItem>>();
                                crtprlst=new List<ccrz.cc_bean_CartItem>();
                                crtprlst.add(cartItemBean);
                                system.debug('cartItemlst for new cart prdCartMap'+cartItemBean);
                                prdCartMap.put(cartItemBean.mockProduct.sku, crtprlst);
                                system.debug('MapCreated for new cart prdCartMap'+prdCartMap.get(cartItemBean.mockProduct.sku));
                             }else{ 
                                 if(!prdCartMap.containsKey(cartItemBean.mockProduct.sku)){
                                    crtprlst=new List<ccrz.cc_bean_CartItem>();
                                    crtprlst.add(cartItemBean);
                                    prdCartMap.put(cartItemBean.mockProduct.sku, crtprlst);
                                    system.debug('MapValueAdded new cart prdCartMap'+prdCartMap.get(cartItemBean.mockProduct.sku));
                                 }else{
                                    crtprlst = prdCartMap.get(cartItemBean.mockProduct.sku);//new line
                                    crtprlst.add(cartItemBean);
                                    prdCartMap.put(cartItemBean.mockProduct.sku, crtprlst);
                                    system.debug('secondMapValueAdded new cart prdCartMap'+prdCartMap.get(cartItemBean.mockProduct.sku));
                                 }
                            }
                       }/*else{
                            if(!isPrimary){
                                system.debug('Contract price of current product'+productContractPriceMap.get(cartItemBean.mockProduct.sku));
                                cartItem.cc_oo_UnitPrice__c=productContractPriceMap.get(cartItemBean.mockProduct.sku).cc_oo_ContractPrice__c;
                            }
                       }*/                        
                        //cartItemBean.price = cartItem.cc_oo_UnitPrice__c;
                        //cartItemBean.subAmount = cartItem.cc_oo_UnitPrice__c * cartItem.ccrz__Quantity__c;
                        //cartItem.ccrz__Price__c = cartItem.cc_oo_UnitPrice__c;
                        //cartItem.ccrz__SubAmount__c = cartItem.cc_oo_UnitPrice__c* cartItem.ccrz__Quantity__c;
                       /* if(cartItem.cc_oo_IsListPrice__c) {
                            cc_oo_PriceList__c price = productPriceMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            
                            if(palletSizeMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c) != null) {
                                Integer quotient = 0;
                                Integer remainder = 0;
                                
                                System.debug('Piyali' + palletSizeMap);
                                System.debug('Piyali' + price);
                                
                                quotient = Integer.valueOf(cartItem.ccrz__Quantity__c) /(Integer.valueOf(palletSizeMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c)));
                                remainder = math.mod(Integer.valueOf(cartItem.ccrz__Quantity__c), (Integer.valueOf(palletSizeMap.get(cartItem.ccrz__Product__r.ccrz__SKU__c))));
                                
                                if(quotient >= 1) {
                                    System.debug('Inside quotient -->');
                                    cartItemBean.price = price.cc_oo_PalletPrice__c;
                                    //cartItemBean.recurringPrice = price.cc_oo_NetListPrice__c;
                                    cartItemBean.subAmount = price.cc_oo_PalletPrice__c * cartItem.ccrz__Quantity__c;
                                    cartItem.ccrz__Price__c = price.cc_oo_PalletPrice__c;
                                    cartItem.ccrz__SubAmount__c = price.cc_oo_PalletPrice__c * cartItem.ccrz__Quantity__c; 
                                }
                                
                                if(remainder >= 1) {
                                    System.debug('Inside remainder-->' + price.cc_oo_NetListPrice__c);
                                    System.debug('Inside remainder-->' + cartItemBean);
                                    cartItemBean.price = price.cc_oo_NetListPrice__c;
                                    cartItemBean.subAmount = price.cc_oo_NetListPrice__c * cartItem.ccrz__Quantity__c;
                                    cartItem.ccrz__Price__c = price.cc_oo_NetListPrice__c;
                                    cartItem.ccrz__SubAmount__c = price.cc_oo_NetListPrice__c* cartItem.ccrz__Quantity__c;
                                }                               
                            } else {
                                cartItemBean.price = price.cc_oo_NetListPrice__c;
                                cartItemBean.subAmount = price.cc_oo_NetListPrice__c * cartItem.ccrz__Quantity__c;
                                cartItem.ccrz__Price__c = price.cc_oo_NetListPrice__c;
                                cartItem.ccrz__SubAmount__c = price.cc_oo_NetListPrice__c* cartItem.ccrz__Quantity__c;
                            }
                        }
                        
                        if(!cartItem.cc_oo_IsListPrice__c) {
                            Decimal contract; 
                            if(cartItem.cc_oo_ContractPrice__r.cc_oo_ContractUoM__c != cartItem.cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__UnitOfMeasure__c) {
                                contract = cartItem.cc_oo_ContractPrice__r.cc_oo_ContractPrice__c/cartItem.cc_oo_ContractPrice__r.cc_oo_ConversionValue__c;
                            } else {
                                contract = cartItem.cc_oo_ContractPrice__r.cc_oo_ContractPrice__c;
                            }                          
                            cartItemBean.price = contract ;
                            cartItemBean.subAmount =  contract * cartItemBean.quantity;
                            cartItem.ccrz__Price__c = contract ;
                            cartItem.ccrz__SubAmount__c = contract * cartItem.ccrz__Quantity__c; 
                        } */
                        
                        cartItemList.add(cartItem);
                    }
                }
                
            } 
            //Annpurna-1601-split cart for list price item
            String accId=cart.cc_oo_ShipToAccount__r.Id;
            List<ccrz__E_ProductInventoryItem__c> prdInvItm=[select ccrz__ProductItem__r.ccrz__SKU__c,cc_oo_IsOnlyPalletProduct__c,
                                                                ccrz__ProductItem__r.ccrz__UnitOfMeasure__c,cc_oo_PalletSize__c,
                                                                ccrz__ProductItem__r.cc_oo_TypeOfProduct__c,cc_oo_MinQuantity__c
                                                                from ccrz__E_ProductInventoryItem__c
                                                                where ccrz__ProductItem__r.ccrz__SKU__c IN:prdlst and cc_oo_Seller__c=:sellerId];
            for(ccrz__E_ProductInventoryItem__c prdInvItemlist:prdInvItm){
                    prdInvMap.put(prdInvItemlist.ccrz__ProductItem__r.ccrz__SKU__c,prdInvItemlist);
            }
            List<cc_oo_PriceList__c> priceList=[select cc_oo_Product__r.ccrz__SKU__c,cc_oo_Product__r.Id,cc_oo_NetListPrice__c,cc_oo_PalletPrice__c from cc_oo_PriceList__c where cc_oo_Product__r.ccrz__SKU__c IN:prdlst and cc_oo_Seller__c=:sellerId and cc_oo_ShipTo__c=:accId];                                                 
            for(cc_oo_PriceList__c pricelst:priceList){
                prdPirceMap.put(pricelst.cc_oo_Product__r.ccrz__SKU__c,pricelst);
            }
            List<cc_oo_PriceList__c> priceOptionList =  new List<cc_oo_PriceList__c>();
            cc_oo_ServiceData__c priceServiceData = cc_oo_ServiceData__c.getValues('RetrievePrice');
            List<cc_oo_ErrorLog__c> logs = new List<cc_oo_ErrorLog__c>();
            System.debug('Piyali' + prdPirceMap);
            for(String prodSku:prdlst){
             system.debug('Inside the main loop');
             //Integer quotient = 0;
             //Integer remainder = 0;
             Integer quantity=0;
             Decimal newListPrice;
             //Decimal palletPrice;
             Integer palletSize;
             Decimal oldListPrice;
             //Decimal oldPalletPrice;
             //2752
             ccrz__E_CartItem__c oldCartItemPrice;
             
             if(oldItemPriceMap != null && oldItemPriceMap.get(prodSku) != null) {
                oldCartItemPrice = oldItemPriceMap.get(prodSku);
             }
             //2752
             
             
             if(prdInvMap!=null && prdInvMap.get(prodSku).cc_oo_PalletSize__c != null){
                  palletSize=Integer.valueOf(prdInvMap.get(prodSku).cc_oo_PalletSize__c);
             }
             System.debug('Hi Piyali'+ prdPirceMap.get(prodSku));
             if(!prdPirceMap.isEmpty() && prdPirceMap.get(prodSku) != null){
                  //palletPrice=prdPirceMap.get(prodSku).cc_oo_PalletPrice__c;
                  newListPrice=prdPirceMap.get(prodSku).cc_oo_NetListPrice__c;
             }else {
                
                cc_oo_JDEPriceRequest.Params paramsReq = new cc_oo_JDEPriceRequest.Params();
                paramsReq.AN8_ShipToNUmber = cart.cc_oo_ShipToAccount__r.AccountNumber;
                paramsReq.MCU_BranchPlant = cart.cc_oo_Seller__r.ccrz__sellerId__c;
                paramsReq.DCTO_OrderType = priceServiceData.cc_oo_OrderType__c;
                paramsReq.LITM_ItemNumber = prodSku;
                paramsReq.VERS_P4210Version = priceServiceData.cc_oo_P4210Version__c;
                
                cc_oo_JDEPriceRequest priceReq = new cc_oo_JDEPriceRequest();
                            priceReq.params = paramsReq;
    
                            //cc_oo_JDEPriceResponse resp = cc_oo_servicePriceCallOut.getProductPrice(priceReq);
                            Map<string, Object> responseData = cc_oo_servicePriceCallOut.getProductPrice(priceReq);
                            cc_oo_JDEPriceResponse resp;
                            if(responseData != null){//Performance check
                                resp = (cc_oo_JDEPriceResponse)responseData.get('response');
                                if(responseData.get('logs') != null){
                                    logs.addAll((List<cc_oo_ErrorLog__c>)responseData.get('logs'));
                                    newListPrice=0;
                                }
                            }//Performance check
                            cc_oo_PriceList__c priceOption =  new cc_oo_PriceList__c();
                            if(resp != null){
                                if(resp.callMethod.errors == null){
                                    if(resp.callMethod.Params != null){//OO-3125
                                      String SecUOM=resp.callMethod.Params.UOM_Pricing;
                                      //defect#4543
                                        //Create new PriceList record
                                        priceOption.cc_oo_Seller__c = cart.cc_oo_Seller__c;
                                        priceOption.cc_oo_Product__c = productSKUIdMap.get(prodSku);
                                        priceOption.cc_oo_ShipTo__c = cart.cc_oo_ShipToAccount__c; 
                                        priceOption.cc_oo_EffectiveDate__c = Date.today(); 
                                        //priceOption.cc_oo_ExpirationDate__c = Date.today() + 7; 
                                        priceOption.cc_oo_IsJDEPriceUpdated__c = true;
                                        String producttype = '';
                                        if(!prdInvItm.isEmpty() && prdInvItm.size() != 0) {
                                        	producttype= prdInvItm.get(0).ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;
                                        }
                                        //defect#4543
                                      if(producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || producttype.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                                        priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2);//Pricing Update - Shri
                                      }else{
                                          priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2);//Pricing Update - Shri
                                      }
                                        
                                        if(resp.callMethod.Params.szFreightHandlingCode == '1') {
                                            priceOption.cc_oo_isfreightincluded__c = true;
                                        } else {
                                            priceOption.cc_oo_isfreightincluded__c = false;
                                        }
                                        newListPrice=priceOption.cc_oo_NetListPrice__c;
                                    }
                                }
                            }
                            
                            if(priceOption.cc_oo_NetListPrice__c != null) {
                                priceOptionList.add(priceOption);
                                prdPirceMap.put(prodSku, priceOption);
                            }
             }
             
             //2752
             if(isAmended && isPrimary) {
                if(oldCartItemPrice != null) {
                    //palletPrice=oldCartItemPrice.cc_oo_OriginalPalletPrice__c;
                    newListPrice=oldCartItemPrice.cc_oo_UnitPrice__c;
                }
             }
             //2752
             List<ccrz.cc_bean_CartItem> cartvalueList = new List<ccrz.cc_bean_CartItem>();
             if(prdCartMap != null && !prdCartMap.isEmpty()) {
                cartvalueList = prdCartMap.get(prodSku);
             }
             
             //Integer oldRemainder,oldRemainder1,oldRemainder2,oldQuantity;
             //oldRemainder=1;
             Integer oldListSize=0;
             List<String> oldCartvalueList = new List<String>(); 
             if(oldPrdCartMap == null) {
             	oldPrdCartMap = new map<String,List<String>>();
             }              
             if(oldPrdCartMap != null && !oldPrdCartMap.isEmpty()){  
                oldCartvalueList = oldPrdCartMap.get(prodSku); 
                if(oldCartvalueList != null) {
                	oldListSize=oldCartvalueList.size();
                //if(oldListSize<2){
                    /*if(palletSize!=null){
                        oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                    }*/
                    /*if(oldRemainder==0){
                        oldPalletprice=oldIdUnitPrice.get(oldCartvalueList[0]);
                    }else{*/
                        oldListprice=oldIdUnitPrice.get(oldCartvalueList[0]);
                    //}
                 /*}else if(oldListSize==2){
                      oldQuantity=Integer.valueOf(oldIdQuantity.get(oldCartvalueList[0]))+Integer.valueOf(oldIdQuantity.get(oldCartvalueList[1]));
                      //oldRemainder=math.mod(oldQuantity , palletSize);
                      Integer j=Integer.valueOf(oldIdQuantity.get(oldCartvalueList[0]));
                      //oldRemainder1=math.mod(j,palletSize);
                      Integer i=Integer.valueOf(oldIdQuantity.get(oldCartvalueList[1]));
                      //oldRemainder2=math.mod(i,palletSize);
                      if(oldRemainder1==0){
                        oldPalletprice=oldIdUnitPrice.get(oldCartvalueList[0]);
                        oldListprice=oldIdUnitPrice.get(oldCartvalueList[1]);
                      }else{
                        oldPalletprice=oldIdUnitPrice.get(oldCartvalueList[1]);
                        oldListprice=oldIdUnitPrice.get(oldCartvalueList[0]);
                      }
                      
                 }*/
                }
             }
             Integer listSize = cartvalueList.size();
             ccrz__E_CartItem__c newCartItem =new ccrz__E_CartItem__c();
             system.debug(listSize);
             //if(palletSize!=null && palletPrice!=null ){//OO-2025
                 if(listSize<2){
                 quantity=Integer.valueOf(cartvalueList[0].quantity);
                 //quotient = quantity /palletSize;
                 //remainder = math.mod(quantity , palletSize);
                 String cartItemId1=cartvalueList[0].itemID;
                 system.debug('cartItemId1 ------------------------------>'+cartItemId1);
                 //Defect-OO-1997 remainder!=0
                 //if(quotient==0 && remainder!=0)
                    updatedCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                    updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                    updatedCartMap.get(cartItemId1).ccrz__Price__c = newListPrice;
                    updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = newListPrice;
                    updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = newListPrice * quantity;
                        //Update cartbeanitem
                    updatedCartBeanMap.get(cartItemId1).quantity=quantity;
                    updatedCartBeanMap.get(cartItemId1).price = newListPrice;
                    updatedCartBeanMap.get(cartItemId1).subAmount = newListPrice * quantity;
                    
                    if(isAmended && isPrimary && (oldCartId!=null && oldCartId.get(cartItemId1)!=null)){
                        if(oldListSize<2 && oldListSize != 0){
                            //oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                            //if(oldRemainder!=0){
                                 newListPrice=oldListPrice;
                            //}
                        /*else if(oldListSize==2){
                                 newListPrice=oldListPrice;
                            }*/
                    }
                        //update current row with list price
                        updatedCartMap.get(cartItemId1).ccrz__Price__c = newListPrice;
                        updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = newListPrice;
                        updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = newListPrice * quantity;
                        //Update cartbeanitem
                        updatedCartBeanMap.get(cartItemId1).quantity=quantity;
                        updatedCartBeanMap.get(cartItemId1).price = newListPrice;
                        updatedCartBeanMap.get(cartItemId1).subAmount = newListPrice * quantity;
                   
                 }
                 /*if(quotient!=0 && remainder==0)
                 {  
                    //update current row with pallet price
                    updatedCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                    updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                    if(isAmended && isPrimary && (oldCartId!=null && oldCartId.containsKey(cartItemId1))){
                         if(oldListSize<2){
                            oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                            if(oldRemainder==0){
                                palletPrice=oldPalletprice;
                            }}
                          else if(oldListSize==2){
                                palletPrice=oldPalletprice;
                            }
                    }
                    updatedCartMap.get(cartItemId1).ccrz__Price__c = palletPrice;
                    updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = palletPrice;
                    updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = palletPrice * quantity;
                    //Update cartbeanitem
                    updatedCartBeanMap.get(cartItemId1).quantity=quantity;
                    updatedCartBeanMap.get(cartItemId1).price = palletPrice;
                    updatedCartBeanMap.get(cartItemId1).subAmount = palletPrice * quantity;
                    system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId1));
                    system.debug('cartItemId ------------------------------>'+updatedCartMap.get(cartItemId1));
                    system.debug('cartItemId1 ------------------------------>'+cartItemId1);
                }*/
                /*if(quotient!=0 && remainder!=0){
                        quantity=quantity-remainder;
                        if(isAmended && isPrimary&&(oldCartId!=null && oldCartId.containsKey(cartItemId1))){
                             if(oldListSize<2){
                                    oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                            if(oldRemainder==0){
                                palletPrice=oldPalletprice;
                            }else{
                                newListPrice=oldListprice;
                            }
                         }else if(oldListSize==2){
                                palletPrice=oldPalletprice;
                                newListPrice=oldListprice;
                            }
                             } 
                            //update current row with reminder and list price
                            updatedCartMap.get(cartItemId1).ccrz__Quantity__c = remainder;
                            updatedCartMap.get(cartItemId1).ccrz__Price__c = newListPrice;
                            updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = newListPrice;
                            updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                            updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = newListPrice * remainder;
                             system.debug('cartItem------------------------------>'+updatedCartMap.get(cartItemId1));
                            //Update cartbeanitem
                            updatedCartBeanMap.get(cartItemId1).quantity=remainder;
                            updatedCartBeanMap.get(cartItemId1).price = newListPrice;
                            updatedCartBeanMap.get(cartItemId1).subAmount = newListPrice * remainder;
                            system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId1));
                            //creat new row with quantity-reminder and pallet price
                            system.debug('quantity ------------------------------>'+ updatedCartMap.get(cartItemId1).ccrz__Quantity__c);
                            system.debug('cartItemId1 ------------------------------>'+cartItemId1);
                            String newPrdSku=updatedCartMap.get(cartItemId1).ccrz__Product__r.ccrz__SKU__c;
                            newCartItem =cc_oo_HelperController.addNewCartListItem(newPrdSku,quantity,cartId,palletPrice);
                            system.debug('new cartItem------'+newCartItem);
                            system.debug('newCartItem.id----->'+newCartItem.id);                   
                            updatedCartMap.put(newCartItem.id,newCartItem);
                            ccrz.cc_bean_CartItem cartItemBeannew = new ccrz.cc_bean_CartItem();
                            cartItemBeannew.itemID = newCartItem.id;
                            system.debug('id----->'+cartItemBeannew.itemID);
                            cartItemBeannew.mockProduct=new ccrz.cc_bean_MockProduct();
                            cartItemBeannew.mockProduct.id=newCartItem.ccrz__Product__r.Id;
                            //OO-2022 Product image on Cart page
                            cartItemBeannew.mediaWrapper = updatedCartBeanMap.get(cartItemId1).mediaWrapper;
                            //OO-2022 Product image on Cart page-ends 
                            cartItemBeannew.mockProduct.name=newCartItem.ccrz__Product__r.name;
                            cartItemBeannew.mockProduct.sku = prodSku;
                            cartItemBeannew.price = newCartItem.ccrz__Price__c;
                            cartItemBeannew.subAmount = newCartItem.ccrz__SubAmount__c;
                            cartItemBeannew.quantity = Integer.valueOf(newCartItem.ccrz__Quantity__c);
                            cartItemBeannew.mediaWrapper = updatedCartBeanMap.get(cartItemId1).mediaWrapper;
                            cartItemBeannew.qtySkipIncrement = updatedCartBeanMap.get(cartItemId1).qtySkipIncrement;
                            cartItemBeannew.qtyIncrement = updatedCartBeanMap.get(cartItemId1).qtyIncrement;
                            updatedCartBeanMap.put(cartItemBeannew.itemID,cartItemBeannew);
                            system.debug('new cartbeanItem------'+cartItemBeannew);
                        }*/
                 }
                //}
                if(listSize==2){
                    quantity=Integer.valueOf(cartvalueList[0].quantity)+Integer.valueOf(cartvalueList[1].quantity);
                    String cartItemId1=cartvalueList[0].itemID;
                    String cartItemId2=cartvalueList[1].itemID;
                    if(isAmended && isPrimary && (oldCartId!=null && oldCartId.get(cartItemId1)!=null)){
                        if(oldListSize<2){
                            //oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                            //if(oldRemainder!=0){
                                 newListPrice=oldListPrice;
                            //}
                        /*else if(oldListSize==2){
                                 newListPrice=oldListPrice;
                            }*/
                    }}
                    updatedCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                    updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                    updatedCartMap.get(cartItemId1).ccrz__Price__c = newListPrice;
                    updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = newListPrice * quantity;
                    updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c=newListPrice;
                    system.debug('quantity ------------------------------>'+ updatedCartMap.get(cartItemId1).ccrz__Quantity__c);
                    system.debug('cartItemId1 ------------------------------>'+cartItemId1+'cartitemid2-----'+cartItemId2);
                    //delete other row from cartitem
                    toDeleteCartItem.add(updatedCartMap.get(cartItemId2));
                    updatedCartMap.remove(cartItemId2);
                    //Update[0] cartbeanitem
                    updatedCartBeanMap.get(cartItemId1).quantity=quantity;
                    updatedCartBeanMap.get(cartItemId1).price = newListPrice;
                    updatedCartBeanMap.get(cartItemId1).subAmount = newListPrice * quantity;
                    system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId1));
                    system.debug('cartItemId ------------------------------>'+updatedCartMap.get(cartItemId1));
                    //delete other row from cartitembean
                    updatedCartBeanMap.remove(cartItemId2);
                    system.debug('second row with cartItemId2---'+cartItemId2+'--deleted');
                }
             /*if(listSize==2){
             quantity=Integer.valueOf(cartvalueList[0].quantity)+Integer.valueOf(cartvalueList[1].quantity);
             String cartItemId1=cartvalueList[0].itemID;
             String cartItemId2=cartvalueList[1].itemID;
             system.debug('cartItemId1 ------------------------------>'+cartItemId1);
             system.debug('cartItemId2 ------------------------------>'+cartItemId2);
             if(palletSize!=null){
                 quotient = quantity /palletSize;
                 remainder = math.mod(quantity , palletSize);
             }
             if(quotient!=0 && remainder==0)
             {
                //update [0] row with quantity and pallet price
                updatedCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                if(isAmended && isPrimary&&(oldCartId!=null && oldCartId.containsKey(cartItemId1))){
                             if(oldListSize<2){
                                if(palletSize!=null){
                                    oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                                }
                                if(oldRemainder==0){
                                    palletPrice=oldPalletprice;
                                }
                            }else if(oldListSize==2){
                                palletPrice=oldPalletprice;
                            }
                }
                updatedCartMap.get(cartItemId1).ccrz__Price__c = palletPrice;
                updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = palletPrice;
                updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = palletPrice * quantity;
                system.debug('quantity ------------------------------>'+ updatedCartMap.get(cartItemId1).ccrz__Quantity__c);
                system.debug('cartItemId1 ------------------------------>'+cartItemId1+'cartitemid2-----'+cartItemId2);
                //delete other row from cartitem
                toDeleteCartItem.add(updatedCartMap.get(cartItemId2));
                updatedCartMap.remove(cartItemId2);
                //Update[0] cartbeanitem
                updatedCartBeanMap.get(cartItemId1).quantity=quantity;
                updatedCartBeanMap.get(cartItemId1).price = palletPrice;
                updatedCartBeanMap.get(cartItemId1).subAmount = palletPrice * quantity;
                system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId1));
                system.debug('cartItemId ------------------------------>'+updatedCartMap.get(cartItemId1));
                //delete other row from cartitembean
                updatedCartBeanMap.remove(cartItemId2);
                system.debug('second row with cartItemId2---'+cartItemId2+'--deleted');
             }
             if(quotient!=0 && remainder!=0){
                quantity=quantity-remainder;
                //update [0] row with reminder and List price
               if(isAmended && isPrimary&&(oldCartId!=null && oldCartId.containsKey(cartItemId1))){
                             if(oldListSize<2){
                                if(palletSize!=null){
                                    oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                                }
                                if(oldRemainder==0){
                                    palletPrice=oldPalletprice;
                                }else{
                                    newListPrice=oldListprice;
                                }
                            }else if(oldListSize==2){
                                palletPrice=oldPalletprice;
                                newListPrice=oldListprice;
                            }
                }
                updatedCartMap.get(cartItemId1).ccrz__Quantity__c = remainder;
                updatedCartMap.get(cartItemId1).ccrz__Price__c = newListPrice;
                updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = newListPrice;
                updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = newListPrice * remainder;
                //Update[0] cartbeanitem
                updatedCartBeanMap.get(cartItemId1).quantity=remainder;
                updatedCartBeanMap.get(cartItemId1).price = newListPrice;
                updatedCartBeanMap.get(cartItemId1).subAmount = newListPrice * remainder;
                system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId1));
                //update [1] row with quantity-reminder and pallet price
                updatedCartMap.get(cartItemId2).ccrz__Quantity__c = quantity;
                updatedCartMap.get(cartItemId2).ccrz__Price__c = palletPrice;
                updatedCartMap.get(cartItemId2).cc_oo_UnitPrice__c = palletPrice;
                updatedCartMap.get(cartItemId2).cc_oo_IsListPrice__c = true;
                updatedCartMap.get(cartItemId2).ccrz__SubAmount__c = palletPrice * quantity;
                //Update[1] cartbeanitem
                updatedCartBeanMap.get(cartItemId2).quantity=quantity;
                updatedCartBeanMap.get(cartItemId2).price = palletPrice;
                updatedCartBeanMap.get(cartItemId2).subAmount = palletPrice * quantity;
                system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId2));
                system.debug('multiple product list to be updated');
             }
             if(quotient==0 && remainder!=0){
                 //update [0] row with quantity and pallet price
                updatedCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                updatedCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                if(isAmended && isPrimary&&(oldCartId!=null && oldCartId.containsKey(cartItemId1))){
                             if(oldListSize<2){
                                if(palletSize!=null){
                                    oldRemainder=math.mod(oldIdQuantity.get(oldCartvalueList[0]),palletSize);
                                }
                                if(oldRemainder!=0){
                                    newListPrice=oldListprice;
                                }
                         }else if(oldListSize==2){
                                newListPrice=oldListprice;
                            }
                }
                updatedCartMap.get(cartItemId1).ccrz__Price__c = newListPrice;
                updatedCartMap.get(cartItemId1).cc_oo_UnitPrice__c = newListPrice;
                updatedCartMap.get(cartItemId1).ccrz__SubAmount__c = newListPrice * quantity;
                system.debug('quantity ------------------------------>'+ updatedCartMap.get(cartItemId1).ccrz__Quantity__c);
                system.debug('cartItemId1 ------------------------------>'+cartItemId1+'cartitemid2-----'+cartItemId2);
                //delete other row from cartitem
                toDeleteCartItem.add(updatedCartMap.get(cartItemId2));
                updatedCartMap.remove(cartItemId2);
                //Update[0] cartbeanitem
                updatedCartBeanMap.get(cartItemId1).quantity=quantity;
                updatedCartBeanMap.get(cartItemId1).price = newListPrice;
                updatedCartBeanMap.get(cartItemId1).subAmount = newListPrice * quantity;
                system.debug('cartBeanItem------------------------------>'+updatedCartBeanMap.get(cartItemId1));
                system.debug('cartItemId ------------------------------>'+updatedCartMap.get(cartItemId1));
                //delete other row from cartitembean
                updatedCartBeanMap.remove(cartItemId2);
                system.debug('second row with cartItemId2---'+cartItemId2+'--deleted');
                }
          }*/
          }
          
          if(logs.size() > 0) {
          	insert logs;
          }
          
          if(!priceOptionList.isEmpty() && priceOptionList.size() > 0) {
            upsert priceOptionList;
          }
          List<ccrz__E_CartItem__c> cartListPriceitem=updatedCartMap.values();
          for(ccrz__E_CartItem__c clst : cartItemList){
                Decimal blkPrice=0;
                Decimal blkUnitPrice=0;
                system.debug('updating backend values------->'+updatedCartMap.get(clst.id));
                String typeOfProduct=clst.ccrz__Product__r.cc_oo_TypeOfProduct__c;
                if(updatedCartMap.containsKey(clst.id)){
                    if(typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                            if(clst.cc_oo_IsListPrice__c ){
                                 if(!prdPirceMap.isEmpty() && prdPirceMap.get(clst.ccrz__Product__r.ccrz__SKU__c) != null){
                                    blkPrice=prdPirceMap.get(clst.ccrz__Product__r.ccrz__SKU__c).cc_oo_NetListPrice__c;
                                 }
                                system.debug('bulk List price------->'+blkPrice);
                            }else{
                                blkPrice=clst.cc_oo_ContractPrice__r.cc_oo_ContractPrice__c;
                                system.debug('bulk contract price------->'+clst.cc_oo_ContractPrice__r.cc_oo_ContractPrice__c);
                            }
                            if(isAmended && isPrimary && (oldCartId!=null && oldCartId.get(clst.id)!=null)){
                                    blkPrice=oldItemMap.get(oldCartId.get(clst.id)).cc_oo_UnitPrice__c;
                            }
                            //updated 4543
                            Integer tonToLb=Integer.valueOf(LOLSettings__c.getValues('cc_oo_TON_TO_LB').Value__c); 
                            blkUnitPrice=blkPrice/tonToLb;
                            clst.ccrz__Price__c =blkPrice;
                            clst.cc_oo_UnitPrice__c = blkPrice;
                            clst.ccrz__SubAmount__c = blkUnitPrice*clst.ccrz__Quantity__c;
                            updatedCartBeanMap.get(clst.id).price = blkPrice;
                            updatedCartBeanMap.get(clst.id).subAmount = blkUnitPrice*clst.ccrz__Quantity__c;
                     }else{
                     	
                     		if(clst.cc_oo_IsListPrice__c ){
                     			if(!prdPirceMap.isEmpty() && prdPirceMap.get(clst.ccrz__Product__r.ccrz__SKU__c) != null){
                            		clst.ccrz__Price__c=prdPirceMap.get(clst.ccrz__Product__r.ccrz__SKU__c).cc_oo_NetListPrice__c;
                            	}
                     		} else {
                     			if(!productContractPriceMap.isEmpty() 
                     					&& productContractPriceMap.get(clst.cc_oo_ContractPrice__r.Name) != null){                    				
                            		clst.ccrz__Price__c=productContractPriceMap.get(clst.cc_oo_ContractPrice__r.Name).cc_oo_ContractPrice__c;
                            	}
                     		}
                            ccrz__E_CartItem__c currentCartitem=updatedCartMap.get(clst.id);
                            clst.ccrz__Quantity__c =currentCartitem.ccrz__Quantity__c;
                            //clst.ccrz__Price__c = currentCartitem.ccrz__Price__c;
                            
                            clst.cc_oo_UnitPrice__c = clst.ccrz__Price__c;
                            clst.cc_oo_IsListPrice__c = currentCartitem.cc_oo_IsListPrice__c;
                            clst.ccrz__SubAmount__c = clst.ccrz__Price__c*clst.ccrz__Quantity__c;
                  			updatedCartBeanMap.get(clst.id).price = clst.ccrz__Price__c;
                            updatedCartBeanMap.get(clst.id).subAmount = clst.ccrz__Price__c*clst.ccrz__Quantity__c;
                            //clst.ccrz__SubAmount__c = currentCartitem.ccrz__SubAmount__c;
                            ccrz__E_CartItem__c blkCurrentCartitem=updatedCartMap.get(clst.id);
                     }   
                        
                }
          }
          List<ccrz.cc_bean_CartItem> cartBeanListPriceitem=updatedCartBeanMap.values();
          system.debug('cartListPriceitem-------->'+cartListPriceitem);
          system.debug('cartBeanListPriceitem-------->'+cartBeanListPriceitem);
          cartBean.cartItems=cartBeanListPriceitem;
            System.debug('compute Cart price adjustment -->'+ cartBean.cartItems);
            
            update cartItemList; 
             if(toDeleteCartItem !=null){
                system.debug(' inside toDeleteCartItem');
            delete toDeleteCartItem; 
            }             
            inputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN,cartBean);
            
         }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'computePricingCart');            
            inputData.put(ccrz.cc_api_CartExtension.PARAM_CARTBEAN,cartBean);
        }
        return inputData;
    }
}