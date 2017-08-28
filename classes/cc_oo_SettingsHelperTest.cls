@isTest
public class cc_oo_SettingsHelperTest {
    
    //Class created to test settingHelper 
    @isTest 
    static void test_settingsHelper() {
    String Input= 'LOLSTORE';
    String objectName ='LOLSettings__c';
    boolean isKey=true;
    boolean isValue=false;
    List<Sobject> helperList= new List<Sobject>();
    String helperStringValue = '';
    List<String> helperStringkey = new List<String> ();
    //Call getData to fetch the key/value for the given CustomSettingObject
    helperList=cc_oo_SettingsHelper.getData(Input,objectName,isKey);
    helperList=cc_oo_SettingsHelper.getData(Input,objectName,isValue);
    helperStringValue =cc_oo_SettingsHelper.GetValueByKey(Input,objectName); 
    helperStringkey = cc_oo_SettingsHelper.GetKeysByValue(Input,objectName); 
    System.assertNotEquals(helperList,null);
    System.assertEquals(helperStringValue,'');
    System.assertNotEquals(helperStringkey ,null);
    }
    
}