/******************************************************************************
 * LMSA_CreateFacilityWalkThruContTest
 * @Description: Test Controller for the LMSA_CreateFacilityWalkThruController class. 
 *
 * @Date: 10/19/2015
 * @Author: Usman Ali (Magnet360)
 *
 * @Updated:
 ******************************************************************************/


@isTest
private class LMSA_CreateFacilityWalkThruContTest 
{   // Level-1 

    public static testMethod void facilityWalkThruTest()
    {   // Level-2 
        
        // Get RecordType for Tip__c
        RecordType recType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Tip__c' AND DeveloperName = 'Management' ] ; 

        // Create tip
        Tip__c tip = new Tip__c(    Name = 'test', Facility_Question__c = 'Facility', Facility_Answer__c = 'test ans', 
                                    Tip__c = 'good', RecordTypeId = recType.Id ) ;
        
        // Create 2nd tip
        Tip__c tip1 = new Tip__c(    Name = 'test', Facility_Question__c = 'Air', Facility_Answer__c = 'ans', 
                                    Tip__c = 'good', RecordTypeId = recType.Id ) ;

        insert new List<Tip__c>{tip, tip1} ;

        // Create attachment for Tip records 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        Attachment attach = new Attachment( ParentId = tip.Id, Body = bodyBlob, Description = 'test' , Name ='test') ;
        Attachment attach1 = new Attachment( ParentId = tip1.Id, Body = bodyBlob, Description = 'test' , Name ='test') ;
        insert new List<Attachment>{ attach, attach1} ; 

        // Insert custom settings
        //Org_Settings__c settings = new Org_Settings__c( FaciityChecklist_Fieldsets__c = 'Facility,General,Environment,Air,Feed,Water' ) ;
        //Ryan Hartos:  Updated to reflect production fieldsets.  Needs to be changed to dynamically read from custom settings
        Org_Settings__c settings = new Org_Settings__c( FaciityChecklist_Fieldsets__c = 'General' ) ;
        insert settings ;

        // Create Account
        Account ac = new Account( Name = 'Test') ;
        insert ac ;

        // Create Contacts 
        Contact con1 = new Contact( FirstName = ' Test ', LastName = 'test ', AccountId = ac.Id ) ; 
        Contact con2 = new Contact( FirstName = ' Test ', LastName = 'test ', AccountId = ac.Id ) ; 
        Contact con3 = new Contact( FirstName = ' Test ', LastName = 'test ', AccountId = ac.Id ) ; 
        insert new List<Contact>{con1, con2, con3} ;

        // Get RecordType for Facility_Checklist__c
        RecordType recType2 = [ SELECT Id FROM RecordType WHERE SObjectType = 'Facility_Checklist__c' AND DeveloperName = 'Swine_Facility_Walk_Through' ] ; 

        // Create FCL record 
        Facility_Checklist__c fcl =  new Facility_Checklist__c( Producer_Facility__c = ac.Id, Contact_1__c = con1.Id, Contact_2__c = con2.Id, Contact_3__c =con3.Id, RecordTypeId = recType2.Id ) ;
        insert fcl ; 

        Facility_Checklist__c fcl2 =  new Facility_Checklist__c( Producer_Facility__c = ac.Id, Contact_1__c = con1.Id, Contact_2__c = con2.Id, Contact_3__c =con3.Id, RecordTypeId = recType2.Id ) ;
        insert fcl2 ; 

        Facility_Check_List_Labels_Settings__c fclls = new Facility_Check_List_Labels_Settings__c(
                Name = 'TestLabel',
                Section_Label__c = 'Air',
                Sub_Section_Label__c = 'Step 1',
                Field_API_Name_s_1_CSV__c = 'Is_humidity_in_room_at_correct_level__c,Humidity_sensors_used__c,Humidity_evaluation__c',
                Field_API_Name_s_2_CSV__c = 'Ventilation_System_CFM__c,Are_exhaust_fans_functioning_Are_blades__c',
                SortOrder__c = 1
            );
        insert fclls;

        // Set Current Page and call controller methods
        test.setCurrentPage(Page.LMSA_CreateFacilityWalkThru) ;
        apexpages.StandardController sc = new apexpages.StandardController(fcl) ;
        LMSA_CreateFacilityWalkThruController cont = new LMSA_CreateFacilityWalkThruController() ;
        cont.FacilityChecklist = fcl ;
        Attachment attach2 = new Attachment( ParentId = fcl.Id, Body = bodyBlob, Description = 'test' , Name ='test') ;
        insert attach2 ;
        cont.SendEmail();

        cont.selectedTipId  = tip.Id ;
        cont.addAttachToChecklist() ;
        
        System.assert(cont.getFieldsOnLoad() !=null);
        system.assert(cont.questionToTipMap !=null);
        
        List<SelectOption> emlTemp = cont.emailTemplates;
        cont.FacilityQuestion = 'Facility';
        cont.FacilityAnswer = 'test ans' ;
        cont.getFacilityTip(); 
        

        // Code coverage for instance variables of controller
        Map<String, List<Schema.FieldSetMember>> populateFieldSet = cont.populateFieldSet ; 
        Map<String, List<SelectOption>> fieldNameToPicklistValues = cont.fieldNameToPicklistValues ; 
        Map<String, List<String>> fieldNameToMultiPicklistValues = cont.fieldNameToMultiPicklistValues ; 
        Map<String, List<String>> fieldNameToValues = cont.fieldNameToValues ; 
        

        // For method SaveNew create new instance of controller with 2nd Tip record
        //sc = new apexpages.StandardController(tip1);
        //cont = new LMSA_CreateFacilityWalkThruController(sc) ;
        
        cont = new LMSA_CreateFacilityWalkThruController() ;
        cont.StdController= new ApexPages.StandardController( fcl2 ) ; 
        cont.FacilityQuestion = 'Air';
        cont.FacilityAnswer = 'ans' ;
        cont.FacilityTip = 'test' ;
        cont.getFacilityTip();
        //cont.SaveNew();
        
        cont.cancel();
        

        String ul = cont.getUl(); 

    }   // Level-2

}   // Level-1