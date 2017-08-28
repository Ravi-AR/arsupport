/*Class Name - cc_oo_QuickOrderController
UserStory                   Description
OO-1540                     Quick Order feature
*************************************************************************************************************************************************/
global without sharing class cc_oo_QuickOrderController{
    
    public static final string CLASS_NAME = 'cc_oo_QuickOrderController';
    /*
        parseCSV - To load the csv data for quick Order featue
    **/            
    @RemoteAction
    global static ccrz.cc_RemoteActionResult parseCSV(final ccrz.cc_RemoteActionContext ctx,String csvBlob,String fileName, String sellerId ,String shipTo, string shipDString, String cartId)
    {   
        String csv;
        String errorMsg='';
        String maxLineMsg='';
        System.debug('*******parse CSV method************');
        ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
            
        try
        {   
            Integer count=0;
            List<String> skus = new List<String>();
            Map<String,String> prodMap = new Map<String,String>();
            Map<String,Object> newMap= new Map<String,Object>();
            if(fileName.contains('csv')){        
                if(csvBlob != null){
                    System.debug('csvBlob'+csvBlob);
                    csv = csvBlob;
                   
                    System.debug('CSV-----' + csv);
                    List<String> lines = csv.split('\n');
                    System.debug('lines'+lines);
                    boolean isFirst=true;
                    Integer maxLines = Integer.valueOf(LOLSettings__c.getAll().get('MaxCsvLines').Value__c);
                    System.debug('maxLines'+maxLines);
                    
                    for(String singleLine : lines){
                      System.debug('i am in');
                        if(!isFirst){
                            count++;
                            //loop though all the lines
                            System.debug('singleLine-----' + singleLine);
                            List<String> values = singleLine.split(',');
                            System.debug('values-----' + values);
                            String index='/'+String.valueof(count);
                            if(count<maxLines){
                              if(values[0] != null && (String.isEmpty(values[1]) || String.isBlank(values[1]))) {
                                values[1] = '0';
                              }
                              prodMap.put(values[0].trim()+index,values[1].trim());
                              }  
                            if(count==maxLines){
                                maxLineMsg = ccrz.cc_CallContext.pageLabels.get('File_Exceed_Limit');
                                newMap.put('maxLineMsg',maxLineMsg);
                                break;
                            }
                              
                        }
                        else{
                            List<String> values = singleLine.split(',');
                            if(values.size()>2){
                                errorMsg = ccrz.cc_CallContext.pageLabels.get('Invalid_File');
                                newMap.put('errorMsg',errorMsg);
                                break;
                            }
                            if(values[0] != null && (String.isEmpty(values[1]) || String.isBlank(values[1]))) {
                              values[1] = '0';
                            }
                            if(!('PRODUCTNO').equals(values[0].trim())|| !('QTY').equals(values[1].trim())){
                                errorMsg = ccrz.cc_CallContext.pageLabels.get('Invalid_File');
                                newMap.put('errorMsg',errorMsg);
                                break;
                            }
                            isFirst=false;                  
                        }  
                    }
                    System.debug('prodMap---->' + prodMap);
                    if(prodMap!=null && !prodMap.isEmpty()){
                    /* calling getProduct details */
                    resp = getProductDetails(ctx, null, sellerId ,shipTo, shipDString, prodMap,cartId);//OO-1180
                    /* calling getProduct details */

                    Map<string, Object> returnedMap= (Map<string, Object>)resp.data; 
                    newMap.put('prodMap',returnedMap);
                    }
                    resp.success=true; 
                    resp.data=newMap;             
                }
                else{
                    errorMsg = ccrz.cc_CallContext.pageLabels.get('Corrupted_File');
                    newMap.put('errorMsg',errorMsg);
                    resp.success=true;
                    resp.data=newMap;     
                }
            }
            else{
                errorMsg = ccrz.cc_CallContext.pageLabels.get('Invalid_File');
                newMap.put('errorMsg',errorMsg);
                resp.success=true;
                resp.data=newMap;     
            }
        }
        catch (Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'parseCSV');
        }
        finally{
            ccrz.ccLog.close(resp);
        }
        return resp;
    }
    
    /* 
        Method: getCartDetails
        To get cart details
    **/
    global static ccrz__E_Cart__c globalCart {get;set;}
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCartDetails(final ccrz.cc_RemoteActionContext ctx, string cartId, string sellerId, string shipTo, string shipDate){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus----');      
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        List<ccrz__E_Cart__c> listPrimaryNSecondary = new List<ccrz__E_Cart__c>();
        Id secondaryCartId;
        try
        {  
          if(cartId != null && cartId != 'undefined' && cartId != '{}' && cartId != ''){
              List<ccrz__E_Cart__c> cart = [select id, cc_oo_Seller__c,cc_oo_ShipToAccount__c, ccrz__RequestDate__c, ccrz__EncryptedId__c, 
                          cc_oo_SplitCart__c, cc_oo_SplitCartType__c,
                          (select id, ccrz__Product__c, ccrz__Product__r.cc_oo_TypeOfProduct__c, ccrz__Product__r.ccrz__sku__c,cc_oo_IsListPrice__c,
                          ccrz__Quantity__c, cc_oo_ContractPrice__c, cc_oo_ContractPrice__r.Name , ccrz__Cart__c
                          from ccrz__E_CartItems__r) 
                          from ccrz__E_Cart__c where ccrz__EncryptedId__c =: cartId];
  
              if(cart.size() > 0){
                  listPrimaryNSecondary.add(cart[0]);
                  if(cart[0].cc_oo_SplitCart__c != null){
                      secondaryCartId =  cart[0].cc_oo_SplitCart__c;
                      List<ccrz__E_Cart__c> secondaryCart = [select id, cc_oo_Seller__c,cc_oo_ShipToAccount__c, ccrz__RequestDate__c, 
                          ccrz__EncryptedId__c, cc_oo_SplitCart__c, cc_oo_SplitCartType__c,
                          (select id, ccrz__Product__c, ccrz__Product__r.cc_oo_TypeOfProduct__c, ccrz__Product__r.ccrz__sku__c,cc_oo_IsListPrice__c,
                          ccrz__Quantity__c, cc_oo_ContractPrice__c, cc_oo_ContractPrice__r.Name , ccrz__Cart__c
                          from ccrz__E_CartItems__r) 
                          from ccrz__E_Cart__c where Id =: secondaryCartId];
                      if(secondaryCart.size() > 0){
                          listPrimaryNSecondary.add(secondaryCart[0]);
                      }
                  }
                  res.success = true;
                  res.data = listPrimaryNSecondary; //cart[0];
  
              }
          }else{
            ccrz__E_Cart__c cart = cc_oo_HeaderController.mapToCart(sellerId, shipTo, false);
                cart.ccrz__RequestDate__c = date.parse(shipDate);
                update cart;
                List<ccrz__E_Cart__c> carts = [select id, cc_oo_Seller__c,cc_oo_ShipToAccount__c, ccrz__RequestDate__c, ccrz__EncryptedId__c, 
                            cc_oo_SplitCart__c, cc_oo_SplitCartType__c,
                            (select id, ccrz__Product__c, ccrz__Product__r.cc_oo_TypeOfProduct__c, ccrz__Product__r.ccrz__sku__c,cc_oo_IsListPrice__c,
                            ccrz__Quantity__c, cc_oo_ContractPrice__c, cc_oo_ContractPrice__r.Name , ccrz__Cart__c
                            from ccrz__E_CartItems__r) 
                            from ccrz__E_Cart__c where id =: cart.Id];
                if(carts.size() > 0){
                    listPrimaryNSecondary.add(carts[0]);
                }
                res.data = listPrimaryNSecondary;
                res.success = true;
          }
        }catch(Exception ex){
          cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCartDetails');
            //System.debug(ex + ' '+ ex.getStackTraceString());
            res.data= ex.getMessage();
        }
        return res;
    }

    /* 
        Method: getProductDetails
        To get complete product details which include pricing, contract details
    **/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductDetails(final ccrz.cc_RemoteActionContext ctx, map<string,string> products, String sellerId ,string shipTo, string shipDString, map<string, string> excelData, String cartId){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus----');      
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        boolean isExcelLoad = false;
        List<cc_oo_PriceList__c> listPriceListUpdate = new List<cc_oo_PriceList__c>();
        List<cc_oo_ErrorLog__c> logs =  new List<cc_oo_ErrorLog__c>();
        system.debug('globalCart-->' + globalCart);
       // map<String,String> tempProducts=new map<String,String>();
        /*if(products!=null && products.size()>0){
          
          tempProducts=products;
        }*/
  /* JDE Price call changes */
        string sellerCode;
        Id shipToSFId;
        List<ccrz__E_Cart__c> carts = [select id, cc_oo_Seller__c, cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_ShipToAccount__c,ccrz__RequestDate__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId LIMIT 1];
        if(carts.size() > 0){
            sellerCode = carts[0].cc_oo_Seller__r.ccrz__SellerId__c;
            shipToSFId = carts[0].cc_oo_ShipToAccount__c;
        }
                            
        /* JDE Price Call changes */
        try
        {   Map<string, Object> dataMap = new Map<string, Object>();
            if(excelData != null && excelData.size() > 0){
               // if(excelData.size() > 0){
                    isExcelLoad = true;
                    products = new map<string,string>();
                    //tempProducts=new map<String,String>();
                    integer i = 0;
                    for(string sku: excelData.keySet()){
                        List<String> prodSku= sku.split('/');
                        products.put('p'+ i+'/'+excelData.get(sku), prodSku[0]);
                        i++;
                    }
                    System.debug('products--->' + products);
                //}
            }
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus try----');
            
            String errorMsg='';
            String mess='';
            
            /*List<ccrz__E_ProductInventoryItem__c> inventorySkus= [select ccrz__ProductItem__r.ccrz__SKU__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__r.ccrz__SKU__c IN :products.values() and cc_oo_Seller__c =:sellerId];*/
            
            List<ccrz__E_Product__c> prodSkus =[select ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c IN :products.values()];
            Set<String> validSkus= new Set<String>();
            Set<string> allValidProducts = new Set<string>();//OO-4953
            for(ccrz__E_Product__c prod :prodSkus){
                validSkus.add(prod.ccrz__SKU__c);
            }
            allValidProducts.addAll(validSkus);//OO-4953
            
            //if(excelData != null){
                List<String> prodVal= new List<String>();
                prodVal = products.values();
                Set<String> prodValues = new Set<String>(prodVal);
                Set<String> invalidSkus= new Set<String>();
                for(String csvValue:prodValues){
                    if(!validSkus.contains(csvValue)){
                        invalidSkus.add('%'+csvValue);
                    }
                }
            
                List<ccrz__E_Product__c> myList =[select ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c LIKE :invalidSkus];
                String matchRegex='(?<!\\d)0+(?=\\d+)';
                map<string,string> flashProducts  =new map<string,string>();
                for(ccrz__E_Product__c matchProduct :myList){
                    String sku=(matchProduct.ccrz__SKU__c);
                    String trimmedSku=sku;
                    if(sku.startsWith('0')){
                        trimmedSku=sku.replaceFirst(matchRegex, '');
                    }
                    if(invalidSkus.contains('%'+trimmedSku)){
                        validSkus.add(sku);
                        allValidProducts.add(sku);
                    }
                    for(String index :products.keySet()){
                        if(trimmedSku==products.get(index)){
                          flashProducts.put(index,sku);
                          System.debug(flashProducts);
                            //products.put(index,sku);
                        }
                    }
                }
                map<String,String> tempProducts=new map<String,String>(products);
                //tempProducts.putAll(products);
                tempProducts.putAll(flashProducts);
                products=tempProducts;
                System.debug(products);
            //}
            
            
            List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select ccrz__AvailabilityMessage__c,ccrz__Status__c,cc_oo_MinQuantity__c,
                                                                    cc_oo_IsOnlyPalletProduct__c,cc_oo_PalletSize__c,ccrz__ProductItem__r.cc_oo_TypeOfProduct__c,
                                                                    ccrz__ProductItem__r.ccrz__SKU__c,ccrz__ProductItem__c,
                                                                    ccrz__ProductItem__r.ccrz__UnitOfMeasure__c,ccrz__ProductItem__r.Id,ccrz__ProductItem__r.cc_oo_UoMDesc__c,
                                                                    ccrz__ProductItem__r.Name, cc_oo_LeadTime__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__r.ccrz__SKU__c IN :products.values() and cc_oo_Seller__c =:sellerId];

      //Defect: 4852
            /*List<ccrz__E_Product__c> productList = [select ccrz__SKU__c,ccrz__ProductId__c from ccrz__E_Product__c where ccrz__SKU__c IN :products.values()];
            Map<string,ccrz__E_Product__c> mapProdList = new Map<string, ccrz__E_Product__c>();
            for(ccrz__E_Product__c product: productList){
              mapProdList.put(product.ccrz__SKU__c, product);
            }*/
            
            Map<string, ccrz__E_ProductInventoryItem__c> mapProdInventory = new Map<string, ccrz__E_ProductInventoryItem__c>();
            Map<string, id> mapProducts = new Map<string, id>();         
               
            for(ccrz__E_ProductInventoryItem__c inventoryItem: inventoryItems){
                mapProdInventory.put(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c, inventoryItem);
                mapProducts.put(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c,inventoryItem.ccrz__ProductItem__c);
            }
            
            if(String.isBlank(shipDString) || shipDString=='null'){              
                    Date leadDate= Date.today();
                    if(!inventoryItems.isEmpty()) {  
                        String[] splitLead = (inventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                        Integer leadTime = Integer.valueOf(splitLead[0]);
                        leadDate = leadDate.addDays(leadTime);                                                
                        for(ccrz__E_ProductInventoryItem__c productInventory : inventoryItems) {
                            String[] splitLeadAll = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                            Integer leadTimeAll = Integer.valueOf(splitLeadAll[0]);
                            Date leadDateAll= Date.today();
                            leadDateAll = leadDateAll.addDays(leadTimeAll);
                            if(leadDate < leadDateAll) {
                                leadDate = leadDateAll;
                            }   
                        }
                        Date finalLeadDate = cc_oo_HelperController.getHolidayLeadDate(sellerId, leadDate);
                        
                        DateTime dt = datetime.newInstance(finalLeadDate.year(), finalLeadDate.month(), finalLeadDate.day()); 
                        shipDString = dt.format('MM/dd/YYYY');
                                  
                        carts[0].ccrz__RequestDate__c = finalLeadDate;
                        update carts[0];
                        }                
                    }

            //Validation - 2
            List<String> productSkuIdList=getProducts(products.values(),sellerId,cartId);
            Set<string> setValidSellerProducts = new set<string>(productSkuIdList);
            System.debug('sellerId'+sellerId);
            map<string, cc_oo_ProductPrice> mapPriceListItems = getPriceListItems(mapProducts, sellerId, shipToSFId);
            map<string, List<cc_oo_ContractPrice>> mapContractItems = getContracts(mapProducts, sellerId, shipToSFId, shipDString);

            //Validation - 3
            map<string, List<string>> mapRelatedProducts = getRelatedProducts(products, sellerId, shipTo,cartId);

            cc_oo_Product prod = new cc_oo_Product();
            ccrz__E_Product__c validProduct = new ccrz__E_Product__c();//4852
            ccrz__E_ProductInventoryItem__c inventoryItem = new ccrz__E_ProductInventoryItem__c();  
            for(string prodItem: products.keySet()){
                String prodId = products.get(prodItem);
                String quantity=null;
                
                if(excelData != null){
                    List<String> indexList=prodItem.split('/');
                    quantity=indexList[1];
                    prodItem=indexList[0];
                }
                
                inventoryItem = mapProdInventory.get(prodId);
                //validProduct = mapProdList.get(prodId);//4852
                prod = new cc_oo_Product();
                prod.sku = prodId;
                prod.index = prodItem;
                if(quantity!=null){
                prod.quantity=quantity;
                }



                //validation - 1
                if(!allValidProducts.contains(prodId)){//4852
                    //Validation - Invalid product number 
                    prod.errorMessage = ccrz.cc_CallContext.pageLabels.get('Invalid_Product_number');
                    dataMap.put(prodItem, prod);
                    continue;
                }else if(inventoryItem==null || !setValidSellerProducts.contains(prodId)){ //validation - 2, 4852
                    prod.errorMessage = ccrz.cc_CallContext.pageLabels.get('Prod_Num_Not_Sold');
                    dataMap.put(prodItem, prod);
                    continue;
                }else if(inventoryItem.ccrz__Status__c == 'Replaced'){
                    List<string> relatedProductSKU = new List<string>();
                    if(mapRelatedProducts.size() > 0){
                        if(mapRelatedProducts.get(prodId) != null){
                            relatedProductSKU = mapRelatedProducts.get(prodId);
                        }
                    }
                    string errMsg = ccrz.cc_CallContext.pageLabels.get('Prod_Disc_Replacement');
                    prod.errorMessage = string.format(errMsg,relatedProductSKU);
                    dataMap.put(prodItem, prod);
                    continue;
                }else if(inventoryItem.ccrz__Status__c == 'Out of Season'){
                    List<string> relatedProductSKU = new List<string>();
                    if(mapRelatedProducts.size() > 0){
                        if(mapRelatedProducts.get(prodId) != null){
                            relatedProductSKU = mapRelatedProducts.get(prodId);
                        }
                    }
                    string errMsg = ccrz.cc_CallContext.pageLabels.get('Product_Out_Of_Season');
                    prod.errorMessage = string.format(errMsg,relatedProductSKU);
                    dataMap.put(prodItem, prod);
                    continue;
                }else if(inventoryItem.ccrz__Status__c == 'Unavailable'){
                    List<string> relatedProductSKU = new List<string>();
                    if(mapRelatedProducts.size() > 0){
                        if(mapRelatedProducts.get(prodId) != null){
                            relatedProductSKU = mapRelatedProducts.get(prodId);
                        }
                    }
                    string errMsg = ccrz.cc_CallContext.pageLabels.get('Product_Unavailable');
                    prod.errorMessage = string.format(errMsg,relatedProductSKU);
                    dataMap.put(prodItem, prod);
                    continue;
                }else if(inventoryItem.ccrz__Status__c == 'Discontinued'){
                    prod.errorMessage = ccrz.cc_CallContext.pageLabels.get('Prod_Disc_Without_Replacement');
                    dataMap.put(prodItem, prod);
                    continue;
                }else{
                    prod.productId = inventoryItem.ccrz__ProductItem__c;
                    prod.typeOfProduct = inventoryItem.ccrz__ProductItem__r.cc_oo_TypeOfProduct__c;
                    prod.fullPalletReq = inventoryItem.cc_oo_IsOnlyPalletProduct__c==true?'true':'false';
                    prod.UOM = inventoryItem.ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
                    String pluralUOM = cc_oo_pluralUOM__c.getValues(inventoryItem.ccrz__ProductItem__r.ccrz__UnitOfMeasure__c).plural__c;
                    prod.pUOM=pluralUOM;
                    prod.palletSize = string.valueOf(inventoryItem.cc_oo_PalletSize__c);
                    prod.status = inventoryItem.ccrz__Status__c;
                    prod.availabilityMessage = inventoryItem.ccrz__AvailabilityMessage__c;
                    //prod.isToteProduct = inventoryItem.ccrz__ProductItem__r.cc_oo_isToteProduct__c==true?'true':'false';
                    prod.errorMessage = '';
                    if(excelData != null && quantity != null){
                       // if(quantity != null){
                            prod.quantity = quantity;  
                            if(!(prod.quantity).isNumeric()) {
                            prod.errorMessage = ccrz.cc_CallContext.pageLabels.get('Invalid_Quantity');
                            }
                       // }
                    }
                      prod.UOMD    =  inventoryItem.ccrz__ProductItem__r.cc_oo_UoMDesc__c==null?'UOM':inventoryItem.ccrz__ProductItem__r.cc_oo_UoMDesc__c;
                        prod.minQuantity =  inventoryItem.cc_oo_MinQuantity__c == null?'0':String.valueof(inventoryItem.cc_oo_MinQuantity__c);
                        prod.palletSize =  inventoryItem.cc_oo_PalletSize__c == null?'0':String.valueof(inventoryItem.cc_oo_PalletSize__c);
                        prod.quantityErrorMessage=''; 
                        /*if(inventoryItem.ccrz__ProductItem__r.cc_oo_TypeOfProduct__c=='BAG'){         
                            if(inventoryItem.cc_oo_IsOnlyPalletProduct__c){
                                prod.palletSize =  inventoryItem.cc_oo_PalletSize__c == null?'1':String.valueof(inventoryItem.cc_oo_PalletSize__c);
                                if(isExcelLoad == true){
                                    if((prod.quantity).isNumeric()){
                                    if(Integer.valueOf(quantity) < Integer.valueOf(prod.minQuantity)){
                                            string errMsg = ccrz.cc_CallContext.pageLabels.get('Quant_Not_Full_Pallet');
                                            prod.errorMessage = string.format(errMsg, new string[]{prod.minQuantity});
                                    }
                                }
                                }
                            
                            }else if(!inventoryItem.cc_oo_IsOnlyPalletProduct__c){
                                prod.minQuantity = inventoryItem.cc_oo_MinQuantity__c == null?'1':String.valueof(inventoryItem.cc_oo_MinQuantity__c);
                                    if(isExcelLoad == true){
                                        if((prod.quantity).isNumeric()){
                                        if(Integer.valueOf(quantity) < Integer.valueOf(prod.minQuantity)){
                                        string errMsg = ccrz.cc_CallContext.pageLabels.get('Quant_Below_Min_Quantity');
                                        prod.errorMessage = string.format(errMsg, new string[]{prod.minQuantity});
                                    }
                                    }
                                }
                            }
                        }*/
                    

                    String leadTime = inventoryItem.cc_oo_LeadTime__c == ''?'': inventoryItem.cc_oo_LeadTime__c;
                    if(leadTime.contains(' ')){
                      String[] leadTimeStr=leadTime.split(' ');
                      leadTime=leadTimeStr[0];  
                    }
                    prod.leadTime=leadTime;
                    prod.shortDescription = inventoryItem.ccrz__ProductItem__r.Name;
                    prod.priceOption = 'Select a Price';
                    if(mapPriceListItems.get(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c) != null){
                        prod.price = mapPriceListItems.get(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c);
            /* JDE Price Call to get price */
                        if(inventoryItem.Id != null){
                            if(prod.price.netListPrice == null || prod.price.netListPrice == ''){
                                
                                string jdePrice = getJDEPrice(shipTo, shipToSFId, sellerId, sellerCode, inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c, inventoryItem.ccrz__ProductItem__c, prod.price.sfId,listPriceListUpdate, logs,inventoryItem.ccrz__ProductItem__r.cc_oo_TypeOfProduct__c); 
                                if(jdePrice != null){
                                    prod.price.netListPrice = jdePrice;
                                }
                                else{
                                  prod.errorMessage =ccrz.cc_CallContext.pageLabels.get('JDEDownPriceMessage_QuickOrder');
                                }
                            }
                        }
                        /* JDE Price call to get Price */
                    }else{
                        
                        string jdePrice = getJDEPrice(shipTo, shipToSFId, sellerId, sellerCode, inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c, inventoryItem.ccrz__ProductItem__c, null,listPriceListUpdate, logs,inventoryItem.ccrz__ProductItem__r.cc_oo_TypeOfProduct__c); 
                        cc_oo_ProductPrice newPrice= new cc_oo_ProductPrice();
            if(jdePrice != null){
              newPrice.netListPrice = jdePrice;
                  newPrice.unitOfMeasure = inventoryItem.ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
                  newPrice.unitOfMeasureDesc = inventoryItem.ccrz__ProductItem__r.cc_oo_UoMDesc__c;                        
                  prod.price=newPrice;
                        }
                        else{
                            prod.errorMessage =ccrz.cc_CallContext.pageLabels.get('JDEDownPirceMessage');
                        }
                    }

                    if(mapContractItems.get(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c) != null){
                        prod.contracts = mapContractItems.get(inventoryItem.ccrz__ProductItem__r.ccrz__SKU__c);
                    }else{
                          if(prod.price!=null){
                            prod.priceOption = 'List Price';
                        }
                        else{
                          prod.priceOption = null;
                        }  
                    }
                    System.debug('prod--->' + prod);
                    dataMap.put(prodItem, prod);    
                }
                
            }
            
            system.debug('listPriceListUpdate---->' + listPriceListUpdate);
            if(listPriceListUpdate.size() > 0){
                upsert listPriceListUpdate;
            }
            system.debug('logs--->' + logs);
            if(logs.size() > 0){
                insert logs;
            }
            res.success = true;
            res.data = dataMap;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus try end----');
        }catch (Exception ex){
          cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductDetails');
            //System.debug(err + ' '+ err.getStackTraceString());
            res.data= ex.getMessage();
        }
        return res;
    }


    public static string getJDEPrice(string shipTo, ID shipToSFId, string sellerId, string sellerCode, string sku, Id skuId, Id priceId, List<cc_oo_PriceList__c> listPriceListUpdate, List<cc_oo_ErrorLog__c> logs,String typeOfProduct){
        string netListPrice=null;    
        
        try{
            cc_oo_ServiceData__c priceServiceData = cc_oo_ServiceData__c.getValues('RetrievePrice');
            cc_oo_PriceList__c priceOption = new cc_oo_PriceList__c();
            
            cc_oo_JDEPriceRequest.Params paramsReq = new cc_oo_JDEPriceRequest.Params();
            paramsReq.AN8_ShipToNUmber = shipTo;
            paramsReq.MCU_BranchPlant = sellerCode;
            paramsReq.DCTO_OrderType = priceServiceData.cc_oo_OrderType__c;
            paramsReq.LITM_ItemNumber = sku;
            paramsReq.VERS_P4210Version = priceServiceData.cc_oo_P4210Version__c;
            //paramsReq.szFreightHandlingCode = priceServiceData.cc_oo_szFreightHandlingCode__c;

            cc_oo_JDEPriceRequest priceReq = new cc_oo_JDEPriceRequest();
            priceReq.params = paramsReq;
            Map<string, Object> responseData = cc_oo_servicePriceCallOut.getProductPrice(priceReq);

            cc_oo_JDEPriceResponse resp = (cc_oo_JDEPriceResponse)responseData.get('response');
            if(responseData.get('logs') != null){
                logs.addAll((List<cc_oo_ErrorLog__c>)responseData.get('logs'));
            }
            if(resp != null){
                if(resp.callMethod.errors == null){
                    if(resp.callMethod.Params != null){
                        if(priceId != null){
                            cc_oo_PriceList__c price = new cc_oo_PriceList__c();
                            price.Id = priceId;
                            String SecUOM=resp.callMethod.Params.UOM_Pricing;
                          if(typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
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
                             } else {
                              price.cc_oo_isfreightincluded__c = false;
                            }
                            //update price; 
                            listPriceListUpdate.add(price);   
                        }else {
                            priceOption.cc_oo_Seller__c = sellerId;
                            priceOption.cc_oo_Product__c = skuId;
                            priceOption.cc_oo_ShipTo__c = shipToSFID; 
                            priceOption.cc_oo_EffectiveDate__c = Date.today(); 
                            priceOption.cc_oo_ExpirationDate__c = Date.today() + 7; 
                            priceOption.cc_oo_IsJDEPriceUpdated__c = true;
                            String SecUOM=resp.callMethod.Params.UOM_Pricing;
                          if(typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                           priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2);//Pricing Update - 4323
                             netListPrice =String.valueOf((decimal.valueof(resp.callMethod.Params.UPRC_UnitPrice)).setScale(2));
                          }else{
                              priceOption.cc_oo_NetListPrice__c = (decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2);//Pricing Update - Shri
                             netListPrice = String.valueOf((decimal.valueof(resp.callMethod.Params.mnAmountExtendedPrice)).setScale(2));
                          }
                          if(resp.callMethod.Params.szFreightHandlingCode == '1') {
                              priceOption.cc_oo_isfreightincluded__c = true;
                             } else {
                              priceOption.cc_oo_isfreightincluded__c = false;
                            }
                            //insert priceOption;
                            listPriceListUpdate.add(priceOption);
                        }
                    }
                }
            }
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getJDEPrice');
        }
        return netListPrice;
    }
    /* 
        Method: insertCartItems
        To get cart details
    **/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult insertCartItems(final ccrz.cc_RemoteActionContext ctx, string mapCartItems, string redirectPath, string products,
        string encryptedCartId, string sid, string shipTo,string shipDate){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getProductDetailStatus----');      
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        Map<String,Object> dataMap= new Map<String,Object>();
        try
        {
            JSONParser parserProd = JSON.createParser(products);
            Map<string,cc_oo_Product> mapNewProducts = (Map<string,cc_oo_Product>)parserProd.readValueAs(Map<string,cc_oo_Product>.class);

            List<ccrz__E_Cart__c> listCart = [select id, ccrz__RequestDate__c, cc_oo_SplitCart__c, cc_oo_SplitCartType__c, ccrz__EncryptedId__c, ccrz__ShipMethod__c,
                                                cc_oo_SplitCart__r.cc_oo_SplitCartType__c, cc_oo_SplitCart__r.ccrz__RequestDate__c, cc_oo_SplitCart__r.ccrz__EncryptedId__c 
                                                 from ccrz__E_Cart__c where ccrz__EncryptedId__c =: encryptedCartId];

            JSONParser parser = JSON.createParser(mapCartItems);
            Map<string,cc_oo_cart> mapNewCartItems = (Map<string,cc_oo_cart>)parser.readValueAs(Map<string,cc_oo_cart>.class);
            
            Boolean status = convertToCartList(mapNewCartItems.values(), mapNewProducts, listCart[0],sid,shipTo);
            if(status == true){
                res.data = redirectPath;
                res.success = true;
            }else{
                res.success = false;
            }
        }catch(Exception ex){
            res.data= ex.getMessage();
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'insertCartItems');
        }
        return res;
    }
    
    /* 
        Method: getOrderDetails
        To get order details
    **/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderDetails(final ccrz.cc_RemoteActionContext ctx, string orderId,string sellerId, string shipTo, string shipDString, String cartId){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'LSBDebug','----Inside getOrderDetails----');      
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        Map<string, Object> newMap= new Map<string, Object>(); 
        Map<string, Object> dataMap= new Map<string, Object>(); 
        try
        {
            Map<string,string> mapProducts = new Map<string,string>();
            Set<Id> productId = new Set<Id>();
            List<ccrz__E_OrderItem__c> listOrderItems = [select id, ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c from ccrz__E_OrderItem__c where ccrz__Order__c =: orderId];
            Integer count=0;
      List<ccrz__E_Cart__c> cartDetail = [select ccrz__RequestDate__c,ccrz__ShipMethod__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId LIMIT 1];
            
            if(!listOrderItems.isEmpty()){
                for(ccrz__E_OrderItem__c orderItem:listOrderItems){
                    count++;
                    String index='/'+String.valueof(count);
                    productId.add(orderItem.ccrz__Product__r.Id);
                    mapProducts.put(orderItem.ccrz__Product__r.ccrz__SKU__c+index,String.valueOf(orderItem.ccrz__Quantity__c));
                }
                if(String.isBlank(shipDString) || shipDString=='null'){
                    List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_LeadTime__c 
                                                                            from ccrz__E_ProductInventoryItem__c
                                                                            where ccrz__ProductItem__c IN :productId 
                                                                            and cc_oo_Seller__c=:sellerId];
                                
                    Date leadDate= Date.today();
                    if(!inventoryItems.isEmpty()) {  
                        String[] splitLead = (inventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                        Integer leadTime = Integer.valueOf(splitLead[0]);
                        leadDate = leadDate.addDays(leadTime);                                                
                        for(ccrz__E_ProductInventoryItem__c productInventory : inventoryItems) {
                            String[] splitLeadAll = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                            Integer leadTimeAll = Integer.valueOf(splitLeadAll[0]);
                            Date leadDateAll= Date.today();
                            leadDateAll = leadDateAll.addDays(leadTimeAll);
                            if(leadDate < leadDateAll) {
                                leadDate = leadDateAll;
                            }   
                        }
                        Date finalLeadDate = cc_oo_HelperController.getHolidayLeadDate(sellerId, leadDate);
                        
                        DateTime dt = datetime.newInstance(finalLeadDate.year(), finalLeadDate.month(), finalLeadDate.day()); 
                        shipDString = dt.format('MM/dd/YYYY');
                                  
                        /*cartDetail[0].ccrz__RequestDate__c = leadDate;
                        update cartDetail[0];*/
                        }
                        newMap.put('shippingDate',shipDString); 
                        
                    }
                            
                } 
        dataMap=cc_oo_HelperController.shuffleCart(cartId,shipDString,cartDetail[0].ccrz__ShipMethod__c,false);
                /*res = getProductDetails(ctx, null, sellerId ,shipTo, shipDString, mapProducts,cartId);
                Map<string, Object> returnedMap= (Map<string, Object>)res.data; 
                    
                newMap.put('prodMap',returnedMap);*/
                newMap.put('mapProducts',mapProducts);
                res.success=true;
                res.data=newMap;
        }catch(Exception ex){
            res.data= ex.getMessage();
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderDetails');
        }
        return res;
    }

    /* 
        Method: convertToCartList
        To convert the bean to ccrz__E_CartItem__c
    **/
    public static Boolean convertToCartList(List<cc_oo_cart> cartItems, map<string, cc_oo_Product> mapProducts, ccrz__E_Cart__c cart,
        string sid, string shipTo){
        List<List<ccrz__E_CartItem__c>> listOfCartItemSets = new List<List<ccrz__E_CartItem__c>>();
        List<ccrz__E_CartItem__c> listPrimaryCartItems = new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> listSecondaryCartItems = new List<ccrz__E_CartItem__c>();
        //OO-2778 - Starts
        String shippingMethod = cart.ccrz__ShipMethod__c;
        if(String.isNotBlank(shippingMethod)){
            String[] splitShippingMethod = shippingMethod.split(' - ');
            if(splitShippingMethod.size() > 1) {
              shippingMethod = splitShippingMethod[1].deleteWhitespace().toUpperCase();
          } else {
            shippingMethod=splitShippingMethod[0].deleteWhitespace().toUpperCase();
          } 
        }
        else{
            shippingMethod=null;
        } 
        //OO-4839
        Map<String,Date> leadTimeMap= new Map<String,Date>();
        integer leadTimeInteger;
        Boolean primaryAddLeadDay = cc_oo_HelperController.getCurrentAndCutOffTime(cartItems[0].productType, sid, shippingmethod);
        
        Date maxLeadTimeDate = Date.Today();
        for(cc_oo_cart cartItem :cartItems){
          leadTimeInteger = Integer.valueOf(cartItem.leadTime.split('\\s+')[0]);
          if(primaryAddLeadDay){
            leadTimeMap.put(cartItem.sku,Date.Today()+leadTimeInteger+1);
            if(maxLeadTimeDate < Date.Today()+leadTimeInteger+1){
              maxLeadTimeDate = Date.Today()+leadTimeInteger+1;  
            }
          }
          else{
            leadTimeMap.put(cartItem.sku,Date.Today()+leadTimeInteger);
            if(maxLeadTimeDate < Date.Today()+leadTimeInteger){
              maxLeadTimeDate = Date.Today()+leadTimeInteger;  
            }
          }
        }
        
        Date dayToday = Date.today(); 
        Date futureMonth = dayToday.addMonths(5);
        List<CC_OO_PlantHolidayCalendar__c> holidayCalendarList= [Select Id, cc_oo_Holiday__c, cc_oo_Month__c,  cc_oo_Year__c from CC_OO_PlantHolidayCalendar__c 
                                    where cc_oo_Holiday__c >= :dayToday AND cc_oo_Holiday__c <=:futureMonth  
                                    AND cc_oo_Plant__c = :sid ORDER BY cc_oo_Holiday__c ASC];
        
        Map<string, Date> mapFinalLeadDate = cc_oo_HelperController.getPlantHolidayLeadDate(holidayCalendarList, leadTimeMap);
        //OO-4839
        ccrz__E_CartItem__c splitCartItem = null; 
        Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
        
        Savepoint sp = Database.setSavepoint();

        date highestLeadTime = cart.ccrz__RequestDate__c;
        
        List<ccrz__E_Cart__c> secondaryCartList = [select id, ccrz__EncryptedId__c, cc_oo_SplitCartType__c,ccrz__ActiveCart__c, cc_oo_SplitCart__r.ccrz__EncryptedId__c,ccrz__RequestDate__c
                                from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open'
                                AND ccrz__ActiveCart__c = False AND cc_oo_SplitCartType__c = 'Secondary' AND cc_oo_SplitCart__c = :cart.Id];
  
  
        try{
            for(cc_oo_cart cartItem: cartItems){
                
                /*List<ccrz__E_PriceListItem__c> priceListItem=[SELECT ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_PriceListItem__c WHERE 
                ccrz__Product__r.ccrz__SKU__c =:cartItem.sku AND 
                ccrz__Pricelist__c IN 
                (SELECT ccrz__Pricelist__c FROM ccrz__E_AccountGroupPriceList__c WHERE ccrz__Pricelist__r.ccrz__Seller__c=:cartItem.seller and ccrz__Pricelist__r.ccrz__Enabled__c=true AND ccrz__AccountGroup__c=:accGroup) AND cc_oo_IsPreBook__c=false];*/
                
                Integer cartItemQuantity = Integer.valueOf(cartItem.quantity);

                splitCartItem = null;
                //ccrz__E_CartItem__c newCartItem = new ccrz__E_CartItem__c();
                //newCartItem.ccrz__Cart__c = cartItem.cartId;
                Map<String, Object> cartItemMap = new Map<String, Object>();
                cc_oo_Product currentProd;
                if(cartItem.category != null && cartItem.category != ''){
                    cartItemMap.put('category', cartItem.category);
                    //newCartItem.ccrz__Category__c = cartItem.category;
                }
                cartItemMap.put('storeID', cartItem.storeID);
                cartItemMap.put('product', cartItem.product);
                //newCartItem.ccrz__StoreID__c = cartItem.storeID;
                //newCartItem.ccrz__Product__c = cartItem.product;
                //2752
                
                if(cartItem.palletPrice != null) {
                    cartItemMap.put('cc_oo_OriginalPalletPrice__c', Decimal.valueOf(cartItem.palletPrice));
                }
                
                /*if(newCartItem.cc_oo_OriginalPalletPrice__c == null && cartItem.palletPrice != null) {
                  newCartItem.cc_oo_OriginalPalletPrice__c = Decimal.valueOf(cartItem.palletPrice);
                }*/
               // if(!priceListItem.isEmpty() && cartItem.seller != null && cartItem.seller != ''){
                   // if(cartItem.seller != null && cartItem.seller != ''){
                        //newCartItem.ccrz__Seller__c = cartItem.seller;
                  //  }
               // }/
               cartItemMap.put('seller', cartItem.seller);

                if(cartItem.quantity != null && cartItem.quantity != ''){
                    cartItemMap.put('quantity', Decimal.valueOf(cartItem.quantity));
                    //newCartItem.ccrz__Quantity__c = Decimal.valueOf(cartItem.quantity);
                }
                
                currentProd = mapProducts.get(cartItem.sku);
                cartItemMap.put('price', Decimal.valueOf(cartItem.price));
                cartItemMap.put('cc_oo_UnitPrice__c', Decimal.valueOf(currentProd.price.netListPrice));
                cartItemMap.put('isListPrice', Boolean.valueOf(cartItem.isListPrice));
                //newCartItem.ccrz__Price__c = Decimal.valueOf(cartItem.price);
                //newCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(currentProd.price.netListPrice);            
                //newCartItem.cc_oo_IsListPrice__c = Boolean.valueOf(cartItem.isListPrice);
                
                cartItemMap.put('cc_oo_OriginalBagPrice__c', Decimal.valueOf(currentProd.price.netListPrice));
                /*if(newCartItem.cc_oo_OriginalBagPrice__c == null) {
                  newCartItem.cc_oo_OriginalBagPrice__c = Decimal.valueOf(currentProd.price.netListPrice);
                }*/
                
                cartItemMap.put('unitOfMeasure', cartItem.unitOfMeasure);
                cartItemMap.put('productType', cartItem.productType);
                cartItemMap.put('ccrz__RequestDate__c', Date.today());
                //newCartItem.ccrz__UnitOfMeasure__c = cartItem.unitOfMeasure;
                //newCartItem.ccrz__ProductType__c = cartItem.productType;
                //newCartItem.ccrz__RequestDate__c = Date.today();
                if(cartItem.isfreightincluded != null) {
                    cartItemMap.put('isfreightincluded', cartItem.isfreightincluded);
                    //newCartItem.cc_oo_isFreightIncluded__c=cartItem.isfreightincluded;
                } else {
                    cartItemMap.put('isfreightincluded', false);
                    //newCartItem.cc_oo_isFreightIncluded__c=false;
                }
                
                cartItemMap.put('leadTime', cartitem.leadTime);
                //newCartItem.cc_oo_leadtime__c=cartitem.leadTime;
                if(mapProducts.get(cartItem.sku) != null){
                    currentProd = mapProducts.get(cartItem.sku);
                    Integer currentProdPalletSize;
                    //US - 3010
                    //if(currentProd.typeOfProduct.toLowerCase() == 'BAG'.toLowerCase() && currentProd.palletSize != null && currentProd.palletSize != '' && currentProd.palletSize != String.valueOf(0)){
                       // if(currentProd.palletSize != null && currentProd.palletSize != ''){
                            //currentProdPalletSize = Integer.valueOf(currentProd.palletSize);
                            //Boolean currentProdFullPalletReq = Boolean.valueOf(currentProd.fullPalletReq);
                            //if(cartItem.contractId == null || cartItem.contractId == null){
                                /*if(cartItemQuantity >= currentProdpalletSize && !currentProdFullPalletReq){
                                    if(Math.mod(cartItemQuantity,currentProdPalletSize) > 0){
                                        splitCartItem = new ccrz__E_CartItem__c();
                                        splitCartItem = newCartItem.clone();
                                        splitCartItem.ccrz__Quantity__c = Math.Mod(cartItemQuantity, currentProdPalletSize);
                                        splitCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(currentProd.price.netListPrice);
                                        splitCartItem.ccrz__Price__c = Decimal.valueOf(currentProd.price.netListPrice);
                                        //2752
                                        if(splitCartItem.cc_oo_OriginalBagPrice__c == null) {
                                          splitCartItem.cc_oo_OriginalBagPrice__c = Decimal.valueOf(cartItem.bagPrice);
                                        }
                                        if(splitCartItem.cc_oo_OriginalPalletPrice__c == null && cartItem.palletPrice != null) {
                              splitCartItem.cc_oo_OriginalPalletPrice__c = Decimal.valueOf(cartItem.palletPrice);
                                        }
                                    }
                                    newCartItem.ccrz__Quantity__c = currentProdPalletSize * (Math.floor(cartItemQuantity/currentProdPalletSize));
                                    newCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(currentProd.price.palletPrice);
                                    newCartItem.ccrz__Price__c = Decimal.valueOf(currentProd.price.palletPrice);
                                    //2752
                                    if(newCartItem.cc_oo_OriginalBagPrice__c == null) {
                                      newCartItem.cc_oo_OriginalBagPrice__c = Decimal.valueOf(cartItem.bagPrice);
                                    }
                                    if(newCartItem.cc_oo_OriginalPalletPrice__c == null && cartItem.palletPrice != null) {
                            newCartItem.cc_oo_OriginalPalletPrice__c = Decimal.valueOf(cartItem.palletPrice);
                                    }
                                }*/
                                //else if(currentProdFullPalletReq){
                                  /*newCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(currentProd.price.palletPrice);
                                    newCartItem.ccrz__Price__c = Decimal.valueOf(currentProd.price.palletPrice); 
                                    
                                    //2752
                                    if(newCartItem.cc_oo_OriginalBagPrice__c == null) {
                                      newCartItem.cc_oo_OriginalBagPrice__c = Decimal.valueOf(cartItem.bagPrice);
                                    }
                                    if(newCartItem.cc_oo_OriginalPalletPrice__c == null && cartItem.palletPrice != null) {
                            newCartItem.cc_oo_OriginalPalletPrice__c = Decimal.valueOf(cartItem.palletPrice);
                                    }*/
                               // }
                           // }
                       // }
                    //}
                    //US - 3010-end

                    if(cartItem.contractId != '' && cartItem.contractId != null){
                        cartItemMap.put('contractId', cartitem.contractId);
                        //newCartItem.cc_oo_ContractPrice__c = cartItem.contractId;
                        for(cc_oo_ContractPrice contract: currentProd.contracts){
                            if(contract.contractSFId == cartItem.contractId){
                
                //US - 1891
                                /*if(Integer.valueOf(cartItem.quantity) > contract.contractDetails.availableBalance){
                                    splitCartItem = new ccrz__E_CartItem__c();
                                    splitCartItem = newCartItem.clone();
                                    
                                    splitCartItem.ccrz__Quantity__c = cartItemQuantity - Integer.valueOf(contract.contractDetails.availableBalance);
                                    splitCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(currentProd.price.netListPrice);
                                    splitCartItem.ccrz__Price__c = Decimal.valueOf(currentProd.price.netListPrice);
                                    splitCartItem.cc_oo_IsListPrice__c = false;
                                    splitCartItem.cc_oo_ContractPrice__c = null;
                                    newCartItem.ccrz__Quantity__c = Integer.valueOf(contract.contractDetails.availableBalance);
                                    newCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(contract.contractPrice);
                                    newCartItem.ccrz__Price__c = Decimal.valueOf(contract.contractPrice);
                                }else{*/
                                    cartItemMap.put('quantity', Integer.valueOf(cartItem.quantity));
                                    cartItemMap.put('cc_oo_UnitPrice__c', Decimal.valueOf(contract.contractPrice));
                                    cartItemMap.put('price', Decimal.valueOf(contract.contractPrice));
                                    //newCartItem.ccrz__Quantity__c = Integer.valueOf(cartItem.quantity);
                                    //newCartItem.cc_oo_UnitPrice__c = Decimal.valueOf(contract.contractPrice);
                                    //newCartItem.ccrz__Price__c = Decimal.valueOf(contract.contractPrice);
                                    
                                    cartItemMap.put('cc_oo_OriginalBagPrice__c', Decimal.valueOf(contract.contractPrice));
                                    /*if(newCartItem.cc_oo_OriginalBagPrice__c == null) {
                                      newCartItem.cc_oo_OriginalBagPrice__c = Decimal.valueOf(contract.contractPrice);
                                    }*/
                                    
                                    if(cartItem.palletPrice != null) {
                                        cartItemMap.put('cc_oo_OriginalPalletPrice__c', Decimal.valueOf(cartItem.palletPrice));
                                    }
                                    
                                    /*if(newCartItem.cc_oo_OriginalPalletPrice__c == null && cartItem.palletPrice != null) {
                                        newCartItem.cc_oo_OriginalPalletPrice__c = Decimal.valueOf(cartItem.palletPrice);
                                    }*/
                                    cartItemMap.put('isListPrice', false);
                                    //newCartItem.cc_oo_IsListPrice__c = false;
                                //}
                                //US - 1891
                                
                            }
                        }
                    }       
                }
                //OO-2244
                if(cartItem.Id != null && cartItem.Id != '' && cartItem.Id != 'undefined'){
                    cartItemMap.put('Id', Id.valueOf(cartItem.Id));
                    //newCartItem.Id = Id.valueOf(cartItem.Id);    
                }//OO-2244

                //newCartItem.ccrz__SubAmount__c = newCartItem.ccrz__Quantity__c * newCartItem.cc_oo_UnitPrice__c;
               
                /*if(splitCartItem != null){
                    splitCartItem.ccrz__SubAmount__c = splitCartItem.ccrz__Quantity__c * splitCartItem.cc_oo_UnitPrice__c;
                    if((Date.Today() + leadTimeInteger) > cart.ccrz__RequestDate__c){
                        if(cart.cc_oo_SplitCart__c != null){
                            splitCartItem.ccrz__Cart__c = cart.cc_oo_SplitCart__c;
                        }
                        listSecondaryCartItems.add(splitCartItem);
                    }else{
                        splitCartItem.ccrz__Cart__c = cart.Id;
                        listPrimaryCartItems.add(splitCartItem);
                    }
                }*/
                System.debug('cart.ccrz__RequestDate__c--->'+ cart.ccrz__RequestDate__c);
                //OO-2778
                Date finalLeadDate = mapFinalLeadDate.get(cartItem.sku);
                //OO-2778
                if(finalLeadDate > cart.ccrz__RequestDate__c){
                    if(highestLeadTime < (Date.Today() + leadTimeInteger)){
                        highestLeadTime = (Date.Today() + leadTimeInteger);
                    }
                    
                    if(!secondaryCartList.isEmpty()) {
                        cartItemMap.put('ccrz__Cart__c', String.valueOf(secondaryCartList[0].Id));
                    }
                    
                    /*if(newCartItem.ccrz__Cart__c == null && cart.cc_oo_SplitCart__c != null){
                        newCartItem.ccrz__Cart__c = String.valueOf(cart.cc_oo_SplitCart__c);
                    }*/
                    //listSecondaryCartItems.add(newCartItem);
                    listSecondaryCartItems.add(cc_oo_HelperController.addQuickOrderItem(cartItemMap));
                }else{
                    cartItemMap.put('ccrz__Cart__c', String.valueOf(cart.Id));
                    /*if(newCartItem.ccrz__Cart__c == null) {
                        newCartItem.ccrz__Cart__c = String.valueOf(cart.Id);
                    }*/
                    //listPrimaryCartItems.add(newCartItem);
                    listPrimaryCartItems.add(cc_oo_HelperController.addQuickOrderItem(cartItemMap));
                }   
                
                 
            }

            List<ccrz__E_CartItem__c> listPrimAndSecCartItems = new List<ccrz__E_CartItem__c>();
            if(cart.cc_oo_SplitCartType__c == 'Primary' && listPrimaryCartItems.size() > 0){
               // if(listPrimaryCartItems.size() > 0){
                    listPrimAndSecCartItems.addAll(listPrimaryCartItems);
                //}
            }

            if(listSecondaryCartItems.size() > 0){
                ccrz__E_Cart__c secondaryCart;
                if(secondaryCartList.isEmpty()){
                    secondaryCart = cc_oo_HeaderController.mapToCart(sid ,shipTo, true);
                    secondaryCart.cc_oo_SplitCart__c = cart.Id;
                    update secondaryCart;

                    ccrz__E_Cart__c primaryCart = cart;
                    primaryCart.cc_oo_SplitCart__c = secondaryCart.Id;
                    update primaryCart;
                    for(ccrz__E_CartItem__c secCartItem: listSecondaryCartItems){
                      if(secCartItem.ccrz__Cart__c==null){
                          secCartItem.ccrz__Cart__c = String.valueOf(secondaryCart.Id);
                      }
                    }                             
                    listPrimAndSecCartItems.addAll(listSecondaryCartItems);
                }else{
                    if(secondaryCartList[0].cc_oo_SplitCartType__c == 'Secondary'){
                        for(ccrz__E_CartItem__c secCartItem: listSecondaryCartItems){
                            if(secCartItem.ccrz__Cart__c == null){//OO-2244
                                secCartItem.ccrz__Cart__c = String.valueOf(secondaryCartList[0].Id);
                            }
                        }
                        listPrimAndSecCartItems.addAll(listSecondaryCartItems);
                    }
                }
                
                if(mapFinalLeadDate != null && mapFinalLeadDate.size() > 0) {
                    Date finalDate = mapFinalLeadDate.values().get(0);
                    for(Date finalSecondaryDate : mapFinalLeadDate.values()) {
                        if(finalDate < finalSecondaryDate) {
                            finalDate = finalSecondaryDate;
                        }
                    }
                    if(secondaryCart != null){
                        secondaryCart.ccrz__RequestDate__c = finalDate;
                        update secondaryCart;
                    }
                }
            }

            if(listPrimAndSecCartItems.size() > 0){
                //insert listPrimAndSecCartItems;
                //OO-2244
                upsert listPrimAndSecCartItems;
                //OO-2244 - Ends
            }
            
            if(cart.cc_oo_SplitCart__c != null) {
                ccrz__E_Cart__c fetchSecondaryCart = [Select Id, ccrz__RequestDate__c,cc_oo_Seller__r.ccrz__SellerId__c,ccrz__ShipMethod__c,
                        (SELECT Id, ccrz__Product__c, ccrz__Product__r.Id, ccrz__Product__r.cc_oo_TypeOfProduct__c FROM ccrz__E_CartItems__r) 
                        FROM ccrz__E_Cart__c Where Id =:cart.cc_oo_SplitCart__c];
                Set<Id> primaryProductId = new Set<Id>();
                if(fetchSecondaryCart != null) {
                    for(ccrz__E_CartItem__c secondaryItem : fetchSecondaryCart.ccrz__E_CartItems__r) {
                        primaryProductId.add(secondaryItem.ccrz__Product__r.Id);
                    }
                
                    List<ccrz__E_ProductInventoryItem__c> secondaryCartInventoryItems = [select cc_oo_LeadTime__c 
                                                                            from ccrz__E_ProductInventoryItem__c
                                                                            where ccrz__ProductItem__c IN :primaryProductId 
                                                                            and cc_oo_Seller__c=:fetchSecondaryCart.cc_oo_Seller__c];
                    String shippingMethodSecondary = fetchSecondaryCart.ccrz__ShipMethod__c;
                    if(String.isNotBlank(shippingMethodSecondary)){
                        String[] splitShippingMethod=shippingMethodSecondary.split(' - ');
                        if(splitShippingMethod.size() > 1) {
                            shippingMethodSecondary=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                        } else {
                            shippingMethodSecondary=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                        }
                    }
                    else{
                        shippingMethodSecondary=null;    
                    }
                    Boolean secondaryAddLeadDay = cc_oo_HelperController.getCurrentAndCutOffTime(fetchSecondaryCart.ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c, fetchSecondaryCart.cc_oo_Seller__c,shippingMethodSecondary);
                    Date leadDate;
                    if(secondaryAddLeadDay) {
                        leadDate = Date.today().addDays(1);
                    } else {
                        leadDate = Date.today();
                    } 
                    
                    if(!secondaryCartInventoryItems.isEmpty() && secondaryCartInventoryItems.size() > 0) {  
                        String[] splitLead = (secondaryCartInventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                        Integer leadTime = Integer.valueOf(splitLead[0]);
                        leadDate = leadDate.addDays(leadTime);                                                
                        for(ccrz__E_ProductInventoryItem__c productInventory : secondaryCartInventoryItems) {
                            String[] splitLeadAll = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                            Integer leadTimeAll = Integer.valueOf(splitLeadAll[0]);
                            Date leadDateAll;
                            if(primaryAddLeadDay) {
                                leadDateAll = Date.today().addDays(1);
                            } else {
                                leadDateAll = Date.today();
                            }
                            leadDateAll = leadDateAll.addDays(leadTimeAll);
                            if(leadDate < leadDateAll) {
                                leadDate = leadDateAll;
                            }   
                        }
                                //US - 2408- Start
                        Date finalLeadDate = cc_oo_HelperController.getHolidayLeadDate(fetchSecondaryCart.cc_oo_Seller__c, leadDate);
                              
                        if(fetchSecondaryCart.ccrz__RequestDate__c > finalLeadDate || fetchSecondaryCart.ccrz__RequestDate__c < finalLeadDate
                            || fetchSecondaryCart.ccrz__RequestDate__c == null) {
                            fetchSecondaryCart.ccrz__RequestDate__c = finalLeadDate;
                            update fetchSecondaryCart;
                        }
                    }
                }
            }
            
            sp = null;
            return true;
        }catch(exception ex){
            System.debug('ex-->' + ex.getMessage());
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'convertToCartList');
            Database.rollback(sp);
            return false;
        }
        return true;
    }

    /* 
        Method: getPriceListItems
        To get the pricing related details for list of Product Ids
    **/
    public static map<string, cc_oo_ProductPrice> getPriceListItems(map<string, id> products, String sellerId, string shipToSFId){
        Date expireLimit = Date.today();
        List<cc_oo_PriceList__c> priceItems = [SELECT cc_oo_NetListPrice__c,cc_oo_isfreightincluded__c,
                                           //cc_oo_PalletPrice__c, // US - 3010
                                           cc_oo_Product__r.ccrz__Quantityperunit__c,
                                                                            cc_oo_Product__r.ccrz__UnitOfMeasure__c,cc_oo_Product__r.cc_oo_UoMDesc__c,
                                                                            cc_oo_Product__r.ccrz__SKU__c,
                                                                            cc_oo_Product__r.cc_oo_TypeOfProduct__c,
                                                                            cc_oo_Seller__r.ccrz__SellerId__c,id,
                                                                            cc_oo_ShipTo__r.AccountNumber
                                                                            FROM cc_oo_PriceList__c 
                                                                            WHERE cc_oo_Seller__c=:sellerId 
                                                                            AND cc_oo_ShipTo__c =: shipToSFId
                                                                            AND cc_oo_Product__c IN:products.values()
                                                                            AND cc_oo_EffectiveDate__c <=:expireLimit];
                                                                            /*AND cc_oo_ExpirationDate__c >=:expireLimit
                                                                            ORDER BY cc_oo_ExpirationDate__c ASC]; */ 

        map<string, cc_oo_ProductPrice> mapPriceListItems = new map<string, cc_oo_ProductPrice>();
        cc_oo_ProductPrice prodPrice = new cc_oo_ProductPrice();
        for(cc_oo_PriceList__c priceItem : priceItems){
            prodPrice = assignPriceDetails(priceItem);
            mapPriceListItems.put(priceItem.cc_oo_Product__r.ccrz__SKU__c, prodPrice);
        }                                                                            
        return mapPriceListItems;
    }

    /* 
        Method: getRelatedProducts
        To get the related Products
    **/
    public static map<string, List<String>> getRelatedProducts(map<string,string> products, String sellerId, string shipTo, string cartId){
        Date expireLimit = Date.today();
        List<ccrz__E_RelatedProduct__c> listRelatedProduct = [SELECT ccrz__Product__c, ccrz__Product__r.ccrz__sku__c, ccrz__RelatedProduct__r.ccrz__SKU__c FROM ccrz__E_RelatedProduct__c WHERE ccrz__Product__r.ccrz__SKU__c IN: products.values()];
        List<String> relatedSkus = new List<String>();
        map<string,List<String>> mapRelatedProducts = new map<string,List<String>>();
        for(ccrz__E_RelatedProduct__c related :listRelatedProduct){
            relatedSkus.add(related.ccrz__RelatedProduct__r.ccrz__SKU__c);
        }
        List<string> skuPriceList = getProducts(relatedSkus,sellerId,cartId);
        Set<String> skuSet= new Set<String>(skuPriceList);
        for(ccrz__E_RelatedProduct__c related :listRelatedProduct){
            if(skuSet.contains(related.ccrz__RelatedProduct__r.ccrz__SKU__c)){
            if(!mapRelatedProducts.isEmpty()){
            List<String> values=mapRelatedProducts.get(related.ccrz__Product__r.ccrz__sku__c);
                if(values!=null && !values.isEmpty()  ){
                    mapRelatedProducts.get(related.ccrz__Product__r.ccrz__SKU__c).add(related.ccrz__RelatedProduct__r.ccrz__sku__c);    
                }
               else{
                   List<String> relatedprodSkus= new List<String>();
                    relatedprodSkus.add(related.ccrz__RelatedProduct__r.ccrz__sku__c);
                    mapRelatedProducts.put(related.ccrz__Product__r.ccrz__SKU__c,relatedprodSkus);

               }
           }
                else{
                    List<String> relatedprodSkus= new List<String>();
                    relatedprodSkus.add(related.ccrz__RelatedProduct__r.ccrz__sku__c);
                    mapRelatedProducts.put(related.ccrz__Product__r.ccrz__SKU__c,relatedprodSkus);
                }
            }
        }                                                                           
        return mapRelatedProducts;
    }
    
    /* 
        Method: getProducts
        To get the products present in seller/customer pricelist
    **/
    public static List<String> getProducts(List<String> skuIds, string sellerId, string cartId){
      
         List<ccrz__E_Cart__c> sellerShipCode=new List<ccrz__E_Cart__c>();
         String orderType = null;
         String sellerCode;
         Decimal accountId;
        sellerShipCode= [select cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId LIMIT 1];
        if(!sellerShipCode.isEmpty()){
           sellerCode=sellerShipCode[0].cc_oo_Seller__r.ccrz__SellerId__c;
           accountId=Decimal.valueOf(sellerShipCode[0].cc_oo_ShipToAccount__r.AccountNumber);
        }
        Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
        Id contactId = ccrz.cc_CallContext.currContact.Id;
        String shipToPricelistName;
        shipToPricelistName=String.valueOf(accountId) + '-'+sellerCode;
        System.debug(shipToPricelistName);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',shipToPricelistName);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',accountId);
        //System.debug(accountId);
        
        List<ccrz__E_PriceListItem__c> PriceListItemList = new List<ccrz__E_PriceListItem__c>();
        //List<ccrz__E_PriceListItem__c> ItemList = new List<ccrz__E_PriceListItem__c>();
        Date expireLimit = Date.today();
         PriceListItemList=[SELECT ccrz__Product__r.ccrz__SKU__c,cc_oo_IsPreBook__c FROM ccrz__E_PriceListItem__c WHERE 
            ccrz__Product__r.ccrz__SKU__c IN :skuIds AND 
            ccrz__Pricelist__c IN 
            (SELECT ccrz__Pricelist__c FROM ccrz__E_AccountGroupPriceList__c WHERE ccrz__Pricelist__r.ccrz__Seller__c=:sellerId and ccrz__Pricelist__r.ccrz__Enabled__c=true AND ccrz__AccountGroup__c=:accGroup  AND (ccrz__Pricelist__r.ccrz__PricelistId__c=:sellerCode OR ccrz__Pricelist__r.ccrz__PricelistId__c=:shipToPricelistName )AND (ccrz__Pricelist__r.cc_oo_ShipToNumber__c=NULL OR ccrz__Pricelist__r.cc_oo_ShipToNumber__c=:accountId )) AND cc_oo_IsPreBook__c=false  AND ccrz__EndDate__c>=:expireLimit];
            if(PriceListItemList.isEmpty()){
            PriceListItemList= new List<ccrz__E_PriceListItem__c>();
            }
            
             List<String> productSkuIdList = new List<String>();
             if(!PriceListItemList.isEmpty()){
               Set<String> newSkuList= new Set<String>();
              for(ccrz__E_PriceListItem__c priceListItem: PriceListItemList) {
                newSkuList.add(priceListItem.ccrz__Product__r.ccrz__SKU__c);
             }
               productSkuIdList.addAll(newSkuList);
        }
        return productSkuIdList;
    }

    /* 
        Method: getContracts
        To get the contract details for list of Product Ids
    **/
    public static map<string, List<cc_oo_ContractPrice>> getContracts(map<string,id> products, String sellerId, string shipToSFId, string shipDString){
        //OO-1180
        Date shipDate = Date.parse(shipDString);
        Date expireLimit = shipDate;
        //US - 2429
        /*Id contactId = ccrz.cc_CallContext.currContact.Id;
        String dealerAccount = '';
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
        //OO-1180
        //US - 2377
        List<cc_oo_ContractPrice__c> contractItems = [SELECT Name, cc_oo_ExpireDate__c, cc_oo_ContractPrice__c,cc_oo_QuantityUpdateDate__c,
                                                cc_oo_isfreightincluded__c, //US - 1773
                                                                                        cc_oo_ContractUoM__c, cc_oo_ConversionValue__c,
                                                                                        cc_oo_ContractQty__c, cc_oo_AvailabilityQty__c,cc_oo_AvailabilityQtyUoMContract__c,
                                                                                        cc_oo_EffectiveDate__c, cc_oo_Product__r.ccrz__SKU__c,
                                                                                        cc_oo_Product__r.cc_oo_UoMDesc__c,
                                                                                        cc_oo_Product__r.cc_oo_TypeOfProduct__c,
                                                                                        cc_oo_EndUserName__c,cc_oo_ContractUoMDesc__c,
                                                                                        cc_oo_ContractNumber__c
                                                                                        FROM cc_oo_ContractPrice__c
                                                                                        WHERE cc_oo_Product__c IN:products.values() 
                                                                                        AND cc_oo_Seller__c=: sellerId
                                                                                        AND cc_oo_ShipToNumber__c=:shipToSFId
                                                                                        AND cc_oo_AvailabilityQty__c>0
                                                                                        AND cc_oo_ContractQty__c>0
                                                                                        AND cc_oo_EffectiveDate__c <=:expireLimit
                                                                                        AND cc_oo_ExpireDate__c >=:expireLimit
                                                                                        ORDER BY cc_oo_ExpireDate__c ASC];  

        map<string, List<cc_oo_ContractPrice>> mapContract = new map<string, List<cc_oo_ContractPrice>>();
        cc_oo_ContractPrice contract = new cc_oo_ContractPrice();
        for(cc_oo_ContractPrice__c contractItem : contractItems){
            contract = assignContractDetails(contractItem);

            if(mapContract.get(contractItem.cc_oo_Product__r.ccrz__SKU__c) != null){
                mapContract.get(contractItem.cc_oo_Product__r.ccrz__SKU__c).add(contract);
            }else{
                List<cc_oo_ContractPrice> listContracts = new List<cc_oo_ContractPrice>();
                listContracts.add(contract);
                mapContract.put(contractItem.cc_oo_Product__r.ccrz__SKU__c, listContracts);
            }
        }                                                                            
        return mapContract;
    }

    /*
        Contract detail assignment to the contract bean objects
    **/
    public static cc_oo_ContractPrice assignContractDetails(cc_oo_ContractPrice__c contract){
        
        cc_oo_ContractPrice contractItem = new cc_oo_ContractPrice();
        contractItem.contractSFId = contract.Id;
        contractItem.contractId = String.valueOf(contract.cc_oo_ContractNumber__c);
        //defect#OO-3226
        if(contract.cc_oo_ExpireDate__c!=null){
          Date Myexpiry_Date = Date.valueOf(String.valueOf(contract.cc_oo_ExpireDate__c));
          contractItem.expiryDate = String.valueOf(Myexpiry_Date.format());
        }
        contractItem.jdeEndUser = string.valueOf(contract.cc_oo_EndUserName__c);
        String typeofproduct=contract.cc_oo_Product__r.cc_oo_TypeOfProduct__c;
        if(typeofproduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK'))|| typeofproduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
          contractItem.unitOfMeasureDesc=ccrz.cc_CallContext.pageLabels.get('TON');
        }else{
        contractItem.unitOfMeasureDesc = string.valueOf(contract.cc_oo_Product__r.cc_oo_UoMDesc__c);
        }
        contractItem.contractPrice = string.valueOf(contract.cc_oo_ContractPrice__c);
        contractItem.contractQty = Integer.ValueOf(contract.cc_oo_ContractQty__c);
        //contractItem.disableContract = 

        cc_oo_ContractDetail contractItemDetail = new cc_oo_ContractDetail();
        contractItemDetail.AvailabilityQtyUoMContract =string.valueOf(contract.cc_oo_AvailabilityQtyUoMContract__c);//2377 
        //defect#OO-3226
        if(contract.cc_oo_EffectiveDate__c!=null){     
          Date effective_Date=Date.valueOf(String.valueOf(contract.cc_oo_EffectiveDate__c));
          contractItemDetail.effectiveDate = String.valueOf(effective_Date.format());
        }
        contractItemDetail.availableBalance = Integer.valueOf(contract.cc_oo_AvailabilityQty__c);
        
        if(String.isNotBlank(contractItemDetail.AvailabilityQtyUoMContract) && !contractItemDetail.AvailabilityQtyUoMContract.equals('0')) {
          contractItemDetail.contractUom = String.valueOf(contract.cc_oo_ContractUoMDesc__c);
        }
        
        contractItemDetail.isfreightincluded = contract.cc_oo_isfreightincluded__c;
        //defect#OO-3226
        if(contract.cc_oo_QuantityUpdateDate__c!=null){
            DateTime myFinalDate = DateTime.valueOf(String.valueOf(contract.cc_oo_QuantityUpdateDate__c));
          contractItemDetail.lastModifiedDate = String.valueOf(myFinalDate.format('MM/dd/YYYY HH:mm'));
        }
        if(contractItemDetail.availableBalance != null && contractItemDetail.availableBalance != 0){
          contractItemDetail.UoMDesc= string.valueOf(contract.cc_oo_Product__r.cc_oo_UoMDesc__c);//2377
        }        
        contractItem.contractDetails = contractItemDetail;
        return contractItem;
    }

    /*
        Price detail assignment to the price bean object
    **/
    public static cc_oo_ProductPrice assignPriceDetails(cc_oo_PriceList__c price){
        
        cc_oo_ProductPrice productPrice = new cc_oo_ProductPrice();
        productPrice.netListPrice = string.valueOf(price.cc_oo_NetListPrice__c);
        productPrice.sfId=price.Id;
        //productPrice.palletPrice = string.valueOf(price.cc_oo_PalletPrice__c); // US - 3010
        productPrice.quantityPerUnit = string.valueOf(price.cc_oo_Product__r.ccrz__Quantityperunit__c);
        productPrice.unitOfMeasure = string.valueOf(price.cc_oo_Product__r.ccrz__UnitOfMeasure__c);
        String typeofproduct=price.cc_oo_Product__r.cc_oo_TypeOfProduct__c;
        if(typeofproduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK'))|| typeofproduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
          productPrice.unitOfMeasureDesc=ccrz.cc_CallContext.pageLabels.get('TON');
        }else{
          productPrice.unitOfMeasureDesc = string.valueOf(price.cc_oo_Product__r.cc_oo_UoMDesc__c);
        }
        productPrice.isfreightincluded = price.cc_oo_isfreightincluded__c;

        return productPrice;
    }

    /*
        Bean - cc_oo_Product
        To hold the product data
    **/
    public class cc_oo_Product{
        public string productId{get; set;}
        public string index{get; set;}
        public string sku{get; set;}
        public string quantity{get; set;}
        public string typeOfProduct{get; set;}
        public string UOM{get; set;}
        public string pUOM{get; set;}
        public string minQuantity{get; set;}
        public string palletSize{get; set;}
        public string status{get; set;}
        public string availabilityMessage{get; set;}
        public string fullPalletReq{get; set;}
        public string isToteProduct{get; set;}
        public string leadTime{get; set;}
        public string shortDescription{get; set;}
        public string priceOption{get; set;}
        public string listPrice{get; set;}
        public string errorMessage{get; set;}
        public string quantityErrorMessage{get;set;}
        public string UOMD{get;set;}
        public cc_oo_ProductPrice price{get; set;}
        public List<cc_oo_ContractPrice> contracts{get; set;}
    }

    /*
        Bean - cc_oo_ProductPrice
        To hold the product price details data
    **/
    public class cc_oo_ProductPrice{
      public Id sfId{get; set;}
        public string netListPrice{get; set;}
        public string palletPrice{get; set;}
        public string quantityPerUnit{get; set;}
        public string unitOfMeasure{get; set;}
        public string unitOfMeasureDesc{get; set;}
        public Boolean isfreightincluded{get; set;}
        //public string palletSize{get; set;}
    }

    /*
        Bean - cc_oo_ContractPrice
        To hold the cotract price details
    **/
    public class cc_oo_ContractPrice {
        public String contractSFId{get; set;}
        public String contractId{get; set;}
        public String contractPrice{get; set;}
        public string expiryDate{get; set;}
        public String jdeEndUser{get; set;}
        public String unitOfMeasureDesc{get; set;}
        public Integer contractQty{get; set;}
        public Boolean disableContract{get; set;}
        public cc_oo_ContractDetail contractDetails{get; set;}
    }
    
    /*
        Bean - cc_oo_ContractPrice
        To hold the cotract price details
    **/
    public class cc_oo_ContractDetail {
        public string effectiveDate{get; set;}
        public String contractUom{get; set;}
        public Integer availableBalance{get; set;}
        public string lastModifiedDate{get; set;} 
        public String AvailabilityQtyUoMContract{get;set;} //2377
        public string UoMDesc{get; set;}  //2377   
        public Boolean isfreightincluded{get; set;} // US - 1773          
    }

    /*
        Bean - cc_oo_cart
        To hold the cart details
    **/
    public class cc_oo_cart{
        public string Id {get;set;}//OO-2244
        public string sku {get; set;}
        public string cartId {get; set;}
        public string category {get; set;}
        public string storeID {get; set;}
        public string product {get; set;}
        public string seller {get; set;}
        public string quantity {get; set;}
        public string price {get; set;}
        public string unitPrice {get; set;}
        public string isListPrice {get; set;}
        //2752
        public string bagPrice {get; set;}
        public string palletPrice {get; set;}
        //public string ccrz__SubAmount__c {get; set;}
        public string unitOfMeasure {get; set;}
        public string productType {get; set;}
        public string requestDate {get; set;}
        public string contractId {get; set;}
        public string leadTime {get; set;}
        public boolean isfreightincluded {get;set;}
    }
}