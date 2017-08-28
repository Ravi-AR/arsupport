/*
* @Auther : Shruti Mishra
* @Date   : 12/07/2016
* @Updated: 06/13/2017 : Adding string constants for the VIP Points & Tons Report SQL strings
* Description : This class is to store commonly used Constants.
*/
public class LPDCR_Constants{
    public final static String CONS_STATUS = system.label.LPDCR_APPROVAL_STATUS_API;
    public final static String CONS_ProgramYear = system.label.LPDCR_SSPY_NAME;
    public final static String CONS_EXPENSE = system.label.LPDCR_EXPENSE;
    public final static String CONS_BalanceAdjustment = system.label.LPDCR_BALANCE_ADJUSTMENT;
    public final static string CONS_CampRecType = system.label.LPDCR_PROMOTION_PREBOOKING;
    public final static string CONS_CampBBRecType = system.label.LPDCR_BUSINESS_BUILDER_PROMOTIONS;
    public final static string CONS_CommunityUser = system.label.LPDCR_COMMUNITY_USER;
    public final static String CONS_STATUS_SAVED = system.label.LPDCR_SAVED;
    public final static String CONS_SUBMITDATE = system.label.LPDCR_CREATED_DATE;
    public final static String CONS_DESC = system.label.LPDCR_DESC;
    public final static String CONS_FARMVIPEVENTS = system.label.LPDCR_FARMVIPEVENTS;//Customer Events
    public final static String CONS_NATIONALEVENTS = system.label.LPDCR_NationalEvent;//Customer Events
    
    
    //LPDCR_BBPLandingMember
    public final static String CONS_ENROLLED = system.label.LPDCR_ENROLLED; //Enrolled
    public final static String CONS_INELIGIBLE = system.label.LPDCR_INELIGIBLE; //Ineligible
    public final static String CONS_COOPERATIVE = system.label.LPDCR_COOPERATIVE; //010-Cooperative;
    public final static String CONS_INDEPENDENT_RETAILER = system.label.LPDCR_INDEPENDENT_RETAILER;  //071-Independent Retailer;
    public final static String CONS_CO = system.label.LPDCR_CO; //CO;
    public final static String CONS_IN = system.label.LPDCR_IN; //IN;
    public final static String CONS_RE = system.label.LPDCR_RE; //RE;
    public final static String CONS_ENROLLMENT_REQUESTED = system.label.LPDCR_ENROLLMENT_REQUESTED; //Enrollment Requested;
    public final static String CONS_SSPY_API = system.label.LPDCR_SSPY_API; //SellingSupportProgramYear__c;
    public final static String CONS_STANDARD = system.label.LPDCR_STANDARD; //Standard;
    public final static String CONS_BB_DOCUMENTS = system.label.LPDCR_BB_DOCUMENTS; //BB_Documents;
    public final static String CONS_SELECTED_ACCID = system.label.LPDCR_SELECTED_ACCID; //selectedAccountId;
    
    //LPDCR_ExpenseController
    public final static String CONS_CreatedDate = system.label.LPDCR_CreatedDate; //CreatedDate
    //public final static String CONS_DESC = system.label.LPDCR_DESC; //DESC
    public final static String CONS_BBYear = system.label.LPDCR_BBYear; //BBYear
    public final static String CONS_Accountid = system.label.LPDCR_Accountid; //Accountid
    public final static String CONS_expenseId = system.label.LPDCR_expenseId; //expenseId
    //public final static String CONS_BBYear = system.label.LPDCR_BBYear; //BBYear
    
                                                 // Returns the summary report data
                                                 // for an internal user that is
                                                 // displayed on the community homepage 
    public final static String INTERNAL_VIP_POINTS_SUMMARY_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Employee Num" s_11, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Name" s_12,'
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" s_13, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" s_14, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21 '
            + 'FROM "Feed Sales Compensation" '
            + 'WHERE (("Invoice Date"."Year" =  VALUEOF("CURRENT_BUSINESS_YEAR")) AND ("Sales Territory Assign Rep"."Salesperson Employee Num" IN (:param1))) '
            + 'ORDER BY 2 ASC NULLS LAST, 3 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY';

