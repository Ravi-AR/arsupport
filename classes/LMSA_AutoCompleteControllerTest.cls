@isTest
public class LMSA_AutoCompleteControllerTest {

    @isTest
    static void AutoCompleteControllerTest(){
        Contact c = new Contact();
        c.LastName = 'This is Test';
        insert c;
        
        LMSA_AutoCompleteController.findSObjects('Contact', 'select Id from Contact', '003', '');
        LMSA_AutoCompleteController.findSObjects('Contact', 'select Id from Contact', '003', 'test');
        LMSA_AutoCompleteController.findSObjects(null, 'select Id from Contact', '003', '');
        LMSA_AutoCompleteController.findSObjects(null, 'select Name__cr from Contact', 'xxx', '');
    }
}