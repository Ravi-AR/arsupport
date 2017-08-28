// VIP_Select_Opportunity_Controller
// 
// ------------------------------------------------------------------
// Author Date Description
// ------------------------------------------------------------------
// Justin Gerstl  08/16/2015 Created
//
public class VIP_Select_Opportunity_Controller {

    public List<Opportunity> opportunities{get;set;}

    public String account_id {get;set;}

    public String contact_id {get;set;}

    public String opportunity_id {get;set;}

    public String tempid{get;set;}
    
    // MWP 10/26/2016 - Added controller as parameter for simpler testing
    public VIP_Select_Opportunity_Controller(ApexPages.StandardController controller){
        account_id = ApexPages.currentpage().getParameters().get('acc_id');
        contact_id = ApexPages.currentpage().getParameters().get('con_id');
        opportunity_id = ApexPages.currentpage().getParameters().get('opp_id');
        List<Opportunity> opps = [SELECT id, Name, CloseDate, StageName, ExpectedRevenue
                                     FROM Opportunity 
                                     WHERE AccountId =: account_id];
        opportunities = opps;
        
    }
    
    public PageReference selectOpp(){
        
        PageReference ret_page = new PageReference('/apex/VIP_Farm_Events_Invite?acc_id=' + account_id + '&opp_id=' + tempid + '&con_id='+contact_id);
        return ret_page;
    }
    
}