                                                 // Should return a list of Territories
                                                 // with the summary Points & Tons data
                                                 // for an Internal user
    public final static String INTERNAL_TERRITORY_LIST_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Sales Territory Code" s_9, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Sales Territory Desc" s_10, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Employee Num" s_11, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Name" s_12, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" s_13, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" s_14, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22 '
            + 'FROM "Feed Sales Compensation" '
            + 'WHERE (("Invoice Date"."Year" = VALUEOF("CURRENT_BUSINESS_YEAR")) AND ("Sales Territory Assign Rep"."Salesperson Employee Num" IN (:param1))) '
            + 'ORDER BY 5 ASC NULLS LAST, 4 ASC NULLS LAST, 3 ASC NULLS LAST, 2 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';                                            
                                                 
                                                 // Should return a list of accounts
                                                 /// for a territory for internal users
    public final static String INTERNAL_ACCOUNT_LIST_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Sales Compensation"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Sales Compensation"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Sales Compensation"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Sales Compensation"."FD1 Parent"."Parent FD1 Customer" s_4, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Sales Territory Code" s_9, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Sales Territory Desc" s_10, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Employee Num" s_11, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Name" s_12, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" s_13, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" s_14, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22 '
            + 'FROM "Feed Sales Compensation" '
            + 'WHERE (("Invoice Date"."Year" = VALUEOF("CURRENT_BUSINESS_YEAR")) AND ("Sales Territory Assign Rep"."Salesperson Employee Num" IN (:param1)) AND ("Sales Territory Assign Rep"."Sales Territory Code" IN (\':param2\'))) '
            + 'ORDER BY 5 ASC NULLS LAST, 4 ASC NULLS LAST, 3 ASC NULLS LAST, 2 ASC NULLS LAST, 7 ASC NULLS LAST, 6 ASC NULLS LAST, 9 ASC NULLS LAST, 8 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
    
                                                 // Should return the list of LEVEL 3 records
                                                 // for a given account for internal users
    public final static String INTERNAL_LEVEL3_LIST_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Sales Compensation"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Sales Compensation"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Sales Compensation"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Sales Compensation"."FD1 Parent"."Parent FD1 Customer" s_4, '
            + '"Feed Sales Compensation"."Product"."Level3 ID" s_5, '
            + '"Feed Sales Compensation"."Product"."Level3" s_6, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Employee Num" s_11, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Name" s_12, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" s_13, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" s_14, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22 '
            + 'FROM "Feed Sales Compensation" '
            + 'WHERE (("Invoice Date"."Year" =  VALUEOF("CURRENT_BUSINESS_YEAR")) AND ("Sales Territory Assign Rep"."Salesperson Employee Num" IN (:param1)) AND ("FD1 Parent"."Parent FD1 Customer Number" IN (:param2)) ) '
            + 'ORDER BY 10 ASC NULLS LAST, 11 ASC NULLS LAST, 12 ASC NULLS LAST, 13 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST, 3 ASC NULLS LAST, 2 ASC NULLS LAST, 7 ASC NULLS LAST, 6 ASC NULLS LAST, 9 ASC NULLS LAST, 8 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
    
