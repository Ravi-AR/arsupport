global class cc_oo_CartController {
    
    public static final string CLASS_NAME = 'cc_oo_CartController';
    //this is to be moved to HeaderController
    public String cartEncId{get;private set;}
    public String currentUserDisplayName{get;private set;}
    //Property to hold community portal link from custom settings
    //public String commPortalLink {get; set;}
    public String LeadTime {get; set;}

    public cc_oo_CartController() {
        cartEncId = ApexPages.currentPage().getParameters().get('cartId');
        if(!Test.isRunningTest()){
            currentUserDisplayName = ccrz.cc_CallContext.currContact.FirstName + ' ' + ccrz.cc_CallContext.currContact.LastName;         
        }
        else
        {
            currentUserDisplayName = 'Test User';
        }           
    }
    
    //this is to be moved to HeaderController
    /***************************************************************************************************************************************
      Method Name : redirect
      Description : redirect is to get the Product List URL for prebook
      Parameter   : cartId :cartId is encrypted id of Cart,ordertype to indicate that its a prebook flow and 
                    url :base url
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-195 - Display only the pre book products in the online ordering system when placing a pre book order                                                              

                    
      *************************************************************************************************************************************/ 
      
    @RemoteAction
    global static ccrz.cc_RemoteActionResult redirect(final ccrz.cc_RemoteActionContext ctx,String cartId,String url,string sellerId,string shipToId, string refreshCart,String portalUserId, string isSameShipto,string shipToDate){//OO-3252
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;  
        Map<String,Object> dataMap= new Map<String,Object>();
        //OO-520
        // delete amended carts which have not been converted to order  
        List<ccrz__E_Cart__c> amendedCarts = [select id from ccrz__E_Cart__c where cc_oo_AmendedCart__c = true AND ccrz__User__c =: ccrz.cc_CallContext.currUserId AND 
                                                id NOT IN (select ccrz__OriginatedCart__c from ccrz__E_Order__c) ];
        if(!amendedCarts.isEmpty()){
            delete amendedCarts;
        }
         Date shipDate= date.parse(shipToDate);
         system.debug('----------------'+shipDate);
        //OO-215
        string newCartId;
        if(refreshCart == 'true'){
            system.debug('mapToCart-->');
            ccrz__E_Cart__c newActiveCart = cc_oo_HeaderController.mapToCart(sellerId,shipToId, false);
            if(newActiveCart != null){
                if(newActiveCart.ccrz__EncryptedId__c != null){
                    newCartId = newActiveCart.ccrz__EncryptedId__c; 
                    ccrz.cc_CallContext.currCartId = newCartId;  
                }else{
                    newCartId = [select id, ccrz__EncryptedId__c from ccrz__E_Cart__c where id=: newActiveCart.Id].ccrz__EncryptedId__c;
                    ccrz.cc_CallContext.currCartId = newCartId;
                }
                if(newActiveCart.ccrz__RequestDate__c==null){
                    newActiveCart.ccrz__RequestDate__c=shipDate;
                }
                newActiveCart.ccrz__ActiveCart__c = true;
               
                update newActiveCart;
            }

            //Deactive the other carts
            List<ccrz__E_Cart__c> listDeactivateList = new List<ccrz__E_Cart__c>();
            if(newCartId != null && newCartId != ''){
                for(ccrz__E_Cart__c crt: [select id, ccrz__CartStatus__c, ccrz__ActiveCart__c, ccrz__EncryptedId__c from ccrz__E_Cart__c where 
                            ccrz__Account__c =: ccrz.cc_CallContext.currAccountId and ccrz__EncryptedId__c !=: newCartId and ccrz__ActiveCart__c = true]){
                    crt.ccrz__ActiveCart__c = false;
                    listDeactivateList.add(crt);

                }
                system.debug('listDeactivateList--->' + listDeactivateList);
                if(listDeactivateList.size() > 0){
                    update listDeactivateList;
                    system.debug('listDeactivateList--->' + listDeactivateList);
                }
                 Date primaryShipTo= newActiveCart.ccrz__RequestDate__c;
                if(primaryShipTo==null){
                    primaryShipTo=shipDate;
                }
                dataMap=cc_oo_HelperController.shuffleCart(newCartId,shipToDate,null,false);
            }
            cartId = newCartId;

        }
        //OO-215

        ccrz__E_Category__c categoryRoots = [select Id from ccrz__E_Category__c where Name = 'Prebook' LIMIT 1];
        //Fetch the category id for Category 'Prebook'
        if(categoryRoots!=null && categoryRoots.id != null){
             String urlName=getProductListURL(categoryRoots.id,cartId,url ,sellerId,portalUserId,isSameShipto);//OO-3252
            res.data=urlName;
            return res;
        }
        else {
            return null;
        } 
    }
    
    //this is to be moved to HeaderController
    //US - 205, 210 - To add promotion code and prevent commitment on existing shipto 
    //Method to get the productListUrl
    //US - 141- To redirect to homepage in case of OO.
    public static String getProductListURL(Id categoryId,String cartId,String url,string sellerId,String portalUserId, string isSameShipto){//OO-3252

        system.debug('Ship to  boolean-->' + isSameShipto);
        string csrFlow = ccrz.cc_CallContext.currPageParameters.get('isCSRFlow');
        string csrParam = '';
        String returnurl = '';
        if(String.isNotBlank(csrFlow) && csrFlow == 'true'){
            csrParam = 'true';
        }
        /*if(orderType != null && orderType.toLowerCase()==('Prebook').toLowerCase()) { 
            if(portalUserId==null){
                returnurl = url+'/ccrz__Products?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
               if(csrParam == 'true'){
                    returnurl += '&isCSRFlow='+csrParam;    
               }
               returnurl += '&portalUser=&store=&cclcl=en_US&sid='+sellerId+'&isSameShipto='+isSameShipto;//OO-3252
               return +returnurl;
            } else {
               returnurl = url+'/ccrz__Products?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
                if(csrParam == 'true'){
                    returnurl += '&isCSRFlow='+csrParam;    
               }
               returnurl += '&portalUser='+portalUserId+'&store=&cclcl=en_US&orderType='+orderType+'&promotionCode='+promotionCode+'&sid='+sellerId+'&isSameShipto='+isSameShipto;
               return +returnurl;   
            }
        } else {*/
         if(portalUserId==null){
               returnurl = url+'/ccrz__HomePage?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
               if(csrParam == 'true'){
                    returnurl += '&isCSRFlow='+csrParam;    
               }
               returnurl += '&portalUser=&store=&cclcl=en_US&sid='+sellerId+'&isSameShipto='+isSameShipto;//OO-3252
               return +returnurl;
            } else {
                returnurl = url+'/ccrz__HomePage?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
                if(csrParam == 'true'){
                    returnurl += '&isCSRFlow='+csrParam;    
               }
               returnurl += '&portalUser='+portalUserId+'&store=&cclcl=en_US&sid='+sellerId+'&isSameShipto='+isSameShipto;//OO-3252
               return +returnurl;   
            }
        
    }
    
    //this is to be moved to CartIncRDController,here also
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
            return res;
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCartType');
              return null;
        }
       
    } 
    
    /************************************************************************************************************************
      Method Name : getMinQualtity
      Description : getMinQualtity is to fetch suggested quantities for products
      Parameter   :  
                    
      Return type : 
      UserStory   : 
                    
      *************************************************************************************************************************/ 
    
   /* @RemoteAction
    global static ccrz.cc_RemoteActionResult getMinQualtity(ccrz.cc_RemoteActionContext ctx, String[] itemToUpdate) {
       //itemToUpdate= itemToUpdate + 'asd';
       System.debug('item to update'+itemToUpdate[0]);
       Map<string, List<string>> productDetail=new Map<string,List<string>>();
       
       ccrz.cc_CallContext.initRemoteContext(ctx);
       ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
      
       res.success = true;
       res.Data = itemToUpdate;
       return res;
    } */
    
    //This is to be moved to CartIncRDController
    /***************************************************************************************************************************************
      Method Name : validateOrderMinimumWeight
      Description : validateOrderMinimumWeight is to validate whether the Preorder minimum weight is more than the minimum weight limit
      Parameter   : cartId 
                    cartId is used to store id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-202 - Ability to validate the quantities in the shopping cart page with the minimum order weight for pre book orders
                    
      *************************************************************************************************************************************/ 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult validateOrderMinimumWeight(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        
        try
        {  
            List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__c, ccrz__Product__r.Id, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
            
            Map<ID, Decimal> productQuantityMap = new Map<ID, Decimal>();
            Map<ID, Decimal> productWeightMap = new Map<ID, Decimal>();
                for (ccrz__E_CartItem__c item :cartItemList){
                    productQuantityMap.put(item.ccrz__Product__r.Id, item.ccrz__Quantity__c);
                    productWeightMap.put(item.ccrz__Product__r.Id, item.ccrz__Product__r.ccrz__ProductWeight__c);
                }
                System.debug('product ID quantity map' + productQuantityMap);
                System.debug('product ID weight map' + productWeightMap);
            
            Decimal aggregateCartOrderWeight = 0;           
            for (ID cartProductId : productQuantityMap.keySet()) {
                for(ID productListId : productWeightMap.keySet()) {
                    if(cartProductId == productListId) {
                        aggregateCartOrderWeight += (productQuantityMap.get(cartProductId) * productWeightMap.get(productListId));
                    }
                }
            }
      
            // Conversion of product weight in lbs to tonne
            Decimal aggregateCartOrderWeightInTonne = aggregateCartOrderWeight * 0.0005;          
            Decimal requiredWeightInLbs = (1 - aggregateCartOrderWeightInTonne) * 2000;  
                    
            cc_oo_prebook_minimum_weight__c minimumWeight = cc_oo_prebook_minimum_weight__c.getValues('prebook_minimum_weight');            
           
            if(aggregateCartOrderWeightInTonne >= minimumWeight.prebook_minimum_weight__c) {
                    res.success = true;                   
            } else {
                res.data = requiredWeightInLbs.round(); 
            }
            return res;
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'validateOrderMinimumWeight');
        }
        return null;
    }
            
    //This needs to be moved to HeaderController,CartIncRDController
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
            List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__c, ccrz__Product__r.Id, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId];
            
           // Map<ID, Decimal> productQuantityMap = new Map<ID, Decimal>();
           //Map<ID, Decimal> productWeightMap = new Map<ID, Decimal>();
        Decimal aggregateCartOrderWeight = 0;
                for (ccrz__E_CartItem__c item :cartItemList){
                    //productQuantityMap.put(item.ccrz__Product__r.Id, item.ccrz__Quantity__c);
                    //productWeightMap.put(item.ccrz__Product__r.Id, item.ccrz__Product__r.ccrz__ProductWeight__c);
            if(item.ccrz__Product__r.ccrz__ProductWeight__c != null)
                {
                    aggregateCartOrderWeight += ( item.ccrz__Quantity__c * item.ccrz__Product__r.ccrz__ProductWeight__c);
                }



                }
               // System.debug('product ID quantity map' + productQuantityMap);
               // System.debug('product ID weight map' + productWeightMap);
            
            /*Decimal aggregateCartOrderWeight = 0;           
            for (ID cartProductId : productQuantityMap.keySet()) {
                for(ID productListId : productWeightMap.keySet()) {
                    if(cartProductId == productListId) {
                        aggregateCartOrderWeight += (productQuantityMap.get(cartProductId) * productWeightMap.get(productListId));
                
                    }
                }
            }*/
            
            res.data=aggregateCartOrderWeight;                    
            return res;
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getTotalWeight');
        }
        return null;
    }
    
    
    //this is to be moved to HeaderComponent
    /***************************************************************************************************************************************
      Method Name : getCartItems
      Description : getCartItems is to get the count of unique cart items
      Parameter   : cartId 
                    cartId is used to encrypted id of Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-492 - write a program to view the total weight of an order under the header                                                              

                    
      *************************************************************************************************************************************/ 
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCartItems(final ccrz.cc_RemoteActionContext ctx, string cartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        {  
            Set<ID> products= new Set<ID>();
            List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId];
            for(ccrz__E_CartItem__c cart:cartItemList){
                products.add(cart.ccrz__Product__c);
            }
            res.data=products.size();                    
            return res; 
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCartItems');
        }
        return null;
    }
    
    //this is to be moved to HeaderController
    //OO-215 - Shipto PLant selection
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getShipTos(final ccrz.cc_RemoteActionContext ctx){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        Id accountId = ccrz.cc_CallContext.currAccountId;
        Id contactId = ccrz.cc_CallContext.currContact.Id;
        Account currentAccount = ccrz.cc_CallContext.currAccount;
        
        Set<id> accountIds = new Set<id>();
        Id dealerAccountId = null;
        for(AccountContactRelation acctContRel : [SELECT AccountId,ContactId,Id,IsActive, Account.ParentId
                      FROM AccountContactRelation where ContactId =: contactId and IsActive = true]){
            
            if(acctContRel.Account.ParentId == null){
                dealerAccountId = acctContRel.AccountId;
                break;
            }else{
                accountIds.add(acctContRel.AccountId);
            }

        }  
        system.debug('accountIds-->' + accountIds);
        system.debug('dealerAccountId-->' + dealerAccountId);
         //US-970 for active Ship to's 
        string accountQueryString = 'SELECT id, AccountNumber, SHIPPINGSTREET, SHIPPINGCITY, SHIPPINGSTATE, SHIPPINGPOSTALCODE, SHIPPINGCOUNTRY, SHIPPINGSTATECODE, ParentId from Account where ShipTo_Flag__c = true AND IsActive__c= true AND ';      
        if(dealerAccountId != null){
            accountQueryString += '(parentid =: dealerAccountId OR id =: dealerAccountId)';

        }else if(accountIds.size() > 0){
            accountQueryString += 'id IN: accountIds';
        }else{
             accountQueryString += 'id =: currentAccount.Id';
        }
        
        system.debug('accountQueryString--->' + accountQueryString);
        
        List<sObject> listOfsobjAccounts = Database.query(accountQueryString);

        system.debug('listOfsobjAccounts-> ' +listOfsobjAccounts);
        String EMPTY = '';
        List<cc_oo_ShipToBean> listOfShipTos = new List<cc_oo_ShipToBean>();
        for(sObject accSobject : listOfsobjAccounts){
            Account acct = (Account) accSobject;
            cc_oo_ShipToBean shipTo = new cc_oo_ShipToBean();
            shipTo.shipToId = acct.AccountNumber;
            //shipTo.shipToCode = addrBookItem.ccrz__AddressBookId__c;
            //shipTo.shipToName = addrBookItem.Name;
            //shipTo.shipToFirstName = addrBookItem.ccrz__E_ContactAddress__r.ccrz__FirstName__c;
            //shipTo.shipToLastName = addrBookItem.ccrz__E_ContactAddress__r.ccrz__LastName__c;
            //shipTo.shipToAddresLine1 = addrBookItem.ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c;
            //shipTo.shipToAddresLine1 = addrBookItem.ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c;
            //shipTo.shipToAddresLine2 = addrBookItem.ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c;
            shipTo.shipToStreet = acct.SHIPPINGSTREET;
            shipTo.shipToCity = acct.SHIPPINGCITY;
            shipTo.shipToState = acct.SHIPPINGSTATE;
            shipTo.shipToCountry = acct.SHIPPINGCOUNTRY;
            shipTo.shipToPostalCode = acct.SHIPPINGPOSTALCODE;
            //US - 143 - to implement filter
            shipTo.consolidateShipto = (acct.AccountNumber == null ? EMPTY : acct.AccountNumber) +' ' + (acct.SHIPPINGSTREET == null ? EMPTY : acct.SHIPPINGSTREET) + ',' + (acct.SHIPPINGCITY == null ? EMPTY : acct.SHIPPINGCITY) +',' + (acct.SHIPPINGSTATE == null ? EMPTY : acct.SHIPPINGSTATE) + ' ' + (acct.SHIPPINGCOUNTRY == null ? EMPTY : acct.SHIPPINGCOUNTRY) + '-' + (acct.SHIPPINGPOSTALCODE == null ? EMPTY : acct.SHIPPINGPOSTALCODE);
            
            listOfShipTos.add(shipTo);
        }
        
        if(listOfShipTos.size() > 0){
            res.data = listOfShipTos;            
            res.success = true;
            return res;
        }
        
        return null;
        
    }
    
    //this is to be moved to HeaderController
    //OO-215 - Shipto PLant selection 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getSellers(final ccrz.cc_RemoteActionContext ctx,  String shipToCode){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true; 
        integer shipToCodeNumber = Integer.valueOf(shipToCode);
        List<cc_oo_SellerBean> listSellers = new List<cc_oo_SellerBean>();                            
    //OO-81 The address must be listed for each plant available in the plant selection screen.  
    map<string, CC_OO_Customer_Freight__c> mapUniqueFreights = new map<string,CC_OO_Customer_Freight__c>();
        for(CC_OO_Customer_Freight__c sellerFreight: [select id, name, Plant_Name__c, Plant_Name__r.id, Plant_Name__r.Name,
                            Plant_Name__r.ccrz__Storefront__c, Plant_Name__r.ccrz__SellerId__c, Plant_Name__r.ccrz__ShortDesc__c, 
                            Plant_Name__r.cc_oo_Address_Line_1__c,Plant_Name__r.cc_oo_Address_Line_2__c,Plant_Name__r.cc_oo_City__c,Plant_Name__r.cc_oo_State__c,Plant_Name__r.cc_oo_Zip__c
                            from CC_OO_Customer_Freight__c where ShipTo_Account_Number__c =: shipToCodeNumber and 
                            Plant_Name__r.ccrz__Storefront__c = 'PurinaMills' and Plant_Name__r.ccrz__Enabled__c = true]){
                            
                            mapUniqueFreights.put(sellerFreight.Plant_Name__r.ccrz__SellerId__c,sellerFreight);
        }  
        
        String EMPTY = '';                         
        for(CC_OO_Customer_Freight__c sellerFreigtItem : mapUniqueFreights.values()){

            cc_oo_SellerBean newSeller = new cc_oo_SellerBean();
            newSeller.sellerSFId = sellerFreigtItem.Plant_Name__r.id;
            newSeller.sellerId = sellerFreigtItem.Plant_Name__r.ccrz__SellerId__c;
            newSeller.sellerName = sellerFreigtItem.Plant_Name__r.Name;
            newSeller.sellerShortDesc = sellerFreigtItem.Plant_Name__r.ccrz__ShortDesc__c;
            //OO-81 The address must be listed for each plant available in the plant selection screen.  
            newSeller.sellerAddresLine1 = sellerFreigtItem.Plant_Name__r.cc_oo_Address_Line_1__c;
            newSeller.sellerAddresLine2 = sellerFreigtItem.Plant_Name__r.cc_oo_Address_Line_2__c;
            newSeller.sellerCity = sellerFreigtItem.Plant_Name__r.cc_oo_City__c;
            newSeller.sellerState = sellerFreigtItem.Plant_Name__r.cc_oo_State__c;
            newSeller.sellerPostalCode = sellerFreigtItem.Plant_Name__r.cc_oo_Zip__c;
            //US - 143 - to implement filter
            newSeller.consolidateSeller = (newSeller.sellerId == null ? EMPTY : newSeller.sellerId) +' ' + (newSeller.sellerName == null ? EMPTY : newSeller.sellerName) + ' ' ;
            newSeller.consolidateSeller += (newSeller.sellerAddresLine1 == null ? EMPTY : newSeller.sellerAddresLine1) + ',' + (newSeller.sellerAddresLine2 == null ? EMPTY : newSeller.sellerAddresLine2) + ',' + (newSeller.sellerCity == null ? EMPTY : newSeller.sellerCity) +',' + (newSeller.sellerState == null ? EMPTY : newSeller.sellerState) +',';
            newSeller.consolidateSeller += (newSeller.sellerPostalCode ==  null ? EMPTY : newSeller.sellerPostalCode);
            listSellers.add(newSeller);
        } 
        
        //OO-210 - Start - To prevent user from creating more than one prebook commitment for same ship-to 
        system.debug('Shp to code-->' + shipToCode);
        Id userId = ccrz.cc_CallContext.currUser.Id; 
        system.debug('Logged User-->' + userId );                  
        List<ccrz__E_Order__c> orderDetails = [SELECT Id, ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.cc_oo_ShipToAccount__c,ccrz__ShipTo__c  from ccrz__E_Order__c WHERE ccrz__OriginatedCart__c IN (SELECT Id FROM ccrz__E_Cart__c WHERE cc_oo_ShipToAccount__r.AccountNumber =:shipToCode) AND ccrz__User__c =:userId ];
        system.debug('order details-->' + orderDetails );
        
        if(orderDetails.size() > 0){
        system.debug('order shipto -->' + orderDetails[0].ccrz__ShipTo__c);
          if(orderDetails[0] != null && orderDetails[0].ccrz__ShipTo__c  != null) {
              //ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message('A prebook commitment exists for this ship to. Please select a different ship to.',ccrz.cc_bean_Message.MessageSeverity.WARN);
              //msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;         
              //messageList.add(msg);
              // Return success false when record exists for the same shipto
              res.success = false;
          } else {
              res.success = true;
          } 
        }
        
        //OO-210 - End                              
        //OO-892 Delete cart items for other cart for which we dont have the orders
       if(orderDetails.size() > 0){
            Id activeCart = orderDetails[0].ccrz__OriginatedCart__c;
            Id shippingAccount = orderDetails[0].ccrz__OriginatedCart__r.cc_oo_ShipToAccount__c;
            List<ccrz__E_CartItem__c> listCartItemsToDelete = new List<ccrz__E_CartItem__c>();
            for(ccrz__E_Cart__c cartItem: [select id,(select id from ccrz__E_CartItems__r) from ccrz__E_Cart__c where id !=: activeCart and cc_oo_ShipToAccount__c =: shippingAccount and ccrz__CartStatus__c != 'Closed' 
                                                and cc_oo_CartType__c = 'Prebook'
                                                ]){
                listCartItemsToDelete.addAll(cartItem.ccrz__E_CartItems__r);
            }

            if(listCartItemsToDelete.size() > 0){
                delete listCartItemsToDelete;
            }
        }
        //OO-892 Delete cart items for other cart for which we dont have the orders                            

        if(listSellers.size() > 0){
            res.data = listSellers;            
            //res.success = true;
            return res;
        }
        else {
            return null;
        } 
    }
    
    //this is to be moved to HeaderController
    //OO-215 - Bean for the ShipTo
    public class cc_oo_ShipToBean {
        public String shipToId{get; set;}
        public String shipToStreet{get; set;}
        public String shipToCity{get; set;}
        public String shipToState{get; set;}
        public String shipToCountry{get; set;}
        public String shipToPostalCode{get; set;}
        //US - 143 - to implement filter
        public String consolidateShipto{get; set;}
    }
    
    //this is to be moved to HeaderController
    //OO-215 - Bean for the ShipTo
    public class cc_oo_SellerBean {
        public String sellerSFId{get; set;}
        public String sellerId{get; set;}
        public String sellerName{get; set;}
        public String sellerShortDesc{get; set;}
        //OO-81 The address must be listed for each plant available in the plant selection screen.  
        public String sellerAddresLine1{get; set;}
        public String sellerAddresLine2{get; set;}
        public String sellerCity{get; set;}
        public String sellerState{get; set;}
        public String sellerPostalCode{get; set;}
        //US - 143 - to implement filter
        public String consolidateSeller{get; set;}
    }
    
    //this is to be moved to HeaderController
    //OO-215 - Bean for the ShipTo
    public class cc_oo_ShipToSellerBean {
        public String sellerName{get; set;}
        public String shipToName{get; set;}
        public String shipToId{get; set;}
        public String sellerId{get; set;}
    }
    
    //this is to be moved to HeaderController
    //OO-215 - Shipto PLant selection 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getShipToSellerInfo(final ccrz.cc_RemoteActionContext ctx,  String selectedSellerSFID, string selectedShipTo, string encCartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;
        cc_oo_ShipToSellerBean shipToSeller = new cc_oo_ShipToSellerBean();
        
        if(selectedShipTo != null && selectedShipTo != ''){
            List<Account> listAccount = [select Id, Name,accountNumber from Account where accountNumber =: selectedShipTo];
            if(listAccount.size() > 0){

                shipToSeller.shipToId = listAccount[0].accountNumber;
                string shipToName = listAccount[0].Name;
                //OO-1341 - Appending Account Number for Ship To
                if(listAccount[0].accountNumber != null && listAccount[0].accountNumber != ''){
                    if(!shipToName.contains(listAccount[0].accountNumber)){
                        shipToName = shipToName + '-' + listAccount[0].accountNumber;
                    }
                }
                shipToSeller.shipToName = shipToName;
            }
        }

        if(selectedSellerSFID != null && selectedSellerSFID != ''){
            List<ccrz__E_Seller__c> listSeller = [select Id, Name from ccrz__E_Seller__c where id =: selectedSellerSFID];
            if(listSeller.size() > 0){
                shipToSeller.sellerId = listSeller[0].Id;
                shipToSeller.sellerName = listSeller[0].Name;
            }
        }

        if(encCartId != null && encCartId != 'null'){
            List<ccrz__E_Cart__c> listCart = new List<ccrz__E_Cart__c>();
            //if(shipToSeller.sellerName == null || shipToSeller.shipToName == null){ 
                listCart = [select id,   cc_oo_Seller__c, cc_oo_Seller__r.Name, cc_oo_ShipToAccount__c,cc_oo_ShipToAccount__r.Name, cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c =: encCartId];
                if(listCart.size() > 0){
                    shipToSeller.sellerId = listCart[0].cc_oo_Seller__c;
                    if(listCart[0].cc_oo_Seller__c != null){
                        shipToSeller.sellerName = listCart[0].cc_oo_Seller__r.Name;
                    }
                    if(listCart[0].cc_oo_ShipToAccount__c != null){
                        
                        shipToSeller.shipToId = listCart[0].cc_oo_ShipToAccount__r.AccountNumber;
                        string shipToName = listCart[0].cc_oo_ShipToAccount__r.Name;
                        //OO-1341 - Appending Account Number for Ship To
                        if(listCart[0].cc_oo_ShipToAccount__r.AccountNumber != null && listCart[0].cc_oo_ShipToAccount__r.AccountNumber != ''){
                            if(!shipToName.contains(listCart[0].cc_oo_ShipToAccount__r.AccountNumber)){
                                shipToName = shipToName + '-' +listCart[0].cc_oo_ShipToAccount__r.AccountNumber;
                            }
                        }
                        shipToSeller.shipToName = shipToName;
                    }
                }
            //}
        }
        res.data = shipToSeller;
        return res;
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getVfdFlag(final ccrz.cc_RemoteActionContext ctx,list<String> sfid){
    ccrz.cc_CallContext.initRemoteContext(ctx);
    ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
    res.success= true;
    System.debug('*********************************************hello im here********************************************');
    //creating a map to store flag variable corresponding to the id's retrieved
    Map<String,boolean> vfdCheckFlag=new Map<String,boolean>();         
    list<ccrz__E_Product__c> vfdFlag=[Select p.Id,p.ccrz__HazardousFlag__c From ccrz__E_Product__c p WHERE p.Id IN :sfid]; 
    system.debug(vfdFlag);
    for(ccrz__E_Product__c prod1:vfdFlag)
    {
        vfdCheckFlag.put(prod1.Id,prod1.ccrz__HazardousFlag__c);
    }
    res.data=vfdCheckFlag;
    return res;
    }
    

    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult PurchaseOrderNumber(final ccrz.cc_RemoteActionContext ctx,string cartid,string purchaseorder)
    {   System.debug('*******in purchase method************');
        ccrz.cc_CallContext.initRemoteContext(ctx);
            ccrz.cc_RemoteActionResult resp = new ccrz.cc_RemoteActionResult();
            resp.success = false;
            
        try
        {   System.debug('*******in try block of method************');
            ccrz__E_PaymentDetail__c paymentdetail=new ccrz__E_PaymentDetail__c();
            if(purchaseorder<> null && purchaseorder<>''){
                paymentdetail.ccrz__Account_Number__c=purchaseorder;
                paymentdetail.ccrz__Cart__c=cartid;
                insert paymentdetail;
                System.debug('*******exiting try block of method************');
            }
            resp.success=true;
            return resp;
        }
        catch (Exception err)
            {
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',err.getMessage());
            }
        finally{
                ccrz.ccLog.close(resp);
            }
        return null;
    }*/
     
    /***************************************************************************************************************************************
    Method Name : getProductInventoryDtls
    Description : getProductInventoryDtls is to get the ProductInventoryDtls for corresponding products
    Parameter   : cartId ,  sellerId 
            cartId is the list of product Ids
    Return type : Returns ccrz.cc_RemoteActionResult.
    UserStory   : OO-49 -Allow for product minimum quantities and pallet increments.                                                               

            
    *************************************************************************************************************************************/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductInventoryDtls(final ccrz.cc_RemoteActionContext ctx, String cartId){

        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        List<String> prdlst=new List<String>();
		Set<Id> productIdList = new Set<Id>();
		Set<Id> productIdContract = new Set<Id>();
        List<String> prodwithFullPalletReq=new List<String>();
        try
        {   
            Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            String sellerId =   null;
            Boolean isAmendedCart=false;//US-OO-2339
            String accountID=ccrz.cc_CallContext.currAccountId;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
            //US-OO-2339-start
            ccrz__E_Cart__c cart=[select cc_oo_AmendedCart__c from ccrz__E_Cart__c where id=:cartId];
            if(cart!=null){
                isAmendedCart=cart.cc_oo_AmendedCart__c==true?true:false;
            }//US-OO-2339-end
            Map<String, Object> dataMap = new Map<String, Object>();
            Map<String,ccrz__E_ProductInventoryItem__c> PrdInvItemMap=new Map<String,ccrz__E_ProductInventoryItem__c>();
            Map<String,Object> PrdInvMap;
            ccrz__E_ProductInventoryItem__c PrdInvItem=new ccrz__E_ProductInventoryItem__c();
            List<ccrz__E_CartItem__c > cartList=[select ccrz__Product__r.Id,ccrz__Product__r.cc_oo_TypeOfProduct__c,id,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.ccrz__ProductId__c,ccrz__Quantity__c,
                                                cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,cc_oo_ContractPrice__r.cc_oo_QuantityUpdateDate__c,
                                                cc_oo_ContractPrice__r.cc_oo_AvailabilityQty__c,cc_oo_ContractPrice__r.cc_oo_ContractUoM__c,cc_oo_ContractPrice__r.cc_oo_ContractUoMDesc__c,
                                                cc_oo_ContractPrice__r.cc_oo_AvailabilityQtyUoMContract__c,cc_oo_ContractPrice__r.cc_oo_ContractNumber__c,
                                                cc_oo_ContractPrice__r.cc_oo_EffectiveDate__c,cc_oo_ContractPrice__r.cc_oo_ExpireDate__c,cc_oo_ContractPrice__r.cc_oo_EndUserName__c
                                                from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId];
            String numOfPallet='';
            Integer quantity,palletSize;
            Boolean isRemainder=false;
            if(cartList!=null && cartList.size()>0){
                for(ccrz__E_CartItem__c cartItemlst:cartList){
                    prdlst.add(cartItemlst.ccrz__Product__r.Id);//1719
                    if(cartItemlst.cc_oo_IsListPrice__c) {
						productIdList.add(cartItemlst.ccrz__Product__r.Id);
					} else {
						productIdContract.add(cartItemlst.ccrz__Product__r.Id);
					}
                }
            }
            List<ccrz__E_ProductInventoryItem__c> prdInvItm=cc_oo_HelperController.getProductInventoryItemDetails(prdlst,sellerId);
            List<cc_oo_PriceList__c> listPalletPrice=[select cc_oo_Product__r.ccrz__SKU__c,cc_oo_NetListPrice__c,cc_oo_PalletPrice__c,cc_oo_isfreightincluded__c from cc_oo_PriceList__c where cc_oo_Product__r.Id IN:prdlst and cc_oo_Seller__c=:sellerId and cc_oo_ShipTo__c=:accountID];                                                 
            List<cc_oo_ContractPrice__c> listContractPrice = new List<cc_oo_ContractPrice__c>();
            
            if(productIdContract != null && !productIdContract.isEmpty()) {
				listContractPrice=[select cc_oo_Product__r.ccrz__SKU__c,cc_oo_isfreightincluded__c,Name 
						from cc_oo_ContractPrice__c where cc_oo_Product__r.Id IN:productIdContract 
						and cc_oo_Seller__c=:sellerId and cc_oo_ShipToNumber__c=:accountID];
			}
            
            Map<String,Decimal> skuPalletitem =new Map<string,Decimal>();
            
            Map<String,Decimal> priceMap=new Map<String,Decimal>();
            
           
            if(listPalletPrice!=null && listPalletPrice.size()>0){
                 
                 for(cc_oo_PriceList__c skuItem:listPalletPrice){
                    skuPalletitem.put(skuItem.cc_oo_Product__r.ccrz__SKU__c,skuItem.cc_oo_PalletPrice__c);
                    priceMap.put(skuItem.cc_oo_Product__r.ccrz__SKU__c,skuItem.cc_oo_NetListPrice__c);
                 }
            }
            if(prdInvItm!=null && prdInvItm.size()>0){
                for(ccrz__E_ProductInventoryItem__c prodInvItmLst:prdInvItm){
                    if(prodInvItmLst.cc_oo_IsOnlyPalletProduct__c ){
                     if(prodInvItmLst.CC_OO_MinQuantity__c!=null && prodInvItmLst.cc_oo_PalletSize__c!=null){
                        
                        prodInvItmLst.ccrz__QtyAvailable__c=prodInvItmLst.CC_OO_MinQuantity__c>prodInvItmLst.cc_oo_PalletSize__c?prodInvItmLst.CC_OO_MinQuantity__c:prodInvItmLst.cc_oo_PalletSize__c;
                     }else{
                        prodInvItmLst.ccrz__QtyAvailable__c=prodInvItmLst.cc_oo_PalletSize__c;
                     }
                        String prdId=prodInvItmLst.ccrz__ProductItem__r.ccrz__ProductId__c;
                    }else{
                        prodInvItmLst.ccrz__QtyAvailable__c=prodInvItmLst.CC_OO_MinQuantity__c;
                    }

                    PrdInvItemMap.put(prodInvItmLst.ccrz__ProductItem__r.ccrz__SKU__c,prodInvItmLst);
                 }
            }
            if(cartList!=null && cartList.size()>0){
                //String PriceSave=''; 
                String lastUpdated='';
                for(ccrz__E_CartItem__c cartProdItem:cartList){
                    numOfPallet ='';//OO-1920 
                    String typeOfProduct=cartProdItem.ccrz__Product__r.cc_oo_TypeOfProduct__c;
                    Boolean isListPrice =cartProdItem.cc_oo_IsListPrice__c;
                    PrdInvMap=new Map<String,Object>();
                    if(listPalletPrice.size() != 0 && !listPalletPrice.isEmpty()) {
						for(cc_oo_PriceList__c priceList : listPalletPrice) {
							if(cartProdItem.ccrz__Product__r.ccrz__SKU__c.equals(priceList.cc_oo_Product__r.ccrz__SKU__c) 
									&& cartProdItem.cc_oo_IsListPrice__c) {
								PrdInvMap.put('isfreightincluded', priceList.cc_oo_isfreightincluded__c);
							}
						}
					}
					
					if(listContractPrice.size() != 0 && !listContractPrice.isEmpty()) {
						for(cc_oo_ContractPrice__c contractList : listContractPrice) {
							if(cartProdItem.ccrz__Product__r.ccrz__SKU__c.equals(contractList.cc_oo_Product__r.ccrz__SKU__c) 
									&& !cartProdItem.cc_oo_IsListPrice__c && cartProdItem.cc_oo_ContractPrice__r.Name == contractList.Name) {
								PrdInvMap.put('isfreightincluded', contractList.cc_oo_isfreightincluded__c);
							}
						}
					}
                    
                    if(cartProdItem.cc_oo_ContractPrice__c!=null && cartProdItem.cc_oo_ContractPrice__r.cc_oo_QuantityUpdateDate__c!=null){
                    String lastModified=String.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_QuantityUpdateDate__c);
                    DateTime myFinalDate = DateTime.valueOf(lastModified);
                    lastUpdated=myFinalDate.format('MM/dd/YYYY HH:mm');
                    }
                    String productSku=cartProdItem.ccrz__Product__r.ccrz__SKU__c;
                    
                    if(cartProdItem.ccrz__Quantity__c!=null){
                        quantity=Integer.valueOf(cartProdItem.ccrz__Quantity__c);
                    }
                    if(PrdInvItemMap.get(productSku).cc_oo_PalletSize__c!=null){
                        palletSize=Integer.valueOf(PrdInvItemMap.get(productSku).cc_oo_PalletSize__c);
                    }
                    String UOM=PrdInvItemMap.get(productSku).ccrz__ProductItem__r.ccrz__UnitOfMeasure__c;
                    String pUOM = cc_oo_pluralUOM__c.getValues(UOM).plural__c;
                    //Decimal savePrice= priceMap.get(productSku);
                    Boolean isOnlyPallet=PrdInvItemMap.get(productSku).cc_oo_IsOnlyPalletProduct__c;
                    Integer palletForBags=0;
                    Integer Quotient;
                    String contractNumber;
                    String CheckIsListPrice,expiry_Date,effective_Date,jdeEndUser;
                    isRemainder=false;
                    if(isListPrice){
                        CheckIsListPrice='true';
                        contractNumber=null;
                    }
                    else{
                        CheckIsListPrice='false';   
                        contractNumber =String.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
                        expiry_Date = String.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_ExpireDate__c);
                        jdeEndUser = String.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_EndUserName__c);
                        Date Myexpiry_Date = Date.valueOf(expiry_Date);
                        expiry_Date=Myexpiry_Date.format();
                        effective_Date =String.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_EffectiveDate__c);
                        Date Myeffective_Date = Date.valueOf(effective_Date);
                        effective_Date=Myeffective_Date.format();
                    }
                   // US-969 Upselling
                    Decimal errPalletPrice=skuPalletitem.get(productSku);
                    
                    Integer diffQuantity=0;
                     if(palletSize != null && palletSize!=0){   //  US:967 the user will see the price savings message on cart page.                             
                                if(typeOfProduct=='BAG'){
                                    Quotient = Integer.valueOf(quantity/palletSize);
                                    Integer rem =math.mod(quantity, palletSize); 
                                    if(!isOnlyPallet){
                                        if(isListPrice){
                                            if(rem!=0){
                                                if(quantity<palletSize){
                                                    diffQuantity=palletSize-quantity;
                                                }
                                                else{
                                                    diffQuantity=palletSize-rem;
                                                }
                                                if(diffQuantity<=(0.5*palletSize)){
                                                        PrdInvMap.put('diffQuantity',string.valueOf(diffQuantity));
                                                        PrdInvMap.put('palletValue',string.valueOf(errPalletPrice));
                                                }
                                                 
                                             }   
                                            if(rem==0){
                                                Decimal palletPrice=skuPalletitem.get(productSku);
                                                Decimal listPrice=priceMap.get(productSku);
                                                //Decimal priceSaveNumber=listPrice-palletPrice;
                                                //PriceSave=string.valueOf(priceSaveNumber);
                                                isRemainder=true;
                                                }
                                            }
                                        }
                                    }
                           // if(UOM =='Bags' || UOM =='BG' || UOM =='BAG')
                           if(typeOfProduct =='BAG' || typeOfProduct== 'BULK' || typeOfProduct =='LIQUID'){ 
                            if(quantity>=palletSize){
                                   palletForBags=Quotient;
                                }
                            system.debug(palletForBags);
                            if(palletForBags!=0){
                                numOfPallet ='('+palletForBags+' Pallet)';
                            }}else if(UOM.equals('Pallet') || UOM.equals('pallet')){
                            palletForBags=palletSize*quantity;
                            if(palletForBags!=0){
                                numOfPallet ='('+palletForBags+' Bags)';
                            }
                        }
                    }
                    cc_oo_ContractDetail detail= new cc_oo_ContractDetail();
                    PrdInvMap.put('numOfPallet',numOfPallet);
                    PrdInvMap.put('MinQuantity',PrdInvItemMap.get(productSku).CC_OO_MinQuantity__c);
                    PrdInvMap.put('fullPalletReq',PrdInvItemMap.get(productSku).cc_oo_IsOnlyPalletProduct__c);
                    PrdInvMap.put('MinOrder',PrdInvItemMap.get(productSku).ccrz__QtyAvailable__c);
                    
                    PrdInvMap.put('UOM',UOM);
                    PrdInvMap.put('pUOM',pUOM);
                    PrdInvMap.put('isListPrice',CheckIsListPrice);
                    //PrdInvMap.put('PriceSave',PriceSave);
                    PrdInvMap.put('isRemainder',string.valueOf(isRemainder));
                    PrdInvMap.put('contractNumber',string.valueOf(contractNumber));
                    if(cartProdItem.cc_oo_ContractPrice__c!=null){
                    detail.contractEffectiveDate=effective_Date;
                    PrdInvMap.put('contractExpireDate',expiry_Date);
                    PrdInvMap.put('contractEndUser',jdeEndUser);
                    detail.contractBalance=string.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_AvailabilityQty__c);
                    
                    detail.AvailabilityQtyUoMContract=string.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_AvailabilityQtyUoMContract__c);//2377                    
                    if(String.isNotBlank(detail.AvailabilityQtyUoMContract)) {
                    	detail.contractUom=string.valueOf(cartProdItem.cc_oo_ContractPrice__r.cc_oo_ContractUoMDesc__c);
                    }
                    }
                    
                    if(String.isNotBlank(detail.contractBalance)) {
                    	PrdInvMap.put('UOMDesc',PrdInvItemMap.get(productSku).ccrz__ProductItem__r.cc_oo_UoMDesc__c);//US-2377
                    }
                    PrdInvMap.put('PalletSize',palletSize);
                    PrdInvMap.put('qUOMDesc',PrdInvItemMap.get(productSku).ccrz__ProductItem__r.cc_oo_UoMDesc__c);//US-4408
                    detail.lastUpdated=lastUpdated;
                    PrdInvMap.put('contractDetails',detail);
                    PrdInvMap.put('typeOfProduct',typeOfProduct);
                    dataMap.put('isAmendedCart',isAmendedCart);//US-OO-2339
                    dataMap.put(string.valueOf(cartProdItem.id),PrdInvMap);
                 }
                 System.debug('dataMap -->' + dataMap); 
                 res.success = true;
                 res.data=dataMap;
             }
            return res;
        }catch (Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductInventoryDtls'); 

        }
        return null;
    } 
    public class cc_oo_ContractDetail {
        public String contractEffectiveDate{get; set;}
        public String contractBalance{get; set;}
        public String contractUom{get; set;}
        public String lastUpdated{get; set;}
        public String AvailabilityQtyUoMContract{get;set;}//US-2377
        
        
        
    }

    
    @RemoteAction
     global static ccrz.cc_RemoteActionResult getProductsLeadTime (final ccrz.cc_RemoteActionContext ctx, List<string> productIds){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
        String sellerId =   null;
        if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
        res.success = false; 
        try{
             Map<String, String> dataMap = new Map<String, String>();
             dataMap        =   cc_oo_HelperController.GetLeadTimeforAllProducts(productIds, sellerId);
             res.success    = true; 
             res.data = dataMap;
             return res;
        }
        
        catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductsLeadTime');
              return null;
        }
        return null;
        
        
     }
     
    /***************************************************************************************************************************************
      Method Name : validateContractQuantity
      Description : validateContractQuantity is to validate whether quantity input is graeter or less than contract balance
      Parameter   : cartDetailMap
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1171 - To display message dialog when quantity is greater than contract price.                                                               

                    
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult validateContractQuantity(final ccrz.cc_RemoteActionContext ctx, Map<String, String> cartDetailMap
                                                                                                            , Map<String, String> cartQuantity){
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;   
        System.debug('Inside Validate Contract');  
        
        try{
            
            Map<String, Object> datamap = new Map<String, Object>();
            System.debug('Inside validate Contract');
            String sku;
            String cartId;
            Integer quantity;
            String contractId;
            String isGlobal;
            string shipDate;//OO-1180
            String sellerID; //US - 1278
             
            
            if(cartDetailMap != null && !cartDetailMap.isEmpty()){
                if(cartDetailMap.containsKey('sellerId') && cartDetailMap.get('sellerId') != null) {
                    sellerID = String.valueOf(cartDetailMap.get('sellerId'));
                }
                
                if(cartDetailMap.containsKey('sku') && cartDetailMap.get('sku') != null) {
                    sku = String.valueOf(cartDetailMap.get('sku'));
                }
                
                if(cartDetailMap.containsKey('cartId')){
                    cartId= String.valueOf(cartDetailMap.get('cartId'));
                }
                
                if(cartDetailMap.containsKey('quantity') && cartDetailMap.get('quantity') != null && cartDetailMap.get('quantity') != '') {
                    quantity = Integer.valueOf(cartDetailMap.get('quantity'));
                }
                
                if(cartDetailMap.containsKey('contractId') && cartDetailMap.get('contractId') != null && cartDetailMap.get('contractId') != ''){
                    contractId= String.valueOf(cartDetailMap.get('contractId'));
                }
                
                if(cartDetailMap.containsKey('isGlobal') && cartDetailMap.get('isGlobal') != null){
                    isGlobal= String.valueOf(cartDetailMap.get('isGlobal'));
                }
                //OO-1180
                if(cartDetailMap.containsKey('shipDate') && cartDetailMap.get('shipDate') != null){
                    shipDate= String.valueOf(cartDetailMap.get('shipDate'));
                }//OO-1180
            }
            
            //OO-1180
            Date shipDateFormatted = Date.parse(shipDate);
            if(isGlobal == 'true' && (cartQuantity!= null && !cartQuantity.isEmpty())) {
                
                System.debug('Inside global' + isGlobal + cartQuantity);
                ccrz__E_Cart__c cartDetails = [SELECT c.ccrz__EncryptedId__c,c.Id, ccrz__ShipMethod__c, (SELECT Id, 
                                                        ccrz__Quantity__c,ccrz__Product__r.ccrz__SKU__c,
                                                        cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,
                                                        cc_oo_ContractPrice__r.cc_oo_ContractNumber__c,
                                                        cc_oo_ContractPrice__r.cc_oo_ExpireDate__c,
                                                        cc_oo_ContractPrice__r.cc_oo_EffectiveDate__c,
                                                        cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__SKU__c,
                                                        cc_oo_ContractPrice__r.cc_oo_AvailabilityQty__c,
                                                        ccrz__Price__c
                                                        FROM ccrz__E_CartItems__r) 
                                                       FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartId LIMIT 1];  
               if(cartDetails != null && String.isNotBlank(cartDetails.ccrz__ShipMethod__c) && !cartDetails.ccrz__ShipMethod__c.contains('-')) {
               		cartDetails.ccrz__ShipMethod__c = 'null - '+cartDetails.ccrz__ShipMethod__c.trim();
               		update cartDetails;
               }
                                                       
               List<ccrz__E_CartItem__c> cartitemList = new List<ccrz__E_CartItem__c>();
               Map<string,ccrz__E_CartItem__c> mapContractNames = new map<string,ccrz__E_CartItem__c>();
               Set<String> productIds = new Set<String>();
               for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r) {
                   productIds.add(cartItem.ccrz__Product__r.ccrz__SKU__c);
                   if(!cartItem.cc_oo_IsListPrice__c) {
                        cartitemList.add(cartItem);
                        mapContractNames.put(String.valueOf(cartItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c),cartItem);
                   }        
               }
               
               Map<String, Object> productStatusMap = new Map<String, Object>();
               Map<String, Object> relatedProductsMap = new Map<String, Object>();
               if(!productIds.isEmpty() && String.isNotBlank(sellerID)) {
                    productStatusMap = cc_oo_HelperController.getProductStatus(productIds, sellerID);
                    relatedProductsMap = cc_oo_HelperController.getRelatedProducts(productIds);
               } 
               
               for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r) {
                    //res.success = true;
                    datamap.putAll(cc_oo_HelperController.getProductMsg(productStatusMap, relatedProductsMap, cartItem.ccrz__Product__r.ccrz__SKU__c, cartItem.Id));
               }
               
               //Boolean invalidContract = false;
               for(ccrz__E_CartItem__c contractItem : cartitemList) {
                    String ContractQty = cartQuantity.get(contractItem.Id);
                    String contractGlobal = String.valueOf(contractItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
                    ccrz__E_CartItem__c contract = mapContractNames.get(contractGlobal);
                    /*if(!ContractQty.equals(String.valueOf(contractItem.ccrz__Quantity__c))) {
                        // Show message dialog when contract balance is less than quantity entered
                        if(contract.cc_oo_ContractPrice__r.cc_oo_AvailabilityQty__c < Integer.valueOf(ContractQty)) {
                            res.success = true;
                            datamap.put('sku',contract.cc_oo_ContractPrice__r.cc_oo_Product__r.ccrz__SKU__c);
                            datamap.put('quantity',ContractQty);
                            datamap.put('cartId',contractItem.Id);
                            datamap.put('contractId',contract.cc_oo_ContractPrice__r.Name);
                            //res.data = dataMap;//OO-1180
                        }
                    }*/

                    //if(!invalidContract) {2708
                        if(shipDateFormatted < contract.cc_oo_ContractPrice__r.cc_oo_EffectiveDate__c || shipDateFormatted > contract.cc_oo_ContractPrice__r.cc_oo_ExpireDate__c){
                            //res.success = true;
                            //2708 - STart
                            String contractError = ccrz.cc_CallContext.pageLabels.get('Cart_ContractValidation');
                            if(datamap.isEmpty() || (!datamap.isEmpty() && !datamap.containsKey(contract.Id))) {
                                datamap.put(contract.Id, contractError);
                                //res.success = true;
                            }                          
                            //res.success = true;
                            //datamap.put(contract.cc_oo_ContractPrice__r.Name, false);
                            //datamap.put('shipDateContractValidation',false);
                            //invalidContract = true;
                        }/*else{
                            contractError = true;
                             if(!datamap.isEmpty() && !datamap.containsKey(contract.Id)) {
                                datamap.put(contract.Id, contractError);
                            } 
                            //datamap.put(contract.Id, contractError);
                            //res.success = false;
                            //datamap.put(contract.cc_oo_ContractPrice__r.Name, true);
                            //datamap.put('shipDateContractValidation',true);
                            //2708 - End
                        }*///OO-1180
                    //}2708
                } 
                String priceError = ccrz.cc_CallContext.pageLabels.get('Price_Validation');
                for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r) {
                	if(cartItem.ccrz__Price__c == 0) {
                		datamap.put(cartItem.Id, priceError);
                	}
               	}
                if(!dataMap.isEmpty()) {
                    res.success = true;
                } 
                res.data = dataMap;                                                                   
            }
            
            if(isGlobal == 'false') {
                
                if(String.isNotBlank(sku)) {
                    Set<String> productIds = new Set<String>();
                    productIds.add(sku);
                    
                    Map<String, Object> productStatusMap = new Map<String, Object>();
                    Map<String, Object> relatedProductsMap = new Map<String, Object>();
                    if(String.isNotBlank(sellerID)) {
                        productStatusMap = cc_oo_HelperController.getProductStatus(productIds, sellerID);
                        relatedProductsMap = cc_oo_HelperController.getRelatedProducts(productIds);
                    } 
                    
                    datamap.putAll(cc_oo_HelperController.getProductMsg(productStatusMap, relatedProductsMap, sku, cartId));
                    //res.success = true;
                }
                if(String.isNotBlank(contractId)) {
                    cc_oo_ContractPrice__c contract;
                    Decimal contractNumber = Decimal.valueOf(contractId);
                    contract = [SELECT Id,cc_oo_Product__r.ccrz__SKU__c, cc_oo_EffectiveDate__c,cc_oo_ExpireDate__c,cc_oo_ContractUoMDesc__c, Name  
                                            FROM cc_oo_ContractPrice__c WHERE cc_oo_ContractNumber__c=:contractNumber AND cc_oo_Product__r.ccrz__sku__c = :sku ];
                    
                    if(shipDateFormatted < contract.cc_oo_EffectiveDate__c || shipDateFormatted > contract.cc_oo_ExpireDate__c){
                        String contractError = ccrz.cc_CallContext.pageLabels.get('Cart_ContractValidation');
                        if(datamap.isEmpty() || (!datamap.isEmpty() && !datamap.containsKey(cartId))) {
                            datamap.put(cartId, contractError);
                            //res.success = true;
                        }
                        //datamap.put(cartId, contractError);
                        //res.success = true; 
                    } /*else {
                        contractError = true;
                        if(!datamap.isEmpty() && !datamap.containsKey(cartId)) {
                            datamap.put(cartId, contractError);
                        }
                        //datamap.put(cartId, contractError);
                        //res.success = false; 
                    }*/
                    
                    // Show message dialog when contract balance is less than quantity entered
                    /*if(contract.cc_oo_AvailabilityQty__c < Integer.valueOf(quantity)) {
                        res.success = true;
                        datamap.put('sku',contract.cc_oo_Product__r.ccrz__SKU__c);
                        datamap.put('quantity',quantity);
                        datamap.put('cartId',cartId);
                        datamap.put('contractId',contract.Name);
                        res.data = dataMap;
                    }*/
                }
                if(!dataMap.isEmpty()) {
                    res.success = true;
                }          
                res.data = dataMap;  
            }         
        }catch (Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'validateContractQuantity');
        }
        
        return res;
    }
    
    /***************************************************************************************************************************************
      Method Name : cancelContract
      Description : cancelContract is to cancel contract entry in cart
      Parameter   : cartDetailMap
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1171 - To display message dialog when quantity is greater than contract price.                                                               

                    
      *************************************************************************************************************************************/
    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult cancelContract(final ccrz.cc_RemoteActionContext ctx, Map<String, String> cartDetailMap){
         ccrz.cc_CallContext.initRemoteContext(ctx);
         ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
         res.success = false;                                                                   
         try {
            
            String sku;
            String cartItemId;
            Integer quantity;
            String contractId;
            
            if(cartDetailMap != null && !cartDetailMap.isEmpty()){
                if(cartDetailMap.containsKey('sku') && cartDetailMap.get('sku') != null) {
                    sku = String.valueOf(cartDetailMap.get('sku'));
                }
                
                if(cartDetailMap.containsKey('cartId')){
                    cartItemId= String.valueOf(cartDetailMap.get('cartId'));
                }
                
                if(cartDetailMap.containsKey('quantity') && cartDetailMap.get('quantity') != null) {
                    quantity = Integer.valueOf(cartDetailMap.get('quantity'));
                }
                
                if(cartDetailMap.containsKey('contractId') && cartDetailMap.get('contractId') != null){
                    contractId= String.valueOf(cartDetailMap.get('contractId'));
                }
            }
            System.debug('Piyali' + cartItemId);
            ccrz__E_CartItem__c cartItem = [SELECT Id, ccrz__Quantity__c, ccrz__SubAmount__c, ccrz__Price__c  
                                                    FROM ccrz__E_CartItem__c WHERE Id =:cartItemId];
            
            if(String.isNotBlank(cartItemId)) {
                delete cartItem;
            }           
            res.success = true;
            Map<String, Object> dataMap = new Map<String, Object>();
            dataMap.put('quantity', quantity);
            dataMap.put('sku', sku);
            res.data = dataMap;
         }catch(Exception ex) {
            System.debug(ex);
            insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString()); 
         }                                                                          
        return res;                                                                     
    }*/
    
    /***************************************************************************************************************************************
      Method Name : splitContract
      Description : splitContract is to split and add the contract quantity and redirect to product detail page with remaining quantity
      Parameter   : cartDetailMap
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1171 - To display message dialog when quantity is greater than contract price.                                                               

                    
      *************************************************************************************************************************************/
    /*@RemoteAction
    global static ccrz.cc_RemoteActionResult splitContract(final ccrz.cc_RemoteActionContext ctx, Map<String, String> cartDetailMap){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try {
            
            String sku;
            String cartItemId;
            Integer quantity;
            String contractId;
            
            if(cartDetailMap != null && !cartDetailMap.isEmpty()){
                if(cartDetailMap.containsKey('sku') && cartDetailMap.get('sku') != null) {
                    sku = String.valueOf(cartDetailMap.get('sku'));
                }
                
                if(cartDetailMap.containsKey('cartId')){
                    cartItemId= String.valueOf(cartDetailMap.get('cartId'));
                }
                
                if(cartDetailMap.containsKey('quantity') && cartDetailMap.get('quantity') != null) {
                    quantity = Integer.valueOf(cartDetailMap.get('quantity'));
                }
                
                if(cartDetailMap.containsKey('contractId') && cartDetailMap.get('contractId') != null){
                    contractId= String.valueOf(cartDetailMap.get('contractId'));
                }
            }
            
            System.debug('Piyali' + cartItemId);
            ccrz__E_CartItem__c cartItem = [SELECT Id, ccrz__Quantity__c, ccrz__SubAmount__c, ccrz__Price__c  
                                                    FROM ccrz__E_CartItem__c WHERE Id =:cartItemId];
            cc_oo_ContractPrice__c contract = [SELECT Id, cc_oo_AvailabilityQty__c,cc_oo_ContractUoM__c,cc_oo_ContractUoMDesc__c, Name  FROM cc_oo_ContractPrice__c WHERE Name =:contractId];
            
            Boolean disabledContract = false;
            Integer addContractQty = Integer.valueOf(contract.cc_oo_AvailabilityQty__c); 
            Integer remainingQty = quantity - Integer.valueOf(contract.cc_oo_AvailabilityQty__c);
            cartItem.ccrz__Quantity__c = addContractQty;
            cartItem.ccrz__SubAmount__c = cartItem.ccrz__Price__c * addContractQty;
            update cartItem;
            
            Map<String, Object> dataMap = new Map<String, Object>();
            dataMap.put('quantity', remainingQty);
            dataMap.put('sku', sku);
            res.data = dataMap;
            res.success = true;
            
         }catch(Exception ex) {
            System.debug(ex);
            insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString()); 
         }                                                                          
        return res;                                                                             
    }*/
