/**
*   @Author:    Ron Soppeland
*   @Date:      12.09.2016
*   @Purpose:   Access Web Services associated with My Links and user profile
*/

public with sharing class LOLMyLinksCallouts {
    private static final String CLASS_NAME = 'LOLMyLinksCallouts.';
    
    public static final String PRODUCT_MANULAS = 'pmi_livestockmanuals';
    public static final String PRICE_LIST_APP_CODE = 'feedpricelists';
    
    @TestVisible private static List<LOLMyLinksCalloutSettings__c> mySettings = LOLMyLinksCalloutSettings__c.getAll().values();
    @TestVisible private static LOLMyLinksCalloutSettings__c mySetting = new LOLMyLinksCalloutSettings__c();
    private static String myAuthorizationHeader = '';
    private static boolean isCacheAvailable = false;
    
    private static List<LOLMyLinksCalloutOverrides__c> myOverrides = LOLMyLinksCalloutOverrides__c.getAll().values();

    /* This class is for storing the results of the getUserInfo web service call
     */
    private class MyUserInfo {
        public String Ag2AgId {get;set;}
        public String user_info {get;set;}
    }
    
    /* This class is for storing the results of the my link data web service in cache
    */
    private class MyLinkResults {
        public String Ag2AgId {get;set;}
        public boolean areResultsAvailable {get;set;}
        public String requestData {get;set;}
    }
    
    /* This class is the wrapper class for the data returned by 
     * the My Links web service.  As it's the bottom most class
     * it can be named what I want.
    */
    public class MyLinkData {
        public String user_id {get;set;}
        public String app_code {get;set;}
        public String app_title {get;set;}
        public String app_description {get;set;}
        public String app_url {get;set;}
        public String app_portal_url {get;set;}
        public String home_page {get;set;}
        public Boolean isHomePage { get { return (home_page == '1' ? true : false); } }
        public String myAppUrl {
            get { return (isHomePage ? app_url : app_portal_url); }
        }
        public String myAppDescription {
            get {
                return (app_description == null 
                        ? app_title
                        : (app_description.trim().Length() == 0 
                            ? app_title 
                            : app_description));
                }
        }
    }
    
    /* 
     * Constructor
     */
    public LOLMyLinksCallouts(LOLMyLinksCalloutSettings__c myCS) {
        final String MOD_NAME = CLASS_NAME + 'LOLMyLinksCallouts with default Custom Setting';
        String msg = '###Active Custom Setting name: ' + myCS.Name;
        
        isCacheAvailable = false; 
        
        mySetting = myCS;                
        Blob myHeaderValue = Blob.valueOf(mySetting.WebServiceLoginId__c + ':' + mySetting.WebServicePassword__c);
        myAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(myHeaderValue);
        //LOLUtilities.LogErrMsg(MOD_NAME, 'Custom Setting Name: ' + mySetting.Name);
        
        try { 
            isCacheAvailable = Cache.Session.isAvailable(); 
            msg += ' - Cache is Available';
        }
        catch(Exception e) { 
            LOLUtilities.LogErrMsg(MOD_NAME, e, 'Checking for Cache availablilty');
            msg += ' - Cache is NOT Available';
        }

        //LOLUtilities.LogErrMsg(MOD_NAME, msg);
    }
    
    public LOLMyLinksCallouts() {
        final String MOD_NAME = CLASS_NAME + 'LOLMyLinksCallouts';
        String msg = '###Active Custom Setting name: ';
        
        isCacheAvailable = false; 
        
        for (LOLMyLinksCalloutSettings__c myS : mySettings) {
            if (myS.isActiveSetting__c == true) {
                msg = msg + myS.Name;
                mySetting = myS;                
                Blob myHeaderValue = Blob.valueOf(mySetting.WebServiceLoginId__c + ':' + mySetting.WebServicePassword__c);
                myAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(myHeaderValue);
                //LOLUtilities.LogErrMsg(MOD_NAME, 'Custom Setting Name: ' + myS.Name);
                break;
            }
        }
        
        try { 
            isCacheAvailable = Cache.Session.isAvailable(); 
            msg += ' - Cache is Available';
        }
        catch(Exception e) { 
            LOLUtilities.LogErrMsg(MOD_NAME, e, 'Checking for Cache availablilty');
            msg += ' - Cache is NOT Available';
        }

        //LOLUtilities.LogErrMsg(MOD_NAME, msg);
    }
    
    /* Optional method to use current user
     * Based on whether the ag2ag ID is an Internal or External user
     * Return the URL that directs the user to either EMS or ITSM for thier profile settings
     */
    public String GetUserProfileURL() {
        return GetUserProfileURL(getFedId());
    }
    
    /*
     * Based on whether the ag2ag ID is an Internal or External user
     * Return the URL that directs the user to either EMS or ITSM for thier profile settings
     */
    public String GetUserProfileURL(String inAg2AgId) {
        System.debug('GetUserInfo---'+GetUserInfo(inAg2AgId)+',,mySetting---'+mySetting);
        return (GetUserInfo(inAg2AgId).equalsIgnoreCase('Internal')
                ? mySetting.InternalUserProfileURL__c
                : mySetting.ExternalUserProfileURL__c );
    }

    /* Optional method to use current user
     * Call the GetUserInfo web service for the user ID that is passed in
     * then return that value as it will be either Internal or External.
     * ag2agId - A Business Link/User Id/Ag2Ag Id/sAMAccountName of a user to look up
     */
    public String GetUserInfo(){
        return GetUserInfo(getFedId());
    }
    
    /* Call the GetUserInfo web service for the user ID that is passed in
     * then return that value as it will be either Internal or External.
     * ag2agId - A Business Link/User Id/Ag2Ag Id/sAMAccountName of a user to look up
     */
    public String GetUserInfo(String ag2agId){
        final String MOD_NAME = CLASS_NAME + 'GetUserInfo';
        final String USER_INFO = 'LOLMyLinkUserInfo' + UserInfo.getUserId();
        MyUserInfo myUI = new MyUserInfo();
        
        //LOLUtilities.LogErrMsg(MOD_NAME, '### Begin method - ag2agId: ' + ag2agId);

        String retValue = '';

        if (isCacheAvailable && Cache.Session.contains(USER_INFO)) {
            myUI = (MyUserInfo)Cache.Session.get(USER_INFO);
            if (myUI.Ag2AgId == ag2agId) {
                retValue = myUI.user_info;
                system.debug('Cache retValue: ' + retValue);
                return retValue;
            }
        }

        retValue = 'Not Found';
        
        String endpointURL = LOLUtilities.buildURL(mySetting.WebSericeBaseURL__c, 'getuserinfo');
        //LOLUtilities.LogErrMsg(MOD_NAME, '### endpointURL: ' + endpointURL);        
        
        HttpRequest reqData = new HttpRequest();
        Http http = new Http();
            
        reqData.setEndpoint(endpointURL);
        reqData.setMethod('POST');

        reqData.setHeader('Content-Type','application/json');
        reqData.setHeader('Accept','application/json');
        
        reqData.setHeader('Authorization', myAuthorizationHeader);
        
        reqData.setBody('{"LoginID":"' + ag2agId + '"}');
        
        try {
            HTTPResponse res = http.send(reqData);
            
            JSONParser parser = jSon.createParser(res.getBody());
            while (parser.nextToken() != null ){
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'UserType') ) {
                    // Get value
                    parser.nextToken();
                    retValue = parser.getText();
                }
            }
        }catch(Exception exp){
            LOLUtilities.LogErrMsg(MOD_NAME, exp, 'Ag2AgId: ' + ag2agId);
            retValue = 'Not Found';
        }

        myUI.Ag2AgId = Ag2AgId;
        myUI.user_info = retValue;
        if (isCacheAvailable) { 
            Cache.Session.put(USER_INFO, myUI);        // Exception generated on LPDCR_CC_HomePage- Platform Cache put operation is not allowed here
        }

        return retValue;
    }

    /* This class is used for deserializing the JSON returned by the
     * web service call.  The name of the one variable must be UserDetailsOutput 
     * because that is the name of the list in the JSON that is returned.
    */
    private class UserDetailsOutput {
        public List<MyLinkData> UserDetailsOutput;
    }
    
    /* Just return the Home Pages for current user
    */
    public List<MyLinkData> GetMyLinkHomeSites() {
        return GetMyLinkHomeSites(getFedId());
    }
    
    /* Just return the Home Pages
    */
    public List<MyLinkData> GetMyLinkHomeSites(String Ag2AgId) {
        final String CUR_FUNC = CLASS_NAME + 'GetMyLinkHomeSites';
        //LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin: ag2agID: ' + Ag2AgId);
        
        List<MyLinkData> lstMyLinks = new List<MyLinkData>();
        
        for (MyLinkData myD :GetMyLinkData(Ag2AgId)) {
            if (myD.isHomePage) {
                lstMyLinks.add(myD);
            }           
        }

        return lstMyLinks;
    }
    
    /* Just return the Applications associated for current user
    */
    public List<MyLinkData> GetMyLinkApplications() {
        return GetMyLinkApplications(getFedId());
    }
    
    /* Just return the Applications associated with the Federation ID passed in
    */
    public List<MyLinkData> GetMyLinkApplications(String Ag2AgId) {
        final String CUR_FUNC = CLASS_NAME + 'GetMyLinkApplications';
        //LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin: ag2agID: ' + Ag2AgId);
        
        List<MyLinkData> lstMyLinks = new List<MyLinkData>();
        
        for (MyLinkData myD :GetMyLinkData(Ag2AgId)) {
            if (!myD.isHomePage) {
                lstMyLinks.add(myD);
            }           
        }

        return lstMyLinks;
    }

    /* Get a specific set of data based on the app code passed in
     */
    public MyLinkData GetSpecificMyLink(String appCode) {
        return GetSpecificMyLink(appcode, getFedId());
    }
    
    /* Get a specific set of data based on the app code passed in
     */
    public MyLinkData GetSpecificMyLink(String appCode, String Ag2AgId) {
        MyLinkData result = new MyLinkData();
        List<MyLinkData> myLD = GetMyLinkData(Ag2AgId);
        
        for (MyLinkData L :myLD) {
            if (L.app_code.equalsIgnoreCase(appCode) ) {
                result = L;
                break;
            }
        }
        
        return result;
    }
    
    
    /* Override to not need the Ag2Ag ID
     * Call the web service that returns the My Link data
     * Format that data into a usable List
     * Return that usable list to the calling method
     * Will look up the current users Federation Id and use it
    */
    private class myNoDataException extends Exception {}
    public List<MyLinkData> GetMyLinkData() {
        return GetMyLinkData(getFedId());
    }
    
    /*
     * Call the web service that returns the My Link data
     * Format that data into a usable List
     * Return that usable list to the calling method
     * Ag2AgId - The user ID that you want data returned for
    */
    public List<MyLinkData> GetMyLinkData(String Ag2AgId) {
        final String CUR_FUNC = CLASS_NAME + 'GetMyLinkData';
        final String MY_LINK_RESULT = 'LOLMyLinkUserResult' + UserInfo.getUserId();
        MyLinkResults myLR = new MyLinkResults();
        String myAg2AgId = (Ag2AgId == null ? '' : Ag2AgId);
        List<MyLinkData> lstMyLinks = new List<MyLinkData>();
        String myRequestData = '';
        boolean isCacheData = false;
        System.debug('GetMyLinkData........'+Ag2AgId);
        //LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin - ag2agID: ' + myAg2AgId);
        
        try {
            if (isCacheAvailable && Cache.Session.contains(MY_LINK_RESULT)) {
                myLR = (MyLinkResults)Cache.Session.get(MY_LINK_RESULT);
                if (myLR.Ag2AgId == myAg2AgId) {
                    system.debug('Are Results Available: ' + myLR.areResultsAvailable);
                    if (myLR.areResultsAvailable) { 
                        myRequestData = myLR.requestData;
                        isCacheData = true;
                    }
                }
            }
            else {
                myLR.Ag2AgId = myAg2AgId;
                myLR.areResultsAvailable = false;
                for (LOLMyLinksCalloutSettings__c myS : mySettings) {
                    if (myS.isActiveSetting__c == true) {
                        //msg = msg + myS.Name;
                        mySetting = myS;                
                        Blob myHeaderValue = Blob.valueOf(mySetting.WebServiceLoginId__c + ':' + mySetting.WebServicePassword__c);
                        myAuthorizationHeader = 'Basic ' + EncodingUtil.base64Encode(myHeaderValue);
                        //LOLUtilities.LogErrMsg(MOD_NAME, 'Custom Setting Name: ' + myS.Name);
                        break;
                    }
                }
                System.debug('2........'+mySetting);
                String endpointURL = LOLUtilities.buildURL(mySetting.WebSericeBaseURL__c, 'mylinkservice?userId=' + myAg2AgId);
                 
                HttpRequest reqData = new HttpRequest();
                Http http = new Http();
                
                reqData.setEndpoint(endpointURL);
                reqData.setMethod('GET');
        
                reqData.setHeader('Accept','application/json');     
                reqData.setHeader('Authorization', myAuthorizationHeader);
            
                lstMyLinks.clear();
                HTTPResponse res = http.send(reqData);
    
                if (res.getBody() == null || res.getBody().trim().Length() == 0) {
                    throw new myNoDataException('No My Link data returned for Ag2AgId: ' + myAg2AgId);
                }
                myRequestData = res.getBody();
                myLR.requestData = res.getBody();
            }
            
            UserDetailsOutput myResults = (UserDetailsOutput)JSON.deserialize(myRequestData, UserDetailsOutput.class);
                        
            set<String> setAppCodes = new set<String>();
            for (MyLinkData myRow : myResults.UserDetailsOutput ) {
                MyLinkData myL = new MyLinkData();
                myL.app_code = (myRow.app_code == null ? '' : myRow.app_code);
                myL.app_description = (myRow.app_description == null ? '' : myRow.app_description);
                myL.app_title = (myRow.app_title == null ? '' : myRow.app_title);
                myL.app_portal_url = (myRow.app_portal_url == null ? '' : myRow.app_portal_url);
                myL.app_url = (myRow.app_url == null ? '' : myRow.app_url);
                myL.home_page = (myRow.home_page == null ? '' : myRow.home_page);
                myL.user_id = (myRow.user_id == null ? '' : myRow.user_id);
                
                if (myL.app_code.Length() == 0 || myL.app_title.Length() == 0
                    || (myL.home_page == '1' && myL.app_url.Length() == 0)
                    || (myL.home_page != '1' && myL.app_portal_url.Length() == 0)
                    || setAppCodes.contains(myL.app_code) == true) {
                        continue;
                    }
/*=== Begin test code for session issue ===*/
                for ( LOLMyLinksCalloutOverrides__c myO : myOverrides ) {
                    if (myO.Is_Active__c && myL.app_code.EqualsIgnoreCase(myO.App_Code__c)) {
                        myL.app_portal_url = myO.Ovr_App_Portal_Url__c;
                        myL.app_url = myO.Ovr_App_Url__c;
                    }                    
                }
/*=== End test code for session issue ===*/                
                setAppCodes.add(myRow.app_code);
                
                lstMyLinks.add(myL);
            }
            myLR.areResultsAvailable = true;
            system.debug('Number of myLink rows: ' + lstMyLinks.size());
        }
        catch(Exception exp){
            LOLUtilities.LogErrMsg(CUR_FUNC, exp, 'Ag2AgId: ' + ag2agId);
        }
        
        if (isCacheAvailable && !isCacheData) { 
            Cache.Session.put(MY_LINK_RESULT, myLR);     // Exception generated on LPDCR_CC_HomePage- Platform Cache put operation is not allowed here
        }
        
        return lstMyLinks;        
    }    
    
    /* Find current users Federation Identifier
     */
    public String getFedId() {
        List<User> myUser = [Select Id,FederationIdentifier from User where Id = :UserInfo.getUserId() Limit 1];
        String myFedId = (myUser != null ? myUser[0].FederationIdentifier : null);
        return (myFedId == null ? '' : myFedId);
    }
}