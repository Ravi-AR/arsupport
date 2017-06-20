public class TestApexClass {

    TestApexClass(){}
    
    public void testApexClassMethod(String email, String contactName){
		Contact contactObj = [select Email from Contact where Email=:email];
        if(contactObj.Email == email){
            //then update web info
            //Case caseObj = new Case();
            //caseObj.SuppliedEmail = email;
            //caseObj.SuppliedName = contactName;
            //insert new Contact[]{C, new Contact(LastName='yyy',accountId=A.id)};
            insert new Case(SuppliedEmail = email, SuppliedName = contactName);


            
        } else {
            //create contact info and then update web info
            //contactObj = new Contact();
            //contactObj.Email = email;
            //contactObj.Name = contactName;
            //insert new Contact(Email = email, Name = contactName);
			insert new Case(SuppliedEmail = email, SuppliedName = contactName);
            
            //Case caseObj = new Case();
            //caseObj.SuppliedEmail = email;
            //caseObj.SuppliedName = contactName;         
        }

    }
    
}