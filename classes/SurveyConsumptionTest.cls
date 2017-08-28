/* *************************************************************************
* Test Class: SurveyConsumptionTest TestClass
* dateCreated : 10/1/2015
*
* Purpose/Methods:
* - Code coverage Test class of the SurveyConsumption class
*
* Unit Test: {SurveyConsumption} 
*
************************************************************************* */

@isTest
public class SurveyConsumptionTest{
    public static testMethod void surveyConsumptionTestMethod(){
        SurveyConsumption objSurveyConsumption = new SurveyConsumption();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/surveyconsumption';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
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
        objContact.Contact_Type__c = 'Producer Contact';
        insert objContact;
        
        String strQuestionId = objQuestion.id, strAnwerId = objAnswer.id;
        
        List<SurveyConsumption.wrapQuestionAnswers> lstwrapQuestionAnswers = new List<SurveyConsumption.wrapQuestionAnswers>();
        SurveyConsumption.wrapQuestionAnswers objWrap = new SurveyConsumption.wrapQuestionAnswers();
        objWrap.questionID = strQuestionId;
        objWrap.answerid = strAnwerId; 
        lstwrapQuestionAnswers.add(objWrap);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        SurveyConsumption.CreateSurveyConsumption(objContact.id, objCampaign.id, lstwrapQuestionAnswers);
    }
    
    public static testMethod void surveyConsumptionTestMethod1(){
        SurveyConsumption objSurveyConsumption = new SurveyConsumption();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/surveyconsumption';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
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
        objContact.Contact_Type__c = 'Producer Contact';
        //insert objContact;
        
        String strQuestionId = objQuestion.id, strAnwerId = objAnswer.id;
        
        List<SurveyConsumption.wrapQuestionAnswers> lstwrapQuestionAnswers = new List<SurveyConsumption.wrapQuestionAnswers>();
        SurveyConsumption.wrapQuestionAnswers objWrap = new SurveyConsumption.wrapQuestionAnswers();
        objWrap.questionID = strQuestionId;
        objWrap.answerid = strAnwerId; 
        lstwrapQuestionAnswers.add(objWrap);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        SurveyConsumption.CreateSurveyConsumption(objContact.id, objCampaign.id, lstwrapQuestionAnswers);
    }
}