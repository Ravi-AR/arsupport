/* *************************************************************************
* Test Class: AnswerTriggerHandlerTest TestClass
* dateCreated : 3/31/2016
*
* Purpose/Methods:
* - Code coverage Test class of the CampaignTriggerHandler class
*
* Unit Test: {CampaignTriggerHandler} 
*
************************************************************************* */

@isTest
public class AnswerTriggerHandlerTest
{
    public static testMethod void AnswerTriggerHandlerTestMethod()
    {
        
        AnswerTriggerHandler objAnswerTriggerHandler = new AnswerTriggerHandler();
        
       	// Select a question.
       	// List<Question__c> lstQuestion = new List<Question__c>();
        Question__c tQuestion = new Question__c();
        tQuestion.Animal_Type__c = 'General';
        tQuestion.Order_Sequence__c = 1;
        tQuestion.Question__c = 'This is a test question?';
        insert tQuestion;
        
		Answer__c tAnswer1 = new Answer__c( Question__c = tQuestion.Id );
        tAnswer1.Answer_Order__c = 1;
        // tAnswer1.RecordTypeId = 2;
        tAnswer1.Answer_Option__c = 'Value 1';
        
		Answer__c tAnswer2 = new Answer__c( Question__c = tQuestion.Id );
        tAnswer2.Answer_Order__c = 2;
        // tAnswer2.RecordTypeId = 2;
        tAnswer2.Answer_Option__c = 'Value 2';


		Answer__c tAnswer3 = new Answer__c( Question__c = tQuestion.Id );
        tAnswer3.Answer_Order__c = 1;
        // tAnswer3.RecordTypeId = 3;
        tAnswer3.Answer_Option__c = 'Value 3';

        insert tAnswer1;
        insert tAnswer2;
        insert tAnswer3;
		
    }
    
}