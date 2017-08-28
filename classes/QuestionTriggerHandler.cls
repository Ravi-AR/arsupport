public class QuestionTriggerHandler {
    public static boolean isQuestionRecursive = false;
    public static void QuestionAPI(List<Question__c> newList,List<Question__c> oldList,
            boolean isUpdate,boolean isAfter,boolean isDelete){
        List<Question__c> lstQuestion = new List<Question__c>();
        if(isAfter && isUpdate){
            lstQuestion = [select id,Question__c,Order_Sequence__c,Animal_Type__c,IsQuestionCreated__c,IsActive__c,
                           (select id,Answer_Option__c from Answers__r) 
                           from Question__c where id in:newList Limit 10];
        } else if(isDelete){
            lstQuestion = [select id,Question__c,Order_Sequence__c,Animal_Type__c,IsQuestionCreated__c,IsActive__c,
                           (select id,Answer_Option__c from Answers__r) 
                           from Question__c where id in:oldList Limit 10];
        }              
        JSONGenerator generator;
        string strAns;
        for(Question__c objQ : lstQuestion){
            strAns = '';
            if(objQ.Answers__r != null && objQ.Answers__r.size() >=2){
                generator = JSON.createGenerator(true);  
                generator.writeStartArray();
                for(Answer__c objAns : objQ.Answers__r){
                    generator.writeStartObject();
                    generator.writeStringField('answerId',objAns.Id);
                    generator.writeStringField('body',objAns.Answer_Option__c);
                    generator.writeEndObject();
                }
                generator.writeEndArray();
                strAns = generator.getAsString();
                if(isDelete || objQ.IsQuestionCreated__c) {
                    if(isDelete) {
                        objQ.IsActive__c = false;
                    }
                    if(!Test.IsRunningTest()) {
                        DigigrapghAPI.EditQuestion(string.valueof(objQ.id),objQ.Question__c,string.valueof(objQ.Order_Sequence__c),objQ.Animal_Type__c,
                                strAns,objQ.IsActive__c,isDelete);   
                    }
                } else {
                    if(!Test.IsRunningTest()) {
                        DigigrapghAPI.Question(string.valueof(objQ.id),objQ.Question__c,string.valueof(objQ.Order_Sequence__c),objQ.Animal_Type__c,
                                strAns,objQ.IsActive__c);
                    }
                    objQ.IsQuestionCreated__c = true;
                }                    
            }
        } 
        if(lstQuestion.size()>0 && isUpdate) {
            QuestionTriggerHandler.isQuestionRecursive = true;
            update lstQuestion;
        }    
    }
}