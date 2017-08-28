public without sharing class cc_lol_TestData {
    //Test Util CLass
    // General Constants
    public static final String STOREFRONT_NAME                            = 'PurinaMills'; 
    public static final String ACCOUNT_NAME                               = 'TestAccount';
    public static final String ACCOUNTGROUP_NAME                          = 'TestAccountGroup';
    public static final String ANON_ACCOUNT_NAME                               = 'CCAnonymous';
    public static final String ANON_ACCOUNTGROUP_NAME                          = 'Anonymous';
    public static final String CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME = 'CloudCraze Customer Community User';
    public static final String USER_LANGUAGE                              = 'en_US';
    public static final Decimal DEFAULT_PRICE                             = 100.00;

    // Category Name Constants
    public static final String STOREFRONT_CATEGORY_ROOT        = 'BP Root';
    public static final String STOREFRONT_CATEGORY_ROOT_IR     = 'IR Root';
    public static final String STOREFRONT_CATEGORY_ROOT_EXT_ID = 'LOLRootExtId';
    public static final String PRODUCT_TYPE_CATEGORY_1         = 'ProductType1';
    public static final String PRODUCT_TYPE_CATEGORY_2         = 'ProductType2';
    public static final String BRAND_CATEGORY_1                = 'Brand1';
    public static final String BRAND_CATEGORY_2                = 'Brand2';
    public static final String BRAND_CATEGORY_3                = 'Brand3';
    public static final String BRAND_CATEGORY_4                = 'Brand4';
    public static final String SUB_BRAND_CATEGORY_1            = 'SubBrand1';
    public static final String SUB_BRAND_CATEGORY_2            = 'SubBrand2';
    public static final String SUB_BRAND_CATEGORY_3            = 'SubBrand3';
    public static final String SUB_BRAND_CATEGORY_4            = 'SubBrand4';

    private static Boolean catalogSetupIsComplete = false;


    public static ccrz__E_AccountGroup__c testAccountGroup {
        get {
            if (testAccountGroup == null) {
                testAccountGroup = new ccrz__E_AccountGroup__c( Name = ACCOUNTGROUP_NAME );
                insert testAccountGroup;
            }
            return testAccountGroup;
        }
        private set;
    }

    public static ccrz__E_AccountGroup__c anonAccountGroup {
        get {
            if (anonAccountGroup == null) {
                anonAccountGroup = new ccrz__E_AccountGroup__c( Name = ANON_ACCOUNTGROUP_NAME );
                insert anonAccountGroup;
            }
            return anonAccountGroup;
        }
        private set;
    }
    
    public static Account testAccount {
        get {
            if (testAccount == null) {
                testAccount = new Account(
                        Name                    = ACCOUNT_NAME,
                        ccrz__E_AccountGroup__c = testAccountGroup.Id,
                        OwnerId                 = UserInfo.getUserId(),
                        Type                    = 'Customer',
                        BillingStreet           = generateRandomString(32),
                        BillingCity             = generateRandomString(32),
                        AccountNumber           = '250287',
                        Parent_Account_Number__c ='250287',
                        Payment_Term_Desc_JDE__c ='3% Cash-ACH Draft',
                        ShipTo_Flag__c          = true,
                        //Dedicated_Customer_Op_Rep__c = UserInfo.getUserId(),
                        Ship_to_Number__c = '250287',
                        Email__c = 'abc@gmail.com',
                        Delivery_Instruction_1__c = 'Delivery instructions 1',
                        Delivery_Instruction_2__c = 'Delivery instructions 2'
                        //Dedicated_Customer_Op_Rep__c = UserInfo.getUserId()
                );
                insert testAccount;
            }
            return testAccount;
        }
        private set;
    }

	
    public static Account anonAccount {
        get {
            if (anonAccount == null) {
                anonAccount = new Account(
                        Name                    = ANON_ACCOUNT_NAME,
                        ccrz__E_AccountGroup__c = anonAccountGroup.Id,
                        OwnerId                 = UserInfo.getUserId(),
                        Type                    = 'Customer',
                        BillingStreet           = generateRandomString(32),
                        BillingCity             = generateRandomString(32)
                );
                insert anonAccount;
            }
            return anonAccount;
        }
        private set;
    }

    public static User testUser {
        get {
            if (testUser == null) {
                setupTestUser();
            }
            return testUser;
        }
        private set;
    }


    public static ccrz__E_ContactAddr__c billToAddress {
        get {
            if (billToAddress == null) {
                billToAddress = getContactAddress();
                insert billToAddress;
            }
            return billToAddress;
        }
        private set;
    }


    public static ccrz__E_ContactAddr__c shipToAddress {
        get {
            if (shipToAddress == null) {
                shipToAddress = getContactAddress();
                insert shipToAddress;
            }
            return shipToAddress;
        }
        private set;
    }

    public static List<ccrz__E_Product__c> products {
        get {
            if (products == null || products.isEmpty()) {
                setupCatalog();
            }
            return products;
        }
        private set;
    }
    
    public static List<ccrz__E_ProductMedia__c> prodMedia {
        get {
            if (prodMedia == null || prodMedia.isEmpty()) {
                setupCatalog();
            }
            return prodMedia;
        }
        private set;
    }
    
    public static List<cc_oo_ContractPrice__c> contractprice{
    	 get {
            if (contractprice== null || contractprice.isEmpty()) {
                setupCatalog();
            }
            return contractprice;
        }
        private set;
    }
    
    public static List<CC_OO_PlantHolidayCalendar__c> holidayCalendar{
    	 get {
            if (holidayCalendar== null || holidayCalendar.isEmpty()) {
                setupCatalog();
            }
            return holidayCalendar;
        }
        private set;
    }
    
    public static List<CC_OO_PlantCutOff__c> cutoffTime{
    	 get {
            if (cutoffTime== null || cutoffTime.isEmpty()) {
                setupCatalog();
            }
            return cutoffTime;
        }
        private set;
    }
    
    
   /* public static List<cc_oo_Product> productsOO {
        get {
            if (productsOO == null || productsOO.isEmpty()) {
                setupCatalog();
            }
            return productsOO;
        }
        private set;
    }*/
    
    public static Map<String,String> pageLabels {
        get {
            if (pageLabels == null) {
                pageLabels = new Map<String,String>();
                setupCatalog();
            }
            return pageLabels;
        }
        private set;
    }
  
  public static List<ccrz__E_ProductInventoryItem__c> productsInventory {
        get {
            if (productsInventory == null || productsInventory.isEmpty()) {
                setupCatalog();
            }
            return productsInventory;
        }
        private set;
    }
    public static Map<String,ccrz__E_Category__c> categoryMap {
        get {
            if (categoryMap == null) {
                categoryMap = new Map<String,ccrz__E_Category__c>();
                setupCatalog();
            }
            return categoryMap;
        }
        private set;
    }

    public static List<ccrz__E_ProductCategory__c> productCategories {
        get {
            if (productCategories == null) {
                setupCatalog();
            }
            return productCategories;
        }
        private set;
    }


    /*------------------------------------------------------------
    Description:   Create a Test User, Contact, Account,
                   and Account Group
    ------------------------------------------------------------*/
   
    public static void setupTestUser() {
        UserRole role = new UserRole(DeveloperName = 'TestUser', Name = 'TestRole');
        insert role;
        
        Contact contactCC = new Contact(
                FirstName = generateRandomString(8),
                LastName  = generateRandomString(9),
                Email = generateRandomString(4)+'@'+ generateRandomString(4)+'.com',
                AccountId = testAccount.Id,
                MailingStreet = 'abc'
        );
        insert contactCC;

        Profile profile = [SELECT Id
        FROM Profile
        WHERE Name = :CLOUDCRAZE_CUSTOMER_COMMUNITY_PROFILE_NAME LIMIT 1];

        User testOwner = [SELECT TimeZoneSidKey, UserRoleId
        FROM User
        WHERE Id = :UserInfo.getUserId()];

        String emailAddress = String.valueOf(System.now().getTime() + '@cc-test.mail');
        testUser = new User(
                Alias                    = 'cctest',
                Email                    = emailAddress,
                EmailEncodingKey         = 'UTF-8',
                LastName                 = 'TestUser',
                LanguageLocaleKey        = 'en_US',
                LocaleSidKey             = 'en_US',
                ProfileId                = profile.Id,
                TimeZoneSidKey           = testOwner.TimeZoneSidKey,
                Username                 = emailAddress,
                isActive                 = true,
                ContactId                = contactCC.Id,
                Contact                  = contactCC,
                UserRole                 = role,
                ccrz__CC_CurrencyCode__c = 'USD'
        );
        insert testUser;

        update testUser.Contact;
    }


    /*------------------------------------------------------------
    Description:   Create CC Cart
    ------------------------------------------------------------*/
   
    public static ccrz__E_Cart__c createCart() {
        Account anonAcc = anonAccount;
        ccrz__E_AccountGroup__c anonAccGrp = anonAccountGroup;
        return createCarts(1).get(0);
    }

    /*------------------------------------------------------------
    Description:   Create CC Carts
    ------------------------------------------------------------*/

    public static List<ccrz__E_Cart__c> createCarts(Integer numberOfCarts) {

        final List<ccrz__E_Cart__c> testCarts = new List<ccrz__E_Cart__c>();
        final List<ccrz__E_Seller__c> sellers = new List<ccrz__E_Seller__c>{
                new ccrz__E_Seller__c(
                        
                        ccrz__SellerId__c            = 'ABDN',                        
                        ccrz__Storefront__c          = STOREFRONT_NAME,
                        ccrz__Enabled__c             = true,
                        cc_oo_Zip__c                 = '567676',
                        cc_oo_State__c               = 'CA',
                        ccrz__EffectiveStart__c      = Date.Today()-10,
                        ccrz__EffectiveEnd__c        = Date.Today()+10
                )
        };
        insert sellers;
        System.assert(testUser != null);
        for (Integer i = 0; i < numberOfCarts; i++) {
            testCarts.add(
                    new ccrz__E_Cart__c(
                            ccrz__Account__c         = testAccount.Id,
                            ccrz__CartType__c        = 'Cart',
                            ccrz__CartStatus__c      = 'Open',
                            ccrz__User__c            = testUser.Id,
                            ccrz__Contact__c         = testUser.ContactId,
                            ccrz__Name__c            = 'cart',
                            OwnerId                  = testUser.Id,
                            ccrz__AnonymousID__c     = false,
                            cc_oo_SplitCartType__c   = 'Primary' ,
                            cc_oo_SplitCart__c     = null,
                            ccrz__ActiveCart__c      = true,
                            ccrz__SessionId__c       = 'testing',
                            ccrz__CurrencyISOCode__c = 'USD',
                            ccrz__Storefront__c      = STOREFRONT_NAME,
                            ccrz__EncryptedId__c     = 'encid' + String.valueOf(Crypto.getRandomInteger()),//i
                            ccrz__BillTo__c          = billToAddress.Id,
                            ccrz__ShipTo__c          = shipToAddress.Id,
                            cc_oo_Alternate_Email_Id__c    = 'abc@xyz.com',
                            ccrz__PONumber__c           =  '12345',
                            cc_oo_ShipToAccount__c = testAccount.Id,
                            ccrz__RequestDate__c     = Date.Today(),
                            cc_oo_Seller__c         = sellers[0].id,
                    	    cc_oo_PickUpTime__c = '7:00 AM',
                            ccrz__Note__c = 'This is a note',
			    			ccrz__ShipMethod__c = 'null - Pick Up',
			    			cc_oo_TimeZone__c = 'CST',
			    			cc_oo_AmendedCart__c =false
                    )
            );
        }
        System.assertEquals(testCarts.size(), numberOfCarts);
        upsert testCarts;

        final List<ccrz__E_PaymentDetail__c> testPaymentDetails = new List<ccrz__E_PaymentDetail__c>();
        final List<String> cartIds                              = new List<String>();

        for (Integer i = 0; i < numberOfCarts; i++) {
            testPaymentDetails.add(
                    new ccrz__E_PaymentDetail__c(
                            ccrz__Cart__c           = testCarts.get(i).Id,
                            ccrz__Payment_Method__c = 'PO Number',
                            ccrz__Account_Number__c = 'PO' + String.valueOf(i)
                    ));
            cartIds.add(testCarts.get(i).Id);
        }
        insert testPaymentDetails;

        return [SELECT Id, ccrz__User__c,ccrz__User__r.Id,ccrz__Account__r.Id,ccrz__Contact__r.Id,ccrz__Contact__c,ccrz__Account__c, ccrz__EncryptedId__c,
        cc_oo_SplitCartType__c,cc_oo_SplitCart__c
        FROM ccrz__E_Cart__c
        WHERE Id IN :cartIds];
    }
    
    /*------------------------------------------------------------
    Description:   Add Items to Test CC Cart
    ------------------------------------------------------------*/

    public static ccrz__E_CartItem__c addCartItem(ccrz__E_Cart__c testCart, Id prodId, Decimal qty, Decimal price) {
        return addCartItems(testCart,
                new Map<Id,Decimal> { prodId => qty },
                new Map<Id,Decimal> { prodId => price }).get(0);
    }
    public static List<ccrz__E_CartItem__c> addCartItems(ccrz__E_Cart__c testCart,
            Map<Id,Decimal> productQuantityMap,
            Map<Id,Decimal> productPriceMap
    ) {
        final List<ccrz__E_CartItem__c> items = new List<ccrz__E_CartItem__c>();
        final Map<Id,Decimal> itemPrices      = (null == productPriceMap) ? new Map<Id,Decimal>() : productPriceMap;

        for (Id productId : productQuantityMap.keySet()) {
            final Decimal itemPrice = itemPrices.containsKey(productId) ? itemPrices.get(productId) : DEFAULT_PRICE;
            items.add(
                    new ccrz__E_CartItem__c(
                            ccrz__Cart__c         = testCart.Id,
                            ccrz__Quantity__c     = productQuantityMap.get(productId),
                            ccrz__Product__c      = productId,
                            ccrz__Price__c        = itemPrice,
                            ccrz__SubAmount__c    = productQuantityMap.get(productId)*itemPrice,
                            ccrz__cartItemType__c = 'Major',
                            cc_oo_IsListPrice__c  = false,
                            cc_oo_UnitPrice__c    = itemPrice,
                            cc_oo_ContractPrice__c=contractprice[1].Id
                    ));
        }
        insert items;
        return items;
    }


    /*------------------------------------------------------------
    Description:   Setup CloudCraze Catalog
    ------------------------------------------------------------*/

    public static void setupCatalog() {
        if (catalogSetupIsComplete) {
            return;
        }
        catalogSetupIsComplete = true;

        //******************************************************************************
        // INSERT STOREFRONT SETTINGS
        //******************************************************************************
        ccrz.cc_util_Reflection.createStorefrontSetting(STOREFRONT_NAME);
        ccrz.cc_util_Reflection.updateStorefrontSettings(STOREFRONT_NAME, 'ccrz__DefaultLanguage__c', USER_LANGUAGE);

        System.debug('@@Created storefront setting: ' + STOREFRONT_NAME);

         final List<ccrz__E_Seller__c> sellers = new List<ccrz__E_Seller__c>{
                new ccrz__E_Seller__c(
                        
                        ccrz__SellerId__c            = 'ABDN',                        
                        ccrz__Storefront__c          = STOREFRONT_NAME,
                        ccrz__Enabled__c             = true,
                        cc_oo_Zip__c                 = '567676',
                        cc_oo_State__c               = 'CA',
                        ccrz__EffectiveStart__c      = Date.Today()-10,
                        ccrz__EffectiveEnd__c        = Date.Today()+10
                )
        };
        insert sellers;

        //ccrz.cc_util_Reflection.addFactoryEntry(string factoryName, string factoryClass, string apiName, string daoName, string serviceName);

        //******************************************************************************
        // INSERT PRICE LISTS
        //******************************************************************************
        final List<ccrz__E_PriceList__c> priceLists = new List<ccrz__E_PriceList__c> {
                new ccrz__E_PriceList__c(
                        Name                     = 'PL002',
                        ccrz__CurrencyISOCode__c = 'USD',
                        ccrz__Enabled__c         = true,
                        ccrz__Storefront__c      = STOREFRONT_NAME,
                        ccrz__StartDate__c       = Date.today().addDays(-7),
                        ccrz__EndDate__c         = Date.today().addDays(7),
                        ccrz__Seller__c          = sellers[0].Id,
                        ccrz__PricelistId__c	= '250287-ABDN',
                        cc_oo_ShipToNumber__c	= 250287
                )
        };
        insert priceLists;
        
        final List<ccrz__E_AccountGroupPriceList__c> testAccountGroupPriceLists = new List<ccrz__E_AccountGroupPriceList__c>();

        for (ccrz__E_PriceList__c priceList : priceLists) {
            testAccountGroupPriceLists.add(
                    new ccrz__E_AccountGroupPriceList__c(
                            ccrz__AccountGroup__c = testAccountGroup.Id,
                            ccrz__PriceList__c    = priceList.Id,
                            ccrz__Enable__c       = true
                    ));
            testAccountGroupPriceLists.add(
                    new ccrz__E_AccountGroupPriceList__c(
                            ccrz__AccountGroup__c = anonAccountGroup.Id,
                            ccrz__PriceList__c    = priceList.Id,
                            ccrz__Enable__c       = true
                    ));
        }
        insert testAccountGroupPriceLists;
        
        //******************************************************************************
        // INSERT CC_OO_Customer_Freight__c
        //******************************************************************************
         final List<CC_OO_Customer_Freight__c> freights = new List<CC_OO_Customer_Freight__c>{
                new CC_OO_Customer_Freight__c(
                        Plant_Name__c              = sellers[0].id,
                        ShipTo_Account_Number__c    = 212121,
                        Product_Type__c             = 'prebook'
                )
         };
        insert freights;
        
        /*ccrz__E_ProductMedia__c prodMedia =new ccrz__E_ProductMedia__c(
                            ccrz__Product__c            = product.Id,
                            ccrz__FilePath__c           = generateRandomString(10),
                            ccrz__ProductMediaSource__c = 'static',
                            ccrz__StaticResourceName__c = generateRandomString(10),
                            ccrz__URI__c=generateRandomString(10)
                    );
         insert prodMedia;*/
       

        //******************************************************************************
        // INSERT PRODUCTS
        //******************************************************************************
        products = new List<ccrz__E_Product__c>{
                new ccrz__E_Product__c(
                        Name                       = 'product001 Bag',
                        ccrz__SKU__c               = 'test001',
                        ccrz__ProductId__c         = 'test001',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        ccrz__HazardousFlag__c     = true,
						ccrz__ShortDesc__c		   ='product001 Bag',
						ccrz__LongDesc__c		   ='product001 Bag',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='product001 Bag'
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product002',
                        ccrz__SKU__c               = 'test002',
                        ccrz__ProductId__c         = 'test002',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        ccrz__HazardousFlag__c     = true,
						ccrz__ShortDesc__c		   ='product002 Bag',
						ccrz__LongDesc__c		   ='product002 Bag',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='product002 Bag'
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product003',
                        ccrz__SKU__c               = 'test003',
                        ccrz__ProductId__c         = 'test003',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        cc_oo_TypeOfProduct__c     = 'BULK',
                        ccrz__HazardousFlag__c     = true,
						ccrz__ShortDesc__c		   ='product003',
						ccrz__LongDesc__c		   ='product003',
						cc_oo_UoMDesc__c		   ='BULK',
						cc_oo_Second_Description__c='product003'
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product004',
                        ccrz__SKU__c               = 'test004',
                        ccrz__ProductId__c         = 'test004',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = true,
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        
						ccrz__ShortDesc__c		   ='product004',
						ccrz__LongDesc__c		   ='product004',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='product004'
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product005 Pallet',
                        ccrz__SKU__c               = 'test005',
                        ccrz__ProductId__c         = 'test005',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = true,
						ccrz__ShortDesc__c		   ='product005',
						ccrz__LongDesc__c		   ='product005',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_TypeOfProduct__c     = 'BAG',
						cc_oo_Second_Description__c='product005'
                ),
                new ccrz__E_Product__c(
                        Name                       = 'product007',
                        ccrz__SKU__c               = 'test007',
                        ccrz__ProductId__c         = 'test007',
                        ccrz__ProductStatus__c     = 'Blocked',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='product007',
						ccrz__LongDesc__c		   ='product007',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='product007'
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FILTER IN-LINE',
                        ccrz__SKU__c               = '023 20878 001',
                        ccrz__ProductId__c         = '023 20878 001',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FILTER IN-LINE',
						ccrz__LongDesc__c		   ='FILTER IN-LINE',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='FILTER IN-LINE'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'HG Layer',
                        ccrz__SKU__c               = '0001823',
                        ccrz__ProductId__c         = '0001823',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500, 
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='HG Layer',
						ccrz__LongDesc__c		   ='HG Layer',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='HG Layer'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FLK RAISER',
                        ccrz__SKU__c               = '3003340-303',
                        ccrz__ProductId__c         = '3003340-303',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        cc_oo_TypeOfProduct__c     = 'BAG',
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FLK RAISER',
						ccrz__LongDesc__c		   ='FLK RAISER',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_Second_Description__c='FLK RAISER'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FLK RAISER 20',
                        ccrz__SKU__c               = '612435',
                        ccrz__ProductId__c         = '612435',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FLK RAISER 20',
						ccrz__LongDesc__c		   ='FLK RAISER 20',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_TypeOfProduct__c     = 'BAG',
						cc_oo_Second_Description__c='FLK RAISER 20'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FLK RAISER 30',
                        ccrz__SKU__c               = '72369',
                        ccrz__ProductId__c         = '72369',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FLK RAISER 30',
						ccrz__LongDesc__c		   ='FLK RAISER 30',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_TypeOfProduct__c     = 'BAG',
						cc_oo_Second_Description__c='FLK RAISER 30'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FLK RAISER 40',
                        ccrz__SKU__c               = '43166',
                        ccrz__ProductId__c         = '43166',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FLK RAISER 40',
						ccrz__LongDesc__c		   ='FLK RAISER 40',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_TypeOfProduct__c     = 'BAG',
						cc_oo_Second_Description__c='FLK RAISER 40'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FLK RAISER 50',
                        ccrz__SKU__c               = '16251652',
                        ccrz__ProductId__c         = '16251652',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'BG',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FLK RAISER 50',
						ccrz__LongDesc__c		   ='FLK RAISER 50',
						cc_oo_UoMDesc__c		   ='BAG',
						cc_oo_TypeOfProduct__c     = 'BAG',
						cc_oo_Second_Description__c='FLK RAISER 50'                     
                ),
                new ccrz__E_Product__c(
                        Name                       = 'FLK RAISER 60',
                        ccrz__SKU__c               = '97827',
                        ccrz__ProductId__c         = '97827',
                        ccrz__ProductStatus__c     = 'Released',
                        ccrz__UnitOfMeasure__c     = 'LB',
                        ccrz__StartDate__c         = Date.today().addDays(-7),
                        ccrz__EndDate__c           = Date.today().addDays(7),
                        ccrz__Storefront__c        = STOREFRONT_NAME,
                        ccrz__ProductWeight__c     = 500,
                        ccrz__HazardousFlag__c     = false,
						ccrz__ShortDesc__c		   ='FLK RAISER 60',
						ccrz__LongDesc__c		   ='FLK RAISER 60',
						cc_oo_UoMDesc__c		   ='BULK',
						cc_oo_TypeOfProduct__c     = 'BULK',
						cc_oo_Second_Description__c='FLK RAISER 60'                     
                )
        };
        insert products;
        
        //******************************************************************************
        // INSERT CC_OO_CONTRACTPRICE
        //******************************************************************************
        final Decimal contractItemPrice = DEFAULT_PRICE;
        contractprice = new List<cc_oo_ContractPrice__c> {
                new cc_oo_ContractPrice__c(
                        cc_oo_AvailabilityQty__c = 20,
                        cc_oo_Product__c = products[7].Id,
                    	cc_oo_ContractPrice__c =contractItemPrice,
                        cc_oo_CommitedQty__c = 10,
                        cc_oo_ContractQty__c = 10,
                        cc_oo_ContractUoM__c = 'testBag',
                        cc_oo_ConversionValue__c = 10,
                        cc_oo_ContractUoMDesc__c = 'TestData',
                        cc_oo_DwChecksum__c = 'testABC',
                        cc_oo_EffectiveDate__c = Date.today().addDays(-10),
                        cc_oo_ExpireDate__c = Date.today().addDays(+10),
                        cc_oo_QuantityUpdateDate__c = Date.today().addDays(-7),
                        cc_oo_ShipConfirm__c = 10,
                        cc_oo_ShipToNumber__c = testAccount.Id,
                        cc_oo_Seller__c =sellers[0].Id,
						cc_oo_isfreightincluded__c = true,
                        cc_oo_AvailabilityQtyUoMContract__c =5,
                        cc_oo_ContractNumber__c = 123,
                        cc_oo_contractPriceID__c = '111078-LANS-131529-3001498-201'
                ),
                new cc_oo_ContractPrice__c(
                        cc_oo_AvailabilityQty__c = 20,
                        cc_oo_Product__c = products[8].Id,
                    	cc_oo_ContractPrice__c=contractItemPrice,
                        cc_oo_CommitedQty__c = 10,
                        cc_oo_ContractQty__c = 10,
                        cc_oo_ContractUoM__c = 'testBag1',
                        cc_oo_ConversionValue__c = 10,
                        cc_oo_ContractUoMDesc__c = 'TestDataa',
                        cc_oo_DwChecksum__c = 'testABCD',
                        cc_oo_EffectiveDate__c = Date.today().addDays(-10),
                        cc_oo_ExpireDate__c = Date.today().addDays(+10),
                        cc_oo_QuantityUpdateDate__c = Date.today().addDays(-7),
                        cc_oo_ShipConfirm__c = 10,
                        cc_oo_ShipToNumber__c = testAccount.Id,
                        cc_oo_Seller__c=sellers[0].Id,
						cc_oo_isfreightincluded__c = true,
                        cc_oo_AvailabilityQtyUoMContract__c =5,
                        cc_oo_ContractNumber__c = 345,
                        cc_oo_contractPriceID__c = '111078-LANS-131529-3001498-200'
                ),
                 new cc_oo_ContractPrice__c(
                        cc_oo_AvailabilityQty__c = 10,
                        cc_oo_Product__c = products[0].Id,
                    	cc_oo_ContractPrice__c =contractItemPrice,
                        cc_oo_CommitedQty__c = 10,
                        cc_oo_ContractQty__c = 10,
                        cc_oo_ContractUoM__c = 'testBag',
                        cc_oo_ConversionValue__c = 10,
                        cc_oo_ContractUoMDesc__c = 'TestData',
                        cc_oo_DwChecksum__c = 'testABC',
                        cc_oo_EffectiveDate__c = Date.today().addDays(-10),
                        cc_oo_ExpireDate__c = Date.today().addDays(+10),
                        cc_oo_QuantityUpdateDate__c = Date.today().addDays(-7),
                        cc_oo_ShipConfirm__c = 10,
                        cc_oo_ShipToNumber__c = testAccount.Id,
                        cc_oo_Seller__c =sellers[0].Id,
						cc_oo_isfreightincluded__c = true,
                        cc_oo_AvailabilityQtyUoMContract__c =5,
                        cc_oo_ContractNumber__c = 456,
                        cc_oo_contractPriceID__c = '111078-LANS-131529-3001498-101'
                )
                
                
        };
        insert contractprice;
        
        //******************************************************************************
        // INSERT CC_OO_PlantHolidayCalendar__c
        //******************************************************************************
        Date newDate = Date.today();
        Integer month = newDate.month();
        Integer year = newDate.year();
        holidayCalendar = new List<CC_OO_PlantHolidayCalendar__c> {
                new CC_OO_PlantHolidayCalendar__c(
                        cc_oo_Holiday__c = newDate.addDays(2),
                        cc_oo_IsNotWeekend__c =false,
                        cc_oo_Month__c = String.valueOf(month),
                        cc_oo_Plant__c =sellers[0].Id,
                        cc_oo_Year__c = String.valueOf(year)
                ),
                new CC_OO_PlantHolidayCalendar__c(
                        cc_oo_Holiday__c = newDate.addDays(3),
                        cc_oo_IsNotWeekend__c =true,
                        cc_oo_Month__c = String.valueOf(month),
                        cc_oo_Plant__c =sellers[0].Id,
                        cc_oo_Year__c = String.valueOf(year)
                ),
                 new CC_OO_PlantHolidayCalendar__c(
                        cc_oo_Holiday__c = newDate.addDays(4),
                        cc_oo_IsNotWeekend__c =true,
                        cc_oo_Month__c = String.valueOf(month),
                        cc_oo_Plant__c =sellers[0].Id,
                        cc_oo_Year__c = String.valueOf(year)
                )
                
                
        };
        insert holidayCalendar;
        
        //******************************************************************************
        // INSERT CC_OO_PlantCutOff
        //******************************************************************************
       
        cutoffTime = new List<CC_OO_PlantCutOff__c> {
                new CC_OO_PlantCutOff__c(
                        cc_oo_AMPM__c = 'AM',
                        cc_oo_PlantCutoffTime__c ='10:20',
                        cc_oo_ProductType__c = 'BAG',
                        cc_oo_Seller__c =sellers[0].Id,
                        cc_oo_TimeZone__c = 'PST',
                        cc_oo_ShippingMethod__c = 'Delivery',
                        cc_oo_Plant__c = 'ARCO',
                        cc_oo_FullTruckLoad__c = 1000
                ),
                new CC_OO_PlantCutOff__c(
                        cc_oo_AMPM__c = 'PM',
                        cc_oo_PlantCutoffTime__c ='10:20',
                        cc_oo_ProductType__c = 'BAG',
                        cc_oo_Seller__c =sellers[0].Id,
                        cc_oo_TimeZone__c = 'PST',
                        cc_oo_ShippingMethod__c = 'Pick Up',
                        cc_oo_Plant__c = 'ARCO',
                        cc_oo_FullTruckLoad__c = 1000
                ),
                 new CC_OO_PlantCutOff__c(
                        cc_oo_AMPM__c = 'AM',
                        cc_oo_PlantCutoffTime__c ='10:20',
                        cc_oo_ProductType__c = 'BULK',
                        cc_oo_Seller__c =sellers[0].Id,
                        cc_oo_TimeZone__c = 'PST',
                        cc_oo_ShippingMethod__c = 'Delivery',
                        cc_oo_Plant__c = 'ARCO',
                        cc_oo_FullTruckLoad__c = 1000
                ),
                new CC_OO_PlantCutOff__c(
                        cc_oo_AMPM__c = 'PM',
                        cc_oo_PlantCutoffTime__c ='10:20',
                        cc_oo_ProductType__c = 'BULK',
                        cc_oo_Seller__c =sellers[0].Id,
                        cc_oo_TimeZone__c = 'PST',
                        cc_oo_ShippingMethod__c = 'Pick Up',
                        cc_oo_Plant__c = 'ARCO',
                        cc_oo_FullTruckLoad__c = 1000
                ),
                new CC_OO_PlantCutOff__c(
                        cc_oo_AMPM__c = 'AM',
                        cc_oo_PlantCutoffTime__c ='10:20',
                        cc_oo_ProductType__c = 'Packaged',
                        cc_oo_Seller__c =sellers[0].Id,
                        cc_oo_TimeZone__c = 'PST',
                        cc_oo_ShippingMethod__c = 'Delivery',
                        cc_oo_Plant__c = 'ARCO',
                        cc_oo_FullTruckLoad__c = 1000
                ),
                new CC_OO_PlantCutOff__c(
                        cc_oo_AMPM__c = 'PM',
                        cc_oo_PlantCutoffTime__c ='10:20',
                        cc_oo_ProductType__c = 'Packaged',
                        cc_oo_Seller__c =sellers[0].Id,
                        cc_oo_TimeZone__c = 'PST',
                        cc_oo_ShippingMethod__c = 'Pick Up',
                        cc_oo_Plant__c = 'ARCO',
                        cc_oo_FullTruckLoad__c = 1000
                )
                
                
        };
        insert cutoffTime;
        
        //******************************************************************************
        // INSERT cc_oo_Product
        //******************************************************************************
        /*productsOO = new List<cc_oo_Product> {
                new cc_oo_Product(
                        sku='0001823',
                        quantity=20
                ),
                new cc_oo_Product(
                        sku='3003340-303',
                        quantity=20
                )
        };
        insert productsOO;*/
        
        pageLabels.put('Prod_Disc_Replacement','Prod discontinued');
        pageLabels.put('Product_Out_Of_Season','Prod Out of Season');
        pageLabels.put('Product_Unavailable','Prod Available');
        pageLabels.put('Prod_Disc_Without_Replacement','Prod discontinued without replacement');
        pageLabels.put('Prod_Num_Not_Sold','This product is not Sold At this Ship From.');
        pageLabels.put('Invalid_Quantity','Please enter a valid quantity.');
        pageLabels.put('BULK', 'BULK');
        pageLabels.put('LIQUID', 'LIQUID');
        pageLabels.put('TON', 'TON');
        pageLabels.put('JDEDownPriceMessage_QuickOrder', 'Price not available at this moment. Please remove this product to proceed.');
        
        
        //******************************************************************************
        final List<ccrz__E_RelatedProduct__c> relatedProd = new List<ccrz__E_RelatedProduct__c> {
                new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[8].Id,
                    	ccrz__RelatedProduct__c = products[7].Id
                ),
                new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[9].Id,
                    	ccrz__RelatedProduct__c = products[7].Id,
                    	ccrz__RelatedProductType__c='Seasonal'
                ),
                 new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[9].Id,
                    	ccrz__RelatedProduct__c = products[8].Id,
                    	ccrz__RelatedProductType__c='Seasonal'
                ),
                 new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[9].Id,
                    	ccrz__RelatedProduct__c = products[1].Id,
                    	ccrz__RelatedProductType__c='Replaced'
                ),
                 new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[9].Id,
                    	ccrz__RelatedProduct__c = products[10].Id,
                    	ccrz__RelatedProductType__c='Alternate'
                ),
                new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[10].Id,
                    	ccrz__RelatedProduct__c = products[7].Id
                ),
                new ccrz__E_RelatedProduct__c(
                    	ccrz__Product__c = products[11].Id,
                    	ccrz__RelatedProduct__c = products[7].Id
                )
        };
        insert relatedProd;
        
        //******************************************************************************
        // INSERT ccrz__E_FeaturedProduct__c
        //******************************************************************************
        final List<ccrz__E_FeaturedProduct__c> spotlightProd = new List<ccrz__E_FeaturedProduct__c> {
                new ccrz__E_FeaturedProduct__c(
                    	ccrz__Product__c = products[8].Id,
						ccrz__Type__c = 'Spotlight',
						ccrz__Enabled__c=true                
						),
                new ccrz__E_FeaturedProduct__c(
                    	ccrz__Product__c = products[7].Id,
                    	ccrz__Type__c = 'Spotlight',
						ccrz__Enabled__c=true  
                )
                
        };
        insert spotlightProd;
        
        
        
        
        final Decimal itemPrice = DEFAULT_PRICE;
        final List<cc_oo_PriceList__c> customPriceLists = new List<cc_oo_PriceList__c> {
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = itemPrice,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[0].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = true
                ),
                
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = itemPrice,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[1].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = false
                ),
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = itemPrice,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[7].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = true
                ),
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = itemPrice,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[8].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = false
                ),
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = itemPrice,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[9].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = true
                ),
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = itemPrice,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[10].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = false
                ),
                new cc_oo_PriceList__c(
                        cc_oo_EffectiveDate__c      = Date.today().addDays(-7),
                        cc_oo_ExpirationDate__c     = Date.today().addDays(+7),
                        cc_oo_IsJDEPriceUpdated__c  = true,
                        cc_oo_Price__c              = itemPrice,
                        cc_oo_NetListPrice__c       = null,
                        cc_oo_PalletPrice__c        = itemPrice,
                        cc_oo_Product__c            = products[13].Id,
                        cc_oo_Seller__c             = sellers[0].Id,
                        cc_oo_ShipTo__c             = testAccount.Id,
                        cc_oo_PriceListID__c        = 'Price',
                        cc_oo_isfreightincluded__c  = false
                )
        };
        insert customPriceLists ;
        

        //******************************************************************************
        // INSERT PRODUCTSINVEMTORY
        //******************************************************************************
        
        productsInventory = new List<ccrz__E_ProductInventoryItem__c>{
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample1',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '12',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[8].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample2',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '10',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[0].Id,
						cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,    
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample3',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '11',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[1].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample4',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '12',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[1].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample5',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '17',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[1].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample6',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '14',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[0].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample7',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[0].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                          
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample8',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[7].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =false,
                        CC_OO_MinQuantity__c = 5,
                        ccrz__AvailabilityMessage__c ='Available'
                                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample9',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Replaced',
                        ccrz__ProductItem__c       = products[8].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                        
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample10',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Discontinued',
                        ccrz__ProductItem__c       = products[9].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                     
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample11',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Out of Season',
                        ccrz__ProductItem__c       = products[10].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                          
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample12',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Unavailable',
                        ccrz__ProductItem__c       = products[11].Id,
						cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                         
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample13',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[12].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                      
                ),
                new ccrz__E_ProductInventoryItem__c(
                        Name                       = 'Sample13',
                        cc_oo_Seller__c            = sellers[0].id,
                        cc_oo_LeadTime__c          = '15 days',
                        ccrz__Status__c          = 'Available',
                        ccrz__ProductItem__c       = products[13].Id,
                        cc_oo_PalletSize__c        = 10,
                        cc_oo_IsOnlyPalletProduct__c =true,
                        CC_OO_MinQuantity__c = 5    ,
                        ccrz__AvailabilityMessage__c ='Available'
                                      
                )
        };
        insert productsInventory;
        
        //final List<ccrz__E_ProductMedia__c> productMedia    = new List<ccrz__E_ProductMedia__c>();
        final List<ccrz__E_ProductItemI18N__c> producti18ns = new List<ccrz__E_ProductItemI18N__c>();
        final List<ccrz__E_PriceListItem__c> priceListItems = new List<ccrz__E_PriceListItem__c>();
		
		prodMedia = new List<ccrz__E_ProductMedia__c>{
                    new ccrz__E_ProductMedia__c(
                            ccrz__Product__c            = products[7].Id,
                            ccrz__FilePath__c           = generateRandomString(10),
                            ccrz__ProductMediaSource__c = 'static',
                            ccrz__StaticResourceName__c = generateRandomString(10),
							ccrz__MediaType__c='Product Image',
                            ccrz__URI__c=generateRandomString(10)
                    ),
                    new ccrz__E_ProductMedia__c(
                            ccrz__Product__c            = products[8].Id,
                            ccrz__FilePath__c           = generateRandomString(10),
                            ccrz__ProductMediaSource__c = 'static',
                            ccrz__StaticResourceName__c = generateRandomString(10),
                            ccrz__MediaType__c='Product Image',
                            ccrz__URI__c=generateRandomString(10)
                    ),
                    new ccrz__E_ProductMedia__c(
                            ccrz__Product__c            = products[9].Id,
                            ccrz__FilePath__c           = generateRandomString(10),
                            ccrz__ProductMediaSource__c = 'static',
                            ccrz__StaticResourceName__c = generateRandomString(10),
                            ccrz__MediaType__c='Product Image',
                            ccrz__URI__c=generateRandomString(10)
                    )
                    };
         insert prodMedia;
		for (ccrz__E_Product__c product : products) {
            

            producti18ns.add(
                    new ccrz__E_ProductItemI18N__c(
                            Name             = product.Name + '-de',
                            ccrz__Locale__c  = 'de',
                            ccrz__Product__c = product.Id
                    ));

            priceListItems.add(
                    new ccrz__E_PriceListItem__c(
                            ccrz__Pricelist__c = priceLists.get(0).Id,
                            ccrz__Product__c   = product.Id,
                            ccrz__StartDate__c = Date.today().addDays(-7),
                            ccrz__EndDate__c   = Date.today().addDays(7),
                            ccrz__Price__c     = DEFAULT_PRICE,

                            cc_oo_IsPreBook__c       = false
                    ));
        }
        insert producti18ns;
        insert priceListItems;

        //******************************************************************************
        // INSERT CATEGORIES
        //******************************************************************************

        // all root
        ccrz__E_Category__c testAllRoot = new ccrz__E_Category__c(
                Name                = 'Products',
                ccrz__CategoryID__c = '0',
                ccrz__StartDate__c  = Date.today().addDays(-1),
                ccrz__EndDate__c    = Date.today().addDays(1)
        );
        insert testAllRoot;
        categoryMap.put('testAllRoot', testAllRoot);

        // storefront root for BP
        ccrz__E_Category__c storefrontRoot = new ccrz__E_Category__c(
                Name                    = STOREFRONT_CATEGORY_ROOT,
                ccrz__CategoryID__c     = STOREFRONT_CATEGORY_ROOT_EXT_ID,
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = testAllRoot.Id
        );
        insert storefrontRoot;

        categoryMap.put(STOREFRONT_CATEGORY_ROOT, storefrontRoot);

        // product types
        List<ccrz__E_Category__c> productTypes = new List<ccrz__E_Category__c>();

        ccrz__E_Category__c productType1 = new ccrz__E_Category__c(
                Name                    = PRODUCT_TYPE_CATEGORY_1,
                ccrz__CategoryID__c     = PRODUCT_TYPE_CATEGORY_1 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = storefrontRoot.Id
        );
        ccrz__E_Category__c productType2 = new ccrz__E_Category__c(
                Name                    = PRODUCT_TYPE_CATEGORY_2,
                ccrz__CategoryID__c     = PRODUCT_TYPE_CATEGORY_2 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = storefrontRoot.Id
        );
        productTypes.add(productType1);
        productTypes.add(productType2);
        insert productTypes;
        categoryMap.put(PRODUCT_TYPE_CATEGORY_1, productType1);
        categoryMap.put(PRODUCT_TYPE_CATEGORY_2, productType2);

        // brands
        List<ccrz__E_Category__c> brands = new List<ccrz__E_Category__c>();

        ccrz__E_Category__c brand1 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_1,
                ccrz__CategoryID__c     = BRAND_CATEGORY_1 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType1.Id,
                ccrz__Sequence__c       = 1
        );
        ccrz__E_Category__c brand2 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_2,
                ccrz__CategoryID__c     = BRAND_CATEGORY_2 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType1.Id,
                ccrz__Sequence__c       = 1
        );
        ccrz__E_Category__c brand3 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_3,
                ccrz__CategoryID__c     = BRAND_CATEGORY_3 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType2.Id,
                ccrz__Sequence__c       = 1
        );
        ccrz__E_Category__c brand4 = new ccrz__E_Category__c(
                Name                    = BRAND_CATEGORY_4,
                ccrz__CategoryID__c     = BRAND_CATEGORY_4 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = productType2.Id,
                ccrz__Sequence__c       = 1
        );
        brands.add(brand1);
        brands.add(brand2);
        brands.add(brand3);
        brands.add(brand4);
        insert brands;
        categoryMap.put(BRAND_CATEGORY_1, brand1);
        categoryMap.put(BRAND_CATEGORY_2, brand2);
        categoryMap.put(BRAND_CATEGORY_3, brand3);
        categoryMap.put(BRAND_CATEGORY_3, brand4);

        // sub-brands
        List<ccrz__E_Category__c> subBrands = new List<ccrz__E_Category__c>();

        ccrz__E_Category__c subbrand1 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_1,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_1 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand1.Id,
                ccrz__Sequence__c       = 2
        );
        ccrz__E_Category__c subbrand2 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_2,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_2 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand2.Id,
                ccrz__Sequence__c       = 2
        );
        ccrz__E_Category__c subbrand3 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_3,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_3 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand1.Id,
                ccrz__Sequence__c       = 2
        );
        ccrz__E_Category__c subbrand4 = new ccrz__E_Category__c(
                Name                    = SUB_BRAND_CATEGORY_4,
                ccrz__CategoryID__c     = SUB_BRAND_CATEGORY_4 + '_ID',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = brand2.Id,
                ccrz__Sequence__c       = 2
        );
        subBrands.add(subBrand1);
        subBrands.add(subBrand2);
        subBrands.add(subBrand3);
        subBrands.add(subBrand4);
        insert subBrands;
        categoryMap.put(SUB_BRAND_CATEGORY_1, subbrand1);
        categoryMap.put(SUB_BRAND_CATEGORY_2, subbrand2);
        categoryMap.put(SUB_BRAND_CATEGORY_3, subbrand3);
        categoryMap.put(SUB_BRAND_CATEGORY_4, subbrand4);

        //******************************************************************************
        // INSERT PRODUCT CATEGORIES
        // TODO: needs to be updated with category structure for all products
        //******************************************************************************
        productCategories = new List<ccrz__E_ProductCategory__c>();
        ccrz__E_ProductCategory__c product001subbrand1 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(0).Id,
                ccrz__Category__c = subbrand1.Id
        );
        ccrz__E_ProductCategory__c product002subbrand2 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(1).Id,
                ccrz__Category__c = subbrand2.Id
        );

        ccrz__E_ProductCategory__c product003subbrand3 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(2).Id,
                ccrz__Category__c = subbrand3.Id
        );
        ccrz__E_ProductCategory__c product004subbrand4 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(3).Id,
                ccrz__Category__c = subbrand4.Id
        );
        ccrz__E_ProductCategory__c product005subbrand4 = new ccrz__E_ProductCategory__c(
                ccrz__Product__c  = products.get(4).Id,
                ccrz__Category__c = subbrand4.Id
        );

        productCategories.add(product001subbrand1);
        productCategories.add(product002subbrand2);
        productCategories.add(product003subbrand3);
        productCategories.add(product004subbrand4);
        productCategories.add(product005subbrand4);
        insert productCategories;

        System.debug(Limits.getQueries() + ' of ' + Limits.getLimitQueries() + ' SOQL queries issued.');

    }


    /*------------------------------------------------------------
    Description:   Get test Contact Address
    ------------------------------------------------------------*/

    public static ccrz__E_ContactAddr__c getContactAddress() {
        return new ccrz__E_ContactAddr__c(
                ccrz__AddressFirstline__c = '100 Pine Street',
                ccrz__City__c             = 'SmallTown',
                ccrz__DaytimePhone__c     = '(847) 555-1212',
                ccrz__FirstName__c        = 'Test',
                ccrz__HomePhone__c        = '(847) 555-1212',
                ccrz__LastName__c         = 'User',
                ccrz__PostalCode__c       = '60601',
                ccrz__State__c            = 'Idaho',
                ccrz__StateISOCode__c     = 'ID',
                cc_oo_BillToShipToID__c   = '250287',
                ccrz__CountryISOCode__c   = 'USA'
        );
    }

    /*------------------------------------------------------------
    Description:   Generate random string
    ------------------------------------------------------------*/

    public static String generateRandomString(Integer len) {
        final String RANDOM_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String returnValue = '';
        Integer random;
        do {
            random = Math.mod(Math.abs(Crypto.getRandomInteger()),RANDOM_CHARS.length());
            returnValue += RANDOM_CHARS.substring(random,random + 1);
        } while (returnValue.length() < len);

        return returnValue;
    }

    /*------------------------------------------------------------
    Description:   Setup LOL Specific Settings
    ------------------------------------------------------------*/

    public static void setupOOSettings() {
        // setup LOL Integration Settings
        List<LOLSettings__c> ooIntegrationSettings = new List<LOLSettings__c> {
            new LOLSettings__c(
                Name     = 'CommunityUrlLink'
                , Value__c = 'http://www.lol.com'
            ),
             new LOLSettings__c(
                Name     = 'CSR_EmailAddress'
                , Value__c = 'abc@xyz.com'
            ), 
            new LOLSettings__c(
                Name     = 'cc_oo_TON_TO_LB'
                , Value__c = '2000'
            ), 
            new LOLSettings__c(
                Name     = 'CSR_PhoneNumber'
                , Value__c = '9363828686'
            ),
             new LOLSettings__c(
                Name     = 'JDEJobScheduler'
                , Value__c = '2'
            ),
            new LOLSettings__c(
                Name     = 'PendingOrderStatus'
                , Value__c = 'Pending'
            ) , 
            new LOLSettings__c(
                Name     = 'MaxCsvLines'
                , Value__c = '10'
            ),
                new LOLSettings__c(
                Name     = 'ParentCategory'
                , Value__c = 'Brand1'
            ),
                new LOLSettings__c(
                Name     = 'LastNMonths'
                , Value__c = '18'
            ),
                new LOLSettings__c(
                Name     = 'AmendedOrderStatus'
                , Value__c = 'Amended'
            ),
                new LOLSettings__c(
                Name     = 'LastNDays'
                , Value__c = '60'
            ),
                new LOLSettings__c(
                Name     = 'cartStatusArchive'
                , Value__c = 'Archive'
            ),
                 new LOLSettings__c(
                Name     = 'cartStatusOpen'
                , Value__c = 'Open'
            ),
            new LOLSettings__c(
                Name     = 'EmailFromAddress'
                , Value__c = 'abc@xyz.com'
            ),
            new LOLSettings__c(
                Name     = 'Pickup'
                , Value__c = 'Pickup'
            )
            ,
            new LOLSettings__c(
                Name     = 'DeliveryFreigtCode'
                , Value__c = 'F'
            )
            ,
            new LOLSettings__c(
                Name     = 'JDEShipFromPartyId'
                , Value__c = '0'
            )
            ,
            new LOLSettings__c(
                Name     = 'JDEShipToPartyId'
                , Value__c = '1'
            ),
            new LOLSettings__c(
                Name     = 'JDEAmendOdrerExpHeader'
                , Value__c = 'DataArea.PurchaseOrder.PurchaseOrderHeader'
            ),
                new LOLSettings__c(
                Name     = 'JDEAmendOdrerExpLine'
                , Value__c = 'DataArea.PurchaseOrder.PurchaseOrderLine'
            ),
            new LOLSettings__c(
                Name     = 'JDEAmendOrderDelete'
                , Value__c = 'Delete'
            ),
                 new LOLSettings__c(
                Name     = 'JDEAmendOrderChange'
                , Value__c = 'Change'
            ),
             new LOLSettings__c(
                Name     = 'ReasonCode'
                , Value__c = 'S13'
            ),
              new LOLSettings__c(
                Name     = 'JDEAmendOrderAdd'
                , Value__c = 'Add'
            ), 
                 new LOLSettings__c(
                Name     = 'JDEAmendOrderCancel'
                , Value__c = 'Cancel'
            ),   
                
            new LOLSettings__c(
                Name     = 'CancelOrderDocNumber'
                , Value__c = '99999999'
            ),
            new LOLSettings__c(
                Name     = 'AmendJDeBatchRecordSize'
                , Value__c = '50'
            ),
            new LOLSettings__c(
                Name     = 'SyncJDeBatchRecordSize'
                , Value__c = '50'
            )
           
        };
       insert ooIntegrationSettings;
       List<cc_oo_pluralUOM__c> ooIntegrationSetting = new List<cc_oo_pluralUOM__c> {
           new cc_oo_pluralUOM__c(
               Name='BG'
               ,plural__c='Bags'
           )
       };
       insert ooIntegrationSetting; 
    } 
    
     /*------------------------------------------------------------
    Description:   Setup LOL Specific Settings
    ------------------------------------------------------------*/

    public static void setupOOServiceDataSettings() {
        // setup LOL Integration Settings
        List<cc_oo_ServiceData__c> ooIntegrationSettings = new List<cc_oo_ServiceData__c> {
            new cc_oo_ServiceData__c(
                Name     = 'RetrieveOrder'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = '443'
                , cc_oo_RequestMethod__c = 'POST'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = '/api/purina/retrievenextorderno'
                , cc_oo_UserName__c = '515181E'
            ),
             new cc_oo_ServiceData__c(
                Name     = 'RetrievePrice'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = 'app5'
                , cc_oo_MethodName__c = 'PriceRetreivalForCustomer'
                , cc_oo_OrderType__c = 'SO'
                , cc_oo_P4210Version__c = 'FDOB5701'
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = '443'
                , cc_oo_RequestMethod__c = 'GET'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = 'F'
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = 'callmethod'
                , cc_oo_URI__c = '/api/purina/retrieveprice'
                , cc_oo_UserName__c = '515181E'
            ), 
            new cc_oo_ServiceData__c(
                Name     = 'SyncOrder'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = '443'
                , cc_oo_RequestMethod__c = 'POST'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = '/api/purina/syncorder'
                , cc_oo_UserName__c = '515181E'
            ),
            new cc_oo_ServiceData__c(
                Name     = 'orderCancel'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = ''
                , cc_oo_RequestMethod__c = 'PUT'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = '/purina/orders'
                , cc_oo_UserName__c = '515181E'
            ),
                new cc_oo_ServiceData__c(
                Name     = 'dockDoor'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = ''
                , cc_oo_RequestMethod__c = 'GET'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = 'http:///purina/branchPlants'
                , cc_oo_UserName__c = '515181E'
            ),
            new cc_oo_ServiceData__c(
                Name     = 'ModifyOrder'
                , cc_oo_AuthMechanism__c = 'Basic'
                , cc_oo_ContentType__c = 'application/json'
                , cc_oo_Host__c = 'https://wsqa.landolakesinc.com'
                , cc_oo_MethodApp__c = ''
                , cc_oo_MethodName__c = ''
                , cc_oo_OrderType__c = ''
                , cc_oo_P4210Version__c = ''
                , cc_oo_Password__c = 'EightyOne_81$1'
                , cc_oo_Port__c = ''
                , cc_oo_RequestMethod__c = 'POST'
                , cc_oo_Session__c = ''
                , cc_oo_SessionIdle__c = ''
                , cc_oo_szFreightHandlingCode__c = ''
                , cc_oo_Timeout__c = '20000'
                , cc_oo_Type__c = ''
                , cc_oo_URI__c = '/purina/orders'
                , cc_oo_UserName__c = '515181E'
            )                                        
        };
       insert ooIntegrationSettings;
    } 
     
    /*------------------------------------------------------------
    Description:   Create CC Orders
    ------------------------------------------------------------*/

    public static List<ccrz__E_Order__c> createExternalOrders(Integer numberOfOrders) {

        final List<ccrz__E_Order__c> testOrders = new List<ccrz__E_Order__c>();
        System.assert(testUser != null);
        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrders.add(
                    new ccrz__E_Order__c(
                            ccrz__Account__c         = testAccount.Id,
                            ccrz__Contact__c         = testUser.ContactId,
                            ccrz__OrderNumber__c     = i,
                            ccrz__Storefront__c      = STOREFRONT_NAME,
                            ccrz__ShipTo__c          = shipToAddress.Id,
                            ccrz__OrderDate__c       = Date.Today(),
                            ccrz__BillTo__c          = billToAddress.Id,
                            cc_oo_ShipToAccount__c  = testAccount.Id,
                        	ccrz__Note__c            = 'This is a note',
                        	ccrz__RequestDate__c = Date.today()
		    ));
        }
        System.assertEquals(testOrders.size(), numberOfOrders);
        upsert testOrders;

        final List<ccrz__E_OrderItem__c> testOrderItems = new List<ccrz__E_OrderItem__c>();
        final List<String> orderIds                              = new List<String>();

        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrderItems.add(
                    new ccrz__E_OrderItem__c(
                            ccrz__Order__c           = testOrders.get(i).Id,
                            ccrz__Price__c           = 50,
                            ccrz__Quantity__c        = 2,
                            ccrz__SubAmount__c       = 20
                    ));
            orderIds.add(testOrders.get(i).Id);
        }
        insert testOrderItems;

        return [SELECT Id from ccrz__E_Order__c WHERE Id IN :orderIds];


    }
    public static List<ccrz__E_Order__c> createOrders(Integer numberOfOrders) {

        final List<ccrz__E_Order__c> testOrders = new List<ccrz__E_Order__c>();
        final List<ccrz__E_Seller__c> sellers = new List<ccrz__E_Seller__c>{
                new ccrz__E_Seller__c(
                        
                        ccrz__SellerId__c            = 'ABDN',                        
                        ccrz__Storefront__c          = STOREFRONT_NAME,
                        ccrz__Enabled__c             = true,
                        cc_oo_Zip__c                 = '567676',
                        cc_oo_State__c               = 'CA',
                        ccrz__EffectiveStart__c      = Date.Today()-10,
                        ccrz__EffectiveEnd__c        = Date.Today()+10
                )
        };
        insert sellers;
        System.assert(testUser != null);
        ccrz__E_Cart__c cart = createCart();
        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrders.add(
                    new ccrz__E_Order__c(
                            ccrz__Account__c         = testAccount.Id,
                            ccrz__Contact__c         = testUser.ContactId,
                            OwnerId                  = testUser.Id,
                            ccrz__OrderNumber__c     = i,
                            cc_oo_JDEOrderNumber__c='983838',
                            cc_oo_JDEFlag__c='0',
                            cc_oo_JDENumericStatus__c='123',
                            ccrz__OrderStatus__c ='Pending',
                            ccrz__Storefront__c      = STOREFRONT_NAME,
                            ccrz__ShipTo__c          = shipToAddress.Id,
                            ccrz__OrderDate__c       = Date.Today(),
                            ccrz__User__c           = testUser.Id,
                            ccrz__BillTo__c          = billToAddress.Id,
                            ccrz__OriginatedCart__c  = cart.Id,
                            cc_oo_Seller__c = sellers[0].id,
                            cc_oo_ShipToAccount__c = testAccount.Id,
                            ccrz__EncryptedId__c    = 'testEncryptedId'+ i.format(),
                            cc_oo_IsSyncOrder__c = false
                            
                    ));
        }
        System.assertEquals(testOrders.size(), numberOfOrders);
        upsert testOrders;
		setupCatalog();
		List<ccrz__E_Product__c> productsCart1=[select id from ccrz__E_Product__c LIMIT 1];
		ccrz__E_CartItem__c cartItem1;
		cartItem1 = addCartItem(cart, productsCart1[0].id, 10.00, 1000.00);
		upsert cartItem1;
        final List<ccrz__E_OrderItem__c> testOrderItems = new List<ccrz__E_OrderItem__c>();
        final List<String> orderIds                              = new List<String>();

        for (Integer i = 0; i < numberOfOrders; i++) {
            testOrderItems.add(
                    new ccrz__E_OrderItem__c(
                            ccrz__Order__c           = testOrders.get(i).Id,
                            ccrz__Product__c         =productsCart1[0].id,
                            ccrz__Price__c           = 50,
                            ccrz__Quantity__c        = 2,
                            ccrz__SubAmount__c       = 20
                    ));
            orderIds.add(testOrders.get(i).Id);
        }
        insert testOrderItems;

        return[SELECT Id,OwnerId,ccrz__OriginatedCart__c,cc_oo_ShipToAccount__c,cc_oo_Seller__c,ccrz__User__c,ccrz__Account__r.Id,ccrz__Contact__r.Id,ccrz__Contact__c,ccrz__Account__c, ccrz__EncryptedId__c,cc_oo_JDEOrderNumber__c,cc_oo_IsSyncOrder__c from ccrz__E_Order__c WHERE Id IN :orderIds];
    }
    
     public static List<ccrz__E_Order__c> createOrders(Integer numberOfOrders,Boolean IsfailedOrders) {
     	//what are the data need for testing FailedOrders/Orders
     	//1. Create Cart
     	//2. Create all other dependencies for creating cart 
     	//3. create Orders
     	//4. Create all dependencies for Order and OrderItems. 
     	//5. Flag Order as failed
     	//6. Validate data 
		List<ccrz__E_Cart__c> carts = createCarts(numberOfOrders);// Each Cart should hold diiferent types of order Status, 'Pending, Cancelled, etc. '		
		//ccrz__E_Cart__c testCart = carts[0];		
        List<ccrz__E_Order__c> testOrders 			= new List<ccrz__E_Order__c>();
        List<ccrz__E_OrderItem__c> testOrderItems 	= new List<ccrz__E_OrderItem__c>();
        List<String> orderIds                       = new List<String>();
        
        //Depency for Order and cart
       ccrz__E_Seller__c sellers =   new ccrz__E_Seller__c(                        
                        ccrz__SellerId__c            = 'ABDN',                        
                        ccrz__Storefront__c          = STOREFRONT_NAME,
                        ccrz__Enabled__c             = true,
                        cc_oo_Zip__c                 = '567676',
                        cc_oo_State__c               = 'CA',
                        ccrz__EffectiveStart__c      = Date.Today()-10,
                        ccrz__EffectiveEnd__c        = Date.Today()+10
                );
       
        upsert sellers; 
        
        setupCatalog();
        List<ccrz__E_Product__c> productsCart=[select id from ccrz__E_Product__c LIMIT 1];
        ccrz__E_CartItem__c cartItem;
        for(ccrz__E_Cart__c cart:carts){
        	cartItem = addCartItem(cart, productsCart[0].id, 10.00, 100.00);  
        }        
       	   
        upsert cartItem;
        
        //ccrz__E_Cart__c testCart = [select ccrz__EncryptedId__c from ccrz__E_Cart__c where id = :cart.id];
       // system.debug('Encrypted Cart Id -------------------->' + testCart.ccrz__EncryptedId__c);
        if(IsfailedOrders){
        	for (Integer i = 0; i < numberOfOrders; i++) {
	            testOrders.add(
	                    new ccrz__E_Order__c(
	                            ccrz__Account__c         = testAccount.Id,
	                            ccrz__Contact__c         = testUser.ContactId,
	                            OwnerId                  = testUser.Id,
	                            ccrz__OrderNumber__c     = i,
	                            cc_oo_JDEOrderNumber__c	 = math.mod(i,2)==0?'':'983838',
	                            cc_oo_IsJDENumberUpdate__c = false,
	                            cc_oo_JDEFlag__c		 ='0',
	                            cc_oo_JDENumericStatus__c='123',
	                            ccrz__OrderStatus__c     = math.mod(i,2)==0?'Order Submitted':'Cancelled',
	                            ccrz__Storefront__c      = STOREFRONT_NAME,
	                            ccrz__ShipTo__c          = shipToAddress.Id,
	                            ccrz__OrderDate__c       = Date.Today(),
	                            ccrz__User__c            = testUser.Id,
	                            ccrz__BillTo__c          = billToAddress.Id,
	                            ccrz__OriginatedCart__c  = carts[i].Id,//math.mod(i,2)==0?carts[0].Id:carts[1].Id,
	                            cc_oo_Seller__c 		 = sellers.id,//sellers[0].id,
	                            cc_oo_ShipToAccount__c 	 = testAccount.Id,
	                            ccrz__EncryptedId__c     = carts[i].ccrz__EncryptedId__c,//math.mod(i,2)==0?carts[0].ccrz__EncryptedId__c:carts[1].ccrz__EncryptedId__c,//'testEncryptedId'+ i.format(),
	                            cc_oo_IsSyncOrder__c     = false,
                            	ccrz__Note__c = 'Test Notes',
                            	ccrz__PONumber__c = 'Testing from test class',
                            	ccrz__BuyerFirstName__c=null,
                            	ccrz__BuyerPhone__c=null,
                            	ccrz__BuyerLastName__c=null,
                            	ccrz__BuyerEmail__c=null   
	                    ));
                system.debug('=====> Order ' + i + ' with id ' + testOrders[i].id );
                system.debug('=====> Order Number '  + testOrders[i].ccrz__OrderNumber__c + ' and Status --' + testOrders[i].ccrz__OrderStatus__c);
                system.debug('=====> JDE Order ' + i + ' with id ' + testOrders[i].cc_oo_JDEOrderNumber__c );
	        }
	        System.assertEquals(testOrders.size(), numberOfOrders);
	        upsert testOrders;
	
	        
	
	        for (Integer i = 0; i < numberOfOrders; i++) {
	            testOrderItems.add(
	                    new ccrz__E_OrderItem__c(
	                            ccrz__Order__c           = testOrders.get(i).Id,
	                            ccrz__Product__c         =productsCart[0].id,
	                            ccrz__Price__c           = 50,
	                            ccrz__Quantity__c        = 2,
	                            ccrz__SubAmount__c       = 20
	                    ));
	            orderIds.add(testOrders.get(i).Id);
	        }
	        
	        insert testOrderItems;
        
        }
        //TODO: Remove this later
        ccrz__E_Cart__c myCart = [SELECT ccrz__EncryptedId__c,ccrz__CartStatus__c,
		                									(SELECT Id, ccrz__SubAmount__c, ccrz__Price__c, ccrz__Quantity__c
		                									, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c
		                									,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,ccrz__Comments__c,ccrz__UnitOfMeasure__c
		                									, cc_oo_UnitPrice__c, cc_oo_ContractPrice__r.cc_oo_ContractNumber__c FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c 
		                									WHERE Id =:testOrders[0].ccrz__OriginatedCart__c LIMIT 1];		
		system.debug('This Cart Id must be Equal to  ------->' + myCart.id);
		system.debug('This cart id from Orders ------------->' + testOrders[0].ccrz__OriginatedCart__c);
		system.assertEquals(myCart.id,testOrders[0].ccrz__OriginatedCart__c);
		
		system.debug('Cart Item stuff - ' + myCart.ccrz__E_CartItems__r);

        return[SELECT Id,
					  Name,
					  LastModifiedDate,
					  ccrz__OrderStatus__c,
					  ccrz__RequestDate__c,
					  CreatedDate,
					  ccrz__ShipTo__r.Name,
					  ccrz__BillTo__r.Name,
					  cc_oo_IsJDENumberUpdate__c,
					  ccrz__ShipMethod__c,
					  cc_oo_TimeZone__c,
					  cc_oo_OrderType__c,
					  cc_oo_PickUpTime__c,
					  cc_oo_JDEDocumentID__c,
					  cc_oo_IsSyncOrder__c,
					  cc_oo_JDEOrderNumber__c,
					  ccrz__Note__c,
					  ccrz__PONumber__c ,
					  cc_oo_ShipToAccount__r.AccountNumber,
					  cc_oo_ShipToAccount__r.BillTo_Account__c,
					  cc_oo_ShipToAccount__r.BillTo_Flag__c,
					  cc_oo_ShipToAccount__r.Delivery_Instruction_1__c,
					  cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber,
					  ccrz__OriginatedCart__r.ccrz__EncryptedId__c,
					  ccrz__OriginatedCart__r.Id,
					  ccrz__OriginatedCart__r.cc_oo_AmendedCart__c,
					  ccrz__OriginatedCart__r.cc_oo_OriginalCart__c,
					  cc_oo_seller__r.ccrz__sellerId__c,
					  (SELECT Id,
					    Name,
					    ccrz__Product__c,
					    ccrz__Product__r.ccrz__SKU__c,
					    ccrz__Quantity__c,
					    ccrz__Comments__c,
					    ccrz__Price__c,
					    ccrz__UnitOfMeasure__c,
					    cc_oo_OriginalOrderItem__c,
					    ccrz__Product__r.cc_oo_TypeOfProduct__c,
					    ccrz__Product__r.ccrz__LongDesc__c,
					    ccrz__Product__r.cc_oo_Second_Description__c,
					    cc_oo_OriginalOrderItem__r.ccrz__Comments__c
					  FROM ccrz__E_OrderItems__r
					  )
					  
        from ccrz__E_Order__c WHERE Id IN :orderIds];
    }
    

    /*------------------------------------------------------------
    Description:   Create CC Root Categories
    ------------------------------------------------------------*/

    public static void createRootCategories() {
        // all root
        ccrz__E_Category__c testAllRoot = new ccrz__E_Category__c(
                Name                = 'Productsadfsafds',
                ccrz__CategoryID__c = 'askflkldsakjlfdskjl',
                ccrz__StartDate__c  = Date.today().addDays(-1),
                ccrz__EndDate__c    = Date.today().addDays(1)
        );
        insert testAllRoot;

        // storefront root for BP
        ccrz__E_Category__c storefrontRoot = new ccrz__E_Category__c(
                Name                    = STOREFRONT_CATEGORY_ROOT,
                ccrz__CategoryID__c     = STOREFRONT_CATEGORY_ROOT_EXT_ID,
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = testAllRoot.Id
        );
        insert storefrontRoot;
        // storefront root for IR
        ccrz__E_Category__c storefrontRootIR = new ccrz__E_Category__c(
                Name                    = STOREFRONT_CATEGORY_ROOT_IR,
                ccrz__CategoryID__c     = STOREFRONT_CATEGORY_ROOT_EXT_ID + 'IR',
                ccrz__StartDate__c      = Date.today().addDays(-1),
                ccrz__EndDate__c        = Date.today().addDays(1),
                ccrz__ParentCategory__c = testAllRoot.Id
        );
        insert storefrontRootIR;

    }
    
    public class cc_oo_Product{
        public string productId{get; set;}
        public string index{get; set;}
        public string sku{get; set;}
        public string quantity{get; set;}
        public string typeOfProduct{get; set;}
        public string UOM{get; set;}
        public string minQuantity{get; set;}
        public string palletSize{get; set;}
        public string status{get; set;}
        public string availabilityMessage{get; set;}
        public string fullPalletReq{get; set;}
        public string isToteProduct{get; set;}
        public string leadTime{get; set;}
        public string shortDescription{get; set;}
        public string priceOption{get; set;}
        public string listPrice{get; set;}
        public string errorMessage{get; set;}
        public string quantityErrorMessage{get;set;}
        public string UOMD{get;set;}

        public cc_oo_ProductPrice price{get; set;}
        public List<cc_oo_ContractPrice> contracts{get; set;}
    }

    /*
        Bean - cc_oo_ProductPrice
        To hold the product price details data
    **/
    public class cc_oo_ProductPrice{
        public string netListPrice{get; set;}
        public string palletPrice{get; set;}
        public string quantityPerUnit{get; set;}
        public string unitOfMeasure{get; set;}
        //public string palletSize{get; set;}
    }

    /*
        Bean - cc_oo_ContractPrice
        To hold the cotract price details
    **/
    public class cc_oo_ContractPrice {
        public String contractSFId{get; set;}
        public String contractId{get; set;}
        public String contractPrices{get; set;}
        public string expiryDate{get; set;}
        public String jdeEndUser{get; set;}
        public Integer contractQty{get; set;}
        public Boolean disableContract{get; set;}
        public cc_oo_ContractDetail contractDetails{get; set;}
    }
    
    /*
        Bean - cc_oo_ContractPrice
        To hold the cotract price details
    **/
    public class cc_oo_ContractDetail {
        public string effectiveDate{get; set;}
        public String contractUom{get; set;}
        public Integer availableBalance{get; set;}
        public string lastModifiedDate{get; set;}     
    }

    /*
        Bean - cc_oo_cart
        To hold the cart details
    **/
    public class cc_oo_cart{
        public string Id {get;set;}//OO-2244
        public string sku {get; set;}
        public string cartId {get; set;}
        public string category {get; set;}
        public string storeID {get; set;} 
        public string product {get; set;}
        public string seller {get; set;}
        public string quantity {get; set;}
        public string price {get; set;}
        public string unitPrice {get; set;}
        public string isListPrice {get; set;}
        //public string ccrz__SubAmount__c {get; set;}
        public string unitOfMeasure {get; set;}
        public string productType {get; set;}
        public string requestDate {get; set;}
        public string contractId {get; set;}
        public string leadTime {get; set;}
    }
    

}