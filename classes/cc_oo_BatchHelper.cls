public  class cc_oo_BatchHelper {
	/*
	*This class is provides helper methods for SynJDEBatch Order
	*/
    
    /***************************************************************************************************************************************
      Method Name : syncOrderToJDE
      Description : syncOrderToJDE is to sync the JDE with the SFDC Order detail
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : Boolean.
                    
      *************************************************************************************************************************************/
    public static Boolean syncOrderToJDE(ccrz__E_Order__c unSynchedOrder, List<ccrz__E_OrderItem__c> orderItems, String jdeOrderNumber, string portalUser) {             
        //we could create a list of Orders that can be sent to API and List response. 
        Boolean response = false;
        cc_oo_JDESyncOrderRequest syncReq = createRequest(unSynchedOrder,orderItems, jdeOrderNumber, portalUser);
        //TODO: pass Bulk Request to API
        //which means update cc_oo_ServiceSyncOrder - to take collection       
	        try{
	        	system.debug('===========> Calling cc_oo_ServiceSyncOrderCallOut.syncOrder Service *********  ');
	        	cc_oo_serviceResponse resp = cc_oo_ServiceSyncOrderCallOut.syncOrder(syncReq);
	        	cc_oo_JDESyncOrderResponse jdeResponse = null;
	        	String stringResp='';
		        if(resp != null && resp.response != null) {
		        	stringResp = resp.response.getBody();
		        	if(String.isNotBlank(stringResp)) {
		        		jdeResponse = cc_oo_JDESyncOrderResponse.parse(stringResp);
		        	}
	            }
	        	//System.debug('Piyali JDE' + resp);
		        //string resp='sucess';
		        if(jdeResponse != null && jdeResponse.status == 'success'){
		           response = true;
		        }else if(resp != null && String.isNotBlank(resp.errorMsg)){
		        	response = false;
		        } else {
		        	response = false;
		        }
	        }catch (Exception ex){
	        	throw ex;
	        }        
        
        return response;
   }
   
  /***************************************************************************************************************************************
      Method Name : createRequest
      Description : createRequest is to create the request structure for the sync order API
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : cc_oo_JDESyncOrderRequest - Order request structure.
                    
      *************************************************************************************************************************************/
    private static cc_oo_JDESyncOrderRequest createRequest(ccrz__E_Order__c orders, List<ccrz__E_OrderItem__c> orderItems, String jdeOrderNumber
    														, string portalUser) {
    															
		cc_oo_JDESyncOrderRequest syncReq = new cc_oo_JDESyncOrderRequest();
    	try{
    		
    	
		       List<ccrz__E_Cart__c> primarycart = [SELECT ccrz__EncryptedId__c,ccrz__CartStatus__c, ccrz__Contact__r.FirstName, ccrz__Contact__r.LastName, ccrz__User__c,
		       												ccrz__User__r.Email, ccrz__User__r.FederationIdentifier,CreatedBy.FederationIdentifier,CreatedById,
		                									(SELECT Id, ccrz__SubAmount__c, ccrz__Price__c, ccrz__Quantity__c,cc_oo_webLineNumber__c, 
		                									ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c
		                									,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,ccrz__Comments__c,ccrz__UnitOfMeasure__c
		                									, cc_oo_UnitPrice__c, cc_oo_ContractPrice__r.cc_oo_ContractNumber__c FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c 
		                									WHERE Id =:orders.ccrz__OriginatedCart__c LIMIT 1]; 
		        string dealuserFederationIdentifier;
		        string dealuserEmail;
		        string dealusercontactFirstName, dealerusercontactLastName,csruserfederationIdentifier;
		        if(primarycart[0] != null){						
					dealuserFederationIdentifier = primarycart[0].ccrz__User__r.FederationIdentifier;
					dealuserEmail = primarycart[0].ccrz__User__r.Email;
					dealusercontactFirstName = primarycart[0].ccrz__Contact__r.FirstName;
					dealerusercontactLastName = primarycart[0].ccrz__Contact__r.LastName;
					if(primarycart[0].CreatedById != primarycart[0].ccrz__User__c){
						csruserfederationIdentifier = primarycart[0].CreatedBy.FederationIdentifier;
					}
		       	}
		        //Get user's FedertionID
		        User csruser = new User();
		        User dealerUser = new User(); 
		        /* --- probably not relevent in batch context. 
		        if(portalUser != 'ApexJob'){
		        	Id contactId = ccrz.cc_CallContext.currContact.Id;
		        	dealerUser = [select id, FederationIdentifier,Email from User where contactId =: contactId];
		        }
		        //Id contactId = ccrz.cc_CallContext.currContact.Id;
		        //dealerUser = [select id, FederationIdentifier,Email from User where contactId =: contactId];
		        if(portalUser != null){
		            csruser = [select id, FederationIdentifier from User where Id =: UserInfo.getUserId()];
		        }
		        */
		        
		        cc_oo_JDESyncOrderRequest.DocumentID documentId = new cc_oo_JDESyncOrderRequest.DocumentID();
		        documentId.replacetokentypeCode = 'batchNumber';
		        documentId.replaceDollar = String.valueOf(orders.Name);
		        
		        cc_oo_JDESyncOrderRequest.DocumentID documentIdBatch = new cc_oo_JDESyncOrderRequest.DocumentID();
		        documentIdBatch.replacetokentypeCode = 'docNumber';
		        documentIdBatch.replaceDollar = String.valueOf(orders.cc_oo_JDEDocumentID__c);
		        
		        cc_oo_JDESyncOrderRequest.DocumentID documentIdPONumber = new cc_oo_JDESyncOrderRequest.DocumentID();
		        documentIdPONumber.replacetokentypeCode = 'customerPONumber';
		        if(String.isNotBlank(orders.ccrz__PONumber__c)) {
		        	documentIdPONumber.replaceDollar = String.valueOf(orders.ccrz__PONumber__c);
		        } else {
		        	documentIdPONumber.replaceDollar = '';
		        }
		        
		        
		        List<cc_oo_JDESyncOrderRequest.DocumentID> documentIdList = new List<cc_oo_JDESyncOrderRequest.DocumentID>();
		        documentIdList.add(documentId);
		        documentIdList.add(documentIdBatch);
		        documentIdList.add(documentIdPONumber);
		        
		        cc_oo_JDESyncOrderRequest.DocumentIDSet finaldocumentId = new cc_oo_JDESyncOrderRequest.DocumentIDSet();
		        finaldocumentId.ID = documentIdList;
		        
		        List<cc_oo_JDESyncOrderRequest.DocumentIDSet> finaldocumentIdList = new List<cc_oo_JDESyncOrderRequest.DocumentIDSet>();
		        finaldocumentIdList.add(finaldocumentId);
		    
		        /*cc_oo_JDESyncOrderRequest.EffectiveTimePeriod effectiveTimePeriod = new cc_oo_JDESyncOrderRequest.EffectiveTimePeriod();
		        effectiveTimePeriod.StartDateTime = String.valueOf(orders.CreatedDate.date());*/ // Not required as part of Sync Order API
		        
		        cc_oo_JDESyncOrderRequest.Status status = new cc_oo_JDESyncOrderRequest.Status();
		        status.Description = orders.ccrz__Note__c;//'1017190823';
		        //status.EffectiveTimePeriod = effectiveTimePeriod; // Not required as part of Sync Order API
		        
		        cc_oo_JDESyncOrderRequest.PersonName personName = new cc_oo_JDESyncOrderRequest.PersonName();
		        if(dealuserFederationIdentifier != null){
		            personName.FormattedName = dealuserFederationIdentifier;//dealerUser.FederationIdentifier;//userInfo.getFirstName() + ' ' + userInfo.getLastName();
		        }
		        
		        List<cc_oo_JDESyncOrderRequest.PersonName> personNameList = new List<cc_oo_JDESyncOrderRequest.PersonName>();
		        personNameList.add(personName);
		        
		        cc_oo_JDESyncOrderRequest.Contact contact = new cc_oo_JDESyncOrderRequest.Contact();
		        contact.PersonName = personNameList;
		        
		        List<cc_oo_JDESyncOrderRequest.Contact> contactList = new List<cc_oo_JDESyncOrderRequest.Contact>();
		        contactList.add(contact);
		        
		        cc_oo_JDESyncOrderRequest.LocationCustomer locationCustomer = new cc_oo_JDESyncOrderRequest.LocationCustomer();
		        locationCustomer.Contact = contactList;
		        
		        List<cc_oo_JDESyncOrderRequest.LocationCustomer> locationCustomerList = new List<cc_oo_JDESyncOrderRequest.LocationCustomer>();
		        locationCustomerList.add(locationCustomer);
		        
		        cc_oo_JDESyncOrderRequest.CustomerParty customerParty = new cc_oo_JDESyncOrderRequest.CustomerParty();
		        customerParty.Location = locationCustomerList;
		        
		        //Ship To Party Details - Starts
		        cc_oo_JDESyncOrderRequest.ShipToParty shipToReq = new cc_oo_JDESyncOrderRequest.ShipToParty();
		        //List<String> IDList = new List<String>();
		        //IDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
		        
		        /*cc_oo_JDESyncOrderRequest.Location locationReq = new cc_oo_JDESyncOrderRequest.Location();
		        locationReq.ID = IDList;
		        List<cc_oo_JDESyncOrderRequest.Location> locationList = new List<cc_oo_JDESyncOrderRequest.Location>();
		        locationList.add(locationReq);*/
		        
		        shipToReq.ID = String.valueOf(orders.cc_oo_ShipToAccount__r.AccountNumber);//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};
		        //shipToReq.location = locationList;
		        //Ship To Party Details - Ends
		
		        cc_oo_JDESyncOrderRequest.BillToParty billToReq = new cc_oo_JDESyncOrderRequest.BillToParty();
		        List<String> BillIDList = new List<String>();
		        if(orders.cc_oo_ShipToAccount__r.BillTo_Flag__c){
		        	BillIDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
		        } else {
		        	BillIDList.add(orders.cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber);
		        }       
		        
		        cc_oo_JDESyncOrderRequest.BillToLocation billLocationReq = new cc_oo_JDESyncOrderRequest.BillToLocation();
		        billLocationReq.Note = new List<string>{ dealuserEmail + ' | ' + dealusercontactFirstName + ' ' + dealerusercontactLastName }; //BillIDList;
		        List<cc_oo_JDESyncOrderRequest.BillToLocation> billLocationList = new List<cc_oo_JDESyncOrderRequest.BillToLocation>();
		        billLocationList.add(billLocationReq);
		        
		        billToReq.ID = BillIDList;//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};//BillIDList;
		        billToReq.Location = billLocationList;
		        
		        //Shipping Method - starts
		        cc_oo_JDESyncOrderRequest.TransportationTerm transportationTerm = new cc_oo_JDESyncOrderRequest.TransportationTerm();
		        if(orders.ccrz__ShipMethod__c != null && orders.ccrz__ShipMethod__c != '') {
		            if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Delivery').Value__c)){
		                transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('DeliveryFreigtCode').Value__c;
		                transportationTerm.FreightTermCode = 'M3';
		            }else if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Pickup').Value__c)){
		                transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('PickupFreigtCode').Value__c;
		                transportationTerm.FreightTermCode = 'M1';
		            }
		        }//Shipping Method - ends
		        
		        List<cc_oo_JDESyncOrderRequest.TransportationTerm> transportationTermList = new List<cc_oo_JDESyncOrderRequest.TransportationTerm>(); 
		        transportationTermList.add(transportationTerm); 
		        
		        //Buyer Part details
		        /*List<String> buyerPartyIDList = new List<String>();
		        if(csruser.FederationIdentifier != null && portalUser != null && portalUser != ''){
		            buyerPartyIDList.add(csruser.FederationIdentifier);
		        }*/
		        
		        cc_oo_JDESyncOrderRequest.BuyerParty buyerParty = new cc_oo_JDESyncOrderRequest.BuyerParty(); 
		        if(csruserfederationIdentifier != null){
		            buyerParty.ID = csruserfederationIdentifier;
		        }   
		        
		        //Ship-From Party Details - Starts
		        //List<string> listShipFrom = new List<string>();
		        //listShipFrom.add(orders.cc_oo_Seller__r.ccrz__SellerId__c);
		        cc_oo_JDESyncOrderRequest.ShipFromParty shipFromParty = new cc_oo_JDESyncOrderRequest.ShipFromParty(); 
		        ShipFromParty.ID = new List<String>{LoLSettings__c.getValues('JDEShipFromPartyId').value__c};//listShipFrom;//OO-3959
		
		        cc_oo_JDESyncOrderRequest.Location locationReqShipFrom = new cc_oo_JDESyncOrderRequest.Location();
		        locationReqShipFrom.ID = String.valueOf(orders.cc_oo_Seller__r.ccrz__SellerId__c);
		        List<cc_oo_JDESyncOrderRequest.Location> locationListShipFrom = new List<cc_oo_JDESyncOrderRequest.Location>();
		        locationListShipFrom.add(locationReqShipFrom);
		        ShipFromParty.Location = locationListShipFrom;
		        
		        List<cc_oo_JDESyncOrderRequest.ShipFromParty> shipFromPartyList = new List<cc_oo_JDESyncOrderRequest.ShipFromParty>();
		        shipFromPartyList.add(shipFromParty);
		        //Ship-From Party Details - Ends
		
		        cc_oo_JDESyncOrderRequest.SalesOrderReference salesOrderReference = new cc_oo_JDESyncOrderRequest.SalesOrderReference(); 
		        salesOrderReference.ID = new List<string>{jdeOrderNumber};
		    
		        cc_oo_JDESyncOrderRequest.PurchaseOrderHeader purchaseHeaderReq = new cc_oo_JDESyncOrderRequest.PurchaseOrderHeader();
		        purchaseHeaderReq.ID = jdeOrderNumber;
		        purchaseHeaderReq.DocumentIDSet = finaldocumentIdList;
		        purchaseHeaderReq.LastModificationDateTime = String.valueOf(orders.LastModifiedDate.Date());
		       
		        purchaseHeaderReq.Description = String.valueOf(orderItems[0].ccrz__Product__r.cc_oo_TypeOfProduct__c).toUpperCase();
		        purchaseHeaderReq.Status = status;
		        purchaseHeaderReq.CustomerParty = customerParty;
		        purchaseHeaderReq.ShipToParty = shipToReq;
		        purchaseHeaderReq.BillToParty = billToReq;
		        purchaseHeaderReq.TransportationTerm = transportationTermList;
		        if(String.isNotBlank(orders.cc_oo_PickUpTime__c) && orders.cc_oo_PickUpTime__c != '{}') {
		        	purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + orders.cc_oo_PickUpTime__c;
		        } else {
		        	String pickUpTime = '00:00';
		        	purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + pickUpTime;
		        }
		        
		        purchaseHeaderReq.PaymentMethodCode = String.valueOf(orders.ccrz__PONumber__c);
		        purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c;//'ShippingInstructions Junemonth 1 WAREHOUS';
		        purchaseHeaderReq.OrderDateTime = String.valueOf(orders.CreatedDate);
		        purchaseHeaderReq.Note = orders.ccrz__Note__c;
		        purchaseHeaderReq.BuyerParty = buyerParty;
		        purchaseHeaderReq.ShipFromParty = shipFromPartyList;
		        purchaseHeaderReq.SalesOrderReference = salesOrderReference;
		        //purchaseHeaderReq.PickUpTime = String.valueOf(orders.cc_oo_PickUpTime__c);//US:1973
		        
		        List<cc_oo_JDESyncOrderRequest.PurchaseOrderLine> purchaseLineList = new List<cc_oo_JDESyncOrderRequest.PurchaseOrderLine>();
		        
		        for(ccrz__E_CartItem__c orderItem : primarycart[0].ccrz__E_CartItems__r){ 
		            cc_oo_JDESyncOrderRequest.PurchaseOrderLine purchaseLineReq = new cc_oo_JDESyncOrderRequest.PurchaseOrderLine();
		            purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_webLineNumber__c);
		            
		            cc_oo_JDESyncOrderRequest.Item itemReq = new cc_oo_JDESyncOrderRequest.Item();
		            itemReq.ID = orderItem.ccrz__Product__r.ccrz__SKU__c;//orderItem.Name;
		            itemReq.Note = orderItem.ccrz__Comments__c;
		            
		            List<cc_oo_JDESyncOrderRequest.Item> itemList = new List<cc_oo_JDESyncOrderRequest.Item>();
		            itemList.add(itemReq);
		            
		            purchaseLineReq.item = itemList;
		            
		            cc_oo_JDESyncOrderRequest.Quantity quantityref = new cc_oo_JDESyncOrderRequest.Quantity();
		            quantityref.replacetokenunitCode = orderItem.ccrz__UnitOfMeasure__c;
		            quantityref.replaceDollar = String.valueOf(orderItem.ccrz__Quantity__c);
		            
		            List<cc_oo_JDESyncOrderRequest.Quantity> quantityList = new List<cc_oo_JDESyncOrderRequest.Quantity>();
		            quantityList.add(quantityref);           
		            purchaseLineReq.quantity = quantityList;
		            
		            cc_oo_JDESyncOrderRequest.UnitPrice unitPriceReq = new cc_oo_JDESyncOrderRequest.UnitPrice();
		            //unitPriceReq.ID = orderItem.ccrz__UnitOfMeasure__c;
		            unitPriceReq.chargeAmount = String.valueOf(orderItem.ccrz__Price__c);
		            purchaseLineReq.unitPrice = unitPriceReq;
		            
		            cc_oo_JDESyncOrderRequest.ContractReference contractReferenceReq = new cc_oo_JDESyncOrderRequest.ContractReference();
		            contractReferenceReq.ID = String.valueOf(orderItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
		            purchaseLineReq.contractReference = contractReferenceReq;
		            
		            cc_oo_JDESyncOrderRequest.AmountDiscount amountDiscountReq = new cc_oo_JDESyncOrderRequest.AmountDiscount();
		            List<String> idAmountList = new List<String>();
		            amountDiscountReq.ID = idAmountList ;
		            amountDiscountReq.percentage = '';
		            amountDiscountReq.description = idAmountList ;
		            
		            cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine purchaseOrderSublineReq = new cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine();
		            purchaseOrderSublineReq.amountDiscount = amountDiscountReq;
		            
		            List<cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine> purchaseSubLineList = new List<cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine>();
		            purchaseSubLineList.add(purchaseOrderSublineReq);
		            purchaseLineReq.purchaseOrderSubLine = purchaseSubLineList;         
		            purchaseLineList.add(purchaseLineReq);
		        }
		        
		        cc_oo_JDESyncOrderRequest.PurchaseOrder purchaseOrderReq = new cc_oo_JDESyncOrderRequest.PurchaseOrder();
		        purchaseOrderReq.replacetokentypeCode = 'S6';
		        purchaseOrderReq.purchaseOrderHeader = purchaseHeaderReq;
		        purchaseOrderReq.purchaseOrderLine = purchaseLineList;
		         
		        /*List<cc_oo_JDESyncOrderRequest.PurchaseOrder> purchaseOrderList = new List<cc_oo_JDESyncOrderRequest.PurchaseOrder>();
		        purchaseOrderList.add(purchaseOrderReq);*/
		        
		        cc_oo_JDESyncOrderRequest.DataArea dataAreaReq = new cc_oo_JDESyncOrderRequest.DataArea();
		        dataAreaReq.PurchaseOrder = purchaseOrderReq;
		        
		        //cc_oo_JDESyncOrderRequest syncReq = new cc_oo_JDESyncOrderRequest();
		        syncReq.DataArea = dataAreaReq;
        }
    	catch (Exception ex){
    		cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();           
            errorLog.cc_oo_Description__c 	= 'Exception type caught: ' + ex.getTypeName() + ' '
            									 + 'Message: ' 			+ ex.getMessage() + ' '
        									 	 + 'Cause: ' 			+ ex.getCause() + ' ' 
        									 	 + 'Stack trace: ' 		+ ex.getStackTraceString();
			errorLog.cc_oo_ApexClass__c 	= 'cc_oo_HelperController';
			errorLog.cc_oo_MethodName__c 	= 'createRequest';
    	}
        return syncReq;
    } 
    
    public static cc_oo_JDEModifyOrderRequest createModifyOrderRequest(ccrz__E_Order__c orders, List<ccrz__E_OrderItem__c> orderItems, String jdeOrderNumber, Id curentCartId, Id originalCartId) {

        //Pull CartItem details from both current and Original carts
        Map<id,ccrz__E_CartItem__c> mapOldCartItems = new Map<id,ccrz__E_CartItem__c>();
        Map<id,Id> mapNewOldIds = new Map<id,Id>();
        Map<id,ccrz__E_CartItem__c> mapNewCartItems = new Map<id,ccrz__E_CartItem__c>();
        for(ccrz__E_CartItem__c cartItem : [select id, ccrz__Cart__c,Name, ccrz__cartItemType__c, ccrz__Comments__c, cc_oo_webLineNumber__c,cc_oo_JDELineNumber__c, cc_oo_OriginalCartItem__c, cc_oo_IsListPrice__c, cc_oo_TotalWieght__c, cc_oo_ContractPrice__c, ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c,
                                cc_oo_ContractPrice__r.cc_oo_ContractNumber__c, cc_oo_UnitPrice__c,ccrz__Price__c, ccrz__Quantity__c, ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where ccrz__Cart__c =: curentCartId OR ccrz__Cart__c =: originalCartId]){
            if(originalCartId == cartItem.ccrz__Cart__c){
                mapOldCartItems.put(cartItem.Id, cartItem);
            }else if(curentCartId == cartItem.ccrz__Cart__c){
                mapNewCartItems.put(cartItem.Id, cartItem);
                mapNewOldIds.put(cartItem.Id, cartItem.cc_oo_OriginalCartItem__c);
            }
        }
        //Pull CartItem details from both current and Original carts - Ends     
        //Get user's FedertionID
        string dealuserFederationIdentifier;
        string dealuserEmail;
        string dealusercontactFirstName, dealerusercontactLastName,csruserfederationIdentifier;
        if(orders != null){                     
            dealuserFederationIdentifier = orders.ccrz__User__r.FederationIdentifier;
            dealuserEmail = orders.ccrz__User__r.FederationIdentifier;
            dealusercontactFirstName = orders.ccrz__Contact__r.FirstName;
            dealerusercontactLastName = orders.ccrz__Contact__r.LastName;
            if(orders.CreatedById != orders.ccrz__User__c){
                csruserfederationIdentifier = orders.CreatedBy.FederationIdentifier;
            }
        }

        User csruser = new User();
        User dealerUser = new User();       

        // Document Set Id
        cc_oo_JDEModifyOrderRequest.DocumentID documentId = new cc_oo_JDEModifyOrderRequest.DocumentID();
        documentId.replacetokentypeCode = 'batchNumber';
        documentId.replaceDollar = String.valueOf(orders.Name);
        
        cc_oo_JDEModifyOrderRequest.DocumentID documentIdBatch = new cc_oo_JDEModifyOrderRequest.DocumentID();
        documentIdBatch.replacetokentypeCode = 'docNumber';
        documentIdBatch.replaceDollar = String.valueOf(orders.cc_oo_JDEDocumentID__c);
        
        cc_oo_JDEModifyOrderRequest.DocumentID documentIdPONumber = new cc_oo_JDEModifyOrderRequest.DocumentID();
        documentIdPONumber.replacetokentypeCode = 'customerPONumber';
        if(String.isNotBlank(orders.ccrz__PONumber__c)) {
            documentIdPONumber.replaceDollar = String.valueOf(orders.ccrz__PONumber__c);
        } else {
            documentIdPONumber.replaceDollar = '';
        }

        List<cc_oo_JDEModifyOrderRequest.DocumentID> documentIdList = new List<cc_oo_JDEModifyOrderRequest.DocumentID>();
        documentIdList.add(documentId);
        documentIdList.add(documentIdBatch);
        documentIdList.add(documentIdPONumber);
        
        cc_oo_JDEModifyOrderRequest.DocumentIDSet finaldocumentId = new cc_oo_JDEModifyOrderRequest.DocumentIDSet();
        finaldocumentId.ID = documentIdList;
        
        List<cc_oo_JDEModifyOrderRequest.DocumentIDSet> finaldocumentIdList = new List<cc_oo_JDEModifyOrderRequest.DocumentIDSet>();
        finaldocumentIdList.add(finaldocumentId);


        //cc_oo_JDEModifyOrderRequest.Status status = new cc_oo_JDEModifyOrderRequest.Status();
        //status.Description = orders.ccrz__Note__c;//'1017190823';
        //status.EffectiveTimePeriod = effectiveTimePeriod; // Not required as part of Sync Order API
        
        cc_oo_JDEModifyOrderRequest.PersonName personName = new cc_oo_JDEModifyOrderRequest.PersonName();
        if(dealuserFederationIdentifier != null){
            personName.FormattedName = dealuserFederationIdentifier;//userInfo.getFirstName() + ' ' + userInfo.getLastName();
        }
        
        List<cc_oo_JDEModifyOrderRequest.PersonName> personNameList = new List<cc_oo_JDEModifyOrderRequest.PersonName>();
        personNameList.add(personName);
        
        cc_oo_JDEModifyOrderRequest.Contact contact = new cc_oo_JDEModifyOrderRequest.Contact();
        contact.PersonName = personNameList;
        
        List<cc_oo_JDEModifyOrderRequest.Contact> contactList = new List<cc_oo_JDEModifyOrderRequest.Contact>();
        contactList.add(contact);
        
        cc_oo_JDEModifyOrderRequest.LocationCustomer locationCustomer = new cc_oo_JDEModifyOrderRequest.LocationCustomer();
        locationCustomer.Contact = contactList;
        
        List<cc_oo_JDEModifyOrderRequest.LocationCustomer> locationCustomerList = new List<cc_oo_JDEModifyOrderRequest.LocationCustomer>();
        locationCustomerList.add(locationCustomer);
        
        cc_oo_JDEModifyOrderRequest.CustomerParty customerParty = new cc_oo_JDEModifyOrderRequest.CustomerParty();
        customerParty.Location = locationCustomerList;
        
        //Ship To Party Details - Starts
        cc_oo_JDEModifyOrderRequest.ShipToParty shipToReq = new cc_oo_JDEModifyOrderRequest.ShipToParty();
        //List<String> IDList = new List<String>();
        //IDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);      
        
        shipToReq.ID = String.valueOf(orders.cc_oo_ShipToAccount__r.AccountNumber);//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};
        //shipToReq.location = locationList;
        //Ship To Party Details - Ends

        cc_oo_JDEModifyOrderRequest.BillToParty billToReq = new cc_oo_JDEModifyOrderRequest.BillToParty();
        List<String> BillIDList = new List<String>();
        if(orders.cc_oo_ShipToAccount__r.BillTo_Flag__c){
            BillIDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
        } else {
            BillIDList.add(orders.cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber);
        }       
        
        cc_oo_JDEModifyOrderRequest.BillToLocation billLocationReq = new cc_oo_JDEModifyOrderRequest.BillToLocation();
        billLocationReq.Note = new List<string>{ dealuserEmail + ' | ' + dealusercontactFirstName + ' ' + dealerusercontactLastName };//OO-4466 //BillIDList;
        List<cc_oo_JDEModifyOrderRequest.BillToLocation> billLocationList = new List<cc_oo_JDEModifyOrderRequest.BillToLocation>();
        billLocationList.add(billLocationReq);
        
        billToReq.ID = BillIDList;//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};//BillIDList;
        billToReq.Location = billLocationList;
        
        //Shipping Method - starts
        cc_oo_JDEModifyOrderRequest.TransportationTerm transportationTerm = new cc_oo_JDEModifyOrderRequest.TransportationTerm();
        if(orders.ccrz__ShipMethod__c != null && orders.ccrz__ShipMethod__c != '') {
            if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Delivery').Value__c)){
                transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('DeliveryFreigtCode').Value__c;
                //transportationTerm.FreightTermCode = 'M1';
            }else if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Pickup').Value__c)){
                transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('PickupFreigtCode').Value__c;
                //transportationTerm.FreightTermCode = 'M3';
            }
        }//Shipping Method - ends
        
        List<cc_oo_JDEModifyOrderRequest.TransportationTerm> transportationTermList = new List<cc_oo_JDEModifyOrderRequest.TransportationTerm>(); 
        transportationTermList.add(transportationTerm); 
        
        cc_oo_JDEModifyOrderRequest.BuyerParty buyerParty = new cc_oo_JDEModifyOrderRequest.BuyerParty(); 
        if(csruserfederationIdentifier != null){//&& portalUser != null && portalUser != ''){
            buyerParty.ID = csruserfederationIdentifier;
        }   
        
        //Ship-From Party Details - Starts
        //List<string> listShipFrom = new List<string>();
        //listShipFrom.add(orders.cc_oo_Seller__r.ccrz__SellerId__c);
        cc_oo_JDEModifyOrderRequest.ShipFromParty shipFromParty = new cc_oo_JDEModifyOrderRequest.ShipFromParty(); 
        ShipFromParty.ID = LoLSettings__c.getValues('JDEShipFromPartyId').value__c;//listShipFrom;//OO-3959

        cc_oo_JDEModifyOrderRequest.Location locationReqShipFrom = new cc_oo_JDEModifyOrderRequest.Location();
        locationReqShipFrom.ID = String.valueOf(orders.cc_oo_Seller__r.ccrz__SellerId__c);
        List<cc_oo_JDEModifyOrderRequest.Location> locationListShipFrom = new List<cc_oo_JDEModifyOrderRequest.Location>();
        locationListShipFrom.add(locationReqShipFrom);
        ShipFromParty.Location = locationListShipFrom;
        
        List<cc_oo_JDEModifyOrderRequest.ShipFromParty> shipFromPartyList = new List<cc_oo_JDEModifyOrderRequest.ShipFromParty>();
        shipFromPartyList.add(shipFromParty);
        //Ship-From Party Details - Ends

        cc_oo_JDEModifyOrderRequest.SalesOrderReference salesOrderReference = new cc_oo_JDEModifyOrderRequest.SalesOrderReference(); 
        salesOrderReference.ID = new List<string>{jdeOrderNumber};

        cc_oo_JDEModifyOrderRequest.PurchaseOrderHeader purchaseHeaderReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderHeader();
        purchaseHeaderReq.ID = jdeOrderNumber;
        purchaseHeaderReq.DocumentIDSet = finaldocumentIdList;
        purchaseHeaderReq.LastModificationDateTime = String.valueOf(orders.LastModifiedDate.Date());
        purchaseHeaderReq.Description = String.valueOf(orderItems[0].ccrz__Product__r.cc_oo_TypeOfProduct__c).toUpperCase();
        //purchaseHeaderReq.Status = status;
        purchaseHeaderReq.CustomerParty = customerParty;
        purchaseHeaderReq.ShipToParty = shipToReq;
        purchaseHeaderReq.BillToParty = billToReq;
        purchaseHeaderReq.TransportationTerm = transportationTermList;
        if(String.isNotBlank(orders.cc_oo_PickUpTime__c) && orders.cc_oo_PickUpTime__c != '{}') {
            purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + orders.cc_oo_PickUpTime__c;
        } else {
            String pickUpTime = '00:00';
            purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + pickUpTime;
        }
        
        purchaseHeaderReq.PaymentMethodCode = String.valueOf(orders.ccrz__PONumber__c);
        //string comments = '\n' + orders.ccrz__Note__c;//OO-4469
        //purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c + comments;//OO-4469
        purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c;//'ShippingInstructions Junemonth 1 WAREHOUS';
        purchaseHeaderReq.OrderDateTime = String.valueOf(orders.CreatedDate);
        purchaseHeaderReq.Note = orders.ccrz__Note__c;
        purchaseHeaderReq.BuyerParty = buyerParty;
        purchaseHeaderReq.ShipFromParty = shipFromPartyList;
        purchaseHeaderReq.SalesOrderReference = salesOrderReference;
        //purchaseHeaderReq.PickUpTime = String.valueOf(orders.cc_oo_PickUpTime__c);//US:1973
        List<cc_oo_JDEModifyOrderRequest.PurchaseOrderLine> purchaseLineList = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderLine>();
        string reasonCode = LOLSettings__c.getValues('ReasonCode').Value__c;
        set<Id> existingOldCartItems = new set<Id>();
        
        List<cc_oo_JDEModifyOrderRequest.ActionExpression> actionExpressionList = new List<cc_oo_JDEModifyOrderRequest.ActionExpression>();
        string actionExpressionDollarHeader = LOLSettings__c.getValues('JDEAmendOdrerExpHeader').Value__c;
        string actionExpressionDollarLine = LOLSettings__c.getValues('JDEAmendOdrerExpLine').Value__c;

        cc_oo_JDEModifyOrderRequest.ActionExpression actionExpressionHeader = new cc_oo_JDEModifyOrderRequest.ActionExpression(); 
        actionExpressionHeader.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderChange').value__c;
        actionExpressionHeader.replaceDollar = actionExpressionDollarHeader;
        actionExpressionList.add(actionExpressionHeader);
        Map<string,integer> mapSkuActionCode = new Map<string,integer>();//OO-5228
        Integer i = 1;
        for(ccrz__E_CartItem__c orderItem : mapNewCartItems.values()){ 

            cc_oo_JDEModifyOrderRequest.PurchaseOrderLine purchaseLineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderLine();
            //purchaseLineReq.lineNumberID = '' ;
            
            cc_oo_JDEModifyOrderRequest.Item itemReq = new cc_oo_JDEModifyOrderRequest.Item();
            itemReq.ID = orderItem.ccrz__Product__r.ccrz__SKU__c;//orderItem.Name;
            itemReq.Note = orderItem.ccrz__Comments__c;
            
            List<cc_oo_JDEModifyOrderRequest.Item> itemList = new List<cc_oo_JDEModifyOrderRequest.Item>();
            itemList.add(itemReq);
            
            purchaseLineReq.item = itemList;
            
            cc_oo_JDEModifyOrderRequest.Quantity quantityref = new cc_oo_JDEModifyOrderRequest.Quantity();
            quantityref.replacetokenunitCode = orderItem.ccrz__UnitOfMeasure__c;
            quantityref.replaceDollar = String.valueOf(orderItem.ccrz__Quantity__c);
            
            List<cc_oo_JDEModifyOrderRequest.Quantity> quantityList = new List<cc_oo_JDEModifyOrderRequest.Quantity>();
            quantityList.add(quantityref);           
            purchaseLineReq.quantity = quantityList;
            
            cc_oo_JDEModifyOrderRequest.UnitPrice unitPriceReq = new cc_oo_JDEModifyOrderRequest.UnitPrice();
            //unitPriceReq.ID = orderItem.ccrz__UnitOfMeasure__c;
            unitPriceReq.chargeAmount = String.valueOf(orderItem.ccrz__Price__c);
            purchaseLineReq.unitPrice = unitPriceReq;
            
            cc_oo_JDEModifyOrderRequest.ContractReference contractReferenceReq = new cc_oo_JDEModifyOrderRequest.ContractReference();
            contractReferenceReq.ID = String.valueOf(orderItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
            purchaseLineReq.contractReference = contractReferenceReq;
            
            cc_oo_JDEModifyOrderRequest.AmountDiscount amountDiscountReq = new cc_oo_JDEModifyOrderRequest.AmountDiscount();
            List<String> idAmountList = new List<String>();
            amountDiscountReq.ID = idAmountList ;
            amountDiscountReq.percentage = '';
            amountDiscountReq.description = idAmountList ;
            
            cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine purchaseOrderSublineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine();
            purchaseOrderSublineReq.amountDiscount = amountDiscountReq;
            
            List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine> purchaseSubLineList = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine>();
            purchaseSubLineList.add(purchaseOrderSublineReq);
            purchaseLineReq.purchaseOrderSubLine = purchaseSubLineList;         

            cc_oo_JDEModifyOrderRequest.ActionExpression actionExpression = new cc_oo_JDEModifyOrderRequest.ActionExpression();            
            //contractReferenceReq.ID = cartItem.cc_oo_ContractPrice__c;
            purchaseLineReq.contractReference = contractReferenceReq;                   
            actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderChange').value__c;//'Change';

            actionExpression.replaceDollar = actionExpressionDollarLine + '[' + i + ']';
            
            cc_oo_JDEModifyOrderRequest.Status statusLn = new cc_oo_JDEModifyOrderRequest.Status();
            if(orderItem.cc_oo_OriginalCartItem__c != null){
                if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c) != null){
                    if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c).ccrz__Quantity__c > orderItem.ccrz__Quantity__c){
                        statusLn.ReasonCode = reasonCode;
                        //actionExpression.replacetokenactionCode = 'modify';
                    }
                    /*if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c).cc_oo_IsListPrice__c != orderItem.cc_oo_IsListPrice__c){//OO-5258
                        statusLn.ReasonCode = reasonCode;
                        //actionExpression.replacetokenactionCode = 'modify';
                    }*///OO-5258
                    if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c).ccrz__Comments__c != null && orderItem.ccrz__Comments__c == null){
                        itemReq.Note = ' ';
                    }
                }
            }
            else{
                //statusLn.ReasonCode = reasonCode;
                actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderAdd').value__c;//'Add';
                if(orderItem.cc_oo_ContractPrice__c != null){//OO-5228
                    mapSkuActionCode.put(orderItem.ccrz__Product__r.ccrz__SKU__c + '_' + orderItem.cc_oo_ContractPrice__c, i);//OO-5228
                }else{
                    mapSkuActionCode.put(orderItem.ccrz__Product__r.ccrz__SKU__c, i);//OO-5228
                }
            }

            actionExpressionList.add(actionExpression);
            //purchaseLineReq.item = itemReq;
            purchaseLineReq.Status = statusLn;
            if(orderItem.cc_oo_JDELineNumber__c != null){
                purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_JDELineNumber__c);
            }else{
                purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_webLineNumber__c);
            }
            purchaseLineList.add(purchaseLineReq);
            System.debug('purchaseLineList--->' + purchaseLineList);
            existingOldCartItems.add(orderItem.cc_oo_OriginalCartItem__c);
            System.debug('purchaseLineList--->' + purchaseLineList);
            i++;
        }
        for(ccrz__E_CartItem__c orderItem : mapOldCartItems.values()){ 
            if(!existingOldCartItems.contains(orderItem.Id)){
                //OO-5228
                string key = orderItem.ccrz__Product__r.ccrz__SKU__c;
                if(orderItem.cc_oo_ContractPrice__c != null){
                    key = key + '_' + orderItem.cc_oo_ContractPrice__c;
                }
                if(mapSkuActionCode.get(key) != null){
                    
                    integer index = mapSkuActionCode.get(key);
                    system.debug('actionExpressionList[index].replacetokenactionCode--->' + actionExpressionList[index].replacetokenactionCode);
                    actionExpressionList[index].replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderChange').value__c;
                    system.debug('actionExpressionList[index].replacetokenactionCode--->' + actionExpressionList[index].replacetokenactionCode);
                }//OO-5228
                else{
                    cc_oo_JDEModifyOrderRequest.PurchaseOrderLine purchaseLineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderLine();
                    //purchaseLineReq.lineNumberID = '' ;
                    
                    cc_oo_JDEModifyOrderRequest.Item itemReq = new cc_oo_JDEModifyOrderRequest.Item();
                    itemReq.ID = orderItem.ccrz__Product__r.ccrz__SKU__c;//orderItem.Name;
                    itemReq.Note = orderItem.ccrz__Comments__c;
                    
                    List<cc_oo_JDEModifyOrderRequest.Item> itemList = new List<cc_oo_JDEModifyOrderRequest.Item>();
                    itemList.add(itemReq);
                    
                    purchaseLineReq.item = itemList;
                    
                    cc_oo_JDEModifyOrderRequest.Quantity quantityref = new cc_oo_JDEModifyOrderRequest.Quantity();
                    quantityref.replacetokenunitCode = orderItem.ccrz__UnitOfMeasure__c;
                    quantityref.replaceDollar = String.valueOf(orderItem.ccrz__Quantity__c);
                    
                    List<cc_oo_JDEModifyOrderRequest.Quantity> quantityList = new List<cc_oo_JDEModifyOrderRequest.Quantity>();
                    quantityList.add(quantityref);           
                    purchaseLineReq.quantity = quantityList;
                    
                    cc_oo_JDEModifyOrderRequest.UnitPrice unitPriceReq = new cc_oo_JDEModifyOrderRequest.UnitPrice();
                    //unitPriceReq.ID = orderItem.ccrz__UnitOfMeasure__c;
                    unitPriceReq.chargeAmount = String.valueOf(orderItem.ccrz__Price__c);
                    purchaseLineReq.unitPrice = unitPriceReq;
                    
                    cc_oo_JDEModifyOrderRequest.ContractReference contractReferenceReq = new cc_oo_JDEModifyOrderRequest.ContractReference();
                    contractReferenceReq.ID = String.valueOf(orderItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
                    purchaseLineReq.contractReference = contractReferenceReq;
                    
                    cc_oo_JDEModifyOrderRequest.AmountDiscount amountDiscountReq = new cc_oo_JDEModifyOrderRequest.AmountDiscount();
                    List<String> idAmountList = new List<String>();
                    amountDiscountReq.ID = idAmountList ;
                    amountDiscountReq.percentage = '';
                    amountDiscountReq.description = idAmountList ;
                    
                    cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine purchaseOrderSublineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine();
                    purchaseOrderSublineReq.amountDiscount = amountDiscountReq;
                    
                    List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine> purchaseSubLineList = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine>();
                    purchaseSubLineList.add(purchaseOrderSublineReq);
                    purchaseLineReq.purchaseOrderSubLine = purchaseSubLineList;         

                cc_oo_JDEModifyOrderRequest.ActionExpression actionExpression = new cc_oo_JDEModifyOrderRequest.ActionExpression();            
                //contractReferenceReq.ID = cartItem.cc_oo_ContractPrice__c;
                purchaseLineReq.contractReference = contractReferenceReq;                   
                actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderCancel').value__c;//'Cancel';

                actionExpression.replaceDollar = actionExpressionDollarLine + '[' + i + ']';
                
                cc_oo_JDEModifyOrderRequest.Status statusLn = new cc_oo_JDEModifyOrderRequest.Status();
                statusLn.ReasonCode = reasonCode;

                actionExpressionList.add(actionExpression);
                //purchaseLineReq.item = itemReq;
                purchaseLineReq.Status = statusLn;
                if(orderItem.cc_oo_JDELineNumber__c != null){
                    purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_JDELineNumber__c);
                }else{
                    purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_webLineNumber__c);
                }
                purchaseLineList.add(purchaseLineReq);
                System.debug('purchaseLineList--->' + purchaseLineList);
                existingOldCartItems.add(orderItem.cc_oo_OriginalCartItem__c);
                System.debug('purchaseLineList--->' + purchaseLineList);

                    i++;
                }
            }
        }
        
        cc_oo_JDEModifyOrderRequest.PurchaseOrder purchaseOrderReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrder();
        purchaseOrderReq.replacetokentypeCode = cc_oo_ServiceData__c.getValues('ModifyOrder').cc_oo_Type__c;
        purchaseOrderReq.purchaseOrderHeader = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderHeader>{purchaseHeaderReq};
        purchaseOrderReq.purchaseOrderLine = purchaseLineList;
        
        cc_oo_JDEModifyOrderRequest.ActionCriteria actionCriteria = new cc_oo_JDEModifyOrderRequest.ActionCriteria();
        actionCriteria.ActionExpression = actionExpressionList;
        
        List<cc_oo_JDEModifyOrderRequest.ActionCriteria> actionCriteriaList = new List<cc_oo_JDEModifyOrderRequest.ActionCriteria>();
        actionCriteriaList.add(actionCriteria);
        
        cc_oo_JDEModifyOrderRequest.Sync syncReq = new cc_oo_JDEModifyOrderRequest.Sync();
        syncReq.ActionCriteria = actionCriteriaList;
        
        cc_oo_JDEModifyOrderRequest.DataArea dataAreaReq = new cc_oo_JDEModifyOrderRequest.DataArea();
        dataAreaReq.PurchaseOrder = purchaseOrderReq;
        dataAreaReq.Sync = syncReq;
                        
        cc_oo_JDEModifyOrderRequest modifyReq = new cc_oo_JDEModifyOrderRequest();
        modifyReq.DataArea = dataAreaReq;
        
        return modifyReq;
        
    }

    public static boolean modifyOrder(cc_oo_JDEModifyOrderRequest modifyOrderReq, string JDEOrderNumber){
        try{
            string body = cc_oo_JDEModifyOrderRequest.serialize(modifyOrderReq);
            System.debug('body-->' + body);
            
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('ModifyOrder', body, JDEOrderNumber);
            
            //cc_oo_HelperController.createLog(body, 'AmendOrder', 'Request','cc_oo_ServiceModifyOrderCallOut','modifyOrder');
            //cc_oo_HelperController.createLog(resp.response.getBody(), 'AmendOrder', 'Response','cc_oo_ServiceModifyOrderCallOut','modifyOrder');
            
            if(resp != null){ 
            	if(resp.response != null) {
            		system.debug('resp.response--->' + resp.response);
	                if(resp.response.getBody() != null){ //OO-4462
	                	system.debug('resp.response.getBody()---->' + resp.response.getBody());
	                    if(resp.response.getBody().contains('"status" : "success"')){
	                        return true;
	                    }
	                }//OO-4462
            	}
            }
            return false;
        }catch(Exception ex){
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            cc_oo_HelperController.CreateErrorLog(ex,'cc_oo_BatchHelper','modifyOrder');
            return null;
        } 
    }
    
    /***************************************************************************************************************************************
      Method Name : createCancelOrderRequest
      Description : createCancelOrderRequest is to create the request structure for the Cancel order API
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : cc_oo_JDESyncOrderRequest - Order request structure.
                    
      *************************************************************************************************************************************/
     public static cc_oo_JDECancelOrderRequest createCancelOrderRequest(string jdeOrderNumber) {
        ccrz__E_Order__c orders = [select Id, Name, cc_oo_JDEDocumentID__c, cc_oo_JDEOrderNumber__c
                                                from ccrz__E_Order__c where cc_oo_JDEOrderNumber__c =: jdeOrderNumber and ccrz__OrderStatus__c != 'Amended'LIMIT 1];
        
        // Document Set Id----
        cc_oo_JDECancelOrderRequest.IDObj documentId = new cc_oo_JDECancelOrderRequest.IDObj();
        documentId.replacetokentypeCode = 'batchNumber';
        documentId.replaceDollar = String.valueOf(orders.Name);
        
        cc_oo_JDECancelOrderRequest.IDObj documentIdBatch = new cc_oo_JDECancelOrderRequest.IDObj();
        documentIdBatch.replacetokentypeCode = 'docNumber';
        
        //Cancel Order DocNumber issue - creating new DocNumber
        if(LOLSettings__c.getValues('CancelOrderDocNumber') != null){
            Integer maskNumber = Integer.valueOf(LOLSettings__c.getValues('CancelOrderDocNumber').Value__c);
            Integer finalDocNumber = maskNumber - Integer.valueOf(orders.cc_oo_JDEDocumentID__c);
            documentIdBatch.replaceDollar = String.valueOf(finalDocNumber);
        }//Cancel Order DocNumber issue - creating new DocNumber    

        List<cc_oo_JDECancelOrderRequest.IDObj> documentIdList = new List<cc_oo_JDECancelOrderRequest.IDObj>();
        documentIdList.add(documentId);
        documentIdList.add(documentIdBatch);
        
        cc_oo_JDECancelOrderRequest.DocumentIDSet finaldocumentId = new cc_oo_JDECancelOrderRequest.DocumentIDSet();
        finaldocumentId.IDObj = documentIdList;
        
        List<cc_oo_JDECancelOrderRequest.DocumentIDSet> finaldocumentIdList = new List<cc_oo_JDECancelOrderRequest.DocumentIDSet>();
        finaldocumentIdList.add(finaldocumentId);
        
        //PurchaseOrderHeader ----
        cc_oo_JDECancelOrderRequest.PurchaseOrderHeader purchaseHeaderReq = new cc_oo_JDECancelOrderRequest.PurchaseOrderHeader();
        purchaseHeaderReq.DocumentIDSet = finaldocumentIdList;

        //Exprssion ----
        List<cc_oo_JDECancelOrderRequest.ActionExpression> actionExpressionList = new List<cc_oo_JDECancelOrderRequest.ActionExpression>();
        cc_oo_JDECancelOrderRequest.ActionExpression actionExpression = new cc_oo_JDECancelOrderRequest.ActionExpression();            
        string actionExpressionDollarHeader = LOLSettings__c.getValues('JDEAmendOdrerExpHeader').Value__c;                                  
        actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderDelete').value__c;//'Cancel';
        actionExpression.replaceDollar = actionExpressionDollarHeader;
        actionExpressionList.add(actionExpression);
        cc_oo_JDECancelOrderRequest.ActionCriteria actionCriteria = new cc_oo_JDECancelOrderRequest.ActionCriteria();
        actionCriteria.ActionExpression = actionExpressionList;
        
        //Sync changes ----
        cc_oo_JDECancelOrderRequest.Sync syncReq = new cc_oo_JDECancelOrderRequest.Sync();
        syncReq.ActionCriteria = new List<cc_oo_JDECancelOrderRequest.ActionCriteria>{actionCriteria};

        //PurchaseHeader ----
        cc_oo_JDECancelOrderRequest.PurchaseOrder purchaseOrderReq = new cc_oo_JDECancelOrderRequest.PurchaseOrder();
        purchaseOrderReq.replacetokentypeCode = cc_oo_ServiceData__c.getValues('orderCancel').cc_oo_Type__c;
        purchaseOrderReq.purchaseOrderHeader = purchaseHeaderReq;
        
        cc_oo_JDECancelOrderRequest.DataArea dataAreaReq = new cc_oo_JDECancelOrderRequest.DataArea();
        dataAreaReq.PurchaseOrder = new List<cc_oo_JDECancelOrderRequest.PurchaseOrder>{purchaseOrderReq};
        dataAreaReq.Sync = syncReq;
                        
        cc_oo_JDECancelOrderRequest cancelReq = new cc_oo_JDECancelOrderRequest();
        cancelReq.DataArea = dataAreaReq;
        
        return cancelReq;
    }
    
    public static boolean cancelOrder(string JDEOrderNumber){
     
            //string body = '{"DataArea":{"PurchaseOrder":[{"op":"cancel"}]}}';//cc_oo_JDECancelRequest.serialize(cancelReq);
            //ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','body-->' + body);
			Boolean response = false;
            cc_oo_JDECancelOrderRequest req = createCancelOrderRequest(JDEOrderNumber);
            string body = cc_oo_JDECancelOrderRequest.serialize(req);
            system.debug('body-->' + body);
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('orderCancel', body, JDEOrderNumber);
            System.debug('Service order call cancel ---> ' +resp);            
			if(resp != null){
	            if(resp.response != null){
		            if(resp.response.getBody().contains('"status" : "success"')){
		                return true;
		            }
	       		}
			}
       		
            return false; 
    }
    
}