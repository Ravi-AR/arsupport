/**
*   @Author:    Shruti Mishra
*   @Date:      28.09.2016
*   @Purpose:   Test Utility Class for Test Data
*
*/

@isTest
public with sharing class LPDCR_TestUtil {
    enum PortalType { CSPLiteUser, CspLitePortal,PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
        if(userWithRole == null) {
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'DealerCoOpDevPartnerUser');
                Database.insert(r);
                userWithRole = new User(alias = 'jdeal', email='james.dealer@mail.com.dev12', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Dealer', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                    timezonesidkey='America/Los_Angeles', username='james.dealer@mail.com.dev111', Customer_Ops_Region__c='Great East');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
        }
        Account a;
        Contact c;
        System.runAs(userWithRole) {
            
            Account up = LPDCR_TestUtil.getultimateParentAccRecord();
            a = new Account( Name = 'Dealer Co-Op Dev', Ultimate_Parent__c=up.Id, 
             ParentId = up.Id, BusinessBuilderProgramStatus__c ='Registration Approved',Business_Builder_Program_Tier__c='Certified Expert Dealer',ASM_BB_Approver__c = Userinfo.getUserId(), Business_Builder_Reimbursement_Approver__c = Userinfo.getUserId());
            Database.insert(a);
            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name = String.valueOf(getRandomNumber(9999)),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(getRandomNumber(9999)));
            insert businessyear;
            SellingSupportProgramYear__c expenseyear = new SellingSupportProgramYear__c(Account__c= a.Id,Name = String.valueOf(Date.Today().Year()),BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 1000000,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseyear;
            //Account acc = [Select Id, (Select Id, Name, Account__c, Available_Balance__c from Selling_Support_Program_Years__r) from Account where Id=: a.Id];
            //acc.Selling_Support_Program_Years__r[0]= expenseyear.Id;
            //acc.;
            //upsert acc;
            c = new Contact(AccountId = a.id, lastname = 'Dealer');
            Database.insert(c);
        }
        /* Get any profile for the given type.*/
        Profile p = [select id from profile where usertype = :portalType.name() limit 1]; 
        String testemail = 'james.dealer@mail.com.dev222';
        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='Dealer', contactId = c.id);
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
    
    //Returns community User record
    public static User getCommunityUser(){
        return getPortalUser(PortalType.PowerPartner, null, true);
    }

    //Returns UltimateParent Account records
    public static Account getultimateParentAccRecord() {
        Account up = new Account( Name = 'Ultimate Parent ');
        insert up;
        return up;
    }
    
    //Returns Account records
    public static Account getAccountRecord() {
        Account up = LPDCR_TestUtil.getultimateParentAccRecord();
        Account ac = new Account(Name = 'TestAccount', AccountNumber = '12345', ParentId = up.Id, Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345', BusinessBuilderProgramStatus__c ='Registration Approved', Business_Builder_Program_Tier__c='Certified Expert Dealer');
        insert ac;
        return ac;
    }
        //Return Business Builder Program Year record
     public static BusinessBuilderProgramYear__c getBBProgramYear()
     {
      BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name = String.valueOf(getRandomNumber(9999)),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(getRandomNumber(9999)));
      system.debug('year-> '+businessyear);
      insert businessyear;
      return businessyear;
     }
     
    //Return SS Program Year record
    public static SellingSupportProgramYear__c getSSProgramYear() {
        Account acc = LPDCR_TestUtil.getAccountRecord();
        BusinessBuilderProgramYear__c businessyear = LPDCR_TestUtil.getBBProgramYear();
        RecordType rt = [SELECT Id FROM RecordType WHERE Name='Standard' AND SobjectType='SellingSupportProgramYear__c'];
        SellingSupportProgramYear__c expenseyear = new SellingSupportProgramYear__c(recordTypeId=rt.id,Account__c= acc.Id,Name =String.valueOf(getRandomNumber(9999)),BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 100000,BusinessBuilderProgramStatus__c ='Enrolled');
        insert expenseyear; 
        return expenseyear;
    }    
    //Returns BusinessBuilderRules records
    public static BusinessBuilderRules__c getBBRuleRecord(){
        BusinessBuilderRules__c businessRules= new BusinessBuilderRules__c(Name = 'Education and Training', Reimbursement_Percentage__c = 100.00,
                                                    Active__c = true, Description__c = 'Business rule', Category__c = 'Education and Training', 
                                                    Checkpoint_Multiplier__c= 2, Max_Reimbursement__c= 500000 ,Reimbursement_Subcategory__c = 'Show VIP',ApplicableYears__c =String.valueOf(getRandomNumber(9999)));
        insert businessRules;
        return businessRules;
    }
    
    //Returns AMASellingSupportExpense Record
    public static AMASellingSupportExpense__c getSSExpenseRecord(){
        Account ac = LPDCR_TestUtil.getAccountRecord();
        SellingSupportProgramYear__c expenseyear =LPDCR_TestUtil.getSSProgramYear();
        AMASellingSupportExpense__c expenserecord = new AMASellingSupportExpense__c(UltimateParentAR__c = ac.id,DealerAccount__c= expenseyear.Account__c, Type__c = 'Expense', 
                                                                                    Selling_Support_Program_Year__c = expenseyear.Id, SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Submitted for Approval',
                                                                                    Internal_Status__c ='Submitted for Approval', Area_Sales_Manager__c = ac.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =ac.Business_Builder_Reimbursement_Approver__c );
        insert expenserecord;
        return expenserecord;
    }
    
    //Returns AMASSItem Record
    public static AMASellingSupportExpenseLineItem__c getSSExpenseLineItemRecord(){
        AMASellingSupportExpense__c expenserecord = LPDCR_TestUtil.getSSExpenseRecord();
        AMASellingSupportExpenseLineItem__c lineItemObjLst = new AMASellingSupportExpenseLineItem__c(Expense__c = expenserecord.id,
        Approval_Status__c='Submitted',Reimbursement_Category__c ='Education and Training',
        Reimbursement_Sub_category__c='Show VIP',Total_Spend__c =200);
        insert lineItemObjLst;
        return lineItemObjLst;
    }
    
    //Returns AMASSExpenseLineItem Record
    public static AMASellingSupportExpenseLineItem__c getSSExpenseLineItemRecord(String expenseId){
        AMASellingSupportExpenseLineItem__c lineItemObjLst = new AMASellingSupportExpenseLineItem__c(Expense__c = expenseId,
        Approval_Status__c='Submitted',Reimbursement_Category__c ='Education and Training',
        Reimbursement_Sub_category__c='Show VIP',Total_Spend__c =200);
        insert lineItemObjLst;
        return lineItemObjLst;
    }
    
        public static AMASellingSupportExpenseLineItem__c getSSExpenseLineItemRecordMaxAmount(){
        AMASellingSupportExpense__c expenserecord = LPDCR_TestUtil.getSSExpenseRecord();
        AMASellingSupportExpenseLineItem__c lineItemObjLst = new AMASellingSupportExpenseLineItem__c(Expense__c = expenserecord.id,
        Approval_Status__c='Submitted',Reimbursement_Category__c ='Education and Training',Reimbursement_Percentage__c =100,
        Reimbursement_Sub_category__c='Show VIP',Total_Spend__c =600000);
        insert lineItemObjLst;
        return lineItemObjLst;
    }
    
    //Get Random Numbers
    public static Integer getRandomNumber(Integer size){
          Double d = math.random() * size;
          return d.intValue();
    }
    
    //Returns LPDCR_Expense Sort custom setting records
    public static List<LPDCR_ExpenseSort__c> getSortParamList(){
        List<LPDCR_ExpenseSort__c> expenseSortCS = new List<LPDCR_ExpenseSort__c>();
        LPDCR_ExpenseSort__c expense1 = new LPDCR_ExpenseSort__c(Name='1',Sort_By_Field__c='Submit Date',SortByField_API__c='CreatedDate',Sort_By_SubField__c='Most Recent First',SortBySubField_API__c='DESC',Active__c=True);
        LPDCR_ExpenseSort__c expense2 = new LPDCR_ExpenseSort__c(Name='2',Sort_By_Field__c='Status',SortByField_API__c='ApprovalStatus__c',Sort_By_SubField__c='Saved',SortBySubField_API__c='Saved',Active__c=True);
        LPDCR_ExpenseSort__c expense3 = new LPDCR_ExpenseSort__c(Name='3',Sort_By_Field__c='Program Year',SortByField_API__c='Selling_Support_Program_Year__r.Name',Sort_By_SubField__c='2016',SortBySubField_API__c='2016',Active__c=True);
        LPDCR_ExpenseSort__c expense4 = new LPDCR_ExpenseSort__c(Name='4',Sort_By_Field__c='Amount',SortByField_API__c='Total__c',Sort_By_SubField__c='Largest First',SortBySubField_API__c='DESC',Active__c=True);
        expenseSortCS.add(expense1);
        expenseSortCS.add(expense2);
        expenseSortCS.add(expense3);
        expenseSortCS.add(expense4);
        insert expenseSortCS;
        return expenseSortCS;
    }

/******************************************************************************
 * Set any custom setting values needed by the test classes/methods
 */
    public static
    void
    setCustomSettings()
    {
        LPDCR_Org_Settings__c l_org_settings = new LPDCR_Org_Settings__c();
        l_org_settings.CC_Portal_Sign_Up_URL_Non_SSO_User__c = 'https://ccrz.cs2.visual.force.com/apex/homepage?isCSRFlow=true&orderType=preBook&portalUser=[CONTACT_ID]&store=PurinaMills&promoCode=[PROMO_CODE]';
        l_org_settings.CC_Portal_Sign_Up_URL_SSO__c = 'https://ccrz.cs2.visual.force.com/apex/homepage?orderType=preBook&store=PurinaMills&promoCode=[PROMO_CODE]';
        l_org_settings.DealerCommunity_BaseURL__c = 'https://dlrcommdev-landolakespartners.cs2.force.com/mypurinamills/';
        l_org_settings.Dealer_Community_Logout_URL__c = 'secur/logout.jsp';
        l_org_settings.Kentico_Resource_URL_Prefix__c = 'https://purinamills.lolportals.com';
        upsert l_org_settings;
        
                                                 // Create the LPDCR_Species_Translation__c records
        List<LPDCR_Species_Translation__c> l_translations = new List<LPDCR_Species_Translation__c>();
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Backyard Poultry', Product_Specie_Terms__c = 'Backyard, Poultry' ) );
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Dairy - Transition & Lactating Cow', Product_Specie_Terms__c = 'Dairy, Cattle, Transition, Lactating, Cow' ) );
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Dairy - Young Animal', Product_Specie_Terms__c = 'Dairy, Young Animal' ) );
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Fish & Aqua', Product_Specie_Terms__c = 'Fish, Aqua' ) );
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Other', Product_Specie_Terms__c = 'Other' ) );
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Swine - Commercial', Product_Specie_Terms__c = 'Swine, Commercial' ) );
        l_translations.add( new LPDCR_Species_Translation__c( Name = 'Swine - Retail', Product_Specie_Terms__c = 'Swine, Retail' ) );
        
        upsert l_translations;
    } 


/******************************************************************************
 * Sample JSON string responses to test the web service callouts, and used to 
 * create the Mock Responses for the test classes
 */
    public static String 
        LPDCR_BLSpeciesTest_JSON = '{'+
        '    \"PurinaBusinessLink_Species\": ['+
        '        {'+
        '            \"PurinaBusinessLink_Species\": ['+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina Premium Poultry feed provides optimum nutrition for healthy birds and nutritious eggs.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Backyard Poultry\",'+
        '                    \"SpeciesID\": 1,'+
        '                    \"Headline\": \"Backyard Poultry\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"As a proud partner, we are committed to providing you the best-in-class cattle products and services, and help you to be the number one cattle dealer in your territory.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Cattle\",'+
        '                    \"SpeciesID\": 2,'+
        '                    \"Headline\": \"Cattle\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina Animal Nutrition offers a portfolio of research-tested and field-proven nutrition solutions for your dairy herd, from pre-fresh to transition and lactating cows.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Dairy - Transition & Lactating Cow\",'+
        '                    \"SpeciesID\": 12,'+
        '                    \"Headline\": \"Transition & Lactating Cow\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina Animal Nutrition offers the only research-tested and market-proven program to get dairy calves off to the right start and ensure their lifetime productivity.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Dairy - Young Animal\",'+
        '                    \"SpeciesID\": 3,'+
        '                    \"Headline\": \"Calf & Heifer\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"AntlerMax&reg; and Antler Advantage&trade; deer feeds are formulated with cutting-edge nutrition technology to help to unleash the genetic potential of deer to grow large, strong antlers.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/Purina-News_Events_Hands_10_22_2013.jpg?ext=.jpg\",'+
        '                    \"Name\": \"Deer & Elk\",'+
        '                    \"SpeciesID\": 7,'+
        '                    \"Headline\": \"Deer & Elk\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina&reg; AquaMax&reg; fish foods are 100% nutritionally complete diets developed by professional nutritionists and fish experts to achieve excellent conversion rates and grow big fish.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/Purina-News_Events_Hands_10_22_2013.jpg?ext=.jpg\",'+
        '                    \"Name\": \"Fish & Aqua\",'+
        '                    \"SpeciesID\": 9,'+
        '                    \"Headline\": \"Fish & Aquatics\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina Goat Chow&reg; and Noble Goat&reg; products are highly palatable feeds designed specifically for goats that deliver superior nutrition and improve skin and hair quality.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/no-image-available.jpg?ext=.jpg\",'+
        '                    \"Name\": \"Goat\",'+
        '                    \"SpeciesID\": 8,'+
        '                    \"Headline\": \"Goat & Sheep\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina provides nutrition solutions for every phase of your horses life and health needs, from foal to senior horse.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Horse\",'+
        '                    \"SpeciesID\": 4,'+
        '                    \"Headline\": \"Horse\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/no-image-available.jpg?ext=.jpg\",'+
        '                    \"Name\": \"Mazuri\",'+
        '                    \"SpeciesID\": 14,'+
        '                    \"Headline\": \"Mazuri\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"With quality ingredients and an affordable price, PMI Nutrition pet foods have been developed and proven through extensive research to exceed the recommended nutritional levels established for your pet.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/no-image-available.jpg?ext=.jpg\",'+
        '                    \"Name\": \"PMI Pet\",'+
        '                    \"SpeciesID\": 6,'+
        '                    \"Headline\": \"PMI Pet\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina Rabbit Chow Wholesome AdvantEdge&trade; rabbit feeds are made with high quality ingredients free from fillers, preservatives or artificial flavors and deliver premium nutrition for raising healthy, vibrant rabbits.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/no-image-available.jpg?ext=.jpg\",'+
        '                    \"Name\": \"Rabbit\",'+
        '                    \"SpeciesID\": 10,'+
        '                    \"Headline\": \"Rabbit\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Designed to maximize your show animal&rsquo;s genetic potential, Honor&reg; Show Chow&reg; show feeds and High Octane&reg; supplements help give you The Power To Perform&reg;.\",'+
        '                    \"Image\": \"~/BusinessLink/media/Business-Link/Images/News/no-image-available.jpg?ext=.jpg\",'+
        '                    \"Name\": \"Show\",'+
        '                    \"SpeciesID\": 11,'+
        '                    \"Headline\": \"Show\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"As an industry innovator and leader, Purina is constantly learning, testing and perfecting our swine feed products to help your producer maximize their nutritional investments.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Swine - Commercial\",'+
        '                    \"SpeciesID\": 5,'+
        '                    \"Headline\": \"Commercial Swine\"'+
        '                },'+
        '                {'+
        '                    \"Description\": null,'+
        '                    \"PageContent\": \"Purina is your partner in swine production, providing proven nutrition solutions and incomparable industry expertise.\",'+
        '                    \"Image\": null,'+
        '                    \"Name\": \"Swine - Retail\",'+
        '                    \"SpeciesID\": 13,'+
        '                    \"Headline\": \"Retail Swine\"'+
        '                }'+
        '            ]'+
        '        },'+
        '        {'+
        '            \"TotalRecords\": ['+
        '                {'+
        '                    \"TotalRecords\": \"14\"'+
        '                }'+
        '            ]'+
        '        }'+
        '    ]'+
        '}';    
        
/******************************************************************************
 * Sample JSON string responses to test LPDCR_BLPromotionsTest web service callouts
 */
    public static String LPDCR_BLPromotionsTest_JSON = '{\"PurinaBusinessLink_Promotions\": '+
        '['+
        '{\"PurinaBusinessLink_Promotions\": '+
        '['+
        '{\"Species\": \"Horse\",'+
        '\"ItemOrder\": null,'+
        '\"PromotionsGuid\": \"00000000-0000-0000-0000-000000000000\",'+
        '\"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/Promo-Horse-Jr-Adult.jpg?ext=.jpg\",'+
        '\"StartDate\": \"2017-04-23T00:00:00+00:00\",'+
        '\"DocumentType\": null,'+        
        '\"ShowOnHomePage\": false,'+
        '\"Headline\": \"New & Improved Purina Equine Product Family\",'+
        '\"ShowInPromoImageCarousel\": true,'+
        '\"IsActive\": true,'+
        '\"PromotionsLastModified\": \"0001-01-01T00:00:00+00:00\",'+
        '\"CarouselDocumentLink\": null,'+
        '\"CarouselURLLink\": null,'+
        '\"CarouselTextArea\": \"<ul>\\r\\n\\t<li>New Adult formula<\\/li>\\r\\n\\t<li>New Packaging for Adult &amp; Junior&nbsp;<\\/li>\\r\\n\\t<li>Relaunched Equine Senior &amp; Equine Senior Active<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '\"WYSIWYG\": \"<strong>Check out the New &amp; Improved Equine Products<\\/strong>\\r\\n<ul>\\r\\n\\t<li>New formula and packaging refresh for Equine Adult&nbsp;&nbsp;<\\/li>\\r\\n\\t<li>Packaging refresh for Equine Junior&nbsp;<\\/li>\\r\\n\\t<li>Equine Senior and Equine Senior Active relaunched in November 2014<\\/li>\\r\\n<\\/ul>\\r\\n<strong><u>Adult\\/Junior Promotion<\\/u><\\/strong><br \\/>\\r\\n<br \\/>\\r\\n<strong>Purpose:<\\/strong> Celebrate the relaunches of the Equine Adult&reg; horse feed and Equine Junior&reg; horse feed lines by treating your customers &ndash; and their horses.<br \\/>\\r\\n<br \\/>\\r\\n<strong>Process: <\\/strong>Buy 10+ bags of Equine Adult&reg; horse feed or 10+ bags of Equine Junior&reg; horse feed and receive 50% off. No max - Discount will be automatically applied. Order for this promotion during the month of August &ndash; no exceptions.<br \\/>\\r\\n<br \\/>\\r\\nIntroduce the new formula of Purina&reg; Equine Adult&reg; horse feed and updated Purina&reg; Equine Junior&reg; horse feed packaging.\",'+
        '\"CarouselButtonLink\": null,'+
        '\"ExpirationDate\": \"2027-06-29T00:00:00+00:00\",'+
        '\"InternalOnly\":false,'+
        '\"PromotionsID\": 1,'+
        '\"CarouselButtonText\": \"Read More\",'+
        '\"CarouselHeadline\": \"New & Improved Equine Products\",'+
        '\"RelatedDocuments\": null'+
        '}'+
        ']'+
        '}'+
        ',{\"TotalRecords\": '+
        '['+
        '{\"TotalRecords\":\"1\"}'+
        ']'+
        '}'+
        ']'+
        '}';

        
/******************************************************************************
 * Sample JSON string responses to test LPDCR_BLDocumentsTest web service callouts
 */
 
 public static String LPDCR_BLDocumentsTest_JSON= '{'+
        '    \"PurinaBusinessLink_Documents\": ['+
        '        {'+
        '            \"PurinaBusinessLink_Documents\": ['+
        '                {'+
        '                    \"DocumentName\": null,'+
        '                    \"IsActive\": true,'+
        '                    \"DocumentSpecies\": \"Cattle\",'+
        '                    \"VideoUrl\": null,'+
        '                    \"CarouselHeadline\": null,'+
        '                    \"DocumentShortDescription\": \"Product Page\",'+
        '                    \"DocumentWYSIWYG\": null,'+
        '                    \"DocumentsGuid\": \"18cf0167-520b-4858-ab12-29730bf84c27\",'+
        '                    \"DocumentsLastModified\": \"2017-04-19T16:13:54+00:00\",'+
        '                    \"DocumentFilePath\": \"~/BusinessLink/media/Business-Link/Documents/Cattle/Accuration-Grower-Complete-Product-Page.pdf\",'+
        '                    \"StartDate\": null,'+
        '                    \"ExpirationDate\": null,'+
        '                    \"LinkOpenInNewWindow\": false,'+
        '                    \"LinkPath\": null,'+
        '                    \"Security\": null,'+
        '                    \"CarouselImage\": null,'+
        '                    \"ShowInPromoImageCarousel\": false,'+
        '                    \"DocumentLocation\": null,'+
        '                    \"DocumentBrand\": \"Purina\",'+
        '                    \"InternalOnly\": true,'+
        '                    \"ShowOnHomePage\": false,'+
        '                    \"ItemOrder\": null,'+
        '                    \"DocumentSubBrand\": \"Accuration\",'+
        '                    \"DocumentOrLink\": \"Document\",'+
        '                    \"DocumentHasLandingPage\": false,'+
        '                    \"DocumentProduct\": \"Accuration Grower\",'+
        '                    \"DocumentType\": \"Sell Sheet\",'+
        '                    \"DocumentsID\": 81,'+
        '                    \"DocumentKeywords\": null,'+
        '                    \"CarouselTextArea\": null,'+
        '                    \"ReviewRemoveDate\": null,'+
        '                    \"FileOrLink\": \"Link To Document\"'+
        '                },'+
        '                {'+
        '                    \"DocumentName\": null,'+
        '                    \"IsActive\": true,'+
        '                    \"DocumentSpecies\": \"Cattle\",'+
        '                    \"VideoUrl\": null,'+
        '                    \"CarouselHeadline\": null,'+
        '                    \"DocumentShortDescription\": \"Sell Sheet\",'+
        '                    \"DocumentWYSIWYG\": null,'+
        '                    \"DocumentsGuid\": \"fea207c1-2d40-4a47-be09-ad72c452ea0c\",'+
        '                    \"DocumentsLastModified\": \"2017-04-18T15:35:20+00:00\",'+
        '                    \"DocumentFilePath\": \"~/BusinessLink/media/Business-Link/Documents/Cattle/Accuration-Block-Sell-Sheet-Nov-2015.pdf?ext=.pdf\",'+
        '                    \"StartDate\": null,'+
        '                    \"ExpirationDate\": null,'+
        '                    \"LinkOpenInNewWindow\": false,'+
        '                    \"LinkPath\": null,'+
        '                    \"Security\": null,'+
        '                    \"CarouselImage\": null,'+
        '                    \"ShowInPromoImageCarousel\": false,'+
        '                    \"DocumentLocation\": null,'+
        '                    \"DocumentBrand\": \"Purina\",'+
        '                    \"InternalOnly\": true,'+
        '                    \"ShowOnHomePage\": false,'+
        '                    \"ItemOrder\": null,'+
        '                    \"DocumentSubBrand\": \"Accuration\",'+
        '                    \"DocumentOrLink\": \"Document\",'+
        '                    \"DocumentHasLandingPage\": false,'+
        '                    \"DocumentProduct\": \"Accuration Block\",'+
        '                    \"DocumentType\": \"Sell Sheet\",'+
        '                    \"DocumentsID\": 80,'+
        '                    \"DocumentKeywords\": null,'+
        '                    \"CarouselTextArea\": null,'+
        '                    \"ReviewRemoveDate\": null,'+
        '                    \"FileOrLink\": \"Link To Document\"'+
        '                },'+
        '                {'+
        '                    \"DocumentName\": \"Flock Raising Happy Healthy Flocks Brochure\",'+
        '                    \"IsActive\": true,'+
        '                    \"DocumentSpecies\": \"Backyard Poultry\",'+
        '                    \"VideoUrl\": null,'+
        '                    \"CarouselHeadline\": null,'+
        '                    \"DocumentShortDescription\": null,'+
        '                    \"DocumentWYSIWYG\": null,'+
        '                    \"DocumentsGuid\": \"165fc77e-9c84-4b72-8fc6-a5737cb926ba\",'+
        '                    \"DocumentsLastModified\": \"2017-04-25T13:58:10+00:00\",'+
        '                    \"DocumentFilePath\": \"~/BusinessLink/media/Business-Link/Documents/Backyard%20Poultry/Flock-Raising-Happy-Healthy-Flocks-Brochure.pdf?ext=.pdf\",'+
        '                    \"StartDate\": null,'+
        '                    \"ExpirationDate\": null,'+
        '                    \"LinkOpenInNewWindow\": false,'+
        '                    \"LinkPath\": null,'+
        '                    \"Security\": null,'+
        '                    \"CarouselImage\": null,'+
        '                    \"ShowInPromoImageCarousel\": false,'+
        '                    \"DocumentLocation\": \"Marketing\",'+
        '                    \"DocumentBrand\": null,'+
        '                    \"InternalOnly\": true,'+
        '                    \"ShowOnHomePage\": false,'+
        '                    \"ItemOrder\": null,'+
        '                    \"DocumentSubBrand\": null,'+
        '                    \"DocumentOrLink\": \"Document\",'+
        '                    \"DocumentHasLandingPage\": false,'+
        '                    \"DocumentProduct\": null,'+
        '                    \"DocumentType\": \"Product Brochure\",'+
        '                    \"DocumentsID\": 16,'+
        '                    \"DocumentKeywords\": null,'+
        '                    \"CarouselTextArea\": null,'+
        '                    \"ReviewRemoveDate\": null,'+
        '                    \"FileOrLink\": \"Link To Document\"'+
        '                },'+
        '                {'+
        '                    \"DocumentName\": \"2015 Chick Days Ad Slicks\",'+
        '                    \"IsActive\": true,'+
        '                    \"DocumentSpecies\": \"Backyard Poultry\",'+
        '                    \"VideoUrl\": null,'+
        '                    \"CarouselHeadline\": null,'+
        '                    \"DocumentShortDescription\": null,'+
        '                    \"DocumentWYSIWYG\": \"<img alt=\\\"\\\" height=\\\"110\\\" src=\\\"~/BusinessLink/media/Business-Link/Documents/Backyard%20Poultry/Celebinions.jpg\\\" style=\\\"float: right;\\\" width=\\\"104\\\" /><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, <a href=\\\"~/BusinessLink/media/Business-Link/Documents/Backyard%20Poultry/Chick-Days-2015-Ad-Slicks_FINAL_1-8-15.pdf\\\">when an unknown</a> printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<a href=\\\"~/BusinessLink/media/Business-Link/Documents/Backyard%20Poultry/Breed-Cards-2015_FINAL_1.pdf\\\">download breed cards here</a>\\r\\n<h2>Example Header</h2>\\r\\n\",'+
        '                    \"DocumentsGuid\": \"cfb8a65a-c9ec-45a3-b8e2-5d592ae4eca5\",'+
        '                    \"DocumentsLastModified\": \"2017-04-25T13:57:24+00:00\",'+
        '                    \"DocumentFilePath\": \"~/BusinessLink/media/Business-Link/Documents/Backyard%20Poultry/2015-Chick-Days-Ad-Slicks.pdf?ext=.pdf\",'+
        '                    \"StartDate\": null,'+
        '                    \"ExpirationDate\": null,'+
        '                    \"LinkOpenInNewWindow\": false,'+
        '                    \"LinkPath\": null,'+
        '                    \"Security\": null,'+
        '                    \"CarouselImage\": null,'+
        '                    \"ShowInPromoImageCarousel\": false,'+
        '                    \"DocumentLocation\": \"Marketing\",'+
        '                    \"DocumentBrand\": null,'+
        '                    \"InternalOnly\": true,'+
        '                    \"ShowOnHomePage\": false,'+
        '                    \"ItemOrder\": null,'+
        '                    \"DocumentSubBrand\": null,'+
        '                    \"DocumentOrLink\": \"Document\",'+
        '                    \"DocumentHasLandingPage\": true,'+
        '                    \"DocumentProduct\": null,'+
        '                    \"DocumentType\": \"Ad Slick\",'+
        '                    \"DocumentsID\": 12,'+
        '                    \"DocumentKeywords\": null,'+
        '                    \"CarouselTextArea\": null,'+
        '                    \"ReviewRemoveDate\": null,'+
        '                    \"FileOrLink\": \"Link To Document\"'+
        '                },'+
        '                {'+
        '                    \"DocumentName\": \"2015 Chick Days Radio Scripts\",'+
        '                    \"IsActive\": true,'+
        '                    \"DocumentSpecies\": \"Backyard Poultry\",'+
        '                    \"VideoUrl\": null,'+
        '                    \"CarouselHeadline\": null,'+
        '                    \"DocumentShortDescription\": null,'+
        '                    \"DocumentWYSIWYG\": null,'+
        '                    \"DocumentsGuid\": \"5189bd7b-39dd-4d7e-84ea-c7613d7d4614\",'+
        '                    \"DocumentsLastModified\": \"2017-04-25T13:56:35+00:00\",'+
        '                    \"DocumentFilePath\": \"~/BusinessLink/media/Business-Link/Documents/Backyard%20Poultry/2015-Chick-Days-Radio-Scripts.docx?ext=.docx\",'+
        '                    \"StartDate\": null,'+
        '                    \"ExpirationDate\": null,'+
        '                    \"LinkOpenInNewWindow\": false,'+
        '                    \"LinkPath\": null,'+
        '                    \"Security\": null,'+
        '                    \"CarouselImage\": null,'+
        '                    \"ShowInPromoImageCarousel\": false,'+
        '                    \"DocumentLocation\": \"Marketing\",'+
        '                    \"DocumentBrand\": null,'+
        '                    \"InternalOnly\": true,'+
        '                    \"ShowOnHomePage\": false,'+
        '                    \"ItemOrder\": null,'+
        '                    \"DocumentSubBrand\": null,'+
        '                    \"DocumentOrLink\": \"Document\",'+
        '                    \"DocumentHasLandingPage\": false,'+
        '                    \"DocumentProduct\": null,'+
        '                    \"DocumentType\": \"Radio Script\",'+
        '                    \"DocumentsID\": 9,'+
        '                    \"DocumentKeywords\": null,'+
        '                    \"CarouselTextArea\": null,'+
        '                    \"ReviewRemoveDate\": null,'+
        '                    \"FileOrLink\": \"Link To Document\"'+
        '                }'+
        '            ]'+
        '        },'+
        '        {'+
        '            \"TotalRecords\": ['+
        '                {'+
        '                    \"TotalRecords\": \"5\"'+
        '                }'+
        '            ]'+
        '        }'+
        '    ]'+
        '}';//"PurinaBusinessLink_Documents": close

/******************************************************************************
 * Sample JSON string responses for the Carousel Promotions web service
 */
    public static String LPDCR_Carousel_Promotions_JSON = '{'+
        '  \"PurinaBusinessLink_Promotions\": ['+
        '    {'+
        '      \"PurinaBusinessLink_Promotions\": ['+
        '        {'+
        '          \"Species\": \"Horse\",'+
        '          \"ItemOrder\": null,'+
        '          \"PromotionsGuid\": \"00000000-0000-0000-0000-000000000000\",'+
        '          \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/Promo-Horse-Jr-Adult.jpg?ext=.jpg\",'+
        '          \"StartDate\": \"2017-04-23T00:00:00+00:00"\",'+
        '          \"DocumentType\": null'+        
        '          \"ShowOnHomePage\": false,'+
        '          \"Headline\": \"New & Improved Purina Equine Product Family\",'+
        '          \"ShowInPromoImageCarousel\": true,'+
        '          \"IsActive\": true,'+
        '          \"PromotionsLastModified\": \"0001-01-01T00:00:00+00:00\",'+
        '          \"CarouselDocumentLink\": null,'+
        '          \"CarouselURLLink\": null,'+
        '          \"CarouselTextArea\": \"<ul>\\r\\n\\t<li>New Adult formula<\\/li>\\r\\n\\t<li>New Packaging for Adult &amp; Junior&nbsp;<\\/li>\\r\\n\\t<li>Relaunched Equine Senior &amp; Equine Senior Active<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"WYSIWYG\": \"<strong>Check out the New &amp; Improved Equine Products<\\/strong>\\r\\n<ul>\\r\\n\\t<li>New formula and packaging refresh for Equine Adult&nbsp;&nbsp;<\\/li>\\r\\n\\t<li>Packaging refresh for Equine Junior&nbsp;<\\/li>\\r\\n\\t<li>Equine Senior and Equine Senior Active relaunched in November 2014<\\/li>\\r\\n<\\/ul>\\r\\n<strong><u>Adult\\/Junior Promotion<\\/u><\\/strong><br \\/>\\r\\n<br \\/>\\r\\n<strong>Purpose:<\\/strong> Celebrate the relaunches of the Equine Adult&reg; horse feed and Equine Junior&reg; horse feed lines by treating your customers &ndash; and their horses.<br \\/>\\r\\n<br \\/>\\r\\n<strong>Process: <\\/strong>Buy 10+ bags of Equine Adult&reg; horse feed or 10+ bags of Equine Junior&reg; horse feed and receive 50% off. No max - Discount will be automatically applied. Order for this promotion during the month of August &ndash; no exceptions.<br \\/>\\r\\n<br \\/>\\r\\nIntroduce the new formula of Purina&reg; Equine Adult&reg; horse feed and updated Purina&reg; Equine Junior&reg; horse feed packaging.\",'+
        '          \"CarouselButtonLink\": null,'+
        '          \"ExpirationDate\": \"2027-06-29T00:00:00+00:00\",'+
        '          \"InternalOnly\":false,'+
        '          \"PromotionsID\": 1,'+
        '          \"CarouselButtonText\": \"Read More\",'+
        '          \"CarouselHeadline\": \"New & Improved Equine Products\",'+
        '          \"RelatedDocuments\": null'+
        '        },'+
        '        {'+
        '          \"Species\": \"Backyard Poultry\",'+
        '          \"ItemOrder\": null,'+
        '          \"PromotionsGuid\": \"00000000-0000-0000-0000-000000000000\",'+
        '          \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/chickens_promo_slide_image-1.png?ext=.png\",'+
        '          \"StartDate\": \"2017-04-23T00:00:00+00:00"\",'+
        '          \"DocumentType\": null'+
        '          \"ShowOnHomePage\": false,'+
        '          \"Headline\": \"Premium Poultry Layer Products\",'+
        '          \"ShowInPromoImageCarousel\": true,'+
        '          \"IsActive\": true,'+
        '          \"PromotionsLastModified\": \"0001-01-01T00:00:00+00:00\",'+
        '          \"CarouselDocumentLink\": null,'+
        '          \"CarouselURLLink\": null,'+
        '          \"CarouselTextArea\": \"<ul>\\r\\n\\t<li>Supports your birds&#39; immune health<\\/li>\\r\\n\\t<li>Now with Prebiotics &amp; Probiotics<\\/li>\\r\\n\\t<li>Available in Pellets &amp; Crumbles<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"WYSIWYG\": \"<ul>\\r\\n\\t<li>Supports your birds&#39; immune health<\\/li>\\r\\n\\t<li>Now with Prebiotics &amp; Probiotics<\\/li>\\r\\n\\t<li>Available in Pellets &amp; Crumbles<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"CarouselButtonLink\": \"Link to current promotion\",'+
        '          \"ExpirationDate\": \"2027-06-29T00:00:00+00:00\",'+
        '          \"PromotionsID\": 2,'+
        '          \"CarouselButtonText\": \"Read More\",'+
        '          \"CarouselHeadline\": \"Premium Poultry Layer Products\",'+
        '          \"RelatedDocuments\": null'+
        '        },'+
        '        {'+
        '          \"Species\": \"Dairy - Transition & Lactating Cow\",'+
        '          \"ItemOrder\": null,'+
        '          \"PromotionsGuid\": \"00000000-0000-0000-0000-000000000000\",'+
        '          \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/Promo-Dairy-Cow-Pasture.jpg?ext=.jpg\",'+
        '          \"StartDate\": \"2017-04-23T00:00:00+00:00"\",'+
        '          \"DocumentType\": null'+
        '          \"ShowOnHomePage\": false,'+
        '          \"Headline\": \"NutriTek\\u00ae Technology \",'+
        '          \"ShowInPromoImageCarousel\": true,'+
        '          \"IsActive\": true,'+
        '          \"PromotionsLastModified\": \"0001-01-01T00:00:00+00:00\",'+
        '          \"CarouselDocumentLink\": null,'+
        '          \"CarouselURLLink\": null,'+
        '          \"CarouselTextArea\": \"<ul>\\r\\n\\t<li>New fermentation technology<\\/li>\\r\\n\\t<li>Delivers higher peak milk<\\/li>\\r\\n\\t<li>Research and trial proven<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"WYSIWYG\": \"An Investment for Healthier Cows\\r\\n<ul>\\r\\n\\t<li>Features new fermentation technology<\\/li>\\r\\n\\t<li>Meets the demands of transition cows to deliver higher peak milk<\\/li>\\r\\n\\t<li>Research and field trial proven<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"CarouselButtonLink\": null,'+
        '          \"ExpirationDate\": \"2027-06-29T00:00:00+00:00\",'+
        '          \"PromotionsID\": 4,'+
        '          \"CarouselButtonText\": \"Read More\",'+
        '          \"CarouselHeadline\": \"NutriTek\\u00ae Technology \",'+
        '          \"RelatedDocuments\": null'+
        '        },'+
        '        {'+
        '          \"Species\": \"Cattle\",'+
        '          \"ItemOrder\": null,'+
        '          \"PromotionsGuid\": \"00000000-0000-0000-0000-000000000000\",'+
        '          \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/CheckerboadDaysLogo.jpg?ext=.jpg\",'+
        '          \"StartDate\": \"2017-04-23T00:00:00+00:00"\",'+
        '          \"DocumentType\": null'+
        '          \"ShowOnHomePage\": false,'+
        '          \"Headline\": \"Check-R-Board\\u00ae Days\",'+
        '          \"ShowInPromoImageCarousel\": true,'+
        '          \"IsActive\": true,'+
        '          \"PromotionsLastModified\": \"0001-01-01T00:00:00+00:00\",'+
        '          \"CarouselDocumentLink\": null,'+
        '          \"CarouselURLLink\": null,'+
        '          \"CarouselTextArea\": \"<ul>\\r\\n\\t<li>Generates feed sales<\\/li>\\r\\n\\t<li>Creates greater sense of community<\\/li>\\r\\n\\t<li>Provides customer opportunities<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"WYSIWYG\": \"<strong>Purpose:<\\/strong> Celebrate the integrity and leadership of the Purina brand with a fun and exciting event focusing on selling feed.<br \\/>\\r\\n<br \\/>\\r\\n<strong>Process:<\\/strong> Check-R-Board&reg; Days events can be held from January through December either as a stand-alone event or tied in with an existing event (i.e. Customer Appreciation, HOW&reg; Meeting, Check Days, C.O.W. Meeting, etc.).<br \\/>\\r\\n<br \\/>\\r\\n<strong>Payoff: <\\/strong>\\r\\n<ul>\\r\\n\\t<li>New and repeat feed sales for the independent dealer.<\\/li>\\r\\n\\t<li>Greater sense of community and brand pride.<\\/li>\\r\\n\\t<li>Provides opportunities with both new and existing customers.<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"CarouselButtonLink\": null,'+
        '          \"ExpirationDate\": \"2027-06-29T00:00:00+00:00\",'+
        '          \"PromotionsID\": 5,'+
        '          \"CarouselButtonText\": \"Read More\",'+
        '          \"CarouselHeadline\": \"Check-R-Board\\u00ae Days\",'+
        '          \"RelatedDocuments\": null'+
        '        },'+
        '        {'+
        '          \"Species\": \"Dairy - Transition & Lactating Cow\",'+
        '          \"ItemOrder\": null,'+
        '          \"PromotionsGuid\": \"00000000-0000-0000-0000-000000000000\",'+
        '          \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/Promo-Dairy-Cows-at-Bunk.jpg?ext=.jpg\",'+
        '          \"StartDate\": \"2017-04-23T00:00:00+00:00"\",'+
        '          \"DocumentType\": Video'+
        '          \"ShowOnHomePage\": false,'+
        '          \"Headline\": \"Cool Cow Heat Abatement Program \",'+
        '          \"ShowInPromoImageCarousel\": true,'+
        '          \"IsActive\": true,'+
        '          \"PromotionsLastModified\": \"0001-01-01T00:00:00+00:00\",'+
        '          \"CarouselDocumentLink\": null,'+
        '          \"CarouselURLLink\": null,'+
        '          \"CarouselTextArea\": \"<ul>\\r\\n\\t<li>Help manage heat stress<\\/li>\\r\\n\\t<li>Rally&reg; New Business Promotion<\\/li>\\r\\n\\t<li>Comprehensive tools available<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"WYSIWYG\": \"<ul>\\r\\n\\t<li>Help Dairy Producers manage heat stress<\\/li>\\r\\n\\t<li>Rally&reg; New Business Promotion -&nbsp; May 1 - September 30, 2015&nbsp;<\\/li>\\r\\n\\t<li>Comprehensive tools available<\\/li>\\r\\n<\\/ul>\\r\\n\",'+
        '          \"CarouselButtonLink\": null,'+
        '          \"ExpirationDate\": \"2027-06-29T00:00:00+00:00\",'+
        '          \"PromotionsID\": 6,'+
        '          \"CarouselButtonText\": \"Read More\",'+
        '          \"CarouselHeadline\": \"Cool Cow Heat Abatement Program\",'+
        '          \"RelatedDocuments\": null'+
        '        }'+
        '      ]'+
        '    },'+
        '    {'+
        '      \"TotalRecords\": ['+
        '        {'+
        '          \"TotalRecords\": \"5\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  ]'+
        '}';

/******************************************************************************
 * Sample XML string response for the Document search web service
 */
    public static String LPDCR_Document_Search_Response_XML = '<?xml version=\"1.0\" encoding=\"utf-8\" ?>' +
            '<string xmlns=\"http://tempuri.org/\">{ '+
            ' \"results\": [ ' +
                '{' +
                  '\"id\": \"1050_PurinaBusinessLink.Documents\", '+
                  '\"type\": \"PurinaBusinessLink.Documents\", '+
                  '\"score\": \"1\", '+
                  '\"position\": \"0\", '+
                  '\"title\": \"Miniature Horse Logo - Vertical\", '+
                  '\"content\": \"Horse\", '+
                  '\"created\": \"5\\/15\\/2107 12:00:00 AM\", '+
                  '\"image\": null, '+
                  '\"imageclass\": null, '+
                  '\"absscore\": \"1.282693\", '+
                  '\"maxscore\": \"1.282693\", '+
                  '\"index\": \"BusinessLinkDocuments\", '+
                  '\"IsActive\": true, '+
                  '\"InternalOnly\": false, '+
                  '\"FileOrLink\": \"Link To Document\", '+
                  '\"DocumentName\": \"Miniature Horse Logo - Vertical\", '+
                  '\"DocumentFilePath\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Documents\\/Horse\\/Miniature-Horse-Vertical-Logo-EPS.eps\", '+
                  '\"VideoUrl\": null, '+
                  '\"DocumentHasLandingPage\": false, '+
                  '\"ShowInPromoImageCarousel\": false, '+
                  '\"DocumentSpecies\": \"Horse\", '+
                  '\"DocumentLocation\": \"Marketing\", '+
                  '\"DocumentType\": \"Logo\", '+
                  '\"DocumentProduct\": null, '+
                  '\"DocumentBrand\": \"Purina\", '+
                  '\"DocumentSubBrand\": null, '+
                  '\"DocumentShortDescription\": \"Logo\", '+
                  '\"DocumentKeywords\": \"Miniature Horse Vertical Logo\", '+
                  '\"DocumentWYSIWYG\": \"Logo\", '+
                  '\"CarouselHeadline\": null, '+
                  '\"CarouselTextArea\": null, '+
                  '\"CarouselImage\": null, '+
                  '\"ShowOnHomePage\": false, '+
                  '\"DocumentOrLink\": \"Document\", '+
                  '\"LinkPath\": null, '+
                  '\"LinkOpenInNewWindow\": false, '+
                  '\"StartDate\": \"2107-05-15T00:00:00\", '+
                  '\"ExpirationDate\": null, '+
                  '\"DocumentsLastModified\": \"2017-05-19T14:55:06\", '+
                  '\"RandomObjectToConsume\": null '+
                '}, '+
                '{ '+
                  '\"id\": \"939_PurinaBusinessLink.Documents\", '+
                  '\"type\": \"PurinaBusinessLink.Documents\", '+
                  '\"score\": \"0.894426866894523\", '+
                  '\"position\": \"1\", '+
                  '\"title\": \"Horse Radio Script\", '+
                  '\"content\": \"Horse\", '+
                  '\"created\": \"5\\/15\\/2107 12:00:00 AM\", '+
                  '\"image\": null, '+
                  '\"imageclass\": null, '+
                  '\"absscore\": \"1.147275\", '+
                  '\"maxscore\": \"1.282693\", '+
                  '\"index\": \"BusinessLinkDocuments\", '+
                  '\"IsActive\": true, '+
                  '\"InternalOnly\": false, '+
                  '\"FileOrLink\": \"Link To Document\", '+
                  '\"DocumentName\": \"Horse Radio Script\", '+
                  '\"DocumentFilePath\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Documents\\/Horse\\/UAT-Horse-Radio-Script-PUBS_ECMP2-0120991.pdf?ext=.pdf\", '+
                  '\"VideoUrl\": null, '+
                  '\"DocumentHasLandingPage\": false, '+
                  '\"ShowInPromoImageCarousel\": false, '+
                  '\"DocumentSpecies\": \"Horse\", '+
                  '\"DocumentLocation\": \"\", '+
                  '\"DocumentType\": \"Radio Script\", '+
                  '\"DocumentProduct\": null, '+
                  '\"DocumentBrand\": \"Purina\", '+
                  '\"DocumentSubBrand\": null, '+
                  '\"DocumentShortDescription\": null, '+
                  '\"DocumentKeywords\": null, '+
                  '\"DocumentWYSIWYG\": null, '+
                  '\"CarouselHeadline\": null, '+
                  '\"CarouselTextArea\": null, '+
                  '\"CarouselImage\": null, '+
                  '\"ShowOnHomePage\": false, '+
                  '\"DocumentOrLink\": \"Document\", '+
                  '\"LinkPath\": null, '+
                  '\"LinkOpenInNewWindow\": false, '+
                  '\"StartDate\": \"2107-05-15T00:00:00\", '+
                  '\"ExpirationDate\": null, '+
                  '\"DocumentsLastModified\": \"2017-05-17T13:59:21\", '+
                  '\"RandomObjectToConsume\": null '+
                '}, '+
                '{ '+
                  '\"id\": \"1030_PurinaBusinessLink.Documents\", '+
                  '\"type\": \"PurinaBusinessLink.Documents\", '+
                  '\"score\": \"0.833333522232325\", '+
                  '\"position\": \"2\", '+
                  '\"title\": \"Impact Horse Feed Ad Slick\", '+
                  '\"content\": \"Horse\", '+
                  '\"created\": \"5\\/15\\/2107 12:00:00 AM\", '+
                  '\"image\": null, '+
                  '\"imageclass\": null, '+
                  '\"absscore\": \"1.068911\", '+
                  '\"maxscore\": \"1.282693\", '+
                  '\"index\": \"BusinessLinkDocuments\", '+
                  '\"IsActive\": false, '+
                  '\"InternalOnly\": false, '+
                  '\"FileOrLink\": \"Link To Document\", '+
                  '\"DocumentName\": \"Impact Horse Feed Ad Slick\", '+
                  '\"DocumentFilePath\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Documents\\/Horse\\/Impact-Horse-Feed-Ad-Slick.pdf\", '+
                  '\"VideoUrl\": null, '+
                  '\"DocumentHasLandingPage\": false, '+
                  '\"ShowInPromoImageCarousel\": false, '+
                  '\"DocumentSpecies\": \"Horse\", '+
                  '\"DocumentLocation\": \"Marketing\", '+
                  '\"DocumentType\": \"Ad Slick\", '+
                  '\"DocumentProduct\": \"Impact\", '+
                  '\"DocumentBrand\": \"Purina\", '+
                  '\"DocumentSubBrand\": null, '+
                  '\"DocumentShortDescription\": \"Packaging\", '+
                  '\"DocumentKeywords\": \"Impact Horse Feed Ad Slick\", '+
                  '\"DocumentWYSIWYG\": \"Packaging\", '+
                  '\"CarouselHeadline\": null, '+
                  '\"CarouselTextArea\": null, '+
                  '\"CarouselImage\": null, '+
                  '\"ShowOnHomePage\": false, '+
                  '\"DocumentOrLink\": \"Document\", '+
                  '\"LinkPath\": null, '+
                  '\"LinkOpenInNewWindow\": false, '+
                  '\"StartDate\": \"2107-05-15T00:00:00\", '+
                  '\"ExpirationDate\": null, '+
                  '\"DocumentsLastModified\": \"2017-05-18T15:53:35\", '+
                  '\"RandomObjectToConsume\": null '+
                '}]}</string>';

/******************************************************************************
 * Sample XML string response for the Promotion search web service
 */
    public static String LPDCR_Promotion_Search_Response_XML = '<?xml version=\"1.0\" encoding=\"utf-8\" ?>' +
            '<string xmlns=\"http://tempuri.org/\">{ '+
            ' \"Table\": [ '+
            '    { '+
            '      \"PromotionsID\": 14, '+
            '      \"PromotionsGuid\": \"9ef547ec-e29e-4ed3-8eab-2cfcad483706\", '+
            '      \"PromotionsLastModified\": \"2017-05-17T12:22:10\", '+
            '      \"Headline\": \"Nature\'s Match - Targeting Overall Nutrient Utilization to Optimize Sow and Pig Performance\", '+
            '      \"Species\": \"Cattle|Swine - Retail\", '+
            '      \"WYSIWYG\": \"\", '+
            '      \"ShowInPromoImageCarousel\": true, '+
            '      \"ShowOnHomePage\": false, '+
            '      \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Images\\/Promo\\/Promo-Retail-Swine-Grass-by-Round-Bale.jpg?ext=.jpg\", '+
            '      \"CarouselHeadline\": \"Nutrient Utilization to Optimize Performance\", '+
            '      \"CarouselTextArea\": \"\", '+
            '      \"CarouselButtonText\": \"Read More\", '+
            '      \"CarouselButtonLink\": \"Link to current promotion\", '+
            '      \"CarouselDocumentLink\": null, '+
            '      \"CarouselURLLink\": null, '+
            '      \"RelatedDocuments\": null, '+
            '      \"IsActive\": true, '+
            '      \"ItemOrder\": 3, '+
            '      \"StartDate\": \"2017-04-26T00:00:00\", '+
            '      \"ExpirationDate\": \"2017-06-28T00:00:00\", '+
            '      \"DocumentType\": \"Promotions\", '+
            '      \"InternalOnly\": false, '+
            '      \"DocumentLocation\": null, '+
            '      \"RandomObjectToConsume\": null '+
            '    }, '+
            '    { '+
            '      \"PromotionsID\": 42, '+
            '      \"PromotionsGuid\": \"53a5ad82-7a50-4cdb-8964-6bc27a966ec7\", '+
            '      \"PromotionsLastModified\": \"2017-05-12T14:55:49\", '+
            '      \"Headline\": \"CheckPoint Newsletter\", '+
            '      \"Species\": \"Cattle\", '+
            '      \"WYSIWYG\": \"\", '+
            '      \"ShowInPromoImageCarousel\": false, '+
            '      \"ShowOnHomePage\": false, '+
            '      \"CarouselImage\": null, '+
            '      \"CarouselHeadline\": null, '+
            '      \"CarouselTextArea\": null, '+
            '      \"CarouselButtonText\": \"Read More\", '+
            '      \"CarouselButtonLink\": null, '+
            '      \"CarouselDocumentLink\": null, '+
            '      \"CarouselURLLink\": null, '+
            '      \"RelatedDocuments\": null, '+
            '      \"IsActive\": false, '+
            '      \"ItemOrder\": 7, '+
            '      \"StartDate\": \"2017-05-15T00:00:00\", '+
            '      \"ExpirationDate\": \"2017-05-31T00:00:00\", '+
            '      \"DocumentType\": null, '+
            '      \"InternalOnly\": false, '+
            '      \"DocumentLocation\": null, '+
            '      \"RandomObjectToConsume\": null '+
            '    }, '+
            '    { '+
            '      \"PromotionsID\": 62, '+
            '      \"PromotionsGuid\": \"2c4e614c-e85e-4edf-bc70-f3017761aa6c\", '+
            '      \"PromotionsLastModified\": \"2017-05-12T14:56:09\", '+
            '      \"Headline\": \"Farmer Feeder Consolidation\", '+
            '      \"Species\": \"Cattle\", '+
            '      \"WYSIWYG\": \"\", '+
            '      \"ShowInPromoImageCarousel\": false, '+
            '      \"ShowOnHomePage\": false, '+
            '      \"CarouselImage\": null, '+
            '      \"CarouselHeadline\": null, '+
            '      \"CarouselTextArea\": null, '+
            '      \"CarouselButtonText\": \"Read More\", '+
            '      \"CarouselButtonLink\": null, '+
            '      \"CarouselDocumentLink\": null, '+
            '      \"CarouselURLLink\": null, '+
            '      \"RelatedDocuments\": null, '+
            '      \"IsActive\": false, '+
            '      \"ItemOrder\": 14, '+
            '      \"StartDate\": \"2017-05-23T00:00:00\", '+
            '      \"ExpirationDate\": \"2017-05-31T00:00:00\", '+
            '      \"DocumentType\": null, '+
            '      \"InternalOnly\": false, '+
            '      \"DocumentLocation\": null, '+
            '      \"RandomObjectToConsume\": null '+
            '    }, '+
            '    { '+
            '      \"PromotionsID\": 66, '+
            '      \"PromotionsGuid\": \"a26a81f9-834a-4c56-94a7-dcd71541fb08\", '+
            '      \"PromotionsLastModified\": \"2017-05-18T02:10:29\", '+
            '      \"Headline\": \"Feed Greatness\", '+
            '      \"Species\": \"Backyard Poultry|Cattle|Dairy - Young Animal|Horse|Swine - Commercial|Deer &amp; Elk|Goat|Fish &amp; Aqua|Rabbit|Show|Swine - Retail\", '+
            '      \"WYSIWYG\": \"\", '+
            '      \"ShowInPromoImageCarousel\": true, '+
            '      \"ShowOnHomePage\": true, '+
            '      \"CarouselImage\": \"~\\/BusinessLink\\/media\\/Business-Link\\/Documents\\/Multi%20Species\\/PURINA_FeedGreatness_412x285.png?ext=.png\", '+
            '      \"CarouselHeadline\": \"Feed Greatness\", '+
            '      \"CarouselTextArea\": \"\", '+
            '      \"CarouselButtonText\": \"Learn More\", '+
            '      \"CarouselButtonLink\": \"Link to current promotion\", '+
            '      \"CarouselDocumentLink\": null, '+
            '      \"CarouselURLLink\": null, '+
            '      \"RelatedDocuments\": null, '+
            '      \"IsActive\": true, '+
            '      \"ItemOrder\": 16, '+
            '      \"StartDate\": \"2017-05-22T00:00:00\", '+
            '      \"ExpirationDate\": \"2017-06-30T00:00:00\", '+
            '      \"DocumentType\": \"Promotions\", '+
            '      \"InternalOnly\": false, '+
            '      \"DocumentLocation\": null, '+
            '      \"RandomObjectToConsume\": null '+
            '    }]}</string>';
        /**************************************************************
        // Sample OBIEE Dealer VIP TONES 
        ************************************/
   public static String 
   LPDCR_DealerVipTonesReportTest_JSON = '{' +
 ' "row" : [ {' +
 '   "column" : [ {' +
 '    "name" : "s_0",' +
 '     "value" : "0"' +
 '   }, {' +
 '     "name" : "s_1",' +
 '     "value" : "302067"' +
 '  }, {' +
 '    "name" : "s_2",' +
 '     "value" : "A B POE AND CO INC"' +
 '  }, {' +
 '     "name" : "s_7",' +
 '     "value" : "PUR HERDMKR PB NT 16 25LB"' +
 '   }, {' +
 '     "name" : "s_8",' +
 '    "value" : "3003203-103"' +
 '   }, {' +
 '     "name" : "s_3",' +
 '     "value" : "302067"' +
 '  }, {' +
 '     "name" : "s_4",' +
 '     "value" : "A B POE AND CO INC"' +
 '   }, {' +
 '     "name" : "s_5",' +
  '    "value" : "271"' +
  '  }, {' +
  '   "name" : "s_6",' +
  '    "value" : "AMP MILK REPLACER LIVESTOCK"' +
  '  }, {' +
   '   "name" : "s_13",' +
    '  "value" : "0.025"' +
   ' }, {' +
   '   "name" : "s_14",' +
    '  "value" : "0.025"' +
   ' }, {' +
    '  "name" : "s_18",' +
     ' "value" : "1.625"' +
   ' }, {' +
    '  "name" : "s_22",' +
     ' "value" : "1.625"' +
   ' } ]' +
 ' } ]' +
'}';
   
   public static String 
   LPDCR_InternalVipTonesReportTest_JSON =  '{' +
 '  "row" : [ {' +
 '   "column" : [ {' +
 '     "name" : "s_0",' +
  '    "value" : "0"' +
  '  }, {' +
  '    "name" : "s_9",' +
   '   "value" : "1513900"' +
   ' }, {' +
   '   "name" : "s_10",' +
    '  "value" : "Territory - 1513900"' +
   ' }, {' +
   '   "name" : "s_11",' +
   '   "value" : "12345"' +
   ' }, {' +
   '   "name" : "s_12",' +
   '   "value" : "JOHNSON ALLEN"' +
   ' }, {' +
   '   "name" : "s_13",' +
   '   "value" : "7661.50486"' +
   ' }, {' +
    '  "name" : "s_14",' +
    '  "value" : "41370.991775"' +
   ' }, {' +
   '   "name" : "s_15",' +
    '  "value" : "8914.34675"' +
   ' }, {' +
    '  "name" : "s_16",' +
    '  "value" : "1242.166135"' +
   ' }, {' +
    '  "name" : "s_17",' +
   '   "value" : "15228.986195"' +
   ' }, {' +
    '  "name" : "s_18",' +
    '  "value" : "373.699375"' +
   ' }, {' +
   '   "name" : "s_19",' +
   '   "value" : "47010.402265"' +
   ' }, {' +
   '   "name" : "s_20",' +
    '  "value" : "6065.8506375"' +
   ' }, {' +
   '   "name" : "s_21",' +
   '   "value" : "81608.7008025"' +
   ' }, {' +
   '   "name" : "s_22",' +
   '   "value" : "1791.9908125"' +
   ' } ]' +
 ' } ]' +
'}';
}// /END Class