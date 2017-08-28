@isTest
private class LMSA_ProgramEvaluationControllerTest 
{
    public static testMethod void programEvl()
    {
        // Create Account
        Account ac = new Account( Name = 'Test') ;
        insert ac ;

        // Create Contacts 
        Contact contact = new Contact( FirstName = ' Test ', LastName = 'test ', AccountId = ac.Id, Email='test@test.com' ) ;
        insert contact ; 

        // Create tip
        Program_Evaluation__c prgrm = new Program_Evaluation__c( Producer_Facility__c = ac.Id ) ;
        Program_Evaluation__c prgrm1 = new Program_Evaluation__c( ) ; // not insert
        insert prgrm ;
        
        // Create attachment for first Tip
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment'); 
        Attachment attach = new Attachment( ParentId = prgrm.Id, Body = bodyBlob, Description = 'test' , Name ='test') ;
        insert attach ;

        // Set Current page
        Test.setCurrentPageReference(Page.LMSA_ProgramEvaluation);         
        PageReference pr ;

        // these line just for coverage of exceptions
        LMSA_ProgramEvaluationController cont =new LMSA_ProgramEvaluationController(new ApexPages.StandardController(prgrm1)); 
        pr = cont.saveRecord();
        cont.cloneRecord(); 

        // Call method with Inserted ProgramEvaluation
        cont =new LMSA_ProgramEvaluationController(new ApexPages.StandardController(prgrm)); 
        pr = cont.saveRecord() ;
        cont.sendEmail() ;

        cont.progEvaluation.Contact__c = contact.Id ;           
        // Get Tempalte ID
        Id templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Program_Evaluation_Email_Templates' LIMIT 1 ].Id ;
        // Insert setting with UserID (for exception message on controller)
        Org_Settings__c setting = new Org_Settings__c( Name='Test', Program_Evaluation_Email_Template_Id__c = UserInfo.getUserId() );
        insert setting ; 
        cont.sendEmail() ; 

        // Update now with tempale ID
        setting.Program_Evaluation_Email_Template_Id__c = templateId ; 
        update setting ;

        cont.sendEmail() ;
        cont.cancel();
        
        cont.cloneRecord(); 
    }
}