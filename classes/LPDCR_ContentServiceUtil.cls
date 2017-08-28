/******************************************************************************
 * Utility class to act as the inteface for the Dealer community to retreive
 * content from the CMS system (Kentico)
 * 
 * @Author: Magnet 360
 * @Date: Mar 22, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing class LPDCR_ContentServiceUtil 
{
    @TestVisible private static String CREDENTIALS_NAME = Label.LPDCR_KenticoCMS_Named_Credentials;
    @TestVisible private static String OBI_CREDENTIALS_NAME = Label.LPDCR_OBI_CMS_Named_Credentials;
    @TestVisible private static String SESSION_CACHE_TYPE = 'Session';
    @TestVisible private static String ORG_CACHE_TYPE = 'Org';
    @TestVisible private static String DOCUMENTS_SEARCH_TYPE = 'Documents';
    @TestVisible private static String PROMOTIONS_SEARCH_TYPE = 'Promotions'; 
    //public String requestLabel;
    //public String result {get;set;}
                 
    @TestVisible private Integer ORG_CHACHE_LIFE {
        get {
            String result = Label.LPDCR_Org_Cache_Timeout_In_Seconds;
            return ( !result.isNumeric() || result == null ? 7200 : Integer.valueOf( result ) );
        }
        set;
    } 
/******************************************************************************
 * Constructor
 */
    public LPDCR_ContentServiceUtil()
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.constructor()' );
        
        System.debug( 'END: LPDCR_ContentServiceUtil.constructor()' );
    }

/******************************************************************************
 * Method to get the Species list from the web service
 */
    public LPDCR_BLSpecies getSpecies()
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getSpecies()' );
        
        LPDCR_BLSpecies l_response;
        
        try
        {
                                                 // Get information from Org platform
                                                 // cache if available   
            String l_species = doCallout( Label.LPDCR_Kentico_Species_Table,
                                          true, 
                                          'Org',
                                          Label.LPDCR_Species_Service_Cache_Key
                                          );

            l_response = LPDCR_BLSpecies.parse( l_species );
            
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            l_response = new LPDCR_BLSpecies();
            l_response.success = false;
            l_response.ex = l_ex;
            
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            l_response = new LPDCR_BLSpecies();
            l_response.success = false;
            l_response.ex = l_ex2;
        }
        
        System.debug( 'Return: l_response = ' + l_response );
        System.debug( 'END: LPDCR_ContentServiceUtil.getSpecies()' );
        
        return l_response;
    }
    

/******************************************************************************
 * Method to get the Promotion Data from the web service
 */ 
    public LPDCR_BLPromotions getPromotionsData(String sort_filter){
     
        System.debug( 'START: LPDCR_ContentServiceUtil.getPromotionsData()' );
        
        LPDCR_BLPromotions response;
        try{
            String promotions = doCallOut( System.Label.LPDCR_Kentico_Promotions_Table,
                                           System.Label.LPDCR_Promotions_Where_Clause,                                          
                                           true,
                                           'Org',
                                           Label.LPDCR_Promotions_Service_Cache_Key,
                                           sort_filter);
                  
            response = LPDCR_BLPromotions.parse(promotions);
        
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLPromotions();
            response.success = false;
            response.ex = l_ex;
            
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLPromotions();
            response.success = false;
            response.ex = l_ex2;
        }
        
        System.debug( 'Return: response = ' + response );
        System.debug( 'END: LPDCR_ContentServiceUtil.getPromotionsData()' );
        
        return response;
    }
    

/******************************************************************************
 * Method to get the Homepage Carousel promotions from the web service
 */ 
    public 
    LPDCR_BLPromotions 
    getCarouselPromotions(){
     
        System.debug( 'START: LPDCR_ContentServiceUtil.getCarouselPromotions()' );
        
        LPDCR_BLPromotions response;
        try{
            String l_where_clause;
            String l_cache_key;
            if( UserInfo.getUserType() == 'STANDARD' )
            {
                l_where_clause = Label.LPDCR_Carousel_Promotions_Where_Clause;
                l_cache_key = Label.LPDCR_Carousel_Promotions_Service_Cache_Key;
            }
            else
            {
                l_where_clause = Label.LPDCR_Carousel_Promotions_Dealer_Where_Clause;
                l_cache_key = Label.LPDCR_Carousel_Promotions_Dealer_Service_Cache_Key;
            }
            
            String promotions = doCallOut( Label.LPDCR_Kentico_Promotions_Table,
                                           l_where_clause,
                                           Label.LPDCR_Carousel_Slide_Limit, 
                                           true,
                                           'Org',
                                           l_cache_key );
                  
            response = LPDCR_BLPromotions.parse(promotions);
        
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            System.debug('Exception Callout----' + l_ex);
            response = new LPDCR_BLPromotions();
            response.success = false;
            response.ex = l_ex;
            
            
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLPromotions();
            response.success = false;
            response.ex = l_ex2;
        }
        
        System.debug( 'Return: response = ' + response );
        System.debug( 'END: LPDCR_ContentServiceUtil.getCarouselPromotions()' );
        
        return response;
    }

/******************************************************************************
 * Method to get the Documents from the web service using a where clause to 
 * specify the exact document types to return, and specifying the cache key
 * to store the results in   
 */ 
    public 
    LPDCR_BLDocuments 
    getDocuments( String a_where_clause, String a_cache_key,String sort_filter )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDocuments()');
        System.debug( 'Param: a_where_clause = ' + a_where_clause );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        LPDCR_BLDocuments response;
        try{
            String documents = doCallOut( System.Label.LPDCR_Kentico_Documents_Table, 
                                          a_where_clause,                                
                                          true,
                                          'Org',
                                          a_cache_key,
                                          sort_filter);
                  
            response = LPDCR_BLDocuments.parse(documents);
            system.debug('**'+response );
        
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLDocuments();
            response.success = false;
            response.ex = l_ex;
            
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLDocuments();
            response.success = false;
            response.ex = l_ex2;
        }
        
        // System.debug( 'Return Document: response = ' + response );
        System.debug( 'END: LPDCR_ContentServiceUtil.getDocuments()' );
        
        return response;
    }
    

