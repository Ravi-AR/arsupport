//<ClassName:cc_oo_OrderItemsController>
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni kale                               9/28/2016                                      US: OO-371 Created and added E2 description in the order Review page
//Samruddhi Gokhale                         9/29/2016                                      US: OO-211 Sending email acknowledgement                                                        
//Rajesh W                                  10/3/2016                                     oo-212 Add back to community portal link
//Murtaza Beejwala							08-12-2016									  oo-1210 vfd checked products.
//Shivani Singh    							01-19-2017									  US-342 The payment terms shall be accessible as read-only for a customer during checkout.
global without sharing class cc_oo_OrderItemsController {
     public static final string CLASS_NAME = 'cc_oo_OrderItemsController';
     //Property to hold community portal link from custom settings
     /*public String commPortalLink {get; set;}
    
     public cc_oo_OrderViewPrebookController() {
        
        //setLinkCookie();
        // Access community portal link cookie key from custom settings
        String commPortalCookiekey  =   LOLSettings__c.getAll().get('CommunityUrlCookieKey').Value__c;
        if(String.isNotEmpty(commPortalCookiekey))
        {
            commPortalLink  =   commPortalCookiekey;
        }
        else
        {
            commPortalLink  =   '#';
        }
     }*/
     //public void setLinkCookie(){
     // String commUrlVal       ='http://www.google.com';
     // Cookie commUrlCookie    = new Cookie(LOLSettings__c.getAll().get('CommunityUrl').Value__c,commUrlVal, null,-1,false);
     // ApexPages.currentPage().setCookies(new Cookie[]{commUrlCookie});
     //}
    
    /*
     *@Param: cartId which is used to store id of Cart
     *@Desc: method is to pull the product details like SKU, Long Description, E2 description
    **/
     public String paymentTerms {get; set;}
     public cc_oo_OrderItemsController() {
       String accId  = ccrz.cc_CallContext.currAccountId;
        List<Account> accData = [select Payment_Term_Desc_JDE__c from Account where id=: accId Limit 1];
        for(Account acc:accData){
          if(acc.Payment_Term_Desc_JDE__c!=null){
            paymentTerms=acc.Payment_Term_Desc_JDE__c;
          }
        }
        
     }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetails(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
              Map<String, ccrz__E_CartItem__c> dataMap = new Map<String, ccrz__E_CartItem__c>();
              Set<Id> productIdList = new Set<Id>();
			  Set<Id> productIdContract = new Set<Id>();
              List<ccrz__E_CartItem__c> cartItems = [Select ci.Id, ci.ccrz__Product__c, ci.ccrz__Product__r.ccrz__SKU__c,
                                      ci.ccrz__Product__r.ccrz__LongDesc__c,ci.ccrz__Product__r.cc_oo_Second_Description__c From ccrz__E_CartItem__c ci WHERE ccrz__Cart__c =: cartId];
              for(ccrz__E_CartItem__c cartItem : cartItems){  
                 // dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem.ccrz__Product__r.ccrz__LongDesc__c);
                 dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem);
              }              
              res.success = true;
              res.data = dataMap;
              
        }catch (Exception ex)
        {
               cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductsDetails');
        }
        return res;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetailsCheckout(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
        	  Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
              Map<String, Object> dataMap = new Map<String, Object>();
              Set<Id> productIdList = new Set<Id>();
			  Set<Id> productIdContract = new Set<Id>();
			  String accountID=ccrz.cc_CallContext.currAccountId;
			  String sellerId =   null;
			  if(pageParams != null){
                sellerId = pageParams.get('sid');
              }
              List<ccrz__E_CartItem__c> cartItems = [Select ci.Id, ci.ccrz__Product__c, ci.ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Id,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,
                                      ci.ccrz__Product__r.ccrz__LongDesc__c,ci.ccrz__Product__r.cc_oo_Second_Description__c From ccrz__E_CartItem__c ci WHERE ccrz__Cart__c =: cartId];
              for(ccrz__E_CartItem__c cartItem : cartItems){  
                 // dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem.ccrz__Product__r.ccrz__LongDesc__c);
                 	if(cartItem.cc_oo_IsListPrice__c) {
						productIdList.add(cartItem.ccrz__Product__r.Id);
					} else {
						productIdContract.add(cartItem.ccrz__Product__r.Id);
					}
                 dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem);
              } 
              
              List<cc_oo_PriceList__c> listPalletPrice = new List<cc_oo_PriceList__c>();
              List<cc_oo_ContractPrice__c> listContractPrice = new List<cc_oo_ContractPrice__c>();
              if(productIdList != null && !productIdList.isEmpty()) {
				listPalletPrice=[select cc_oo_Product__r.ccrz__SKU__c,cc_oo_NetListPrice__c,cc_oo_PalletPrice__c,cc_oo_isfreightincluded__c 
						from cc_oo_PriceList__c where cc_oo_Product__r.Id IN:productIdList 
						and cc_oo_Seller__c=:sellerId and cc_oo_ShipTo__c=:accountID];
				}
                       
              if(productIdContract != null && !productIdContract.isEmpty()) {
				listContractPrice=[select cc_oo_Product__r.ccrz__SKU__c,cc_oo_isfreightincluded__c,Name 
						from cc_oo_ContractPrice__c where cc_oo_Product__r.Id IN:productIdContract 
						and cc_oo_Seller__c=:sellerId and cc_oo_ShipToNumber__c=:accountID];
				}
				
				for(ccrz__E_CartItem__c cartItem : cartItems){ 
					if(listPalletPrice.size() != 0 && !listPalletPrice.isEmpty()) {
						for(cc_oo_PriceList__c priceList : listPalletPrice) {
							if(cartItem.ccrz__Product__r.ccrz__SKU__c.equals(priceList.cc_oo_Product__r.ccrz__SKU__c) && cartItem.cc_oo_IsListPrice__c) {
								dataMap.put(cartItem.Id, priceList.cc_oo_isfreightincluded__c);
							}
						}
					}
					
					if(listContractPrice.size() != 0 && !listContractPrice.isEmpty()) {
						for(cc_oo_ContractPrice__c contractList : listContractPrice) {
							if(cartItem.ccrz__Product__r.ccrz__SKU__c.equals(contractList.cc_oo_Product__r.ccrz__SKU__c) 
									&& !cartItem.cc_oo_IsListPrice__c && cartItem.cc_oo_ContractPrice__r.Name == contractList.Name) {
								dataMap.put(cartItem.Id, contractList.cc_oo_isfreightincluded__c);
							}
						}
					}
					
				}
              
              res.success = true;
              res.data = dataMap;
              
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductsDetailsCheckout');
        }
        return res;
    }
     /*
     *@Param: 
            orderId: Used to store id of Cart
            emailId: email Id entered by user
     *@Desc: method is to send acknowledgement to user about order confirmation
    **/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult saveAlternateEmail(final ccrz.cc_RemoteActionContext ctx, string cartId, string emailId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
              List<ccrz__E_Cart__c> cartList = [select cc_oo_Alternate_Email_Id__c from ccrz__E_Cart__c where Id=:cartId];
              if(!cartList.isEmpty() && String.isNotBlank(emailId) && !emailId.equals('{}')) 
              {
                  cartList[0].cc_oo_Alternate_Email_Id__c = emailId;
                  update cartList[0];
              }     
              res.success = true;
              
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'saveAlternateEmail'); 
        }
        return res;
    }
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderDetails(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
            List<ccrz__E_Cart__c> cartDetails = [select cc_oo_AmendedCart__c,cc_oo_JDEPreviousOrderNumber__c from ccrz__E_Cart__c where Id=:cartId];
            for(ccrz__E_Cart__c cart:cartDetails)
              
              {
                  if(cart.cc_oo_AmendedCart__c)
                  {
                     string jdePreviousOrder = cart.cc_oo_JDEPreviousOrderNumber__c;
                  }
              }     
              
              res.success = true;
              
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderDetails'); 
        }
        return res;
    }
    
    /***************************************************************************************************************************************
      Method Name : getVfdFlag
      Description : getVfdFlag is to get the vfd-flag of products
      Parameter   : sfid 
                    sfid is the list of product ids.
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-59 - write a program to get the vfd regulated feed items.                                                              

                    
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
    
    /***************************************************************************************************************************************
      Method Name : getOrderReViewDetails
      Description : getOrderReViewDetails is to get the details on order review page
      Parameter   : cartId 
                    cartId is the list of cart ids.
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2690 - Order Review and order confirmation page updates                                                              
					OO-4712 Differentiate Contract Price on Order review and order confirmation page
                    
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderReViewDetails(final ccrz.cc_RemoteActionContext ctx, String cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        System.debug('*********************************************hello im in getOrderReviewDetails method********************************************');
        Map<String,object> dataMap = new Map<String,object>();
    
        try{
            List<ccrz__E_CartItem__c> cartItems = [select ccrz__Cart__r.ccrz__PONumber__c,ccrz__Cart__r.cc_oo_PickUpTime__c,ccrz__Cart__r.cc_oo_TimeZone__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Product__r.cc_oo_UoMDesc__c,cc_oo_TotalWieght__c,ccrz__Product__r.ccrz__LeadTime__c,cc_oo_IsListPrice__c from ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
         
            /*System.debug('cartitems--->'+cartItems);
            for(ccrz__E_CartItem__c cartItem : cartItems){
                dataMap.put('OrderViewData',cartItem);
            }*/
            if(cartItems.size() > 0){
            
                    for(ccrz__E_CartItem__c cartItem :cartItems){
                         if(cartItem.ccrz__Product__r.ccrz__UnitOfMeasure__c !=null){
                                 String pUOM = cc_oo_pluralUOM__c.getValues(cartItem.ccrz__Product__r.ccrz__UnitOfMeasure__c).plural__c;
                                 cartItem.ccrz__Product__r.cc_oo_UoMDesc__c=pUOM;
                          }
                   }
                  dataMap.put('OrderViewData',cartItems);
           }
            
        
            System.debug('dataMap---->'+dataMap);
            res.success = true;
            res.data = dataMap;
        }
		catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderReViewDetails');
        }
		        return res;
		    } 
    /***************************************************************************************************************************************
      Method Name : getOrderReViewLeadTimeDetails
      Description : getOrderReViewLeadTimeDetails is to get the lead time details on order review page
      Parameter   : List<string> productIds 
                    productId is the list of sku ids.
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2690 - To fetch the product inventory on Order review page                                                              

                    
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderReViewLeadTimeDetails(final ccrz.cc_RemoteActionContext ctx,List<string> productIds){
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
             return res;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderReViewLeadTimeDetails');
        }
        return res;
    }
    /***************************************************************************************************************************************
      Method Name : getCommentsFromOrderInfo
      Description : getCommentsFromOrderInfo is to get the comments on order review page
      Parameter   : String cartId 
                    
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2690 - To fetch the comments on Order review page                                                              

                    
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCommentsFromOrderInfo(final ccrz.cc_RemoteActionContext ctx, String cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try{
             Map<String, String> dataMap = new Map<String, String>();
             ccrz__E_Cart__c comments = [select ccrz__Note__c from ccrz__E_Cart__c where id=:cartId];
             res.data = comments.ccrz__Note__c;
             res.success = true;
             
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCommentsFromOrderInfo');
        }
        return res;
    }
    /***************************************************************************************************************************************
      Method Name : getDeliveryInstructions
      Description : getDeliveryInstructions is to get the delivery Instructions on order review page
      Parameter   : String shipToId 
                    
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2690 and Defect 4322 - To fetch the delivery instructions on Order review page                                                              

                    
      *************************************************************************************************************************************/
    @RemoteAction
	global static ccrz.cc_RemoteActionResult getDeliveryInstructions(final ccrz.cc_RemoteActionContext ctx,string shipToId)
	{	
		ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
            Map<String,Object> shippingDetails=new Map<String,Object>(); 
            String deliveryInstruction;
		try
		{
		 	//US-1644-Start
		 	List<Account> act=[select AccountNumber,BillTo_Account__c,BillTo_Account__r.cc_oo_IsPORequired__c,cc_oo_IsPORequired__c,Delivery_Instruction_1__c,Delivery_Instruction_2__c from Account where accountNumber = : shipToId];
		   	if(act.size() > 0){
			   	deliveryInstruction='';
			   	//added null check 
			   	if(act[0].Delivery_Instruction_1__c != null && string.isNotBlank(act[0].Delivery_Instruction_1__c)){
			   		deliveryInstruction += act[0].Delivery_Instruction_1__c;
			   	}
			   	//US-1644 string concatenation
			   	if( act[0].Delivery_Instruction_2__c !=null && string.isNotBlank(act[0].Delivery_Instruction_2__c)){
			   			deliveryInstruction += ' ' + act[0].Delivery_Instruction_2__c;	
			   	}
			   	//field change to Delivery_Instruction_1__c as mentioned by Ashwini-US_1644
			   	shippingDetails.put('DeliveryInstructions',deliveryInstruction);
		    }
		    resp.data=shippingDetails;
			resp.success=true;
			//US-1644-end
			
		}	
		catch (Exception ex)
            {
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getDeliveryInstructions');
            }
        return resp;
	}
    
}