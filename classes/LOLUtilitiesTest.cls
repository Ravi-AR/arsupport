/**
*   @Author:    Ron Soppeland
*   @Date:      11.29.2016
*   @Purpose:   Test Class behind LOLUtilities
*/

@isTest(SeeAllData=False)	// SeeAllData=True needed for getting Custom Settings
public class LOLUtilitiesTest {
    private final static String CLS_NAME = 'LOL_UtilitiesTest.';
    private class aTestException extends Exception {}
    
    public LOLUtilitiesTest() {
        loadSettings();
    }
        
    static testMethod void testLogErrMsg() {
        final String CUR_FUNC = CLS_NAME + 'testLogErrMsg';
        loadSettings();
        
        LOLUtilities.LogErrMsg(CUR_FUNC, 'Message Only Test', true);
        
        for (LOLUtilitiesSettings__c myU : LOLUtilities.myLolUtilitySettings) {
            system.debug('$$$ Setting: ' + myU.Name);
            LOLUtilities.LogErrMsg(CUR_FUNC,'Name: ' + myU.Name 
                + ' - cfgIsYorN: ' + myU.cfgIsYorN__c
                + ' - cfgText: ' + myU.cfgText__c
                + ' - cfgEmail: ' + myU.cfgEmail__c);
        }

        try {
            throw new aTestException('Test name and exception only');
        }
        catch (Exception e1) {
            LOLUtilities.LogErrMsg(CUR_FUNC, e1);
        }
        
        try {           
            throw new aTestException('Test exception only');
        }
        catch (Exception e1) {
            LOLUtilities.LogErrMsg(e1);
        }
        
        try{
            integer i = 10;
            i = i / 0;
        }
        catch(Exception e){
            LOLUtilities.LogErrMsg(CUR_FUNC, e, 'This should be a divide by 0 error');
        }
    }
    
    static testMethod void testEmailErrMsg() {
        final String CUR_FUNC = CLS_NAME + 'testLogErrMsg';
        loadSettings();
        LOLUtilities.LogErrMsg(CUR_FUNC, 'Begin testMethod');
        LOLUtilities.myLogErrMsgSettings = null;
        LOLUtilities.EmailErrMsg('Test EmailErrMsg No Settings');

        LOLUtilities.myLogErrMsgSettings = LOLUtilities.getMyLolUtilitySettings(LOLUtilities.LOG_ERR_MSG_SETTINGS);
        LOLUtilities.EmailErrMsg('Test EmailErrMsg With Settings');

    } 
    
    static testMethod void testbuildURL() {
        String testResult = LOLUtilities.buildURL('https://testWebService.com/api', 'getTest');
        loadSettings();
        system.assertEquals('https://testWebService.com/api/getTest', testResult, '!!!Failed to add a forward slash');
        
        testResult = LOLUtilities.buildURL('https://testWebService.com/api/', 'getTest');
        system.assertEquals('https://testWebService.com/api/getTest', testResult, '!!!Failed to format test string correctly');
    }
    
    static void loadSettings() {	
        final String CUR_FUNC = CLS_NAME + 'loadSettings';
        system.debug('$$$ Begin loadSettings');
        try {
            List<LOLUtilitiesSettings__c> mySettings = [Select Name,cfgEmail__c,cfgIsYorN__c,cfgText__c 
                From LOLUtilitiesSettings__c Where Name = 'LogErrMsgSettings' limit 1];
            LOLUtilitiesSettings__c mySetting = new LOLUtilitiesSettings__c();
            if (mySettings != null && mySettings.size() > 0) {
                system.debug('$$$ setting found');
                mySetting = mySettings[0];
            }
            mySetting.Name = 'LogErrMsgSettings';
            mySetting.cfgEmail__c = 'rdsoppeland@landolakes.com';
            mySetting.cfgIsYorN__c = true;
            mySetting.cfgText__c = 'Test Mode: ' + mySetting.cfgIsYorN__c;
                
            Database.insert(mySetting);
	        system.debug('$$$ Setting inserted');
        }
        catch(Exception e){
            LOLUtilities.LogErrMsg(CUR_FUNC, e, 'Unable to insert Custom Setting row');
        }
        system.debug('$$$ End loadSettings');
    }
}