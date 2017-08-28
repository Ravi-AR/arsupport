/**
*   @Author:    Ron Soppeland
*   @Date:      12.09.2016
*   @Purpose:   Test Class behind LOLMyLinksCallouts
*/

@isTest(SeeAllData=false)
public class LOLMyLinksCalloutsTest {
	private static final String CLASS_NAME = 'LOLMyLinksCalloutsTest.';
    
    @isTest static void testCustomSettings() {
        final String MOD_NAME = CLASS_NAME + 'testCustomSettings';
        LOLUtilities.LogErrMsg(MOD_NAME, '### Begin Test');
		loadSettings();
        
    	LOLMyLinksCallouts myCallouts = new LOLMyLinksCallouts();

        system.assertNotEquals(null, LOLMyLinksCallouts.mySettings, 'Must contain Custom Settings');
        system.assert(LOLMyLinksCallouts.mySetting.Name == 'QACustomSetting', 'Custom setting name should be QACustomSetting');
        system.debug('Number of mySettings: ' + LOLMyLinksCallouts.mySettings.size());
        system.debug('Base web service URL: ' + LOLMyLinksCallouts.mySetting.WebSericeBaseURL__c);

        LOLUtilities.LogErrMsg(MOD_NAME, '### End Test');
    }
    
    @isTest static void testGetUserInfo() {
        final String MOD_NAME = CLASS_NAME + 'testGetUserInfo';
        LOLUtilities.LogErrMsg(MOD_NAME, '### Begin Test');

        LOLMyLinksCalloutSettings__c mySetting = new LOLMyLinksCalloutSettings__c();
        mySetting.Name = 'QACustomSetting';
        mySetting.ExternalUserProfileURL__c = 'https://uat-landolakesinc.cs17.force.com/ems/profile';
        mySetting.InternalUserProfileURL__c = 'https://landolakes.service-now.com/selfservice/order_security_access.do';
        mySetting.isActiveSetting__c = true;
        mySetting.WebSericeBaseURL__c = 'https://wsqa.landolakesinc.com/QA/api/idm/';
        mySetting.WebServiceLoginId__c = '516566e';
        mySetting.WebServicePassword__c = '0rangeP1zzA34!56';
        
        LOLMyLinksCallouts myCallouts = new LOLMyLinksCallouts(mySetting);
        
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LOLMyLinksCalloutsUserInfo');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call method to test
        String result = myCallouts.GetUserInfo('sopper81');
        
        // Verify mock response is not null
        System.assertNotEquals(null, result, 'The callout returned a null response.');
        System.assertEquals('Internal', result, 'The callout returned an invalid response.');
        system.debug(MOD_NAME + ' - result: ' + result);
        
        // Call method to test to check Cacheing
        result = myCallouts.GetUserInfo('sopper81');
        
        String myResult = myCallouts.GetUserProfileURL('sopper81');
        system.debug('~~~User Profile URL: ' + myResult);
        system.assertEquals(true, myResult.trim().length() > 0, 'No Profile URL found for sopper81');
        
        // Call optional method to test 
        result = myCallouts.GetUserInfo();

        LOLUtilities.LogErrMsg(MOD_NAME, '### End Test');
    }
    
    @isTest static  void testGetMyLinkData() {
		List<LOLMyLinksCallouts.MyLinkData> lstMyLinkData = new List<LOLMyLinksCallouts.MyLinkData>();
        final String MOD_NAME = CLASS_NAME + 'testGetMyLinkData';        
        LOLUtilities.LogErrMsg(MOD_NAME, '### Begin Test');

        //loadSettings();
    	LOLMyLinksCallouts myCallouts = new LOLMyLinksCallouts();

		// Load the mock my links data
		loadMyLinksCalloutsDataMock();
		        
        // Call method to test
		lstMyLinkData = myCallouts.GetMyLinkData('sopper81');
        
        // Verify mock response is not null
        System.assertNotEquals(null, lstMyLinkData, 'The callout returned a null response.');
        System.assertEquals(4, lstMyLinkData.size(), 'The array should only contain 4 items.'); 
        
        LOLMyLinksCallouts.MyLinkData myRow = lstMyLinkData.get(0);
        System.assertEquals(true, myRow.app_code.equals('agrimine') , 'App_Code should be agrimine');
        System.assertEquals(false, myRow.isHomePage, 'Home Page[0] should be false');
        System.assertEquals(true, myRow.myAppUrl.equals('https://ssoqa.landolakesinc.com/idp/startSSO.ping?PartnerSpId=xsinc')
                            , 'myAppUrl did not match');
        myRow.app_description = null;
        System.assertEquals(true, myRow.myAppDescription.equals('AgriMine'), 'myAppDesctiption should be "AgriMine"');

        myRow = lstMyLinkData.get(1);
        System.assertEquals(true, myRow.app_code.equals('pmi_livestockmanuals') , 'App_Code should be pmi_livestockmanuals');
        //system.assert(myRow.myAppUrl.EqualsIgnoreCase(OVR_AGRIMINE_URL), 'App URL ' + myRow.myAppUrl + ' - must be ' + OVR_AGRIMINE_URL);
                    
        myRow = lstMyLinkData.get(2);
        System.assertEquals(true, myRow.app_code.equals('wfagportal') , 'App_Code should be wfagportal');
        System.assertEquals(true, myRow.isHomePage, 'Home Page[1] should be true');
        System.assertEquals(true, myRow.myAppUrl.equals('https://qa.lolportals.com/webcenter/spaces/PtlWfAg'), 'myAppUrl did not match');
        System.assertEquals(true, myRow.myAppDescription.equals('WinField Ag Business Link')
                            , 'myAppDesctiption should be "WinField Ag Business Link"');

        myRow = lstMyLinkData.get(3);
        System.assertEquals(true, myRow.app_code.equals('wfppgportal') , 'App_Code should be wfppgportal');
        System.assertEquals(true, myRow.myAppDescription.equals('Home page for WinField PPG')
                            , 'myAppDesctiption should be "Home page for WinField PPG"');

        // Call Home Pages only method to test
        lstMyLinkData = new List<LOLMyLinksCallouts.MyLinkData>();
		lstMyLinkData = myCallouts.GetMyLinkHomeSites('sopper81');
		System.assertEquals(true, lstMyLinkData.size() == 2, 'Should have 2 home pages');
        
        // Call Applications only method to test
        lstMyLinkData = new List<LOLMyLinksCallouts.MyLinkData>();
		lstMyLinkData = myCallouts.GetMyLinkApplications('sopper81');
		System.assertEquals(true, lstMyLinkData.size() == 2, 'Should have 2 applications');
        
        // Call optional methods
		lstMyLinkData = myCallouts.GetMyLinkData();
		lstMyLinkData = myCallouts.GetMyLinkHomeSites();
		lstMyLinkData = myCallouts.GetMyLinkApplications();
        
        // Call GetSpecificMyLink to verify it can return a specific one
        final String testCode = 'AgriMine';
        LOLMyLinksCallouts.MyLinkData myApp = myCallouts.GetSpecificMyLink(testCode, 'sopper81');
        system.assert(myApp.app_code.EqualsIgnoreCase(testCode), 'App Code must be ' + testCode);

        LOLUtilities.LogErrMsg(MOD_NAME, '### End Test');
    }  
    
