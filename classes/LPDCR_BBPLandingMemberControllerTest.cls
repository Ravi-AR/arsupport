/**
*   @Author:    Heena Tanna
*   @Date:      15.11.2016
*   @Jira:      LPDCR-852
*   @Purpose:   Test class for  LPDCR_BBPLandingMemberController
**/

@isTest(SeeAllData=false)
public class LPDCR_BBPLandingMemberControllerTest{
   
   static testMethod void testBBMembers() 
   {
        
        User pu = LPDCR_TestUtil.getCommunityUser();
        
        System.RunAs(pu)
        {
            
            Account up = new Account( Name = 'Ultimate Parent ');
            insert up;
            //RecordType acRecType = [Select Id From RecordType  Where SobjectType = 'Account' and DeveloperName = 'Dealer_Coop_Account'];           
            Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = null,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
            insert ac;
            BusinessBuilderProgramYear__c businessyear1 = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),EnrollmentStartDate__c = System.Today(), EnrollmentEndDate__c = System.Today().addDays(20),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear1;
            BusinessBuilderProgramYear__c businessyear2 = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),EnrollmentStartDate__c = System.Today(), EnrollmentEndDate__c = System.Today().addDays(20),StartDate__c = System.Today().addDays(1),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear2; 
            RecordType ssRecType = [Select Id From RecordType  Where SobjectType = 'SellingSupportProgramYear__c' and DeveloperName = 'Standard'];           
            SellingSupportProgramYear__c expenseyear1 = new SellingSupportProgramYear__c(Account__c= ac.Id,recordtypeid = ssRecType.id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),BusinessBuilderProgramYear__c = businessyear1.Id,Program_Year_Allocation__c = 1000000,BusinessBuilderProgramStatus__c = 'Enrolled');
            insert expenseyear1;           
            Document docObj = new Document(FolderId = [select id from folder where name = 'BB Documents'].id,DeveloperName='Navigator_Document_9999',Name ='Navigator Document 2016');
            insert docObj;            
            RecordType RecType = [Select Id From RecordType  Where SobjectType = 'CustomerEventMetadata__c' and DeveloperName = 'Business_Builder_Program_Year_Metadata'];
            CustomerEventMetadata__c custEventObj = new CustomerEventMetadata__c(Business_Builder_Program_Year__c=businessyear1.Id,
                          Document_Name__c='Navigator Document 2016', DocumentDeveloperName__c='Navigator_Document_9999', DocumentFolderDeveloperName__c='BB_Documents',
                          MetadataType__c='Carousel Desktop', Description__c='Test',Display_Order_for_Type__c = 1, Display_Start_Date__c = System.Today(), Display_End_Date__c = System.Today().addDays(20));
            insert custEventObj;
            
            PageReference pageRef = Page.LPDCR_BBPLandingMember;
            System.Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('selectedAccountId',ac.Id);
            Test.startTest();
            LPDCR_BBPLandingMemberController controller = new LPDCR_BBPLandingMemberController();
            
            //Scenario 1; Eligible,Enrolled,ProgramAllocation>0
            Boolean init = controller.init;
            List<SellingSupportProgramYear__c> sspyLst = controller.activeSSProgramYrs;
            
            //Scenario 2; Eligible,Enrolled,ProgramAllocation=0
            expenseyear1.Program_Year_Allocation__c = 0;
            update expenseyear1;
            controller.initialize();
            controller.selectedProgYearId = businessyear2.Id;
            controller.createSSPYRecord();
            
            //Scenario 3; Eligible,Enrolled,ProgramAllocation=0, End Date before today
            businessyear1.EndDate__c = System.Today()-2;
            update businessyear1;
            controller.initialize();
            
            //Scenario 4; Ineligible,Enrolled,ProgramAllocation=0
            businessyear1.EndDate__c = System.Today().addDays(20);
            update businessyear1;
            ac.BusinessBuilderProgramStatus__c = 'Ineligible';
            ac.Business_Builder_Program_Tier__c = null;
            update ac;
            controller.initialize();
            
            //Scenario 5; Eligible,Enrolled,ProgramAllocation=null
            ac.BusinessBuilderProgramStatus__c = 'Eligible';
            //ac.Business_Builder_Program_Tier__c = 'Program Dealer';
           
            update ac;
            expenseyear1.BusinessBuilderProgramStatus__c = 'Enrolled';
            expenseyear1.Program_Year_Allocation__c = null;
            update expenseyear1;
            controller.initialize();
            
            delete sspyLst;
            controller.initialize();
            
            System.assertEquals(ApexPages.currentPage().getParameters().get('selectedAccountId')!=null,true);
            
            ApexPages.currentPage().getParameters().put('selectedAccountId',null);
            controller.initialize();
            Test.stopTest();
        }       
   }
   
   static testMethod void testNotEnrolledBB() 
   {
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu)
        {
            
            Account up = new Account( Name = 'Ultimate Parent ');
            insert up;
            Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = null,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
            insert ac;            
            BusinessBuilderProgramYear__c businessyear1 = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),EnrollmentStartDate__c = System.Today(), EnrollmentEndDate__c = System.Today().addDays(20),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear1;
            RecordType ssRecType = [Select Id From RecordType  Where SobjectType = 'SellingSupportProgramYear__c' and DeveloperName = 'Standard'];
            SellingSupportProgramYear__c expenseyear1 = new SellingSupportProgramYear__c(Account__c= ac.Id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),recordtypeid = ssRecType.id,BusinessBuilderProgramYear__c = businessyear1.Id,Program_Year_Allocation__c = 10000,BusinessBuilderProgramStatus__c = 'Not Enrolled');
            insert expenseyear1;            
            Document docObj = new Document(FolderId = [select id from folder where name = 'BB Documents'].id,DeveloperName='Navigator_Document_9999',Name ='Navigator Document 2016');
            insert docObj;  
            
            RecordType RecType = [Select Id From RecordType  Where SobjectType = 'CustomerEventMetadata__c' and DeveloperName = 'Business_Builder_Program_Year_Metadata'];
            CustomerEventMetadata__c custEventObj = new CustomerEventMetadata__c(Business_Builder_Program_Year__c=businessyear1.Id,
                          Document_Name__c='Navigator Document 2016', DocumentDeveloperName__c='Navigator_Document_9999', DocumentFolderDeveloperName__c='BB_Documents',
                          MetadataType__c='Carousel Desktop', Description__c='Test',Display_Order_for_Type__c = 1, Display_Start_Date__c = System.Today(), Display_End_Date__c = System.Today().addDays(20));
            insert custEventObj;
            
            PageReference pageRef = Page.LPDCR_BBPLandingMember;
            System.Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('selectedAccountId',ac.Id);
            Test.startTest();
            LPDCR_BBPLandingMemberController controller = new LPDCR_BBPLandingMemberController();
            controller.initialize();
            System.assertEquals(ApexPages.currentPage().getParameters().get('selectedAccountId')!=null,true);
            Test.stopTest();
        }        
   }
   static testMethod void testNotEnrolledZeroBlncBB() 
   {
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu)
        {
            
            Account up = new Account( Name = 'Ultimate Parent ');
            insert up;
            Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = null,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
            insert ac;            
            BusinessBuilderProgramYear__c businessyear1 = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),EnrollmentStartDate__c = System.Today(), EnrollmentEndDate__c = System.Today().addDays(20),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear1;
            RecordType ssRecType = [Select Id From RecordType  Where SobjectType = 'SellingSupportProgramYear__c' and DeveloperName = 'Standard'];
            SellingSupportProgramYear__c expenseyear1 = new SellingSupportProgramYear__c(Account__c= ac.Id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),recordtypeid = ssRecType.id,BusinessBuilderProgramYear__c = businessyear1.Id,Program_Year_Allocation__c = 0,BusinessBuilderProgramStatus__c = 'Not Enrolled');
            insert expenseyear1;            
            Document docObj = new Document(FolderId = [select id from folder where name = 'BB Documents'].id,DeveloperName='Navigator_Document_9999',Name ='Navigator Document 2016');
            insert docObj;  
            
            RecordType RecType = [Select Id From RecordType  Where SobjectType = 'CustomerEventMetadata__c' and DeveloperName = 'Business_Builder_Program_Year_Metadata'];
            CustomerEventMetadata__c custEventObj = new CustomerEventMetadata__c(Business_Builder_Program_Year__c=businessyear1.Id,
                          Document_Name__c='Navigator Document 2016', DocumentDeveloperName__c='Navigator_Document_9999', DocumentFolderDeveloperName__c='BB_Documents',
                          MetadataType__c='Carousel Desktop', Description__c='Test',Display_Order_for_Type__c = 1, Display_Start_Date__c = System.Today(), Display_End_Date__c = System.Today().addDays(20));
            insert custEventObj;
            
            PageReference pageRef = Page.LPDCR_BBPLandingMember;
            System.Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('selectedAccountId',ac.Id);
            Test.startTest();
            LPDCR_BBPLandingMemberController controller = new LPDCR_BBPLandingMemberController();
            controller.initialize();
            System.assertEquals(ApexPages.currentPage().getParameters().get('selectedAccountId')!=null,true);
            Test.stopTest();
        }        
   }
   
   static testMethod void testFutureBBMembers() 
   {
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu)
        {
            Account up = new Account( Name = 'Ultimate Parent ');
            insert up;
            Account ac = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = null,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
            insert ac;            
            BusinessBuilderProgramYear__c businessyear1 = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),EnrollmentStartDate__c = System.Today(), EnrollmentEndDate__c = System.Today().addDays(20),StartDate__c = System.Today().addDays(1),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear1;
            RecordType ssRecType = [Select Id From RecordType  Where SobjectType = 'SellingSupportProgramYear__c' and DeveloperName = 'Standard'];
            SellingSupportProgramYear__c expenseyear1 = new SellingSupportProgramYear__c(Account__c= ac.Id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),recordtypeid = ssRecType.id,BusinessBuilderProgramYear__c = businessyear1.Id,Program_Year_Allocation__c = 10000,BusinessBuilderProgramStatus__c = 'Enrolled');
            insert expenseyear1;            
            Document docObj = new Document(FolderId = [select id from folder where name = 'BB Documents'].id,DeveloperName='Navigator_Document_9999',Name ='Navigator Document 2016');
            insert docObj;  
             
            RecordType RecType = [Select Id From RecordType  Where SobjectType = 'CustomerEventMetadata__c' and DeveloperName = 'Business_Builder_Program_Year_Metadata'];
            CustomerEventMetadata__c custEventObj = new CustomerEventMetadata__c(Business_Builder_Program_Year__c=businessyear1.Id,
                          Document_Name__c='Navigator Document 2016', DocumentDeveloperName__c='Navigator_Document_9999', DocumentFolderDeveloperName__c='BB_Documents',
                          MetadataType__c='Carousel Desktop', Description__c='Test',Display_Order_for_Type__c = 1, Display_Start_Date__c = System.Today(), Display_End_Date__c = System.Today().addDays(20));
            insert custEventObj;
            
            PageReference pageRef = Page.LPDCR_BBPLandingMember;
            System.Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('selectedAccountId',ac.Id);
            Test.startTest(); 
            LPDCR_BBPLandingMemberController controller = new LPDCR_BBPLandingMemberController();
            controller.initialize();
            System.assertEquals(ApexPages.currentPage().getParameters().get('selectedAccountId')!=null,true);
            Test.stopTest();
        }        
   }
   
}