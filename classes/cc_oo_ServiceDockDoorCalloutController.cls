public without sharing class cc_oo_ServiceDockDoorCalloutController {
    public static DockDoorTimeslotCollectionBean getPickupTime(String plantName,String productType,String customerNumber,Date shipDate,String cartId){
        try{
            String shipDateString =  shipDate.year()+'-'+shipDate.month()+'-'+shipDate.day();
            System.debug('shipDateString---->'+shipDateString);
            productType = productType.toUpperCase();
            //string params = 'ABDN/dockDoorTimeSlots?productType='+productType.toUpperCase()+'&shipToNumber=311901&pickupDate=2017-01-19';
            ccrz.cc_RemoteActionResult totalWeight = cc_oo_HeaderController.getTotalWeightByCartId(cartId);
            System.debug('totalWeight---->'+totalWeight);
            string params = plantName+'/dockDoorTimeSlots?productType='+productType+'&shipToNumber='+customerNumber+'&pickupDate='+shipDateString+'&orderWeight='+totalWeight.data;
            System.debug('Params dockdoor---->'+params);
            //string params = 'IGH/dockDoorTimeSlots?productType=BAG&shipToNumber=321321&startDate=2017-02-21&endDate=2017-02-26';
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('dockDoor', null ,params);
            System.debug('Service order call cancel ---> ' +resp);
            
            System.debug('actualResp----->' +  resp.response.getStatus());
            string stringRespStatus = resp.response.getStatus();            
            
            Integer stringRespcode = resp.response.getStatusCode();
            System.debug('----stringRespcode-----'+stringRespcode);
            insert new cc_oo_ErrorLog__c(cc_oo_Description__c= '---->'+ stringRespStatus);
            if(stringRespcode == 200){
                cc_oo_HelperController.createLog(params, 'DockDoor', 'EndPoint','cc_oo_ServiceDockDoorCalloutController','getPickupTime');
                cc_oo_HelperController.createLog(resp.response.getBody(), 'DockDoor', 'Response','cc_oo_ServiceDockDoorCalloutController','getPickupTime');
                System.debug('stringRespStatus-->' +resp.response.getBody());
                DockDoorTimeslotCollectionBean slots = (DockDoorTimeslotCollectionBean) JSON.deserialize(resp.response.getBody(), DockDoorTimeslotCollectionBean.class);
                System.debug('slots-->' +slots);
                return slots;
            }
            return null;
            
        }catch(Exception ex){
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','---->' + ex);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','---->' + ex.getMessage());
            
            cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();           
            errorLog.cc_oo_Description__c   = 'Exception type caught: ' + ex.getTypeName() + ' '
                                                 + 'Message: '          + ex.getMessage() + ' '
                                                 + 'Cause: '            + ex.getCause() + ' ' 
                                                 + 'Stack trace: '      + ex.getStackTraceString();
            errorLog.cc_oo_ApexClass__c     = 'cc_oo_ServiceDockDoorCalloutController';
            errorLog.cc_oo_MethodName__c    = 'getPickupTime';
           insert errorLog;
            return null;
        } 
    }

    public class DockDoorTimeslotCollectionBean{
        public string timeZone{get;set;}
        public DockDoorTimeslotCollection DockDoorTimeslotCollection {get;set;}
    }

    public class DockDoorTimeslotCollection{
        public List<DockDoorTimeslot> DockDoorTimeslot = new List<DockDoorTimeslot>();
    }

    public class DockDoorTimeslot{
        public string pickupTime {get; set;}
        public string shipToNumber {get; set;}
        public string isBooked {get; set;}
        public string orderNumber {get; set;}
    } 
}