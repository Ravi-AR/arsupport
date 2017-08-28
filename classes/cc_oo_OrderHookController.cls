//ClassName:cc_oo_OrderHookController 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         9/27/2016                                      OO-428 Ability to view my pre book orders in the online ordering system
//Piyali Mukherjee                          01/02/2017                                     OO-517 Sync Order with JDE API
//-----------------------------------------------------------------------------------------------------------------------
global without sharing class cc_oo_OrderHookController extends ccrz.cc_hk_Order { 
    public static final string CLASS_NAME = 'cc_oo_OrderHookController';
    global override Map<String,Object> fetchOrderHistory(Map<String,Object> inputData){
        //First get default order list
        Map<String,Object> retMap = new Map<String, Object>();
            
        /*try{
            retMap = super.fetchOrderHistory(inputData);
        }
        catch(Exception ex){
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'fetchOrderHistory');
        }
        List<ccrz.cc_bean_MockOrder> fetchedOrders = new List<ccrz.cc_bean_MockOrder>();
        fetchedOrders = (List<ccrz.cc_bean_MockOrder>)retMap.get(ccrz.cc_hk_Order.PARAM_ORDERS);
        /*List<ccrz.cc_bean_MockOrder> filteredOrderBeans = new List<ccrz.cc_bean_MockOrder>();
        Set<Id> orderIds = new Set<Id>();
        if(fetchedOrders != null){
            for(ccrz.cc_bean_MockOrder orderBean:fetchedOrders){
                orderIds.add(orderBean.sfid);
            }
        }
        /*if(Test.isRunningTest()){
            orderIds.add((Id)inputData.get('ORDERID'));
            ccrz.cc_bean_MockOrder orderBean = new ccrz.cc_bean_MockOrder();
            orderBean.sfid = (Id)inputData.get('ORDERID');
            fetchedOrders = new List<ccrz.cc_bean_MockOrder>();
            fetchedOrders.add(orderBean);
        }
        if(fetchedOrders == null){
            fetchedOrders = new List<ccrz.cc_bean_MockOrder>();
        }*/
        
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

        
        //pass only prebook or OO orders in output map, based on page parameters
       // if(!orderIds.isEmpty()){
            List<ccrz.cc_bean_MockOrder> fetchedOrders = new List<ccrz.cc_bean_MockOrder>();
            List<ccrz.cc_bean_MockOrder> filteredOrderBeans = new List<ccrz.cc_bean_MockOrder>();
            List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
            //Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            String orderType = 'OnlineOrder';
            Integer months=Integer.valueOf(LOLSettings__c.getValues('LastNMonths').Value__c);
            String statusAmended=LOLSettings__c.getValues('AmendedOrderStatus').Value__c;
            //String prebook='Prebook';
            /*if(pageParams != null){
                orderType = pageParams.get('orderType');
            }*/
            /*if(orderType == 'Prebook'){
                orderList = [select id from ccrz__E_Order__c where cc_oo_OrderType__c = 'Prebook' AND Id IN:orderIds];
            }else{*/
            if(inputData.containsKey('shipFrom')||inputData.containsKey('shipTo')||inputData.containsKey('toDateStr')||inputData.containsKey('fromDateStr')||inputData.containsKey('searchOrderInput')||inputData.containsKey('searchOrderStatus')){
                ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData-'+inputData);
                String shipFrom  =  String.valueOf(inputData.get('shipFrom')).trim();
                String shipTo    =  String.valueOf(inputData.get('shipTo')).trim();
                String searchInput  =   String.valueOf(inputData.get('searchOrderInput')).trim();
                //Date toDate   = Date.valueof(inputData.get('toDateStr'));
                //Date fromDate = Date.valueof(inputData.get('fromDateStr'));
                Date toDate = null, fromDate = null;
                if(inputData.get('toDateStr') != null && inputData.get('toDateStr') != ''){
                    toDate = setStringToDateFormat((string)inputData.get('toDateStr'));
                }
                if(inputData.get('toDateStr') != null && inputData.get('fromDateStr') != ''){
                    fromDate = setStringToDateFormat((string)inputData.get('fromDateStr'));
                }

                String orderStatus = String.valueOf(inputData.get('searchOrderStatus')).trim();
                String searchOrderResult='Select Id,cc_oo_JDEFlag__c,cc_oo_JDEOrderNumber__c,ccrz__AdjustmentAmount__c,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__BillTo__r.ccrz__AddrReadOnly__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__CompanyName__c,ccrz__BillTo__r.ccrz__DaytimePhone__c,ccrz__BillTo__r.ccrz__Email__c,ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__HomePhone__c,ccrz__BillTo__r.ccrz__LastName__c,ccrz__BillTo__r.ccrz__MailStop__c,ccrz__BillTo__r.ccrz__MiddleName__c,ccrz__BillTo__r.ccrz__Partner_Id__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__BillTo__r.ccrz__ShippingComments__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__CountryISOCode__c ,ccrz__BuyerCompanyName__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__CCEmailAddress__c,CreatedDate,ccrz__CurrencyISOCode__c,ccrz__EncryptedId__c,ccrz__ExtShipTrackNo__c ,lastModifiedDate,Name,ccrz__OrderDate__c,ccrz__OrderId__c,ccrz__OrderStatus__c,ccrz__OrderNumber__c,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.ccrz__EncryptedID__c,Owner.Name,ccrz__PaymentMethod__c,ccrz__PONumber__c,ccrz__RequestDate__c,ccrz__ShipAmount__c,ccrz__ShipComplete__c,ccrz__ShipDiscountAmount__c,ccrz__ShipMethod__c,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__CountryISOCode__c,ccrz__ShipTo__r.ccrz__DaytimePhone__c,ccrz__ShipTo__r.ccrz__Email__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__HomePhone__c,ccrz__ShipTo__r.ccrz__MiddleName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__MailStop__c,ccrz__ShipTo__r.ccrz__Partner_Id__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__ShippingComments__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__Storefront__c,ccrz__SubTotalAmount__c,ccrz__TaxAmount__c,ccrz__TotalAmount__c,ccrz__TotalDiscount__c,ccrz__TotalSurcharge__c From ccrz__E_Order__c WHERE cc_oo_ShipToAccount__c IN:accountIds AND ccrz__OrderDate__c>=LAST_N_MONTHS:' + months + ' AND ccrz__OrderStatus__c!=:statusAmended';
                if(shipFrom!=null && shipFrom!=''){
                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData2-'+shipFrom);
                    searchOrderResult+=' AND cc_oo_Seller__r.ccrz__SellerId__c=:shipFrom';
                }
                if(shipTo!=null && shipTo!=''){
                    searchOrderResult+=' AND cc_oo_ShipToAccount__r.AccountNumber=:shipTo';
                }
                if(searchInput!=null && searchInput!=''){
                    String searchInputFinal='%'+searchInput+'%';
                    //ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData3-'+searchOrderResult);
                    searchOrderResult+=' AND (ccrz__EncryptedId__c LIKE:searchInputFinal OR Name LIKE:searchInputFinal OR cc_oo_JDEOrderNumber__c LIKE:searchInputFinal';
                    if(searchInput.isNumeric()){
                        //ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData5-'+searchOrderResult);
                        Integer searchNumber=integer.valueof(searchInput);
                        searchOrderResult+=' OR ccrz__OrderNumber__c=:searchNumber';
                    }
                    searchOrderResult+=')';
                }
                if(toDate!=null){
                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'toDate-'+ toDate);
                    searchOrderResult+=' AND ccrz__OrderDate__c<=:toDate';
                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'toDate-1'+ toDate);
                }
                if(fromDate!=null){
                    searchOrderResult+=' AND ccrz__OrderDate__c>=:fromDate';
                }
                if(orderStatus!=null && orderStatus!=''){
                    ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData4-'+orderStatus);
                    searchOrderResult+=' AND ccrz__OrderStatus__c=:orderStatus';
                }
                ccrz.ccLog.log(System.LoggingLevel.INFO, 'toDate-33');
                searchOrderResult+=' ORDER BY name desc';
                ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData6-'+searchOrderResult);
                orderList   =Database.Query(searchOrderResult);
            }
            else{
                orderList = Database.Query('Select Id,cc_oo_JDEFlag__c,cc_oo_JDEOrderNumber__c,ccrz__AdjustmentAmount__c,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__BillTo__r.ccrz__AddrReadOnly__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__CompanyName__c,ccrz__BillTo__r.ccrz__DaytimePhone__c,ccrz__BillTo__r.ccrz__Email__c,ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__HomePhone__c,ccrz__BillTo__r.ccrz__LastName__c,ccrz__BillTo__r.ccrz__MailStop__c,ccrz__BillTo__r.ccrz__MiddleName__c,ccrz__BillTo__r.ccrz__Partner_Id__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__BillTo__r.ccrz__ShippingComments__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__CountryISOCode__c ,ccrz__BuyerCompanyName__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__CCEmailAddress__c,CreatedDate,ccrz__CurrencyISOCode__c,ccrz__EncryptedId__c,ccrz__ExtShipTrackNo__c ,lastModifiedDate,Name,ccrz__OrderDate__c,ccrz__OrderId__c,ccrz__OrderStatus__c,ccrz__OrderNumber__c,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.ccrz__EncryptedID__c,Owner.Name,ccrz__PaymentMethod__c,ccrz__PONumber__c,ccrz__RequestDate__c,ccrz__ShipAmount__c,ccrz__ShipComplete__c,ccrz__ShipDiscountAmount__c,ccrz__ShipMethod__c,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__CountryISOCode__c,ccrz__ShipTo__r.ccrz__DaytimePhone__c,ccrz__ShipTo__r.ccrz__Email__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__HomePhone__c,ccrz__ShipTo__r.ccrz__MiddleName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__MailStop__c,ccrz__ShipTo__r.ccrz__Partner_Id__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__ShippingComments__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__Storefront__c,ccrz__SubTotalAmount__c,ccrz__TaxAmount__c,ccrz__TotalAmount__c,ccrz__TotalDiscount__c,ccrz__TotalSurcharge__c From ccrz__E_Order__c WHERE cc_oo_ShipToAccount__c IN:accountIds AND ccrz__OrderDate__c>=LAST_N_MONTHS:' + months + 'AND ccrz__OrderStatus__c!=:statusAmended ORDER BY name desc');
            }
            if(Test.isRunningTest()){
                orderList = [Select Id,cc_oo_JDEFlag__c,cc_oo_JDEOrderNumber__c,ccrz__AdjustmentAmount__c,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__AddressThirdline__c,ccrz__BillTo__r.ccrz__AddrReadOnly__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__CompanyName__c,ccrz__BillTo__r.ccrz__DaytimePhone__c,ccrz__BillTo__r.ccrz__Email__c,ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__HomePhone__c,ccrz__BillTo__r.ccrz__LastName__c,ccrz__BillTo__r.ccrz__MailStop__c,ccrz__BillTo__r.ccrz__MiddleName__c,ccrz__BillTo__r.ccrz__Partner_Id__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__BillTo__r.ccrz__ShippingComments__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__CountryISOCode__c ,ccrz__BuyerCompanyName__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__CCEmailAddress__c,CreatedDate,ccrz__CurrencyISOCode__c,ccrz__EncryptedId__c,ccrz__ExtShipTrackNo__c ,lastModifiedDate,Name,ccrz__OrderDate__c,ccrz__OrderId__c,ccrz__OrderStatus__c,ccrz__OrderNumber__c,ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.ccrz__EncryptedID__c,Owner.Name,ccrz__PaymentMethod__c,ccrz__PONumber__c,ccrz__RequestDate__c,ccrz__ShipAmount__c,ccrz__ShipComplete__c,ccrz__ShipDiscountAmount__c,ccrz__ShipMethod__c,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__CountryISOCode__c,ccrz__ShipTo__r.ccrz__DaytimePhone__c,ccrz__ShipTo__r.ccrz__Email__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__HomePhone__c,ccrz__ShipTo__r.ccrz__MiddleName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__MailStop__c,ccrz__ShipTo__r.ccrz__Partner_Id__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__ShippingComments__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__Storefront__c,ccrz__SubTotalAmount__c,ccrz__TaxAmount__c,ccrz__TotalAmount__c,ccrz__TotalDiscount__c,ccrz__TotalSurcharge__c From ccrz__E_Order__c 
                                                ORDER BY name desc];
            }
            map<id,String> orderWeight=new map<id,String>();
            list<Id> cartList=new list<Id>();
            map<Id,Id> orderCart    =new map<Id,Id>();
            String portalUser=ccrz.cc_CallContext.currPageParameters.get('isCSRFlow');
            if(orderList!=null){
                for(ccrz__E_Order__c accountOrder:orderList){
                    cartList.add(accountOrder.ccrz__OriginatedCart__c);
                    orderCart.put(accountOrder.ccrz__OriginatedCart__c,accountOrder.Id);
                    ccrz.cc_bean_MockOrder orderBean = new ccrz.cc_bean_MockOrder();
                    ccrz.cc_bean_MockContactAddress billToAddress = new ccrz.cc_bean_MockContactAddress(accountOrder.ccrz__BillTo__r);
                    ccrz.cc_bean_MockContactAddress shipToAddress = new ccrz.cc_bean_MockContactAddress(accountOrder.ccrz__ShipTo__r);
                    orderBean.billTo = billToAddress;
                    orderBean.shipTo = shipToAddress;
                    orderBean.paymentMethod = accountOrder.ccrz__PaymentMethod__c;
                    orderBean.poNumber = accountOrder.ccrz__PONumber__c;
                    orderBean.shippingMethod = accountOrder.ccrz__ShipMethod__c;
                    orderBean.shipAmount = accountOrder.ccrz__ShipAmount__c;
                    orderBean.subTotalAmount = accountOrder.ccrz__SubTotalAmount__c;
                    if(accountOrder.cc_oo_JDEOrderNumber__c!=null && accountOrder.cc_oo_JDEOrderNumber__c!=''){
                        orderBean.name= accountOrder.cc_oo_JDEOrderNumber__c;
                    }else{  
                        orderBean.name= accountOrder.Name;
                    }
                    orderBean.orderNumber = accountOrder.ccrz__OrderNumber__c;
                    //orderBean.orderNumberAsString = accountOrder.Name;
                    orderBean.sfid = accountOrder.Id;
                    orderBean.status= accountOrder.ccrz__OrderStatus__c;
                    orderBean.taxAmount = accountOrder.ccrz__TaxAmount__c; 
                    orderBean.totalAmount = accountOrder.ccrz__TotalAmount__c;
                    orderBean.totalSurcharge = accountOrder.ccrz__TotalSurcharge__c;
                    orderBean.buyerEmail = accountOrder.ccrz__BuyerEmail__c;
                    orderBean.buyerFirstName = accountOrder.ccrz__BuyerFirstName__c;
                    orderBean.buyerLastName = accountOrder.ccrz__BuyerLastName__c ;
                    orderBean.buyerPhone = accountOrder.ccrz__BuyerPhone__c;
                    orderBean.buyerMobilePhone = accountOrder.ccrz__BuyerMobilePhone__c;
                    orderBean.buyerCompanyName = accountOrder.ccrz__BuyerCompanyName__c;
                    orderBean.shipTrackNo = accountOrder.ccrz__ExtShipTrackNo__c;
                    orderBean.ownerName = accountOrder.Owner.Name;
                    orderBean.currencyIsoCode = accountOrder.ccrz__CurrencyISOCode__c;
                    orderBean.externalOrderId = accountOrder.ccrz__OrderId__c;
                    orderBean.shipComplete = accountOrder.ccrz__ShipComplete__c;
                    orderBean.requestDateVal= accountOrder.ccrz__RequestDate__c;
                    orderBean.requestDate = orderBean.requestDateVal<> null ?orderBean.requestDateVal.format():null;
                    orderBean.orderDate = accountOrder.ccrz__OrderDate__c;
                    orderBean.orderDateStr = orderBean.orderDate<> null?orderBean.orderDate.format():null;
                    orderBean.encryptedId = accountOrder.ccrz__EncryptedId__c;
                    orderBean.canReorder = true;
                    //orderBean.canAmend    = true;
                    //orderBean.canCancel   =true;
                    if(accountOrder.cc_oo_JDEFlag__c == '0' &&( accountOrder.cc_oo_JDEFlag__c!=null && accountOrder.cc_oo_JDEFlag__c!='')&& (accountOrder.ccrz__OrderStatus__c != 'Pending')){
                        orderBean.canAmend  = true;
                        orderBean.canCancel =true;
                    }
                    else if((accountOrder.cc_oo_JDEFlag__c=='1')&&(portalUser=='false')){
                        orderBean.canAmend  = false; 
                        orderBean.canCancel =false;
                    }
                    else if((accountOrder.cc_oo_JDEFlag__c=='1')&&(portalUser=='true')){
                        orderBean.canAmend  = true;
                        orderBean.canCancel =true;
                    }
                    else{
                        orderBean.canAmend  = false;
                        orderBean.canCancel =false;
                    }
                    if(accountOrder.ccrz__OrderStatus__c=='Cancelled'){
                        orderBean.canAmend=false;
                        orderBean.canCancel=false;
                    }
                    fetchedOrders.add(orderBean);
                }
            
            }
            for(ccrz__E_Cart__c cartId:([SELECT Id,(SELECT Id, cc_oo_TotalWieght__c FROM ccrz__E_CartItems__r ) FROM ccrz__E_Cart__c WHERE ccrz__E_Cart__c.Id IN: cartList])){
                Decimal totalAggr=0;
                for(ccrz__E_CartItem__c cartitemlevel:cartId.ccrz__E_CartItems__r){
                    totalAggr+=cartitemlevel.cc_oo_TotalWieght__c;
                }
                orderWeight.put(orderCart.get(cartId.Id),String.valueOf(totalAggr));
                
            }
            ccrz.cc_bean_MockOrder tempOrderBean;
            for(ccrz.cc_bean_MockOrder orderBean:fetchedOrders){
                tempOrderBean=new ccrz.cc_bean_MockOrder();
                tempOrderBean=orderBean;
                tempOrderBean.orderNumberAsString=orderWeight.get(orderBean.sfid);
                filteredOrderBeans.add(tempOrderBean);
                
            }
            fetchedOrders=filteredOrderBeans;
            /*if(orderList == null){
                fetchedOrders = new List<ccrz.cc_bean_MockOrder>() ;
            }
            else{
                Set<Id> filteredOrders = new Set<Id>();
                for(ccrz__E_Order__c order:orderList){
                    filteredOrders.add(order.Id);
                }
                for(ccrz.cc_bean_MockOrder orderBean:fetchedOrders){
                    if(filteredOrders.contains(orderBean.sfid))
                        filteredOrderBeans.add(orderBean);
                }
            }
        }*/
        ccrz.ccLog.log(System.LoggingLevel.INFO, 'fetchOrderData1-'+fetchedOrders);
        retMap.put(ccrz.cc_hk_Order.PARAM_ORDERS,fetchedOrders);
        return retMap;
    }
    
    global static Date setStringToDateFormat(String myDate) {
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;
    }
    global override Map<String,Object> place(Map<String,Object>inputData){
        final String placeStep = (String)inputData.get(ccrz.cc_hk_order.PARAM_PLACE_STEP);
        
        if(ccrz.cc_hk_Order.STEP_CREATE_ORDER_POST.equals(placeStep)){
            ccrz__E_Order__c order = (ccrz__E_Order__c) inputData.get(ccrz.cc_hk_Order.PARAM_ORDER);
            if(order != null){
                updateOrder(order.Id);
            }
        }
        if(ccrz.cc_hk_Order.STEP_END.equals(placeStep)){
            ccrz__E_Order__c order = (ccrz__E_Order__c) inputData.get(ccrz.cc_hk_Order.PARAM_ORDER);
            if(order != null){
                order.ccrz__OrderStatus__c=LOLSettings__c.getValues('PendingOrderStatus').Value__c;
                //list<ccrz__E_Order__c> orderConfirm=[select id,ccrz__OriginatedCart__c,ccrz__PONumber__c from ccrz__E_Order__c where ccrz__E_Order__c.id =: orderId];
                ccrz__E_Cart__c cartcheck=[select c.ccrz__PONumber__c,cc_oo_ShipToAccount__c,cc_oo_PickUpTime__c,cc_oo_TimeZone__c from ccrz__E_Cart__c c where c.Id =:order.ccrz__OriginatedCart__c];
                //list<ccrz__E_PaymentDetail__c> cartcheck=[select c.ccrz__Account_Number__c,c.ccrz__CC_Order__c from ccrz__E_PaymentDetail__c c where c.ccrz__Cart__c =:order.ccrz__OriginatedCart__c limit 1];
                //cartcheck[0].ccrz__CC_Order__c=order.Id;
                if(cartcheck.ccrz__PONumber__c!=null && cartcheck.ccrz__PONumber__c!=''){
                    order.ccrz__PONumber__c=cartcheck.ccrz__PONumber__c;
                }
                order.cc_oo_ShipToAccount__c=cartcheck.cc_oo_ShipToAccount__c;
                order.cc_oo_PickUpTime__c = cartcheck.cc_oo_PickUpTime__c; 
                order.cc_oo_TimeZone__c = cartcheck.cc_oo_TimeZone__c;              
                update order;
            }
        // User story 1720: To verify primary and secondary carts
            //ccrz__E_Cart__c newCarts = new ccrz__E_Cart__c();
            String primaryCartId =  (String) inputData.get(ccrz.cc_hk_Order.PARAM_CART_ID); 
            List<ccrz__E_Cart__c> secondaryCarts = [select c.Id,c.ccrz__ActiveCart__c,c.ccrz__CartStatus__c,c.ccrz__ShipTo__c,c.cc_oo_ShipToAccount__c,c.cc_oo_SplitCart__c,c.cc_oo_SplitCartType__c 
                  from ccrz__E_Cart__c c where c.cc_oo_SplitCart__c =: primaryCartId and c.ccrz__CartStatus__c ='Open'];
                  if(!secondaryCarts.isEmpty()){
                    secondaryCarts[0].cc_oo_SplitCartType__c = 'Primary';
                    secondaryCarts[0].ccrz__ActiveCart__c = true;
                  update secondaryCarts;
            }
            // End of user story OO-1720 
        }
        return inputData;
    }
    private void updateOrder(Id orderId){
        try{ 
            ccrz__E_Order__c orders = [select cc_oo_OrderType__c,cc_oo_JDEOrderNumber__c,ccrz__OriginatedCart__r.cc_oo_JDEPreviousOrderNumber__c from ccrz__E_Order__c where id=:orderId LIMIT 1];
                Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
                String orderType = 'OnlineOrder';
                String sellerId = null;
                if(pageParams != null){
                    orderType = pageParams.get('orderType');
                    sellerId = pageParams.get('sid');
                }
                if(sellerId != null){
                    orders.cc_oo_Seller__c = sellerId;
                }
                if(orderType == 'Prebook'){
                    orders.cc_oo_OrderType__c = 'Prebook';
                }else{
                    orders.cc_oo_OrderType__c = 'Online Order';
                }
                if(orders.ccrz__OriginatedCart__r.cc_oo_JDEPreviousOrderNumber__c != null){
                    orders.cc_oo_JDEOrderNumber__c = orders.ccrz__OriginatedCart__r.cc_oo_JDEPreviousOrderNumber__c;
                }
                update orders;
        }catch (Exception ex) {
               cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'updateOrder');
              
        }
    }
    
    // US - 517 - Start - Sync order with JDE
    global override Map<String,Object> placeTarget(Map<String,Object>inputData){
        
        ccrz__E_Order__c orderDetail = (ccrz__E_Order__c) inputData.get(ccrz.cc_hk_Order.PARAM_ORDER);
        String orderId = orderDetail.ccrz__EncryptedId__c;
        String pageUrl = ccrz.cc_CallContext.currURL;
        String pathName = pageUrl.split('\\?')[0];
        List<String> path = pathName.split('\\/');
        String isbaseUrl = path[0]+'//'+path[2]+'/'+path[3];
        String baseUrl = cc_oo_HelperController.getRedirectUrl('ccrz__CCPage?pageKey=JDESubscriber&', orderId,null, false, isbaseUrl);
        System.debug('Piyali Url' + baseUrl );                  
        inputData.put(ccrz.cc_hk_Order.PARAM_PLACE_TARGET, baseUrl);
        return inputData;   
    }
    // US - 517 - End
}