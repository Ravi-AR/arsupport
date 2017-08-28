/* *************************************************************************
* Test Class: LeadCreationTest TestClass
* dateCreated : 10/1/2015
*
* Purpose/Methods:
* - Code coverage Test class of the LeadCreation class
*
* Unit Test: {LeadCreation} 
*
************************************************************************* */

@isTest
public class LeadCreationTest{
    public static testMethod void leadCreationTestMethod(){
        LeadCreation objLeadCreation = new LeadCreation();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('firstname', 'test');
        req.addParameter('lastname', 'test');
        req.addParameter('street', 'sapleStreet');
        req.addParameter('city', 'sampleCity');
        req.addParameter('state', 'Ohio');
        req.addParameter('postalcode', '02315');
        req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        req.addParameter('mobilephone', '0212457845');
        req.addParameter('company', 'sampleCompany');        
        RestContext.request = req;
        RestContext.response= res;
        
        LeadCreation.CreateLeadRecord();
    }
    
    public static testMethod void leadCreationTestMethod1(){
        LeadCreation objLeadCreation = new LeadCreation();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        //req.addParameter('firstname', 'test');
        req.addParameter('lastname', 'test');
        req.addParameter('street', 'sapleStreet');
        req.addParameter('city', 'sampleCity');
        req.addParameter('state', 'Ohio');
        req.addParameter('postalcode', '02315');
        req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        req.addParameter('mobilephone', '0212457845');
        req.addParameter('company', 'sampleCompany');        
        RestContext.request = req;
        RestContext.response= res;
        
        LeadCreation.CreateLeadRecord();
    }
    
    public static testMethod void leadCreationTestMethod2(){
        LeadCreation objLeadCreation = new LeadCreation();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('firstname', 'test');
        //req.addParameter('lastname', 'test');
        req.addParameter('street', 'sapleStreet');
        req.addParameter('city', 'sampleCity');
        req.addParameter('state', 'Ohio');
        req.addParameter('postalcode', '02315');
        req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        req.addParameter('mobilephone', '0212457845');
        req.addParameter('company', 'sampleCompany');        
        RestContext.request = req;
        RestContext.response= res;
        
        LeadCreation.CreateLeadRecord();
    }
    
    public static testMethod void leadCreationTestMethod3(){
        LeadCreation objLeadCreation = new LeadCreation();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('firstname', 'test');
        req.addParameter('lastname', 'test');
        req.addParameter('street', 'sapleStreet');
        req.addParameter('city', 'sampleCity');
        req.addParameter('state', 'Ohio');
        req.addParameter('postalcode', '02315');
        //req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        req.addParameter('mobilephone', '0212457845');
        req.addParameter('company', 'sampleCompany');        
        RestContext.request = req;
        RestContext.response= res;
        
        LeadCreation.CreateLeadRecord();
    }
    
    public static testMethod void leadCreationTestMethod4(){
        LeadCreation objLeadCreation = new LeadCreation();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('firstname', 'test');
        req.addParameter('lastname', 'test');
        req.addParameter('street', 'sapleStreet');
        req.addParameter('city', 'sampleCity');
        req.addParameter('state', 'Ohio');
        req.addParameter('postalcode', '02315');
        req.addParameter('email', 'sample@sampletest.com');
        //req.addParameter('phone', '1245124512');
        req.addParameter('mobilephone', '0212457845');
        req.addParameter('company', 'sampleCompany');        
        RestContext.request = req;
        RestContext.response= res;
        
        LeadCreation.CreateLeadRecord();
    }
    
    public static testMethod void leadCreationTestMethod5(){
        LeadCreation objLeadCreation = new LeadCreation();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/leadcreation';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('firstname', 'test');
        req.addParameter('lastname', 'test');
        req.addParameter('street', 'sapleStreet');
        req.addParameter('city', 'sampleCity');
        req.addParameter('state', 'Ohio');
        req.addParameter('postalcode', '02315');
        req.addParameter('email', 'sample@sampletest.com');
        req.addParameter('phone', '1245124512');
        req.addParameter('mobilephone', '0212457845');
        //req.addParameter('company', 'sampleCompany');        
        RestContext.request = req;
        RestContext.response= res;
        
        LeadCreation.CreateLeadRecord();
    }
}