                                                 // Should return the list of product records
                                                 // for a given Level 3 record for internal users
    public final static String INTERNAL_PRODUCT_LIST_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Sales Compensation"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Sales Compensation"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Sales Compensation"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Sales Compensation"."FD1 Parent"."Parent FD1 Customer" s_4, '
            + '"Feed Sales Compensation"."Product"."Level3 ID" s_5, '
            + '"Feed Sales Compensation"."Product"."Level3" s_6, '
            + '"Feed Sales Compensation"."Product"."Product Name" s_7, '
            + '"Feed Sales Compensation"."Product"."Product Number" s_8, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Employee Num" s_11, '
            + '"Feed Sales Compensation"."Sales Territory Assign Rep"."Salesperson Name" s_12, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" s_13, '
            + '"Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" s_14, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split Shipped Tons" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" <=VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYM" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points - PYTD" USING ("Feed Sales Compensation"."Invoice Date"."Month" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Sales Compensation"."Sales Compensation Metrics"."Split VIP Points" USING ("Feed Sales Compensation"."Invoice Date"."Month" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22 '
            + 'FROM "Feed Sales Compensation" '
            + 'WHERE (("Invoice Date"."Year" =  VALUEOF("CURRENT_BUSINESS_YEAR")) AND ("Sales Territory Assign Rep"."Salesperson Employee Num" IN (:param1)) AND ("FD1 Parent"."Parent FD1 Customer Number" IN (:param2)) AND ("Product"."Level3 ID" = \':param3\')) '
            + 'ORDER BY 10 ASC NULLS LAST, 11 ASC NULLS LAST, 12 ASC NULLS LAST, 13 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST, 3 ASC NULLS LAST, 2 ASC NULLS LAST, 7 ASC NULLS LAST, 6 ASC NULLS LAST, 9 ASC NULLS LAST, 8 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
    
                                                 // Returns the summary report data
                                                 // for an internal user that is
                                                 // displayed on the community homepage 
    public final static String DEALER_VIP_POINTS_SUMMARY_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer" s_4, ' 
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" s_13, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" s_14, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."Sales Tons PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."VIP Points PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19 '
            + 'FROM "Feed Profitability Reporting" '
            + 'WHERE (("AR Parent"."Parent AR Customer Number" IN (:param1)) AND ("Invoice Date"."Fiscal Year" =  VALUEOF("CURRENT_BUSINESS_YEAR"))) '
            + 'ORDER BY 6 ASC NULLS LAST, 5 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
    
                                                 // Shows the list of all accounts
                                                 // that a dealer has access to
                                                 // and the Points & Tons data
                                                 // summarized for each of them
    public final static String DEALER_ACCOUNTS_LIST_REPORT_SQL 
        = 'SELECT 0 s_0, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer" s_4, ' 
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" s_13, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" s_14, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."Sales Tons PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."VIP Points PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19 '
            + 'FROM "Feed Profitability Reporting" '
            + 'WHERE (("AR Parent"."Parent AR Customer Number" IN (:param1)) AND ("Invoice Date"."Fiscal Year" =  VALUEOF("CURRENT_BUSINESS_YEAR"))) '
            + 'ORDER BY 2 ASC NULLS LAST, 6 ASC NULLS LAST, 5 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
    
                                                 // Should return the list of Level 3
                                                 // records for a specific account
                                                 // for a Dealer user
    public final static String DEALER_LEVEL3_LIST_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer" s_4, ' 
            + '"Feed Profitability Reporting"."Product Hierarchy"."Level3 ID" s_5, '
            + '"Feed Profitability Reporting"."Product Hierarchy"."Level3" s_6, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" s_13, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" s_14, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."Sales Tons PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."VIP Points PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19 '
            + 'FROM "Feed Profitability Reporting" '
            + 'WHERE (("FD1 Parent"."Parent FD1 Customer Number" IN (:param2)) AND ("AR Parent"."Parent AR Customer Number" IN (:param1)) AND ("Invoice Date"."Fiscal Year" =  VALUEOF("CURRENT_BUSINESS_YEAR"))) '
            + 'ORDER BY 3 ASC NULLS LAST, 2 ASC NULLS LAST, 6 ASC NULLS LAST, 7 ASC NULLS LAST, 8 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
            // changed param2 to param1 and param1 to param2 // 
                                                 // Should return a list of the producst
                                                 // for a specific Level 3 Product category
                                                 // for Dealer users
    public final static String DEALER_PRODUCT_LIST_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Profitability Reporting"."Basic Product Details"."Product Name" s_7, '
            + '"Feed Profitability Reporting"."Basic Product Details"."Product Number" s_8, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer" s_4, '
            + '"Feed Profitability Reporting"."Product Hierarchy"."Level3 ID" s_5, '
            + '"Feed Profitability Reporting"."Product Hierarchy"."Level3" s_6, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" s_13, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" s_14, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."Sales Tons PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."VIP Points PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19 '
            + 'FROM "Feed Profitability Reporting" '
            + 'WHERE (("FD1 Parent"."Parent FD1 Customer Number" IN (:param2)) AND ("AR Parent"."Parent AR Customer Number" IN (:param1)) AND ("Invoice Date"."Fiscal Year" =  VALUEOF("CURRENT_BUSINESS_YEAR")) AND ("Product Hierarchy"."Level3 ID" = \':param3\')) '
            + 'ORDER BY 3 ASC NULLS LAST, 2 ASC NULLS LAST, 6 ASC NULLS LAST, 7 ASC NULLS LAST, 8 ASC NULLS LAST, 9 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';
             // changed param2 to param1 and param1 to param2 //
             
