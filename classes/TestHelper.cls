public class TestHelper {

    public VIP_Purina_Account__c retrieveCustomSettings(){
        VIP_Purina_Account__c Purina_Account = VIP_Purina_Account__c.getOrgDefaults();
        return Purina_Account;
    }
    
}