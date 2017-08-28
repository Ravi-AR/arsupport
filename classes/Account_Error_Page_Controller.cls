public class Account_Error_Page_Controller {
	
    public Account current_account{get;set;}
    public Contact  current_contact{get;set;}
    public Opportunity current_opp{get;set;}

    public Boolean contact_exists{get;set;}
    public List<Contact> related_contacts{get;set;}
    public Boolean rel_contacts {get;set;}
    public id sel_conid {get;set;}

    public List<Animal_Count_Lifestage__c> animal_counts{get;set;}
    public List<Opportunity> opps{get;set;}
    // Createing new animal account records.
    public Animal_Count_Lifestage__c create_animal_count{get;set;}
    public Opportunity create_Opportunity{get;set;}

    // parameter ids.
    public String cid {get;set;}
    public String aid {get;set;}
    public String oid {get;set;}

    public Boolean informationGood{get;set;}
    public String ErrorMessage {get;set;}
    public String successMessage {get;set;}
    
    public String popupError {get;set;}

    public boolean displayPopUp {get;set;}
    public Boolean NotInfluencer {get;set;}
    public Boolean ListHasLifeStage {get;set;}
    public Boolean hasSelectedOpps {get;set;}

    List<list_Opp_item> OppList {get;set;}
    public List<list_Opp_item> selected_OppList = new List<list_Opp_item>();
    public List<Opportunity> cur_sOList {get;set;}
    public Map<ID, Opportunity> cur_sOList_MAP {get;set;}
    // Custom settings.
    VIP_Purina_Account__c Purina_Account{get;set;}
    Map<String, String> influecerPath {get;set;}

    public Account_Error_Page_Controller(ApexPages.StandardController controller){
        // coming from the contact or the opportunity.
        Purina_Account = VIP_Purina_Account__c.getOrgDefaults();
        influecerPath = new Map<String, String>();
        if(Purina_Account.Contact_Influencer_Type__c != null){
            List<String> con_types_infl = Purina_Account.Contact_Influencer_Type__c.split(',');
            for(String s : con_types_infl){
                influecerPath.put(s, s);
            }
        }
        informationGood = false;
        displayPopUp = false;
        cid = ApexPages.currentPage().getParameters().get('con_id');
        aid = ApexPages.currentPage().getParameters().get('acc_id');
        oid = ApexPages.currentPage().getParameters().get('opp_id');

        SYSTEM.DEBUG('THISS IS CURRENT PAGE ' + Apexpages.currentPage());
        SYSTEM.DEBUG('Acocunt id ' + aid);

        current_account = [SELECT ID, Name
                           FROM Account
                           WHERE id =: aid];

        create_animal_count = new Animal_Count_Lifestage__c();
        create_animal_count.Account__c = current_account.id;

        create_Opportunity = new Opportunity();
        create_Opportunity.AccountId = current_account.id;
        create_Opportunity.OwnerId = UserInfo.getUserId();

        // Get all the related opportunities
/******* DON'T WANT TO USE CLOSED OPPORTUNITIES OR CLOSED WON OPPORTUNITIES. *******/
        opps = [SELECT id, Name, AccountId, CloseDate, StageName, Life_Stage__c, Species__c, Total_Head__c, Type
                FROM Opportunity
                WHERE AccountId =: aid AND StageName != 'Closed Won' AND StageName != 'Closed Lost'];
        if(opps.size() > 0){
            current_opp = opps[0];
            getOppList();
        }
        // Get all the related animal counts and life stages.  Lead__c,
        animal_counts = [SELECT id, Name, Account__c, Animal_Count__c, Animals_Served__c, Animal_Type__c, Lifestage__c
                            FROM Animal_Count_Lifestage__c
                            WHERE Account__c =: aid];

        if(cid != null && cid != ''){
            current_contact = [SELECT id, Name, firstName, lastName, AccountId, Contact_Type__c, Phone, Email, Other_Role__c, Role__c
                            FROM Contact
                            WHERE id =: cid];
            contact_exists = true;
            system.debug('contact type ' + current_contact.Contact_Type__c);
            system.debug('influecerPath ' + influecerPath);
            if(influecerPath.containsKey(current_contact.Contact_Type__c)){

                NotInfluencer = false;
            }else{
                NotInfluencer = true;
            }
        }else{
            contact_exists = false;
            NotInfluencer = true;
        }

        if(oid != null && oid != ''){
            current_opp = [SELECT id, Name
                             FROM Opportunity 
                             WHERE id =: oid];
        }

        if(contact_exists == false){    // no contact.
            related_contacts = [SELECT id, Name, firstName, lastName, AccountId, Contact_Type__c, Phone, Email, Other_Role__c, Role__c
                                FROM Contact 
                                WHERE AccountId =: current_account.id];
            if(related_contacts.size() > 0){
                rel_contacts = true;                
            }else{
                rel_contacts = false;
            }
        }else{
            rel_contacts = false;
        }

        if( current_contact != null && opps.size() > 0 && animal_counts.size() > 0){
            informationGood = true;
            successMessage = Label.AError_Success;
        }
        
        system.debug('opp list ' + OppList);
        populateError();

        //override the qualifications
        if(current_contact != null){
            //if(current_contact.Contact_Type__c == 'Influencer' || current_contact.Contact_Type__c == 'Dealer' ){
            if(influecerPath.containsKey(current_contact.Contact_Type__c)){    
                informationGood = true;
                successMessage = Label.AError_Success;
                ErrorMessage = '';
            }
        }
    }

    public void populateError(){
        ErrorMessage = '';
        if(current_contact == null){
            ErrorMessage += '*Account Requires a Contact.  ';
        }
        if(opps.size() == 0){
            ErrorMessage = Label.AError_no_opp;
        }
        if(animal_counts.size() == 0){ 
            ErrorMessage = Label.AError_no_life; 
        }
        if(opps.size() == 0 && animal_counts.size() == 0){
            ErrorMessage = Label.AError_no_both;
        }
    }
    
    public void checkSuccess(){
        if( current_contact != null && opps.size() > 0 && animal_counts.size() > 0){
            informationGood = true;
            successMessage = Label.AError_Success;
        }
    }


    public PageReference insertAnimalRecord(){
        
        try{
            insert create_animal_count;
        }catch(DmlException e){
            System.debug('ERROR OCCURED ON INSERT (Animal_Count_Lifestage__c record: ' + e.getMessage());
        }
        PageReference l_page = new PageReference('/apex/Account_Error_Page');
        l_page.getParameters().put('acc_id', aid);
        l_page.getParameters().put('con_id', cid);
        l_page.getParameters().put('opp_id', oid);
        l_page.setRedirect(true);
        return l_page;
    }

// DEPRECATED WITH NEW CODE AND ADD ONS. 
    //public PageReference insertOpportunityRecord(){
    //    PageReference l_page;
    //    try{
    //        insert create_Opportunity;
    //        l_page = new PageReference('/apex/Account_Error_Page');
    //        l_page.getParameters().put('acc_id', aid);
    //        l_page.getParameters().put('con_id', cid);
    //        l_page.getParameters().put('opp_id', oid);
    //        l_page.setRedirect(true);
    //    }catch(DmlException e){
    //        System.debug('ERROR OCCURED ON INSERT OPPORTUNITY : ' + e.getMessage());
    //        l_page = null;
    //    }
    //    return l_page;
    //}
    
    public PageReference registerVIP(){

        PageReference l_page = new PageReference('/apex/VIP_Farm_Events_Invite');
        l_page.getParameters().put('acc_id', current_account.id);
        l_page.getParameters().put('con_id', current_contact.id);

        List<id> oppids = new List<id>();
        Map<id, Opportunity> id_has_life = new Map<id, Opportunity>();

        if(cur_sOList == null){
            cur_sOList = new List<Opportunity>();
            cur_sOList_MAP = new Map<ID, Opportunity>();
        }
        if(Selected_OppList != null){
            for(list_Opp_item o : this.Selected_OppList){
                if(o.selected == true){
                    oppids.add(o.opp.id);
                    if(cur_sOList_MAP.containsKey(o.opp.id)){
                    }else{
                        cur_sOList_MAP.put(o.opp.id, o.opp);
                        cur_sOList.add(o.opp);        
                    }
                    id_has_life.put(o.opp.id, o.opp);
                }
            }
            
        }
        String multiOppIds = '';
        integer f = 0;
        for(id i : oppids){
            if(f != oppids.size()-1){
                multiOppIds += i+';';
            }else{
                multiOppIds += i;
            }
            f++;
        }      
        
        if(oppids.size() > 0){
            // CHECK OPPORUTNITIES TO MAKE SURE AT LEAST ONE HAS A LIFESTAGE VALUE
            hasSelectedOpps = true;
            Boolean lifeStageGood = checkOppLifeStage(id_has_life);
            ListHasLifeStage = lifeStageGood;
            if(lifeStageGood == true){
                l_page.getParameters().put('multiOppIds', multiOppIds);
                //popupError = '';
                l_page.setRedirect(true);
            }else{
                popupError = Label.One_LifeStage_Req;
                l_page = null;
            }        
        }else{
            hasSelectedOpps = false;
            // IF the contact is not type Influencer or dealer -- require opportunities to be created.  
            //if(current_contact.Contact_Type__c != 'Influencer' && current_contact.Contact_Type__c != 'Dealer'){
            if(influecerPath.containsKey(current_contact.Contact_Type__c)){    
            }else{
                popupError = Label.Must_select_Opportunity;
                l_page = null;
            }
        }

        if(ListHasLifeStage == false && cur_sOList.size() >0){
            try{
                update cur_sOList;
            }catch(DmlException e){
                SYSTEM.DEBUG('This is the error message ' + e.getMessage());
            }
        }
        
        
        //l_page.setRedirect(true);
        system.debug('this is the page ' + l_page);
        return l_page;
    }

    public Boolean checkOppLifeStage(Map<id, Opportunity> oppMap){
        Boolean ret_val = false;
        for(id i : oppMap.keySet()){
            Opportunity tempO = oppMap.get(i);
            if(tempO.Life_Stage__c != null){
                ret_val = true;
            }
        }
        return ret_val;
    }

    public void showPopUp(){
            displayPopUp = true;
    }
    public void closePopUp(){
        displayPopUp = false;
    }
    
    public void selectContact(){
        current_contact = [SELECT id, Name, firstName, lastName, AccountId, Contact_Type__c, Phone, Email, Other_Role__c, Role__c
                            FROM Contact
                            WHERE id =: sel_conid];
        contact_exists = true;
        rel_contacts = false;
		populateError();
        checkSuccess();
    }

    public List<list_Opp_item> getOppList(){
        List<list_Opp_item> new_l = new List<list_Opp_item>();
        List<list_Opp_item> tempL = new List<list_Opp_item>();
        if(opps.size() > 0){
            
            for(Opportunity o : opps){
                list_Opp_item l_o = new list_Opp_item(o);
                if(cur_sOList_MAP != null){
                    if(cur_sOList_MAP.containsKey(o.id)){
                        l_o.selected = true;
                    }    
                }
                
                new_l.add(l_o);
                tempL.add(l_o);
            }
        }
        selected_OppList = tempL;
        return new_l;
    }

    public class list_Opp_item{
        public Opportunity opp {get;set;}
        public Boolean selected {get;set;}

        public list_Opp_item(Opportunity o){
            opp = o;
            selected = false;
        }
    }

    public PageReference createNewContact(){
        return null;
    }

    public void updateOppLifestagesvalues(){
        System.debug('this is the opp list ' );
        OppList = OppList;
        try{
            update cur_sOList;
        }catch(DmlException e){
            SYSTEM.DEBUG('Error occured : update Opportunity : ' + e.getMessage());
        }
        //return null;
    }

/* ------------- CREATE CUSTOME LIST FOR RELATING OBJECTS TO THE OPPORTUNITY. ----------- */
    
}