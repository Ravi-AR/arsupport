@isTest
public class LMSA_SelectedManagementTipsCtrlrTest {

    @isTest
    static void SelectedManagementTipsControllerTest(){
        Tip__c t = new Tip__c();
        t.Name = 'Test Tip';
        t.Tip__c = 'Please Test';
        t.Facility_Question__c = 'What is tips?';
        insert t;
        
        User u = new User( Id = UserInfo.getUserId() );
        u.Selected_Management_Tips__c = t.Id ;
        update u;
        
        LMSA_SelectedManagementTipsController controller = new LMSA_SelectedManagementTipsController();
        system.assert( controller.tips.size() == 1);
    }
}