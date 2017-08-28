public abstract class Account_Error_CreateNewOppt {
	
	public Apexpages.StandardController controller;
	public Opportunity tempOpp{get;set;}
    public Boolean PageSaved {get;set;}

    public Account_Error_CreateNewOppt(Apexpages.StandardController c){
        SYSTEM.DEBUG('CREATENEW OPPT CONTROLLER');
    	controller = c;
    	PageSaved = false;
    }
    
    public PageReference Tsave() {
        SYSTEM.DEBUG('RECORD ID ' + controller.getRecord());
		Opportunity temp = (Opportunity)controller.getRecord();
        temp.AccountId = ApexPages.currentPage().getParameters().get('acc_id');

    	controller.save(); // invoke standard save method. 

        PageReference pr = new PageReference('/apex/Account_Error_Page');
        pr.getParameters().put('acc_id',Apexpages.currentPage().getParameters().get('acc_id'));
        pr.getParameters().put('con_id',Apexpages.currentPage().getParameters().get('con_id'));
        return pr;
    }

}