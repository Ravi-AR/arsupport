/******************************************************************************
 * Utility class to perform roll up summaries on the campaign object after 
 * Campaigns or Opportunities are updated.
 *
 * @Author: Magnet 360
 * @Date: 06/30/2015
 * @Last Modified By: Yogendra Rathi
 * @Date: 03/22/2016
 
 */
public class LOL_Campaign_Rollup {

/******************************************************************************
 *      @Params : List<Campaign> newList - list of campaigns that have been updated.
 *
 *      @return : void - rolls up campaigns points and tons field based on the 
 *                  child opportunities.
 */
    public void rollUpCampaigns_campaign(List<Campaign> newList){
        
        List<ID> campids = new List<ID>();  // campaign ids for query.

        for(Campaign c : newList){
            campids.add(c.id);              // Add current campaign id - 
            if(c.ParentId != null){
                campids.add(c.ParentId);    // Add parent campaign id if it exits.
            }
        }

        // List of campaigns that have been edited and their parent campaigns -- 
        List<Campaign> cur_and_parents = [SELECT id, Name, ParentId, Rollup_Annual_Points__c, Rollup_Annual_Tons__c, LastModifiedDate, Rollup_Won_Points__c, Rollup_Won_Tons__c, Total_Converted_Producers__c
                                        FROM Campaign
                                        WHERE id IN : campids OR ParentId IN : campids];
            // Global lists might need some trimming. 
        // Global query of all campaigns -- Map everything.
        List<Campaign> all_campaigns = [SELECT id, Name, ParentId, Rollup_Annual_Points__c, Rollup_Annual_Tons__c, LastModifiedDate, Rollup_Won_Points__c, Rollup_Won_Tons__c, Total_Converted_Producers__c
                                        FROM Campaign];
        // Global query of all opportunities -- Map everything. 
        List<Opportunity> all_opportunities = [SELECT id, Name, Annual_Points__c, Annual_Tons__c, CampaignId, StageName, AccountId
                                                    FROM Opportunity WHERE campaignId != null];
        // recursively get all of the parents. 
        List<Campaign> cfu = getAllParents(cur_and_parents, all_campaigns);
        Set<Campaign> temp_camps = new Set<Campaign>();
        temp_camps.addAll(cfu);
        List<Campaign> camps_for_update = new List<Campaign>();
        camps_for_update.addAll(temp_camps);


        // Now that we have all Campaigns that need to be updated get their children and total up their opportunities.
        List<Campaign> update_campaigns = new List<Campaign>();

        for(Campaign c : camps_for_update){

            List<Campaign> child_campaigns = getAllChildren(c, all_campaigns);
            List<Opportunity> child_opportunities = getAllRelatedOpportunities(child_campaigns, all_opportunities);

            // loop through the opportunities and total their values.
            Decimal t = 0;          // tons
            Decimal p = 0;          // points
            Decimal cw_t = 0;       // Closed won tons
            Decimal cw_p = 0;       // Closed won points

            Set<ID> opp_accountids = new Set<ID>();

            for(Opportunity o : child_opportunities){
// TODO: ADD NULL CHECKS FOR THE POINTS AND TOTAL VALUES.  
                if(o.Annual_Tons__c != null){
                    t += o.Annual_Tons__c;
                }
                if(o.Annual_Points__c != null){
                    p += o.Annual_Points__c;
                }
                            
                if(o.StageName == 'Closed Won'){
                    if(o.Annual_Tons__c != null){
                        cw_t += o.Annual_Tons__c;
                    }
                    if(o.Annual_Points__c != null){
                        cw_p += o.Annual_Points__c;
                    }
                    opp_accountids.add(o.AccountId);
                }
            }
            c.Rollup_Annual_Points__c   =   p;
            c.Rollup_Annual_Tons__c     =   t;
            c.Rollup_Won_Tons__c        =   cw_t;
            c.Rollup_Won_Points__c      =   cw_p;
            c.Total_Converted_Producers__c = opp_accountids.size();

            SYSTEM.DEBUG('LASTMODIFIED : ' + c.LastModifiedDate + ' current time -1 ' + system.now().addSeconds(-5));
            if(c.LastModifiedDate > System.now().addSeconds(-5)){
                system.debug('this record was just updated less than 5 seconds ago. ' + c.id + ' ' + c.Name);
            }else{  
                update_campaigns.add(c);
            }
        }

        SYSTEM.DEBUG('these are the campaigns for update ' + update_campaigns);
        try{
            update update_campaigns;
        }catch(DMLException e){
            SYSTEM.DEBUG('Error on updating Campaigns : ' + e.getMessage());
        }
    }

/***********************************************************************************
*       @Param  :   List<Opportunity> newList -- list of opportunities being updated 
*
*       @Return :  void  -- updates campaigns -- calls rollUpCampaigns_campaign
*/
public void rollUpCampaigns_Opportunities(List<Opportunity> newList){

    List<ID> cam_ids = new List<ID>();  // campaign ids related to the opportunities --

    for(Opportunity o : newList){
        cam_ids.add(o.CampaignId);
    }
    SYSTEM.DEBUG('THIS IS THE OPPORTUNITY LIST ' + newList);
    // Query Camapigns that will need to be updated.
    List<Campaign> related_camps = [SELECT id, Name, ParentId, Rollup_Annual_Points__c, Rollup_Annual_Tons__c, LastModifiedDate, Rollup_Won_Points__c, Rollup_Won_Tons__c, Total_Converted_Producers__c
                                        FROM Campaign
                                        WHERE id IN : cam_ids];
    CampaignTriggerHandler.isCampaignOppTrgRecursive = true;//INC2447541 Fix
    rollUpCampaigns_campaign(related_camps);
}

// Method to check for diassociated opportunities. 
/***********************************************************************************
 * @Param : Map<ID, Opportunity> newM  - new map of the updated Opportunities.
 * @Param : Map<ID, Opportunity> oldM  - values of the opportunity before it was updated.
 *
 * @Return : void -- if the opportunities campaignID have been changed -- calculate new values (subract the old ones).
 */
public void rollUpCampaigns_Opportunities(Map<ID, Opportunity> newM, Map<ID, Opportunity> oldM){
    SYSTEM.DEBUG('NEWLIST ' + newM);
    SYSTEM.DEBUG('OLDLIST ' + oldM);


    List<ID> abandoned_ids = new List<ID>();


    for(ID oid : newM.keySet()){
        Opportunity new_opp = newM.get(oid);
        Opportunity old_opp = oldM.get(oid);

        if(new_opp.campaignId != old_opp.campaignId){
            if(new_opp.campaignId != null){
                abandoned_ids.add(new_opp.CampaignId);
            }
            if(old_opp.campaignId != null){
                abandoned_ids.add(old_opp.CampaignId);
            }
        }
    }

    if(abandoned_ids.size() > 0){
        List<Campaign> related_campaigns = [SELECT id, Name, ParentId, Rollup_Annual_Points__c, Rollup_Annual_Tons__c, LastModifiedDate, Rollup_Won_Points__c, Rollup_Won_Tons__c, Total_Converted_Producers__c
                                            FROM Campaign
                                            WHERE id IN : abandoned_ids];
        rollUpCampaigns_campaign(related_campaigns);
    }
}




/***********************************************************************
*   @ params : this_campaign - current campaign to get all children for.
*            : globalList   - current List of all campaigns.
*
*   @ return : return's a list of this_campaigns's child campaigns.
*/
    public List<Campaign> getAllChildren(Campaign this_campaign, List<Campaign> globalList){

        // for the current campaign - get all of the immidate children.
        List<Campaign> camp_and_childs = new List<Campaign>();
        List<Campaign> decrement = new List<Campaign>();

        camp_and_childs.add(this_campaign);     // add to the global list of campaigns.  
        decrement.add(this_campaign);

        Campaign cur_campaign = this_campaign;

        //RECURSIVE LOOP.
        while(decrement.size() > 0){

            cur_campaign = decrement[0];    // first time through this should be the campaign comming in.
            List<Campaign> children = getChildCampaigns(cur_campaign, globalList);

            SYSTEM.DEBUG('CHILD CAMPAIGN SIZE : ' + children.size() + ' cur campaign : ' + cur_campaign.Name);
            if(children.size() > 0){
                camp_and_childs.addAll(children);
                decrement.addAll(children);
            }
            decrement.remove(0);
        }

        SYSTEM.DEBUG('allChildren returning : ' + camp_and_childs.size() );
        return camp_and_childs;
    }

/***********************************************************************
*   @ params : cur_campaign - current campaign to get childeren for.
*            : globalList   - current List of all campaigns.
*
*   @ return : return's a list of all childeren campaigns. 
*/
    public List<Campaign> getChildCampaigns(Campaign cur_campaign, List<Campaign> globalList){
        
        List<Campaign> children = new List<Campaign>();     // return list of childeren campaigns.

        for(Campaign c : globalList){
            if(c.parentId == cur_campaign.id){
                // The campaign's parent id is equal to the current campaign we are looking for - thus it is a child. - add it.
                children.add(c);
            }
        }
        return children; 
    }

/***********************************************************************
*   @ params : cur_campaign - current campaign to get related opps for.
*            : globalList   - current List of all opportunities.
*
*   @ return : return's a list of all related Opportunities. 
*/
    public List<Opportunity> getRelatedOpportunities(Campaign cur_campaign, List<Opportunity> globalList){
        
        List<Opportunity> rel_opps = new List<Opportunity>();       // return list of childeren campaigns.

        for(Opportunity o : globalList){
            if(o.campaignId == cur_campaign.id){
                rel_opps.add(o);
            }
        }
        return rel_opps; 
    }

/***********************************************************************
*   @ params : camps - list of campaigns to get all associated records for.  
*            : globalList   - current List of all opportunities.
*
*   @ return : return's a list of all related Opportunities. 
*/
    public List<Opportunity> getAllRelatedOpportunities(List<Campaign> camps, List<Opportunity> globalList){

        List<ID> campaignids = new List<ID>();
        Map<ID, Campaign> id_to_camp = new Map<ID, Campaign>();

        List<Opportunity> opps = new List<Opportunity>();

        for(Campaign c : camps){
            campaignids.add(c.id);
            id_to_camp.put(c.id, c);
        }

        for(opportunity o : globalList){
            // make sure campaign id is not null.
            if(o.campaignId != null){
                if( id_to_camp.containsKey(o.campaignId) ){
                    opps.add(o);
                }
            }
        }
        return opps;
    }

/***********************************************************************
*   @ params : newList - current campaigns that have been edited.
*            : globalList   - current List of all campaigns.
*
*   @ return : return's a list of all parent campaigns. 
*/
public List<Campaign> getAllParents(List<Campaign> newList, List<Campaign> globalList){
        
        List<Campaign> camp_and_parents = new List<Campaign>();
        List<Campaign> decrement = new List<Campaign>();

        camp_and_parents.addAll(newList);
        decrement.addAll(newList);

        Campaign cur_camp = new Campaign();

        // Start recursion.
        while(decrement.size() > 0){
            cur_camp = decrement[0];
            
            if(cur_camp.ParentId != null){
                List<Campaign> parents = getParentCampaign(cur_camp, globalList);
                decrement.addAll(parents);
                camp_and_parents.addAll(parents);
            }
            decrement.remove(0);
        }
        SYSTEM.DEBUG('METHOD: getAllParents : RETURNING : camps for update: ' + camp_and_parents);
        return camp_and_parents;
}

/***********************************************************************
*   @ params : cur_camp - current campaign to get parent for.
*            : globalList   - current List of all campaigns.
*
*   @ return : return's a list of cur_camps parent campaign.
*/
public List<Campaign> getParentCampaign(Campaign cur_camp, List<Campaign> globalList){
    List<Campaign> parents = new List<Campaign>();

    for(Campaign c : globalList){
        if(c.id == cur_camp.ParentId){
            parents.add(c);
        }
    }
    return parents;
}


/****************************CALUCLATE TOTAL HEAD VIA CUSTOM SETTTINGS********************/
/***********************************************************************
*   @ params : LIST<Opportunity> before insert
*   @ return : void 
*/

/*  CUSTOM SETTINGS.
LIFESTAGE CUSTOM SETTING
Animal_LS_and_Type_To_Account_Field__c:{
    Name=Aqua
    Calculated_VIP_Points__c=0.18
    Account_Animal_Count_Field__c=LS_Total_Aqua_Companion__c
    Amimal_Type__c=Companion
    Life_Stage__c=Aqua
 } 
ANIMAL TYPE CUSTOM SETTING
Animal_Type_to_Account_Fields__c:{
    Account_Animal_Count_Field__c=Type_Total_Companion_Animals__c
    Account_Animal_Served_Field__c=Type_Total_Companion_Animals_Fed__c
    Name=Companion
 }
*/
 public void CalculatePoints(List<Opportunity> newList){
    SYSTEM.DEBUG('Calculate total head hit ');
    Map<String, Animal_LS_and_Type_To_Account_Field__c> lifeStage = Animal_LS_and_Type_To_Account_Field__c.getAll();
    //Map<String, Animal_Type_to_Account_Fields__c> animalType = Animal_Type_to_Account_Fields__c.getAll();

        List<ID> oids = new List<ID>();
        for(Opportunity o : newList){
            oids.add(o.id);
        }

        List<Opportunity> oppsfor_update = [SELECT id, Annual_Points__c, StageName, Life_Stage__c, Species__c, Total_Head__c, RecordType.DeveloperName FROM Opportunity WHERE id IN : oids];
        List<Opportunity> update_opps = new List<Opportunity>();

        for(Opportunity o : oppsfor_update){

            // Wrap in check agianst custom settings.
            if(AnimalType_OpportunityRT_OKAY(o)==true){
                Animal_LS_and_Type_To_Account_Field__c life = lifeStage.get(o.Life_Stage__c);
                if(life == null){
                    life = lifeStage.get(o.Life_Stage__c + ' - ' + o.Species__c);
                }
                //Animal_Type_to_Account_Fields__c aType = animalType.get(o.Species__c);
                //SYSTEM.DEBUG('this is lyfe : ' + life + ' animal type ' + atype);
                SYSTEM.DEBUG('THIS IS THE LIFESTAGE ' + o.Life_Stage__c);

                // CHEck to see if the opportunity is open ( no closed )
                //** BY Yogendra Rathi Dated 03/22/2016: comment below line to count anuual point for all stages.
                //if(o.StageName != 'Closed Won' && o.StageName != 'Closed Lost')
                {
                    if(life != null){
                        if(o.Annual_Points__c != (life.Calculated_VIP_Points__c * o.Total_Head__c)){
                            o.Annual_Points__c = life.Calculated_VIP_Points__c * o.Total_Head__c;
                            update_opps.add(o);
                        }else{
                            SYSTEM.DEBUG('OPPORTUNITY ALLREADY HAS A GOOD VALUE');
                        }
                    }else{
                        if(o.Annual_Points__c != 0.00){
                            o.Annual_Points__c = 0.00;
                            update_opps.add(o);
                        }
                    }
                }
            }

        }//end Opportunity loop.

        try{
            update update_opps;
        }catch(DmlException e){
            SYSTEM.DEBUG('ERROR ON UPDATE OPPORTUNITIES : '+ e.getMessage());
        }


 }