/******************************************************************************
 * Method to get the Documents from the web service using a where clause to 
 * specify the exact document types to return
 */ 
    public LPDCR_BLDocuments getMSRPDocuments( String a_table_name, String a_columns, String a_where_clause, String a_plant_names )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getMSRPDocuments()');
        System.debug( 'Param: a_where_clause = ' + a_where_clause );
        
        LPDCR_BLDocuments response;
        try{
        
            if( a_columns == null ) {
                a_columns = 'All';
            }
            
            String l_where_clause = System.EncodingUtil.urlEncode( a_where_clause+' AND ('+a_plant_names+')', 'UTF-8' );
            //String l_where_clause = System.EncodingUtil.urlEncode( a_where_clause, 'UTF-8' );
                    
            System.debug('l_where_clause ----'+a_where_clause+' AND ('+a_plant_names+')' );
                    
            /* NAMED CREDENTIALS APPROACH */
            HttpRequest l_req = new HttpRequest();
            l_req.setEndpoint( 'callout:' + CREDENTIALS_NAME + '/rest/' + a_table_name + '/' + a_columns + '?format=JSON&WHERE=' + l_where_clause );
            l_req.setMethod( 'GET' );
            //l_req.setTimeout(60000);
            Http l_http = new Http();
            HTTPResponse l_res = l_http.send( l_req );
            String l_response_body = l_res.getBody();
            
            String documents = l_response_body;
                  
            response = LPDCR_BLDocuments.parse(documents);
            system.debug('**'+response );
        
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLDocuments();
            response.success = false;
            response.ex = l_ex;
            
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLDocuments();
            response.success = false;
            response.ex = l_ex2;
        }
        
        System.debug( 'Return Document: response = ' + response );
        System.debug( 'END: LPDCR_ContentServiceUtil.getMSRPDocuments()' );
        
        return response;
    }     

/******************************************************************************
 * Private method to create the webservice callout and return the results,
 * defaulting the returned table columns to "all" and the WHERE and TOPN parameters to NULL
 */
    @TestVisible
    private String doCallout( String a_table_name, Boolean a_use_cache, String a_cache_type, String a_cache_key)
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doCallout()' );
        System.debug( 'Param: a_table_name = ' + a_table_name );
        System.debug( 'Param: a_use_cache = ' + a_use_cache );
        System.debug( 'Param: a_cache_type = ' + a_cache_type );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        
        String l_response = doCallout( a_table_name, 'All', null, null, a_use_cache, a_cache_type, a_cache_key,null);
        
        // System.debug( 'Return: l_response = ' + l_response );
        System.debug( 'END: LPDCR_ContentServiceUtil.doCallout()' );
        
        return l_response;
    }

/******************************************************************************
 * Private method to create the webservice callout and return the results, Specifying
 * the WHERE clause, and defaulting the returned table columns to "all" 
 * and TOPN parameter to null
 */
    @TestVisible
    private String doCallout( String a_table_name, String a_where_condition,Boolean a_use_cache, String a_cache_type, String a_cache_key)
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doCallout()' );
        System.debug( 'Param: a_table_name = ' + a_table_name );
        System.debug( 'Param: a_where_condition = ' + a_where_condition );
        System.debug( 'Param: a_use_cache = ' + a_use_cache );
        System.debug( 'Param: a_cache_type = ' + a_cache_type );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        
        String l_response = doCallout( a_table_name, 'All', a_where_condition, null, a_use_cache, a_cache_type, a_cache_key,null);
        
        // System.debug( 'Return: l_response = ' + l_response );
        System.debug( 'END: LPDCR_ContentServiceUtil.doCallout()' );
        
        return l_response;
    }
/******************************************************************************
 * Private method to create the webservice callout and return the results, Specifying
 * the WHERE clause, and defaulting the returned table columns to "all" 
 * and TOPN parameter to null and sort filter clause 
 */
    @TestVisible
    private String doCallout( String a_table_name, String a_where_condition,Boolean a_use_cache, String a_cache_type, String a_cache_key,String sort_filter)
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doCallout()' );
        System.debug( 'Param: a_table_name = ' + a_table_name );
        System.debug( 'Param: a_where_condition = ' + a_where_condition );
        System.debug( 'Param: a_use_cache = ' + a_use_cache );
        System.debug( 'Param: a_cache_type = ' + a_cache_type );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        System.debug( 'Param: sort_filter = ' + sort_filter );
        
        String l_response = doCallout( a_table_name, 'All', a_where_condition, null, a_use_cache, a_cache_type, a_cache_key,sort_filter);
        
        // System.debug( 'Return: l_response = ' + l_response );
        System.debug( 'END: LPDCR_ContentServiceUtil.doCallout()' );
        
        return l_response;
    }
    
/******************************************************************************
 * Private method to create the webservice callout and return the results, Specifying
 * the WHERE and TOPN parameters, and defaulting the returned table columns to "all" 
 */
    @TestVisible
    private String doCallout( String a_table_name, String a_where_condition, String a_top_n, Boolean a_use_cache, String a_cache_type, String a_cache_key)
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doCallout()' );
        System.debug( 'Param: a_table_name = ' + a_table_name );
        System.debug( 'Param: a_where_condition = ' + a_where_condition );
        System.debug( 'Param: a_top_n = ' + a_top_n );
        System.debug( 'Param: a_use_cache = ' + a_use_cache );
        System.debug( 'Param: a_cache_type = ' + a_cache_type );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        
        String l_response = doCallout( a_table_name, 'All', a_where_condition, a_top_n, a_use_cache, a_cache_type, a_cache_key,null);
        
        // System.debug( 'Return: l_response = ' + l_response );
        System.debug( 'END: LPDCR_ContentServiceUtil.doCallout()' );
        
        return l_response;
    }

