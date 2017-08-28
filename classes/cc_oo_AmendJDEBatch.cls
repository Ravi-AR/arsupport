global without sharing class cc_oo_AmendJDEBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    global List<CCRZ__E_Order__c> orderFailedToUpdateList = new List<CCRZ__E_Order__c>();
    Integer recordCount = 0;
    global String query = 'select Id,'+
							'Name,'+
							'LastModifiedDate,'+
							'ccrz__OrderStatus__c,'+ 
							'ccrz__RequestDate__c,'+
							'CreatedDate,'+
							'ccrz__ShipTo__r.Name,'+ 
							'ccrz__BillTo__r.Name,'+ 
							'cc_oo_IsJDENumberUpdate__c,'+
							'ccrz__ShipMethod__c,'+ 
							'cc_oo_OrderType__c,'+
							'cc_oo_PickUpTime__c,'+
							'cc_oo_JDEDocumentID__c,'+
							'cc_oo_IsSyncOrder__c,'+
							'cc_oo_JDEOrderNumber__c,'+
							'ccrz__Note__c,'+
							'ccrz__PONumber__c ,'+
							'ccrz__EncryptedId__c, '+
							'cc_oo_ShipToAccount__r.AccountNumber,'+
							'cc_oo_ShipToAccount__r.BillTo_Account__c,'+
							'cc_oo_ShipToAccount__r.BillTo_Flag__c,'+
							'cc_oo_ShipToAccount__r.Delivery_Instruction_1__c,'+
							'cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber,'+
							'ccrz__OriginatedCart__r.ccrz__EncryptedId__c,'+
							'ccrz__OriginatedCart__r.Id,'+
							'ccrz__OriginatedCart__r.cc_oo_AmendedCart__c,'+ 
							'ccrz__OriginatedCart__r.cc_oo_OriginalCart__c,'+
							'ccrz__OriginatedCart__r.cc_oo_OriginalCart__r.cc_oo_OriginalCart__c,'+ 
							'cc_oo_seller__r.ccrz__sellerId__c,'+
							'ccrz__Contact__r.FirstName,' +
							'ccrz__Contact__r.LastName,' + 
							'ccrz__User__c,' + 
		       				'ccrz__User__r.Email,' +  
		       				'ccrz__User__r.FederationIdentifier,' + 
		       				'CreatedBy.FederationIdentifier,' +
		       				'CreatedById,' +							
							'(select Id,'+
							    'Name,'+ 
								'ccrz__Product__c,'+ 
								'ccrz__Product__r.ccrz__SKU__c,'+
								'ccrz__Quantity__c,'+
								'ccrz__Comments__c,'+
								'ccrz__Price__c,'+
								'ccrz__UnitOfMeasure__c,'+
								'cc_oo_OriginalOrderItem__c,'+	
								'ccrz__Product__r.cc_oo_TypeOfProduct__c,'+
								'ccrz__Product__r.ccrz__LongDesc__c,'+
								'ccrz__Product__r.cc_oo_Second_Description__c,'+	
								'cc_oo_OriginalOrderItem__r.ccrz__Comments__c'+' '+
								'from ccrz__E_OrderItems__r'+ 
							 ')'+                        
							'from ccrz__E_Order__c'+ ' '+ 
							'where cc_oo_IsSyncOrder__c = FALSE and ' +
							' cc_oo_IsJDENumberUpdate__c = TRUE and ' +
							' ccrz__OriginatedCart__r.cc_oo_AmendedCart__c = TRUE' + 
							' ORDER BY CreatedDate desc';
							                    
    
     
	public cc_oo_AmendJDEBatch() {
	}

	//initate batch jobs 
    global Database.QueryLocator start(Database.BatchableContext BC){
    	system.debug('Query --->'+ query);
        return Database.getQueryLocator(query);  
    }

    //batch apex execution
    global void execute(Database.BatchableContext BC, List<CCRZ__E_Order__c> scope){
    	List<CCRZ__E_Order__c> orderList = new List<CCRZ__E_Order__c>();  

       	try{                   
            if(!scope.isEmpty()) {
            	String jdeOrderNumber;
           		String portalUser = 'ApexJob';
           		Boolean isSyncOrder;	
           		Map<id,List<ccrz__E_CartItem__c>> mapIdsOriginalCarts = new Map<id,List<ccrz__E_CartItem__c>>();
           		Map<id,List<ccrz__E_CartItem__c>> mapIdsAmendedCarts = new Map<id,List<ccrz__E_CartItem__c>>();
           		set<id> setIdsAmendedCarts = new set<Id>();

           		Map<string,cc_oo_orderDetails> mapOrders = new Map<string,cc_oo_orderDetails>();
           		cc_oo_orderDetails orderDetail;

                for(CCRZ__E_Order__c cOrder : scope) {
                	mapIdsOriginalCarts.put(cOrder.ccrz__OriginatedCart__r.cc_oo_OriginalCart__c, null);
                	mapIdsAmendedCarts.put(cOrder.ccrz__OriginatedCart__c, null);
                	orderDetail = new cc_oo_orderDetails();
                	orderDetail.order = cOrder;
                	orderDetail.oldCartId = cOrder.ccrz__OriginatedCart__r.cc_oo_OriginalCart__c;
                	orderDetail.newCartId = cOrder.ccrz__OriginatedCart__c;
                	mapOrders.put(cOrder.cc_oo_JDEOrderNumber__c, orderDetail);
				}

				//Pull old orders
				for(ccrz__E_Cart__c oldCart: [SELECT Id, (select id, cc_oo_JDEOrderNumber__c from ccrz__E_Orders__r) FROM ccrz__E_Cart__c where id IN: mapIdsOriginalCarts.keySet()]){
					if(oldCart.ccrz__E_Orders__r[0] != null){
						if(oldCart.ccrz__E_Orders__r[0].cc_oo_JDEOrderNumber__c != null && oldCart.ccrz__E_Orders__r[0].cc_oo_JDEOrderNumber__c != ''){
							if(mapOrders.get(oldCart.ccrz__E_Orders__r[0].cc_oo_JDEOrderNumber__c) != null){
								mapOrders.get(oldCart.ccrz__E_Orders__r[0].cc_oo_JDEOrderNumber__c).oldOrder = oldCart.ccrz__E_Orders__r[0];
							}
						}
					}

				}

				//Pull CartItem details from both current and Original carts
			    /*Map<id,ccrz__E_CartItem__c> mapOldCartItems = new Map<id,ccrz__E_CartItem__c>();
			    Map<id,Id> mapNewOldIds = new Map<id,Id>();
			    Map<id,ccrz__E_CartItem__c> mapNewCartItems = new Map<id,ccrz__E_CartItem__c>();
			    for(ccrz__E_CartItem__c cartItem : [select id, ccrz__Cart__c,Name, ccrz__cartItemType__c, ccrz__Comments__c, cc_oo_webLineNumber__c,cc_oo_JDELineNumber__c, cc_oo_OriginalCartItem__c, cc_oo_IsListPrice__c, cc_oo_TotalWieght__c, cc_oo_ContractPrice__c, ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c,
			                            cc_oo_ContractPrice__r.cc_oo_ContractNumber__c, cc_oo_UnitPrice__c,ccrz__Price__c, ccrz__Quantity__c, ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where ccrz__Cart__c IN: mapIdsOriginalCarts.keyset() OR ccrz__Cart__c IN: mapIdsAmendedCarts.keySet()]){

			        if(mapIdsOriginalCarts.containsKey(cartItem.ccrz__Cart__c)){
				        if(mapIdsOriginalCarts.get(cartItem.ccrz__Cart__c) == null){
				        	List<ccrz__E_CartItem__c> listItems = new List<ccrz__E_CartItem__c>();
				        	listItems.add(cartItem);
				        	mapIdsOriginalCarts.put(cartItem.ccrz__Cart__c,listItems);
				        }else{
				        	List<ccrz__E_CartItem__c> listItems = mapIdsOriginalCarts.get(cartItem.ccrz__Cart__c);
				        	listItems.add(cartItem);
				        	mapIdsOriginalCarts.put(cartItem.ccrz__Cart__c,listItems);
				        }
			    	}else{
			    		mapNewOldIds.put(cartItem.Id, cartItem.cc_oo_OriginalCartItem__c);
			    		if(mapIdsAmendedCarts.get(cartItem.ccrz__Cart__c) == null){
				        	List<ccrz__E_CartItem__c> listItems = new List<ccrz__E_CartItem__c>();
				        	listItems.add(cartItem);
				        	mapIdsAmendedCarts.put(cartItem.ccrz__Cart__c,listItems);
				        }else{
				        	List<ccrz__E_CartItem__c> listItems = mapIdsAmendedCarts.get(cartItem.ccrz__Cart__c);
				        	listItems.add(cartItem);
				        	mapIdsAmendedCarts.put(cartItem.ccrz__Cart__c,listItems);
				        }
			    	}
			    }

			    //Push the cart items to the bean object
			    for(cc_oo_orderDetails ordDet: mapOrders.values()){
			    	if(mapIdsOriginalCarts.get(ordDet.oldCartId) != null){
			    		ordDet.oldCartItems = mapIdsOriginalCarts.get(ordDet.oldCartId);
			    	}else if(mapIdsAmendedCarts.get(ordDet.oldCartId) != null){
			    		ordDet.currentCartItems = mapIdsAmendedCarts.get(ordDet.oldCartId);
			    	}
			    }*/
			    

			    //Make the callouts for Amend
			    CCRZ__E_Order__c cOrder;
			    for(string cOrderNumber : mapOrders.keySet()) {
			    	cc_oo_orderDetails orderDet = mapOrders.get(cOrderNumber);
                	cc_oo_JDEModifyOrderRequest modifyReq = cc_oo_BatchHelper.createModifyOrderRequest(orderDet.order, orderDet.order.ccrz__E_OrderItems__r, cOrderNumber, orderDet.newCartId, orderDet.oldCartId);
        			boolean amendStatus = cc_oo_BatchHelper.modifyOrder(modifyReq,cOrderNumber);
        			cOrder = orderDet.order;
	        		if(amendStatus){
	                	cOrder.cc_oo_IsSyncOrder__c = true;	                
	                	orderList.add(cOrder); 
	                	system.debug(' Following order is added to list for Order update ===========> ' + cOrder.id);                      	
	                }else {
	                	system.debug(' This JDE Order number is not updated ===========> ' + cOrderNumber);
	                	system.debug(' Following order is NOT ADDED to list for Order update ===========> ' + cOrder.id); 
	                	orderFailedToUpdateList.add(cOrder);
	                }
            	}
        	}	
       
		}catch(Exception ex){

		}finally {
       		//Commit any successful work that is communicated to JDE - 
       		System.debug('orderList------>' + orderList);
       		List<Database.UpsertResult> srList = Database.upsert(orderList, false);
       		for (Database.UpsertResult sr : srList) {
			    if (sr.isSuccess()) {
			        // Operation was successful, so get the ID of the record that was processed
			        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    recordCount++;
			    }
			    else {
			        // Operation failed, so get all errors                
			        for(Database.Error err : sr.getErrors()) {				        	
			            System.debug('The following error has occurred.');                    
			            System.debug(err.getStatusCode() + ': ' + err.getMessage());
			            System.debug('Account fields that affected this error: ' + err.getFields());
			        }
			    }
			}
	    }

	}


	//finish batch jobs
    global void finish(Database.BatchableContext BC){
    	// Get the ID of the AsyncApexJob representing this batch job
	    // from Database.BatchableContext.
	    // Query the AsyncApexJob object to retrieve the current job's information.
	   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
	      					TotalJobItems, CreatedBy.Email
	      					FROM AsyncApexJob WHERE Id = :BC.getJobId()];
	     
	   // Send an email to the Apex job's submitter notifying of job completion.
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {a.CreatedBy.Email};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject('Process Sync Order to JDE Job' + a.Status);
  		string bodyText =''; 
  		bodyText = 'The batch Apex job cc_oo_SyncJDEBatch processed ' + a.TotalJobItems +
   			' batches with '+ a.NumberOfErrors + ' failures. \n';	   
	   
		bodyText = bodyText + 'Number or Records processed :' + recordCount + '\n';		   
	   
	   if(orderFailedToUpdateList.isEmpty()==false){
		   	bodyText = bodyText + 'Following Orders were not processed \n';		   
	   }
	   for(CCRZ__E_Order__c failedOrders: orderFailedToUpdateList){
	   	 
	   	bodyText = bodyText +'\n' + 'Web Order Id : ' + failedOrders.Name +' Salesforce Id : '+ failedOrders.id + ' \n';
	   }
	   mail.setPlainTextBody(bodyText);
	   
	   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

	class cc_oo_orderDetails{
		public Id oldCartId{get;set;}
		public Id newCartId{get;set;}
		public CCRZ__E_Order__c order{get; set;}
		//public List<ccrz__E_CartItem__c> oldCartItems{get; set;}
		//public List<ccrz__E_CartItem__c> currentCartItems{get; set;}
		public CCRZ__E_Order__c oldOrder{get; set;}
	}
}