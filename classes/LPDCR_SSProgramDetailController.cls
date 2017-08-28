/**
*   @Author:    Shruti Mishra
*   @Date:      28.09.2016
*   @Jira:      LPDCR-521
*   @Purpose:   Controller behind LPDCR_SSProgramDetail page
*
*/

public with sharing class LPDCR_SSProgramDetailController {
    public static Decimal currentBalance{get;set;}
    public static String currentYear {get;set;}
    public static List<Account> accountObj {get;set;}
    
    public LPDCR_SSProgramDetailController(){
        LPDCR_SSProgramDetailController.getAccountDetail();
    }
    
    
    // Method to get account detail for SS Program Detail Page
    public static void getAccountDetail(){        
        currentBalance = 0;
        currentYear = String.valueOf(Date.Today().Year());
        Set<Id> uniqueAccountIdSet = new Set<Id>();
        try{
            User userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
            Contact c= [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
            accountObj = [Select Id, Name, Ultimate_Parent__r.Name,Business_Builder_Program_Tier__c from Account where Id=:c.AccountId];
            //Support Program Query WHERE Year = '2016'
            for(Account ac:accountObj)
            uniqueAccountIdSet.add(ac.Id);
            List<SellingSupportProgramYear__c> sellSuppLst =[Select Id,Name,Available_Balance__c,Account__r.Id from SellingSupportProgramYear__c where Account__c IN: uniqueAccountIdSet AND Name =: currentYear];
            
            if(sellSuppLst!=null && sellSuppLst.size()>0)
            currentBalance = sellSuppLst[0].Available_Balance__c.Abs();         
        }
        catch(Exception ex){
            System.debug('Exception occurred- '+ex);
        }
        
    }
    
}