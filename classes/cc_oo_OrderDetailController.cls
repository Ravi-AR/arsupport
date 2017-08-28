//ClassName:cc_oo_OrderDetailController
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//
//Saloni Kale                                9/28/2016                                      OO-371 - Created and added E2 description on the cart page
//                                                                                          Used the same method getProductsDetails()
//
//Piyali Mukherjee                           10/7/2016                                      US - 205 - To add promotion code to order
//Murtaza Beejwala                           08/12/2016                                     US-1210 - To get the VFD flagged product
//-----------------------------------------------------------------------------------------------------------------------
global without sharing class cc_oo_OrderDetailController {
    
     public static final string CLASS_NAME = 'cc_oo_OrderDetailController';
     //Property to hold community portal link from custom settings
     /*public String commPortalLink {get; set;} */
     public static String urlOrderId{get;private set;}
     public static String jdeOrderNo{get;private set;}
     public static String jdeName{get;private set;} // Defect- 3176
     public static Boolean addnextCart{get;private set;}
     public static String secondaryCartId{get;private set;}
     public String paymentTerms {get; set;}
     
     public cc_oo_OrderDetailController() {
        //setLinkCookie();
        // Access community portal link cookie key from custom settings
        /*String commPortalCookiekey  =   LOLSettings__c.getAll().get('CommunityUrlCookieKey').Value__c;
        if(String.isNotEmpty(commPortalCookiekey))
        {
            commPortalLink  =   commPortalCookiekey;
        }
        else
        {
            commPortalLink  =   '#';
        }*/
        // US-2690 start
        String accId  = ccrz.cc_CallContext.currAccountId;
        List<Account> accData = [select Payment_Term_Desc_JDE__c from Account where id=: accId Limit 1];
        for(Account acc:accData){
          if(acc.Payment_Term_Desc_JDE__c!=null){
            paymentTerms=acc.Payment_Term_Desc_JDE__c;
          }
        }
        // US-2690 end
        urlOrderId = ApexPages.currentPage().getParameters().get('o');
        secondaryCartId = ApexPages.currentPage().getParameters().get('cartID');
        System.debug('Order detail' + urlOrderId);
        // defect OO-2360
        List<ccrz__E_CartItem__c> cartItems = [select id,ccrz__CartItemId__c from ccrz__E_CartItem__c where ccrz__Cart__c=:secondaryCartId];
        if(cartItems.isEmpty()){
            addnextCart = false;
        }
        else{
            addnextCart = true;
        }
        // end of defect OO-2360
        ccrz__E_Order__c orders = [select Name,cc_oo_IsSyncOrder__c,cc_oo_JDEOrderNumber__c,ccrz__OrderStatus__c
                                            from ccrz__E_Order__c where ccrz__EncryptedId__c=:urlOrderId LIMIT 1];
        if(orders.cc_oo_JDEOrderNumber__c == null || orders.cc_oo_JDEOrderNumber__c == '') {
            jdeOrderNo = null;//us-2391
        }else {
            jdeOrderNo = orders.cc_oo_JDEOrderNumber__c;
        }                               
        // Start of Defect - 3176: new line added in the code for fetching order name if JDE order number is not available
        if(orders.Name == '' || orders.Name == null){
            jdeName = null;
        }else{
            jdeName = orders.Name;
        }
        // End of Defect - 3176: new line added in the code for fetching order name if JDE order number is not available
     }
    /* 
     *@Param: cartId which is used to store id of Cart
     *@Desc: method is to pull the product details like SKU, Long Description 
    **/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetails(final ccrz.cc_RemoteActionContext ctx, string orderId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        {     System.debug('********im in product details*******');
              Map<String, Object> dataMap = new Map<String, Object>();
              /*List<ccrz__E_OrderItem__c> orderItems = [Select ci.Id, ci.ccrz__Product__c, ci.ccrz__Product__r.ccrz__SKU__c,
                                      ci.ccrz__Product__r.ccrz__LongDesc__c,ci.ccrz__Product__r.cc_oo_Second_Description__c From ccrz__E_OrderItem__c ci WHERE ccrz__Order__c =: orderId];*/
                                      
              List<ccrz__E_Order__c> orderDetails = [Select ccrz__BillTo__r.Id, ccrz__BillTo__r.ccrz__FirstName__c,ccrz__BillTo__r.ccrz__AddrReadOnly__c,ccrz__BuyerEmail__c,cc_oo_ShipToAccount__c, cc_oo_ShipToAccount__r.Delivery_Instruction_1__c,cc_oo_ShipToAccount__r.Delivery_Instruction_2__c,
                                                            ccrz__BuyerFirstName__c,ccrz__BuyerPhone__c,ccrz__BuyerLastName__c,ccrz__EncryptedId__c, Name, ccrz__OrderDate__c, ccrz__OrderNumber__c,cc_oo_Seller__c,
                                                            ccrz__RequestDate__c, Id,ccrz__ShipComplete__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c, ccrz__ShipTo__r.ccrz__City__c,
                                                            ccrz__ShipTo__r.ccrz__Country__c, ccrz__ShipTo__r.ccrz__CountryISOCode__c, ccrz__ShipTo__r.ccrz__FirstName__c, ccrz__ShipTo__r.ccrz__PostalCode__c,
                                                            ccrz__ShipTo__r.Id, ccrz__ShipTo__r.ccrz__State__c, ccrz__ShipTo__r.ccrz__StateISOCode__c, ccrz__ShipAmount__c,
                                                            ccrz__Contact__r.FirstName,ccrz__Contact__r.LastName,ccrz__Contact__r.Phone,ccrz__Contact__r.Email,
                                                            ccrz__ShipMethod__c,ccrz__OrderStatus__c, ccrz__SubtotalAmount__c, ccrz__TaxSubTotalAmount__c,cc_oo_PickUpTime__c,cc_oo_TimeZone__c,ccrz__OriginatedCart__c,
                                                            (Select ccrz__SubAmount__c,ccrz__AbsoluteDiscount__c, ccrz__DisplayProduct__r.Name, Id, ccrz__ItemTotal__c,
                                                            ccrz__OrderLineType__c, ccrz__Price__c, ccrz__Quantity__c, ccrz__Product__r.Id, ccrz__Product__r.Name,
                                                            ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.ccrz__UnitOfMeasure__c, ccrz__Product__r.ccrz__ProductType__c,
                                                            ccrz__Product__r.ccrz__LongDesc__c,ccrz__Product__r.cc_oo_Second_Description__c,ccrz__Comments__c,ccrz__Order__c
                                                            FROM ccrz__E_OrderItems__r order by Name) FROM ccrz__E_Order__c Where Id =:orderId Limit 1];
              List<Map<String, Object>> orderItems = new List<Map<String, Object>>();
              //Id contactId=orderDetails[0].ccrz__Contact__c;
              //contact buyerInfo=[select FirstName,Phone,LastName,Email from contact where Id=:contactId];
              //if(buyerInfo!=null){
                orderDetails[0].ccrz__BuyerFirstName__c=orderDetails[0].ccrz__Contact__r.FirstName;
                orderDetails[0].ccrz__BuyerPhone__c=orderDetails[0].ccrz__Contact__r.Phone;
                orderDetails[0].ccrz__BuyerEmail__c=orderDetails[0].ccrz__Contact__r.Email;
                orderDetails[0].ccrz__BuyerLastName__c=orderDetails[0].ccrz__Contact__r.LastName;
                update orderDetails[0];
              //}
              string sellerID=orderDetails[0].cc_oo_Seller__c;
              string accountID=orderDetails[0].cc_oo_ShipToAccount__c; //OO-4800
              Set<String> productIds = new Set<String>();
              
              for(ccrz__E_OrderItem__c orderItem : orderDetails[0].ccrz__E_OrderItems__r){
                    productIds.add(orderItem.ccrz__Product__r.Id);
              }
              //List<String>listproductIDs=new List<String>(productIds);
              //Map<String, String> dataLeadMap = new Map<String, String>();
              List<ccrz__E_ProductMedia__c> productMedia = new List<ccrz__E_ProductMedia__c>();
              if(productIds.size() != 0 && !productIds.isEmpty()) {
                    productMedia = [SELECT ccrz__Product__r.Id, ccrz__URI__c, ccrz__ProductMediaSource__c
                                                                         FROM ccrz__E_ProductMedia__c WHERE ccrz__Product__c IN :productIds];
               //dataLeadMap        =   cc_oo_HelperController.GetLeadTimeforAllProducts(listproductIDs, sellerID);
              }
              //dataMap.put('sellerId', orderDetails[0].cc_oo_Seller__c);
              // for lead time
              list<boolean> priceList=new list<boolean>();
              List<Boolean> frieghtData = new List<Boolean>();
              list<String>  leadtime = new list<String>();
              List<ccrz__E_CartItem__c> cartItems = [Select ci.Id,ci.cc_oo_leadtime__c,ci.cc_oo_isFreightIncluded__c,ci.cc_oo_IsListPrice__c,ccrz__Product__c,ccrz__Product__r.ccrz__SKU__c From ccrz__E_CartItem__c ci WHERE ccrz__Cart__c =: orderDetails[0].ccrz__OriginatedCart__c order by Name];
              //Set<Id> productIdList = new Set<Id>();
              //Set<Id> productIdContract = new Set<Id>();
              for(ccrz__E_CartItem__c cartItem : cartItems){  
                 // dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem.ccrz__Product__r.ccrz__LongDesc__c);
                 frieghtData.add(cartItem.cc_oo_isFreightIncluded__c);
                 priceList.add(cartItem.cc_oo_IsListPrice__c);
                 leadtime.add(cartItem.cc_oo_leadtime__c);
              }
              integer priceMapSize=0;
              for(ccrz__E_OrderItem__c orderItem : orderDetails[0].ccrz__E_OrderItems__r){  
                 // dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem.ccrz__Product__r.ccrz__LongDesc__c);
                 dataMap.put(string.valueOf(orderItem.ccrz__Product__r.ccrz__SKU__c),orderItem);
                 Map<String, Object> orderItemMap = new Map<String, Object>(); 
                 orderItemMap.put('SubAmount', orderItem.ccrz__SubAmount__c);
                 orderItemMap.put('absoluteDiscount', orderItem.ccrz__AbsoluteDiscount__c);
                 orderItemMap.put('displayProductName', orderItem.ccrz__DisplayProduct__r.Name);
                 orderItemMap.put('isLimitedSubscription', false);
                 orderItemMap.put('isSubscription', false);
                 orderItemMap.put('itemID', orderItem.Id);
                 orderItemMap.put('itemTotal', orderItem.ccrz__ItemTotal__c);
                 orderItemMap.put('itemType', orderItem.ccrz__OrderLineType__c);
                 orderItemMap.put('comments',orderItem.ccrz__Comments__c); // added to store the value of shopping cart note
                 orderItemMap.put('priceType',priceList.get(priceMapSize));
                 orderItemMap.put('isfreightincluded',frieghtData.get(priceMapSize));
                 orderItemMap.put('leadTime',leadtime.get(priceMapSize));
                 priceMapSize++;
                 List<Map<String, Object>> mediaWrapperList = new List<Map<String, Object>>();
                 if(productMedia.size() != 0 && !productMedia.isEmpty()) {
                    for(ccrz__E_ProductMedia__c media : productMedia) {
                        if(media.ccrz__Product__r.Id.equals(orderItem.ccrz__Product__r.Id)) {
                            Map<String, Object> mediaWrapper = new Map<String, Object>();
                             mediaWrapper.put('mediaName', media.ccrz__URI__c);
                             mediaWrapper.put('sourceType', media.ccrz__ProductMediaSource__c);
                             mediaWrapper.put('uri', media.ccrz__URI__c);
                             mediaWrapperList.add(mediaWrapper);
                        }
                    }
                 }
                 if(mediaWrapperList.size() != 0 && !mediaWrapperList.isEmpty()) {
                    orderItemMap.put('mediaWrapper', mediaWrapperList);
                 }                 
                 
                 List<String> minorLines = new List<String>(); 
                 orderItemMap.put('minorLines', minorLines);
                 
                 Map<String, Object> mockProduct = new Map<String, Object>();
                 mockProduct.put('ProductType', orderItem.ccrz__Product__r.ccrz__ProductType__c);
                 mockProduct.put('UnitOfMeasure', orderItem.ccrz__Product__r.ccrz__UnitOfMeasure__c);
                 List<String> compositeSubscriptions = new List<String>();
                 mockProduct.put('compositeSubscriptions', compositeSubscriptions);
                 mockProduct.put('id', orderItem.ccrz__Product__r.Id);
                 mockProduct.put('name', orderItem.ccrz__Product__r.Name);
                 mockProduct.put('showSubscriptionSelection', false);
                 mockProduct.put('sku', orderItem.ccrz__Product__r.ccrz__SKU__c);
                 List<String> subscriptionFrequencies = new List<String>();
                 mockProduct.put('subscriptionFrequencies', subscriptionFrequencies);
                 
                 orderItemMap.put('mockProduct', mockProduct);
                 orderItemMap.put('price', orderItem.ccrz__Price__c);
                 orderItemMap.put('quantity', orderItem.ccrz__Quantity__c);
                 
                 orderItems.add(orderItemMap);
                 //Associating a payment detail to the order.
              }
              String deliveryInstruction='';
                //added null check 
                if(orderDetails[0].cc_oo_ShipToAccount__r.Delivery_Instruction_1__c != null && string.isNotBlank(orderDetails[0].cc_oo_ShipToAccount__r.Delivery_Instruction_1__c)){
                    deliveryInstruction += orderDetails[0].cc_oo_ShipToAccount__r.Delivery_Instruction_1__c;
                }
                //US-1644 string concatenation
                if( orderDetails[0].cc_oo_ShipToAccount__r.Delivery_Instruction_2__c !=null && string.isNotBlank(orderDetails[0].cc_oo_ShipToAccount__r.Delivery_Instruction_2__c)){
                        deliveryInstruction += ' ' + orderDetails[0].cc_oo_ShipToAccount__r.Delivery_Instruction_2__c;  
                }
              Map<String, Object> billingMap = new Map<String, Object>();  
              billingMap.put('addrReadOnly', orderDetails[0].ccrz__BillTo__r.ccrz__AddrReadOnly__c);
              billingMap.put('firstName', orderDetails[0].ccrz__BillTo__r.ccrz__FirstName__c);
              billingMap.put('sfid', orderDetails[0].ccrz__BillTo__r.Id);
              dataMap.put('billingAddress', billingMap);    
              //dataMap.put('dataLeadMap',  dataLeadMap);    
              dataMap.put('buyerEmail', orderDetails[0].ccrz__BuyerEmail__c); 
              dataMap.put('buyerFirstName', orderDetails[0].ccrz__BuyerFirstName__c);
              dataMap.put('buyerLastName', orderDetails[0].ccrz__BuyerLastName__c);
              dataMap.put('buyerPhone',orderDetails[0].ccrz__BuyerPhone__c);
              dataMap.put('couponName', '');  
              dataMap.put('encryptedId', orderDetails[0].ccrz__EncryptedId__c); 
              dataMap.put('hasCoupon', false); 
              dataMap.put('isConfirmation', true);
              dataMap.put('name', orderDetails[0].Name);  
              dataMap.put('orderDate', orderDetails[0].ccrz__OrderDate__c);  
              dataMap.put('orderDateStr', String.valueOf(orderDetails[0].ccrz__OrderDate__c));
              dataMap.put('orderItems', orderItems);
              dataMap.put('orderNumber', orderDetails[0].ccrz__OrderNumber__c);
              List<String> payments = new List<String>();
              dataMap.put('payments', payments);
              dataMap.put('requestedDate', orderDetails[0].ccrz__RequestDate__c);
              dataMap.put('requestedDateStr', String.valueOf(orderDetails[0].ccrz__RequestDate__c));
              dataMap.put('sfid', orderDetails[0].Id);
              
              dataMap.put('shipComplete', orderDetails[0].ccrz__ShipComplete__c);
              dataMap.put('pickupTime', orderDetails[0].cc_oo_PickUpTime__c);
              dataMap.put('timeZone',orderDetails[0].cc_oo_TimeZone__c);
              List<String> shipments = new List<String>();
              dataMap.put('shipments', shipments);
              dataMap.put('DeliveryInstructions',deliveryInstruction);
              
              Map<String, Object> shippingMap = new Map<String, Object>();  
              shippingMap.put('address1', orderDetails[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c);
              shippingMap.put('city', orderDetails[0].ccrz__ShipTo__r.ccrz__City__c);
              shippingMap.put('country', orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c);
              shippingMap.put('countryCode', orderDetails[0].ccrz__ShipTo__r.ccrz__CountryISOCode__c);
              shippingMap.put('firstName', orderDetails[0].ccrz__ShipTo__r.ccrz__FirstName__c);
              shippingMap.put('postalCode', orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
              shippingMap.put('sfid', orderDetails[0].ccrz__ShipTo__r.Id);
              shippingMap.put('state', orderDetails[0].ccrz__ShipTo__r.ccrz__State__c);
              shippingMap.put('stateCode', orderDetails[0].ccrz__ShipTo__r.ccrz__StateISOCode__c);
              dataMap.put('shippingAddress', shippingMap); 
              
              dataMap.put('shippingCharge', orderDetails[0].ccrz__ShipAmount__c);  
              dataMap.put('shippingMethod', orderDetails[0].ccrz__ShipMethod__c);  
              dataMap.put('status', orderDetails[0].ccrz__OrderStatus__c);
              dataMap.put('subTotal', orderDetails[0].ccrz__SubtotalAmount__c);
              dataMap.put('tax', orderDetails[0].ccrz__TaxSubTotalAmount__c);
              
              List<String> transactionPayments = new List<String>();
              dataMap.put('transactionPayments', transactionPayments);
              
              
              /*list<ccrz__E_Order__c> orderConfirm=[select id,ccrz__OriginatedCart__c,ccrz__PONumber__c from ccrz__E_Order__c where ccrz__E_Order__c.id =: orderId];
              list<ccrz__E_PaymentDetail__c> cartcheck=[select c.ccrz__Account_Number__c,c.ccrz__CC_Order__c from ccrz__E_PaymentDetail__c c where c.ccrz__Cart__c =:orderConfirm[0].ccrz__OriginatedCart__c limit 1];
              cartcheck[0].ccrz__CC_Order__c=orderConfirm[0].id;
              update cartcheck[0];*/
              res.success = true;
              res.data = dataMap;
              
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductsDetails');
        }
        return res;
    }
    
    /*//OO-3252
     *@Param: orderId which is used to store id of order
     *@Desc: method is used to save promotion code in order comments.
    **/
    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult savePromotionCode(final ccrz.cc_RemoteActionContext ctx, string orderId, string promotionCode){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
            ccrz__E_Order__c orders = [select Id, ccrz__Note__c from ccrz__E_Order__c where id=:orderId];
            if(orders != null && promotionCode != null){
                orders.ccrz__Note__c = promotionCode;
                update orders;
              }
              res.success = true;
              
        }catch (Exception error) 
        {
              System.debug(error);
        }
        return res;
    }*///OO-3252
    
     @RemoteAction
    global static ccrz.cc_RemoteActionResult getOrderDetails(final ccrz.cc_RemoteActionContext ctx, String orderName){
              
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        Map<String,String> dataMap = new Map<String,String>();
        Integer orderNumber = Integer.valueof(orderName);
        try
        {  
              List<ccrz__E_Order__c> cc_orders = [Select Id, cc_oo_JDEOrderNumber__c from ccrz__E_Order__c  
                                                        WHERE ccrz__OrderNumber__c  =:orderNumber];
              if(!cc_orders.isEmpty()){
                dataMap.put('cc_oo_JDEOrderNumber__c',cc_orders[0].cc_oo_JDEOrderNumber__c);
                
              }
              res.data = dataMap;
              res.success = true;
              
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderDetails');
        }

        return res;
    } 
    
    /***************************************************************************************************************************************
      Method Name : getVfdFlag
      Description : getVfdFlag is to get the vfd flag for corresponding products
      Parameter   : sfIds 
                    sfIds is the list of product Ids
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-59 - vfd products shall be flagged.                                                              

                    
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
      Method Name : getPONumber
      Description : getPONumber is to get the PO Number on order confirmation page
      Parameter   : orderId 
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1720 - Enter Order info                                                              

      *************************************************************************************************************************************/
      @RemoteAction
     global static ccrz.cc_RemoteActionResult getPONumber(final ccrz.cc_RemoteActionContext ctx,String orderId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        System.debug('********* In getPONumber() method *********');
        res.success = false; 
       Map<String,String> dataMap = new Map<String,String>();
       Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
       String sellerId;
       String cartId;
       ccrz__E_Cart__c newActiveCart;
       if(pageParams != null){
            sellerId = pageParams.get('sid');
            cartId = pageParams.get('cartID')!=null ? pageParams.get('cartID')  : pageParams.get('cartId'); 
        }
        try{
            System.debug('**** In Try block of getPONumber() method ****');
            List<ccrz__E_Order__c> orderItems = [select c.Id,c.ccrz__PONumber__c,c.cc_oo_ShipToAccount__r.AccountNumber,ccrz__RequestDate__c,ccrz__Note__c,ccrz__OriginatedCart__r.ccrz__Note__c  from ccrz__E_Order__c c where Id =:orderId];
            System.debug('OrderItems: '+orderItems);
            if(String.isEmpty(cartId)) {
                newActiveCart = cc_oo_HeaderController.mapToCart(sellerId,orderItems[0].cc_oo_ShipToAccount__r.AccountNumber, false);
                newActiveCart.ccrz__RequestDate__c = orderItems[0].ccrz__RequestDate__c;
                update newActiveCart;
            }
            if(!orderItems.isEmpty()){
                for(ccrz__E_Order__c orderItem:orderItems){                 
                    System.debug('PO Number: '+orderItem.ccrz__PONumber__c);
                    dataMap.put('PONumber',orderItem.ccrz__PONumber__c);
                    dataMap.put('AccountNumber',orderItem.cc_oo_ShipToAccount__r.AccountNumber);
                    dataMap.put('Comments',orderItem.ccrz__OriginatedCart__r.ccrz__Note__c);
                }
                if(newActiveCart != null) {
                    dataMap.put('cartId',newActiveCart.ccrz__EncryptedId__c);
                }
                res.data = dataMap;
            }
            else
            {
                res.data = 'Order Not Found';
            }
            res.success = true;
           
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getPONumber');
        }
        return res;
     }  
     /***************************************************************************************************************************************
      Method Name : getOrderConfirmationDetails
      Description : getOrderConfirmationDetails is to get the details on order confirmation page
      Parameter   : orderId 
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-2690 - Updates to Order Review and Order confirmation pages                                                              

      *************************************************************************************************************************************/
      @RemoteAction
     global static ccrz.cc_RemoteActionResult getOrderConfirmationDetails(final ccrz.cc_RemoteActionContext ctx,String orderId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        System.debug('********* In getOrderConfirmationDetails() method *********');
        res.success = false; 
        Map<String,object> dataMap = new Map<String,object>();
       
        try{
            List<ccrz__E_OrderItem__c> orderItems = [select ccrz__Product__r.ccrz__LeadTime__c,ccrz__Product__r.cc_oo_UoMDesc__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Order__r.cc_oo_PickUpTime__c from
                                                    ccrz__E_OrderItem__c where ccrz__Order__c =:orderId];
             if(orderItems.size() > 0){
            
                    for(ccrz__E_OrderItem__c cartItem :orderItems){
                         if(cartItem.ccrz__Product__r.ccrz__UnitOfMeasure__c !=null){
                                 String pUOM = cc_oo_pluralUOM__c.getValues(cartItem.ccrz__Product__r.ccrz__UnitOfMeasure__c).plural__c;
                                 cartItem.ccrz__Product__r.cc_oo_UoMDesc__c=pUOM;
                          }
            
                   }
                  dataMap.put('OrderDetailData',orderItems);
           }
            System.debug('dataMap---->'+dataMap);
            
            res.success = true;
            res.data = dataMap;
                
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderConfirmationDetails');
        }
        return res;
     }
     /***************************************************************************************************************************************
      Method Name : getOrderTotalWeight
      Description : getOrderTotalWeight is to get the details on order confirmation page for total weight
      Parameter   : orderId 
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-2690 - Updates to Order Review and Order confirmation pages                                                              

      *************************************************************************************************************************************/
     @RemoteAction
     global static ccrz.cc_RemoteActionResult getOrderTotalWeight(final ccrz.cc_RemoteActionContext ctx, String orderId){
         ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        System.debug('********* In getOrderTotalWeight() method *********');
        res.success = false; 
        Map<String,object> dataMap = new Map<String,object>();
        try{
            List<ccrz__E_OrderItem__c> orderItems = [select ccrz__Quantity__c,ccrz__Product__r.ccrz__ProductWeight__c from ccrz__E_OrderItem__c where ccrz__Order__c =:orderId];
            Decimal aggregateCartOrderWeight = 0;
            for (ccrz__E_OrderItem__c item :orderItems){
                if(item.ccrz__Product__r.ccrz__ProductWeight__c!=null){
                    aggregateCartOrderWeight += ( item.ccrz__Quantity__c * item.ccrz__Product__r.ccrz__ProductWeight__c);
                }
            }
            res.success = true;
            res.data = aggregateCartOrderWeight;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getOrderTotalWeight');
        }
        return res;
     }
}