public class VIP_Contact_Select_Controller {
    
    public Campaign selected_campaign {get;set;}
    public Farm_VIP_Registration__c reg_info {get;set;}

    public Account acc      {get;set;}
    public Contact con      {get;set;}
    public String errormsg {get;set;}
    public Boolean showErr {get;set;}
    public String temp {get;set;}

    public VIP_Contact_Select_Controller(){
        String e_id = ApexPages.currentPage().getParameters().get('event_id');
        try{
            selected_campaign = [SELECT id, Name
                            FROM Campaign
                            WHERE id =: e_id];
        }catch(DmlException e){
                system.debug('error occured ' + e.getMessage());
        }
        
        showErr = false;
        reg_info = new Farm_VIP_Registration__c();
    }

    public PageReference setOpportunitiesList(){
        
        SYSTEM.DEBUG('this is the id ' + reg_info.Registrant__c);
        
        if(reg_info.Registrant__c != null){
            try{
                con = [SELECT id, Name, AccountId, Phone, Email
                        FROM Contact 
                        WHERE id =: reg_info.Registrant__c];
                }catch(DmlException e){
                    system.debug('error occured ' + e.getMessage());
            }  
            
            try{
                acc = [SELECT id, Name
                        FROM Account
                        WHERE id =: con.AccountId];
            }catch(DmlException e){
                system.debug('error occured ' + e.getMessage());
            }
            
        }
        return null;
    }
    
    public PageReference redirect_or_error(){
    	PageReference l_page;
        
        if(reg_info.Registrant__c != null){
			l_page = new PageReference('/apex/Account_Error_Page');
            l_page.getParameters().put('acc_id', acc.id);
            l_page.getParameters().put('con_id', con.id);
            showErr = false;
            errormsg = '';
        }else{
			errormsg = 'Please select a contact.';
            showErr = true;
            l_page = null;
        }
		SYSTEM.DEBUG('THIS IS L_PAGE ' + l_page);
		return l_page;
    }
    
}