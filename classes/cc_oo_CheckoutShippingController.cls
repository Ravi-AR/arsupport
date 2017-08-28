/* 
----------------------------------------------------------------------------------------------------------------------
Author                                      Date                                           Description
----------------------------------------------------------------------------------------------------------------------
Murtaza B							    10/26/2016									 US:OO-513 To give the ability to enter the PO Number
*/

/***************************************************************************************************************************************
      Method Name : PurchaseOrderNumber
      Description : PurchaseOrderNumber is to save the po number in cart
      Parameter   : cartId :cartId is encrypted id of Cart,purchaseorder is the po number entered
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-513 - enter the purchase order at checkout shipping.
                    
      *************************************************************************************************************************************/
global without sharing class cc_oo_CheckoutShippingController {
    public static final string CLASS_NAME = 'cc_oo_CheckoutShippingController';
    // US- OO:2434 start
    public static Date shipDateOrderInfo {get;set;}
    public static String shipDateString {get;set;}
   /* public cc_oo_CheckoutShippingController(){
        String cartId;
        String shipToNumber;
        List<ccrz__E_CartItem__c> cartItems = [select ccrz__Cart__c,ccrz__Cart__r.ccrz__Account__r.AccountNumber,ccrz__Cart__r.ccrz__RequestDate__c,ccrz__Cart__r.cc_oo_ShipToAccount__c,ccrz__Product__c,ccrz__Product__r.cc_oo_TypeOfProduct__c from ccrz__E_CartItem__c where ccrz__Cart__r.cc_oo_ShipToAccount__c=:ccrz.cc_CallContext.currAccountId LIMIT 1];
        //List<ccrz__E_CartItem__c> cartItems = [select ccrz__Cart__c,ccrz__RequestDate__c,ccrz__Cart__r.ccrz__Account__r.AccountNumber,ccrz__Cart__r.ccrz__RequestDate__c,ccrz__Cart__r.cc_oo_ShipToAccount__c,ccrz__Product__c,ccrz__Product__r.cc_oo_TypeOfProduct__c from ccrz__E_CartItem__c where ccrz__Cart__r.cc_oo_ShipToAccount__r.AccountNumber = : shipToNumber LIMIT 1];
        System.debug('cartItems ---->'+cartItems);
        System.debug('cartItems constructor----->'+cartItems);
        if(cartItems[0].ccrz__Cart__r.ccrz__RequestDate__c!=Null){
            shipDateOrderInfo = cartItems[0].ccrz__Cart__r.ccrz__RequestDate__c;
        }
        
        shipDateString = shipDateOrderInfo.format();
        System.debug('shipDate ----->'+shipDateString);
    }*/
     // US- OO:2434 End
     @RemoteAction
     global static ccrz.cc_RemoteActionResult getshipDate(final ccrz.cc_RemoteActionContext ctx,String cartId){
         System.debug('*******in getShipDate method************');
		 ccrz.cc_CallContext.initRemoteContext(ctx);
         ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
         List<String> dataMap = new List<String>();
         
         resp.success = false;
         try{
             
             List<ccrz__E_Cart__c> cart = [select  id, ccrz__RequestDate__c from ccrz__E_Cart__c where id =: cartId LIMIT 1];
             if(cart.size() > 0){
                if(cart[0].ccrz__RequestDate__c!=Null){
                  shipDateOrderInfo = cart[0].ccrz__RequestDate__c;
                  shipDateString = shipDateOrderInfo.format();
                  System.debug('shipDate ----->'+shipDateString);
                  dataMap.add(shipDateString);
                  resp.data = dataMap;
                  resp.success = true;
                }
            }
            
         }catch(Exception ex){
             cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getshipDate');
         }
         return resp;
     }
     
    @RemoteAction
	global static ccrz.cc_RemoteActionResult PurchaseOrderNumber(final ccrz.cc_RemoteActionContext ctx,string cartid,string purchaseorder,String modifiedDelvIns,String modifiedshipnotes,String pickupTime,String shippingMethodOptions,String timeZone)
	{	System.debug('*******in purchase method************');
		ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
			
		try
		{	System.debug('*******in try block of method************');
			ccrz__E_Cart__c cartcheck=[select c.ccrz__PONumber__c,ccrz__Note__c,ccrz__ShipMethod__c,cc_oo_TimeZone__c from ccrz__E_Cart__c c where c.Id =:cartid];
			if(cartcheck.ccrz__PONumber__c!=null && cartcheck.ccrz__PONumber__c!='')
			{
				if(purchaseorder!=cartcheck.ccrz__PONumber__c)
				{	
						cartcheck.ccrz__PONumber__c=purchaseorder;
						resp.success=true;
						System.debug('*******coming back again************');
				}
			}
			else
			{
					//ccrz__E_PaymentDetail__c paymentdetail=new ccrz__E_PaymentDetail__c();
					cartcheck.ccrz__PONumber__c=purchaseorder;
					//paymentdetail.ccrz__Cart__c=cartid;
					resp.success=true;
					System.debug('*******inserting the record************');
				
			}
			//US-1644-start
			if(modifiedDelvIns!=null){
				cartcheck.ccrz__Note__c=ModifiedDelvIns;
			}
			//US-1644-end
			// US-2434 start
			if(pickupTime!=null){
			    cartcheck.cc_oo_PickUpTime__c = pickupTime;
			}
			// Defect 3213 Fixed- To retain comments in Order info
			if(modifiedshipnotes!=Null){
			    cartcheck.ccrz__Note__c=modifiedshipnotes;
			}
			if(shippingMethodOptions!=Null){
			    cartcheck.ccrz__ShipMethod__c = shippingMethodOptions;
			}
			if(timeZone!=Null){
			    cartcheck.cc_oo_TimeZone__c = timeZone;
			}
			// US-2434 end
			update cartcheck;
			
			
		}
		catch (Exception ex)
            {
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'PurchaseOrderNumber');
            }
        finally
        {
        	
            ccrz.ccLog.close(resp);
        }
        return resp;
	}
	
	@RemoteAction
	global static ccrz.cc_RemoteActionResult isPORequired(final ccrz.cc_RemoteActionContext ctx,string shipToId)
	{	
		ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
            Boolean isPORequired = false;
            Map<String,Object> shippingDetails=new Map<String,Object>(); 
            String deliveryInstruction;
		try
		{
		 	//US-1644-Start
		 	List<Account> act=[select AccountNumber,BillTo_Account__c,BillTo_Account__r.cc_oo_IsPORequired__c,cc_oo_IsPORequired__c,Delivery_Instruction_1__c,Delivery_Instruction_2__c from Account where accountNumber = : shipToId];
		   	if(act.size() > 0){
		   		if(act[0].BillTo_Account__c!=null && act[0].BillTo_Account__r.cc_oo_IsPORequired__c==true){
					isPORequired=true;
		   		}else if(act[0].cc_oo_IsPORequired__c){
		   			isPORequired=true;
		   		}
			   	shippingDetails.put('isPORequired',isPORequired);
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
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'isPORequired');
            }
        return resp;
	}
	
	/***************************************************************************************************************************************
      Method Name : PurchaseOrderNumberCheck
      Description : PurchaseOrderNuPurchaseOrderNumberCheckmber is to check the po number in cart
      Parameter   : cartId :cartId is encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-513 - to check the purchase order at checkout shipping
                    
      *************************************************************************************************************************************/
	
	@RemoteAction
	global static ccrz.cc_RemoteActionResult PurchaseOrderNumberCheck(final ccrz.cc_RemoteActionContext ctx,string cartid)
	{	System.debug('*******in purchase method check************');
		ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            Map<String,Object> dataMap = new Map<String,Object>();
            resp.success = false;
			
		try
		{	System.debug('*******in try block of method2************');
			ccrz__E_Cart__c cartcheck=[select ccrz__PONumber__c,ccrz__Note__c,cc_oo_AmendedCart__c,(SELECT ccrz__Product__r.cc_oo_TypeOfProduct__c FROM ccrz__E_CartItems__r),cc_oo_Seller__c from ccrz__E_Cart__c  where Id =:cartid limit 1];
            String typeOfProduct=cartcheck.ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
            String sid=cartcheck.cc_oo_Seller__c;
            if(!cartcheck.cc_oo_AmendedCart__c){
            List<CC_OO_PlantCutOff__c> plantCutOffList= [SELECT cc_oo_AMPM__c,cc_oo_PlantCutoffTime__c,CC_OO_TIMEZONE__C,cc_oo_ShippingMethod__c 
                                                            FROM CC_OO_PlantCutOff__c WHERE cc_oo_ProductType__c=:typeOfProduct AND cc_oo_Seller__c=:sid];
            boolean isDelivery=true;
            boolean isPickUp=true;
            
            if(plantCutOffList.size()==1){
                if(plantCutOffList[0].cc_oo_ShippingMethod__c.equalsIgnoreCase('Delivery')){
                    isPickUp=false;
                }
                else{
                    isDelivery=false;
                }
            }
            dataMap.put('isPickUp',isPickUp);
            dataMap.put('isDelivery',isDelivery);
            
            }			
            resp.success = true;
            dataMap.put('AmendedCart',cartcheck.cc_oo_AmendedCart__c);
			if(cartcheck.ccrz__PONumber__c!=null && cartcheck.ccrz__PONumber__c!='')
			{
				dataMap.put('PONumber',cartcheck.ccrz__PONumber__c);  
			}	
			// Defect 3213 Fixed - To retain comments in Order info
            if(cartcheck.ccrz__Note__c!=null && cartcheck.ccrz__Note__c!=''){
                dataMap.put('shipNote',cartcheck.ccrz__Note__c);
               
            }
            resp.data = dataMap;	
		}
		catch (Exception ex)
            {
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'PurchaseOrderNumberCheck');
            }
        finally
        {
        	
            ccrz.ccLog.close(resp);
        }
        return resp;
	}
	
	/***************************************************************************************************************************************
      Method Name : shuffle
      Description : shuffle is to shuffle the cart
      Parameter   : cartId :cartId is encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2407 - 
                    
      *************************************************************************************************************************************/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult shuffle(final ccrz.cc_RemoteActionContext ctx,string cartid,string requestDate,string shippingMethod)
    {   ccrz.ccLog.log('*******in purchase method check************');
        ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
            Map<String,Object> dataMap= new Map<String,Object>();
	    try
	{  
           dataMap=cc_oo_HelperController.shuffleCart(cartid,requestDate,shippingMethod,true);
           if((boolean)dataMap.get('cartUpdated')){
                resp.data=dataMap;
                resp.success = true;
           }
            
        }
        catch (Exception ex)
            {
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'shuffle');
            }
        finally
        {
            
            ccrz.ccLog.close(resp);
        }
        return resp;
    }
    
    /***************************************************************************************************************************************
      Method Name : isCartUpdated
      Description : isCartUpdated is to check if the cart is getting updated
      Parameter   : cartId :cartId is encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2407 - 
                    
      *************************************************************************************************************************************/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult isCartUpdated(final ccrz.cc_RemoteActionContext ctx,string cartid,string requestDate,string shippingMethod)
    {   ccrz.ccLog.log('*******in purchase method check************');
        ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
            Map<String,Object> dataMap= new Map<String,Object>();
	    try
	{  
           dataMap=cc_oo_HelperController.isCartUpdated(cartid,requestDate,shippingMethod,true);
           if((boolean)dataMap.get('cartUpdated')){
                resp.data=dataMap;
                resp.success = true;
           }
            
        }
        catch (Exception ex)
            {
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'isCartUpdated');
            }
        finally
        {
            
            ccrz.ccLog.close(resp);
        }
        return resp;
    }
    
    /***************************************************************************************************************************************
      Method Name : getShippingDetails
      Description : to get the shipping info details
      Parameter   : cartId :cartId is encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2738 - User should not be able to place an order if its weight is more than the weight restrictions of the plant
                    
      *************************************************************************************************************************************/
	@RemoteAction
	global static ccrz.cc_RemoteActionResult getShippingDetails(final ccrz.cc_RemoteActionContext ctx,string plantId,String cartId,String shippingMethod){
		ccrz.ccLog.log('*******in getShippingDetails method************');
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        try{
            List<ccrz__E_CartItem__c> cartItemList = [select ccrz__Product__c, ccrz__Product__r.cc_oo_TypeOfProduct__c,ccrz__Product__r.Id, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c from  ccrz__E_CartItem__c where ccrz__Cart__c=:cartId];
            String productType = cartItemList[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
            Decimal aggregateCartOrderWeight = 0;
            for (ccrz__E_CartItem__c item :cartItemList){
                if(item.ccrz__Product__r.ccrz__ProductWeight__c != null)
                {
                    aggregateCartOrderWeight += ( item.ccrz__Quantity__c * item.ccrz__Product__r.ccrz__ProductWeight__c);
                }
            }
            String shipping=null;
        	if(String.isNotBlank(shippingMethod)){
        		String[] splitShippingMethod=shippingMethod.split(' - ');
        		if(splitShippingMethod.size() > 1) {
                	shipping=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                } else {
                	shipping=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                } 
        	}
        	
	        List<CC_OO_PlantCutOff__c> plantDetails = [select Id, cc_oo_Seller__c, cc_oo_FullTruckLoad__c, cc_oo_ProductType__c,cc_oo_PlantType__c,cc_oo_ShippingMethod__c from CC_OO_PlantCutOff__c where cc_oo_Seller__c=:plantId AND cc_oo_ProductType__c=:productType AND cc_oo_ShippingMethod__c=:shipping];
	        if(aggregateCartOrderWeight > plantDetails[0].cc_oo_FullTruckLoad__c){
	        	res.success = true;
	        	res.data = plantDetails[0].cc_oo_FullTruckLoad__c;
	        }
	        else{
	        	res.data = 0;
	        	res.success = false;
	        }
	        
        }catch(Exception ex){
        	cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getShippingDetails');
        }
        return res;
	}
	/***************************************************************************************************************************************
      Method Name : getPickupTime
      Description : to get the info details of the Pickup time slots
      Parameter   : cartId :cartId is encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-2434 - Dock Door API
                    
      *************************************************************************************************************************************/
	@RemoteAction
    global static ccrz.cc_RemoteActionResult getPickupTime(final ccrz.cc_RemoteActionContext ctx, string cartId){    
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        String plantName;
        String productType;
        String shipping;
        String sellerId,shipToId,customerNumber;
        boolean fromOrderInfo=false;
        Boolean status = false;
        String shippingDate;
        Date shipDate;
        res.success = false;
        Map<string, object> dataMap = new Map<string, object>();
        Map<string, List<cc_oo_PickUpTime>> mapTimeSlots = new Map<string, List<cc_oo_PickUpTime>>();
        cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean dockDoorTimeslot = new cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslotCollectionBean();
        
        try{
        
 			if(cartId!=Null){       
        		List<ccrz__E_CartItem__c> cartItems = [select ccrz__Cart__c,ccrz__Cart__r.cc_oo_Seller__r.ccrz__SellerId__c,ccrz__Cart__r.ccrz__Account__r.AccountNumber,ccrz__Cart__r.ccrz__RequestDate__c,ccrz__Cart__r.cc_oo_ShipToAccount__c,ccrz__Product__c,ccrz__Product__r.cc_oo_TypeOfProduct__c, 
                                                          ccrz__Cart__r.cc_oo_AmendedCart__c, ccrz__Cart__r.cc_oo_PickUpTime__c, ccrz__Cart__r.cc_oo_TimeZone__c from ccrz__E_CartItem__c where ccrz__Cart__c=:cartId LIMIT 1];
        		
        		plantName = cartItems[0].ccrz__Cart__r.cc_oo_Seller__r.ccrz__SellerId__c;
        		productType = cartItems[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
        		customerNumber = cartItems[0].ccrz__Cart__r.ccrz__Account__r.AccountNumber;
        		shipDate = cartItems[0].ccrz__Cart__r.ccrz__RequestDate__c;
        		//shippingDate = shipDate.format(); // defect - 3178
            	dataMap.put('shipDate', shipDate.format());
            	Boolean timeSlotAvailable=false;//US:2944
            	//OO-4900
                if(cartItems[0].ccrz__Cart__r.cc_oo_AmendedCart__c){
                    if(cartItems[0].ccrz__Cart__r.cc_oo_PickUpTime__c != null && cartItems[0].ccrz__Cart__r.cc_oo_PickUpTime__c != ''){
                        dataMap.put('amendPickUpTime', cartItems[0].ccrz__Cart__r.cc_oo_PickUpTime__c);  
                    } 

                    if(cartItems[0].ccrz__Cart__r.cc_oo_TimeZone__c != null && cartItems[0].ccrz__Cart__r.cc_oo_TimeZone__c != ''){
                        dataMap.put('amendPickUpTimeZone', cartItems[0].ccrz__Cart__r.cc_oo_TimeZone__c);  
                    } 
                }
                //OO-4900
                List<CC_OO_PlantCutOff__c> plantDetails = [select Id,cc_oo_ShippingMethod__c from CC_OO_PlantCutOff__c where cc_oo_ShippingMethod__c=:shipping LIMIT 1];
                dockDoorTimeslot = cc_oo_ServiceDockDoorCalloutController.getPickupTime(plantName,productType,customerNumber,shipDate,cartId);
                //dockDoorTimeslot=Null; // keep this line when you want jde down and time to be 8am to 5pm - US: 2944
                if(dockDoorTimeslot!=Null){
                    if(dockDoorTimeslot.timeZone != null && dockDoorTimeslot.timeZone != ''){
                        dataMap.put('timeZone', dockDoorTimeslot.timeZone);                      
                    }
                    if(dockDoorTimeslot.DockDoorTimeslotCollection != null){
                        if(dockDoorTimeslot.DockDoorTimeslotCollection.DockDoorTimeslot!=Null){
                            if(dockDoorTimeslot.DockDoorTimeslotCollection.DockDoorTimeslot.size()>0){
                                timeSlotAvailable=true;//US:2944
                                // add picklist values
                              List<cc_oo_PickUpTime> listPickUp;
	                            for(cc_oo_ServiceDockDoorCalloutController.DockDoorTimeslot slotTime: dockDoorTimeslot.DockDoorTimeslotCollection.DockDoorTimeslot){
                                  listPickUp = new List<cc_oo_PickUpTime>();
                                  cc_oo_PickUpTime timeSlot = new cc_oo_PickUpTime();
                                  timeSlot.pickUpTime = slotTime.pickupTime;
								  //OO-3151
                                  if(slotTime.isBooked == '1'){
                                      timeSlot.enabled = false;
                                  }else if(slotTime.isBooked == '0'){
                                      timeSlot.enabled = true;
                                  }
								  //OO-3151	
                                  if(slotTime.shipToNumber == customerNumber){
                                      timeSlot.enabled = true; // Defect 3954 Fixed
                                      if(mapTimeSlots.get('Reserved') == null){
                                          
                                          listPickUp.add(timeSlot);
                                          mapTimeSlots.put('Reserved',listPickUp);
                                      }else{

                                          listPickUp = mapTimeSlots.get('Reserved');
                                          listPickUp.add(timeSlot);
                                          mapTimeSlots.put('Reserved',listPickUp);
                                      }
                                  }else{
                                      if(mapTimeSlots.get('Alternate') == null){
                                          
                                          listPickUp.add(timeSlot);
                                          mapTimeSlots.put('Alternate',listPickUp);
                                      }else{

                                          listPickUp = mapTimeSlots.get('Alternate');
                                          listPickUp.add(timeSlot);
                                          mapTimeSlots.put('Alternate',listPickUp);
                                      }
                                  }
	                            }
	                            dataMap.put('IsJDEUp',true);
	                            if(mapTimeSlots.size() >0 ){
	                                dataMap.put('timeSlots', mapTimeSlots);
	                            }else{
	                                dataMap.put('timeSlots', null);
	                            }
            		        }
            		    }
                	}
        		    /*else{
        		        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Dock door is unavailable');
        		    }*/
        		}//US : 2944 - Start
        		if(timeSlotAvailable==false){
        			List<CC_OO_PlantCutOff__c> plantCutOff = [select id, cc_oo_Seller__c, cc_oo_ProductType__c, cc_oo_TimeZone__c from CC_OO_PlantCutOff__c where cc_oo_ProductType__c =: productType and cc_oo_seller__r.ccrz__SellerId__c  =: plantName and cc_oo_ShippingMethod__c= 'PICKUP'];
	                if(plantCutOff.size() >0){
	                    dataMap.put('timeZone',plantCutOff[0].cc_oo_TimeZone__c);  
	                }
                	List<cc_oo_PickUpTime> listDefaultPickUp = new List<cc_oo_PickUpTime>();
                    string [] timeSlots = Label.cc_oo_DefaultTimeSlots.split(';');
                    system.debug('timeSlots--->' + timeSlots);
                    cc_oo_PickUpTime timeSlot;
                    for (string defaulttime: timeSlots){
                    	timeSlot = new cc_oo_PickUpTime();
                        timeSlot.pickUpTime = defaulttime;
                        timeSlot.enabled = true;
                        listDefaultPickUp.add(timeSlot);
					}
					mapTimeSlots.put('Alternate',listDefaultPickUp);
                  	dataMap.put('timeSlots' ,mapTimeSlots);  
                  	dataMap.put('IsJDEUp',false);
				}//US:2944-Ends
 			}
 			res.data = dataMap;
            res.success = true;
        }
        catch(Exception ex){
        	cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getPickupTime');
        }
        return res;
	  }

    public class cc_oo_PickUpTime{
        public string pickUpTime{get; set;}
        public boolean enabled{get; set;}
    }
}