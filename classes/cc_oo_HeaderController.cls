global without sharing class cc_oo_HeaderController {
    public static final string CLASS_NAME = 'cc_oo_HeaderController';
    public String cartEncId{get;private set;}
    public String currentUserDisplayName{get;private set;}
    //Property to hold community portal link from custom settings
    //public String commPortalLink {get; set;}
    
    /* Declaring getter/setter for the custom setting to show static CSR Email Address and static CSR Phone Number from LOLSettings */ 
    //Property to hold Email Address from Custom setting
    public String CSREmailAddress {get;set;}
    //Property to hold Phone Number from Custom Setting
    public String CSRPhoneNumber {get;set;}
    //dedicatedCustomerOpRep for holding CSR Name
    public String dedicatedCustomerOpRep {get;set;}
    public String contactId{get;private set;}
    public cc_oo_HeaderController() {
    /* User story OO-142: Ability to access the contact information of the customer's assigned Customer Service
       Representative (CSR) in the online ordering system */ 
        CSREmailAddress = LOLSettings__c.getAll().get('CSR_EmailAddress').Value__c;
        CSRPhoneNumber =ccrz.cc_CallContext.pageLabels.get('CSRphone');
        // Fetching CSR Name on the basis of ship to Number selected
        Account accData = [select Name, Ship_to_Number__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.Name from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
        //Passing the query string result into a varible and passing the same variable to access it in the frontend
        if(accData.Dedicated_Customer_Op_Rep__c!=NULL){
            dedicatedCustomerOpRep = accData.Dedicated_Customer_Op_Rep__r.Name;
        }
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','-----------dedicated customer: '+dedicatedCustomerOpRep);
        //System.debug('-----dedicated customer: '+dedicatedCustomerOpRep);
        
        cartEncId = ApexPages.currentPage().getParameters().get('cartId');
        if(!Test.isRunningTest()){
            //currentUserDisplayName = ccrz.cc_CallContext.currContact.FirstName + ' ' + ccrz.cc_CallContext.currContact.LastName;
            string portalUserId = ccrz.cc_CallContext.currPageParameters.get('portalUser');
            if(portalUserId != null && portalUserId != '' && portalUserId != 'undefined' && portalUserId != 'null'){
                portalUserId = portalUserId;
            }
            else{
                portalUserId = ccrz.cc_CallContext.currUserId;
            }
            User theUser = [Select u.Id, u.ContactId from User u where u.Id =: portalUserId];
            Contact theContact = [Select c.FirstName, c.LastName From Contact c where c.Id =: theUser.ContactId];
            currentUserDisplayName = theContact.FirstName + ' ' + theContact.LastName;                
        }
        else
        {
            currentUserDisplayName = 'Test User';
        } 
        contactId=ccrz.cc_CallContext.currContact.Id;          
    }
    
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
             List<AggregateResult> cartItemAggr  = [SELECT SUM(cc_oo_TotalWieght__c)TotalWeight FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId ];
            //List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__c, ccrz__Product__r.Id, ccrz__Product__r.ccrz__ProductWeight__c, ccrz__Quantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId];
            
           // Map<ID, Decimal> productQuantityMap = new Map<ID, Decimal>();
           //Map<ID, Decimal> productWeightMap = new Map<ID, Decimal>();
            Decimal aggregateCartOrderWeight = (Decimal)cartItemAggr[0].get('TotalWeight');
              
            res.success=true;
            res.data=aggregateCartOrderWeight;                    
            
        }catch (Exception ex)
        {
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getTotalWeight');
              //System.debug(error);
        }
        return res;
    }
    
     /***************************************************************************************************************************************
      Method Name : getTotalWeightByCartId
      Description : getTotalWeight is to get the total weight of the product
      Parameter   : cartId 
                    cartId is the id of the Cart
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-5281 - CC to provide dock door API the order weight.
      *************************************************************************************************************************************/ 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getTotalWeightByCartId(string cartId){
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        try {  
            List<AggregateResult> cartItemAggr  = [SELECT SUM(cc_oo_TotalWieght__c)TotalWeight FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
            Decimal aggregateCartOrderWeight = (Decimal)cartItemAggr[0].get('TotalWeight');
            res.success=true;
            res.data=aggregateCartOrderWeight;
        } catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getTotalWeightByCartId');
        }
        return res;
    }
    
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
            //List<ccrz__E_CartItem__c> cartItemList = [SELECT ccrz__Product__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId];
            for(ccrz__E_CartItem__c cart:([SELECT ccrz__Product__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =: cartId])){
                products.add(cart.ccrz__Product__c);
            }
            res.data=products.size();                    
             res.success=true;
        }catch (Exception ex)
        {
              cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'getCartItems');
              //System.debug(error);
        }
       return res;
    }
    
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
        //US - 1914 - adding Account Name
        public String shipToName {get; set;}
    }
    
    //OO-215 - Bean for the ShipTo
    public class cc_oo_SellerBean {
        public String sellerSFId{get; set;}
        public String sellerId{get; set;}
        public String sellerName{get; set;}
        public String sellerShortDesc{get; set;}
        public String routeTruckDay{get; set;}
        //OO-81 The address must be listed for each plant available in the plant selection screen.  
        public String sellerAddresLine1{get; set;}
        public String sellerAddresLine2{get; set;}
        public String sellerCity{get; set;}
        public String sellerState{get; set;}
        public String sellerPostalCode{get; set;}
        //US - 143 - to implement filter
        public String consolidateSeller{get; set;}
        //US - 1914
        public String ProductType {get; set;}
        public String routeCode{get; set;}
        //US-1974
        public List<String> sellerHoliday {get; set;}
    }
    
    //OO-215 - Bean for the ShipTo
    public class cc_oo_ShipToSellerBean {
        public String sellerName{get; set;}
        public String shipToName{get; set;}
        public String shipToId{get; set;}
        public String sellerId{get; set;}
    }
    
    //OO-215 - Shipto PLant selection 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getShipToSellerInfo(final ccrz.cc_RemoteActionContext ctx,  String selectedSellerSFID, string selectedShipTo, string encCartId){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;
        cc_oo_ShipToSellerBean shipToSeller = new cc_oo_ShipToSellerBean();
        
        if(selectedShipTo != null && selectedShipTo != ''){
            List<Account> listAccount = [select Id, Name,accountNumber from Account where accountNumber =: selectedShipTo];
            if(!listAccount.isEmpty()){

                shipToSeller.shipToId = listAccount[0].accountNumber;
                string shipToName = listAccount[0].Name;
                //OO-1341 - Appending Account Number for Ship To
                if(listAccount[0].accountNumber != null && listAccount[0].accountNumber != '' && !shipToName.contains(listAccount[0].accountNumber)){
                        shipToName = shipToName + '-' + listAccount[0].accountNumber;
                }
                shipToSeller.shipToName = shipToName;
            }
        }

        if(selectedSellerSFID != null && selectedSellerSFID != ''){
            List<ccrz__E_Seller__c> listSeller = [select Id, Name from ccrz__E_Seller__c where id =: selectedSellerSFID];
            if(!listSeller.isEmpty()){
                shipToSeller.sellerId = listSeller[0].Id;
                shipToSeller.sellerName = listSeller[0].Name;
            }
        }

        if(encCartId != null && encCartId != 'null'){
            List<ccrz__E_Cart__c> listCart = new List<ccrz__E_Cart__c>();
            //if(shipToSeller.sellerName == null || shipToSeller.shipToName == null){
                listCart = [select id, cc_oo_Seller__c, cc_oo_Seller__r.Name, cc_oo_ShipToAccount__c,cc_oo_ShipToAccount__r.Name, cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c =: encCartId];
                if(!listCart.isEmpty()){
                    shipToSeller.sellerId = listCart[0].cc_oo_Seller__c;
                    if(listCart[0].cc_oo_Seller__c != null){
                        shipToSeller.sellerName = listCart[0].cc_oo_Seller__r.Name;
                    }
                    if(listCart[0].cc_oo_ShipToAccount__c != null){
                        
                        shipToSeller.shipToId = listCart[0].cc_oo_ShipToAccount__r.AccountNumber;
                        string shipToName = listCart[0].cc_oo_ShipToAccount__r.Name;
                        //OO-1341 - Appending Account Number for Ship To
                        if(listCart[0].cc_oo_ShipToAccount__r.AccountNumber != null && listCart[0].cc_oo_ShipToAccount__r.AccountNumber != '' && !shipToName.contains(listCart[0].cc_oo_ShipToAccount__r.AccountNumber)){
                                shipToName = shipToName + '-' +listCart[0].cc_oo_ShipToAccount__r.AccountNumber;
                        }
                        shipToSeller.shipToName = shipToName;
                    }
                }
            //}
        }
        res.data = shipToSeller;
        return res;
    }
    
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
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','accountIds-->' + accountIds);
        //system.debug('accountIds-->' + accountIds);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','dealerAccountId-->' + dealerAccountId);
        //system.debug('dealerAccountId-->' + dealerAccountId);
         //US-970 for active Ship to's 
        string accountQueryString = 'SELECT id, AccountNumber, SHIPPINGSTREET, SHIPPINGCITY, SHIPPINGSTATE, SHIPPINGPOSTALCODE, SHIPPINGCOUNTRY, SHIPPINGSTATECODE, ParentId, Name from Account where ShipTo_Flag__c = true AND IsActive__c= true AND ';      
        if(dealerAccountId != null){
            accountQueryString += '(parentid =: dealerAccountId OR id =: dealerAccountId)';

        }else if(!accountIds.isEmpty()){
            accountQueryString += 'id IN: accountIds';
        }else{
             accountQueryString += 'id =: currentAccount.Id';
        }
        accountQueryString+= ' ORDER BY Name';
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','accountQueryString--->' + accountQueryString);
        //system.debug('accountQueryString--->' + accountQueryString);
        
        List<sObject> listOfsobjAccounts = Database.query(accountQueryString);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','listOfsobjAccounts-> ' +listOfsobjAccounts);
        //system.debug('listOfsobjAccounts-> ' +listOfsobjAccounts);
        String EMPTY = '';
        List<cc_oo_ShipToBean> listOfShipTos = new List<cc_oo_ShipToBean>();
        Account acct;
        cc_oo_ShipToBean shipTo;
        for(sObject accSobject : listOfsobjAccounts){
            acct = (Account) accSobject;
            shipTo = new cc_oo_ShipToBean();
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
            shipTo.shipToState = cc_oo_HelperController.getStateCode(acct.SHIPPINGSTATE);
            shipTo.shipToCountry = cc_oo_HelperController.getCountryCode(acct.SHIPPINGCOUNTRY);
            shipTo.shipToPostalCode = acct.SHIPPINGPOSTALCODE;
            //US - 143 - to implement filter
            shipTo.consolidateShipto = (acct.AccountNumber == null ? EMPTY : acct.AccountNumber) +' ' + (acct.SHIPPINGSTREET == null ? EMPTY : acct.SHIPPINGSTREET) + ',' + (acct.SHIPPINGCITY == null ? EMPTY : acct.SHIPPINGCITY) +',' + (shipTo.shipToState == null ? EMPTY : shipTo.shipToState) + ' ' + (acct.SHIPPINGCOUNTRY == null ? EMPTY : acct.SHIPPINGCOUNTRY) + '-' + (acct.SHIPPINGPOSTALCODE == null ? EMPTY : acct.SHIPPINGPOSTALCODE) + '-' + (acct.Name == null ? EMPTY : acct.Name);
            shipTo.shipToName = acct.Name;
            listOfShipTos.add(shipTo);
        }
        
        if(!listOfShipTos.isEmpty()){
            res.data = listOfShipTos;            
            res.success = true;
            
        }
        
        return res;
        
    }
    
    //OO-215 - Shipto PLant selection 
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getSellers(final ccrz.cc_RemoteActionContext ctx,  String shipToCode){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true; 
        integer shipToCodeNumber = Integer.valueOf(shipToCode);
        List<cc_oo_SellerBean> listSellers = new List<cc_oo_SellerBean>();
        Map<String,String> mapRouteDayUniqueFreights=new Map<String,String>();
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','#########in sellers'); 
        //system.debug('#########in sellers');                           
    //OO-81 The address must be listed for each plant available in the plant selection screen.  
    map<string, CC_OO_Customer_Freight__c> mapUniqueFreights = new map<string,CC_OO_Customer_Freight__c>();
        for(CC_OO_Customer_Freight__c sellerFreight: [select id, name, Plant_Name__c,Route_Truck_Day__c,Route_Code__c, Product_Type__c, Plant_Name__r.id, Plant_Name__r.Name,
                            Plant_Name__r.ccrz__Storefront__c, Plant_Name__r.ccrz__SellerId__c, Plant_Name__r.ccrz__ShortDesc__c, 
                            Plant_Name__r.cc_oo_Address_Line_1__c,Plant_Name__r.cc_oo_Address_Line_2__c,Plant_Name__r.cc_oo_City__c,Plant_Name__r.cc_oo_State__c,Plant_Name__r.cc_oo_Zip__c
                            from CC_OO_Customer_Freight__c where ShipTo_Account_Number__c =: shipToCodeNumber and 
                            Plant_Name__r.ccrz__Storefront__c = 'PurinaMills' and Plant_Name__r.ccrz__Enabled__c = true ORDER BY Plant_Name__r.Name]){
                            if((sellerFreight.Product_Type__c!=null) && (sellerFreight.Route_Code__c!=null) ){
                                if(sellerFreight.Product_Type__c.toUpperCase()=='BAG' && sellerFreight.Route_Code__c.toUpperCase()=='M3'){
                                        mapRouteDayUniqueFreights.put(sellerFreight.Plant_Name__r.ccrz__SellerId__c,sellerFreight.Route_Truck_Day__c);
                                }
                            }
                            mapUniqueFreights.put(sellerFreight.Plant_Name__r.ccrz__SellerId__c,sellerFreight);
        }                                               
        List<String> disabledDates;
        Map<String, List<String>> disabledDatesMap = new Map<String, List<String>>();
        List<CC_OO_PlantHolidayCalendar__c> holidaysList=[select cc_oo_Holiday__c,cc_oo_Plant__r.ccrz__SellerId__c from CC_OO_PlantHolidayCalendar__c where cc_oo_Plant__r.ccrz__SellerId__c IN:mapUniqueFreights.keySet()];
            for(CC_OO_PlantHolidayCalendar__c holDate:holidaysList){
                Date dateToUse=holDate.cc_oo_Holiday__c;
                String dateFinal = DateTime.newInstance(dateToUse.year(),dateToUse.month(),dateToUse.day()).format('dd MM YYYY');
                if(disabledDatesMap.containsKey(holDate.cc_oo_Plant__r.ccrz__SellerId__c)){
                    disabledDates = disabledDatesMap.get(holDate.cc_oo_Plant__r.ccrz__SellerId__c);
                    disabledDates.add(dateFinal);
                    disabledDatesMap.put(holDate.cc_oo_Plant__r.ccrz__SellerId__c,disabledDates);
                }else{
                    disabledDates = new List<string>();
                    disabledDates.add(dateFinal);
                    disabledDatesMap.put(holDate.cc_oo_Plant__r.ccrz__SellerId__c,disabledDates);
                }
            }    
        
        String EMPTY = '';   
        cc_oo_SellerBean newSeller;
        for(CC_OO_Customer_Freight__c sellerFreigtItem : mapUniqueFreights.values()){

            newSeller = new cc_oo_SellerBean(); 
            newSeller.sellerSFId = sellerFreigtItem.Plant_Name__r.id;
            newSeller.sellerId = sellerFreigtItem.Plant_Name__r.ccrz__SellerId__c;
            newSeller.sellerName = sellerFreigtItem.Plant_Name__r.Name;
            newSeller.sellerShortDesc = sellerFreigtItem.Plant_Name__r.ccrz__ShortDesc__c;
            newSeller.routeTruckDay =sellerFreigtItem.Route_Truck_Day__c;
            newSeller.routeCode =sellerFreigtItem.Route_Code__c;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','#########in sellers...got your property');
            //system.debug('#########in sellers...got your property'); 
            //OO-81 The address must be listed for each plant available in the plant selection screen.  
            newSeller.sellerAddresLine1 = sellerFreigtItem.Plant_Name__r.cc_oo_Address_Line_1__c;
            newSeller.sellerAddresLine2 = sellerFreigtItem.Plant_Name__r.cc_oo_Address_Line_2__c;
            newSeller.sellerCity = sellerFreigtItem.Plant_Name__r.cc_oo_City__c;
            newSeller.sellerState = sellerFreigtItem.Plant_Name__r.cc_oo_State__c;
            newSeller.sellerPostalCode = sellerFreigtItem.Plant_Name__r.cc_oo_Zip__c;
            //US - 143 - to implement filter
            newSeller.consolidateSeller = (newSeller.sellerId == null ? EMPTY : newSeller.sellerId) +' ' + (newSeller.sellerName == null ? EMPTY : newSeller.sellerName) + ' ' ;
            newSeller.consolidateSeller += (newSeller.sellerAddresLine1 == null ? EMPTY : newSeller.sellerAddresLine1) + ',' + (newSeller.sellerAddresLine2 == null ? EMPTY : newSeller.sellerAddresLine2) + ',' + (newSeller.sellerCity == null ? EMPTY : newSeller.sellerCity) +',' + (newSeller.sellerState == null ? EMPTY : newSeller.sellerState) +',';
            newSeller.consolidateSeller += (newSeller.sellerPostalCode ==  null ? EMPTY : newSeller.sellerPostalCode) + ',';
            newSeller.consolidateSeller += (newSeller.sellerName ==  null ? EMPTY : newSeller.sellerName);
            //US - 1914
            newSeller.ProductType = sellerFreigtItem.Product_Type__c;
            //US-1974
            system.debug('#########in sellers...got your property'); 
            newSeller.sellerHoliday =disabledDatesMap.get(sellerFreigtItem.Plant_Name__r.ccrz__SellerId__c);
            listSellers.add(newSeller);
        } 
        
        //OO-210 - Start - To prevent user from creating more than one prebook commitment for same ship-to
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Shp to code-->' + shipToCode); 
        //system.debug('Shp to code-->' + shipToCode);
        Id userId = ccrz.cc_CallContext.currUser.Id;
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Logged User-->' + userId); 
        //system.debug('Logged User-->' + userId );                  
        List<ccrz__E_Order__c> orderDetails = [SELECT Id, ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.cc_oo_ShipToAccount__c,ccrz__ShipTo__c  from ccrz__E_Order__c WHERE ccrz__OriginatedCart__c IN (SELECT Id FROM ccrz__E_Cart__c WHERE cc_oo_ShipToAccount__r.AccountNumber =:shipToCode) AND ccrz__User__c =:userId ];
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','order details-->' + orderDetails);
        //system.debug('order details-->' + orderDetails );
        
        if(!orderDetails.isEmpty()){
         ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','order shipto -->' + orderDetails[0].ccrz__ShipTo__c);
        //system.debug('order shipto -->' + orderDetails[0].ccrz__ShipTo__c);
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
        //OO-1800 - As per the defect OO-1800 commmented the cart item deletion logic as this is not required Online Order logic
        /*if(!orderDetails.isEmpty()){
            Id activeCart = orderDetails[0].ccrz__OriginatedCart__c;
            Id shippingAccount = orderDetails[0].ccrz__OriginatedCart__r.cc_oo_ShipToAccount__c;
            List<ccrz__E_CartItem__c> listCartItemsToDelete = new List<ccrz__E_CartItem__c>();
            for(ccrz__E_Cart__c cartItem: [select id,(select id from ccrz__E_CartItems__r) from ccrz__E_Cart__c where id !=: activeCart and cc_oo_ShipToAccount__c =: shippingAccount and ccrz__CartStatus__c != 'Closed' 
                                                and cc_oo_CartType__c = 'Prebook'
                                                ]){
                listCartItemsToDelete.addAll(cartItem.ccrz__E_CartItems__r);
            }

            if(!listCartItemsToDelete.isEmpty()){
                delete listCartItemsToDelete;
            }
        }*/
        //OO-892 Delete cart items for other cart for which we dont have the orders                            

        Map<String,Object> mapSellers= new Map<String,Object>();
        if(!listSellers.isEmpty()){
            mapSellers.put('listSellers',listSellers);
        }
        if(!mapRouteDayUniqueFreights.isEmpty()){
            mapSellers.put('routeSellers',mapRouteDayUniqueFreights);
        }   
        if(!mapSellers.isEmpty()){
            res.data = mapSellers; 
        }else{
            res=null;
        }
        return res; 
    }
    
     //OO-215
    public static ccrz__E_Cart__c mapToCart(string sellerId, string shipToId, Boolean secondaryCart){
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','in mapToCart-->');
        //system.debug('in mapToCart-->');
        Id accountId = ccrz.cc_CallContext.currAccountId;
        Id contactId = ccrz.cc_CallContext.currContact.Id;
        Id userId = ccrz.cc_CallContext.currUser.Id;

        List<ccrz__E_Cart__c> checkExistingCart = [select id, ccrz__EncryptedId__c, cc_oo_SplitCartType__c,ccrz__ActiveCart__c,ccrz__RequestDate__c,CreatedDate,
                 (SELECT Id, ccrz__Product__r.cc_oo_TypeOfProduct__c FROM ccrz__E_CartItems__r)
                 from       ccrz__E_Cart__c where ccrz__Account__c =: accountId and ccrz__User__c =: userId and  ccrz__Contact__c =: contactId and
                cc_oo_Seller__r.Id =: sellerId and ccrz__ShipTo__r.cc_oo_BillToShipToID__c =: shipToId and ccrz__CartStatus__c = 'Open' Order By CreatedDate DESC]; 
                   
        if(!checkExistingCart.isEmpty()){ 
            ccrz__E_Cart__c returnAvailCart;  
            for(ccrz__E_Cart__c availCart : checkExistingCart) {
                if(!secondaryCart && availCart.cc_oo_SplitCartType__c == 'Primary') {
                    availCart.ccrz__ActiveCart__c = true;
                    returnAvailCart = availCart;
                    break;
                    //update availCart;
                    //return availCart;
                } else if(secondaryCart && availCart.cc_oo_SplitCartType__c == 'Secondary' && availCart.ccrz__E_CartItems__r.isEmpty()){
                    availCart.ccrz__ActiveCart__c = false;
                    returnAvailCart = availCart;
                    break;
                    //update availCart;
                    //return availCart;
                }
            }  
            
            if(returnAvailCart != null) {
                update returnAvailCart;
                return returnAvailCart;   
            }           
        } 
        
       
        List<Account> listAccounts = [SELECT id,Name, Phone, Email__c, AccountNumber, SHIPPINGSTREET, SHIPPINGCITY, SHIPPINGSTATE, SHIPPINGPOSTALCODE, SHIPPINGCOUNTRY, SHIPPINGSTATECODE,
                BILLING_STREET__C, BILLING_CITY__C, BILLING_STATE_PROVINCE__C, BILLING_ZIP_POSTAL_CODE__C, BILLING_COUNTRY__C
                from Account where ShipTo_Flag__c = true and accountNumber =: shipToId];
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','creation of cart-->');
        //system.debug('creation of cart-->');
        if(!listAccounts.isEmpty()){
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','in if mapToCart-->');
            //system.debug('in if mapToCart-->');
            Account shipToAccount = listAccounts[0];
            //Create ShipTo address
            ccrz__E_ContactAddr__c shipTo = new ccrz__E_ContactAddr__c();
            shipTo.ccrz__Country__c = cc_oo_HelperController.getCountryCode(shipToAccount.SHIPPINGCOUNTRY);
            shipTo.ccrz__CountryISOCode__c = cc_oo_HelperController.getCountryCode(shipToAccount.SHIPPINGCOUNTRY);
            shipTo.ccrz__PostalCode__c = shipToAccount.SHIPPINGPOSTALCODE;
            shipTo.ccrz__State__c = cc_oo_HelperController.getStateCode(shipToAccount.SHIPPINGSTATE);
            shipTo.ccrz__StateISOCode__c = cc_oo_HelperController.getStateCode(shipToAccount.SHIPPINGSTATE);
            shipTo.ccrz__City__c = shipToAccount.SHIPPINGCITY;
            shipto.ccrz__AddressFirstline__c = shipToAccount.SHIPPINGSTREET;
            shipto.ccrz__AddressSecondline__c = '';
            shipTo.ccrz__AddressThirdline__c = '';
            shipTo.ccrz__FirstName__c = shipToAccount.Name;
            shipTo.ccrz__HomePhone__c = shipToAccount.Phone;
            shipTo.ccrz__Email__c = shipToAccount.Email__c;
            shipTo.cc_oo_BillToShipToID__c = shipToAccount.AccountNumber;
            insert shipTo;

            //Create Bill To address
            ccrz__E_ContactAddr__c billTo = new ccrz__E_ContactAddr__c();
            billTo.ccrz__Country__c = cc_oo_HelperController.getCountryCode(shipToAccount.BILLING_COUNTRY__C);
            billTo.ccrz__CountryISOCode__c = cc_oo_HelperController.getCountryCode(shipToAccount.BILLING_COUNTRY__C);
            billTo.ccrz__PostalCode__c = shipToAccount.BILLING_ZIP_POSTAL_CODE__C;
            billTo.ccrz__State__c = cc_oo_HelperController.getStateCode(shipToAccount.BILLING_STATE_PROVINCE__C);
            billTo.ccrz__StateISOCode__c = cc_oo_HelperController.getStateCode(shipToAccount.BILLING_STATE_PROVINCE__C);
            billTo.ccrz__City__c = shipToAccount.BILLING_CITY__C;
            billTo.ccrz__AddressFirstline__c = shipToAccount.BILLING_STREET__C;
            billTo.ccrz__AddressSecondline__c = '';
            billTo.ccrz__AddressThirdline__c = '';
            billTo.ccrz__FirstName__c = shipToAccount.Name;
            billTo.ccrz__HomePhone__c = shipToAccount.Phone;
            billTo.ccrz__Email__c = shipToAccount.Email__c;
            billTo.cc_oo_BillToShipToID__c = shipToAccount.AccountNumber;        
            insert billTo;

            //Create new Active Cart
            ccrz__E_Cart__c newCart = new ccrz__E_Cart__c();
            newCart.ccrz__Account__c = accountId;
            //newCart.ccrz__ActiveCart__c = true;
            newCart.ccrz__CartStatus__c = 'Open';
            newCart.ccrz__CartType__c = 'Cart';
            newCart.ccrz__Contact__c = contactId;
            newCart.ccrz__User__c = userId;
            newCart.ccrz__BillTo__c = billTo.Id;
            newCart.ccrz__ShipTo__c = shipTo.Id;
            newCart.ccrz__Storefront__c = 'PurinaMills';
            newCart.cc_oo_ShipToAccount__c = shipToAccount.Id;
            newCart.cc_oo_Seller__c = sellerId;
            newCart.ccrz__AnonymousId__c = false;
            newCart.cc_oo_CartType__c = 'Prebook';
            newCart.ownerid = userId;
            
            if(secondaryCart) {
                newCart.ccrz__ActiveCart__c = false;
                newCart.cc_oo_SplitCartType__c = 'Secondary';
                for(ccrz__E_Cart__c primaryCart : checkExistingCart) {
                    if(primaryCart.cc_oo_SplitCartType__c == 'Primary') {
                        newCart.cc_oo_SplitCart__c = primaryCart.Id;
                        break;
                    }
                }
            } else {
                newCart.ccrz__ActiveCart__c = true;
                newCart.cc_oo_SplitCartType__c = 'Primary';
                
            }
            insert newCart;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','newCart-->' + newCart);
            //system.debug('newCart-->' + newCart);
            ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
            List<ccrz.ccApiCart.LineData> theNewLines = new List<ccrz.ccApiCart.LineData>();
            theNewLines.add( theNewLine );
            Map<String,Object> createResults = ccrz.ccApiCart.addTo(new Map<String,Object>{
                ccrz.ccApi.API_VERSION => 2,
                ccrz.ccApiCart.CART_ID => newCart.Id,
                ccrz.ccApiCart.LINE_DATA => theNewLines
            });
          
            //General check, since the cart id will be blank if not successful we technically do not need this.
            boolean wasSuccessful = (Boolean)createResults.get(ccrz.ccApi.SUCCESS);
            
            if(wasSuccessful == true){
                string theNewCartId = (String)createResults.get(ccrz.ccApiCart.CART_ENCID);
                
                newCart = [select id, ccrz__EncryptedId__c,cc_oo_SplitCartType__c,ccrz__RequestDate__c, cc_oo_AmendedCart__c  from ccrz__E_Cart__c where ccrz__EncryptedId__c=: theNewCartId limit 1];
                if(newCart.cc_oo_SplitCartType__c == 'Primary') {
                    newCart.ccrz__ActiveCart__c = true;
                } else if(newCart.cc_oo_SplitCartType__c == 'Secondary') {
                    newCart.ccrz__ActiveCart__c = false;
                }
                update newCart;
                return newCart;
            }else{
                return null;
            }
        }
        return null;
        
    
    }
    
    
    //US - 205, 210 - To add promotion code and prevent commitment on existing shipto 
    //Method to get the productListUrl
    //US - 141- To redirect to homepage in case of OO.
    public static String getProductListURL(Id categoryId,String cartId,String url,string sellerId,String portalUserId, string isSameShipto){//OO-3252
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Ship to  boolean-->' + isSameShipto);
        //system.debug('Ship to  boolean-->' + isSameShipto);
        string csrFlow = ccrz.cc_CallContext.currPageParameters.get('isCSRFlow');
        string csrParam = '';
        String returnurl = '';
        if(String.isNotBlank(csrFlow) && csrFlow == 'true'){
            csrParam = 'true';
        }
        /*if(orderType != null && orderType.toLowerCase()==('Prebook').toLowerCase()) {//OO-3252 
            if(portalUserId==null){
               returnurl = url+'/ccrz__Products?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
               if(csrParam == 'true'){
                    returnurl += '&isCSRFlow='+csrParam;    
               }
               returnurl += '&portalUser=&store=&cclcl=en_US&orderType='+orderType+'&promotionCode='+promotionCode+'&sid='+sellerId+'&isSameShipto='+isSameShipto;
               return +returnurl;

            } else {
                returnurl = url+'/ccrz__Products?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
                if(csrParam == 'true'){
                    returnurl += '&isCSRFlow='+csrParam;    
               }
               returnurl += '&portalUser='+portalUserId+'&store=&cclcl=en_US&orderType='+orderType+'&promotionCode='+promotionCode+'&sid='+sellerId+'&isSameShipto='+isSameShipto;
               return +returnurl;   
            }
        } else {*///OO-3252
         if(portalUserId==null){
               returnurl = +url+'/ccrz__HomePage?viewState=ListView&cartId='+cartId+'&categoryId='+categoryId;
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
    
    /***************************************************************************************************************************************
      Method Name : redirect
      Description : redirect is to get the Product List URL for prebook
      Parameter   : cartId :cartId is encrypted id of Cart,ordertype to indicate that its a prebook flow and 
                    url :base url
      Return type : Returns ccrz.cc_RemoteActionResult
      UserStory   : OO-195 - Display only the pre book products in the online ordering system when placing a pre book order                                                              

                    
      *************************************************************************************************************************************/ 
      
    @RemoteAction
    global static ccrz.cc_RemoteActionResult redirect(final ccrz.cc_RemoteActionContext ctx,String cartId,String url,string sellerId,string shipToId, string refreshCart,String portalUserId, string isSameShipto, string shipToDate, boolean isLogoClicked){//OO-3252
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true;
    Map<String,Object> dataMap= new Map<String,Object>();
        //OO-520
         // Strat-Us-OO-2339-delete amended carts primary/secondary which have not been converted to order 
        Set<ccrz__E_Cart__c> availAmendCartListSet=new Set<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> availAmendCartList=new List<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> updateOriginalList=new List<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> amendedCarts = [select id,cc_oo_AmendedCart__c,cc_oo_SplitCart__c from ccrz__E_Cart__c where cc_oo_AmendedCart__c=true AND ccrz__CartStatus__c = 'Open'AND ccrz__User__c =: ccrz.cc_CallContext.currUserId AND 
                                                id NOT IN (select ccrz__OriginatedCart__c from ccrz__E_Order__c) ];
        if(!isLogoClicked){//5203
            if(!amendedCarts.isEmpty()){
                for(ccrz__E_Cart__c amdCart:amendedCarts){
                    if(amdCart.cc_oo_AmendedCart__c){
                        availAmendCartListSet.add(amdCart);
                        if(amdCart.cc_oo_SplitCart__c!=null){
                            ccrz__E_Cart__c secAmndCart=new ccrz__E_Cart__c();  
                            secAmndCart.id=amdCart.cc_oo_SplitCart__c;
                            availAmendCartListSet.add(secAmndCart);
                        }
                    }
                }
                availAmendCartList.addAll(availAmendCartListSet);
                delete availAmendCartList;//defect#4209
            }
        }//5203
        // Strat-Us-OO-2339-delete amended carts primary/secondary which have not been converted to order
        //OO-215
        string newCartId;
        if(refreshCart == 'true'){
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','mapToCart------------------------------>');
            //system.debug('mapToCart------------------------------>');
            ccrz__E_Cart__c newActiveCart = mapToCart(sellerId,shipToId,false);
            Date shipDate= date.parse(shipToDate);
            if(newActiveCart.ccrz__RequestDate__c==null){
                newActiveCart.ccrz__RequestDate__c=shipDate;
                
            }
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','----------------#######################################'+shipDate);
            //system.debug('----------------#######################################'+shipDate);
            

            if(newActiveCart != null){
                if(newActiveCart.ccrz__EncryptedId__c != null){
                    newCartId = newActiveCart.ccrz__EncryptedId__c; 
                    ccrz.cc_CallContext.currCartId = newCartId;  
                }else{
                    newCartId = [select id, ccrz__EncryptedId__c from ccrz__E_Cart__c where id=: newActiveCart.Id].ccrz__EncryptedId__c;
                    ccrz.cc_CallContext.currCartId = newCartId;
                }
                newActiveCart.ccrz__ActiveCart__c = true;
                dataMap=cc_oo_HelperController.shuffleCart(newCartId,shipToDate,null,false);
                newActiveCart.ccrz__RequestDate__c=shipDate;
                update newActiveCart;
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','----------------#######################################'+newActiveCart.ccrz__RequestDate__c);
                //system.debug('----------------#######################################'+newActiveCart.ccrz__RequestDate__c);
                
               
            }

            //Deactive the other carts
            List<ccrz__E_Cart__c> listDeactivateList = new List<ccrz__E_Cart__c>();
            if(newCartId != null && newCartId != ''){
                for(ccrz__E_Cart__c crt: [select id, ccrz__CartStatus__c, ccrz__ActiveCart__c, ccrz__EncryptedId__c from ccrz__E_Cart__c where 
                            ccrz__Account__c =: ccrz.cc_CallContext.currAccountId and ccrz__EncryptedId__c !=: newCartId and ccrz__ActiveCart__c = true]){
                    crt.ccrz__ActiveCart__c = false;
                    listDeactivateList.add(crt);

                }
                Date primaryShipTo;
                if(newActiveCart != null){
                    primaryShipTo= newActiveCart.ccrz__RequestDate__c;
                }
                
                if(primaryShipTo==null){
                    primaryShipTo=shipDate;
                }
                dataMap=cc_oo_HelperController.shuffleCart(newCartId,String.valueOf(shipToDate),null,false);
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','listDeactivateList--->' + listDeactivateList);
                //system.debug('listDeactivateList--->' + listDeactivateList);
                if(!listDeactivateList.isEmpty()){
                    update listDeactivateList;
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','listDeactivateList--->' + listDeactivateList);
                    //system.debug('listDeactivateList--->' + listDeactivateList);
                }
                
                
            
            }
            cartId = newCartId;

        }
        //OO-215

        //OO-3035 -starts
        string parentCategory = LOLSettings__c.getValues('ParentCategory').Value__c;
        ccrz__E_Category__c categoryRoots = Database.query('select Id from ccrz__E_Category__c where Name =: parentCategory LIMIT 1');
        //OO-3035 - Ends
        if(categoryRoots!=null && categoryRoots.id != null){
             String urlName=getProductListURL(categoryRoots.id,cartId,url ,sellerId,portalUserId,isSameShipto);//OO-3252
            res.data=urlName;
        }
        else {
            res= null;
        } 
        return res;
    }
    
    /***************************************************************************************************************************************
      Method Name : getCartDetails
      Description : getCartDetails is to retrieve the primary and secondary cart details
      Parameter   : sellerId, shipToId, cartId
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-2495                                                            
      *************************************************************************************************************************************/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCartDetails(final ccrz.cc_RemoteActionContext ctx,String sellerId, String shipToId, String cartId,boolean fromOrderInfo, String shipDate, boolean clearCart){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = false; 
        Id accountId = ccrz.cc_CallContext.currAccountId;
        Id contactId = ccrz.cc_CallContext.currContact.Id;
        Id userId = ccrz.cc_CallContext.currUser.Id;
        Map<String, Object> dataMap = cc_oo_HelperController.getCartDetails(sellerId,shipToId,cartId,fromOrderInfo,accountId,contactId,userId, shipDate);
        if(clearCart){
            if(dataMap.get('secondaryCart')!=null){
                Map<String,Object> secCartMap=(Map<String,Object>)dataMap.get('secondaryCart');
                ccrz__E_Cart__c secCart= new ccrz__E_Cart__c();
                secCart.id=(id)secCartMap.get('Sid');
                if(dataMap.get('secondaryCartItemsList')!=null){
                    delete (List<ccrz__E_CartItem__c>)dataMap.get('secondaryCartItemsList');
                    delete secCart;
                    dataMap.put('secondaryCart', null);
                }
            }
            if(dataMap.get('primaryCart')!=null){
                Map<String,Object> primaryCartMap=(Map<String,Object>)dataMap.get('primaryCart');
                if(dataMap.get('primaryCartItemsList')!=null){
                    delete (List<ccrz__E_CartItem__c>)dataMap.get('primaryCartItemsList');
                    primaryCartMap.put('weight', 0);
                    primaryCartMap.put('price',null);
                    primaryCartMap.put('noOfItems',0);   
                }
                dataMap.put('primaryCart',primaryCartMap);
            }
        }
        if(dataMap != null) {
            res.success = true;
            res.data = dataMap; 
        }    
        return res;
    }
}