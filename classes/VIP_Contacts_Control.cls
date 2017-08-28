// VIP_Contacts_Control
// 
// ------------------------------------------------------------------
// Author Date Description
// ------------------------------------------------------------------
// Justin Gerstl  08/16/2015 Created
//
public class VIP_Contacts_Control {
    
    Apexpages.StandardController controller;

    public List<Contact> rel_cons {get;set;}
    public Boolean consExist{get;set;}
    public ID conClick{get;set;}

    public VIP_Contacts_Control(ApexPages.StandardController c){
        controller = c;

        // MWP 10/26/2016 - Changed to getRecord() for simpler testing
        //Farm_VIP_Registration__c cur = (Farm_VIP_Registration__c)c.getRecord();
        Farm_VIP_Registration__c cur = [select id, Name, Registrant__c, Related_Contact_Ids__c FROM Farm_VIP_Registration__c WHERE id =: c.getId()];
        
        List<ID> conids = new List<ID>();

        if(cur.Related_Contact_Ids__c != null && cur.Related_Contact_Ids__c != ''){
            List<String> rel_con_ids = cur.Related_Contact_Ids__c.split(',');
                 for(Integer i=0; i < rel_con_ids.size(); i++){
                    if(rel_con_ids[i]!='null')
                        conids.add(rel_con_ids[i]);
            }    
        }

        if(conids.size() > 0){
            List<Contact> contacts = [SELECT id, Name, Phone, Email, Role__c FROM Contact WHERE id IN : conids];
            rel_cons = contacts;
            consExist = true;
        }else{
            consExist = false;
        }

    }

    public PageReference gotoContact(){

        return new PageReference('/'+conClick);
    }

}