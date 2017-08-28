@isTest
public class CreateCaseControllerTest {
    public static testMethod void testCaseCreation(){
        Account a = new Account(Name = 'AA Test Account');
        Insert a;
        
         ApexPages.currentPage().getParameters().put('id', a.Id);
        
        CreateCaseController cntrl = new CreateCaseController();
        
        cntrl.attachments[0].Name = 'AA Test Doc'; 
        cntrl.attachments[0].Body = Blob.valueOf('Test Attachement');
         
        cntrl.getFields();
        cntrl.isS1();

        cntrl.newCase.Subject = 'Test Case';
        cntrl.newCase.Item_Number__c = '21312';
        PageReference pr = cntrl.SubmitCase();
        System.assertNotEquals(null, pr);
        
        //For salesforce1
        ApexPages.currentPage().getParameters().put('id', '005');
        ApexPages.currentPage().getParameters().put('sfdcIFrameHost', '1');
        ApexPages.currentPage().getParameters().put('sfdcIFrameOrigin', '1');
        ApexPages.currentPage().getParameters().put('isdtp', 'p1');
        ApexPages.currentPage().getParameters().put('projectone', '1');
        
        CreateCaseController cntrl2 = new CreateCaseController();
        cntrl2.isS1();
        cntrl2.SubmitCase();
        
        //Setting up any id to null
        ApexPages.currentPage().getParameters().remove('id');
        ApexPages.currentPage().getParameters().remove('sfdcIFrameHost');
        
        CreateCaseController cntrl3 = new CreateCaseController();
        cntrl3.isS1();
        cntrl3.SubmitCase();
        
    }
}