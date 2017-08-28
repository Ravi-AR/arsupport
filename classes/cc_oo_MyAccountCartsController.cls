//ClassName:cc_oo_MyAccountCartsController 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                        Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         10/12/2016                                       OO-546 Cart Name should be shown as a unique number on My Carts.
//Murtaza Beejwala							13-Dec-2016										 OO-1451 Getting the shipto's and shipfrom's for filter widget.
//-----------------------------------------------------------------------------------------------------------------------
 global class cc_oo_MyAccountCartsController {
     public static final string CLASS_NAME = 'cc_oo_MyAccountCartsController';
     @RemoteAction
    global static ccrz.cc_RemoteActionResult getCartDetails(final ccrz.cc_RemoteActionContext ctx, List<string> cartIds){
              
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        
        try
        { 
              map<String, Map<string,string>> dataMap = new map<string,Map<string,string>>();
              String cartname=ccrz.cc_CallContext.pageLabels.get('Mycart_name');
              List<ccrz__E_Cart__c> cc_Carts = [Select c.Id, c.Name,c.CreatedDate, c.ccrz__EncryptedId__c From ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c IN :cartIds];
            map<String,String> cartFields;
            for(ccrz__E_Cart__c cartItem : cc_Carts){
            		cartFields =new map<String,String>();
	    			cartFields.put('cartName',string.valueOf(cartname+cartItem.Name));
	    			cartFields.put('lastCreate',string.valueOf(cartItem.CreatedDate));
                    dataMap.put(string.valueOf(cartItem.ccrz__EncryptedId__c),cartFields);
            }            
            res.success = true;
            res.data = dataMap;
        }catch (Exception ex)
        {
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCartDetails');
        }
        return res;
    }
    
     /***************************************************************************************************************************************
      Method Name : getAllShipValues
      Description : getAllShipValues is to get all the shipTo's and shipFrom
      Return type : Returns DataMap.
      UserStory   : OO-1451 - ship to and ship from of the carts created.
                    
      *************************************************************************************************************************************/
     @RemoteAction
     global static ccrz.cc_RemoteActionResult getAllShipValues(final ccrz.cc_RemoteActionContext ctx){
    		ccrz.cc_CallContext.initRemoteContext(ctx);
	        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
	        res.success = false;
	        System.debug('*******in my account carts*******');
    	try{
    		map<String,set<string>> shipToAndFrom	=new map<String,set<String>>();
    		map<String,set<string>> shipFromAndTo	=new map<String,set<String>>();
    		Set<String> ShipTo	=new Set<String>();
    		Set<String> ShipFrom =new Set<String>();
    		list<Map<String,String>> CartShipToData =new list<Map<String,String>>();
    		map<String,Object> finalFilterData	= new map<String,Object>();
    		for(ccrz__E_Cart__c cartData:[select c.Id,(SELECT Id, cc_oo_TotalWieght__c FROM ccrz__E_CartItems__r ),c.CreatedDate,c.cc_oo_ShipToAccount__r.AccountNumber,c.cc_oo_Seller__r.ccrz__SellerId__c From ccrz__E_Cart__c c where c.ccrz__CartStatus__c='Open' AND c.ccrz__Account__c =: ccrz.cc_CallContext.currAccount.Id AND c.ccrz__Contact__c =:ccrz.cc_CallContext.currContact.Id AND  c.ccrz__User__c =:ccrz.cc_CallContext.currUserId]){
	    			if(shipToAndFrom.containsKey(cartData.cc_oo_ShipToAccount__r.AccountNumber)){
	    				if(!(shipToAndFrom.get(cartData.cc_oo_ShipToAccount__r.AccountNumber)).contains(cartData.cc_oo_Seller__r.ccrz__SellerId__c)){
	    					shipToAndFrom.get(cartData.cc_oo_ShipToAccount__r.AccountNumber).add(cartData.cc_oo_Seller__r.ccrz__SellerId__c);
	    				}	
	    			}
	    			else{
	                    set<string> listSellerIds = new set<string>();
	                    listSellerIds.add(cartData.cc_oo_Seller__r.ccrz__SellerId__c);
	                    shipToAndFrom.put(cartData.cc_oo_ShipToAccount__r.AccountNumber,listSellerIds);
	                    system.debug('shipToAndFromelse'+shipToAndFrom);
	    			}
	    			if(shipFromAndTo.containsKey(cartData.cc_oo_Seller__r.ccrz__SellerId__c)){
	    				if(!(shipFromAndTo.get(cartData.cc_oo_Seller__r.ccrz__SellerId__c)).contains(cartData.cc_oo_ShipToAccount__r.AccountNumber)){
	    					shipFromAndTo.get(cartData.cc_oo_Seller__r.ccrz__SellerId__c).add(cartData.cc_oo_ShipToAccount__r.AccountNumber);
	    				}	
	    			}
	    			else{
	                    set<string> listSellerIds = new set<string>();
	                    listSellerIds.add(cartData.cc_oo_ShipToAccount__r.AccountNumber);
	                    shipFromAndTo.put(cartData.cc_oo_Seller__r.ccrz__SellerId__c,listSellerIds);
	                    system.debug('shipFromAndToelse'+shipFromAndTo);
	    			}
	    			Decimal totalAggr=0;
	    			for(ccrz__E_CartItem__c cartitemlevel:cartData.ccrz__E_CartItems__r){
	    				totalAggr+=cartitemlevel.cc_oo_TotalWieght__c;
	    			}
	    			ShipTo.add(cartData.cc_oo_ShipToAccount__r.AccountNumber);
	    			ShipFrom.add(cartData.cc_oo_Seller__r.ccrz__SellerId__c);
	    			map<String,String> shiptofrom	=new map<String,String>();
	    			shiptofrom.put('shipTo',cartData.cc_oo_ShipToAccount__r.AccountNumber);
	    			shiptofrom.put('shipFrom',cartData.cc_oo_Seller__r.ccrz__SellerId__c);
	    			shiptofrom.put('sellerId',cartData.cc_oo_Seller__c);
	    			shiptofrom.put('cartId',cartData.Id);
	    			shiptofrom.put('lastCreate',string.valueOf(cartData.CreatedDate));
	    			shiptofrom.put('cartWeight',string.valueof(totalAggr));
	    			CartShipToData.add(shiptofrom); 
                }
            System.debug('shipFromAndTo'+shipFromAndTo);
    		System.debug('shipToAndFrom'+shipToAndFrom);
    		System.debug('shipTo'+ShipTo);
    		System.debug('shipFrom'+ShipFrom);
    		System.debug('cartData'+CartShipToData);
    		finalFilterData.put('shipToAndFrom',shipToAndFrom);
    		finalFilterData.put('shipTo',ShipTo);
    		finalFilterData.put('shipFrom',ShipFrom);
    		finalFilterData.put('cartData',CartShipToData);
    		finalFilterData.put('shipFromAndTo',shipFromAndTo);
    		res.data=finalFilterData;
    		res.success=true;
    	} 
    	catch(Exception ex){
    		cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getAllShipValues');
    	}
    	return res;
    }
}