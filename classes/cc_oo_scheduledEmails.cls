//ClassName:cc_oo_scheduledEmails 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         10/07/2016                                     OO-211 Scheduler for sending Order Acknowledgement Mail
//-----------------------------------------------------------------------------------------------------------------------
global class cc_oo_scheduledEmails implements Schedulable{

    
	public static void start() { 
        Datetime sysTime = System.now().addMinutes(10);       
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('cc_oo_scheduledEmails', chronExpression, new cc_oo_scheduledEmails());
    }
    
    global void execute(SchedulableContext SC) {	
		
        if(!isJobAlreadyRunning('cc_oo_EmailBatch')){
			Type t = Type.forName('cc_oo_EmailBatch');                  
        	Database.Batchable<sObject> batch = (Database.Batchable<sObject>)t.newInstance();
        	Database.executeBatch(batch,10); 
		}

        // Abort job and start again
        System.abortJob( SC.getTriggerId() );  
	    cc_oo_scheduledEmails.start();
        
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