/******************************************************************************
 * Test class for LPDCR_CC_HomePageController 
 * 
 * @Author: Heena Tanna
 * @Date: 27-04-2017 
 * @Jira: LPDCR-1989
 */


@isTest( SeeAllData=false )
public without sharing class LPDCR_CC_HomePageControllerTest{
    
    static testMethod void checkPermissionSetAssigmentTest(){
        System.debug( 'START: LPDCR_CC_HomePageControllerTest.checkPermissionSetAssigmentTest()' );
        
        Test.startTest();
        
        LPDCR_CC_HomePageController controller = new LPDCR_CC_HomePageController();
        controller.checkPermissionSetAssigment();
        
        System.assert( controller.bbmBGColor != null );
        System.assert( controller.ooBGColor != null );
        System.assert( controller.bbBGColor != null );
        System.assert( controller.piBGColor != null );
        System.assert( controller.mmBGColor != null );
        System.assert( controller.epBGColor != null );
        System.assert( controller.ttBGColor != null );
        System.assert( controller.carouselBGColor != null );
        
        User l_user = LPDCR_TestUtil.getCommunityUser();        
        System.runAs( l_user )
        {	Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', 
            Member_Type_catcode1__c = '010-Cooperative', 
            ParentId = null,
            Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),
            ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',
            AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer',AccountNumber='12345');
            insert ac;
         
            PageReference pageRef = Page.LPDCR_DealerVIPPointsTonsReportDetail;
            System.Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('selectedAccountId',ac.id);
         
            PermissionSet ps = [SELECT ID From PermissionSet WHERE Name =: 'Business_Builder_External_Users'];
            insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps.Id );
            controller = new LPDCR_CC_HomePageController();
        	controller.checkPermissionSetAssigment();
         	PermissionSet ps2 = [SELECT ID From PermissionSet WHERE Name =: 'Business_Management_External_Users'];
         	insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps2.Id );
            controller.checkPermissionSetAssigment();
            PermissionSet ps3 = [SELECT ID From PermissionSet WHERE Name =: 'Events_and_Planning_External_Users'];
         	insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps3.Id );
            controller.checkPermissionSetAssigment();
            PermissionSet ps4 = [SELECT ID From PermissionSet WHERE Name =: 'Marketing_External_Users'];
         	insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps4.Id );
            controller.checkPermissionSetAssigment();
            PermissionSet ps5 = [SELECT ID From PermissionSet WHERE Name =: 'Online_Order_External_Users'];
         	insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps5.Id );
            controller.checkPermissionSetAssigment();
            PermissionSet ps6 = [SELECT ID From PermissionSet WHERE Name =: 'Product_Information_External_Users'];
         	insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps6.Id );
            controller.checkPermissionSetAssigment();
            PermissionSet ps7 = [SELECT ID From PermissionSet WHERE Name =: 'Training_External_Users'];
         	insert new PermissionSetAssignment(AssigneeId = l_user.id, PermissionSetId = ps7.Id );
            controller.checkPermissionSetAssigment();
           
           
         
        }
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_HomePageControllerTest.checkPermissionSetAssigmentTest()' );
        
    }


}