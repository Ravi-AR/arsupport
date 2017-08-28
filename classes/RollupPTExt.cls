public with sharing class RollupPTExt
{
    private final Account acct;
    String tyear = string.valueof(Date.today().year());
   
    public Double shtcytp {get;set;}
    public Double shtcytt {get;set;}
    public Double shtpytp {get;set;}
    public Double shtpytt {get;set;}
    public Double sotcytp {get;set;}
    public Double sotcytt {get;set;}
    public Double sotpytp {get;set;}
    public Double sotpytt {get;set;}
     
    public Double rshtcytp {get;set;}
    public Double rshtcytt {get;set;}
    public Double rshtpytp {get;set;}
    public Double rshtpytt {get;set;}
    public Double rsotcytp {get;set;}
    public Double rsotcytt {get;set;}
    public Double rsotpytp {get;set;}
    public Double rsotpytt {get;set;}

    public RollupPTExt(ApexPages.StandardController std)
    {
        this.acct = (Account)std.getRecord();
        total(acct.id);
        AccSum(acct.id);
    }
    
    private void total(String account)
    {   
        rshtcytp = 0;
        rshtcytt = 0;
        rshtpytp = 0;
        rshtpytt = 0;
        rsotcytp = 0;
        rsotcytt = 0;
        rsotpytp = 0;
        rsotpytt = 0;
        
        List<Account> accs = [select id from Account where Ultimate_Parent__c = :account or ParentId = :account];
        List<String> accId = new List<String>();
        accId.add(account);
        for(Account acc : accs)
        {
            accId.add(acc.Id);
        }
        List<VIP_Tons_Points__c> shtps = [select Points_Current_Year__c, Tons_Current_Year__c, Points_Prior_Year__c, Tons_Prior_Year__c from VIP_Tons_Points__c where Ship_To_Customer2__c in :accId and Year__c = :tyear];
        List<VIP_Tons_Points__c> sotps = [select Points_Current_Year__c, Tons_Current_Year__c, Points_Prior_Year__c, Tons_Prior_Year__c from VIP_Tons_Points__c where Sold_To_Customer__c in :accId and Year__c = :tyear];
        for(VIP_Tons_Points__c tp : shtps)
        {
            if(tp.Points_Current_Year__c!=null){
                rshtcytp = rshtcytp + tp.Points_Current_Year__c;
            }
            if(tp.Tons_Current_Year__c!=null){
                rshtcytt = rshtcytt + tp.Tons_Current_Year__c;
            }
            if(tp.Points_Prior_Year__c!=null){
                rshtpytp = rshtpytp + tp.Points_Prior_Year__c;
            }
            if(tp.Tons_Prior_Year__c !=null){
                rshtpytt = rshtpytt + tp.Tons_Prior_Year__c ;
            }
        }
        for(VIP_Tons_Points__c tp : sotps)
        {
            if(tp.Points_Current_Year__c!=null){
                rsotcytp = rsotcytp + tp.Points_Current_Year__c;
            }
            if(tp.Tons_Current_Year__c!=null){
                rsotcytt = rsotcytt + tp.Tons_Current_Year__c;
            }
            if(tp.Points_Prior_Year__c!=null){
                rsotpytp = rsotpytp + tp.Points_Prior_Year__c;
            }
            if(tp.Tons_Prior_Year__c !=null){
                rsotpytt = rsotpytt + tp.Tons_Prior_Year__c ;
            }
        }
    }
    
    // Accout Level
    public void AccSum(String accid)
    {
        shtcytp = 0;
        shtcytt = 0;
        shtpytp = 0;
        shtpytt = 0;
        sotcytp = 0;
        sotcytt = 0;
        sotpytp = 0;
        sotpytt = 0;
        List<VIP_Tons_Points__c> shtps = [select Points_Current_Year__c, Tons_Current_Year__c, Points_Prior_Year__c, Tons_Prior_Year__c from VIP_Tons_Points__c where Ship_To_Customer2__c = :accid and Year__c = :tyear];
        List<VIP_Tons_Points__c> sotps = [select Points_Current_Year__c, Tons_Current_Year__c, Points_Prior_Year__c, Tons_Prior_Year__c from VIP_Tons_Points__c where Sold_To_Customer__c= :accid and Year__c = :tyear];
        for(VIP_Tons_Points__c tp : shtps)
        {
            if(tp.Points_Current_Year__c!=null){
                shtcytp = shtcytp + tp.Points_Current_Year__c;
            }
            if(tp.Tons_Current_Year__c!=null){
                shtcytt = shtcytt + tp.Tons_Current_Year__c;
            }
            if(tp.Points_Prior_Year__c!=null){
                shtpytp = shtpytp + tp.Points_Prior_Year__c;
            }
            if(tp.Tons_Prior_Year__c !=null){
                shtpytt = shtpytt + tp.Tons_Prior_Year__c ;
            }
        }
        for(VIP_Tons_Points__c tp : sotps)
        {
            if(tp.Points_Current_Year__c!=null){
                sotcytp = sotcytp + tp.Points_Current_Year__c;
            }
            if(tp.Tons_Current_Year__c!=null){
                sotcytt = sotcytt + tp.Tons_Current_Year__c;
            }
            if(tp.Points_Prior_Year__c!=null){
                sotpytp = sotpytp + tp.Points_Prior_Year__c;
            }
            if(tp.Tons_Prior_Year__c !=null){
                sotpytt = sotpytt + tp.Tons_Prior_Year__c ;
            }
        }
    }
}