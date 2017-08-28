//ClassName:cc_oo_FeaturedProductsController
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shivani Singh                              03/09/2016                                      OO-2943 - Display entitled spotlight products on Homepage                                                                                                  part of the 'Product No' and 'Product Name'.
//-----------------------------------------------------------------------------------------------------------------------
global without sharing class cc_oo_FeaturedProductsController {
    
    /***************************************************************************************************************************************
      Method Name : getSpotlightProducts
      Description : getSpotlightProducts is to retrieve the spotlight entitled products
      Parameter   : sellerId, shipToId 
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-2943                                                          
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getSpotlightProducts(final ccrz.cc_RemoteActionContext ctx){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        List<ccrz__E_FeaturedProduct__c> featuredProducts=[Select ccrz__Product__r.ccrz__SKU__c from ccrz__E_FeaturedProduct__c WHERE ccrz__Type__c = 'Spotlight' AND ccrz__Enabled__c=true];
        List<String> skuIds= new List<String>();
        for(ccrz__E_FeaturedProduct__c prods:featuredProducts){
            skuIds.add(prods.ccrz__Product__r.ccrz__SKU__c);
        }
        List<String> filteredSpotlightProducts = cc_oo_HelperController.getProducts(skuIds);        
        List<ccrz__E_Product__c> spotlightProduct = [SELECT Name,ccrz__SKU__c,ccrz__ShortDesc__c,CC_OO_BrandCode__r.cc_oo_LogoURL__c,(select ccrz__URI__c from ccrz__E_ProductMedias__r where ccrz__Product__r.ccrz__SKU__c IN:filteredSpotlightProducts and ccrz__MediaType__c='Product Image' ) FROM ccrz__E_Product__c WHERE ccrz__SKU__c IN:filteredSpotlightProducts];
        List<cc_oo_SpotlightProducts> spotlightList=new List<cc_oo_SpotlightProducts>();
        if(spotlightProduct!=null) {
            for(ccrz__E_Product__c prod :spotlightProduct){
                cc_oo_SpotlightProducts spotlight = new cc_oo_SpotlightProducts();
                spotlight.name=prod.Name;
                spotlight.sku=prod.ccrz__SKU__c;
                spotlight.shortDesc=prod.ccrz__ShortDesc__c;
                if(prod.ccrz__E_ProductMedias__r.size()>0){
                    spotlight.url=prod.ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                }               
                if(prod.CC_OO_BrandCode__r!=null){
                    spotlight.brandLogo=prod.CC_OO_BrandCode__r.cc_oo_LogoURL__c;
                }
                spotlightList.add(spotlight);
            }
            res.success = true;
            res.data = spotlightList;
       }  
        return res;
    }
    
    //US-2943
      public class cc_oo_SpotlightProducts{
        public String name{get; set;}
        public String sku{get; set;}
        public String shortDesc{get; set;}
        public String url{get; set;}
        public String brandLogo{get;set;}
    }
    
}