//ClassName:cc_oo_scheduledMyCart 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                        Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                        		3/15/2017                                      									
//-----------------------------------------------------------------------------------------------------------------------

global class cc_oo_scheduledMyCart implements Schedulable{
    
    public static void start() { 
        Datetime sysTime = DateTime.Now().AddDays(1);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('cc_oo_scheduledMyCart', chronExpression, new cc_oo_scheduledMyCart());
    }
    
    global void execute(SchedulableContext SC) {  

        if(!isJobAlreadyRunning('cc_oo_scheduledMyCart')){
            Type t = Type.forName('cc_oo_MyCartBatch');                  
            Database.Batchable<sObject> batch = (Database.Batchable<sObject>)t.newInstance();
            Database.executeBatch(batch); 
        }
        // Abort job and start again
        System.abortJob( SC.getTriggerId() );
        cc_oo_scheduledMyCart.start();   
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