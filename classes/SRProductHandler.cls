/*
 * SRProductHandler
 * Logic for what should happen when handling Service Request Products.
 * Currently, this updates the email fields in the Service Request Product that 
 * are used to notify of potential liability  
 * 
 * ---------------------------------------------------------------------------------
 * Author                   Date                    Description
 * ---------------------------------------------------------------------------------
 * Juan Rivera              10/05/2016              Created
 */
public with sharing class SRProductHandler {
   // Variables store Service Request Products, Service Requests and Plants
   List<Service_Request_Product__c> srpList;
   Map<Id, Case> srMap = getOpenServiceRequest();
   Map<Id, Branch__c> plantMap = getPlants();
    
   // Constructor 
   public SRProductHandler(List<Service_Request_Product__c> triggerSRP){
      srpList = triggerSRP;
   }
   
   // Method for get Case Status picklist field values
   
   public static set<string> sValues(){
        set<string> csvalues = new set<string>();
        list<CaseStatus> cstatus =[Select MasterLabel From CaseStatus where MasterLabel!='Closed'];
        for(CaseStatus cs : cstatus){
            csvalues.add(cs.MasterLabel);
        }
        return csvalues;
   }
    
   // Method called by SRProduct Trigger to populate email fields
   public void populateSRPEmailFields(){
      for(Service_Request_Product__c srp : srpList){     
         if(srp.Service_Request__c != null){               

            // Service Request current SR Product belongs to
            Case serviceRequest = srMap.get(srp.Service_Request__c);

            // check for correct record types: Consumer, Customer Care, Mass Channel/Farm & Ranch
            // Refactor to RecordTypeId in {...}, then refactor to replace w/ query instead of hardcode
            if(serviceRequest.RecordType.Name == 'Consumer' || serviceRequest.RecordType.Name == 'Customer Care' || serviceRequest.RecordType.Name == 'Mass Channel/Farm & Ranch'){
                
               // Manufacturing Plant personnel email population in SR Product
               if(srp.Manufacturing_Plant__c != null){
                  // Manufacturing Plant SR Product originated from
                  Branch__c manufacturingPlant = plantMap.get(srp.Manufacturing_Plant__c);
                        
                  // updates email fields corresponding to Manufacturing Plant personnel
                  updateManPlant(manufacturingPlant, srp);
               }
                    
               // Shipping Plant personnel email population in SR Product
               if(serviceRequest.Shipping_Plant_Lookup__c != null){
                  // Shipping Plant designated on SR
                  Branch__c shippingPlant = plantMap.get(serviceRequest.Shipping_Plant_Lookup__c); 
                        
                  // updates email fields corresponding to Shipping Plant personnel
                  updateShipPlant(shippingPlant, srp);
               }
                    
               // Vet & Nutritionist email population in SR Product
               if(serviceRequest.Nutritionist_Email__c!= null){
                  srp.Nutritionist_Email_Field__c = serviceRequest.Nutritionist_Email__c;
               }
               if(serviceRequest.Veterinarian_Email__c!= null) {
                  srp.Veterinarian_Email_Field__c = serviceRequest.Veterinarian_Email__c;
               }         
               
               // Salesperson email population in SR Product
               if(serviceRequest.Purina_Salesperson__r.Email!= null){
                  srp.Purina_Salesperson_Email_Field__c = serviceRequest.Purina_Salesperson__r.Email;
               }
                
               // check if this is the first Service Request Product added to Service Request
               // Functionality is currently part of Workflow Rule: Potential Product Liability SR Email - Plant Users
               /* 
               if(!serviceRequest.isFirstSRProduct__c){
                  serviceRequest.isFirstSRProduct__c = true;
               }
               */
            }
         }       
      }        
   }
    
   private static Map<Id, Case> getOpenServiceRequest(){
      // List of Open Service Request
      List<Case> sr = [SELECT Id,
                       Potential_Product_Liability__c,
                       Shipping_Plant_Lookup__c,
                       isFirstSRProduct__c,
                       Nutritionist_Email__c,
                       Veterinarian_Email__c,
                       RecordType.Name,
                       Owner.Name,
                       Purina_Salesperson__r.Email
                       FROM Case
                       WHERE Status in :sValues()
                       ];
       
      Map<Id, Case> mCase = new Map<ID, Case>(sr);
      return mCase;        
   }
    
   private static Map<Id, Branch__c> getPlants(){
      // List of Plants where Plant Type has been designated 
      List<Branch__c> plants = [SELECT Id,
                                Customer_Operations_Manager__r.Email,
                                Customer_Op_Team_email__c,
                                Plant_Manager__r.Email,
                                Plant_Quality_Manager__r.Email,
                                Plant_Supervisor__r.Email,
                                Quality_Supervisor__r.Email     
                                FROM Branch__c 
                                WHERE Customer_Ops_Plant_Type__c != null 
                                ];        
        
      Map<Id, Branch__c> mBranch = new Map<Id, Branch__c>(plants); 
      return mBranch;        
   }
    
   private void updateManPlant(Branch__c manPlant,Service_Request_Product__c srProduct){
      if(manPlant.Customer_Operations_Manager__r.Email != null){
         srProduct.Customer_Operations_Manager_Email_Manuf__c = manPlant.Customer_Operations_Manager__r.Email;
      }
      if(manPlant.Plant_Manager__r.Email != null){
         srProduct.Plant_Manager_Email_Manufacturing__c = manPlant.Plant_Manager__r.Email;
      }
      if(manPlant.Plant_Quality_Manager__r.Email != null){
         srProduct.Quality_Manager_Email_Manufacturing__c = manPlant.Plant_Quality_Manager__r.Email;
      }
      if(manPlant.Plant_Supervisor__r.Email != null){
         srProduct.Plant_Supervisor_Email_Manufacturing__c = manPlant.Plant_Supervisor__r.Email;
      }
      if(manPlant.Quality_Supervisor__r.Email != null){
         srProduct.Quality_Supervisor_Email_Manufacturing__c = manPlant.Quality_Supervisor__r.Email;
      }        
   }
    
   private void updateShipPlant(Branch__c shipPlant, Service_Request_Product__c srProduct){
      if(shipPlant.Customer_Op_Team_email__c != null){
         srProduct.Customer_Care_Group_Email__c = shipPlant.Customer_Op_Team_email__c;
      }
      if(shipPlant.Customer_Operations_Manager__r.Email != null){
         srProduct.Customer_Operations_Manager_Email_Ship__c = shipPlant.Customer_Operations_Manager__r.Email;
      }
      if(shipPlant.Plant_Manager__r.Email != null){
         srProduct.Plant_Manager_Email_Shipping__c = shipPlant.Plant_Manager__r.Email;
      }
      if(shipPlant.Plant_Quality_Manager__r.Email != null){
         srProduct.Quality_Manager_Email_Shipping__c = shipPlant.Plant_Quality_Manager__r.Email;
      }
      if(shipPlant.Plant_Supervisor__r.Email != null){
         srProduct.Plant_Supervisor_Email_Shipping__c = shipPlant.Plant_Supervisor__r.Email;
      }
      if(shipPlant.Quality_Supervisor__r.Email != null){
         srProduct.Quality_Supervisor_Email_Shipping__c = shipPlant.Quality_Supervisor__r.Email;
      }        
   }
}