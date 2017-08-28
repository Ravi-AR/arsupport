/******************************************************************************
 * Class : VIP_Events_Router_Controller 
 * 
 * Purpose : Class for handling redirecting logic for Adding contacts / opportunities
 *            to Farm VIP events.
 */
public class VIP_Events_Router_Controller {
    
    Opportunity                     master_opp {get;set;}
    Account                         master_acc {get;set;}
    Contact                         master_con {get;set;}
    Boolean                         fromContact {get;set;}

    //List<Animal_Count_Lifestage__c> master_animals{get;set;}
    //String                          SendAccountError {get;set;}

    //Contstructor: 
    public VIP_Events_Router_Controller(){

        String con = ApexPages.currentpage().getParameters().get('contactid');
        String opp = ApexPages.currentpage().getParameters().get('opportunityid');

        // contact flow.
        if(con != null){
            Contact c = [SELECT ID, Name, AccountId from Contact WHERE id =: con];
            fromContact = true;
            master_con = c;
            if(c.AccountId != null){
                 Account a = [SELECT ID, Name, Error__c FROM Account WHERE id =: c.AccountId];
                 master_acc = a;
            }
           
        }

        // opportunity flow. 
        if(opp != null){
            Opportunity c = [SELECT ID, NAME, AccountId from Opportunity WHERE id =: opp];
            fromContact = false;
            master_acc = [SELECT ID, Name, Error__c FROM Account WHERE ID =: c.AccountId];
            master_opp = c;
        }

    }
    
/***************************************************************
*   Routing method for VIP Farm evetns.
*   @return : redirects the user based on the FARM VIP flow.
*/
    public PageReference route(){
        PageReference l_page;

        if(fromContact == true){    // contact logic route.

            l_page = new PageReference('/apex/Account_Error_Page');
            if(master_acc == null){
                l_page = new PageReference('/'+master_con.id);
            }else{
                l_page.getParameters().put('acc_id', master_acc.id);    
            }
            
            if(master_con != null){
                l_page.getParameters().put('con_id', master_con.id);
            }
            if(master_opp != null){
                //l_page.getParameters().put('opp_id', master_opp.id);
            }
            l_page.setRedirect(true);
            
        }else{                      // opportunity logic route.

            l_page = new PageReference('/apex/Account_Error_Page');
            if(master_con != null){
                //l_page.getParameters().put('con_id', master_con.id);
            }
            if(master_acc != null){
                l_page.getParameters().put('acc_id', master_acc.id);
            }
            if(master_opp != null){
                l_page.getParameters().put('opp_id', master_opp.id);
            }
            l_page.setRedirect(true);
        }
        return l_page;
    }

}