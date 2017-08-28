/**
 * Test Class for  UserTriggerHelper
 * @DateCreated: 4/7/2016
 * @Author: Mounika Nagapuri (Magnet360)
 */
@isTest
private class UserTriggerHelperTest{
    private static testmethod void postivetests(){
        

        UserRole uRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = uRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test11@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago',
            Sales_Division__C = 'Red River Area',
            Cattle__c = true
        );
        Database.insert(portalAccountOwner1);
        
 
        
        portalAccountOwner1.horse__c = true;
        update portalAccountOwner1;
        
 

        
        Account portalAccount1 = new Account();
        System.runAs ( portalAccountOwner1 ) {
            //Create account
            portalAccount1 = new Account(
                Name = 'TestAccount',
                RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer-Coop Account').getRecordTypeId(),
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test22@test.com'
            );
            Database.insert(contact1);
            
            //Create contact
            Contact contact2 = new Contact(
                FirstName = '2Test',
                Lastname = '2McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test33@test.com'
            );
            Database.insert(contact2);
            
            //Create user
            Profile portalProfile = [ SELECT Id FROM Profile
                                     WHERE Name = 'Partner Community User (Custom)' 
                                     LIMIT 1];
            UserRole portalRole = [Select Id,Name From UserRole WHERE NAME LIKE '%Partner User' Limit 1];
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test1234567@test.com',
                ContactId = contact1.Id,
                PortalRole = 'Manager',
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            
            User user2 = new User(
                Username = System.now().millisecond() + 'test12345689@test.com',
                ContactId = contact2.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test1235',
                Email = 'test123456@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = '2McTesty',
                CommunityNickname = 'test123456',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user2);
            
            System.assertEquals(1, [Select id from GroupMember where UserOrGroupId = :user2.id].size());

    }
   }
}