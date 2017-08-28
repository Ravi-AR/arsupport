//ClassName:cc_oo_CartIncRD2Controller
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shrivaths Kulkarni                         9/7/2016                                      OO-121 - Created and added getProductsDetails() method
//                                                                                         which will give the long description in Cart page - Additional Info
//                                                                                         Test class: cc_oo_CartIncRD2ControllerTest
//Saloni Kale								 9/28/2016										OO-371 - Created and added E2 description on the cart page
//																							Used the same method getProductsDetails()
//-----------------------------------------------------------------------------------------------------------------------
global with sharing class cc_oo_CartIncRD2Controller {
    
    /*
     *@Param: cartId which is used to store id of Cart
     *@Desc: method is to pull the product details like SKU, Long Description
    **/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetails(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
              Map<String, ccrz__E_CartItem__c> dataMap = new Map<String, ccrz__E_CartItem__c>();
              List<ccrz__E_CartItem__c> cartItems = [Select ci.Id, ci.ccrz__Product__c, ci.ccrz__Product__r.ccrz__SKU__c,
                                      ci.ccrz__Product__r.ccrz__LongDesc__c,ci.ccrz__Product__r.cc_oo_Second_Description__c From ccrz__E_CartItem__c ci WHERE ccrz__Cart__c =: cartId];
              for(ccrz__E_CartItem__c cartItem : cartItems){  
                 // dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem.ccrz__Product__r.ccrz__LongDesc__c);
                 dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem);
              }              
              res.success = true;
              res.data = dataMap;
              return res;
        }catch (Exception error)
        {
              System.debug(error);
        }
        return null;
    }
}