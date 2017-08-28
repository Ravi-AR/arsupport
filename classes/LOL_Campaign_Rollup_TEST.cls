@isTest
public class LOL_Campaign_Rollup_TEST {

    static testMethod void insertOpportunity(){
        Campaign campC = new Campaign();
        campC.Name = 'temp Camp';
        campC.Rollup_Annual_Points__c   = 0;
        campC.Rollup_Annual_Tons__c     = 0;
        campC.Rollup_Won_Tons__c        = 0;
        campC.Rollup_Won_Points__c      = 0;
        insert campC;

        Campaign rel_camp = new Campaign();
        rel_camp.Name = 'related campaign';
        rel_camp.ParentId = campC.id;
        insert rel_camp;

        Opportunity op = new Opportunity();
        op.Name = 'temp opp';
        op.CampaignId = rel_camp.id;
        op.Annual_Points__c = 10.00;
        op.Annual_Tons__c   = 10.00;
        op.Species__c = 'Companion';
        op.Life_Stage__c = 'Aqua';
        op.StageName = 'Prospecting';
        op.CloseDate = date.today();
        insert op;

        Opportunity o = new Opportunity();
        o.Name = 'temp opp';
        o.CampaignId = campC.id;
        o.Annual_Points__c = 10.00;
        o.Annual_Tons__c   = 10.00;
        o.Species__c = 'Companion';
        o.Life_Stage__c = 'Aqua';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        insert o;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'temp opp';
        opp.CampaignId = campC.id;
        opp.Annual_Points__c = 10.00;
        opp.Annual_Tons__c   = 10.00;
        opp.StageName = 'Closed Won';
        opp.Species__c = 'Companion';
        opp.Life_Stage__c = 'Aqua';
        opp.CloseDate = date.today();
        Test.startTest();
        insert opp;
        List<Opportunity> ooo = [SELECT id, Name, Annual_Points__c, Annual_Tons__c, CampaignId, StageName
                                    FROM Opportunity];
        LOL_Campaign_Rollup test_util = new LOL_Campaign_Rollup();
        List<Opportunity> temp_opps = test_util.getRelatedOpportunities(campC, ooo);

        Campaign check = [select id, Name, Rollup_Annual_Points__c, Rollup_Annual_Tons__c 
                            FROM Campaign 
                            WHERE id =: campC.id];
        system.debug('this is the campaign ' + check);
        system.debug('this is the campaign ' + check.Rollup_Annual_Points__c);
        Test.stopTest();
    }


    // create some campaigns with opportunitie 
    static testMethod void updateCampaign(){

        //Integer start = System.Now().millisecond();
        //while(System.Now().millisecond()< start+1000){ 
        //}
        List<Campaign> cams = new List<Campaign>();
        List<Opportunity> opps = new List<Opportunity>();

        Campaign campC = new Campaign();
        campC.Name = 'temp Camp';
        campC.Rollup_Annual_Points__c   = 0;
        campC.Rollup_Annual_Tons__c     = 0;
        campC.Rollup_Won_Tons__c        = 0;
        campC.Rollup_Won_Points__c      = 0;
        cams.add(campC);
        //insert campC;

        Campaign rel_camp = new Campaign();
        rel_camp.Name = 'related campaign';
        rel_camp.ParentId = campC.id;
        //insert rel_camp;
        cams.add(rel_camp);

        Opportunity op = new Opportunity();
        op.Name = 'temp opp';
        op.CampaignId = rel_camp.id;
        op.Annual_Points__c = 10.00;
        op.Annual_Tons__c   = 10.00;
        op.Species__c = 'Companion';
        op.Life_Stage__c = 'Aqua';
        op.StageName = 'Prospecting';
        op.CloseDate = date.today();
        //insert op;
        opps.add(op);

        Opportunity o = new Opportunity();
        o.Name = 'temp opp';
        o.CampaignId = campC.id;
        o.Annual_Points__c = 10.00;
        o.Annual_Tons__c   = 10.00;
        o.Species__c = 'Companion';
        o.Life_Stage__c = 'Aqua';
        o.StageName = 'Prospecting';
        o.CloseDate = date.today();
        //insert o;
        opps.add(o);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'temp opp';
        opp.CampaignId = campC.id;
        opp.Annual_Points__c = 10.00;
        opp.Annual_Tons__c   = 10.00;
        opp.Species__c = 'Companion';
        opp.Life_Stage__c = 'Aqua';
        opp.StageName = 'Closed Won';
        opp.CloseDate = date.today();
        
        //insert opp;
        opps.add(opp);

        insert cams;
        //Integer start = System.Now().millisecond();
        //while(System.Now().millisecond()< start+6000){ 
        //}
        Test.startTest();
        insert opps;

        Campaign check = [select id, Name, Rollup_Annual_Points__c, Rollup_Annual_Tons__c 
                            FROM Campaign 
                            WHERE id =: campC.id];
        system.debug('DEBUG: CAMP' + check);
        system.debug('this is the campaign ' + check.Rollup_Annual_Points__c);
        delete opp;
        delete rel_camp;
        Test.stopTest();
    }

    static testMethod void animalType_confirmOpportunity(){
        TestHelper th = new TestHelper();
        VIP_Purina_Account__c test_custom = th.retrieveCustomSettings();
        
        //VIP_Purina_Account__c test_custom = new VIP_Purina_Account__c();
  //      test_custom.AccountId__c = '001g000000d9FPQAA2';
  //      test_custom.Contact_Owner_ID__c = '005g0000002FcvxAAC';
  //      test_custom.Contact_Record_Type__c = '012g0000000DTQOAA4';
  //      test_custom.Contact_Influencer_Type__c = 'Influencer,';
  //      test_custom.Bad_Animal_Type_Values__c = 'Non-Animal Opportunity,';
  //      test_custom.Bad_Opportunity_Record_Types__c = ',';
   //     insert test_custom;

        Campaign campC = new Campaign();
        campC.Name = 'temp Camp';
        campC.Rollup_Annual_Points__c   = 0;
        campC.Rollup_Annual_Tons__c     = 0;
        campC.Rollup_Won_Tons__c        = 0;
        campC.Rollup_Won_Points__c      = 0;
        insert campC;

        Opportunity opp = new Opportunity();
        opp.Name = 'temp opp';
        opp.CampaignId = campC.id;
        opp.Annual_Points__c = 10.00;
        opp.Annual_Tons__c   = 10.00;
        opp.Species__c = 'Companion';
        opp.Life_Stage__c = 'Aqua';
        opp.StageName = 'Closed Won';
        opp.CloseDate = date.today();
        insert opp;

        LOL_Campaign_Rollup util = new LOL_Campaign_Rollup();
        Boolean test = util.AnimalType_OpportunityRT_OKAY(opp);


    }

}