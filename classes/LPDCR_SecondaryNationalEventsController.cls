/**
*   @Author:    Heena Tanna
*   @Date:      04.05.2017
*   @Jira:      LPDCR-2471
*   @Purpose:   Controller behind LPDCR_SecondaryNationalEvents Component
*/
public without sharing class LPDCR_SecondaryNationalEventsController extends LPDCR_ComponentBaseController{
    
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
    public static String TYPE_NATIONAL = 'National'; //National Event
    public static String STATUS_PLANNED ='Planned';
    public List<Campaign> campList_nationalevent {get;set;}
    public Boolean internal_only{get;set;}
    Set<String> camNatType = new Set<String>{TYPE_NATIONAL};//National Event
    Set<String> camNatStatus = new Set<String>{STATUS_PLANNED};//National Event
    
    public static String sortBy { get; set; }
    public List<CampaignWrapper> campaignWrapperList{get;set;}
   
     public Boolean init{
    get{
        getNationalEventLst();
        return false;
       }
    }
   
    
    public LPDCR_SecondaryNationalEventsController(){
       
        species_filter = new List<String>();
    }
    
   
    /***
    **Wrapper class for sorting campaigns
    ***/
      public class CampaignWrapper implements Comparable{
        
        
        public String Name{get;set;}
        public Campaign camp{get;set;}
       
        
        public CampaignWrapper(Campaign cam){
         camp= cam;
        }
        public CampaignWrapper(){
        }
        public integer compareTo( Object a_compare_to ){
            
            CampaignWrapper campSort = (CampaignWrapper)a_compare_to;
            
           if( LPDCR_SecondaryNationalEventsController.sortBy.equals( 'Date DESC' ) )
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
            else if( LPDCR_SecondaryNationalEventsController.sortBy.equals( 'Date ASC' ) )
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
            if(LPDCR_SecondaryNationalEventsController.sortBy.equals('Name DESC'))
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
      
    public List<Campaign> getNationalEventLst(){
        try{
            
            campList_nationalevent =[SELECT Id,Name,Date_of_Event__c,EndDate,Short_Description__c,Type,Status,Event_Location__c,Event_Date_Range__c,Specie_Focus__c,Display_in_Dealer_Community__c
                    FROM Campaign WHERE ( Display_in_Dealer_Community__c = true AND RecordType.DeveloperName =:  LPDCR_Constants.CONS_NATIONALEVENTS AND Type IN:camNatType AND Status IN:camNatStatus AND EndDate >= TODAY )
                    ORDER BY Date_of_Event__c DESC];
           
           System.debug('National campList ---'+ campList_nationalevent ); 
           //Filter Species
           
            campList_nationalevent  = LPDCR_ContentServiceUtil.filterCampaign(campList_nationalevent,species_filter);
            //Looping the campList_nationalevent for SortBy 
            
              campaignWrapperList = new List<CampaignWrapper>();
              
               for(Campaign c:campList_nationalevent)
               {
                 campaignWrapperList.add(new CampaignWrapper(c));
               }
             
               campaignWrapperList.sort();
              
               System.debug('campList_nationalevent---'+campaignWrapperList);
          
            
            
        }
        catch(Exception ex){
        System.debug('Exception National Event Occured--'+ ex);
       
        }
        return campList_nationalevent;
      }
      
    
}