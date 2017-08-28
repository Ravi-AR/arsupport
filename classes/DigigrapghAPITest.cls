/* *************************************************************************
* Test Class: DigigrapghAPITest TestClass
* dateCreated : 10/1/2015
*
* Purpose/Methods:
* - Code coverage Test class of the DigigrapghAPI class
*
* Unit Test: {DigigrapghAPI} 
*
************************************************************************* */

@isTest
public class DigigrapghAPITest{
    public static testMethod void digigrapghAPITestMethod(){
        DigigrapghAPI objDigigrapghAPI = new DigigrapghAPI();
                
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/DigigrapghAPI';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        RestContext.request = req;
        RestContext.response= res;
        
        Question__c objQuestion = new Question__c();
        objQuestion.Order_Sequence__c = 1;
        objQuestion.Animal_Type__c = 'Dairy';
        objQuestion.Question__c = 'What is the name?';
        insert objQuestion;
                
        Answer__c objAnswer = new Answer__c();
        objAnswer.Question__c = objQuestion.id;
        objAnswer.Answer_Option__c = 'SampleAnswer';
        insert objAnswer;
        
        Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Customer Events').getRecordTypeId();
        Campaign objCampaign = new Campaign();
        objCampaign.Name = 'SampleEvent';
        objCampaign.Specie_Focus__c = 'Horse';
        objCampaign.Type = 'Local';
        objCampaign.Date_of_Event__c = Date.today();
        objCampaign.Event_Zip__c = '36201';
        insert objCampaign;
        
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Direct Producer Account').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.Name = 'sampleName';
        insert objAccount;
        
        Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        Contact objContact = new Contact();
        objContact.Account = objAccount;
        objContact.LastName = 'sampleName';
        objContact.Email = 'sample@sampletest.com';
        objContact.Phone = '1245124512';
        objContact.Contact_Type__c = 'Producer Contact';
        //insert objContact;
        
        List<Contact> lstContact = new List<Contact>();
        lstContact.add(objContact);
        insert lstContact;
        
        Lead objLead = new Lead();
        objLead.LastName = 'sampleName';
        objLead.Company = 'sampleCompany';
        objLead.Email = 'sample@sampletest.com';
        objLead.Phone = '1245124512';
        objLead.Status = 'Qualified';
        
        List<Lead> lstLead = new List<Lead>();
        lstLead.add(objLead);
        insert lstLead;
        
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DigigrapghAPI.pingUser();
        DigigrapghAPI.CreateEvent(objCampaign.id, objCampaign.Event_Zip__c, 'sampleName', objQuestion.Animal_Type__c, true, Date.today(), Date.today(), 'Payload Test');
        DigigrapghAPI.EditEvent(objCampaign.id, objCampaign.Event_Zip__c, 'sampleName', objQuestion.Animal_Type__c, true, false, Date.today(), Date.today(), 'Payload Test 2');
        DigigrapghAPI.DeleteEvent(objCampaign.id);
        DigigrapghAPI.FindEvent(objCampaign.Event_Zip__c);
        DigigrapghAPI.Question(objQuestion.id, 'sampleBody', '1', objQuestion.Animal_Type__c, 'Sample Answers', true);
        DigigrapghAPI.EditQuestion(objQuestion.id, 'sampleBody', '1', objQuestion.Animal_Type__c, 'Sample Answers', true,false);
        DigigrapghAPI.EditQuestion(objQuestion.id, 'sampleBody', '1', objQuestion.Animal_Type__c, 'Sample Answers', true,true);
        DigigrapghAPI.DeleteQuestion(objQuestion.id);
        DigigrapghAPI.UploadSurvey(myBlob);
        DigigrapghAPI.RandomQuestions(objCampaign.id, userinfo.getuserid());
        DigigrapghAPI.SaveAnswers(objCampaign.id, userinfo.getuserid(), 'Sample Answers');
    }
}