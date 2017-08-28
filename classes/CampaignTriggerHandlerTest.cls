/* *************************************************************************
* Test Class: CampaignTriggerHandlerTest TestClass
* dateCreated : 10/1/2015
*
* Purpose/Methods:
* - Code coverage Test class of the CampaignTriggerHandler class
*
* Unit Test: {CampaignTriggerHandler} 
*
************************************************************************* */

@isTest
public class CampaignTriggerHandlerTest{
    public static testMethod void campaignTriggerHandlerTestMethod(){
        CampaignTriggerHandler objCampaignTriggerHandler = new CampaignTriggerHandler();
        
        List<Campaign> lstCampaign = new List<Campaign>();
        
        for( integer x = 0; x < 20; x ++ )
        {
            Campaign objCamp = new Campaign();
            objCamp.Name = 'SampleEvent_' + string.valueOf(x);
            objCamp.Specie_Focus__c = 'Horse';
            objCamp.Type = 'Local';
            objCamp.Date_of_Event__c = Date.today();
            objCamp.Event_Zip__c = '36200';
            objCamp.Digigraph_Active__c = true;           
            lstCampaign.add( objCamp );
        }

        insert lstCampaign;
        
        for( Campaign obj : lstCampaign )
        {
            Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Customer Events').getRecordTypeId();
            obj.Name = 'SampleEvent_99';
            obj.Type = 'National';
            obj.Specie_Focus__c = 'Cattle';
            obj.Date_of_Event__c = Date.today().addDays(2);
            obj.Event_Zip__c = '90210';
            obj.Digigraph_Active__c = false;
        }
        
        update lstCampaign;        
  		delete lstCampaign;      
  
        
        Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Customer Events').getRecordTypeId();
        Campaign objCampaign = new Campaign();
        objCampaign.Name = 'SampleEvent';
        objCampaign.Specie_Focus__c = 'Horse';
        objCampaign.Type = 'Local';
        objCampaign.Date_of_Event__c = Date.today().addDays(2);
        objCampaign.Event_Zip__c = '36201';
        objCampaign.Digigraph_Active__c = true;
        insert objCampaign;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        objCampaign.Name = 'SampleEvent1';
        objCampaign.Specie_Focus__c  = 'Cattle';
        objCampaign.Event_Zip__c = '12321';
        objCampaign.IsActive= false;
        objCampaign.Digigraph_Active__c = false;
        update objCampaign;
        
        delete objCampaign;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                
        // Delete objCampaign;
        // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    }
}