/******************************************************************************
 * Private method to create the webservice callout and return the results. The
 * method allows the results to be stored in Session or Org cache for quick
 * retrieval, or be specified to ignore the cache and make the webservice callout
 * to get the data.
 *
 * @Param: String a_table_name : The Kentico table name to set as the callout
 *                               endpoint. Also used as part of the Key when
 *                               storing the results in cache. 
 *
 * @Param: String a_columns : A comma separated list of table columns to return
 *                            in the web service call. Defaults to 'All'
 *
 * @Param: String a_where_condition : The WHERE condition that will be URLEncoded
 *                                    and included on the web service call. The value
 *                                    should begin after "WHERE="
 *
 * @Param: String a_top_n : Limit the number of results returned to this number
 *
 * @Param: Boolean a_use_cache : Indicates whether or not to retreive the data
 *                               from cache if it is available
 *
 * @Param: String a_cache_type : Indicates the type of Platform cache to use. 
 *                               Either 'Session' or 'Org', depending on if 
 *                               the data is specific to a user, or used for
 *                               multiple users. Ignored if a_use_cache == false
 * @Param: String a_cache_key : The unique key for the value if it is stored in cache.
 *                              Limited to the first 50 characters. Ignored if 
 *                              a_use_cache == false
 */
    @TestVisible
    private String doCallout( String a_table_name, String a_columns, String a_where_clause, String a_top_n, Boolean a_use_cache, String a_cache_type, String a_cache_key, String sort_filter)
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doCallout()' );
        System.debug( 'Param: a_table_name = ' + a_table_name );
        System.debug( 'Param: a_columns = ' + a_columns );
        System.debug( 'Param: a_where_clause = ' + a_where_clause );
        System.debug( 'Param: a_top_n = ' + a_top_n );
        System.debug( 'Param: a_use_cache = ' + a_use_cache );
        System.debug( 'Param: a_cache_type = ' + a_cache_type );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        System.debug( 'Param: sort_filter = ' + sort_filter );
        
        if( a_columns == null ) {
            a_columns = 'All';
        }
        if( a_use_cache == null )
        {
            a_use_cache = false;
        }
                                                 // If caching is disabled, override
                                                 // the a_use_cache parameter and set
                                                 // it to false        
        if( ! LPDCR_Org_Settings__c.getInstance().Enable_Web_Service_Caching__c )
        {
            a_use_cache = false;
        }
        
        
        String l_response_body;
        Cache.SessionPartition l_session_partition;
        Cache.OrgPartition l_org_partition;
        String l_where_clause = '';
        String l_top_n = '';
        String l_order_by = '';
        
        if( a_where_clause != null && a_where_clause != '' )
        {
            l_where_clause = '&WHERE=' + System.EncodingUtil.urlEncode( a_where_clause,'UTF-8' );
        }
        if( a_top_n != null && a_top_n.isNumeric() )
        {
            l_top_n = '&TOPN=' + a_top_n;
        }
        if( (a_table_name.contains( 'Documents' ) || a_table_name.contains( 'Promotions' ) )&& sort_filter != null )
        {
            l_order_by = '&ORDERBY=' + System.EncodingUtil.urlEncode(sort_filter,'UTF-8');
        }
       /* if( a_table_name.contains( 'Promotions' ) && sort_filter != null)
        {
            l_order_by = '&ORDERBY='+sort_filter;
        }*/
        if(a_cache_key != null){
            a_cache_key = cleanseCacheKey( a_cache_key ).left( 50 );
        }
        
        try
        {
                                                 // Set the cache partition if
                                                 // needed
            if( a_use_cache )
            {
                if( a_cache_type == SESSION_CACHE_TYPE )
                {
                    System.debug( 'Use Session cache' );
                    l_session_partition = Cache.Session.getPartition( Label.LPDCR_Platform_Cache_Partition );
                }
                else
                {
                    System.debug( 'Use Org cache' );
                    l_org_partition = Cache.Org.getPartition( Label.LPDCR_Platform_Cache_Partition );
                }
            }// /END if( a_use_cache )

                                                 // If the request is specifed
                                                 // to use the cache, retreive
                                                 // the value from cache if it exists.
                                                 // SF BEST PRACTICE: Avoid calling 
                                                 // the contains(key) method followed 
                                                 // by the get(key) method. If you 
                                                 // intend to use the key value, simply 
                                                 // call the get(key) method and make 
                                                 // sure that the value is not equal to null.
            if( a_use_cache
                && ( ( l_session_partition != null
                       && l_session_partition.get( a_cache_key ) != null )
                    || ( l_org_partition != null
                        && l_org_partition.get( a_cache_key ) != null )  
                   )
              )
            {
                if( a_cache_type == SESSION_CACHE_TYPE )
                {
                                                 // Get the JSON string response
                                                 // from the session cache
                    l_response_body = ( String ) l_session_partition.get( a_cache_key );
                }
                else
                {
                                                 // Get the JSON string response
                                                 // from the Org cache
                    l_response_body = ( String ) l_org_partition.get( a_cache_key );
                }
            }
            else
            {
                                                 // Either the data does not
                                                 // yet exist in cache, or it
                                                 // needs to be called directly
                                                 // from the web service.
                /* NAMED CREDENTIALS APPROACH */
                HttpRequest l_req = new HttpRequest();
                l_req.setEndpoint( 'callout:' + CREDENTIALS_NAME + '/rest/' + a_table_name + '/' + a_columns + '?format=JSON' + l_where_clause + l_top_n + l_order_by );
                l_req.setMethod( 'GET' );
               
                Http l_http = new Http();
                HTTPResponse l_res = l_http.send( l_req );
                l_response_body = l_res.getBody();
            
                                                 // If the call is designated to
                                                 // use cache, store the response
                                                 // in the appropriate cache
                if( l_res.getStatusCode() == 200
                    && l_response_body != null 
                    && a_use_cache )
                {
                    if( a_cache_type == SESSION_CACHE_TYPE )
                    {
                        l_session_partition.put( a_cache_key, l_response_body );
                    }
                    else
                    {
                        l_org_partition.put( a_cache_key, l_response_body, ORG_CHACHE_LIFE );
                    }
                }// /END if( a_use_cache )
            }// /END if( Get From Cache )
        }
        catch( Exception l_ex )
        {
            LPDCR_CalloutException l_exception = new LPDCR_CalloutException( a_table_name,
                                                                             a_columns,
                                                                             l_ex );
            
            LOLUtilities.LogErrMsg( 'LPDCR_ContentServiceUtil.doCallout()',
                                    l_ex,
                                    a_table_name 
                                    + ':'
                                    + a_columns
                                    + ':'
                                    + l_ex.getMessage() );
            
                                                 // Clear out the cache
                                                 // when an error has occurred
                                                 // so a bad response is not
                                                 // retained.
            if( a_use_cache )
            {
                if( l_session_partition != null && l_session_partition.get( a_cache_key ) != null )
                {
                    l_session_partition.remove( a_cache_key );
                }
                else if( l_org_partition != null && l_org_partition.get( a_cache_key ) != null )
                {
                    l_org_partition.remove( a_cache_key );
                }
            }
            
            throw l_exception;
        }
        
        // System.debug( 'Return: ' + a_table_name + ' = ' + l_response_body );
        System.debug( 'END: LPDCR_ContentServiceUtil.doCallout()' );
        
        return l_response_body;
    }

