//ClassName:cc_oo_NavigationBarController 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                        10/12/2016                                       OO-212 Ability to redirect user back to the community page from the online ordering system.
//-----------------------------------------------------------------------------------------------------------------------
  

global without sharing class cc_oo_NavigationBarController{
    
    public String communityLink {get;set;}
    public cc_oo_NavigationBarController(){
        communityLink  =   LOLSettings__c.getAll().get('CommunityUrlLink').Value__c;
    }
}