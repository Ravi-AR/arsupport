public without sharing class cc_oo_JDESubscriber {
    public static final string CLASS_NAME = 'cc_oo_JDESubscriber';
    public PageReference redirectJDEOrder(){
        
        String baseUrl = '';
        try{
            System.debug('Piyali Subscriber'); 
            String urlOrderId = ApexPages.currentPage().getParameters().get('o');
            String portalUser = ApexPages.currentPage().getParameters().get('portalUser');
            ccrz__E_Order__c orders = [select Id, Name,LastModifiedDate,ccrz__EncryptedId__c,ccrz__OrderStatus__c, ccrz__RequestDate__c, CreatedDate
                                                ,ccrz__ShipTo__r.Name, ccrz__BillTo__r.Name, cc_oo_IsJDENumberUpdate__c, cc_oo_ShipToAccount__r.AccountNumber,
                                                cc_oo_ShipToAccount__r.BillTo_Account__c,cc_oo_ShipToAccount__r.BillTo_Flag__c,cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber,
                                                cc_oo_seller__r.ccrz__sellerId__c, ccrz__ShipMethod__c, cc_oo_OrderType__c,
                                                cc_oo_ShipToAccount__r.Delivery_Instruction_1__c,cc_oo_JDEDocumentID__c,
                                                cc_oo_IsSyncOrder__c,cc_oo_JDEOrderNumber__c,ccrz__OriginatedCart__r.ccrz__EncryptedId__c,
                                                ccrz__OriginatedCart__r.Id,ccrz__OriginatedCart__r.cc_oo_AmendedCart__c, ccrz__Note__c,
                                                ccrz__OriginatedCart__r.cc_oo_OriginalCart__c,cc_oo_PickUpTime__c, ccrz__PONumber__c, 
                                                (Select Id,Name, ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,ccrz__Product__r.cc_oo_TypeOfProduct__c,
                                                    ccrz__Product__r.ccrz__LongDesc__c,ccrz__Product__r.cc_oo_Second_Description__c,ccrz__Comments__c
                                                    ,ccrz__Price__c,ccrz__UnitOfMeasure__c,cc_oo_OriginalOrderItem__c,cc_oo_OriginalOrderItem__r.ccrz__Comments__c
                                                    From ccrz__E_OrderItems__r) 
                                                from ccrz__E_Order__c where ccrz__EncryptedId__c=:urlOrderId LIMIT 1];
            
                                                
            String primaryCartID = orders.ccrz__OriginatedCart__r.Id;            
            String jdeOrderNumber;
            Boolean AmendedCart = orders.ccrz__OriginatedCart__r.cc_oo_AmendedCart__c;
            
            if(AmendedCart == false){//Sync Odrer Logic
                List<ccrz__E_Cart__c> cart = [SELECT ccrz__EncryptedId__c,ccrz__CartStatus__c FROM ccrz__E_Cart__c WHERE cc_oo_SplitCart__r.Id =:primaryCartID AND ccrz__CartStatus__c = 'Open' LIMIT 1];                                  
                
                String secondaryCartId = '';
                if(!cart.isEmpty()) {
                    secondaryCartId = cart[0].ccrz__EncryptedId__c;
                }
                
                if(orders.cc_oo_JDEOrderNumber__c == null || orders.cc_oo_JDEOrderNumber__c == ''){
                    jdeOrderNumber = cc_oo_HelperController.updateJDEOrderNumber(orders);
                    System.debug('Piyali Testing' + jdeOrderNumber);
                }

                
                    
                
                Boolean isSyncOrder = false;            
                if(String.isNotBlank(jdeOrderNumber)) {
                	isSyncOrder = cc_oo_HelperController.syncOrderToJDE(orders, orders.ccrz__E_OrderItems__r, jdeOrderNumber, portalUser);
            	}
                
                System.debug('Piyali isSyncOrder ' + isSyncOrder );
                cc_oo_HelperController.updateOrder(String.valueOf(orders.ccrz__EncryptedId__c), jdeOrderNumber, isSyncOrder);
                System.debug('after update ---->');        
                baseUrl = cc_oo_HelperController.getRedirectUrl('ccrz__OrderConfirmation?', urlOrderId,secondaryCartId, true, null);
            }else{//OO-1772 - Modify Odrer Logic
                System.debug('in amend cart');
                id originalCart = orders.ccrz__OriginatedCart__r.cc_oo_OriginalCart__c;
                System.debug('in amend cart--->' + originalCart);
                ccrz__E_Cart__c oldCart = [SELECT ccrz__EncryptedId__c,ccrz__CartStatus__c, (select id, cc_oo_JDEOrderNumber__c from ccrz__E_Orders__r) FROM ccrz__E_Cart__c where id=: originalCart LIMIT 1];                                  
                ccrz__E_Order__c oldOrder = [select Name,LastModifiedDate,ccrz__EncryptedId__c,ccrz__OrderStatus__c, ccrz__RequestDate__c, CreatedDate
                                                ,ccrz__ShipTo__r.Name, ccrz__BillTo__r.Name, cc_oo_IsJDENumberUpdate__c
                                                ,cc_oo_IsSyncOrder__c,cc_oo_JDEOrderNumber__c,ccrz__OriginatedCart__r.ccrz__EncryptedId__c,
                                                ccrz__OriginatedCart__r.Id,ccrz__OriginatedCart__r.cc_oo_AmendedCart__c,
                                                ccrz__OriginatedCart__r.cc_oo_OriginalCart__c,
                                                (Select Id,Name, ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,
                                                    ccrz__Product__r.ccrz__LongDesc__c,ccrz__Product__r.cc_oo_Second_Description__c,ccrz__Comments__c
                                                    ,ccrz__Price__c,ccrz__UnitOfMeasure__c,cc_oo_OriginalOrderItem__c,cc_oo_OriginalOrderItem__r.ccrz__Comments__c
                                                    From ccrz__E_OrderItems__r) 
                                                from ccrz__E_Order__c where Id =: oldCart.ccrz__E_Orders__r[0].Id LIMIT 1];
                string oldJDEOrderNumber = oldCart.ccrz__E_Orders__r[0] != null ? oldCart.ccrz__E_Orders__r[0].cc_oo_JDEOrderNumber__c : '';				
                Boolean isModifyOrder = false;
                Boolean isSyncOrder = false;
                List<ccrz__E_Cart__c> cart = [SELECT ccrz__EncryptedId__c,ccrz__CartStatus__c FROM ccrz__E_Cart__c WHERE cc_oo_SplitCart__r.Id =:primaryCartID AND ccrz__CartStatus__c = 'Open' LIMIT 1];                                  
                
                String secondaryCartId = '';
                if(!cart.isEmpty()) {
                    secondaryCartId = cart[0].ccrz__EncryptedId__c;
                }
                if(String.isNotBlank(oldJDEOrderNumber)){
                    isModifyOrder = cc_oo_HelperController.modifyOrderToJDE(orders, orders.ccrz__E_OrderItems__r, oldOrder, oldJDEOrderNumber, orders.ccrz__OriginatedCart__r.Id, orders.ccrz__OriginatedCart__r.cc_oo_OriginalCart__c);//oldJDEOrderNumber);
                    cc_oo_HelperController.modifyOrderCheck(orders.Id, oldOrder.Id, oldJDEOrderNumber, isModifyOrder);   
                }
                /*System.debug('update Amend status --->');
                if(oldJDEOrderNumber != '' && oldJDEOrderNumber != null){
                    orders.cc_oo_JDEOrderNumber__c = oldJDEOrderNumber; 
                    system.debug('amend old order---->'); 
                    oldOrder.ccrz__OrderStatus__c = LOLSettings__c.getValues('AmendedOrderStatus').Value__c;
                    update orders;                    
                    update oldOrder;
                
                }*/
                baseUrl = cc_oo_HelperController.getRedirectUrl('ccrz__OrderConfirmation?', urlOrderId,secondaryCartId, true, null);
                //OO-1772 - Modify Odrer Logic - Ends
        		                                                         
                }
        }catch(Exception ex){           
            //cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
            //errorLog.cc_oo_Description__c = ex.getMessage() + ' \n ' +ex.getStackTraceString();
            //insert errorLog;
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'redirectJDEOrder');
           
        }
        PageReference page = new PageReference(baseUrl);
        return page;
    }
}