/******************************************************************************
 * Private method used to cleanse the Cache Key so that it is an alpha-numeric
 * value, with no spaces, underscores, commas or periods
 */
    private String cleanseCacheKey( String a_key )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.cleanseCacheKey()' );
        System.debug( 'Param: a_key = ' + a_key );
        
        Pattern nonAlphanumeric = Pattern.compile( '[^a-zA-Z0-9]' );
        if(a_key != null){
            Matcher matcher = nonAlphanumeric.matcher( a_key );
            a_key = matcher.replaceAll( '' );
        }
        
        
        System.debug( 'Return: a_key = ' + a_key );
        System.debug( 'END: LPDCR_ContentServiceUtil.cleanseCacheKey()' );
        
        return a_key;
    }

/******************************************************************************
 * Inner custom exception class to handle callout exceptions
 */
    public class LPDCR_CalloutException extends Exception
    {
        public Exception ex { get; set; }
        public String table_name { get; set; }
        public String columns { get; set; }
        
        public LPDCR_CalloutException( String a_table_name, String a_columns, Exception a_ex )
        {
            table_name = a_table_name;
            columns = a_columns; 
            ex = a_ex;
        }
    }// /END LPDCR_CalloutException class
 /*******************************************************************************************
 * Method to store permission set in session cache.
 */   
    public static Map<String,Boolean> getcurrentUserPerSet()
    {
        Map<String,Boolean> permissionSetUserMap = new Map<String,Boolean>();
        List<String> permissionSetList = System.Label.LPDCR_Permission_Set.Split(',');
        Set<String> permissionSet = new Set<String>();
        Boolean a_use_cache =false;// Default value of a_use_cache
                                                 // Override the a_use_cache 
                                                 // parameter and set it to true
        if( LPDCR_Org_Settings__c.getInstance().Enable_Web_Service_Caching__c )
        {
            a_use_cache = true;
        } 
                                                 // if a_use_cache is true and 
                                                 // session cache has values it 
                                                 // will fetch values from session
        if(a_use_cache && Cache.Session.get('psMap' + UserInfo.getUserId() ) != null)
        {
            permissionSetUserMap =(Map<String,Boolean>)Cache.Session.get('psMap' + UserInfo.getUserId() );
        }
        else
        {
                                                 // if session cache is null it will 
                                                 // query the permission sets
                                                 // assigned to user.
            permissionSet.addall(permissionSetList);
        
            for(String str:permissionSet)
            {
               permissionSetUserMap.put(str,false);
            }
            
            for(PermissionSetAssignment currentUserPerSetList : [ SELECT Id, PermissionSetId, PermissionSet.Label, AssigneeId 
                                                                  FROM PermissionSetAssignment  
                                                                  WHERE AssigneeId = :Userinfo.getUserId() 
                                                                    AND PermissionSet.Label IN :permissionSet ] )
            {
                permissionSetUserMap.put(currentUserPerSetList.PermissionSet.Label,true);
            }
            
            if(a_use_cache)
            {
                Cache.Session.put('psMap' + UserInfo.getUserId(), permissionSetUserMap);
            }
        }// /END if( a_use_cache )
           
        System.debug('permissionSetUserMap----' + permissionSetUserMap);
        
        return permissionSetUserMap;
    }// End of getcurrentUserPerSet() method.
    
    /***************************
    ** Method for filter campaign 
    */
    public static List<Campaign> filterCampaign(List<Campaign> camp,List<String> species){
        
        List<Campaign> campfilter = new List<Campaign>();
        
        if( species != null && species.size() > 0 )
        {
            for( Campaign cam : camp )
            {
                for( String spe : species )
                {
                    if( cam.Specie_Focus__c != null && cam.Specie_Focus__c.contains( spe ) )
                    {
                        campfilter.add( cam );
                        break;
                    }
                }
            }// /END for( species )
        }
        else
        {
                                                 // Add all the documents to the list
                                                 // that will be eventually returned
            campfilter.addAll( camp );
        }// /END if( species != null )
        
        System.debug( 'START: LPDCR_ContentServiceUtil.filterCampaign()' );
        
        return campfilter; 
    }
    
