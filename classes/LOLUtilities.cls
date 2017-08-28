/**
*   @Author:    Ron Soppeland
*   @Date:      11.29.2016
*   @Purpose:   Utility Methods
*/

public class LOLUtilities {
	private static final String CLASS_NAME = 'LOLUtilities.';
    private class CommonException extends Exception {}
    
    // The following List represents all settings for LOLUtilities
    public static List<LOLUtilitiesSettings__c> myLolUtilitySettings = LOLUtilitiesSettings__c.getAll().values();
    // The following constant and variable are for just the LogErrMsgSettings entry
    // Which is required for any logged emails to be automatically emailed to a user
    @TestVisible private static final String LOG_ERR_MSG_SETTINGS = 'LogErrMsgSettings';
    @TestVisible private static LOLUtilitiesSettings__c myLogErrMsgSettings = null;
    
    /* Standard format for dumping an exception to the log file
     * mySource should be the Class and Method that invoked this method
     * myComment should be any comments to be added to the log
    */ 
    public static void LogErrMsg(String mySource, String myComment){
        LogErrMsg(mySource, Null, MyComment, false);
    }

    /* Standard format for dumping an exception to the log file
     * mySource should be the Class and Method that invoked this method
     * myComment should be any comments to be added to the log
    */ 
    public static void LogErrMsg(String mySource, String myComment, Boolean isChkEmail){
        LogErrMsg(mySource, Null, MyComment, isChkEmail);
    }

    /* Standard format for dumping an exception to the log file
     * mySource should be the Class and Method that invoked this method
     * myException should be an exception to be logged
    */ 
    public static void LogErrMsg(String mySource, Exception myException){
        LogErrMsg(mySource, myException, null);
    }

    /* Standard format for dumping an exception to the log file
     * myException should be an exception to be logged
    */ 
    public static void LogErrMsg(Exception myException){
        LogErrMsg(null, myException, null);
    }

    /* Standard format for dumping an exception to the log file
     * mySource should be the Class and Method that invoked this method
     * myComment should be any supporting information that may be needed
     * myException should be an exception to be logged
    */ 
    public static void LogErrMsg(String mySource, Exception myException, String myComment){
        myLogErrMsgSettings = getMyLolUtilitySettings(LOG_ERR_MSG_SETTINGS);
        
        LogErrMsg(mySource, myException, myComment, true);
    }
    
    /* Standard format for dumping an exception to the log file
     * mySource should be the Class and Method that invoked this method
     * myComment should be any supporting information that may be needed
     * myException should be an exception to be logged
    */ 
    private static void LogErrMsg(String mySource, Exception myException, String myComment, Boolean isChkEmail){
        String myEmailMsg = '';
        
        myEmailMsg = '#E# UserInfo - Name: ' + UserInfo.getName() 
                    + ' - UserName: ' + UserInfo.getUserName() 
                    + ' - UserId: ' + UserInfo.getUserId();
        System.debug(myEmailMsg);
        
        if (mySource != null) { 
            System.debug('#E# Source: ' + mySource); 
            myEmailMsg += '\r\n#E# Source: ' + mySource;
        }
        
        if (myComment != null) { 
            System.debug('#E# Comment: ' + myComment);
            myEmailMsg += '\r\n#E# Comment: ' + myComment;
        }
        
        if (myException != null) {
            System.debug('#E# Type: ' + myException.getTypeName());
            myEmailMsg += '\r\n#E# Type: ' + myException.getTypeName();
            System.debug('#E# Message: ' + myException.getMessage());
            myEmailMsg += '\r\n#E# Message: ' + myException.getMessage();
            System.debug('#E# Cause: ' + myException.getCause());
            myEmailMsg += '\r\n#E# Cause: ' + myException.getCause();
            System.debug('#E# Line: ' + myException.getLineNumber());
            myEmailMsg += '\r\n#E# Line: ' + myException.getLineNumber();
            System.debug('#E# Stack Trace: ' + myException.getStackTraceString());
            myEmailMsg += '\r\n#E# Stack Trace: ' + myException.getStackTraceString();
        }
        
        if (isChkEmail && myLogErrMsgSettings != null && myLogErrMsgSettings.cfgIsYorN__c == true ) {
            EmailErrMsg(myEmailMsg);
        }
    }

    /* 
     * Send an email version of the message if the email flag is turned on
     * Send the email to the email address in the setting
     * 
    */
    @TestVisible private static void EmailErrMsg(String myMsg) {                
        try {
	        if (myLogErrMsgSettings == null) { 
                throw new CommonException('Log Err Msg Settings record is null');
            }
            Messaging.reserveSingleEmailCapacity(1);
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	String[] toAddresses = new String[] { myLogErrMsgSettings.cfgEmail__c};
            LogErrMsg(CLASS_NAME + 'EmailErrMsg', 'email: ' + myLogErrMsgSettings.cfgEmail__c);
			mail.setToAddresses(toAddresses);
			mail.setSenderDisplayName('#E# System Error');
			mail.setSubject('#E# Error Occured');
			mail.setPlainTextBody(myMsg);
            mail.setHtmlBody(myMsg);

           	//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
            	LogErrMsg(CLASS_NAME + 'EmailErrMsg', 'The email was sent successfully.');
            } 
            else {
            	LogErrMsg(CLASS_NAME + 'EmailErrMsg', 'The email failed to send: ' + results[0].errors[0].message);
			}

        }
        catch (Exception e)
        {
			LogErrMsg(CLASS_NAME + 'EmailErrMsg', e, null, false);
        }        
    }
    
    /* 
     * Return a row matching the name that is passed in
     */
    public static LOLUtilitiesSettings__c getMyLolUtilitySettings(String strName) {
        LOLUtilitiesSettings__c retValue = null;
        
        for (LOLUtilitiesSettings__c myU : myLolUtilitySettings) {
            if (myU.Name == strName ) {
                retValue = myU;
                break;
            }
        }
        
        return retValue;
    }
    
    public static String buildURL(String inBaseUrl, String inExtUrl) {
        String retValue = '';
        if (inBaseUrl != null) {
        	retValue = inBaseUrl.trim();
        }
        
        if (retValue.endswith('/')) {
        	retValue = retValue + inExtUrl.trim();
        }
        else {
        	retValue = retValue + '/' + inExtUrl.trim();
        }
        
        return retValue;
    }
}