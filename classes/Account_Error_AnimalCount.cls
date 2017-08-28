public abstract class Account_Error_AnimalCount {
	
    Apexpages.StandardController controller;
    
    public Account_Error_AnimalCount(Apexpages.StandardController c){
        controller = c;
    }
    
    public PageReference Tsave(){
        Animal_Count_Lifestage__c temp = (Animal_Count_Lifestage__c)controller.getRecord();
        temp.Account__c = ApexPages.currentPage().getParameters().get('acc_id');
        controller.save();


        PageReference pr = new PageReference('/apex/Account_Error_Page');
        pr.getParameters().put('acc_id',Apexpages.currentPage().getParameters().get('acc_id'));
        pr.getParameters().put('con_id',Apexpages.currentPage().getParameters().get('con_id'));
        return pr;

        //return null;
    }
    
}