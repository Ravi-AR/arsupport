/* *************************************************************************
* Test Class: FindLeadContactTest TestClass
* dateCreated : 10/1/2015
*
* Purpose/Methods:
* - Code coverage Test class of the FindLeadContact class
*
* Unit Test: {FindLeadContact} 
*
************************************************************************* */
@isTest
public class FindLeadContactTest{
    public static testMethod void findLeadContactTestMethod(){
        FindLeadContact objFindLeadContact = new FindLeadContact();        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        RestContext.request = req;
        RestContext.response= res;
        
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
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        FindLeadContact.FindLeadContactRecord();
        FindLeadContact.jsonstringContact(lstContact);
    }
}