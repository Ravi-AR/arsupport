@isTest
public class RollupPTExtTest
{
    static testMethod void rollupPTExtTest(){
        
    // Sampl Data Creation
        // Main Account
        Account acc = new Account();
        acc.Name = 'TestAcc';
        insert acc;     
        
        // VIP related to main account
        VIP_Tons_Points__c viptp = new VIP_Tons_Points__c();
        viptp.Ship_To_Customer2__c = acc.id;
        viptp.Sold_To_Customer__c = acc.id;
        viptp.Points_Current_Year__c = 10;
        viptp.Points_Prior_Year__c = 20;
        viptp.Tons_Current_Year__c = 30;
        viptp.Tons_Prior_Year__c = 40;
        viptp.Year__c = '2015';
        insert viptp;
        
        // Run the visualforce page RollupPT
        PageReference pageRef = Page.RollupPT;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('id', acc.id);
        ApexPages.StandardController sc = new ApexPages.standardController(acc);        
        RollupPTExt ext = new RollupPTExt(sc);
        
    }
}