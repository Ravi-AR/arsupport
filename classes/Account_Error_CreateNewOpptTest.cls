@istest
public class Account_Error_CreateNewOpptTest {

    private static testmethod void accountErrorCreateNewOppt()
    {
        Account acc = new Account( name = 'test accont');
        insert acc;
        
        Opportunity oppty = new Opportunity( Name = 'test opportunity',
                                           accountId = acc.Id);
        
        PageReference theOpptyPage = Page.Account_Error_createOpportunity;
        test.setCurrentPage(theOpptyPage);
        
        Account_Error_CreateNewOppt accCreateOppty
            = new Account_Error_CreateNewOpptExt(new ApexPages.StandardController(oppty));
        
        test.starttest();
        
        accCreateOppty.tempOpp = oppty;
        accCreateOppty.Tsave();
        
        test.stoptest();
        
        System.assert(accCreateOppty.tempOpp != null);
        
    }
}