/******************************************************************************
 * Private method to call the OBI Web services 
 *
 * @Param: 
 */    
    private
    String
    doReportCallout( String a_report_name, String a_report_path, String a_account_number, Boolean a_use_cache, String a_cache_type, String a_cache_key )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doReportCallout()' );
        System.debug( 'Param: a_report_name = ' + a_report_name );
        System.debug( 'Param: a_report_path = ' + a_report_path );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        System.debug( 'Param: a_use_cache = ' + a_use_cache );
        System.debug( 'Param: a_cache_type = ' + a_cache_type );
        System.debug( 'Param: a_cache_key = ' + a_cache_key );
        
        if( ! LPDCR_Org_Settings__c.getInstance().Enable_Web_Service_Caching__c )
        {
            a_use_cache = false;
        }
        
        String l_response_body;
        Cache.SessionPartition l_session_partition;
        Cache.OrgPartition l_org_partition;
        
        a_cache_key = cleanseCacheKey( a_cache_key ).left( 50 );
        
        try
        {
                                                 // Set the cache partition if
                                                 // needed
            if( a_use_cache )
            {
                if( a_cache_type == SESSION_CACHE_TYPE )
                {
                    System.debug( 'Use Session cache' );
                    l_session_partition = Cache.Session.getPartition( Label.LPDCR_Platform_Cache_Partition );
                }
                else
                {
                    System.debug( 'Use Org cache' );
                    l_org_partition = Cache.Org.getPartition( Label.LPDCR_Platform_Cache_Partition );
                }
            }// /END if( a_use_cache )

                                                 // If the request is specifed
                                                 // to use the cache, retreive
                                                 // the value from cache if it exists.
                                                 // SF BEST PRACTICE: Avoid calling 
                                                 // the contains(key) method followed 
                                                 // by the get(key) method. If you 
                                                 // intend to use the key value, simply 
                                                 // call the get(key) method and make 
                                                 // sure that the value is not equal to null.
            if( a_use_cache
                && ( ( l_session_partition != null
                       && l_session_partition.get( a_cache_key ) != null )
                    || ( l_org_partition != null
                        && l_org_partition.get( a_cache_key ) != null )  
                   )
              )
            {
                if( a_cache_type == SESSION_CACHE_TYPE )
                {
                                                 // Get the JSON string response
                                                 // from the session cache
                    l_response_body = ( String ) l_session_partition.get( a_cache_key );
                }
                else
                {
                                                 // Get the JSON string response
                                                 // from the Org cache
                    l_response_body = ( String ) l_org_partition.get( a_cache_key );
                }
            }
            else
            {
                                                 // Either the data does not
                                                 // yet exist in cache, or it
                                                 // needs to be called directly
                                                 // from the web service.
                /* NAMED CREDENTIALS APPROACH */
                HttpRequest l_req = new HttpRequest();
                if(UserInfo.getUserType() != 'Standard'){
                l_req.setEndpoint( 'callout:' + OBI_CREDENTIALS_NAME + '/purina/reports?reportPath=/' + a_report_path + '/' + System.EncodingUtil.urlEncode( a_report_name, 'UTF-8' ) + '&CUSTOMER_NUM=' + System.EncodingUtil.urlEncode( a_account_number, 'UTF-8' ) );
                }
                else{
                l_req.setEndpoint( 'callout:' + OBI_CREDENTIALS_NAME + '/purina/reports?reportPath=/' + a_report_path + '/' + System.EncodingUtil.urlEncode( a_report_name, 'UTF-8' ) + '&EMPLOYEE_ID=' + System.EncodingUtil.urlEncode( a_account_number, 'UTF-8' ) );
                }
                l_req.setMethod( 'GET' );
                l_req.setHeader( 'Accept-Encoding', 'application/json' );
                l_req.setTimeout( 6000 );
               
                Http l_http = new Http();
                HTTPResponse l_res = l_http.send( l_req );
                l_response_body = l_res.getBody();
            
                                                 // If the call is designated to
                                                 // use cache, store the response
                                                 // in the appropriate cache
                if( l_res.getStatusCode() == 200
                    && l_response_body != null 
                    && a_use_cache )
                {
                    if( a_cache_type == SESSION_CACHE_TYPE )
                    {
                        l_session_partition.put( a_cache_key, l_response_body );
                    }
                    else
                    {
                        l_org_partition.put( a_cache_key, l_response_body, ORG_CHACHE_LIFE );
                    }
                }// /END if( a_use_cache )
            }// /END if( Get From Cache )
        }
        catch( Exception l_ex )
        {
            LPDCR_CalloutException l_exception = new LPDCR_CalloutException( a_report_name,
                                                                             '',
                                                                             l_ex );
            
            LOLUtilities.LogErrMsg( 'LPDCR_ContentServiceUtil.doReportCallout()',
                                    l_ex,
                                    a_report_name 
                                    + ':'
                                    + null
                                    + ':'
                                    + l_ex.getMessage() );
            
                                                 // Clear out the cache
                                                 // when an error has occurred
                                                 // so a bad response is not
                                                 // retained.
            if( a_use_cache )
            {
                if( l_session_partition != null && l_session_partition.get( a_cache_key ) != null )
                {
                    l_session_partition.remove( a_cache_key );
                }
                else if( l_org_partition != null && l_org_partition.get( a_cache_key ) != null )
                {
                    l_org_partition.remove( a_cache_key );
                }
            }
            
            throw l_exception;
        }
        
        System.debug( 'END: LPDCR_ContentServiceUtil.doReportCallout()' );
        
        return l_response_body;
    }


/******************************************************************************
 * Public interface method to search Documents in Kentico
 *
 * @Param: String a_term : The search string
 */   
    public
    LPDCR_BLDocuments
    searchDocuments( String a_term )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.searchDocuments()' );
        System.debug( 'Param: a_term = ' + a_term );
        
        LPDCR_ContentSearchResult l_result;
        
        try
        {
            String l_search_results = doSearchCallout( DOCUMENTS_SEARCH_TYPE, a_term );
            
            try
            {
                l_result = new LPDCR_ContentSearchResult( DOCUMENTS_SEARCH_TYPE, l_search_results );
            }
            catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
            {
                System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
                l_result = new LPDCR_ContentSearchResult();
                l_result.success = false;
                l_result.ex = l_ex2;
            }
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            l_result = new LPDCR_ContentSearchResult();
            l_result.success = false;
            l_result.ex = l_ex;
        }
        
        System.debug( 'END: LPDCR_ContentServiceUtil.searchDocuments()' );
        return l_result.documents;
    }

/******************************************************************************
 * Public interface method to search Promotions in Kentico
 *
 * @Param: String a_term : The search string
 */   
    public
    LPDCR_BLPromotions
    searchPromotions( String a_term )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.searchPromotions()' );
        System.debug( 'Param: a_term = ' + a_term );
        
        LPDCR_ContentSearchResult l_result;
        
        try
        {
            String l_search_results = doSearchCallout( PROMOTIONS_SEARCH_TYPE, a_term );
            
            try
            {
                l_result = new LPDCR_ContentSearchResult( PROMOTIONS_SEARCH_TYPE, l_search_results );
            }
            catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
            {
                System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
                l_result = new LPDCR_ContentSearchResult();
                l_result.success = false;
                l_result.ex = l_ex2;
            }
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            l_result = new LPDCR_ContentSearchResult();
            l_result.success = false;
            l_result.ex = l_ex;
        }
        
        System.debug( 'END: LPDCR_ContentServiceUtil.searchPromotions()' );
        return l_result.promotions;
    }

