@istest
public class AnimalCountAndLifeStageControllerTest {
   @istest
    static void AnimalCountsToAccountTotalTest()
    {
        /*
        List<Animal_Life_Stage_To_Account_Field__c> lifeStagesCSetting = new List<Animal_Life_Stage_To_Account_Field__c>();
        lifeStagesCSetting.add( new Animal_Life_Stage_To_Account_Field__c( Name = 'Stocker',
                                                                           Account_Animal_Count_Field__c = 'LS_Total_Stocker_Cattle__c'));
        lifeStagesCSetting.add( new Animal_Life_Stage_To_Account_Field__c( Name = 'Back Grounder',
                                                                           Account_Animal_Count_Field__c = 'LS_Total_Back_Grounder_Cattle__c'));
        insert lifeStagesCSetting ;
        List<Animal_Type_to_Account_Fields__c> animalTypeCSetting = new List<Animal_Type_to_Account_Fields__c>();
        animalTypeCSetting.add(new Animal_Type_to_Account_Fields__c(Name = 'Cattle',
                                                                   	Account_Animal_Count_Field__c = 'LS_Total_Cattle_Animals_Show__c',
                                                                  	Account_Animal_Served_Field__c = 'Type_Total_Cattle_Animals_Fed__c'));
        insert animalTypeCSetting;
        
        Account acc = new Account(Name = 'test account'); 
        insert acc;
        
        List<Animal_Count_Lifestage__c> animalCountLifeStages = new List<Animal_Count_Lifestage__c>();
        animalCountLifeStages.add(new Animal_Count_Lifestage__c( Account__c = acc.id,
                                                                Animal_Count__c = 5,
                                                                Animals_Served__c = 5,
                                                                Animal_Type__c = 'Cattle',
                                                                Lifestage__c = 'Stocker' ));
        animalCountLifeStages.add(new Animal_Count_Lifestage__c( Account__c = acc.id,
                                                                Animal_Count__c = 15,
                                                                Animals_Served__c = 5,
                                                                Animal_Type__c = 'Cattle',
                                                                Lifestage__c = 'Back Grounder' ));
        animalCountLifeStages.add(new Animal_Count_Lifestage__c( Account__c = acc.id,
                                                                Animal_Count__c = 15,
                                                                Animals_Served__c = 5,
                                                                Animal_Type__c = 'Cattle',
                                                                Lifestage__c = 'Back Grounder' ));
        test.startTest();
        insert animalCountLifeStages;
        test.stopTest();
        
        List<Account> accounts = [Select id ,LS_Total_Stocker_Cattle__c,
                                  		LS_Total_Back_Grounder_Cattle__c,Type_Total_Cattle_Animals_Fed__c,
                                  		LS_Total_Cattle_Animals_Show__c from Account where id =: acc.Id];
        System.assertEquals(5, accounts.get(0).LS_Total_Stocker_Cattle__c);
        System.assertEquals(30, accounts.get(0).LS_Total_Back_Grounder_Cattle__c);
        System.assertEquals(15, accounts.get(0).Type_Total_Cattle_Animals_Fed__c);
        System.assertEquals(35, accounts.get(0).LS_Total_Cattle_Animals_Show__c);
        
        delete animalCountLifeStages;
        
        accounts = [Select id ,LS_Total_Stocker_Cattle__c,
                                  		LS_Total_Back_Grounder_Cattle__c,Type_Total_Cattle_Animals_Fed__c,
                                  		LS_Total_Cattle_Animals_Show__c from Account where id =: acc.Id];
        System.assertEquals(0, accounts.get(0).LS_Total_Stocker_Cattle__c);
        System.assertEquals(0, accounts.get(0).LS_Total_Back_Grounder_Cattle__c);
        System.assertEquals(0, accounts.get(0).Type_Total_Cattle_Animals_Fed__c);
        System.assertEquals(0, accounts.get(0).LS_Total_Cattle_Animals_Show__c);
        */
    }
    

}