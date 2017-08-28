@isTest
public class SetQuestionsOrderControllerTest {

    public static testMethod void testSetQuestionOrder() {
        Question__c objQ1 = new Question__c();
        objQ1.Animal_Count_Update__c = false;
        objQ1.Animal_Type__c = 'Cattle';
        objQ1.IsActive__c = true;
        objQ1.Order_Sequence__c = 1; 
        objQ1.Question__c = 'How many Cattle do you have?';
        insert objQ1;
        
        Question__c objQ2 = new Question__c();
        objQ2.Animal_Count_Update__c = false;
        objQ2.Animal_Type__c = 'Companion';
        objQ2.IsActive__c = true;
        objQ2.Order_Sequence__c = 1; 
        objQ2.Question__c = 'How many Cattle do you want?';
        insert objQ2;
        
        Question__c objQ3 = new Question__c();
        objQ3.Animal_Count_Update__c = false;
        objQ3.Animal_Type__c = 'Cattle';
        objQ3.IsActive__c = true;
        objQ3.Order_Sequence__c = 3; 
        objQ3.Question__c = 'How many Cattle do you have?';
        insert objQ3;
        
        Answer__c objAnswer1 = new Answer__c();
        objAnswer1.Answer_Option__c = 'A';
        objAnswer1.Question__c = objQ3.Id;
        insert objAnswer1;
        
        Answer__c objAnswer2 = new Answer__c();
        objAnswer2.Answer_Option__c = 'A';
        objAnswer2.Question__c = objQ3.Id;
        insert objAnswer2;
        
        QuestionTriggerHandler.isQuestionRecursive = false;
        objQ3.Order_Sequence__c = 5; 
        update objQ3;
        
        delete objAnswer2;
        
        SetQuestionsOrderController objSetQuestion = new SetQuestionsOrderController();
        SetQuestionsOrderController.fnQuestionlist();
        SetQuestionsOrderController.fnQuestionActive(objQ2);
        SetQuestionsOrderController.fnUpdateQuestionOrder(new List<Question__c> {objQ1,objQ2});
    }
}