                                                 // Should return the full VIP Points & Tons
                                                 // report for dealer. Respons is used to
                                                 // generate a CSV file for download by the user
    public final static String DEALER_FULL_REPORT_SQL
        = 'SELECT 0 s_0, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer Number" s_1, '
            + '"Feed Profitability Reporting"."AR Parent"."Parent AR Customer" s_2, '
            + '"Feed Profitability Reporting"."Basic Product Details"."Product Name" s_7, '
            + '"Feed Profitability Reporting"."Basic Product Details"."Product Number" s_8, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer Number" s_3, '
            + '"Feed Profitability Reporting"."FD1 Parent"."Parent FD1 Customer" s_4, '
            + '"Feed Profitability Reporting"."Product Hierarchy"."Level3 ID" s_5, '
            + '"Feed Profitability Reporting"."Product Hierarchy"."Level3" s_6, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" s_13, '
            + '"Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" s_14, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."Sales Tons" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_18, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (Actual)"."VIP Points" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_22, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."Sales Tons PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_16, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYM)"."VIP Points PYM" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_20, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_17, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."Sales Tons PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_15, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =CONCAT(VALUEOF("CURRENT_BUSINESS_YEAR"),\' / 12\'))) s_21, '
            + 'FILTER("Feed Profitability Reporting"."Gross Margin Metrics (PYTD)"."VIP Points PYTD" USING ("Feed Profitability Reporting"."Invoice Date"."Fiscal Period" =VALUEOF("CURRENT_BUSINESS_MONTH"))) s_19 '
            + 'FROM "Feed Profitability Reporting" '
            + 'WHERE (("AR Parent"."Parent AR Customer Number" IN (:param1)) AND ("Invoice Date"."Fiscal Year" =  VALUEOF("CURRENT_BUSINESS_YEAR"))) '
            + 'ORDER BY 3 ASC NULLS LAST, 2 ASC NULLS LAST, 6 ASC NULLS LAST, 7 ASC NULLS LAST, 8 ASC NULLS LAST, 9 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY ';

