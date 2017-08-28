/**
* Batch function to send Emails to Sellers to notify them
* of Reimbursement Requests that they need to approve
* 
* @Date: 01.09.2017
* @Author: Ron Soppeland
* 
* In order to test this class; click on Debug -> Open Execute Anonoymous Window.
* Then paste in the following commands and click on Execute:
LPDCR_ReimbursementRequestNotification bc = new LPDCR_ReimbursementRequestNotification();
    database.executeBatch(bc, 2000);
*
* @Updates:
*/

global class LPDCR_ReimbursementRequestNotification implements Database.Batchable<sObject> {
    
    private static final String CLASS_NAME = 'LPDCR_ReimbursementRequestNotification.';
    
    private static map<ID, Integer> myUserCtr = new map<ID, Integer>();
    private static map<String, String> myApprovalStatus = new map<String, String>();
    //private static map<String, String> myProfile = new map<String, String>();  Profile filtering is no longer being used
    private static set<String> myUserIdFilter = new set<String>();
    private static boolean isTestMode = true;
    private static ID TestModeID = '005R0000002aRk2';   // ID value of user to send all emails to if isTestMode is true
    //private static final ID totalCountID = ID.valueOf('000000000000001');

    /* Constructor
     */
    global LPDCR_ReimbursementRequestNotification() { 
        final String CUR_FUNC = CLASS_NAME + 'Constructor';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Constructor ###');
    }
    
    /* 
    ** Get the values from the Custom Setting and load them into the class variables
    */
    private void processCustomSettings() {
        final String CUR_FUNC = CLASS_NAME + 'processCustomSettings';
        for (LPDCR_ReimbursementRequestNotification_C__c C :LPDCR_ReimbursementRequestNotification_C__c.getAll().values()) {
            LOLUtilities.LogErrMsg(CUR_FUNC, '### ' + C.Name
                + ' - Is Active: ' + C.Is_Active_Setting__c
                + ' - Config Type: ' + C.Config_Type__c
                + ' - Config Setting: ' + C.Config_Setting__c);

            if (C.Config_Type__c.equals('TestMode')) {
                //isTestMode = true;//old
                isTestMode = C.Is_Active_Setting__c;
                TestModeID = C.Config_Setting__c;
            }
            if (C.Is_Active_Setting__c == false) {
                continue;
            }
            String key = (C.Config_Setting__c == null ? '' : C.Config_Setting__c);
            String value = (C.Config_Setting__c == null ? '' : '\'' + C.Config_Setting__c + '\'');
            
            if (C.Config_Type__c.equals('Status')) {
                if (myApprovalStatus == null || myApprovalStatus.size() == 0 || myApprovalStatus.containsKey(key) == false) {
                    myApprovalStatus.put(key, value);
                }
            }
            
/*            if (C.Config_Type__c.equals('Profile')) {
                if (myProfile == null || myProfile.size() == 0 || myProfile.containsKey(key) == false) {
                    myProfile.put(key, value);
                }
            }
 */           
        }

        
        system.debug('myApprovalStatus key: ' + myApprovalStatus.keySet() );
        system.debug('myApprovalStatus values: ' + myApprovalStatus.values() );
        //system.debug('myProfile key: ' + myProfile.keySet());
        //system.debug('myProfile values: ' + myProfile.values());
        system.debug('isTestMode: ' + isTestMode + ' - TestModeId: ' + TestModeId);
    }
    
    /* Start method
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        final String CUR_FUNC = CLASS_NAME + 'start';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Processing ###');
        
        return Database.getQueryLocator([SELECT Email,FirstName,Full_Name__c,Id,LastName,Profile_Current__c FROM User 
                                         WHERE IsActive = true
                                         and Id in (Select CurrentApprover__c from AMASellingSupportExpense__c)]);  
    }
    
    /* execute method
     * Takes in a list of Reimbursements requests from start
     * Counts them based on the Approval Statuses
     */
    global void execute(Database.BatchableContext BC, list<User> myData) {
        final String CUR_FUNC = CLASS_NAME + 'execute';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Processing ###');

        processCustomSettings();
                        
        string myQry = 'SELECT ApprovalStatus__c ,CurrentApprover__c,Id FROM AMASellingSupportExpense__c ' 
            + 'Where IsDeleted = false and ApprovalStatus__c != null and CurrentApprover__c != null '
            + 'And ApprovalStatus__c in ' + myApprovalStatus.values();

        system.debug('myQry: ' + myQry);
        list<AMASellingSupportExpense__c> myRequests = Database.query(myQry);
        system.debug('myRequests size: ' + myRequests.size());
        
        for (User U : myData) {
            // Do NOT send an email to the SFDC Admin user 
            if (U.Email.Contains('purinacrmsupport@landolakes.com') ) { continue; }
            
            for (AMASellingSupportExpense__c R : myRequests) {
                if (R.ApprovalStatus__c == null || !myApprovalStatus.containsKey(R.ApprovalStatus__c)) { continue; }
                
                // The user is associated with the Request based on:
                // - They are the current responsible person for the Request

                if (R.CurrentApprover__c.Equals(U.Id) ) {
                    if (myUserCtr.isEmpty() || !myUserCtr.containsKey(U.Id)) {
                        myUserCtr.put(U.Id, 1);
                    }
                    else {
                        Integer c = myUserCtr.get(U.Id);
                        myUserCtr.put(U.Id, ++c);
                    }
                }
            }
        }
                
        // Send the emails
        execute_SendEmail(myData);
    }
        
    /* Send the emails 
    */
    private void execute_SendEmail(List<User> inUsers) {
        final String CUR_FUNC = CLASS_NAME + 'execute_SendEmail';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Processing ###');
        
        String mySummaryBody = 'Messages from: ' + CUR_FUNC;
        system.debug('myUserCtr: ' + myUserCtr.size());
        
        try {
            List<Messaging.SingleEmailMessage> allMail = new List<Messaging.SingleEmailMessage>();

            for (User U : inUsers) {                
                // get the data to report on                
                if (!myUserCtr.containsKey(U.id)) { continue; }

                // Add email init and header stuff
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId((isTestMode ? TestModeID : U.Id));
                //mail.setTargetObjectId(TestModeID);
                mail.setSenderDisplayName('Salesforce Purina');     // make a config item
                mail.setSubject('Reimbursement Request Status');    // make a config item

                // Use a String variable to store the html body - if needed
                // 'Dear Purina Sales Team:<br /><br />'
                string myHtmlBody = 'Dear ' + U.Full_Name__c.trim() + ':<br /><br />'
                    + 'Here is your current activity report for customer accounts registered in the Business Builder Program: <br /><br />';
                
                // Use a String variable to store the text body
                // 'Dear Purina Sales Team: /r/n/r/n'
                String myTextBody = 'Dear ' + U.Full_Name__c.trim() + ': /r/n/r/n'
                    + 'Here is your current activity report for customer accounts registered in the Business Builder Program: /r/n/r/n';
                
                // Load variable information into the body
                integer ctr = myUserCtr.get(U.id);

                myTextBody += 'You have ' + ctr + (ctr == 1 ? ' request that requires ' : ' requests that require ') + 'your attention. /r/n';
                myHtmlBody += 'You have ' + ctr + (ctr == 1 ? ' request that requires ' : ' requests that require ') + 'your attention. <br /><br />';
                
                // Load footer information
                myHtmlBody += 'Please review and prepare your action items as needed. You can login to Salesforce Purina via '
                    + '<a href="https://www.purinamills.com/businesslink/login">Purina Business Link</a> <br /><br />'
                    + 'Thanks for encouraging our customers to participate in the Business Builder Selling Support Program.<br /><br />'
                    + 'If you have additional questions, please contact customer service at '
                    + '<a href="mailto:businessbuildersupport@landolakes.com" >businessbuildersupport@landolakes.com</a> or 1-855-333-3565.';

                myTextBody += 'Please review and prepare your action items as needed. /r/n/r/n'
                    + 'Thanks for encouraging our customers to participate in the Business Builder Selling Support Program. /r/n/r/n'
                    + 'If you have additional questions, please contact customer service at businessbuildersupport@landolakes.com or 1-855-333-3565.';
                
                //system.debug(myTextBody);
                mail.setHtmlBody(myHtmlBody);
                mail.setPlainTextBody(myTextBody);
                mail.setSaveAsActivity(false);
                
                if (ctr > 0) {
                    allMail.add(mail);
                }
            }

            // Send the email
            mySummaryBody += '<br />Number of emails to send: ' + allMail.size();
            Messaging.reserveSingleEmailCapacity(allMail.size());
            Messaging.sendEmail(allMail);
            
            LOLUtilities.LogErrMsg(CUR_FUNC, mySummaryBody, isTestMode);
            
        }
        catch (Exception e)
        {
            LOLUtilities.LogErrMsg(CUR_FUNC, e, '@@@ ERROR @@@');
        }               
    }
    
    /* finish method
     * Send the emails to each User
     */
    global void finish(Database.BatchableContext BC) {
        final String CUR_FUNC = CLASS_NAME + 'finish';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### End Processing ###', isTestMode);
    }
           
}