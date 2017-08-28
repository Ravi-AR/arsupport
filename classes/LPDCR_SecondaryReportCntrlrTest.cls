/**
*   @Author:    Shruti Mishra
*   @Date:      01.06.2017
*   @Jira:      LPDCR-
*   @Purpose:   Test class for LPDCR_SecondaryReportController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryReportCntrlrTest {

/******************************************************************************
 * Setup any data and custom settings needed for the test class
 */    
    @testSetup
    public static 
    void 
    testSetup()
    {
        LPDCR_TestUtil.setCustomSettings();
    }
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryReportCntrlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryReportController controller = new LPDCR_SecondaryReportController();
        controller.showDocumentList();
        controller.hideDocumentList();
        controller.showPointsDetailReport();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryReportCntrlrTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getAccountPointsSummary()
 */
    static testMethod void test_getAccountPointsSummary() 
    {
        System.debug( 'START: LPDCR_SecondaryReportCntrlrTest.test_getAccountPointsSummary()' );
        LPDCR_SecondaryReportController controller;
        Test.startTest();        
        controller = new LPDCR_SecondaryReportController();        
        controller.getAccountPointsSummary();        
        System.assert( controller != null );
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
            controller = new LPDCR_SecondaryReportController();
            controller.getAccountPointsSummary();            
        }
        Test.stopTest();
        System.debug( 'END: LPDCR_SecondaryReportCntrlrTest.test_getAccountPointsSummary()' );
    }
    
/*******************************************************************************
 * Method to test getWaffleResourceList()
 */
    static testMethod void test_getWaffleResourceList() 
    {
        System.debug( 'START: LPDCR_SecondaryReportCntrlrTest.test_getWaffleResourceList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryReportController controller = new LPDCR_SecondaryReportController();
        controller.search_term = 'Sales';
        //controller.sort_filter = 'Name DESC';
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> docs = controller.documentList;
        Boolean init = controller.init;
        Account accObj = LPDCR_TestUtil.getAccountRecord();
        controller.selectedAccountId = accObj.Id;
        ccrz__E_Seller__c plantObj = new ccrz__E_Seller__c(Name= 'Montgomery City Feed Mill', ccrz__SellerId__c='FCVB');
        insert plantObj;
        CC_OO_Customer_Freight__c customerFreightObj = new CC_OO_Customer_Freight__c(Product_Type__c = 'BAG',Plant_Name__c=plantObj.Id, ShipTo_Account_Number__c=Decimal.ValueOf(accObj.AccountNumber));
        insert customerFreightObj;
        controller.document_type = Label.LPDCR_MSRP_Component_Name;
        controller.retrieveDocuments();
        accObj.ShippingState = 'Arizona';
        update accObj;
        controller.document_type = Label.LPDCR_MSRP_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Tons_and_VIP_Points_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Price_Lists_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Performance_Profile_Component_Name;
        controller.retrieveDocuments();
        System.assert( controller != null );
        
        
        CHC_Summary__c chcObj = new CHC_Summary__c (Average_Per_Month__c=5000, Current_Growth__c=1000, Points_for_Bronze__c=2000, Points_for_Gold__c=6000, Points_for_Silver__c=5000, Total_Base_Points__c=10000, 
                          Total_Performance_Points__c=4000, Trip_Win_Level__c='Gold',Parent_FD_1_Account__c=accObj.Id);
        insert chcObj;
        controller.getCHCDetails();
        chcObj.Total_Performance_Points__c=1000;
        update chcObj;
        controller.getCHCDetails();
        chcObj.Total_Performance_Points__c=5500;
        update chcObj;
        controller.getCHCDetails();
        chcObj.Total_Performance_Points__c=6500;
        update chcObj;
        controller.getCHCDetails();
        chcObj.Total_Performance_Points__c=0;
        update chcObj;
        controller.getCHCDetails();
        System.debug( 'END: LPDCR_SecondaryReportCntrlrTest.test_getWaffleResourceList()' );
    }

    
}// /END Test Class