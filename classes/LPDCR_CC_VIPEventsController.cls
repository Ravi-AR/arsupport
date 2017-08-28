/**
*   @Author:    Heena Tanna
*   @Date:      16.03.2017
*   @Jira:      LPDCR-2064
*   @Purpose:   Controller behind LPDCR_CC_EventsPlanning
*/


public without sharing class LPDCR_CC_VIPEventsController extends LPDCR_ComponentBaseController  {
    
    
    /*public List<String> species_filter { get; set; }
    public String search_term { get; set; }
    public String sort_filter { get; set; }*/
    public static String TYPE_NATIONAL_VIP = 'National VIP';//Farm VIP Event
    public static String TYPE_DEALER_TRAINING = 'Dealer/Training VIP';
    //public static String TYPE_NATIONAL = 'National'; //National Event
    public static String STATUS_PLANNED ='Planned';
    public static String STATUS_REGISTRATIONOPEN ='Registration Open';
    public static String STATUS_REGISTRATIONCLOSED ='Registration Closed';
    //public List<Campaign> campList_farm {get;set;}
    //public List<Campaign> campList_nationalevent {get;set;}
    //public Map<String, Document> vipDocumentsMap { get; set; }
    public List<Campaign> campList_homepage {get;set;}
    
    
   
    //@TestVisible private Campaign camp;
    /*
    Set<String> camNatType = new Set<String>{TYPE_NATIONAL};//National Event
    Set<String> camNatStatus = new Set<String>{STATUS_PLANNED};//National Event*/
    Set<String> camFarmVipType = new Set<String>{TYPE_NATIONAL_VIP,TYPE_DEALER_TRAINING};//Farm VIP Event
    Set<String> camFarmVipStatus = new Set<String>{STATUS_PLANNED,STATUS_REGISTRATIONOPEN,STATUS_REGISTRATIONCLOSED};//Farm VIP Event
    /** Constructor**/
    public LPDCR_CC_VIPEventsController(){
        
       //getFarmVipLst();
        getHomepageCampaigns();
        //getNationalEventLst();
    }
      
        //To fetch latest 2 record for homepage component 
        public void getHomepageCampaigns(){
            try{
                    campList_homepage =[SELECT Id,Name,Date_of_Event__c,EndDate,Event_Date_Range__c,Short_Description__c,Type,Status
                    FROM Campaign WHERE (RecordType.DeveloperName =:  LPDCR_Constants.CONS_FARMVIPEVENTS AND 
                    Type IN:camFarmVipType AND Display_in_Dealer_Community__c = true
                    AND Status IN:camFarmVipStatus AND EndDate >= TODAY) ORDER BY Date_of_Event__c limit 2];

            }
            
            catch(Exception ex){
                System.debug('Exception homepage Occured--'+ ex);
                
            }
            
        } 
     
        
         //FARM VIP EVENTS   
       /* public void getFarmVipLst(){
        try{
            campList_farm =[ SELECT Id, Name, Date_of_Event__c,EndDate,Short_Description__c,Type,Status,Event_Location__c,Event_Date_Range__c,
                                ( SELECT Id, Document_Name__c, DocumentDeveloperName__c, DocumentFolderDeveloperName__c FROM Customer_Event_Metadata__r WHERE MetadataType__c = 'Download PDF' AND Display_Start_Date__c <= TODAY AND Display_End_Date__c >= TODAY ORDER BY Display_Order_for_Type__c)
                            FROM Campaign WHERE ( IsActive = true AND RecordType.DeveloperName =: LPDCR_Constants.CONS_FARMVIPEVENTS AND Type IN:camFarmVipType AND Status IN:camFarmVipStatus AND EndDate >= TODAY ) ORDER BY Date_of_Event__c];
           
           System.debug('lst campList_farm ---'+ campList_farm ); 
                                                 // Query for the actual document
                                                 // records matching the Customer_Event_Metadata__r
                                                 // records
            vipDocumentsMap = new Map<String,Document>();
            List<String> l_campaign_doc_names = new List<String>();
            for( Campaign l_c : campList_farm )
            {
                for( CustomerEventMetadata__c l_doc : l_c.Customer_Event_Metadata__r )
                {
                    l_campaign_doc_names.add( l_doc.DocumentDeveloperName__c );
                }
            }
            for( Document l_d : [ SELECT Id, DeveloperName FROM Document WHERE DeveloperName IN :l_campaign_doc_names ] )
            {
                vipDocumentsMap.put( l_d.DeveloperName, l_d );
            }
            System.debug('vipDocumentsMap = ' + vipDocumentsMap );
           
        }
        catch(Exception ex){
        System.debug('Exception FarmVIPOccured--'+ ex);
       
        }
      }*/
      
      //National Events
     /* public void getNationalEventLst(){
        try{
            campList_nationalevent =[SELECT Id,Name,Date_of_Event__c,EndDate,Short_Description__c,Type,Status,Event_Location__c,Event_Date_Range__c
                    FROM Campaign WHERE ( IsActive = true AND RecordType.DeveloperName =:  LPDCR_Constants.CONS_NATIONALEVENTS AND Type IN:camNatType AND Status IN:camNatStatus AND EndDate >= TODAY ) ORDER BY Date_of_Event__c];
           
           System.debug('National campList ---'+ campList_nationalevent ); 
        }
        catch(Exception ex){
        System.debug('Exception National Event Occured--'+ ex);
       
        }
      }*/
      
}