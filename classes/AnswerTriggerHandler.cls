public class AnswerTriggerHandler{
    public static void AnswerAPI(List<Answer__c> newList,List<Answer__c> oldList,Map<id,Answer__c> oldMap,
                        boolean isInsert,boolean isUpdate,boolean isAfter,boolean isDelete,boolean isunDelete){
        
        if(isAfter){
            set<Id> setQuestion = new set<Id>();
            if(isInsert || isUpdate || isunDelete) {
                for(Answer__c objans : newList){
                    setQuestion.add(objans.Question__c);
                }
            }
            if(isDelete) {
                for(Answer__c objans : oldList){
                    setQuestion.add(objans.Question__c);
                }
            }
            
            List<Question__c> lstQuestion = new List<Question__c>();
            lstQuestion = [select id,Question__c,Order_Sequence__c,Animal_Type__c,IsQuestionCreated__c,
                            (select id,Answer_Option__c,Answer_Order__c from Answers__r) from Question__c where id in: setQuestion limit 10];
            JSONGenerator generator;
            string strAns;
            for(Question__c objQ : lstQuestion){
                strAns = '';
                Boolean blnAns = objQ.IsQuestionCreated__c;
                if(objQ.Answers__r != null && objQ.Answers__r.size() >=2 ){
                    generator = JSON.createGenerator(true);  
                    generator.writeStartArray();
                    for( Answer__c objAns : objQ.Answers__r){
                        generator.writeStartObject();
                        generator.writeStringField('answerId',objAns.Id);
                        generator.writeStringField('body',objAns.Answer_Option__c);
                        if( objAns.Answer_Order__c != null )
                        {
                        	generator.writeStringField('order', string.valueof(objAns.Answer_Order__c));
                        }
                        else
                        {
                            generator.writeStringField('order', '99');
                        }
                        generator.writeEndObject();
                    }
                    generator.writeEndArray();
                    strAns = generator.getAsString();
                    if(blnAns) {
                        if(!Test.IsRunningTest()) {
                            DigigrapghAPI.EditQuestion(string.valueof(objQ.id),objQ.Question__c,string.valueof(objQ.Order_Sequence__c),objQ.Animal_Type__c,strAns, true,false);
                        }
                    } else {
                        if(!Test.IsRunningTest()) {
                            DigigrapghAPI.Question(string.valueof(objQ.id),objQ.Question__c,string.valueof(objQ.Order_Sequence__c),objQ.Animal_Type__c,strAns, true);
                        }
                        objQ.IsQuestionCreated__c = true;
                    }
                }
            }
            if(lstQuestion.size()>0) {
                QuestionTriggerHandler.isQuestionRecursive = true;
                update lstQuestion;
            }
        }
        
    }
}