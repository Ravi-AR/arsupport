@istest
public class Account_Error_AnimalCountTest {

    private static testmethod void accountErrorAnimalCountTest()
    {
        Account acc = new Account( name = 'test account' );
        insert acc;
        
        Animal_Count_Lifestage__c animalCount = new Animal_Count_Lifestage__c(Account__c = acc.id,
                                                                              Animal_Count__c = 5,
                                                                              Animals_Served__c = 5,
                                                                              Animal_Type__c = 'Cattle',
                                                                              Lifestage__c = 'Back Grounder');
        PageReference theAnimalPage = Page.CreateAnimalCountLife;
        test.setCurrentPage(theAnimalPage);
        
        Account_Error_AnimalCount accountErrorAnimalCont
            = new Account_Error_AnimalCountExt(new ApexPages.StandardController(animalCount));
        
        test.startTest();
        accountErrorAnimalCont.Tsave();
        test.stoptest();
        
    }
    
}