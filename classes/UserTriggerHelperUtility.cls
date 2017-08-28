/**
* Helper class for User Trigger
* @Created: 7/4/2016 
* Author : Mounika Nagapuri(Magnet360)
* Updates : Mounika Nagapuri(Magnet360) - 5/17/2016
            Removing logic that assigns permission sets based on sales division
* Updates : Mounika Nagapuri(Magnet360) - 5/19/2016
            Adding logic that assigns permission sets/ public groups based on checkbox fields on users.
            All the fields are stored in a field set called Specie_Focus_Fields on User
*/
public with sharing class UserTriggerHelperUtility {


 /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Fires after Insert
 * @param: map<id,User>newusermap,map<id,User>oldusermap
 * @return: 
 ******************************************************************************/
 public static void afterInsert(map<id,User>newusermap,map<id,User>oldusermap ){
     AddUsertoPublicGroups(newusermap);
     assignPermissionSets(newusermap);
 }
 
 /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Fires after Update
 * @param: map<id,User>newusermap,map<id,User>oldusermap
 * @return: 
 ******************************************************************************/
 public static void afterUpdate(map<id,User>newusermap,map<id,User>oldusermap ){
     determineroleschanged(newusermap,oldusermap);
     determinecheckboxeschanged(newusermap,oldusermap);

 }
 
 
 
  /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Adds users to public groups based on the roles
 * @param: map<id,User>newusermap
 * @return: 
 * @JIRA:LPPLH-339
 ******************************************************************************/
 private static void AddUsertoPublicGroups(map<id,User>newusermap){
     
     //Get the groups that the user should be added to
     Group localhires =[select Id from Group Where DeveloperName='Partner_Users'];
     Group localhiremanagers =[select Id from Group Where DeveloperName='Partner_Leadership_Users'];
     
     List<GroupMember>listGroupMember =new List<GroupMember>();
       
     for(User u: [Select id,UserRole.Name from User where Profile.Name = 'Partner Community User (Custom)' and UserRole.Name != '' and Id IN:newusermap.keySet()]){
           if(u.UserRole.Name.contains('Partner User')){
                  GroupMember gm= new GroupMember(); 
                  gm.GroupId=localhires.id;
                  gm.UserOrGroupId = u.id;
                  listGroupMember.add(gm);  
           }
           else if(u.UserRole.Name.contains('Partner Manager')){
                  GroupMember gm= new GroupMember(); 
                  gm.GroupId=localhiremanagers.id;
                  gm.UserOrGroupId = u.id;
                  listGroupMember.add(gm);  
           }
     }
     
     if(listGroupMember.size()>0) insert listGroupMember;
 }
 
/******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Determine users with roles changed
 * @param: map<id,User>newusermap
 * @return: 
 * @JIRA:LPPLH-339
 ******************************************************************************/
 private static void determineroleschanged(map<id,User>newusermap,map<id,User>oldusermap ){
    map<id,User>userroleschanged = new map<id,User>();
    for(User u: [Select id,UserRole.Name, UserRoleId from User where Profile.Name = 'Partner Community User (Custom)' and UserRole.Name != '' and Id IN:newusermap.keySet()]){
        if(u.UserRoleId != oldusermap.get(u.id).UserRoleId){
            userroleschanged.put(u.id,u);
        }
    }
    
    if(userroleschanged != null)AddRoleChangedUsertoGroups(userroleschanged);
 }

/******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Adds users with new roles to respective public groups and removes them from existing public groups with their old roles
 * @param: map<id,User>newusermap
 * @return: 
 * @JIRA:LPPLH-339
 ******************************************************************************/

 private static void AddRoleChangedUsertoGroups(map<id,User>newusermap){
     
     //Get the groups that the user should be added to
     Group localhires =[select Id from Group Where DeveloperName='Partner_Users'];
     Group localhiremanagers =[select Id from Group Where DeveloperName='Partner_Leadership_Users'];
     
     List<GroupMember>listGroupMember =new List<GroupMember>();
       
     for(User u: [Select id,UserRole.Name from User where Id IN:newusermap.keySet()]){
           if(u.UserRole.Name.contains('Partner User')){
                  GroupMember gm= new GroupMember(); 
                  gm.GroupId=localhires.id;
                  gm.UserOrGroupId = u.id;
                  listGroupMember.add(gm);  
           }
           else if(u.UserRole.Name.contains('Partner Manager')){
                  GroupMember gm= new GroupMember(); 
                  gm.GroupId=localhiremanagers.id;
                  gm.UserOrGroupId = u.id;
                  listGroupMember.add(gm);  
           }
     }
     
     List<GroupMember>DellistGroupMember = [Select id from GroupMember where UserOrGroupId IN:newusermap.KeySet() and (GroupId = :localhires.id or GroupId = :localhiremanagers.id) ];
     if(DellistGroupMember.size()>0) delete DellistGroupMember;
     if(listGroupMember.size()>0) insert listGroupMember;
 }
 
 /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Create a map with Permission set label and Permission set id
 * @param: 
 * @return: map<string,id>
 * @JIRA:LPPLH-632
 ******************************************************************************/
 
 private static map<string,string> permissionsetmap(){
         String permissionsetfilter = '%Feeding Trials%';
         map<string,string> salespermissionsetmap = new map<String,id>();
         for(permissionset p:[Select id,name,label from Permissionset where label like :permissionsetfilter]){
             String permlabel =  p.label;
             List<String> perm = permlabel.split(':');
             String labelname = perm[1].trim();
             salespermissionsetmap.put(labelname,p.id);
         }
         System.debug('*****salespermissionsetmap' + salespermissionsetmap);
         return salespermissionsetmap;
 }
 
  /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Create a map with Group label and  id
 * @param: 
 * @return: map<string,string>
 * @JIRA:LPPLH-632
 ******************************************************************************/
 
 private static map<string,string> groupsmap(){
         String groupsfilter = '%Feeding Trials%';
         map<string,string> feedingtrialsgroupmap = new map<String,id>();
         for(Group g:[Select id,name from Group where name like :groupsfilter]){
             String glabel =  g.name;
             List<String> grp = glabel.split(':');
             String labelname = grp[1].trim();
             feedingtrialsgroupmap.put(labelname,g.id);
         }
         System.debug('*****feedingtrialsgroupmap' + feedingtrialsgroupmap);
         return feedingtrialsgroupmap;
 }
 
 /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Assign Permission sets according to user fields
 * @param: map<id,User>newusermap
 * @return: 
 * @JIRA:LPPLH-632
 ******************************************************************************/
 
 public static void assignPermissionSets(map<id,User>newusermap){
     List<PermissionsetAssignment> lstpermassign = new List<PermissionsetAssignment>();
     List<GroupMember>listGroupMember =new List<GroupMember>();
     map<string,string> userpermissionsetmap = permissionsetmap();
     map<string,string> usergroupmap = groupsmap();
    
     // get fields from field set on user
     List<Schema.FieldSetMember> schemaset= SObjectType.User.FieldSets.Specie_Focus_Fields.getFields();

     
   // get all fields on User with labels, apinames etc
    Schema.SObjectType UserSchema = Schema.getGlobalDescribe().get('User');
    Map<String, Schema.SObjectField> fieldMap = UserSchema.getDescribe().fields.getMap();
    
    // create a set with user ids 
        Set<id> userid = new set<id>();
        for(id uid: newusermap.keySet()){
            userid.add(uid);
        }
    
    // create dynamic query using field set
       String query = 'SELECT ';
        for(Schema.FieldSetMember f : schemaset) {
            query += f.getFieldPath() + ', ';
        }
        query += 'id,name from User where Id IN:userid and isActive = true';
        List<User>lstusers = Database.query(query);

   // Assign permission sets and public groups based on conditions
    
    for(User u: lstusers){
       
       for(Schema.FieldSetMember f : schemaset) {
            String apiname = f.getFieldPath();
            if(u.get(apiname) == true){
                 string fieldlabel = fieldMap.get(apiname).getDescribe().getLabel();  
                 if(userpermissionsetmap.get(fieldlabel) != null)lstpermassign.add(new PermissionsetAssignment(AssigneeId = u.id, PermissionSetId = userpermissionsetmap.get(fieldlabel)));       
                 if(usergroupmap.get(fieldlabel) != null)listGroupMember.add(new GroupMember(UserOrGroupId = u.id, GroupId = usergroupmap.get(fieldlabel)));       

            }
        }
                  
     }
     
       
     if(lstpermassign.size()>0) insert lstpermassign;
     if(listGroupMember.size()>0) insert listGroupMember;
 }
 
 
 /******************************************************************************
 * @author: Mounika Nagapuri(Magnet360)
 * @description: Determine users with checkbox fields changed
 * @param: map<id,User>newusermap
 * @return: 
 * @JIRA:LPPLH-632
 ******************************************************************************/
 
 
 private static void determinecheckboxeschanged(map<id,User>newusermap,map<id,User>oldusermap ){
    map<id,User>checkboxeschanged = new map<id,User>();
    
    
    // get fields from field set on user
     List<Schema.FieldSetMember> schemaset= SObjectType.User.FieldSets.Specie_Focus_Fields.getFields();

     
   // get all fields on User with labels, apinames etc
    Schema.SObjectType UserSchema = Schema.getGlobalDescribe().get('User');
    Map<String, Schema.SObjectField> fieldMap = UserSchema.getDescribe().fields.getMap();
    
    // create a set with user ids 
        Set<id> userid = new set<id>();
        for(id uid: newusermap.keySet()){
            userid.add(uid);
        }
    
    // create dynamic query using field set
       String query = 'SELECT ';
        for(Schema.FieldSetMember f : schemaset) {
            query += f.getFieldPath() + ', ';
        }
        query += 'id,name from User where Id IN:userid and isActive = true';
        List<User>lstusers = Database.query(query);
    
    for(User u: lstusers){
        for(Schema.FieldSetMember f : schemaset) {
            String apiname = f.getFieldPath();
            if(u.get(apiname) !=  oldusermap.get(u.id).get(apiname)){
                 checkboxeschanged.put(u.id,u);
            }
        }
    }
    
    if(checkboxeschanged.size()>0){
        List<PermissionsetAssignment> delpermassign = [Select id from PermissionsetAssignment where PermissionSetId IN:permissionsetmap().values() and AssigneeId IN:checkboxeschanged.Keyset()];
        if(delpermassign.size()>0) delete delpermassign;
        
        List<GroupMember> delgrpmembers = [Select id from GroupMember where groupid IN:groupsmap().values() and UserOrGroupId IN:checkboxeschanged.Keyset()];
        if(delgrpmembers.size()>0) delete delgrpmembers;
        
        assignPermissionSets(checkboxeschanged);
    }
    
 } 
 

}