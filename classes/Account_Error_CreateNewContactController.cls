public abstract class Account_Error_CreateNewContactController 
{

    Apexpages.StandardController controller;
    
    public Account_Error_CreateNewContactController(Apexpages.StandardController c){
    	controller = c;
    }
     
    public PageReference save() {
        SYSTEM.DEBUG('IN OVERRIDE SAVE METHOD');
        SYSTEM.DEBUG('RECORD ID ' + controller.getRecord());
		Contact temp = (Contact)controller.getRecord();
        temp.AccountId= ApexPages.currentPage().getParameters().get('acc_id');
    	controller.save();				//invoke standard Save method
        return null;
    }




}