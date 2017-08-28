/**
* Controller for autoComplete Component
* 
* @Date: 11.16.2015
* @Author: Adeel Ahmad (Magnet 360)
* 
* @Updates:
*/
global with sharing class LMSA_AutoCompleteController {
    @RemoteAction
    global static SObject[] findSObjects(string obj, string qry, String preFix, String filterField) {
        // more than one field can be passed in the addFields parameter
        // split it into an array for later use
        List<String> fieldList;
        
        //If object name is not provided, get the object name based on prefix
        if(obj == '' || obj == null){
            obj = findObjectNameFromRecordIdPrefix(preFix);
        } 

        
       // check to see if the object passed is valid
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(obj);
        if (sot == null) {
            // Object name not valid
            return null;
        }
        
        
        // create the filter text
        String filter = ' like \'%' + String.escapeSingleQuotes(qry) + '%\'';
        //begin building the dynamic soql query
        String soql = 'select id, Name ';

        // add the object and filter by name to the soql
        soql += ' from ' + obj + ' WHERE Name ' + filter;
        // add the filter by additional fields to the soql
        if (obj == 'Contact' && (String.isNotEmpty(filterField) && filterField != '000000000000000')) {
            soql += ' AND AccountId = \'' + filterField + '\'';
        }

        soql += ' order by Name limit 20';
        System.debug('AA:Soql ' + soql);
        
        List<sObject> L = new List<sObject>();
        try {
            L = Database.query(soql);
        }
        catch (QueryException e) {
            return null;
        }
        return L;
   }
    
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                System.debug('Prefix is ' + prefix);
                 
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
}