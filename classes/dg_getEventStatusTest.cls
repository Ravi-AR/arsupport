/* *************************************************************************
* Test Class: dg_getEventStatusTest TestClass
* dateCreated : 2/22/2015
*
* Purpose/Methods:
* - Code coverage Test class of the dg_getEventStatusTest class
*
* Unit Test: {dg_getEventStatus} 
*
************************************************************************* */
@isTest(SeeAllData=True)
public class dg_getEventStatusTest
{
    public static testMethod void dg_getEventStatusTestMethod()
    {        
  		Test.startTest();

        TestRest();
		
        Test.stopTest();
        
    }
    
    public static void TestRest()
    {
        RestRequest req_1 = new RestRequest();
        RestResponse res = new RestResponse();
        
        req_1.requestURI = '/dg_getEventStatus';  //Request URL
        req_1.httpMethod = 'GET'; //HTTP Request Type
        
        RestContext.request = req_1;
        RestContext.response= res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       	dg_getEventStatus.getEventStatus();
    }
}