public class cc_oo_SettingsHelper{
    
    /*--This class fetches the values for the key & vice-versa wrt the CustomSettingObject --New Change*/
    public static List<Sobject> getData(String Input,String objectName,boolean isKey) {
        if(isKey){
            //If the input is key,get the value for the given objectName 
            string str='SELECT NAME,Value__c FROM '+ String.escapeSingleQuotes(objectName) +' WHERE Name= \''+ String.escapeSingleQuotes(Input) +'\'';
            List<sObject> sobjList = Database.query(str);
            system.debug(sobjList );
            return sobjList;
        }
        else{
            //If the input is value,get the key for the given objectName 
            string str='SELECT NAME,Value__c FROM '+ String.escapeSingleQuotes(objectName) +' WHERE Value__c=\''+ String.escapeSingleQuotes(Input) +'\'';
            List<sObject> sobjList = Database.query(str);
            system.debug(sobjList);
            return sobjList;
        }
    }
    public static String GetValueByKey(String Input,String objectName) {
        //If the input is key,get the value for the given objectName 
        string inputValue = String.escapeSingleQuotes(Input);
        string str='SELECT Value__c FROM '+ String.escapeSingleQuotes(objectName) +' WHERE Name=\''+ String.escapeSingleQuotes(Input) +'\'';
        List<sObject> sobjList = Database.query(str);
        String value ='';
        if(!sobjList.isEmpty()) {
            value=(String)sobjList[0].get('Value__c');
        }
        system.debug( value);
        return value;
    }
    public static List<String> GetKeysByValue(String Input,String objectName) {
        //If the input is value,get the keys for the given objectName 
        string str='SELECT Name FROM '+ String.escapeSingleQuotes(objectName) +' WHERE Value__c=\''+ String.escapeSingleQuotes(Input) +'\'';
        List<sObject> sobjList = Database.query(str);
        List<String> keys= new List<String>();
        for(sObject s:sobjList){
            keys.add((String)s.get('Name'));
        }
        system.debug( keys);
        return keys;
    }
}