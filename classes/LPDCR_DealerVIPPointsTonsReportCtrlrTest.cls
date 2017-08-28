/******************************************************************************
 * Test class for LPDCR_DealerVIPPointsTonsReportCntrlr.cls
 *
 *
 * @Author: Heena Tanna
 * @Date: July 7, 2017
 * @Jira: LPDCR-2029
 */
 @isTest(SeeAllData=false)
private class LPDCR_DealerVIPPointsTonsReportCtrlrTest {
        
 /******************************************************************************
 * Method to test the class constructor
 */
    static testMethod 
    void 
    test_Constructor() 
    {
        System.debug( 'START: LPDCR_DealerVIPPointsTonsReportCtrlrTest .test_Constructor()' );
        
        Test.startTest();
        
        
        
        
        Test.stopTest();

        System.debug( 'END: LPDCR_DealerVIPPointsTonsReportCtrlrTest .test_Constructor()' );
    }

    static testMethod void test_dealerAccountReport()
    {   

        User pu = LPDCR_TestUtil.getCommunityUser();
        
        System.RunAs(pu){
        Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', 
        Member_Type_catcode1__c = '010-Cooperative', 
        ParentId = null,
        Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),
        ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',
        AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer',AccountNumber='12345');
        insert ac;
        LPDCR_DealerVIPPointsTonsReportCntrlr l_controller = new LPDCR_DealerVIPPointsTonsReportCntrlr();
        PageReference pageRef = Page.LPDCR_DealerVIPPointsTonsReportDetail;
        System.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('selectedAccountId',ac.id);
        
        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller.active_account_id ='302067';
        l_controller.getAccountDetails();
        l_controller.getDealerAccountList();
        l_controller.fd1_customer_id='302067';
        l_controller.getDealerLevel3List();
        l_controller.level3_id='271';
        l_controller.getDealerProductList();
        
        }
        Test.stopTest();
    
    }
    static testMethod void test_activeAccount(){
        
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
        Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', 
        Member_Type_catcode1__c = '010-Cooperative', 
        ParentId = null,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),
        ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',
        AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer',AccountNumber='12345');
        insert ac;
        LPDCR_DealerVIPPointsTonsReportCntrlr l_controller = new LPDCR_DealerVIPPointsTonsReportCntrlr();
        PageReference pageRef1 = Page.LPDCR_DealerVIPPointsTonsReportDetail;
        System.Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('dlrAccountId',ac.id);
        
        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller.getAccountDetails();
        l_controller.getDealerAccountList();
        l_controller.getDealerLevel3List();
        l_controller.getDealerProductList();
       }
         Test.stopTest();
    }
    
}