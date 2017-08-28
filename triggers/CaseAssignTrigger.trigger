trigger CaseAssignTrigger on Case (after insert) {
    
    List<Id> caseId = new List<Id>{};

        for (Case theCase:trigger.new) 
            caseId.add(theCase.Id);
        
        List<Case> cases = new List<Case>{}; 
        for(Case c : [Select Id from Case where Id in :caseId])
        {
            Database.DMLOptions dmo = new Database.DMLOptions();
 
            dmo.assignmentRuleHeader.useDefaultRule = true;
            c.setOptions(dmo);
            
            cases.add(c);
        }

        Database.upsert(cases);

}