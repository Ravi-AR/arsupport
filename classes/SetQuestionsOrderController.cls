global with sharing class SetQuestionsOrderController {
    public List<Question__c> lstQuestion {get;set;} 
    public string strJSON{get;set;}
    
    public SetQuestionsOrderController() {
        lstQuestion = new List<Question__c>([select Id,Name,Question__c,Order_Sequence__c,Animal_Type__c,IsActive__c 
                from Question__c Order by Animal_Type__c asc,Order_Sequence__c asc]); 
        strJSON = JSON.serialize(lstQuestion);
    }
 
    @RemoteAction
    global static map<string,List<Question__c>> fnQuestionlist(){
    
        map<string,List<Question__c>> mapOfQue = new map<string,List<Question__c>>();
        
        List<Question__c> lstQuestion = new List<Question__c>([select Id,Name,Question__c,Order_Sequence__c,Animal_Type__c,
                        IsActive__c from Question__c Order by IsActive__c desc,Animal_Type__c asc,Order_Sequence__c asc]);
                        
        if(lstQuestion != null && lstQuestion.size() > 0){
            for(Question__c objQue : lstQuestion){
                if(!mapOfQue.containskey(objQue.Animal_Type__c)){
                    mapOfQue.put(objQue.Animal_Type__c,new List<Question__c>{objQue});
                }else{
                    mapOfQue.Get(objQue.Animal_Type__c).add(objQue);
                }
            }
        }
        
        return mapOfQue ;
    }  
    
    @RemoteAction
    global static string fnQuestionActive(Question__c objQuestion){
        try {
            update objQuestion;
            return 'success';
        }  catch(Exception ex) {
            return 'Fail: '+ex.getMessage();
        }
    } 
    
    @RemoteAction
    global static string fnUpdateQuestionOrder(List<Question__c> lst){
        try {
            update lst;
            return 'success';
        } catch(Exception ex) {
            return 'Fail: '+ex.getMessage();
        }
    }  
}