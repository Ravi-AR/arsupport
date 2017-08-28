/**
 * Filter UserStatus updates for blacklisted words
 * Author: Quinton Wall - qwall@salesforce.com
 
 *** Updates - Mounika Nagapuri (Magnet 360) - 4/7/2016
   * Adding After Insert
 
 */
trigger BlacklistWordFilterOnUserStatus  on User (before update,after insert,after update) {
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            List<User> usersWithStatusChanges = new List<User>();
            
            //only test for blacklist filtering if the trigger was executed
            //because of a status change
            for(User u : trigger.new)
            {
                if(u.CurrentStatus != trigger.oldMap.get(u.Id).currentStatus)
                    usersWithStatusChanges.add(u);
            }
            
            if(!usersWithStatusChanges.isEmpty())
                new BlacklistFilterDelegate().filterUserStatus(usersWithStatusChanges);
          }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            UserTriggerHelperUtility.AfterInsert(Trigger.newMap,Trigger.OldMap);
        }
        if(Trigger.isUpdate){
            UserTriggerHelperUtility.AfterUpdate(Trigger.newMap,Trigger.OldMap);
        }
    }

}