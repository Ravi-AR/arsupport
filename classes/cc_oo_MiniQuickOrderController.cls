//<ClassName:cc_oo_MiniQuickOrderController
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                          10/25/2016                                     US-339 The system will not allow the user to add two types of products in the cart.
//Samruddhi Gokhale                         11/03/2016                                     US-49 Allow for product minimum quantities and pallet increments.
global without sharing class cc_oo_MiniQuickOrderController {
    
    // User story : OO-1357 Excel Mass Upload Quick Order (Declaring variables)
    /*public String csv{get; set;}
    public blob csvBlob{get; set;}
    public String fileName{get; set;} */
    // End of declaring variables for user story OO-1357

    // US - 339 - System will not allow bag vs bulk vs liquid products to reside in the same cart
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult addToCartOO(final ccrz.cc_RemoteActionContext ctx, Map<string, string> productDetailMap, Map<string, string> skuQuantityMap){
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;
         Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            String sellerId =   null;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
        Map<String,Object> response = cc_oo_HelperController.addToCartMini(productDetailMap, skuQuantityMap, sellerId);
        
        res.data = response;
        
        return res;
    }
    
    // User story OO-1357: Excel Mass Upload in Quick Order
   /* public PageReference parseCSV(){
        PageReference page = null;
        List<ccrz_assortment_bean_product> productsToAdd = new List<ccrz_assortment_bean_product>(); 
        List<String> skus = new List<String>();
        Map<String, ccrz_assortment_bean_product> skusToBeans = new Map<String, ccrz_assortment_bean_product>();
        ccrz_assortment_bean_product parentProduct = null;
        if(csvBlob != null && csvBlob.size() > 0)
            csv = csvBlob.toString();
        else
            csv = ApexPages.currentPage().getParameters().get('hiddenCSVContent');
            
        System.debug('CSV-----' + csv);
        List<String> lines = csv.split('\n');
        boolean isFirst = true;

        for(String singleLine : lines){//loop though all the lines
            if(!isFirst){
                List<String> values = singleLine.split(',');
                ccrz_assortment_bean_product nextProduct = new ccrz_assortment_bean_product();
                boolean isSingleton = values[0].trim().indexOf('_') > 0;
                nextProduct.SKU = values[0].trim().replace('_', '');
                nextProduct.quantity = Decimal.valueOf(values[1].trim());
                nextProduct.listPrice = 0;
                nextProduct.customerPrice = 0;
                if(!isSingleton)
                    nextProduct.parentProduct = parentProduct;
                skus.add(nextProduct.SKU);
                productsToAdd.add(nextProduct);
                skusToBeans.put(nextProduct.SKU, nextProduct);
                //nextProduct.SKU = values[4];
                //nextProduct.SKU = values[5];          
            }
            else{//handles parent product for dynamic kits
                parentProduct = new ccrz_E_assortment_bean_product__c();
                parentProduct.SKU = '90050';//Define assortment sku in future, this would work with shirts, etc...
                parentProduct.quantity = 1;
                parentProduct.listPrice = 0;
                parentProduct.customerPrice = 0;
                skus.add(parentProduct.SKU);
                productsToAdd.add(parentProduct);
                skusToBeans.put(parentProduct.SKU, parentProduct);
                isFirst = false;
            }
        }
        
        List<ccrz__E_Product__c> products = [Select Id, ccrz__Sku__c from ccrz__E_Product__c where ccrz__Sku__c in: skus];//grab product IDs since all I have are skus
        for(ccrz__E_Product__c product : products){
            skusToBeans.get(product.ccrz__SKU__c).productId = product.Id;
        }
        
        ccrz__E_Cart__c myCart = cc_assortment_addToCart.createCart();
        cc_assortment_addToCart.addProductsToCart(myCart, productsToAdd);
        
        page = new PageReference('/ccrz__Cart?cartId=' + myCart.ccrz__EncryptedId__c + '&store=DefaultStore');
        
        return page;
    }*/
    // End of method for user story OO-1357

}