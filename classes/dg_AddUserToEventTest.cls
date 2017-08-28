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
public class dg_AddUserToEventTest{
    public static testMethod void dg_AddUserToEventTestMethod()
    {
        
        
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
        
        Lead objLead = new Lead();
        objLead.LastName = 'sampleName';
        objLead.Company = 'sampleCompany';
        objLead.Email = 'sample@sampletest.com';
        objLead.Phone = '1245124512';
        objLead.Status = 'Qualified';
        
        insert objLead;
        
        String contactID = objContact.Id;
        String leadID = objLead.Id;
        string eventID = objCampaign.Id;
        
        string invalidID = '000000000000000000';
        
        Test.startTest();
        
        TestRest( contactID, eventID );
        TestRest( contactID, invalidID );
        TestRest( leadID, eventID );
        TestRest( leadID, invalidID );
        TestRest( invalidID, eventID );
        TestRest( invalidID, invalidID );
        
        Test.stopTest();
        
    }
    
    public static void TestRest( string strLeadID, string strEventID )
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_AddUserToEvent';  //Request URL
        req_1.httpMethod = 'GET';//HTTP Request Type
        req_1.addParameter('lead_id', strLeadID);
        req_1.addParameter('event_id', strEventID);
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_AddUserToEvent.AddUserToEvent();
    }
}