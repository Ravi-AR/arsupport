/**
*   @Author:    Heena Tanna
*   @Date:      04.05.2017
*   @Jira:      LPDCR-2471
*   @Purpose:   Controller behind LPDCR_SecondaryVIPFarm Component
*/

public without sharing class LPDCR_SecondaryVIPFarmController extends LPDCR_ComponentBaseController {
    
    public List<String> species_filter { get; set; }
    public String search_term { get; set; }
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    public static String TYPE_NATIONAL_VIP = 'National VIP';//Farm VIP Event
    public static String TYPE_DEALER_TRAINING = 'Dealer/Training VIP';
    public List<Campaign> campList_farm {get;set;}
    public static String STATUS_PLANNED ='Planned';
    public static String STATUS_REGISTRATIONOPEN ='Registration Open';
    public static String STATUS_REGISTRATIONCLOSED ='Registration Closed';
    public Map<String, Document> vipDocumentsMap { get; set; }
    Set<String> camFarmVipType = new Set<String>{TYPE_NATIONAL_VIP,TYPE_DEALER_TRAINING};//Farm VIP Event
    Set<String> camFarmVipStatus = new Set<String>{STATUS_PLANNED,STATUS_REGISTRATIONOPEN,STATUS_REGISTRATIONCLOSED};//Farm VIP Event
    public Boolean internal_only{get;set;}
    public static String sortBy { get; set; }
    public List<CampaignWrapper> campaignWrapperList{get;set;}
    public Boolean init{
    get{
        getFarmVipLst();
        return false;
       }
    }
   
    
    
    public LPDCR_SecondaryVIPFarmController(){
       // getFarmVipLst();
       species_filter = new List<String>();
        
    }
    
    /***
    **Wrapper class for sorting campaigns
    ***/
     public class CampaignWrapper implements Comparable{
        
        
        //public String Name{get;set;}
        public Campaign camp{get;set;}
       
        
        public CampaignWrapper(Campaign cam){
         camp= cam;
        }
        public CampaignWrapper(){
        }
        public integer compareTo( Object a_compare_to ){
            
            CampaignWrapper campSort = (CampaignWrapper)a_compare_to;
            
           if( LPDCR_SecondaryVIPFarmController.sortBy.equals( 'Date DESC' ) )
            {
               
                if(camp.Date_of_Event__c != null && campSort.camp.Date_of_Event__c !=null && camp.Date_of_Event__c < campSort.camp.Date_of_Event__c )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
            else if( LPDCR_SecondaryVIPFarmController.sortBy.equals( 'Date ASC' ) )
            {
                if(camp.Date_of_Event__c != null && campSort.camp.Date_of_Event__c !=null && camp.Date_of_Event__c > campSort.camp.Date_of_Event__c )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }       
            }
            if(LPDCR_SecondaryVIPFarmController.sortBy.equals('Name DESC'))
            {
                if(camp.Name != null && campSort.camp.Name !=null && camp.Name < campSort.camp.Name){
                return 1;
                }
                else{
                return 0;
                }
            }
            else{ //NAME ASC
                if(camp.Name != null && campSort.camp.Name !=null && camp.Name > campSort.camp.Name){
                return 1;
                }
                else{
                return 0;
                }
            }

        }

      }//Wrapper class End
    
    
             //FARM VIP EVENTS   
        public void getFarmVipLst(){
        try{
            campList_farm =[ SELECT Id, Name, Date_of_Event__c,EndDate,Short_Description__c,Type,Status,Event_Location__c,Event_Date_Range__c,Specie_Focus__c,Display_in_Dealer_Community__c,
                                ( SELECT Id, Document_Name__c, DocumentDeveloperName__c, DocumentFolderDeveloperName__c FROM Customer_Event_Metadata__r WHERE MetadataType__c = 'Download PDF' AND Display_Start_Date__c <= TODAY AND Display_End_Date__c >= TODAY ORDER BY Display_Order_for_Type__c)
                            FROM Campaign WHERE (Display_in_Dealer_Community__c = true AND RecordType.DeveloperName =: LPDCR_Constants.CONS_FARMVIPEVENTS AND Type IN:camFarmVipType AND Status IN:camFarmVipStatus AND EndDate >= TODAY ) ORDER BY Date_of_Event__c DESC];
           
           
               
           
            System.debug('lst campList_farm ---'+ campList_farm ); 
            
            vipDocumentsMap = new Map<String,Document>();
               List<String> l_campaign_doc_names = new List<String>();
                for( Campaign l_c : campList_farm )
                {
                    System.debug('l_c------'+l_c);
                    if(l_c != null){
                        for( CustomerEventMetadata__c l_doc : l_c.Customer_Event_Metadata__r )
                        {
                            l_campaign_doc_names.add( l_doc.DocumentDeveloperName__c );
                        }
                    }
                }
                for( Document l_d : [ SELECT Id, DeveloperName FROM Document WHERE DeveloperName IN :l_campaign_doc_names ] )
                {
                    vipDocumentsMap.put( l_d.DeveloperName, l_d );
                }
                System.debug('vipDocumentsMap = ' + vipDocumentsMap );
                                                 // Query for the actual document
                                                 // records matching the Customer_Event_Metadata__r
                                                 // records
                
                //Filter Species                                 
               campList_farm  = LPDCR_ContentServiceUtil.filterCampaign(campList_farm,species_filter); 
               System.debug('filtered campList_farm' + campList_farm); 
               //Looping the campList_nationalevent for SortBy                                 
               campaignWrapperList = new List<CampaignWrapper>();
               for(Campaign c:campList_farm)
               {
                   if(c!=null){
                    campaignWrapperList.add(new CampaignWrapper(c));
                   }
               }
               if(sort_filter==null || sort_filter==''){
                   sort_filter='Date DESC';
               }
               LPDCR_SecondaryVIPFarmController.sortBy = sort_filter;
               campaignWrapperList.sort();
               System.debug('campList_farm---'+campaignWrapperList);                                     
               
               
            }
            catch(Exception ex){
            System.debug('Exception FarmVIPOccured--'+ ex);
           
            }
          }
      
     
      
    
}