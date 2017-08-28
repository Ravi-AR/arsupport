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
public class dg_SyncSearchDataTest{
    public static testMethod void dg_SyncSearchDataTestMethod(){
        
  		Test.startTest();
 

		// Contact
		// 
		
        dg_SyncSearchData.GetLeadContactDetails( '', 'contact', 'all', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('', 'contact', 'update', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('', 'contact', 'delete', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('003j000000eqAhjAAE', 'contact', 'all', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('003j000000eqAhjAAE', 'contact', 'update', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('003j000000eqAhjAAE', 'contact', 'delete', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('003j000000eqAhjAAE', 'contact', 'all', '2017-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('003j000000eqAhjAAE', 'contact', 'update', '2017-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('003j000000eqAhjAAE', 'contact', 'delete', '2017-01-31T00:00:00Z');        
        dg_SyncSearchData.GetLeadContactDetails('', '', 'update', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('', '', '', '');


        TestRest( '', 'contact', 'all', '2015-01-31T00:00:00Z' );
        TestRest( '', 'contact', 'update', '2015-01-31T00:00:00Z');
        TestRest( '', 'contact', 'delete', '2015-01-31T00:00:00Z');
        TestRest('003j000000eqAhjAAE', 'contact', 'all', '2015-01-31T00:00:00Z' );
        TestRest('003j000000eqAhjAAE', 'contact', 'update', '2015-01-31T00:00:00Z' );
        TestRest('003j000000eqAhjAAE', 'contact', 'delete', '2015-01-31T00:00:00Z' );
        TestRest('003j000000eqAhjAAE', 'contact', 'all', '2017-01-31T00:00:00Z' );
        TestRest('003j000000eqAhjAAE', 'contact', 'update', '2017-01-31T00:00:00Z' );
        TestRest('003j000000eqAhjAAE', 'contact', 'delete', '2017-01-31T00:00:00Z' );        
        TestRest('', '', 'update', '2015-01-31T00:00:00Z');
        TestRest('', '', '', '');
        
        // Lead      
        dg_SyncSearchData.GetLeadContactDetails('', 'contact', 'all', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('', 'contact', 'update', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('', 'contact', 'delete', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('00Q630000016XFWEA2', 'contact', 'all', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('00Q630000016XFWEA2', 'contact', 'update', '2015-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('00Q630000016XFWEA2', 'contact', 'delete', '2015-01-31T00:00:00Z');       
        dg_SyncSearchData.GetLeadContactDetails('00Q630000016XFWEA2', 'contact', 'all', '2017-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('00Q630000016XFWEA2', 'contact', 'update', '2017-01-31T00:00:00Z');
        dg_SyncSearchData.GetLeadContactDetails('00Q630000016XFWEA2', 'contact', 'delete', '2017-01-31T00:00:00Z');       

        
        TestRest('', 'contact', 'all', '2015-01-31T00:00:00Z');
        TestRest('', 'contact', 'update', '2015-01-31T00:00:00Z');
        TestRest('', 'contact', 'delete', '2015-01-31T00:00:00Z');
        TestRest('00Q630000016XFWEA2', 'contact', 'all', '2015-01-31T00:00:00Z');
        TestRest('00Q630000016XFWEA2', 'contact', 'update', '2015-01-31T00:00:00Z');
        TestRest('00Q630000016XFWEA2', 'contact', 'delete', '2015-01-31T00:00:00Z');       
        TestRest('00Q630000016XFWEA2', 'contact', 'all', '2017-01-31T00:00:00Z');
        TestRest('00Q630000016XFWEA2', 'contact', 'update', '2017-01-31T00:00:00Z');
        TestRest('00Q630000016XFWEA2', 'contact', 'delete', '2017-01-31T00:00:00Z'); 

        
        
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
        dg_SyncSearchData.FindLeadContactRecord();
        dg_SyncSearchData.getContacts_JSON(lstContact);
        dg_SyncSearchData.getLeads_JSON(lstLead);
		
        Test.stopTest();
        
    }
    
    public static void TestRest( string strLeadID, string strRecType, string strActionType, string strSince )
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_SyncSearchData';  //Request URL
        req_1.httpMethod = 'GET';//HTTP Request Type
        req_1.addParameter('next_lead_id', strLeadID);
        req_1.addParameter('record_type', strRecType);
        req_1.addParameter('action_type', strActionType);
        req_1.addParameter('since', strSince);
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_SyncSearchData.FindLeadContactRecord();
    }
    
    
}