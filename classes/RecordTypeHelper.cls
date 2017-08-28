// RecordTypeHelper
// Helper class to minimize code needed to get record type ids based on the name.
//------------------------------------------------------------------------------
// Author					Date			Description
// -----------------------------------------------------------------------------
// Mark Purick				10/06/2016		Created
// 
public class RecordTypeHelper {    
    public Id getIdFromName(String rtName, sObject rtObject) {
		Schema.DescribeSObjectResult d = rtObject.getSObjectType().getDescribe();
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get(rtName);
        Id rtId = rtByName.getRecordTypeId();
        return rtId;
    }    
}