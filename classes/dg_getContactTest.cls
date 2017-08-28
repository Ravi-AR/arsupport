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
public class dg_getContactTest{
    public static testMethod void dg_getContactTestMethod(){
        
  		Test.startTest();
        // Test1();
        Test2();
        // Test3();
        // Test4();
        
        dg_getContact.GetLeadContactDetails('00Q630000016XFWEA2');
        dg_getContact.GetLeadContactDetails('000000000000000000');
        dg_getContact.GetLeadContactDetails('');
        dg_getContact.GetLeadContactDetails('003j000000eqAhjAAE');
       
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
        dg_getContact.FindLeadContactRecord();
        dg_getContact.jsonstringContact(lstContact);
        dg_getContact.jsonstringLead(lstLead);
		
		
        
    }
    
    public static void Test1()
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_getContact';  //Request URL
        req_1.httpMethod = 'GET';//HTTP Request Type
        req_1.addParameter('lead_id', '00Q630000016XFWEA2');
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_getContact.FindLeadContactRecord();
    }
    
    public static void Test2()
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_getContact';  //Request URL
        req_1.httpMethod = 'GET';//HTTP Request Type
        req_1.addParameter('lead_id', '003j000000eqAhjAAE');
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_getContact.FindLeadContactRecord();
    } 
    
        public static void Test3()
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_getContact';  //Request URL
        req_1.httpMethod = 'GET';//HTTP Request Type
        req_1.addParameter('lead_id', '000000000000000000');
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_getContact.FindLeadContactRecord();
    }  
    
    public static void Test4()
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_getContact';  //Request URL
        req_1.httpMethod = 'GET';//HTTP Request Type
        req_1.addParameter('lead_id', '');
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_getContact.FindLeadContactRecord();
    }  
}