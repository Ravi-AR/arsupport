@istest
public class Account_Error_CreateNewContactContTest {
    
    private static testmethod void accountErrorCreateNewTest()
    {
        Account account = new Account( name = 'test account' );
        insert account;
        
        Contact c = new contact( Lastname = 'test',
                                accountId = account.id);
       
        PageReference accErrorPage = Page.Account_Error_createContact;
        test.setCurrentPage(accErrorPage);
        
        Account_Error_CreateNewContactController accErrNewContactCont
            = new Account_Error_CreateNewContactContExt(new ApexPages.standardController(c));
       
        test.startTest();
        accErrNewContactCont.save();
        test.stopTest();
    }

}