/******************************************************************************
 * Private method to call the Kentico API to search either documents or promotions.
 * The search results are not cached. This method will return an XML string of the
 * search results with the <string xmlns="http://tempuri.org/"> tag containing
 * a JSON string of the actual results array. The JSON will be parsed by the calling
 * interface method to return a List<> of the results.
 *
 * @Param: String a_object_type : Either 'Documents' or 'Promotions' to define the
 *                         Kentico objects to search
 * @Param: String a_term : The search string
 */    
    private
    String
    doSearchCallout( String a_object_type, String a_term )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doSearchCallout()' );
        System.debug( 'Param: a_object_type = ' + a_object_type );
        System.debug( 'Param: a_term = ' + a_term );
        
        String l_response_body;
        
        try
        {
            /* NAMED CREDENTIALS APPROACH */
            HttpRequest l_req = new HttpRequest();
            if( a_object_type == DOCUMENTS_SEARCH_TYPE )
            {
                l_req.setEndpoint( 'callout:' + CREDENTIALS_NAME + '/CMSAPIExamples/BusinessLinkModule/BussinessLinkDocuments.asmx/GetResults?input=' + System.EncodingUtil.urlEncode( a_term, 'UTF-8' ) );
            }
            else
            {
                l_req.setEndpoint( 'callout:' + CREDENTIALS_NAME + '/CMSAPIExamples/BusinessLinkModule/BusinessLinkPromotions.asmx/GetResults?input=' + System.EncodingUtil.urlEncode( a_term, 'UTF-8' ) );                
            }
            l_req.setMethod( 'GET' );
           
            Http l_http = new Http();
            HTTPResponse l_res = l_http.send( l_req );
            l_response_body = l_res.getBody();
            System.debug( 'LPDCR_ContentServiceUtil.doSearchCallout() l_response_body = ' + l_response_body );
        }
        catch( Exception l_ex )
        {
            LPDCR_CalloutException l_exception = new LPDCR_CalloutException( a_object_type,
                                                                             '',
                                                                             l_ex );
            
            LOLUtilities.LogErrMsg( 'LPDCR_ContentServiceUtil.doSearchCallout()',
                                    l_ex,
                                    a_object_type 
                                    + ':'
                                    + null
                                    + ':'
                                    + l_ex.getMessage() );

            throw l_exception;
        }
        
        System.debug( 'END: LPDCR_ContentServiceUtil.doSearchCallout()' );
        
        return l_response_body;
    }
    
    /******************************************************************************
 * Method to get the Documents from the web service
 */ 
    public LPDCR_BLDocuments getDocuments(String a_where_clause){
     
        System.debug( 'START: LPDCR_ContentServiceUtil.getDocuments()');
        LPDCR_BLDocuments response;
        try{
            String documents = doCallOut( System.Label.LPDCR_Kentico_Documents_Table,                                                                                 
                                          a_where_clause);

            response = LPDCR_BLDocuments.parse(documents);
            system.debug('**'+response );
        
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLDocuments();
            response.success = false;
            response.ex = l_ex;
            
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            response = new LPDCR_BLDocuments();
            response.success = false;
            response.ex = l_ex2;
        }
        
        // System.debug( 'Return Document: response = ' + response );
        System.debug( 'END: LPDCR_ContentServiceUtil.getDocuments()' );
        
        return response;
    }

/******************************************************************************
 * Method to call the OBI Web services and get the VIP Points and Tons
 * summary report for a dealer account
 *
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain a single
 *              "Row" record that holds the summary data
 */    
    public 
    LPDCR_VIPTonsReport
    getDealerAccountSummaryReport( String a_account_number )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDealerAccountSummaryReport()' );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        
        String l_sql = LPDCR_Constants.DEALER_VIP_POINTS_SUMMARY_REPORT_SQL.replaceAll( ':param1', a_account_number );
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getDealerAccountSummaryReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to call the OBI Web services and get the VIP Points and Tons
 * detail report for a Dealer
 *
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the dealer accounts the employee has to 
 */    
    public 
    LPDCR_VIPTonsReport
    getDealerAccountDetailReport( String a_account_number )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDealerAccountDetailReport()' );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        
        String l_sql = LPDCR_Constants.DEALER_ACCOUNTS_LIST_REPORT_SQL.replaceAll( ':param1', a_account_number );
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getDealerAccountDetailReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to get the Level 3 details for a specific account for a Dealer user
 *
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the level 3 records for the specified account 
 */    
    public 
    LPDCR_VIPTonsReport
    getDealerAccountLevel3DetailReport( String a_account_number, String a_fd1_id )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDealerAccountLevel3DetailReport()' );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        System.debug( 'Param: a_fd1_id = ' + a_fd1_id );
        
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        if( a_fd1_id == null )
        {
            a_fd1_id = '';
        }
        
        String l_sql = LPDCR_Constants.DEALER_LEVEL3_LIST_REPORT_SQL.replaceAll( ':param1', a_account_number )
                                                                    .replace(':param2',a_fd1_id); // added param2
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getDealerAccountLevel3DetailReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to get the Level 3 details for a specific account for a Dealer user
 *
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 * @Param: String a_level_3_id : The id of the Level3 record 
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the product records for the specified Level3 record 
 */    
    public 
    LPDCR_VIPTonsReport
    getDealerAccountProductDetailReport( String a_employee_id,
                                         String a_account_number,
                                         String a_level_3_id )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDealerAccountProductDetailReport()' );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        System.debug( 'Param: a_level_3_id = ' + a_level_3_id );
        System.debug( 'Param: a_employee_id = ' + a_employee_id );
        
        if( a_employee_id == null )
        {
            a_employee_id = '';
        }
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        if( a_level_3_id == null )
        {
            a_level_3_id = '';
        }
        
        String l_sql = LPDCR_Constants.DEALER_PRODUCT_LIST_REPORT_SQL
                                      .replaceAll( ':param1', a_account_number )
                                      .replace(':param2',a_employee_id) // added param2
                                      .replace( ':param3', a_level_3_id );
                                      
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getDealerAccountProductDetailReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to get full Dealer VIP Points & Tons report
 *
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain all the Points 
 *              & Tons data for the specified account 
 */    
    public 
    LPDCR_VIPTonsReport
    getDealerFullReport( String a_account_number )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDealerFullReport()' );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        
        String l_sql = LPDCR_Constants.DEALER_FULL_REPORT_SQL.replaceAll( ':param1', a_account_number );
                                      
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getDealerFullReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to get the full VIP Points & Tons dealer report as a CSV file string.
 * The web service returns a Base64 encoded string to this method, which then
 * needs to be returned and rendered properly by the calling page
 *
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 *
 * @Return: Blob l_csv_file : Base64 enooded string of the CSV file returned
 *                              from the web service 
 */    
    public 
    String
    getDealerFullReportAsCSV( String a_account_number )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getDealerFullReportAsCSV()' );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        
        String l_response;
        // Blob l_csv_file;
        String l_csv_file;
        
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        
        String l_sql = LPDCR_Constants.DEALER_FULL_REPORT_JSON.replaceAll( ':param1', a_account_number );

        l_response = doOBIServicePost( l_sql, true );
        System.debug( 'l_response = ' + l_response );
        JSONParser l_parser = JSON.createParser( l_response );
        while( l_parser.nextToken() != null ) 
        {
            if( ( l_parser.getCurrentToken() == JSONToken.FIELD_NAME ) 
                   && ( l_parser.getText() == 'content' ) ) 
            {
                                                 // Get the value.
                l_parser.nextToken();
                l_csv_file =  l_parser.getText();
                // l_csv_file =  l_parser.getBlobValue();
                // l_csv_file = EncodingUtil.base64Decode( l_parser.getText() );
                System.debug( 'l_csv_file = ' + l_csv_file );
            }
        }// /END while
        
        System.debug( 'END: LPDCR_ContentServiceUtil.getDealerFullReportAsCSV()' );
        
        return l_csv_file;
    }

