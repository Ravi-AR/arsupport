Public class Accountclass{
    public Accountclass(){
        List<Account> act = [select id,name from Account];
    }
    
    public List<Account> getIndustryType(String ind){
        //Comments
        List<Account> act = [select id,name from Account where industry=:ind];
        Bank_Account ba = new Bank_Account();
        ba.setValues('Testaccount',121315,1245);
        return act;
    }

    /**
    * Revenue Method
      New Comment test comment
    */ 
    public void updateRevenue(){
        List<Account> act = [select id,name from Account where industry='Agriculture'];
        for(Account ac:act){
             ac.AnnualRevenue = 150;
        }
        update act;
    }
}