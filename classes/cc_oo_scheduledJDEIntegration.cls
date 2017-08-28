//ClassName:cc_oo_scheduledJDEIntegration 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         01/03/2017                                        OO-517 - Schedule job for JDE integration
//-----------------------------------------------------------------------------------------------------------------------
global class cc_oo_scheduledJDEIntegration implements Schedulable{

    public static Integer timeValue = Integer.valueOf(LOLSettings__c.getAll().get('JDEJobScheduler').Value__c);
    
    public static void start() {  
        Datetime sysTime = System.now().addMinutes(timeValue);       
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('cc_oo_scheduledJDEIntegration', chronExpression, new cc_oo_scheduledJDEIntegration());
    }
    
    global void execute(SchedulableContext SC) {    
        
        if(!isJobAlreadyRunning('cc_oo_SyncJDEBatch')){
            Type t = Type.forName('cc_oo_SyncJDEBatch');                  
            Database.Batchable<sObject> batch = (Database.Batchable<sObject>)t.newInstance();
            Database.executeBatch(batch,timeValue); 
        }

        // Abort job and start again
        System.abortJob( SC.getTriggerId() );  
        cc_oo_scheduledJDEIntegration.start();
        
    }
    
    public static boolean isJobAlreadyRunning(String apexClassName) {
        
        ApexClass batchApexClass = [Select Id From ApexClass Where Name = :apexClassName limit 1][0];
        List<AsyncApexJob> apexJobs = [Select Id, CompletedDate From AsyncApexJob Where JobType = 'BatchApex' AND ApexClassID = :batchApexClass.Id AND CompletedDate = null];
        if(!apexJobs.isEmpty()){
            return true;
        }   
        //check if more than 5 concurrant batch is running
        if(!([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5)) {
                return true;
        }
        return false; 
    }
}