/**
*   @Author:    Heena Tanna
*   @Date:      21.12.2016
*   @Jira:      LPDCR-852
*   @Purpose:   Test class for LPDCR_BBEnrollmentController
*
*/

@isTest
public class LPDCR_BBEnrollmentControllerTest
{
    static testMethod void testgetAccountDetail() 
    {
        
       User pu = LPDCR_TestUtil.getCommunityUser();
         System.RunAs(pu){
          Account ac = LPDCR_TestUtil.getAccountRecord(); 
          BusinessBuilderProgramYear__c bbpy = LPDCR_TestUtil.getBBProgramYear();
          SellingSupportProgramYear__c sspy = LPDCR_TestUtil.getSSProgramYear();    
          test.setCurrentPage(page.LPDCR_BBEnrollment);
          ApexPages.currentPage().getParameters().put('Accountid',ac.Id);   
          ApexPages.currentPage().getParameters().put('BBYearId',bbpy.Id); 
          Document docObj = new Document(FolderId = [select id from folder where name = 'BB Documents'].id,DeveloperName='Navigator_Document_9999',Name ='Navigator Document 2016');
          insert docObj;            
          RecordType RecType = [Select Id From RecordType  Where SobjectType = 'CustomerEventMetadata__c' and DeveloperName = 'Business_Builder_Program_Year_Metadata'];
          CustomerEventMetadata__c custEventObj = new CustomerEventMetadata__c(Business_Builder_Program_Year__c=bbpy.Id,
                                                                                  Document_Name__c='Navigator Document 2016', DocumentDeveloperName__c='Navigator_Document_9999', DocumentFolderDeveloperName__c='BB_Documents',
                                                                                  MetadataType__c='Carousel Desktop', Description__c='Test',Display_Order_for_Type__c = 1, Display_Start_Date__c = System.Today(), Display_End_Date__c = System.Today().addDays(20));
          insert custEventObj;
          LPDCR_BBEnrollmentController controller = new LPDCR_BBEnrollmentController();
          controller.getAccountdetails();
          controller.updateSSProgYear();   
         
         }
        
    }
    static testmethod void testNotEnrolled(){
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
            Account up = new Account( Name = 'Ultimate Parent ');
            insert up;
            Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = up.Id,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
            insert ac;            
            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),EnrollmentStartDate__c = System.Today(), EnrollmentEndDate__c = System.Today().addDays(20),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear;
            ApexPages.currentPage().getParameters().put('Accountid',ac.Id);   
            ApexPages.currentPage().getParameters().put('BBYearId',businessyear.Id);
            Document docObj = new Document(FolderId = [select id from folder where name = 'BB Documents'].id,DeveloperName='Navigator_Document_9999',Name ='Navigator Document 2016');
            insert docObj;            
            RecordType RecType = [Select Id From RecordType  Where SobjectType = 'CustomerEventMetadata__c' and DeveloperName = 'Business_Builder_Program_Year_Metadata'];
            CustomerEventMetadata__c custEventObj = new CustomerEventMetadata__c(Business_Builder_Program_Year__c=businessyear.Id,
                                                                                      Document_Name__c='Navigator Document 2016', DocumentDeveloperName__c='Navigator_Document_9999', DocumentFolderDeveloperName__c='BB_Documents',
                                                                                      MetadataType__c='Carousel Desktop', Description__c='Test',Display_Order_for_Type__c = 1, Display_Start_Date__c = System.Today(), Display_End_Date__c = System.Today().addDays(20));
            insert custEventObj;
            RecordType ssRecType = [Select Id From RecordType  Where SobjectType = 'SellingSupportProgramYear__c' and DeveloperName = 'Standard'];
            SellingSupportProgramYear__c expenseyear = new SellingSupportProgramYear__c(Account__c= ac.Id,recordtypeid = ssRecType.id,
            Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 10000,TermsandConditionsAccepted__c = true);
            insert expenseyear; 
            List<SellingSupportProgramYear__c> updated = [Select Id,Name,TermsandConditionsAccepted__c,BusinessBuilderProgramStatus__c from SellingSupportProgramYear__c WHERE ID=:expenseyear.id];
            updated[0].TermsandConditionsAccepted__c = true;
            updated[0].BusinessBuilderProgramStatus__c = 'Enrolled';
            update updated;
            LPDCR_BBEnrollmentController controller = new LPDCR_BBEnrollmentController();
            //controller.getAccountdetails();
            controller.updateSSProgYear();
            
        }
    }
}