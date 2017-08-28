/**
@Purpose:   Test class for LPDCR_AccountContactRelationHandler
**/

@isTest

public class LPDCR_AccountContactHandlerTest {
    
  
    public static testMethod void AccountContactHandlerUnitTest(){
        
        Account a1 = new Account();
        a1.name = 'Test Account1';
        a1.Business_Builder_Program_Tier__c='Certified Expert Dealer';
        a1.BusinessBuilderProgramStatus__c = 'Registration Approved';
        
        //insert Account
        insert a1;
        
        
        
        system.runAs(new User(Id=UserInfo.getUserId()))
        {
        
        User pu = LPDCR_TestUtil.getCommunityUser();
        
        User pu2 = [Select Id,ContactId,Contact.AccountId FROM User where Id=:pu.id ];
        AccountContactRelation acr = new AccountContactRelation ();
        acr.AccountId = a1.Id;
        acr.ContactId = pu2.ContactId;
        acr.AuthorizedBusinessBuilderParentAR__c = true;
            //insert Account Contact Relationship
        test.startTest();
        insert acr;
        
        AccountContactRelation acr2 = new AccountContactRelation(Id = acr.Id);
        acr2.AuthorizedBusinessBuilderParentAR__c = false;
        update acr2;
        
        delete acr2;
        test.stopTest();
        }
        
    }
}