                                                 // JSON body used to request the 
                                                 // Dealer VIP Points & Tons report as
                                                 // a Base64 encoded string
                                                 // :param1 = AR Account Number
    public final static String DEALER_FULL_REPORT_JSON
        = '{"sql":"SELECT 0 s_0, '
            + '\\"Feed Profitability Reporting\\".\\"AR Parent\\".\\"Parent AR Customer Number\\" s_1, '
            + '\\"Feed Profitability Reporting\\".\\"AR Parent\\".\\"Parent AR Customer\\" s_2, '
            + '\\"Feed Profitability Reporting\\".\\"Basic Product Details\\".\\"Product Name\\" s_7, '
            + '\\"Feed Profitability Reporting\\".\\"Basic Product Details\\".\\"Product Number\\" s_8, '
            + '\\"Feed Profitability Reporting\\".\\"FD1 Parent\\".\\"Parent FD1 Customer Number\\" s_3, '
            + '\\"Feed Profitability Reporting\\".\\"FD1 Parent\\".\\"Parent FD1 Customer\\" s_4, '
            + '\\"Feed Profitability Reporting\\".\\"Product Hierarchy\\".\\"Level3 ID\\" s_5, '
            + '\\"Feed Profitability Reporting\\".\\"Product Hierarchy\\".\\"Level3\\" s_6, '
            + '\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (Actual)\\".\\"Sales Tons\\" s_13, '
            + '\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (Actual)\\".\\"VIP Points\\" s_14, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (Actual)\\".\\"Sales Tons\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_18, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (Actual)\\".\\"VIP Points\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_22, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (PYM)\\".\\"Sales Tons PYM\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_16, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (PYM)\\".\\"VIP Points PYM\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_20, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (PYTD)\\".\\"Sales Tons PYTD\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =CONCAT(VALUEOF(\\"CURRENT_BUSINESS_YEAR\\"),\' / 12\'))) s_17, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (PYTD)\\".\\"Sales Tons PYTD\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_15, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (PYTD)\\".\\"VIP Points PYTD\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =CONCAT(VALUEOF(\\"CURRENT_BUSINESS_YEAR\\"),\' / 12\'))) s_21, '
            + 'FILTER(\\"Feed Profitability Reporting\\".\\"Gross Margin Metrics (PYTD)\\".\\"VIP Points PYTD\\" USING (\\"Feed Profitability Reporting\\".\\"Invoice Date\\".\\"Fiscal Period\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_19 '
            + 'FROM \\"Feed Profitability Reporting\\" '
            + 'WHERE ((\\"AR Parent\\".\\"Parent AR Customer Number\\" IN (:param1)) AND (\\"Invoice Date\\".\\"Fiscal Year\\" =  VALUEOF(\\"CURRENT_BUSINESS_YEAR\\"))) '
            + 'ORDER BY 3 ASC NULLS LAST, 2 ASC NULLS LAST, 6 ASC NULLS LAST, 7 ASC NULLS LAST, 8 ASC NULLS LAST, 9 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY", "fileName":"DealerVIPPointsAndTonsReport_' + DateTime.now().format('dd-MM-YYYY') + '" } ';

