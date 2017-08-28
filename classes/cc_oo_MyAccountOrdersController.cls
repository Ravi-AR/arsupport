//<ClassName:cc_oo_MyAccountOrdersController>
//<Summary>
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         10/27/2016                                     US-166 Show Availability message on PDP page
//Samruddhi Gokhale                         10/27/2016                                     US-520 Amend Button Functionality
//Samruddhi Gokhale                         11/09/2016                                     US-524 Online ordering system must not allow customers to cancel an order after 
//                                                                                         cut-off for the longest lead time item in the order.
//Murtaza Beejwala                          11/09/2016                                     US-523,532 Amend and cancel functionality with the numeric_status column for csr flow.
// Saloni Kale								12/14/2016									   US-1447 The customer needs the ability to view Ship To and Ship From for each order in CC
//Piyali Mukherjee							01/03/2017									   US - 517 - JDE API Order Number 
//Shivani Singh								02/27/2017									   US - 1976 ReOrder Functionality 
global without sharing class cc_oo_MyAccountOrdersController{
     public static final string CLASS_NAME = 'cc_oo_MyAccountOrdersController';
     /************************************************************************************************************************
      Method Name : amendOrder
      Description : Create a new cart and cart items
      Parameter   : orderId 
                    This is the original id of cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   :  US-520 and US-527 Amend Button Functionality
                    
    *************************************************************************************************************************/ 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult amendOrder(final ccrz.cc_RemoteActionContext ctx, string orderId){    
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        boolean cartUpdated=false;
        ccrz__E_Cart__c newCart,clonedCart;
        Map<String,Object> dataMap= new Map<String,Object>();
        map<string, Object> data = new map<string, Object>();
        try
        { 
            if(orderId != null){
                List<ccrz__E_Order__c> order = [select id, ccrz__OriginatedCart__c,cc_oo_JDEOrderNumber__c, cc_oo_Seller__c from ccrz__E_Order__c where id =: orderId];
                List<ccrz__E_Cart__c> amendedCart=[select id,ccrz__CartStatus__c,ccrz__ActiveCart__c,cc_oo_JDEPreviousOrderNumber__c from ccrz__E_Cart__c WHERE cc_oo_OriginalCart__c=:order[0].ccrz__OriginatedCart__c and cc_oo_OriginalOrder__c=:orderId and ccrz__CartStatus__c=:'Open' and cc_oo_AmendedCart__c=true LIMIT 1];
                if(!amendedCart.isEmpty()){
                    delete amendedCart;
                }
                    if(!order.isEmpty() && order[0].ccrz__OriginatedCart__c != null){
                        ccrz__E_Cart__c cart = [select Id, ccrz__Account__c,ccrz__ActiveCart__c,ccrz__AdjustmentAmount__c,ccrz__AdjustmentReason__c,ccrz__AnonymousId__c,
                                                ccrz__BillTo__c, ccrz__CartType__c,cc_oo_Seller__c, ccrz__CCEmailAddress__c, ccrz__BuyerCompanyName__c,ccrz__Contact__c,
                                                ccrz__ContractId__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,
                                                ccrz__BuyerLastName__c,ccrz__BuyerMobilePhone__c,ccrz__Name__c,ccrz__Note__c,ccrz__PaymentMethod__c,ccrz__BuyerPhone__c,
                                                ccrz__PONumber__c,ccrz__RequestDate__c,ccrz__SessionId__c,ccrz__ShipAmount__c,ccrz__ShipComplete__c,ccrz__ShipDiscountAmount__c,
                                                ccrz__ShipMethod__c,ccrz__ShipTo__c,cc_oo_ShipToAccount__c,ccrz__Storefront__c,ccrz__SubtotalAmount__c,ccrz__TaxAmount__c,
                                                ccrz__TaxExemptFlag__c,ccrz__TotalDiscount__c,ccrz__TotalSurcharge__c,ccrz__User__c,ccrz__ValidationStatus__c,
                                                cc_oo_Alternate_Email_Id__c, cc_oo_AmendedCart__c,cc_oo_PickUpTime__c,cc_oo_TimeZone__c
                                                from ccrz__E_Cart__c where id=:order[0].ccrz__OriginatedCart__c LIMIT 1];
                        newCart = cart.clone(false, true, false, false);
                        newCart.ccrz__CartStatus__c = 'Open';
                        newCart.ccrz__ActiveCart__c = true;
                        newCart.cc_oo_AmendedCart__c = true;
                        newCart.cc_oo_SplitCartType__c = 'Primary';
                        newCart.cc_oo_JDEPreviousOrderNumber__c = order[0].cc_oo_JDEOrderNumber__c;
                        newCart.cc_oo_OriginalCart__c = cart.Id;
                        newCart.cc_oo_OriginalOrder__c = order[0].Id;
    
                        List<ccrz__E_ContactAddr__c> listContactAddress = [select id, ccrz__AddressFirstline__c, ccrz__AddressSecondline__c, ccrz__AddressThirdline__c, ccrz__AddrReadOnly__c, cc_oo_BillToShipToID__c,
                            ccrz__City__c, ccrz__CompanyName__c, ccrz__ContactAddrId__c, ccrz__Country__c, ccrz__CountryISOCode__c, ccrz__DaytimePhone__c, ccrz__Email__c,
                            ccrz__FirstName__c, ccrz__HomePhone__c, ccrz__LastName__c, ccrz__MailStop__c, ccrz__MiddleName__c, ccrz__Partner_Id__c, ccrz__PostalCode__c,
                            ccrz__ShippingComments__c, ccrz__State__c, ccrz__StateISOCode__c from ccrz__E_ContactAddr__c where id =: cart.ccrz__BillTo__c OR id =: cart.ccrz__ShipTo__c];
                        List<ccrz__E_ContactAddr__c> listNewContactAddress = new List<ccrz__E_ContactAddr__c>();
                        ccrz__E_ContactAddr__c newContactAddress;
                        for(ccrz__E_ContactAddr__c contAddr: listContactAddress){
                            newContactAddress = contAddr.clone(false, true, false, false);
                            listNewContactAddress.add(newContactAddress);
                        }
                        if(listNewContactAddress.size() > 0){
                            insert listNewContactAddress;
                        }
    
                        newCart.ccrz__BillTo__c = listNewContactAddress[0].Id;
                        newCart.ccrz__ShipTo__c = listNewContactAddress[1].Id;
                        insert newCart;
    
    
                        List<ccrz__E_CartItem__c> cartItems = [select ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,ccrz__cartItemType__c,cc_oo_leadtime__c,cc_oo_isFreightIncluded__c,
                                                                ccrz__Category__c,ccrz__Comments__c,ccrz__Coupon__c,ccrz__DisplayProduct__c,
                                                                ccrz__ItemLabel__c,ccrz__ItemTotal__c,ccrz__OriginalQuantity__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,
                                                                ccrz__ProductType__c,ccrz__Quantity__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c,ccrz__RequestDate__c,
                                                                ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__UnitOfMeasure__c,
                                                                ccrz__Is_Subscription_Selected__c,ccrz__Price__c,ccrz__Product__c,ccrz__StoreID__c,ccrz__Seller__c,cc_oo_IsListPrice__c, cc_oo_ContractPrice__c,
                                                                cc_oo_TotalWieght__c, cc_oo_OriginalCartItem__c, cc_oo_UnitPrice__c, cc_oo_LineNumberId__c, cc_oo_JDELineNumber__c,
                                                                cc_oo_OriginalBagPrice__c, cc_oo_OriginalPalletPrice__c
                                                                FROM ccrz__E_CartItem__c where ccrz__Cart__c =: order[0].ccrz__OriginatedCart__c];
                        List<ccrz__E_CartItem__c> newCartItems = new List<ccrz__E_CartItem__c>();
                        if(!cartItems.isEmpty()){
                            ccrz__E_CartItem__c newItem;
                            for(ccrz__E_CartItem__c cartItem: cartItems){
                                newItem = cartItem.clone(false, true, false, false);
                                newItem.ccrz__Cart__c = newCart.Id;
                                newItem.cc_oo_OriginalCartItem__c = cartItem.Id;
                                newItem.cc_oo_OriginalBagPrice__c = cartItem.cc_oo_OriginalBagPrice__c;
                                newItem.cc_oo_OriginalPalletPrice__c = cartItem.cc_oo_OriginalPalletPrice__c;
                                newItem.cc_oo_JDELineNumber__c = cartItem.cc_oo_JDELineNumber__c;
                                newCartItems.add(newItem);
                            }
                            insert newCartItems;
                        }
                     List<String> disabledAmendDates= new List<String>();
                     if(!String.isBlank(order[0].cc_oo_Seller__c)){
                     List<CC_OO_PlantHolidayCalendar__c> holidaysAmendList=[select cc_oo_Holiday__c,cc_oo_Plant__r.ccrz__SellerId__c from CC_OO_PlantHolidayCalendar__c where cc_oo_Plant__c=:order[0].cc_oo_Seller__c];
                     if(!holidaysAmendList.isEmpty()){
                         for(CC_OO_PlantHolidayCalendar__c holDate:holidaysAmendList){
                            Date dateToUse=holDate.cc_oo_Holiday__c;
                            String dateFinal = DateTime.newInstance(dateToUse.year(),dateToUse.month(),dateToUse.day()).format('dd MM YYYY');
                            disabledAmendDates.add(dateFinal);
                         }
                
                     }
                }
                    clonedCart = [select ccrz__EncryptedId__c,ccrz__RequestDate__c,ccrz__ShipMethod__c from ccrz__E_Cart__c where id=:newCart.Id LIMIT 1];
                    dataMap=cc_oo_HelperController.shuffleCart(clonedCart.ccrz__EncryptedId__c, cart.ccrz__RequestDate__c.format(),clonedCart.ccrz__ShipMethod__c,false);
                    date newShipDate = checkForPrimaryCartEmpty(clonedCart.Id, order[0].ccrz__OriginatedCart__c);
                    data.put('newCartId', clonedCart.ccrz__EncryptedId__c);
                    data.put('selectedSellerId', order[0].cc_oo_Seller__c);
                    if(newShipDate != null){//5148---------
                        String clonedCartDate=newShipDate.format();
                        data.put('requestedDate',clonedCartDate);
                    }else{
                        String clonedCartDate=clonedCart.ccrz__RequestDate__c.format();
                        data.put('requestedDate',clonedCartDate);
                    }
                    data.put('disabledAmendDates',disabledAmendDates);
                    res.data = data;//clonedCart.ccrz__EncryptedId__c; 
                    res.success = true;
                }
            
            }
        }catch (Exception ex)
        {
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'amendOrder');
        }
        return res;  
    }
    
    //5148---------
    private static date checkForPrimaryCartEmpty(Id newCartId, Id originatedCartId){
        List<ccrz__E_Cart__c> listCarts = [select id, Name, ccrz__RequestDate__c, cc_oo_SplitCart__r.cc_oo_SplitCartType__c, cc_oo_SplitCart__c, cc_oo_SplitCartType__c, ccrz__CartStatus__c,
                                                                (select ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,ccrz__cartItemType__c,
                                                                ccrz__Category__c,ccrz__Comments__c,ccrz__Coupon__c,ccrz__DisplayProduct__c,
                                                                ccrz__ItemLabel__c,ccrz__ItemTotal__c,ccrz__OriginalQuantity__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,
                                                                ccrz__ProductType__c,ccrz__Quantity__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c,ccrz__RequestDate__c,
                                                                ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__UnitOfMeasure__c,
                                                                ccrz__Is_Subscription_Selected__c,ccrz__Price__c,ccrz__Product__c,ccrz__StoreID__c,ccrz__Seller__c,cc_oo_IsListPrice__c, cc_oo_ContractPrice__c,
                                                                cc_oo_TotalWieght__c, cc_oo_OriginalCartItem__c, cc_oo_UnitPrice__c, cc_oo_LineNumberId__c, cc_oo_JDELineNumber__c,
                                                                cc_oo_OriginalBagPrice__c, cc_oo_OriginalPalletPrice__c
                                                                FROM ccrz__E_CartItems__r) from ccrz__E_Cart__c where id=:newCartId or cc_oo_SplitCart__c =: newCartId or id=: originatedCartId ORDER BY name ASC LIMIT 3];        
        
        List<ccrz__E_CartItem__c> newCartItems = new List<ccrz__E_CartItem__c>(); 
        List<ccrz__E_Cart__c> listNewCarts = new List<ccrz__E_Cart__c>(); 
        Date newShipDate = null;  
        boolean merged = false;                                                    
        ccrz__E_Cart__c originatedCart = null;//new ccrz__E_Cart__c();
        ccrz__E_Cart__c secondaryCart = null;
        if(listCarts.size() > 2){
            for(ccrz__E_Cart__c cart: listCarts){
                System.debug('cart.Name-->' + cart.Id);
                if(cart.ccrz__CartStatus__c == 'Closed'){
                    originatedCart = cart;
                }
                else if(originatedCart != null && cart.ccrz__CartStatus__c == 'Open' && cart.cc_oo_SplitCartType__c == 'Primary' && cart.ccrz__E_CartItems__r.size() == 0 && cart.cc_oo_SplitCart__c != null && cart.cc_oo_SplitCart__r.cc_oo_SplitCartType__c == 'Secondary'){
                    ccrz__E_CartItem__c newItem;
                    for(ccrz__E_CartItem__c cartItem: originatedCart.ccrz__E_CartItems__r){
                        newItem = new ccrz__E_CartItem__c();
                        newItem = cartItem.clone(false, true, false, false);
                        newItem.ccrz__Cart__c = cart.Id;
						newItem.cc_oo_OriginalCartItem__c = cartItem.Id;
                        newItem.cc_oo_OriginalBagPrice__c = cartItem.cc_oo_OriginalBagPrice__c;
                        newItem.cc_oo_OriginalPalletPrice__c = cartItem.cc_oo_OriginalPalletPrice__c;
                        newItem.cc_oo_JDELineNumber__c = cartItem.cc_oo_JDELineNumber__c;
                        newCartItems.add(newItem);
                    }
                    
                    if(listCarts.size() >= 3 && listCarts[2] != null ){
                        if(listCarts[2].cc_oo_SplitCartType__c == 'Secondary' && listCarts[2].ccrz__CartStatus__c == 'Open'){
                            cart.ccrz__RequestDate__c = listCarts[2].ccrz__RequestDate__c;
                            newShipDate = listCarts[2].ccrz__RequestDate__c;
                        }
                    }
                    cart.cc_oo_isShipDateExtended__c = true;
                    listNewCarts.add(cart);
                    merged = true;
                }else if(merged == true && cart.ccrz__CartStatus__c == 'Open' && cart.cc_oo_SplitCartType__c == 'Secondary'){
                    secondaryCart = cart;
                }
            }
            if(merged == true){
                if(listNewCarts.size() > 0){
                    update listNewCarts;
                }
                if(newCartItems.size() > 0){
                    insert newCartItems;
                }

                if(secondaryCart != null){
                    delete secondaryCart;
                }
            }
        }                                                              
        return newShipDate;
    }
    //5148---------
    
    /***************************************************************************************************************************************
      Method Name : getAllShipValues
      Description : getAllShipValues is to get all the shipTo's and shipFrom
      Return type : Returns DataMap.
      UserStory   : OO-1447 - ship to and ship from of the orders placed.
                    
      *************************************************************************************************************************************/
       @RemoteAction
     global static ccrz.cc_RemoteActionResult getAllShipValues(final ccrz.cc_RemoteActionContext ctx){
            ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
            res.success = false;
            System.debug('*******in my account orders*******');
        try{
            
            map<String,set<string>> shipToAndFrom   =new map<String,set<String>>();
            map<String,set<string>> shipFromAndTo   =new map<String,set<String>>();
            Set<String> ShipTo  =new Set<String>();
            Set<String> ShipFrom =new Set<String>();
            list<Map<String,String>> CartShipToData =new list<Map<String,String>>();
            map<String,Object> finalFilterData  = new map<String,Object>();
            String portalUser=ccrz.cc_CallContext.currPageParameters.get('isCSRFlow');
            list<Id> cartList=new list<Id>();
            map<Id,Id> orderCart	=new map<Id,Id>();
           	map<id,String> orderWeight=new map<id,String>();
           	Id userContact=ccrz.cc_CallContext.currContact.Id;
	        Set<id> accountIds = new Set<id>();
	        Id dealerAccountId = null;
	        for(AccountContactRelation acctContRel : [SELECT AccountId,ContactId,Id,IsActive, Account.ParentId
	            FROM AccountContactRelation where ContactId =: userContact and IsActive = true]){ 
	            if(acctContRel.Account.ParentId == null){
	                dealerAccountId = acctContRel.AccountId;
	                break;
	            }else{
	                accountIds.add(acctContRel.AccountId);
	            }
			}
			if(dealerAccountId!=null){
				accountIds = new Set<id>();
				for(Account dealerAccount:[SELECT Id from Account WHERE Parent.Id=:dealerAccountId]){
					accountIds.add(dealerAccount.Id);
				}
				accountIds.add(dealerAccountId);
			}
            for(ccrz__E_Order__c cartData:[select c.Id,c.ccrz__OriginatedCart__c,c.ccrz__RequestDate__c,c.cc_oo_ShipToAccount__r.AccountNumber,c.cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_JDEOrderNumber__c, cc_oo_JDEFlag__c,cc_oo_JDENumericStatus__c,ccrz__OrderStatus__c From ccrz__E_Order__c c where c.cc_oo_ShipToAccount__c IN:accountIds ORDER BY name desc]){
            	//cartList.add(cartData.ccrz__OriginatedCart__c);
            	//orderCart.put(cartData.ccrz__OriginatedCart__c,cartData.Id);
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
                    ShipTo.add(cartData.cc_oo_ShipToAccount__r.AccountNumber);
                    ShipFrom.add(cartData.cc_oo_Seller__r.ccrz__SellerId__c);
                    /*map<String,String> shiptofrom   =new map<String,String>();
                    shiptofrom.put('shipTo',cartData.cc_oo_ShipToAccount__r.AccountNumber);
                    shiptofrom.put('shipFrom',cartData.cc_oo_Seller__r.ccrz__SellerId__c);
                    shiptofrom.put('orderId',cartData.Id);*/
                    
                   /* if(cartData.cc_oo_JDEOrderNumber__c!=null && cartData.cc_oo_JDEOrderNumber__c!=''){
                    	shiptofrom.put('JDE_OrderNumber',cartData.cc_oo_JDEOrderNumber__c);
                    }
                    if(cartData.cc_oo_JDEFlag__c == '0' &&( cartData.cc_oo_JDEFlag__c!=null && cartData.cc_oo_JDEFlag__c!='')&& (cartData.ccrz__OrderStatus__c != 'Pending')){
	                	shiptofrom.put('ShowAmdCancelBtn','true');
	                }
	                else if((cartData.cc_oo_JDEFlag__c=='1')&&(portalUser=='false')){
	                	shiptofrom.put('ShowAmdCancelBtn','false'); 
	                }
	                else if((cartData.cc_oo_JDEFlag__c=='1')&&(portalUser=='true')){
	                	shiptofrom.put('ShowAmdCancelBtn','true');
	                }
	                else{
	                    shiptofrom.put('ShowAmdCancelBtn','false');
	                }*/
                    //CartShipToData.add(shiptofrom);     
            }
            System.debug('1'+cartList);
            System.debug('2'+orderCart);
            //map<Id,List<ccrz__E_CartItem__c>> cartItemList  = [SELECT Id,(SELECT Id, cc_oo_TotalWieght__c FROM ccrz__E_CartItem__c ) FROM ccrz__E_Cart__c WHERE ccrz__Cart__c.Id IN: cartList];
            /*for(ccrz__E_Cart__c cartId:([SELECT Id,(SELECT Id, cc_oo_TotalWieght__c FROM ccrz__E_CartItems__r ) FROM ccrz__E_Cart__c WHERE ccrz__E_Cart__c.Id IN: cartList])){
            	Decimal totalAggr=0;
            	for(ccrz__E_CartItem__c cartitemlevel:cartId.ccrz__E_CartItems__r){
            		totalAggr+=cartitemlevel.cc_oo_TotalWieght__c;
            	}
            	orderWeight.put(orderCart.get(cartId.Id),String.valueOf(totalAggr));
            	
            }
            System.debug('3'+orderWeight);
            list<Map<String,String>> tempCartShipToData =new list<Map<String,String>>();
            for(map<String,String> cartship:CartShipToData){
            	if(orderWeight.containsKey(cartship.get('orderId'))){
            		map<String,String> tempShiptofrom   =new map<String,String>();
            		tempShiptofrom=cartship;
            		tempShiptofrom.put('orderWeight',orderWeight.get(cartship.get('orderId')));
            		tempCartShipToData.add(tempShiptofrom);
            		System.debug('5'+tempShiptofrom);
             		//cartship.put('orderWeight',orderWeight.get(cartship.get('orderId')));
             		//cartShipToData.add(cartship);
             	}
            }*/
           // cartShipToData=tempCartShipToData;
            System.debug('4'+cartShipToData);
            System.debug('shipFromAndTo'+shipFromAndTo);
            System.debug('shipToAndFrom'+shipToAndFrom);
            System.debug('shipTo'+ShipTo);
            System.debug('shipFrom'+ShipFrom);
            System.debug('orderData'+CartShipToData);
            finalFilterData.put('shipToAndFrom',shipToAndFrom);
            finalFilterData.put('shipTo',ShipTo); 
            finalFilterData.put('shipFrom',ShipFrom);
            //finalFilterData.put('orderData',CartShipToData);
            finalFilterData.put('shipFromAndTo',shipFromAndTo);
            res.data=finalFilterData;
            res.success=true;
        }
        catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getAllShipValues');
        }
        return res;
     }
    
        /************************************************************************************************************************
      Method Name : getReasonCodes
      Description : get all the reasonCodes
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : US-522 
                    
      *************************************************************************************************************************/
     /*@RemoteAction
     global static ccrz.cc_RemoteActionResult getReasonCodes(final ccrz.cc_RemoteActionContext ctx){
              
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        
        try
        { 
              Map<String, String> dataMap = new Map<String, String>();
              
              List<ReasonCodes__c> reasonCodes = [Select Name,Value__c From ReasonCodes__c];
            
            for(ReasonCodes__c codes : reasonCodes){
                dataMap.put(codes.Name,codes.Value__c);
                }
            
            res.success = true;
            res.data = dataMap;
           return res;
        }catch (Exception err)
        {
              System.debug(err+' '+err.getStackTraceString());
        }

        return null;
    } 
    /************************************************************************************************************************
      Method Name : updateStatus
      Description : update all the orders
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : US-522 
                    
      *************************************************************************************************************************/
    /* @RemoteAction
     global static ccrz.cc_RemoteActionResult updateOrder(final ccrz.cc_RemoteActionContext ctx,String orderId,String reasonCode){
              
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        String csrFlow = ccrz.cc_CallContext.currPageParameters.get('isCSRFlow');
        
        
        try
        { 
            List<ccrz__E_Order__c> newOrderList= new List<ccrz__E_Order__c>();
            for(ccrz__E_Order__c orderVal :[SELECT ccrz__OrderStatus__c FROM ccrz__E_Order__c WHERE Id=:orderId]){
                orderVal.ccrz__OrderStatus__c='Cancelled';
                newOrderList.add(orderVal);
            }
            if(newOrderList.size()>0){
                update newOrderList;
            }
            
            List<ccrz__E_OrderItem__c> newItemList = new List<ccrz__E_OrderItem__c>();
            for(ccrz__E_OrderItem__c orderItems :[SELECT ccrz__OrderItemId__c,ccrz__OrderItemStatus__c,cc_oo_ReasonCode__c FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c=:orderId]){
                orderItems.ccrz__OrderItemStatus__c='Cancelled';
                orderItems.cc_oo_ReasonCode__c=reasonCode;
                newItemList.add(orderItems);
            }
            if(newItemList.size()>0){
                update newItemList;
            } 
            
            
            
            res.success = true;
           return res;
        }catch (Exception err)
        {
              System.debug(err+' '+err.getStackTraceString());
              
        }

        return null;
    }*/
    
    /************************************************************************************************************************
      Method Name : cancelOrder
      Description : Cancel order Functionality
      Parameter   : orderId 
                    This is the original id of cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   :  US-521 Cancel Button Functionality
                    
      *************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult cancelOrder(final ccrz.cc_RemoteActionContext ctx, string orderId){    
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        String JDEOrderNumber;
        Boolean status = false;
        res.success = false;
        try{
            
            if(orderId != null){
                List<ccrz__E_Order__c> order = [select cc_oo_JDEOrderNumber__c,ccrz__OrderStatus__c from ccrz__E_Order__c where id =: orderId]; 
	            if(order.size() > 0) {
                    JDEOrderNumber = order[0].cc_oo_JDEOrderNumber__c;
                    System.debug('JDEOrderNumber cancel------->'+JDEOrderNumber);
                    status = cc_oo_ServiceOrderCancelCallOut.cancelOrder(JDEOrderNumber);
                    System.debug('status cancel order--->' + status);
                    //OO-4462
                    if(status == true){
                        order[0].cc_oo_IsSyncOrder__c = true;
                    }else{
                        order[0].cc_oo_IsSyncOrder__c = false;
                    }//OO-4462
                    order[0].ccrz__OrderStatus__c = 'Cancelled';
                    update order; 

                    res.data = true;
                    res.success = true;
                }
        	}
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'cancelOrder');
        }
        return res;
    }
    
    /************************************************************************************************************************
      Method Name : getReorderUrl
      Description : ReOrder Functionality
      Parameter   : orderId 
                    This is the orderId
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : US-1976 ReOrder  Functionality
                    
      *************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getReorderUrl(final ccrz.cc_RemoteActionContext ctx, string orderId,string cartId,string shipTo,string sellerId,string shipDate){    
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        boolean status=false;
        String url;
        try{
            List<ccrz__E_Order__c> listOrderItems = [select id, cc_oo_Seller__c,cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Order__c where id =: orderId];
            String orderSellerId=listOrderItems[0].cc_oo_Seller__c;
            String orderShipTo=listOrderItems[0].cc_oo_ShipToAccount__r.AccountNumber;
            boolean changeShipToSeller =false;
            if(orderSellerId.equals(sellerId) && orderShipTo.equals(shipTo)){
                url = cc_oo_HelperController.getRedirectUrl('ccrz__CCPage?pageKey=reorder&',null,cartId,false,null);
                
            }
            else{
                ccrz__E_Cart__c newActiveCart=cc_oo_HeaderController.mapToCart(orderSellerId,orderShipTo,false);
                changeShipToSeller=true;
                if(newActiveCart.cc_oo_AmendedCart__c) {
                	newActiveCart.cc_oo_AmendedCart__c = false;
                	update newActiveCart;
                }
	               /* if(String.isNotBlank(shipDate)){
	                    newActiveCart.ccrz__RequestDate__c=Date.parse(shipDate);
	                    update newActiveCart;
	                }*/
	            
                
                
                url = cc_oo_HelperController.getRedirectUrl('ccrz__CCPage?pageKey=reorder&',null,newActiveCart.ccrz__EncryptedId__c,false,null);
            }
            String orderSid;
            String orderAccNumber;
            List<String> disabledOrderDates= new List<String>();
            if(changeShipToSeller){
                if(sellerId=='undefined'){
                    url=url.replace('&sid=null' ,'&sid='+orderSellerId);
                }
                else{
                    url=url.replace('&sid='+sellerId ,'&sid='+orderSellerId);
                }
                orderSid=orderSellerId;
                orderAccNumber=orderShipTo;
                if(!String.isBlank(orderSid)){
                	 List<CC_OO_PlantHolidayCalendar__c> holidaysOrderList=[select cc_oo_Holiday__c,cc_oo_Plant__r.ccrz__SellerId__c from CC_OO_PlantHolidayCalendar__c where cc_oo_Plant__c=:orderSid];
                	 if(!holidaysOrderList.isEmpty()){
	                	 for(CC_OO_PlantHolidayCalendar__c holDate:holidaysOrderList){
	                     	Date dateToUse=holDate.cc_oo_Holiday__c;
	                     	String dateFinal = DateTime.newInstance(dateToUse.year(),dateToUse.month(),dateToUse.day()).format('dd MM YYYY');
	                     	disabledOrderDates.add(dateFinal);
	                	 }
                
                     }
                }
            }
            /*if(url.contains('portalUser')){
            	url = url+'&isCSRFlow=true';
            }*/
            Map<String,object> dataMap= new Map<String,object>();
            dataMap.put('url',url);
            dataMap.put('orderSid',orderSid);
            dataMap.put('orderAccNumber',orderAccNumber);
            dataMap.put('disabledOrderDates',disabledOrderDates);
            
            res.data = dataMap;
            res.success = true;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getReorderUrl');
        }
        return res;
    }

}