 //CHECK TO MAKE SURE THE ANIMAL TYPE AND THE RECORD TYPE ON THE OPPORTUNITY ARE OKAY (CUSTOM SETTINGS).
 //returns TRUE to proceede on (the animal type isn't bad, caclulcate the points)
 public Boolean AnimalType_OpportunityRT_OKAY(Opportunity o){

    // custom setting of list of opportunity types that we shouldn't include. 
    VIP_Purina_Account__c Purina_Account = VIP_Purina_Account__c.getOrgDefaults();
    List<String> exclude_AT = new List<String>();
    List<String> exclude_O_RT = new List<String>();

    if(Purina_Account.Bad_Animal_Type_Values__c != null){
        exclude_AT = Purina_Account.Bad_Animal_Type_Values__c.split(',');
    }
    if(Purina_Account.Bad_Opportunity_Record_Types__c != null){
        exclude_O_RT = Purina_Account.Bad_Opportunity_Record_Types__c.split(',');
    }
    
    Boolean ret = true;

    if(exclude_AT.size() > 0){
        for(String s : exclude_AT){
            if(o.Species__c == s){
                ret = false;
            }
        }
    }

    if(exclude_O_RT.size() > 0){
        for(String s : exclude_O_RT){
            if(o.RecordType.DeveloperName == s){
                ret = false;
            }
        }
    }
    
    return ret;
 }



}// END Class.