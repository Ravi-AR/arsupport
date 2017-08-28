public class VIP_Animals_Controller {
	
    Apexpages.StandardController controller;
    
    public List<Animal_Count_Lifestage__c> animals{get;set;}
    
    public VIP_Animals_Controller(Apexpages.StandardController c){
        controller = c;

        //Farm_VIP_Registration__c cur = (Farm_VIP_Registration__c)controller.getRecord();
        Farm_VIP_Registration__c cur = [select id, Name, Registrant__c FROM Farm_VIP_Registration__c WHERE id =: c.getId()];
        
		id conid = cur.Registrant__c;
        Contact cc = [SELECT id, name, AccountId FROM Contact WHERE id =: conid];
        animals = [SELECT id, Name, Animal_Count__c, Animals_Served__c, Animal_Type__c, Lifestage__c, Account__c
                   FROM Animal_Count_Lifestage__c 
                   WHERE Account__c =: cc.AccountId];
        
        
    }
}