/*@RemoteAction
global static ccrz.cc_RemoteActionResult createNewListpriceItem(final ccrz.cc_RemoteActionContext ctx,String cartId,Map<string,Integer> cartItemQty){

        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        Set<String> prdlst=new Set<String>();
        List<ccrz__E_CartItem__c> crtprlst;
        Map<String,ccrz__E_CartItem__c> NewCartMap=new Map<String,ccrz__E_CartItem__c>();
        Map<String,List<ccrz__E_CartItem__c>> prdCartMap;
        Map<String,ccrz__E_ProductInventoryItem__c> prdInvMap=new Map<String,ccrz__E_ProductInventoryItem__c>();
        Map<String,cc_oo_PriceList__c> prdPirceMap=new Map<String,cc_oo_PriceList__c>();
        List<ccrz__E_CartItem__c> cartItemList=new List<ccrz__E_CartItem__c>();
        try
        {   
            Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            String sellerId =   null;
            String accountID=ccrz.cc_CallContext.currAccountId;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
            }
            List<ccrz__E_CartItem__c > cartList=[select id,ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,cc_oo_IsListPrice__c
                                                from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId];
            if(cartList!=null && cartList.size()>0){
                for(ccrz__E_CartItem__c cartItemlst:cartList){
                    if(cartItemlst.cc_oo_IsListPrice__c){
                         cartItemlst.ccrz__Quantity__c=cartItemQty.get(cartItemlst.id);
                         prdlst.add(cartItemlst.ccrz__Product__r.ccrz__SKU__c);
                         NewCartMap.put(cartItemlst.id,cartItemlst);
                         system.debug('new cart map'+NewCartMap);
                         system.debug('prod cart map'+prdCartMap);
                        if(prdCartMap == null){
                          prdCartMap=new Map<String,List<ccrz__E_CartItem__c>>();
                            crtprlst=new List<ccrz__E_CartItem__c>();
                            crtprlst.add(cartItemlst);
                            system.debug('cartItemlst'+cartItemlst);
                            prdCartMap.put(cartItemlst.ccrz__Product__r.ccrz__SKU__c, crtprlst);
                            system.debug('MapCreated'+prdCartMap.get(cartItemlst.ccrz__Product__r.ccrz__SKU__c));
                         }else{ 
                         if(!prdCartMap.containsKey(cartItemlst.ccrz__Product__r.ccrz__SKU__c)){
                          crtprlst=new List<ccrz__E_CartItem__c>();
                            crtprlst.add(cartItemlst);
                            prdCartMap.put(cartItemlst.ccrz__Product__r.ccrz__SKU__c, crtprlst);
                            system.debug('MapValueAdded'+prdCartMap.get(cartItemlst.ccrz__Product__r.ccrz__SKU__c));
                         }else{
                            crtprlst.add(cartItemlst);
                            prdCartMap.put(cartItemlst.ccrz__Product__r.ccrz__SKU__c,crtprlst);
                            system.debug('secondMapValueAdded'+prdCartMap.get(cartItemlst.ccrz__Product__r.ccrz__SKU__c));
                         }
                        }
                    }
                }
            }
            List<ccrz__E_ProductInventoryItem__c> prdInvItm=[select ccrz__ProductItem__r.ccrz__SKU__c,cc_oo_IsOnlyPalletProduct__c,
                                                                ccrz__ProductItem__r.ccrz__UnitOfMeasure__c,cc_oo_PalletSize__c
                                                                from ccrz__E_ProductInventoryItem__c
                                                                where ccrz__ProductItem__r.ccrz__ProductId__c IN:prdlst and cc_oo_Seller__c=:sellerId];
            for(ccrz__E_ProductInventoryItem__c prdInvItemlist:prdInvItm){
                    prdInvMap.put(prdInvItemlist.ccrz__ProductItem__r.ccrz__SKU__c,prdInvItemlist);
            }
            List<cc_oo_PriceList__c> priceList=[select cc_oo_Product__r.ccrz__SKU__c,cc_oo_NetListPrice__c,cc_oo_PalletPrice__c from cc_oo_PriceList__c where cc_oo_Product__r.ccrz__SKU__c IN:prdlst and cc_oo_Seller__c=:sellerId and cc_oo_ShipTo__c=:accountID];                                                 
            for(cc_oo_PriceList__c pricelst:priceList){
                prdPirceMap.put(pricelst.cc_oo_Product__r.ccrz__SKU__c,pricelst);
            }
            for(String prodSku : prdlst){
             system.debug('Inside the main loop');
             Integer quotient = 0;
             Integer remainder = 0;
             Integer quantity=0;
             Integer palletSize=Integer.valueOf(prdInvMap.get(prodSku).cc_oo_PalletSize__c);
             Decimal palletPrice=prdPirceMap.get(prodSku).cc_oo_PalletPrice__c;
             Decimal listPrice=prdPirceMap.get(prodSku).cc_oo_NetListPrice__c;
             List<ccrz__E_CartItem__c> cartvalueList = prdCartMap.get(prodSku);                       
             Integer listSize = cartvalueList.size();
             
             system.debug(listSize);
             if(listSize<2){
             quantity=Integer.valueOf(cartvalueList[0].ccrz__Quantity__c);
             quotient = quantity /palletSize;
             remainder = math.mod(quantity , palletSize);
             String cartItemId1=cartvalueList[0].id;
             system.debug('cartItemId1 ------------------------------>'+cartItemId1);
             if(quotient==0 && remainder==0){
                    //update current row with list price
                    NewCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                    NewCartMap.get(cartItemId1).ccrz__Price__c = listPrice;
                    NewCartMap.get(cartItemId1).cc_oo_UnitPrice__c = listPrice;
                    NewCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                    NewCartMap.get(cartItemId1).ccrz__SubAmount__c = listPrice * quantity;
                    cartItemList.add( NewCartMap.get(cartItemId1));
                     system.debug('quantity ------------------------------>'+quantity);
                     system.debug('cartItemId1 ------------------------------>'+cartItemId1);
             }
             if(quotient!=0 && remainder==0)
             {  
                //update current row with pallet price
                NewCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                NewCartMap.get(cartItemId1).ccrz__Price__c = palletPrice;
                NewCartMap.get(cartItemId1).cc_oo_UnitPrice__c = palletPrice;
                NewCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                NewCartMap.get(cartItemId1).ccrz__SubAmount__c = palletPrice * quantity;
                cartItemList.add( NewCartMap.get(cartItemId1));
                system.debug('quantity ------------------------------>'+ NewCartMap.get(cartItemId1).ccrz__Quantity__c);
                     system.debug('cartItemId1 ------------------------------>'+cartItemId1);
            }
             if(quotient!=0 && remainder!=0){
                    quantity=quantity-remainder;
                    //update current row with reminder and list price
                    NewCartMap.get(cartItemId1).ccrz__Quantity__c = remainder;
                    NewCartMap.get(cartItemId1).ccrz__Price__c = listPrice;
                    NewCartMap.get(cartItemId1).cc_oo_UnitPrice__c = listPrice;
                    NewCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                    NewCartMap.get(cartItemId1).ccrz__SubAmount__c = listPrice * remainder;
                    cartItemList.add( NewCartMap.get(cartItemId1));
                    //creat new row with quantity-reminder and pallet price
                    system.debug('quantity ------------------------------>'+ NewCartMap.get(cartItemId1).ccrz__Quantity__c);
                     system.debug('cartItemId1 ------------------------------>'+cartItemId1);
                    cc_oo_HelperController.addNewCartItem(prodSku,quantity,cartId,palletPrice,false,null);
             }
             }
             if(listSize==2){
             quantity=Integer.valueOf(cartvalueList[0].ccrz__Quantity__c)+Integer.valueOf(cartvalueList[1].ccrz__Quantity__c);
             String cartItemId1=cartvalueList[0].id;
             String cartItemId2=cartvalueList[1].id;
             system.debug('cartItemId1 ------------------------------>'+cartItemId1);
             system.debug('cartItemId2 ------------------------------>'+cartItemId2);
             quotient = quantity /palletSize;
             remainder = math.mod(quantity , palletSize);
             if(quotient!=0 && remainder==0)
             {
                //update [0] row with quantity and pallet price
                NewCartMap.get(cartItemId1).ccrz__Quantity__c = quantity;
                NewCartMap.get(cartItemId1).ccrz__Price__c = palletPrice;
                NewCartMap.get(cartItemId1).cc_oo_UnitPrice__c = palletPrice;
                NewCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                NewCartMap.get(cartItemId1).ccrz__SubAmount__c = palletPrice * quantity;
                cartItemList.add( NewCartMap.get(cartItemId1));
                system.debug('quantity ------------------------------>'+ NewCartMap.get(cartItemId1).ccrz__Quantity__c);
                system.debug('cartItemId1 ------------------------------>'+cartItemId1);
                //delect other row
                NewCartMap.remove(cartItemId2);
             }
             if(quotient!=0 && remainder!=0){
                quantity=quantity-remainder;
                //update [0] row with reminder and List price
                NewCartMap.get(cartItemId1).ccrz__Quantity__c = remainder;
                NewCartMap.get(cartItemId1).ccrz__Price__c = listPrice;
                NewCartMap.get(cartItemId1).cc_oo_UnitPrice__c = listPrice;
                NewCartMap.get(cartItemId1).cc_oo_IsListPrice__c = true;
                NewCartMap.get(cartItemId1).ccrz__SubAmount__c = listPrice * remainder;
                cartItemList.add( NewCartMap.get(cartItemId1));
                //update [1] row with quantity-reminder and pallet price
                NewCartMap.get(cartItemId2).ccrz__Quantity__c = quantity;
                NewCartMap.get(cartItemId2).ccrz__Price__c = palletPrice;
                NewCartMap.get(cartItemId2).cc_oo_UnitPrice__c = palletPrice;
                NewCartMap.get(cartItemId2).cc_oo_IsListPrice__c = true;
                NewCartMap.get(cartItemId2).ccrz__SubAmount__c = palletPrice * quantity;
                cartItemList.add( NewCartMap.get(cartItemId2));
                system.debug('multiple product list to be updated'+cartItemList);
             }
             }  
          }
          update cartItemList;
          system.debug('Final list to be updated'+cartItemList);
        }
        catch(Exception ex) {
            system.debug(ex);
            insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString()); 
         }                                                                          
        return res;
  }*/

    
    /***************************************************************************************************************************************
      Method Name : getCartDetails
      Description : getCartDetails is to retrieve the primary and secondary cart details
      Parameter   : sellerId, shipToId, cartId
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1719                                                             
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCartDetails(final ccrz.cc_RemoteActionContext ctx,String sellerId, String shipToId, String cartId,boolean fromOrderInfo, String shipDate){
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        Id accountId = ccrz.cc_CallContext.currAccountId;
        Id contactId = ccrz.cc_CallContext.currContact.Id;
        Id userId = ccrz.cc_CallContext.currUser.Id;

        Map<String, Object> dataMap = cc_oo_HelperController.getCartDetails(sellerId,shipToId,cartId,fromOrderInfo,accountId,contactId,userId, shipDate);
        if(dataMap.get('tobeUpdatedCartList') != null) {
        	List<ccrz__E_Cart__c> updateCartList = new List<ccrz__E_Cart__c>();
        	updateCartList.addAll((List<ccrz__E_Cart__c>)dataMap.get('tobeUpdatedCartList'));
        	update updateCartList;
        }
        if(dataMap != null) {
            res.success = true;
            res.data = dataMap; 
        }    
        return res;
    }

    
    /***************************************************************************************************************************************
      Method Name : splitProductOnDate
      Description : splitProductOnDate is to reshuffle cartItems when dates are modified
      Parameter   : cartId, shipDate
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1719                                                             
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult splitProductOnDate(final ccrz.cc_RemoteActionContext ctx,String cartId, String shipDate){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false;
        boolean cartUpdated=false;
        Map<String,Object> dataMap= new Map<String,Object>();
        try {
            String shippingMethod=cc_oo_HelperController.getShippingMethod(cartId);
            dataMap=cc_oo_HelperController.shuffleCart(cartId,shipDate,shippingMethod,false);
            res.success = true;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'splitProductOnDate');
        }
        return res;
    }
        /***************************************************************************************************************************************
      Method Name : DeleteAmendedCart
      Description : DeleteAmendedCart is to delete Amendedcart on click on cancel(yes-confirm) button and return myOrder url.
      Parameter   : cartId
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-2339                                                             
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult DeleteAmendedCart(final ccrz.cc_RemoteActionContext ctx,String sid, String shipToId, string cartEncId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        map<string,object> respDataMap=new map<string,object>();
        res.success = false;
        String url;
        try {
        // Strat-Us-OO-2339-delete amended carts primary/secondary which have not been converted to order 
        List<ccrz__E_Cart__c> availAmendCartList=new List<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> amendedCarts = [select id,cc_oo_OriginalCart__c,cc_oo_OriginalOrder__c,ccrz__ShipTo__c,ccrz__BillTo__c,cc_oo_AmendedCart__c,cc_oo_SplitCart__c from ccrz__E_Cart__c where cc_oo_AmendedCart__c=true AND ccrz__CartStatus__c = 'Open'AND //ccrz__User__c =: ccrz.cc_CallContext.currUserId AND 
                                                ccrz__EncryptedId__c=:cartEncId and id NOT IN (select ccrz__OriginatedCart__c from ccrz__E_Order__c) ];
         if(!amendedCarts.isEmpty()){
            for(ccrz__E_Cart__c amdCart:amendedCarts){
                if(amdCart.cc_oo_AmendedCart__c){
                    availAmendCartList.add(amdCart);
                    if(amdCart.cc_oo_SplitCart__c!=null){
                        ccrz__E_Cart__c secAmndCart=new ccrz__E_Cart__c();  
                        secAmndCart.id=amdCart.cc_oo_SplitCart__c;
                        availAmendCartList.add(secAmndCart);
                    }
                }
            }
            //url='/PurinaMills/ccrz__MyAccount?viewState=myOrders&cclcl=en_US&sid='+ sid + '&isSameShipto=false';
            //url = cc_oo_HelperController.getRedirectUrl('ccrz__MyAccount?viewState=myOrders&',null,null,false,null);
            delete availAmendCartList;
            String CartId;
            ccrz__E_Cart__c encCartId = cc_oo_HeaderController.mapToCart(sid,shipToId,false);
            CartId=String.valueOf(encCartId.ccrz__EncryptedId__c);
            url = cc_oo_HelperController.getRedirectUrl('ccrz__MyAccount?viewState=myOrders&',null,CartId,false,null);
            respDataMap.put('url',url);
            respDataMap.put('encCartId',encCartId);
            res.success = true;
            res.data=respDataMap;
         }
        }catch(Exception ex){
			cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'DeleteAmendedCart');
        }
        return res;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getProductsDetails(final ccrz.cc_RemoteActionContext ctx, string cartId, string sellerId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try
        { 
              Map<String, Object> dataMap = new Map<String, Object>();
              List<ccrz__E_CartItem__c> cartItems = [Select ci.Id, ci.ccrz__Product__c, ci.ccrz__Product__r.ccrz__SKU__c,ci.ccrz__Quantity__c,
                                      ci.ccrz__Product__r.ccrz__LongDesc__c,ci.ccrz__Product__r.cc_oo_Second_Description__c,ccrz__Price__c From ccrz__E_CartItem__c ci WHERE ccrz__Cart__c =: cartId];
              String priceError = ccrz.cc_CallContext.pageLabels.get('Price_Validation');
              for(ccrz__E_CartItem__c cartItem : cartItems){             	
	              	if(cartItem.ccrz__Quantity__c == null) {
	                    cartItem.ccrz__Quantity__c = 1;                 	 
	              	}
	              	dataMap.put(string.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),cartItem);
	              	if(cartItem.ccrz__Price__c == 0) {
	              		dataMap.put(cartItem.Id, priceError);
	              	}     	 
              }           
              res.success = true;
              res.data = dataMap;
              
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getProductsDetails');
        }
       return res;
    }
 }