    /* Load the static resource for getting the test My Link data
    */
    public static void loadMyLinksCalloutsDataMock() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LOLMyLinksCalloutsData');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
    }

    @isTest static  void testGetMyLinkDataNull() {
		List<LOLMyLinksCallouts.MyLinkData> lstMyLinkData = new List<LOLMyLinksCallouts.MyLinkData>();
        final String MOD_NAME = CLASS_NAME + 'testGetMyLinkDataNull';
        LOLUtilities.LogErrMsg(MOD_NAME, '### Begin Test');

        //loadSettings();
    	LOLMyLinksCallouts myCallouts = new LOLMyLinksCallouts();

        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LOLMyLinksCalloutsDataNull');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        // Call method to test
		lstMyLinkData = myCallouts.GetMyLinkData('sopper81');        

        LOLUtilities.LogErrMsg(MOD_NAME, '### End Test');
    }

    /*
     * Load the static resource for getting the UserInfo
     */
    static void loadUserInfoMock() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('LOLMyLinksCalloutsUserInfo');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
    }   
    
    /* 
     * Load the Custom Settings for the LOLMyLinksCallouts class
     */
    static void loadSettings() {
        final String CUR_FUNC = CLASS_NAME + 'loadSettings';
        //return;
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Load');
        system.debug(CUR_FUNC + ' - Begin Load');
        try {                  
        	loadLOLMyLinksCalloutOverrides();
            List<LOLMyLinksCalloutSettings__c> mySettingList = [Select Id, Name from LOLMyLinksCalloutSettings__c];
            LOLMyLinksCalloutSettings__c mySetting = new LOLMyLinksCalloutSettings__c();
            If (mySettingList != Null && mySettingList.size() > 0 && mySettingList[0].Name == 'QACustomSetting') {
                return;
            }
			system.debug('Create Custom Setting QACustomSetting');
            mySetting.Name = 'QACustomSetting';
            mySetting.ExternalUserProfileURL__c = 'https://uat-landolakesinc.cs17.force.com/ems/profile';
            mySetting.InternalUserProfileURL__c = 'https://landolakes.service-now.com/selfservice/order_security_access.do';
            mySetting.isActiveSetting__c = true;
            mySetting.WebSericeBaseURL__c = 'https://wsqa.landolakesinc.com/QA/api/idm/';
            mySetting.WebServiceLoginId__c = '516566e';
            mySetting.WebServicePassword__c = '0rangeP1zzA34!56';
            
            insert mySetting;
        }
        catch(Exception e){
            system.debug(CUR_FUNC + ' - ' + e);
            LOLUtilities.LogErrMsg(CUR_FUNC, e, 'Unable to insert Custom Setting row');
        }
        LOLUtilities.LogErrMsg(CUR_FUNC, '### End Load');
    }

    /* Load LOL My Links Callout Override object data
     */
    final static String OVR_APP_CODE = 'pmi_livestockmanuals';
    final static String OVR_AGRIMINE_URL = 'http://RoadToNowhere.com';
    private static void loadLOLMyLinksCalloutOverrides() {
        final String CUR_FUNC = CLASS_NAME + 'loadLOLMyLinksCalloutOverrides';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Load');
        
        List<LOLMyLinksCalloutOverrides__c> lstOvr = [Select Id, App_Code__c from LOLMyLinksCalloutOverrides__c];        
        
        If (lstOvr == null || lstOvr.size() == 0 || lstOvr[0].App_Code__c != OVR_APP_CODE) {
    		LOLMyLinksCalloutOverrides__c myOvr = new LOLMyLinksCalloutOverrides__c();
            myOvr.App_Code__c = OVR_APP_CODE;
            myOvr.Name = 'Ovr_' + OVR_APP_CODE;
            myOvr.Is_Active__c = true;
            myOvr.Ovr_App_Portal_Url__c = OVR_AGRIMINE_URL;
            myOvr.Ovr_App_Url__c = OVR_AGRIMINE_URL;
            insert myOvr;
        }
        LOLUtilities.LogErrMsg(CUR_FUNC, '### End Load');
    }    
}