public with sharing class AnimalCountAndLifeStageController {
    public static void isAfter(map<id, Animal_Count_Lifestage__c> animalCounts)
    {
        updateAnimalAccountTotals(animalCounts.values());
    }
    
    private static void updateAnimalAccountTotals(List<Animal_Count_Lifestage__c> animalCounts)
    {
        Map<Id, Account> accounts = new Map<Id, Account>();
        Map<String, Animal_Type_to_Account_Fields__c> animalTypeToAccFields = Animal_Type_to_Account_Fields__c.getAll();
        Map<String, Animal_LS_and_Type_To_Account_Field__c> animalLifeStagesToAccFields = Animal_LS_and_Type_To_Account_Field__c.getAll();
        Map<string, string> animalLSAndTypeAccFields = new Map<string, string>();
        
        for(Animal_LS_and_Type_To_Account_Field__c asl: animalLifeStagesToAccFields.values())
        {
            animalLSAndTypeAccFields.put(asl.Life_Stage__c+'-'+asl.Amimal_Type__c, asl.Account_Animal_Count_Field__c); 
        }
        
        
        for(Animal_Count_Lifestage__c acls: animalCounts)
        {
            if(accounts.get(acls.Account__c) == null)
            { 
                Account acc = new Account(Id = acls.Account__c);
                accounts.put(acls.Account__c ,acc);
                for(Animal_Type_to_Account_Fields__c ataf:animalTypeToAccFields.values())
                {
                    if(ataf.Account_Animal_Count_Field__c !=  null)
                        acc.put(ataf.Account_Animal_Count_Field__c, 0);
                    if(ataf.Account_Animal_Served_Field__c !=  null)
                        acc.put(ataf.Account_Animal_Served_Field__c, 0);
                }
                for(Animal_LS_and_Type_To_Account_Field__c alaf:animalLifeStagesToAccFields.values())
                {
                    acc.put(alaf.Account_Animal_Count_Field__c, 0);
                }
            }
        }
        if(accounts.keySet().isEmpty()) return;
        
        List<AggregateResult> animalTypeAndLifeCounts = [Select Sum(Animal_Count__c) AnimalCount,  
                                                         Sum(Animals_Served__c) AnimalServed ,Account__c,
                                                         Animal_Type__c,Lifestage__c
                                                         from Animal_Count_Lifestage__c
                                                         where  Account__c in : accounts.keySet()
                                                         Group by Account__c, Animal_Type__c, Lifestage__c ];
        
        for(AggregateResult ar: animalTypeAndLifeCounts)
        {
            AnimalCountLife acl = new AnimalCountLife((Id)ar.get('Account__c'),
                                                      (String)ar.get('Animal_Type__c'),
                                                      (String)ar.get('Lifestage__c'),
                                                      (Decimal)ar.get('AnimalCount'),
                                                      (Decimal)ar.get('AnimalServed'));

            Account acc = accounts.get(acl.accountId);
            System.debug('RK: acc:'+acc);
            
            // retrieve the Custom Setting for life stage and animal type
            Animal_Type_to_Account_Fields__c animalTypeAccField = animalTypeToAccFields.get(acl.animalType);
            string  animalLSAndTypeAccField = animalLSAndTypeAccFields.get(acl.lifeStage+'-'+acl.animalType);
            
            
            //if(animalTypeAccField == null || animalLSAndTypeAccField == null) continue;
            if(animalTypeAccField == null) continue;
            
            if(animalTypeAccField.Account_Animal_Count_Field__c != null)
                acl.totalCount =  (Decimal)acc.get(animalTypeAccField.Account_Animal_Count_Field__c);
            if(animalLSAndTypeAccField != null)
                acl.totalLSCount = (Decimal)acc.get(animalLSAndTypeAccField);
            if(animalTypeAccField.Account_Animal_Served_Field__c != null)
                acl.totalServed = (Decimal)acc.get(animalTypeAccField.Account_Animal_Served_Field__c);
            

            // populating/calculating the animal served total based on the animal type 
            if(animalTypeAccField.Account_Animal_Count_Field__c != null)
            {
                if( acl.totalServed == 0)
                {
                    acc.put(animalTypeAccField.Account_Animal_Served_Field__c, acl.animalServed);
                }else{
                    
                    if ( acl.totalServed == null) {
                        acl.totalServed = 0;
                    }
                    acl.totalServed += acl.animalServed;
                    acc.put(animalTypeAccField.Account_Animal_Served_Field__c, acl.totalServed);
                }
            }
            
           // populating the animal count total based on the animal life stages & type
            if( animalLSAndTypeAccField != null){

                if(acl.totalLSCount == 0)
                {
                    acc.put(animalLSAndTypeAccField, acl.animalCount); 
                }else
                {
                    if ( acl.totalLSCount == null) {
                        acl.totalLSCount = 0;
                    }
                    acl.totalLSCount += acl.animalCount;
                    acc.put(animalLSAndTypeAccField, acl.totalLSCount);
                }
            }
            
            // populating the animal count total based on the animal life stages 
            /*if( animalLifeStageAccField.Account_Animal_Count_Field__c != null){
                if(acl.totalLSCount == 0)
                {
                    acc.put(animalLifeStageAccField.Account_Animal_Count_Field__c, acl.animalCount); 
                }else
                {
                    if ( acl.totalLSCount == null) {
                        acl.totalLSCount = 0;
                    }
                    acl.totalLSCount += acl.animalCount;
                    acc.put(animalLifeStageAccField.Account_Animal_Count_Field__c, acl.totalLSCount);
                }
            }*/
            
            // populating the animal count total based on the animal type
            if(animalTypeAccField.Account_Animal_Count_Field__c != null)
            { 

                if(acl.totalCount == 0)
                {
                    acc.put(animalTypeAccField.Account_Animal_Count_Field__c, acl.animalCount); 
                }else
                {
                    if ( acl.totalCount == null) {
                        acl.totalCount = 0;
                    }
                    acl.totalCount += acl.animalCount;
                    acc.put(animalTypeAccField.Account_Animal_Count_Field__c, acl.totalCount); 
                }
            }
            
        }
        SYSTEM.DEBUG('AnimalCountAndLifeStageController :: accounts to be updated : ' + accounts.values());
        if(accounts.values().size() > 0)
            update accounts.values();
    }
    public class AnimalCountLife{
        public Id accountId{ get; private set;}
        public Decimal animalCount { get; private set;}
        public Decimal animalServed { get; private set;}
        public string animalType { get; private set;}
        public string lifeStage {get; private set;}
        public Decimal totalCount {get; set;}
        public Decimal totalLSCount {get; set;}
        public Decimal totalServed {get; set;}
        public AnimalCountLife( Id accountId,string animalType,string lifeStage, Decimal animalCount , Decimal animalServed)
        {
            this.accountId = accountId;
            this.animalType = ( animalType == null ) ? '' : animalType;
            this.lifeStage = ( lifeStage == null ) ? '' : lifeStage;
            this.animalCount = ( animalCount == null ) ? 0 : animalCount;
            this.animalServed = ( animalServed == null ) ? 0 : animalServed;
            
        }
    }
    
}