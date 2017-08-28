public class Edit_Farm_VIP_Reg_Control {
	
	public Farm_VIP_Registration__c cur_reg {get;set;}
	public Contact 					cur_con {get;set;}
    VIP_Purina_Account__c Purina_Account    {get;set;}
    public Boolean Influencer_Path            {get;set;}

    public Edit_Farm_VIP_Reg_Control(ApexPages.StandardController controller){
        ID reg_id = controller.getId();
        cur_reg = [SELECT id, Name, Animals_Influenced__c, Approval_Date__c, Approval_Status__c, Attendee_Type__c, Farm_VIP_Event__c, Host_will_be_attending__c, Notes__c, Registrant__c, Related_Contact_Ids__c, Re_submitted__c, Room_With__c, Traveling_Via__c, Wearable_Size_if_applicable__c
        			FROM Farm_VIP_Registration__c
        			WHERE id =: reg_id];	
        cur_con = [SELECT id, Name, FirstName, LastName, AccountId, Email, MobilePhone, Contact_Type__c, Role__c 
        			FROM Contact 
        			WHERE id =: cur_reg.Registrant__c];

        Purina_Account = VIP_Purina_Account__c.getOrgDefaults();
        Map<String, String> influecerPath = new Map<String, String>();
        if(Purina_Account.Contact_Influencer_Type__c != null){
            List<String> con_types_infl = Purina_Account.Contact_Influencer_Type__c.split(',');
            for(String s : con_types_infl){
                influecerPath.put(s, s);
            }
        }

        //if(influecerPath.containsKey(cur_con.Contact_Type__c)){
        if(cur_con.Contact_Type__c == 'Influencer'){
            Influencer_Path = true;
        }else{
            Influencer_Path = false;
        }
    }
    
    public PageReference cancelEdit(){
        return new PageReference('/'+cur_reg.id);
        return null;
    }
    
    public PageReference saveAndUpdate(){
	   SYSTEM.DEBUG(' BEFORE current record ' + cur_reg);
        SYSTEM.DEBUG('BEFORE current contact ' + cur_con);
        try{
            update cur_con;
        }catch(DMLException e){
            SYSTEM.DEBUG('ERROR OCCURED ' + e.getMessage());
        }
        
        try{
            update cur_reg;
        }catch(DMLException e){
            SYSTEM.DEBUG('ERROR OCCURED ON UPDATE (Farm_VIP_Registration__c) ' + e.getMessage());
        }

        SYSTEM.DEBUG('current record ' + cur_reg);
        SYSTEM.DEBUG('current contact ' + cur_con);
        return new PageReference('/'+cur_reg.id);
    }
}