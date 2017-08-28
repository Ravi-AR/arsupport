//ClassName:cc_oo_SyncJDEBatch 
//Summary:
// 1. Communication to JDE can fail at any point, during initial Order, while Amending and Cancelling.
// 		It can faile to get, JDE OrderNumber,Fail After getting JDE Order Number. 
// 2. This batch job will sync records that failed to Synchronize with ERP system.
//  
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         01/03/2017                                     OO-517 - Sync JDE and Order Update
//-----------------------------------------------------------------------------------------------------------------------
global class cc_oo_SyncJDEBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    global List<CCRZ__E_Order__c> orderFailedToUpdateList = new List<CCRZ__E_Order__c>();
    string myVal = 'Cancelled';
    Integer recordCount =0;
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
							'cc_oo_seller__r.ccrz__sellerId__c,'+
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
							'where cc_oo_IsSyncOrder__c = FALSE ' + 
							//these are my addtional qualifier for test purpose only
							//'AND ccrz__OrderStatus__c = :myval '+
							' ORDER BY CreatedDate desc';
							/*
							 - - Get all isSyncOrder - false
							 - - Then check if  IsJDENumberUpdate__C flagged to see it can be processed?(For Ammended orders) - Update Order  
							 - - For Cancelled order - Process one that were not Synced 
							AND cc_oo_IsJDENumberUpdate__c = FALSE  
							AND cc_oo_JDEOrderNumber__c = null 
							ORDER BY LastModifiedDate desc limit 5 remove this after test.
							 */                     
    	
    global cc_oo_SyncJDEBatch(){
        
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
                for(CCRZ__E_Order__c cOrder : scope) {
                    jdeOrderNumber='';
                    system.debug(' Order web number ===========> ' + cOrder.Name);
                    system.debug(' Order JDE Order number ===========> ' + cOrder.cc_oo_JDEOrderNumber__c);
                    system.debug(' Order Sync Status  ===========> ' + cOrder.cc_oo_IsSyncOrder__c);
                    if((cOrder.cc_oo_JDEOrderNumber__c == null || cOrder.cc_oo_JDEOrderNumber__c == '') && cOrder.ccrz__OriginatedCart__r.cc_oo_AmendedCart__c == false) {
                    	 system.debug('===========> Calling updateJDEOrderNumber To get Jde Number since Jde Number is not aviable  ');
                    	 if(Test.isRunningTest()){
						//do something
							jdeOrderNumber = '9000000';//some fake response
						}else{
							jdeOrderNumber = cc_oo_HelperController.updateJDEOrderNumber(cOrder);
						}
                       /*jdeOrderNumber = cc_oo_HelperController.updateJDEOrderNumber(cOrder);*/
                        system.debug(' ************Got New JDE Order number ===========> ' + jdeOrderNumber);
                        isSyncOrder=false;
	                    if(!cOrder.cc_oo_IsSyncOrder__c && (String.isNotBlank(jdeOrderNumber))) {	 
	                    	system.debug('===========> Calling syncOrderToJDE to create New order in JDE'); 
	                    	if(Test.isRunningTest()){//to avoid callout from test class 
	                    		isSyncOrder = true;
	                    	}else {
	                    		isSyncOrder = cc_oo_BatchHelper.syncOrderToJDE(cOrder,cOrder.ccrz__E_OrderItems__r, jdeOrderNumber, portalUser);	
	                    	}
	                    	/*isSyncOrder = cc_oo_BatchHelper.syncOrderToJDE(cOrder,cOrder.ccrz__E_OrderItems__r, jdeOrderNumber, portalUser);*/	                      
	                        //Once order is SyncedIN JDE now Prepare the order for update in CC
	                        if(isSyncOrder){
	                        	cOrder.cc_oo_IsSyncOrder__c = true;
	                        	cOrder.cc_oo_JDEOrderNumber__c = jdeOrderNumber;
	                        	//cOrder.cc_oo_IsJDENumberUpdate__c  = true;
	                        	orderList.add(cOrder); 
	                        	 
	                        	 system.debug(' Following order is added to list for Order update ===========> ' + cOrder.id);                      	
	                        }else {
	                        	system.debug(' This JDE Order number is not updated ===========> ' + jdeOrderNumber);
	                        	 system.debug(' Following order is NOT ADDED to list for Order update ===========> ' + cOrder.id); 
	                        	 orderFailedToUpdateList.add(cOrder);
	                        }
	                        
	                    }

                    }else if(!cOrder.cc_oo_IsSyncOrder__c && cOrder.cc_oo_JDEOrderNumber__c != null && cOrder.cc_oo_JDEOrderNumber__c != '' && cOrder.ccrz__OrderStatus__c == 'Pending' && cOrder.ccrz__OriginatedCart__r.cc_oo_AmendedCart__c == false){
                    	if(Test.isRunningTest()){//to avoid callout from test class 
	                    		isSyncOrder = true;
                    	}else {
                    		isSyncOrder = cc_oo_BatchHelper.syncOrderToJDE(cOrder,cOrder.ccrz__E_OrderItems__r, cOrder.cc_oo_JDEOrderNumber__c, portalUser);	
                    	}
                    	/*isSyncOrder = cc_oo_BatchHelper.syncOrderToJDE(cOrder,cOrder.ccrz__E_OrderItems__r, jdeOrderNumber, portalUser);*/	                      
                        //Once order is SyncedIN JDE now Prepare the order for update in CC
                        if(isSyncOrder){
                        	cOrder.cc_oo_IsSyncOrder__c = true;
                        	//cOrder.cc_oo_JDEOrderNumber__c = jdeOrderNumber;
                        	//cOrder.cc_oo_IsJDENumberUpdate__c  = true;
                        	orderList.add(cOrder); 
                        	 
                        	 system.debug(' Following order is added to list for Order update ===========> ' + cOrder.id);                      	
                        }else {
                        	system.debug(' This JDE Order number is not updated ===========> ' + jdeOrderNumber);
                        	 system.debug(' Following order is NOT ADDED to list for Order update ===========> ' + cOrder.id); 
                        	 orderFailedToUpdateList.add(cOrder);
                        }
                    } else if(cOrder.ccrz__OrderStatus__c == 'Cancelled' && cOrder.cc_oo_JDEOrderNumber__c != null && cOrder.cc_oo_JDEOrderNumber__c != ''){
                    	jdeOrderNumber = cOrder.cc_oo_JDEOrderNumber__c;                    	
                    	system.debug('===========> since Jde Number Exist----Skip call to get JDE order Number, and also it should skip call to Sync Order');
                    	//Determine the status - ccrz__OrderStatus__c
                    	//Amend Order - Cancelled 
                    	boolean resp = false;
                    	if(cOrder.ccrz__OrderStatus__c == 'Cancelled'){
                    		if(Test.isRunningTest()){
                    			resp = true;
                    		}else{
                    			
                                resp = cc_oo_BatchHelper.cancelOrder(jdeOrderNumber);
                    		}
                    		
                    		if(resp){
                    			cOrder.cc_oo_IsSyncOrder__c 		= true;
                    			//cOrder.cc_oo_IsJDENumberUpdate__c	= true;
                    			orderList.add(cOrder); 
                    		}else {
	                        	system.debug(' This JDE Order number is not updated ===========> ' + jdeOrderNumber);
	                        	 system.debug(' Following order is NOT ADDED to list for Order update ===========> ' + cOrder.id); 
	                        	 orderFailedToUpdateList.add(cOrder);
	                        }
                    	}
                    	
                    }  
                  
           		}


















           		
            }         
       	}catch(Exception ex){            
			throw ex;	        
       } finally {
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
	   if(orderFailedToUpdateList.isEmpty()==false){
	   		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	   }
    }

    

}