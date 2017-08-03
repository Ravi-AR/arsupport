trigger CheckSoW on Opportunity (before update) {
    
    //get Opportunity and Attachments
    List <Opportunity> oppty = new List<Opportunity>([select id, StageName from Opportunity where Id IN:Trigger.new]); 
    //Map<id,Attachment> att = new Map<id, Attachment>([select id, Name, ParentId from Attachment where ( Name = '%SOW%' AND ParentID IN:Trigger.new)]);
    list<Attachment> att = new list<Attachment>([select id, Name, ParentId from Attachment where ( Name = '%SOW%' AND ParentID IN:Trigger.new)]);
    For(Opportunity opp : Trigger.new){
        if(oppty.get(0).Stagename == 'Closed Won')
        {
          for(Attachment attach:att){
            if(attach.parentId!=opp.id){
             system.debug('------------------------------entered--------------------');
             opp.adderror('For "Closed Won" Opportunities, please attach an SoW. The name of the Document should contain SoW');
             break;
            }
          }
        }
    }
    
}