/******************************************************************************
 * Method to call the OBI Web services and get the VIP Points and Tons
 * summary report for an Internal user
 *
 * @Param: String a_employee_number : The value from the User.Employee_Number__c field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain a single
 *              "Row" record that holds the summary data
 */    
    public 
    LPDCR_VIPTonsReport
    getInternalSummaryReport( String a_employee_number )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getInternalSummaryReport()' );
        System.debug( 'Param: a_employee_number = ' + a_employee_number );
        
        if( a_employee_number == null )
        {
            a_employee_number = '';
        }
        
        String l_sql = LPDCR_Constants.INTERNAL_VIP_POINTS_SUMMARY_REPORT_SQL.replace( ':param1', a_employee_number );
        System.debug('Query--->'+l_sql);
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getInternalSummaryReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to call the OBI Web services and get the VIP Points and Tons
 * detail report for an internal sales user
 *
 * @Param: String a_employee_id : The value from the User.Employee_Number__c field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the dealer accounts the employee has to 
 */    
    public 
    LPDCR_VIPTonsReport
    getInternalAccountDetailReport( String a_employee_id, String territory_id )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getInternalAccountDetailReport()' );
        System.debug( 'Param: a_employee_id = ' + a_employee_id );
        System.debug( 'Param: territory_id = ' + territory_id );
        
        if( a_employee_id == null )
        {
            a_employee_id = '';
        }
        if( territory_id == null )
        {
            territory_id = '';
        }
        
        String l_sql = LPDCR_Constants.INTERNAL_ACCOUNT_LIST_REPORT_SQL.replace( ':param1', a_employee_id ).replace(':param2',territory_id);
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getInternalAccountDetailReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to call the OBI Web services and  get list of territories and their VIP Points & Tons Summaries for an internal user.
 * detail report for an internal sales user
 *
 * @Param: String a_employee_id : The value from the User.Employee_Number__c field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the dealer accounts the employee has to 
 */    
    public 
    LPDCR_VIPTonsReport
    getInternalAccountTerritoryReport( String a_employee_id )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getInternalAccountTerritoryReport()' );
        System.debug( 'Param: a_employee_id = ' + a_employee_id );
        
        if( a_employee_id == null )
        {
            a_employee_id = '';
        }
        
        String l_sql = LPDCR_Constants.INTERNAL_TERRITORY_LIST_REPORT_SQL.replace( ':param1', a_employee_id );
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getInternalAccountTerritoryReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to get the Level 3 details for a specific account for an internal user
 *
 * @Param: String a_employee_id : The value from the User.EmployeeNumber field
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the level 3 records for the specified account 
 */    
    public 
    LPDCR_VIPTonsReport
    getInternalAccountLevel3DetailReport( String a_employee_id,
                                          String a_account_number )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getInternalAccountLevel3DetailReport()' );
        System.debug( 'Param: a_employee_id = ' + a_employee_id );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        
        if( a_employee_id == null )
        {
            a_employee_id = '';
        }
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        
        String l_sql = LPDCR_Constants.INTERNAL_LEVEL3_LIST_REPORT_SQL
                                      .replace( ':param1', a_employee_id )
                                      .replace( ':param2', a_account_number );
                                      
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getInternalAccountLevel3DetailReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Method to get the Level 3 details for a specific account for an internal user
 *
 * @Param: String a_employee_id : The value from the User.EmployeeNumber field
 * @Param: String a_account_number : The value from the Account.AccountNumber field
 * @Param: String a_level_3_id : The id of the Level3 record 
 *
 * @Return: LPDCR_VIPTonsReport l_report : An obect of LPDCR_VIPTonsReport that
 *              holds the data from the web service. Should contain "Row" records
 *              for each of the product records for the specified Level3 record 
 */    
    public 
    LPDCR_VIPTonsReport
    getInternalAccountProductDetailReport( String a_employee_id,
                                           String a_account_number,
                                           String a_level_3_id )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.getInternalAccountProductDetailReport()' );
        System.debug( 'Param: a_employee_id = ' + a_employee_id );
        System.debug( 'Param: a_account_number = ' + a_account_number );
        System.debug( 'Param: a_level_3_id = ' + a_level_3_id );
        
        if( a_employee_id == null )
        {
            a_employee_id = '';
        }
        if( a_account_number == null )
        {
            a_account_number = '';
        }
        if( a_level_3_id == null )
        {
            a_level_3_id = '';
        }
        
        String l_sql = LPDCR_Constants.INTERNAL_PRODUCT_LIST_REPORT_SQL
                                      .replace( ':param1', a_employee_id )
                                      .replace( ':param2', a_account_number )
                                      .replace( ':param3', a_level_3_id );
                                      
        LPDCR_VIPTonsReport l_summary = handleVIPTonsReportCallout( l_sql );

        System.debug( 'END: LPDCR_ContentServiceUtil.getInternalAccountProductDetailReport()' );
        
        return l_summary;
    }

/******************************************************************************
 * Private method to help handle all of the calls to the doVIPTonsReportCallout()
 * method by wrapping them in try/catch blocks, so that each of the individual
 * methods do not have to do that.
 *
 * @Param: String a_sql : The SQL string that is sent in to the service as 
 *                        a parameter
 * @Return: LPDCR_VIPTonsReport : The parsed response from the service
 */    
    private 
    LPDCR_VIPTonsReport
    handleVIPTonsReportCallout( String a_sql )
    {
        LPDCR_VIPTonsReport l_summary;
        String l_json;
        
        try
        {
            l_json = doVIPTonsReportCallout( a_sql );
            l_summary = LPDCR_VIPTonsReport.parse( l_json );
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
            l_summary = new LPDCR_VIPTonsReport();
            l_summary.success = false;
            l_summary.ex = l_ex;
        }
        catch( LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_ex2 )
        {
            System.debug( '*** ERROR: PARSING EXCEPTION OCCURRED ***' );
            l_summary = new LPDCR_VIPTonsReport();
            l_summary.success = false;
            l_summary.ex = l_ex2;
        }
        
        return l_summary;
    }