                                                 // JSON body to use in the POST to
                                                 // the web service for an internal
                                                 // user to request the full VIP Points
                                                 // & Tons report to be emailed to them
                                                 // :param1 = User.Employe_Number__c
                                                 // :param2 = Email address to send the report to
    public final static String INTERNAL_VIP_TONS_REPORT_REQUEST_JSON
        = '{"sql":"SELECT 0 s_0, '
             + '\\"Feed Sales Compensation\\".\\"AR Parent\\".\\"Parent AR Customer Number\\" s_1, '
             + '\\"Feed Sales Compensation\\".\\"AR Parent\\".\\"Parent AR Customer\\" s_2, '
             + '\\"Feed Sales Compensation\\".\\"FD1 Parent\\".\\"Parent FD1 Customer Number\\" s_3, '
             + '\\"Feed Sales Compensation\\".\\"FD1 Parent\\".\\"Parent FD1 Customer\\" s_4, '
             + '\\"Feed Sales Compensation\\".\\"Product\\".\\"Level3 ID\\" s_5, '
             + '\\"Feed Sales Compensation\\".\\"Product\\".\\"Level3\\" s_6, '
             + '\\"Feed Sales Compensation\\".\\"Product\\".\\"Product Name\\" s_7, '
             + '\\"Feed Sales Compensation\\".\\"Product\\".\\"Product Number\\" s_8, '
             + '\\"Feed Sales Compensation\\".\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" s_9, '
             + '\\"Feed Sales Compensation\\".\\"Sales Territory Assign Rep\\".\\"Sales Territory Desc\\" s_10, '
             + '\\"Feed Sales Compensation\\".\\"Sales Territory Assign Rep\\".\\"Salesperson Employee Num\\" s_11, '
             + '\\"Feed Sales Compensation\\".\\"Sales Territory Assign Rep\\".\\"Salesperson Name\\" s_12, '
             + '\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split Shipped Tons\\" s_13, '
             + '\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split VIP Points\\" s_14, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split Shipped Tons - PYM\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\"  <=VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_15, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split Shipped Tons - PYM\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\"  =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_16, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split Shipped Tons - PYTD\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\" =CONCAT(VALUEOF(\\"CURRENT_BUSINESS_YEAR\\"),\' / 12\'))) s_17, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split Shipped Tons\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_18, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split VIP Points - PYM\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\" <=VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_19, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split VIP Points - PYM\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_20, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split VIP Points - PYTD\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\" =CONCAT(VALUEOF(\\"CURRENT_BUSINESS_YEAR\\"),\' / 12\'))) s_21, '
            + 'FILTER(\\"Feed Sales Compensation\\".\\"Sales Compensation Metrics\\".\\"Split VIP Points\\" USING (\\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Month\\" =VALUEOF(\\"CURRENT_BUSINESS_MONTH\\"))) s_22 '
            + 'FROM \\"Feed Sales Compensation\\" '
            + 'WHERE \\"Feed Sales Compensation\\".\\"Invoice Date\\".\\"Year\\" = VALUEOF(\\"CURRENT_BUSINESS_YEAR\\") '
            + 'AND (\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" >= ANY (SELECT saw_4 FROM (SELECT CASE WHEN RIGHT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\",4) = \'0000\' THEN CONCAT(LEFT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\",LENGTH(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\") - 4), \'%\') ELSE \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\"  END saw_0, \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" saw_1, CONCAT(LEFT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\", LENGTH(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\") - 4),\'0000\') saw_2, \\"Sales Territory Assign Rep\\".\\"Salesperson Employee Num\\" saw_3, \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" saw_4, Case WHEN RIGHT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\",4) = \'0000\' THEN CAST((CAST(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" AS INTEGER) + 10000) AS CHAR) ELSE \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" END saw_5 FROM \\"Feed Sales Compensation\\" WHERE (LENGTH(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\") > 4) AND (\\"Sales Territory Assign Rep\\".\\"Salesperson Employee Num\\" = :param1)) nqw_1 )) AND (\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" <= ALL (SELECT saw_5 FROM (SELECT CASE WHEN RIGHT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\",4) =\'0000\' THEN CONCAT(LEFT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\",LENGTH(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\") - 4), \'%\') ELSE \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\"  END saw_0, \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" saw_1, CONCAT(LEFT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\", LENGTH(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\") - 4),\'0000\') saw_2, \\"Sales Territory Assign Rep\\".\\"Salesperson Employee Num\\" saw_3, \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" saw_4, Case WHEN RIGHT(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\",4) = \'0000\' THEN CAST((CAST(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" AS INTEGER) + 10000) AS CHAR) ELSE \\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\" END saw_5 FROM \\"Feed Sales Compensation\\" WHERE (LENGTH(\\"Sales Territory Assign Rep\\".\\"Sales Territory Code\\") > 4) AND (\\"Sales Territory Assign Rep\\".\\"Salesperson Employee Num\\" = :param1)) nqw_1 )) '
            + 'ORDER BY 10 ASC NULLS LAST, 11 ASC NULLS LAST, 12 ASC NULLS LAST, 13 ASC NULLS LAST, 5 ASC NULLS LAST, 4 ASC NULLS LAST, 3 ASC NULLS LAST, 2 ASC NULLS LAST, 7 ASC NULLS LAST, 6 ASC NULLS LAST, 9 ASC NULLS LAST, 8 ASC NULLS LAST '
            + 'FETCH FIRST 5000001 ROWS ONLY", "to":":param2", "fileName":":param3" }';

    public LPDCR_Constants(){}
}