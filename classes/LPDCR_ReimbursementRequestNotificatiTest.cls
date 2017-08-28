/**
*   @Author:    Ron Soppeland
*   @Date:      01.23.2017
*   @Purpose:   Test Class behind LPDCR_ReimbursementRequestNotification
*/

@isTest(SeeAllData=False)
public with sharing class LPDCR_ReimbursementRequestNotificatiTest {
    private final static String CLS_NAME = 'LPDCR_ReimbursementRequestNotificatiTest.';

    static testMethod void testClass() {
        String CUR_FUNC = CLS_NAME + 'testClass';
        LOLUtilities.LogErrMsg(CUR_FUNC, '### Begin Constructor ###');
        
        try {
            User runAsUser = [ Select Id From User Where Id = :UserInfo.getUserId() ];
            System.runAs(runAsUser) {
            
                // Create User record for the test
                User u1 = LPDCR_TestUtil.getCommunityUser();
                system.debug('User id: ' + u1.Id);

                // Create the Custom Setting data
                LPDCR_ReimbursementRequestNotification_C__c custData = new LPDCR_ReimbursementRequestNotification_C__c();
                custData.Name = 'Approval setting 1';
                custData.Is_Active_Setting__c = true;
                custData.Config_Type__c = 'Status';
                custData.Config_Setting__c = 'In Progress';
                insert custData;
                
                custData.clear();
                custData.Name = 'Approval setting 2';
                custData.Is_Active_Setting__c = true;
                custData.Config_Type__c = 'Status';
                custData.Config_Setting__c = 'Submitted for Approval';
                insert custData;
                
                custData.clear();
                custData.Name = 'Profile setting 1';
                custData.Is_Active_Setting__c = false;
                custData.Config_Type__c = 'Profile';
                custData.Config_Setting__c = 'No Longer Used';
                insert custData;
                
                custData.clear();
                custData.Name = 'Test Mode setting';
                custData.Is_Active_Setting__c = true;
                custData.Config_Type__c = 'TestMode';
                custData.Config_Setting__c = u1.Id;
                insert custData;
                Test.startTest();
                // Create Expenxe records for the test
                AMASellingSupportExpense__c e1 = LPDCR_TestUtil.getSSExpenseRecord();
                String oldValS = (String)e1.put('ApprovalStatus__c', 'In Progress');
                ID oldVal = (ID)e1.put('CurrentApprover__c', u1.Id);
                update e1;
                
                AMASellingSupportExpense__c e2 = LPDCR_TestUtil.getSSExpenseRecord();
                oldValS = (String)e2.put('ApprovalStatus__c', 'Submitted for Approval');
                oldVal = (ID)e2.put('CurrentApprover__c', u1.Id);
                update e2;
                
                List<AMASellingSupportExpense__c> eList = [Select ID ,ApprovalStatus__c ,CurrentApprover__c ,IsDeleted from AMASellingSupportExpense__c];
                system.debug('eList size: ' + eList.size());
                for (AMASellingSupportExpense__c l : eList){
                    system.debug('l.ID :' + l.ID);
                    system.debug('l.ApprovalStatus__c :' + l.ApprovalStatus__c);
                    system.debug('l.CurrentApprover__c :' + l.CurrentApprover__c);
                    system.debug('l.IsDeleted :' + l.IsDeleted);
                }
                // Run the test
                String myBatchID = '';
                
                //LPDCR_ReimbursementRequestNotification C = new LPDCR_ReimbursementRequestNotification();
                //ID batchID = Database.executeBatch(C, 2000);
                LPDCR_ReimbursementRequestNotify_Sched schNotify = new LPDCR_ReimbursementRequestNotify_Sched();
                String sch ='20 30 8 10 2 ?';                
                String jobId = System.schedule('ScheduleJob',sch,schNotify);
                Test.stopTest();
            }
        }
        catch (Exception e1) {
            LOLUtilities.LogErrMsg(CUR_FUNC, e1);
        }       
    }
}