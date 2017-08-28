@isTest
private class LMSA_ManagementTipsControllerTest 
{
	public static testMethod void testTip()
	{

		// Create Account
        Account ac = new Account( Name = 'Test') ;
        insert ac ;

        // Create Contacts 
        Contact contact = new Contact( FirstName = ' Test ', LastName = 'test ', AccountId = ac.Id, Email='test@test.com' ) ;
        insert contact ; 

		// Get RecordType for Tip__c
    	RecordType recType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Tip__c' AND DeveloperName = 'Management' ] ; 

    	// Create tip
    	Tip__c tip = new Tip__c( 	Name = 'test', Facility_Question__c = 'Facility', Facility_Answer__c = 'test ans', 
    								Tip__c = 'good', RecordTypeId = recType.Id ) ;
        
        // Create 2nd tip
        Tip__c tip1 = new Tip__c(    Name = 'test', Facility_Question__c = 'Air', Facility_Answer__c = 'ans', 
                                    Tip__c = 'good', RecordTypeId = recType.Id ) ;
        insert new List<Tip__c>{tip, tip1} ;

        // Create attachment for first Tip
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment'); 
        Attachment attach = new Attachment( ParentId = tip.Id, Body = bodyBlob, Description = 'test' , Name ='test') ;
        insert attach ;

		// Set Current page
        Test.setCurrentPageReference(Page.LMSA_ManagementTips);         

        // Call Controller methods 
       	LMSA_ManagementTipsController cont =new LMSA_ManagementTipsController(new ApexPages.StandardController(tip)); 
       	cont.selectedTips = String.valueOf( tip.Id ) + ',' + String.valueOf( tip1.Id ) ;
       	cont.addSelectedTips();
       	cont.sendAttachmentEmail() ;
       	cont.contactRecord.Contact__c = contact.Id; 

        EmailTemplate et = new EmailTemplate();
        et.Body = 'this is tmplate';
        et.Name = 'Facility Checklist Email';
        et.DeveloperName = 'Test_test_test';
        et.TemplateType = 'Text';
        et.IsActive = true;
        et.FolderId = [SELECT Id, Name, DeveloperName FROM Folder where Type = 'Email' limit 1].Id;
        
        System.runAs( new User( ID = UserInfo.getUserId() )){
        	insert et;    
        }
        
        
       	// Get Tempalte ID
 		//Id templateId = [SELECT Id FROM EmailTemplate WHERE Name ='Facility Checklist Email' LIMIT 1 ].Id ;
		Id templateId = et.Id;
        
       	// Insert setting with UserID (for exception message on controller)
		Org_Settings__c setting = new Org_Settings__c( Name='Test', Management_Tip_Email_Template_Id__c = UserInfo.getUserId() );
		insert setting ; 
 		cont.sendAttachmentEmail() ;

 		// Update now with tempale ID
 		setting.Management_Tip_Email_Template_Id__c = templateId ;
 		update setting ;

 		cont.sendAttachmentEmail() ;
        
	}
    
}