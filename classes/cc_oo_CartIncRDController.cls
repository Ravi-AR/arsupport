/**************************************Change Log*****************************************************************************************
Name:cc_oo_CartIncRDController - (cc_oo_CartDetail, cc_oo_CartIncRD2)
Shrivaths                               11/17/2016                                    US:OO-333 Minimum order messages on Cart Page
******************************************************************************************************************************************/

global without sharing class cc_oo_CartIncRDController {
	
	public static final string CLASS_NAME = 'cc_oo_CartIncRDController';
    
    /***************************************************************************************************************************************
      Method Name : getTotalWeight
      Description : getTotalWeight is to get the total weight of the product
      Parameter   : cartId 
                    cartId is used to encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-492 - write a program to view the total weight of an order under the header                                                              

                    
      *************************************************************************************************************************************/ 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getTotalWeight(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        {   
            List<AggregateResult> cartItemAggr   = [SELECT SUM(cc_oo_TotalWieght__c)TotalWeight FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId ];
            Decimal aggregateCartOrderWeight = (Decimal)cartItemAggr[0].get('TotalWeight');
           
            res.success=true;
            res.data=aggregateCartOrderWeight;                    
            
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getTotalWeight');
        }
        return res;
    }
    
    /************************************************************************************************************************
      Method Name : getCartType
      Description : getCartType is to fetch the type of the cart whether it is Pre-Book or Online Order
      Parameter   : cartId 
                    cartId is used to store id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-244, OO-261 - method is to check the cart type if this is Pre-Book
                    
      *************************************************************************************************************************/ 
     
     @RemoteAction
     global static ccrz.cc_RemoteActionResult getCartType(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
            List<ccrz__E_Cart__c> selectedCart = [select id, ccrz__CartType__c from ccrz__E_Cart__c where id =: cartId];
            if(selectedCart[0].ccrz__CartType__c.capitalize() == Label.cc_oo_Pre_BookLabel.capitalize()){
                res.success = true;
                res.data = '';
            }
            
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCartType');
        }
       return res;
    } 
    
    /***************************************************************************************************************************************
      Method Name : validateOrderMinimumWeight
      Description : validateOrderMinimumWeight is to validate whether the Preorder minimum weight is more than the minimum weight limit
      Parameter   : cartId 
                    cartId is used to store id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-202 - Ability to validate the quantities in the shopping cart page with the minimum order weight for pre book orders
                    
      *************************************************************************************************************************************/ 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult validateOrderMinimumWeight(final ccrz.cc_RemoteActionContext ctx, string cartId, Map<string, Integer> cartItemMap){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        
        try
        {  
            //List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__c, ccrz__Product__r.Id, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
            
            Map<ID, Decimal> productQuantityMap = new Map<ID, Decimal>();
            Map<ID, Decimal> productWeightMap = new Map<ID, Decimal>();
            Decimal aggregateCartOrderWeight = 0; 
            List<ccrz__E_CartItem__c> updatedList = new List<ccrz__E_CartItem__c>();
            for (ccrz__E_CartItem__c item :([SELECT ccrz__Product__c, ccrz__Product__r.Id, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId])){
                Integer quantity = cartItemMap.get(item.Id);
                if(item.ccrz__Product__r != null && 
                    item.ccrz__Product__r.ccrz__ProductWeight__c != null 
                        && quantity != null)
                {
                    item.ccrz__Quantity__c = quantity;
                    aggregateCartOrderWeight += item.ccrz__Product__r.ccrz__ProductWeight__c * quantity;
                    updatedList.add(item);
                }
                //productQuantityMap.put(item.ccrz__Product__r.Id, item.ccrz__Quantity__c);
                //productWeightMap.put(item.ccrz__Product__r.Id, item.ccrz__Product__r.ccrz__ProductWeight__c);
            }
            update updatedList;
                  
            // Conversion of product weight in lbs to tonne
            Decimal aggregateCartOrderWeightInTonne = aggregateCartOrderWeight * 0.0005;          
            Decimal requiredWeightInLbs = (1 - aggregateCartOrderWeightInTonne) * 2000;  
                    
            cc_oo_prebook_minimum_weight__c minimumWeight = cc_oo_prebook_minimum_weight__c.getValues('prebook_minimum_weight');            
           
            if(aggregateCartOrderWeightInTonne >= minimumWeight.prebook_minimum_weight__c) {
                    res.success = true;                   
            } else {
                res.data = requiredWeightInLbs.round(); 
            }
            
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'validateOrderMinimumWeight');
        }
        return res;
    }
    
    //this is to be moved to CartIncRDController,here also
    /***************************************************************************************************************************************
      Method Name : checkForMinimumWeight
      Description : checkForMinimumWeight is to check if the cart items are enough for Free Delivery(no fright charges)
      Parameter   : cartId is used to store id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-796(OO-333) - Retrieve The minimum order weight depending on the combination of plant and ship method and add validation
                    
      *************************************************************************************************************************************/ 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult checkForMinimumWeight(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        decimal totalWeightForType = 0;
        
        string cartType = '';
        string sellerCode;
        string message = '';

        try
        {  

            for(ccrz__E_CartItem__c cartItem: [SELECT Id, ccrz__Cart__r.cc_oo_Seller__r.ccrz__SellerId__c, ccrz__Product__c, ccrz__Product__r.Id,ccrz__Product__r.cc_oo_TypeOfProduct__c, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId]){
                sellerCode = cartItem.ccrz__Cart__r.cc_oo_Seller__r.ccrz__SellerId__c;
                cartType = cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c.toLowerCase();
                totalWeightForType += cartItem.ccrz__Product__r.ccrz__ProductWeight__c * cartItem.ccrz__Quantity__c;
            }
            
            string orderMinimum ='';
            String smallOrder ='';
            for(cc_oo_PlantCutOff__c  plantRec : [select id, cc_oo_OrderMinumum__c, cc_oo_Plant__c, cc_oo_ProductType__c, cc_oo_ShippingMethod__c, cc_oo_SmallOrderWeight__c from cc_oo_PlantCutOff__c where  cc_oo_Plant__c =: sellerCode and cc_oo_ProductType__c =: cartType]){
                String typeOfProduct=plantRec.cc_oo_ProductType__c;
                orderMinimum= string.valueOf(plantRec.cc_oo_OrderMinumum__c);
                smallOrder = string.valueOf(plantRec.cc_oo_SmallOrderWeight__c);
                if(plantRec.cc_oo_ShippingMethod__c == 'DELIVERY'){
                	//defect-OO-5177
                         if((typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK'))) || (typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID')))){
                  			if(totalWeightForType < plantRec.cc_oo_OrderMinumum__c) {
                  				message += Label.cc_oo_RouteTruckOrdMinWeightMsg.replace('__',orderMinimum) + '<br>';
                  			}
	             		 }else{
	             		 	if(totalWeightForType < plantRec.cc_oo_OrderMinumum__c && plantRec.cc_oo_OrderMinumum__c > 1) {
	             		 		message += Label.cc_oo_RouteTruckOrdMinWeightMsgBag.replace('__',orderMinimum) + ' ';
	             		 	}
	             		 	if(totalWeightForType < plantRec.cc_oo_SmallOrderWeight__c && plantRec.cc_oo_SmallOrderWeight__c > 1) {
	             		 		message += Label.cc_oo_RouteTruckOrdSmallWeightMsgBag.replace('__',smallOrder) + '<br>';
	             		 	}
	             		 }
	                    res.success = true;
                }else if(plantRec.cc_oo_ShippingMethod__c == 'PICKUP' && totalWeightForType < plantRec.cc_oo_OrderMinumum__c){
                        res.success = true;
                        message += Label.cc_oo_PickUpOrdMinWeightMsg.replace('__',orderMinimum) + '<br>';
                }
                
            }
            res.data = message;
            
           
        }catch (Exception ex){
        
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'checkForMinimumWeight');
        }
        return res;
    }
    
    /***************************************************************************************************************************************
      Method Name : saveNotes
      Description : saveNotes is to save the comment for cartItem.
      Parameter   : cartItemId,Notes 
                    cartItemId is used to retrieve the cartItem.
                    notes is used to save the comment.
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-340 - write a program to save the notes for that cartItem.                                                              

                    
      *************************************************************************************************************************************/ 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult saveNotes(final ccrz.cc_RemoteActionContext ctx, string cartItemId,String notes){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        System.debug('In saveNotes');
        try
        {   System.debug('In try saveNotes');
            ccrz__E_CartItem__c cartNotes = [select c.ccrz__Comments__c from ccrz__E_CartItem__c c where c.Id=:cartItemId];
            if(cartNotes!=null && notes!=null){
                cartNotes.ccrz__Comments__c=notes;
                update cartNotes;
                res.success=true;
            }
            System.debug('updated saveNotes');
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'saveNotes');
              
        }
        return res;
    }
    
}