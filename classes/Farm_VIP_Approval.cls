public class Farm_VIP_Approval {

    //method called by trigger to update approval items. -- passes control to make ApprovalUpdates if updates need to be made. 
    public void checkApproved(Map<ID, Farm_VIP_Registration__c> newMap, Map<ID, Farm_VIP_Registration__c> oldMap){
        Set<ID> ids = new Set<ID>();
        for(ID ci : newMap.keySet()){
            Farm_VIP_Registration__c new_temp = newMap.get(ci);
            if(new_temp.Approval_Status__c == 'Approved'){
                ids.add(new_temp.id);
            }
        }
        if(ids.size() > 0){
            makeApprovalUpdates(ids, newMap);
        }

    }   // end check approved.

    // updates opportunities, contact, and user records.  
    public void makeApprovalUpdates(Set<ID> regids, Map<ID, Farm_VIP_Registration__c> cmap){

        List<ID> vipids = new List<ID>();                               // List of all FARM VIP ids.
        vipids.addAll(regids);              
        VIP_Purina_Account__c Purina_Account = VIP_Purina_Account__c.getOrgDefaults();  // AccountId__c -- field we need. Contact_Record_Type__c
        List<Opportunity>   rel_opps    = new List<Opportunity>();      // List of all opportunities that need to be updated.
        List<Contact>       rel_cons    = new List<Contact>();          // All of the contacts that will need to be updated.
        List<User>          rel_users   = new List<User>();             // All of the Hosts (Users) that COULD be updated.      
        List<ID>            contactids  = new List<ID>();                           
        List<ID>            userids     = new List<ID>();                           
        
        List<CampaignMember> cMems = new List<CampaignMember>();
        
        Map<ID, User>                   id_to_user = new Map<ID, User>();                               
        Map<ID, Contact>                id_to_con = new Map<ID, Contact>();
        Map<ID, List<Opportunity>>      farm_to_opps = new Map<ID, List<Opportunity>>();
        Map<ID, List<CampaignMember>>   camp_to_mems = new Map<ID, List<CampaignMember>>();

        for(id i : vipids){
            Farm_VIP_Registration__c temp = cmap.get(i);
            userids.add(temp.OwnerId);          // Host is the owner of the record.
            contactids.add(temp.Registrant__c); // Contact related to the registrant record. 
        }

        // Get all of the related contacts, users, and opportunities.  
        
        rel_cons = [SELECT ID, Name, User_Record__c, Email, MobilePhone, Phone, FirstName, LastName FROM Contact WHERE ID IN : contactids];
        rel_opps = [SELECT ID, CampaignId, Farm_VIP_Registration__c FROM Opportunity WHERE Farm_VIP_Registration__c IN : regids];

        for(Contact c : rel_cons){
            if(c.User_Record__c != null){
                userids.add(c.User_Record__c);
            }
        }

        rel_users = [SELECT ID, Name, ContactId, MobilePhone, Email, FirstName, LastName FROM User where ID IN : userids];

        List<Contact> user_cons = [SELECT ID, Name, User_Record__c, Email, MobilePhone, Phone, FirstName, LastName FROM Contact WHERE User_Record__c IN : userids];
        Map<ID, Contact> uc_id_con = new Map<ID, Contact>();    // map for the user. 
        
        for(Contact c : user_cons){
            uc_id_con.put(c.User_Record__c, c);
        }

        for(User u : rel_users){
            id_to_user.put(u.id, u);    // Map Users.
        }
        for(Contact c : rel_cons){
            id_to_con.put(c.id, c);     // Map Contacts. 
        }

        // Map the opportunities to their Farm VIP Registration record.  
        if(rel_opps.size() > 0){
            for(Opportunity o : rel_opps){
                if(farm_to_opps.containsKey(o.Farm_VIP_Registration__c)){
                    List<Opportunity> temp_opps = farm_to_opps.get(o.Farm_VIP_Registration__c);
                    temp_opps.add(o);
                }else{
                    List<Opportunity> temp_opps = new List<Opportunity>();
                    temp_opps.add(o);
                    farm_to_opps.put(o.Farm_VIP_Registration__c, temp_opps);
                }
            }
        }

        cMems = [SELECT ID, CampaignId, ContactId, Name, Status FROM CampaignMember WHERE CampaignId IN : vipids];
        // Map the Campaign to the campaign members. 
        if(camp_to_mems.size() > 0){
            for(CampaignMember cm : cMems){
                if(camp_to_mems.containsKey(cm.CampaignId)){
                    List<CampaignMember> t_camps = camp_to_mems.get(cm.CampaignId);
                    t_camps.add(cm);
                }else{
                    List<CampaignMember> t_camps = new List<CampaignMember>();
                    t_camps.add(cm);
                    camp_to_mems.put(cm.CampaignId, t_camps);
                }
            }
        }

        Set<CampaignMember> camps_insert  = new Set<CampaignMember>();  // List of CampaignMembers for Insert. 
        List<Opportunity>   opps_update   = new List<Opportunity>();    // List of Opportunities for Insert. 

        for(id i : vipids)// Loop through the registration records.
        {   
            Farm_VIP_Registration__c temp = cmap.get(i);        // temp         = Current Registration
            List<Opportunity> opps = farm_to_opps.get(i);       // opps         = List of Opportunities related to the Regitstration
            id cur_event_id = temp.Farm_VIP_Event__c;           // cur_event_id = Current Event ID 

            // SET THE OPPORTUNITY PRIMARY CAMPAIGN TO THE FARM VIP REGISTRANT RECORD.
            if(opps != null){
                if( opps.size() > 0 ){
                    for(Opportunity o : opps){
                        o.CampaignId = temp.Farm_VIP_Event__c;
                        opps_update.add(o);
                    }
                }
            }
            
            // ADD THE CONTACT(HOST) AS AN EVENT MEMBER TO THE FARM VIP CUSTOMER EVENT.
            CampaignMember c = new CampaignMember();
            c.CampaignId = temp.Farm_VIP_Event__c;
            c.ContactId = temp.Registrant__c;
            c.Farm_VIP_Registration__c = temp.id;
            c.Status = 'Registered';
            camps_insert.add(c);
             system.debug('sreenath+++'+temp.Related_Contact_Ids__c );
            // ADD RELATED CONTACTs AS CAMPAIGN MEMBERS TO THE EVENT.
            if(temp.Related_Contact_Ids__c != null && temp.Related_Contact_Ids__c != ''){
           
                string str =  temp.Related_Contact_Ids__c; //INC2447541 FIX
                List<String> rel_con_ids = str.split(',');
                for(String s : rel_con_ids){
                    if(string.isNotBlank(s)) //INC2447541 FIX
                     {                         //INC2447541 FIX
                     if(s.contains('null') == false || s!='null'){ //INC2447541 FIX
                    CampaignMember new_camp = new CampaignMember();
                    new_camp.CampaignId = temp.Farm_VIP_Event__c;
                    new_camp.ContactId  = s;
                    new_camp.Farm_VIP_Registration__c = temp.id;
                    new_camp.Status = 'Registered';
                    camps_insert.add(new_camp);
                    }//INC2447541 FIX
                  }//INC2447541 FIX
                }
                SYSTEM.DEBUG('DEBUG:: RELATED CONTACTS TO BE ADDED AS EVENT MEMBERS : ' + camps_insert);
            }
            
            // CHECK THE HOST CREDENTIALS AND DETERMINE IF YOU NEED TO ADD IT.  
            if(temp.Host_will_be_attending__c == 'Yes'){            // Host will physically be present. 

                User t_user = id_to_user.get(temp.OwnerId);         // Get current user. 
                Contact tt_con = uc_id_con.get(t_user.id);          // Get contact associate to the user.

                if(tt_con != null){                                 // Make sure user has a contact. 
                    //Contact t_contact = id_to_con.get(t_user.ContactId);
                    SYSTEM.DEBUG('debug: user already has contact : ' + tt_con );
                    Contact t_contact = tt_con;
                    List<CampaignMember> t_cmems = camp_to_mems.get(cur_event_id);// Get the list of current campaign members related to the FARM VIP record.
                    Boolean already_exists = false;
                    for(CampaignMember cm : cmems){
                        if(cm.contactId == t_contact.id){
                            already_exists = true;                              // There is already a campaign member associated to this contact and Campaign.
                        }
                    }

                    if(already_exists == true){
                    // If campaign member allready exists DONT ADD IT. -- continue. 
                        SYSTEM.DEBUG('******CAMPAIGN MEMBER ALLREADY EXISTS -- DON\'T ADD HIM!');
                    }else{
                        // Campaign member doesn't exits ... add the campaign member.
                        CampaignMember host_camp = new CampaignMember();
                        host_camp.CampaignId = temp.Farm_VIP_Event__c;
                        //host_camp.ContactId = temp.Registrant__c;
                        host_camp.ContactID = t_contact.id;
                        host_camp.Farm_VIP_Registration__c = temp.id;
                        host_camp.Status = 'Registered';
                        camps_insert.add(host_camp);
                        SYSTEM.DEBUG('debug:: camps_insert :: ' + camps_insert);
                    }

                }else{      // User has no contact ( create one and add it.)
                            // *** CREATE NEW CONTACT **** FOR THE USER RECORD. 
                    Contact temp_contact = new Contact();
                    temp_contact.Phone = t_user.MobilePhone;
                    temp_contact.Email = t_user.Email;
                    temp_contact.FirstName = t_user.FirstName;
                    temp_contact.LastName = t_user.LastName;
                    temp_contact.AccountId = Purina_Account.AccountId__c;
                    temp_contact.RecordTypeId = Purina_Account.Contact_Record_Type__c;
                    if(Test.isRunningTest()==false){
                        temp_contact.User_Record__c = t_user.id;    
                    }
                    temp_contact.OwnerId = Purina_Account.Contact_Owner_ID__c;
                    //temp_contact.OwnerId = UserInfo.getUserId();
                    SYSTEM.DEBUG('TEMP CONTACT BEFORE INSERT ' + temp_contact);
                    try{
                        insert temp_contact;    // add contact -- MOVE This logic out of loop later (will only fire once). ******
                    }catch(DmlException e){
                        SYSTEM.DEBUG('Error occured on insert (Contact). ' + e.getMessage());
                    }

                    SYSTEM.DEBUG('TEMP CONTACT AFTER INSERT ' + temp_contact);
                    CampaignMember host_camp = new CampaignMember();
                    host_camp.Farm_VIP_Registration__c = temp.id;
                    host_camp.CampaignId = temp.Farm_VIP_Event__c;
                    host_camp.ContactId = temp_contact.id;
                    host_camp.Status = 'Registered';
                    camps_insert.add(host_camp);
                    SYSTEM.DEBUG('debug:: camps_insert :: ' + camps_insert);
                }
                SYSTEM.DEBUG('OMG Becky the host will be attending this event!');
            }   // END CHECKING CAMPAIGN MEMBER FOR HOST.           
            
        }// END FOR LOOP (ID in VIPS).

        // UPDATE opportunities, Insert CampaignMembers.
        if( opps_update.size() > 0 ){   
            try{
                update opps_update; 
            }catch(DmlException e){
                SYSTEM.DEBUG('Error occured : updating opportunities: ' + e.getMessage());
            }
        }

        // MOVE CONTACT INSERT LOGIC HERE.
        // NEED TO ADD THE CONTACTS THAT MIGHT NOT EXITS BEFORE INSERTING THE CAMPAIGN MEMBERS. 
        // WILL NEED TO RELATE THE INSERTED CONTACT IDS TO THEIR CAMPAIGN MEMBERS IF THERE ARE SOME. 

        SYSTEM.DEBUG('debug:: set of campaigns before insert:: ' + camps_insert);
        List<CampaignMember> list_camp_insert = new List<CampaignMember>();

        list_camp_insert.addAll(camps_insert);

        List<ID> ccoonn = new List<ID>();
        List<ID> camppp = new List<ID>();
        for(CampaignMember cm : list_camp_insert){
            ccoonn.add(cm.ContactID);
            camppp.add(cm.CampaignId);
        }
        List<CampaignMember> compareTo = [SELECT id, ContactId, CampaignId FROM CampaignMember WHERE Contactid IN : ccoonn OR CampaignId IN : camppp];
        List<CampaignMember> badCM = new List<CampaignMember>();

        // pull out all bad CampaignMembers
        for(CampaignMember c : compareTo){
            for(CampaignMember ic : list_camp_insert){
                if(c.CampaignId == ic.CampaignId && c.ContactID == ic.ContactID){
                    // throw errror duplicate.
                    badCM.add(ic);
                }
            }
        }


        if(badCM.size() > 0){
            List<CampaignMember> del_dup = new List<CampaignMember>();

            for(CampaignMember cc : list_camp_insert){
                boolean addtolist = true;
                for(CampaignMember c : badCM){
                    if(cc.ContactId == c.ContactID && cc.Campaignid == c.Campaignid){
                        addtolist = false;
                    }
                }
                if(addtolist == true){
                    del_dup.add(cc);
                }
            }
            list_camp_insert.clear();
            list_camp_insert.addAll(del_dup);
        }
        

        SYSTEM.DEBUG('BADCM :: ' + badCM);

        if( list_camp_insert.size() > 0){
            try{
                //database.insert(list_camp_insert, false);
                insert list_camp_insert;
            }catch(DmlException e){
                SYSTEM.DEBUG('Error occured : inserting CampaignMembers: ' + e.getMessage() );
                SYSTEM.DEBUG('Error occured : # of records affected : ' + e.getNumDml() );
                //List<CampaignMember> currr = [SELECT id, ContactID, Campaignid from CampaignMember];  ////INC2447541 FIX
               //system.debug('cur camsp ::::::: ' +currr);
            }
        }
        SYSTEM.DEBUG('END OF MAKE APPROVAL UPDATES --CLASS-- Farm_VIP_Approval');
    }// END OF MakeApprovalUpdates



}