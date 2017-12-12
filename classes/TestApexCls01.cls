public class TestApexCls01 {
    
    public list<Employee__c> emp{set ; get;}
    
    public void test(){
        
        emp = [select id,Emp_Name__c from Employee__c];
        System.debug('emp'+emp);
    }
    

}