/******************************************************************************
 * Private method to call the OBI Web services and get the VIP Points and Tons
 * reports. This report response should not be cached because of the size
 * of some responses.
 *
 * @Param: String a_sql : The SQL string that is sent in to the service as 
 *                        a parameter
 * @Return: A JSON string of the results
 */    
    private
    String
    doVIPTonsReportCallout( String a_sql )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doVIPTonsReportCallout()' );
        System.debug( 'Param: a_sql = ' + a_sql );

        String l_response_body;
        try
        {   
            
           /* Continuation con = new Continuation(40);
            con.continuationMethod='processResponse';*/
            
            
            HttpRequest l_req = new HttpRequest();
            
            l_req.setEndpoint( 'callout:' + OBI_CREDENTIALS_NAME + '/purina/reports/query?sql=' + System.EncodingUtil.urlEncode( a_sql, 'UTF-8' ) );
            l_req.setMethod( 'GET' );
            l_req.setHeader( 'Accept', 'application/json' );
            
            l_req.setTimeout( 20000 );//120000
            
           
            //this.requestLabel = con.addHttpRequest(l_req);  
            Http l_http = new Http();
            HTTPResponse l_res = l_http.send( l_req );
            l_response_body = l_res.getBody();
            System.debug('l_response_body...'+l_response_body);
            if( l_res.getStatusCode() != 200 )
            {
                System.debug( 'Throw callout excetion' );
                
                throw new System.CalloutException();
            }
    
            /*if( l_res.getStatusCode() != 200 && l_res.getStatusCode() != 500)
            {
                System.debug( 'Throw callout excetion' );
                
                throw new System.CalloutException();
            }
            
            else if(l_res.getStatusCode() == 500){
            HTTPResponse res = l_http.send( l_req );    
            res = Continuation.getResponse(this.requestLabel);
            this.result = res.getBody();
            System.debug('Continuation--');
            }*/
        
        }
        catch( Exception l_ex )
        {
            LPDCR_CalloutException l_exception = new LPDCR_CalloutException( a_sql,
                                                                             '',
                                                                             l_ex );

            LOLUtilities.LogErrMsg( 'LPDCR_ContentServiceUtil.doVIPTonsReportCallout()',
                                    l_ex,
                                    a_sql 
                                    + ':'
                                    + null
                                    + ':'
                                   + l_ex.getMessage() );
                                 
            
            throw l_exception;
        }
        
        System.debug( 'END: LPDCR_ContentServiceUtil.doVIPTonsReportCallout()' );
        
        return l_response_body;
        //return null;
    }

/******************************************************************************
 * Asynchronous method to request the full VIP Points & Tons report to be emailed 
 * to an internal user
 *
 * @Param: String a_employee_number : User.Employe_Number__c field
 * @Param: String a_email_address : The email address to send the report to
 
 * @Return: Boolean : True/False success message of the call
 */    
    @future(callout=true)
    public static 
    void
    requestInternalVIPTonsReport( String a_employee_number, 
                                  String a_email_address,
                                  String a_asm_name )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.requestInternalVIPTonsReport()' );
        System.debug( 'Param: a_employee_number = ' + a_employee_number );
        System.debug( 'Param: a_email_address = ' + a_email_address );
        System.debug( 'Param: a_asm_name = ' + a_asm_name );
        
        if( a_employee_number == null )
        {
            a_employee_number = '';
        }
        if( a_email_address == null )
        {
            a_email_address = '';
        }
        
        String l_json;
        String l_response;
        LPDCR_ContentServiceUtil l_service_util;
        
        try
        {
            Date d = date.today();
            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MM-YYYY');

            l_service_util = new LPDCR_ContentServiceUtil();
            
            l_json = LPDCR_Constants.INTERNAL_VIP_TONS_REPORT_REQUEST_JSON
                                    .replace( ':param1', a_employee_number )
                                    .replace( ':param2', a_email_address )
                                    .replace( ':param3', 'TonsAndVIP_' + a_asm_name + '_' + dt );
            
            l_response = l_service_util.doOBIServicePost( l_json, false );
        }
        catch( LPDCR_CalloutException l_ex )
        {
            System.debug( '*** ERROR: CALLOUT EXCEPTION OCCURRED ***' );
        }
    }

/******************************************************************************
 * Private method to submit a POST request to the OBI web service
 *
 * @Param: String a_json_body : The JSON string to use as the body of the request
 * @Param: Boolean a_get_csv : Flag to indicate that the response will be used
 *                  to generate a CSV file
 * @Return: A JSON string of the results
 */    
    private
    String
    doOBIServicePost( String a_json_body, Boolean a_get_csv )
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doOBIServicePost()' );
        System.debug( 'Param: a_json_body = ' + a_json_body );
        System.debug( 'Param: a_get_csv = ' + a_get_csv );

        String l_response_body;
        try
        {   
            String l_endpoint = '/purina/reports/query';
            if( a_get_csv == true )
            {
                l_endpoint += '/dealerreport';
            }
            else
            {
                l_endpoint += '/asmreport';
            }

            HttpRequest l_req = new HttpRequest();
            
            l_req.setEndpoint( 'callout:' + OBI_CREDENTIALS_NAME + l_endpoint );
            l_req.setMethod( 'POST' );
            l_req.setHeader( 'Accept', 'application/json' );
            l_req.setHeader( 'Content-Type', 'application/json' );
            l_req.setTimeout( 20000 );//120000
            l_req.setBody( a_json_body );
            
            
            
            Http l_http = new Http();
            HTTPResponse l_res = l_http.send( l_req );
            l_response_body = l_res.getBody();
    
            if( ! ( l_res.getStatusCode() == 200 || l_res.getStatusCode() == 202 ) )
            {
                System.debug( 'Throw callout excetion' );
                
                throw new System.CalloutException();
            }
            
            
        
        }
        catch( Exception l_ex )
        {
            LPDCR_CalloutException l_exception = new LPDCR_CalloutException( a_json_body,
                                                                             '',
                                                                             l_ex );

            LOLUtilities.LogErrMsg( 'LPDCR_ContentServiceUtil.doOBIServicePost()',
                                    l_ex,
                                    a_json_body 
                                    + ':'
                                    + null
                                    + ':'
                                   + l_ex.getMessage() );
                                 
            
            throw l_exception;
        }
        
        System.debug( 'END: LPDCR_ContentServiceUtil.doOBIServicePost()' );
        
        return l_response_body; 
    }
    
/******************************************************************************
 * Private method to create the webservice callout and return the results,
 * defaulting the returned table columns to "all"
 */
    @TestVisible
    private String doCallout( String a_table_name, String a_where_clause)
    {
        System.debug( 'START: LPDCR_ContentServiceUtil.doCallout()' );
        System.debug( 'Param: a_table_name = ' + a_table_name );
                
        String l_response = doCallout( a_table_name, 'All', a_where_clause, null, null, null, null, null);
        
         System.debug( 'Return document: l_response = ' + l_response );
        System.debug( 'END: LPDCR_ContentServiceUtil.doCallout()' );
        
        return l_response;
    }

        

} // /END Class