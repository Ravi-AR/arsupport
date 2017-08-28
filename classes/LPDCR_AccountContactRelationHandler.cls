/**
*   @Author:    Heena Tanna
*   @Jira:      LPDCR-1732
*   @Purpose:   Controller behind AccountContactRelationTrigger
*/


public without sharing class LPDCR_AccountContactRelationHandler
{
    public static void insertAccountShare(List<AccountContactRelation> acrs)
    {
        Set<Id> contactIdSet = new Set<Id>();//Set to add contactId's
        Map<Id,Id> contactUserMap = new Map<Id,Id>();//ContactId and UserId Map
        List<AccountShare> accShareInsertList = new List<AccountShare>();
        For(AccountContactRelation acr:acrs)
        {
         if(acr.AuthorizedBusinessBuilderParentAR__c == true)
         {                   
          contactIdSet.add(acr.ContactId);//Add the ContactId to ContactIDSet    
         }
        }
        
        for(User u:[SELECT Id,ContactId,IsActive,IsPortalEnabled FROM User WHERE ContactId IN:contactIdSet AND IsActive = true AND IsPortalEnabled=true])
        { 
           contactUserMap.put(u.ContactId,u.Id);//UserId for the associated ContactId
             
        } 
        
        for(AccountContactRelation acre:acrs)
        {
            if(contactUserMap.size()>0)
            {
                //AccessLevel to be given
                AccountShare shareObj = new AccountShare();
                shareObj.AccountId = acre.AccountId;
                shareObj.UserOrGroupId = contactUserMap.get(acre.ContactId);
                shareObj.AccountAccessLevel = 'Read';   
                shareObj.CaseAccessLevel = 'None';
                shareObj.OpportunityAccessLevel ='None';
                accShareInsertList.add(shareObj);
            }
        }  
       
            
                if(accShareInsertList.size()>0)
                insert accShareInsertList;            
         
    }
    
    public static void deleteAccountShareOnUpdate(List<AccountContactRelation> acrs)
    {
     Set<Id> contactIdSet = new Set<ID>();
            Set<Id> accountIdSet = new Set<ID>();
            Set<Id> userIdSet = new Set<ID>();
            List<AccountShare> accShareDeleteList = new List<AccountShare>();
            Map<id,Set<Id>> mapAccSha = new Map<id,Set<Id>>();
            
            for(AccountContactRelation acr:acrs)
            {
                if(acr.AuthorizedBusinessBuilderParentAR__c == false)
                {
                     contactIdSet.add(acr.ContactId);
                     accountIdSet.add(acr.AccountId);
                }
            
            }
            
            for(User u: [Select Id,ContactId,IsActive,IsPortalEnabled FROM User WHERE ContactId IN:contactIdSet AND IsActive = true AND IsPortalEnabled = true])
            {
                userIdSet.add(u.Id);
            
            }
            
            for(AccountShare asObj:[Select Id,AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN :accountIdSet AND UserOrGroupId IN:userIdSet])
            {
                accShareDeleteList.add(asObj);
            }
            if(accShareDeleteList.size()>0)
            delete accShareDeleteList;
            
        
        }
        
   public static void deleteAccountShareOnDelete(List<AccountContactRelation> acrs)
    { 
        Set<Id> contactIdSet = new Set<ID>();
            Set<Id> accountIdSet = new Set<ID>();
            Set<Id> userIdSet = new Set<ID>();
            List<AccountShare> accShareDeleteList = new List<AccountShare>();
            
            for(AccountContactRelation acr:acrs)
            {
                //if(acr.AuthorizedBusinessBuilderParentAR__c == false)
                //{
                     contactIdSet.add(acr.ContactId);
                     accountIdSet.add(acr.AccountId);
                //}
            
            }
            
            for(User u: [Select Id,ContactId,IsActive,IsPortalEnabled FROM User WHERE ContactId IN:contactIdSet AND IsActive = true AND IsPortalEnabled = true])
            {
                userIdSet.add(u.Id);
            
            }
            
            for(AccountShare asObj:[Select Id,AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN :accountIdSet AND UserOrGroupId IN:userIdSet])
            {
                accShareDeleteList.add(asObj);
            }
            if(accShareDeleteList.size()>0)
            delete accShareDeleteList;
        
        
        }
    }