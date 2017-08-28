public without sharing class cc_oo_ctrl_SRFlow {
// Ashwini Rudra
// Varibale 
	// Propoerties
	public static final string CLASS_NAME = 'cc_oo_ctrl_SRFlow';
	public string contactId {get;set;}
	public string orgId {get;set;}
	private Contact userContact;
	public boolean getIsActiveUser() {
		try{
	    	user u = [select id from user where contactId= :userContact.id and isActive=TRUE limit 1];
	    	return true;
	 	} catch (exception e) {
	    	return false;
	 	}
	}

	 
	 //Constuctor
	 public cc_oo_ctrl_SRFlow () {}
	 public cc_oo_ctrl_SRFlow (ApexPages.StandardController c) {
		   userContact = (Contact) c.getRecord();
		   contactId = userContact.id;
		   orgId = UserInfo.getOrganizationId();
	 }
	 
	 //Method
	 public pageReference forward(){
	       return punchInCloudCraze();
	 }
 
	 // Method	 
	 public pageReference punchInCloudCraze() {
		  try {
			     pageReference pr =  System.Page.ccrz__HomePage;
			     user u = [select id from user where contactId= :userContact.id and isActive=TRUE limit 1];
			     pr.getParameters().put('portalUser',u.id);
			     pr.getParameters().put('isCSRFlow','true');
			     pr.getParameters().put('store','purinamills');
			     pr.getParameters().put('orderType','preBook');
			     return pr;
		      } catch(Exception ex) {
		      	cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'punchInCloudCraze');
		    	return null;
		  	}
 	}
}