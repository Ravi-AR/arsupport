@isTest
public class SurveyResultsUtility_TEST {

	static testMethod void LeadRouteNonePopulated(){

		Lead createL = new Lead();
		createL.Company = 'testCompany';
		createL.lastName 	= 'testLead';
		insert createL;

		List<Survey_Results__c> results = new List<Survey_Results__c>();

		//Question_Answer_ID__c 
		Question__c Q = new Question__c();
		Q.Animal_Count_Update__c = TRUE;
		insert Q;

		Answer__c A = new Answer__c();
		A.Answer_Option__c = '11-200';
		A.Question__c = Q.id;
		insert A;
		Answer__c A1 = new Answer__c();
		A1.Answer_Option__c =	'12+';
		A1.Question__c = Q.id;
		insert A1;
		Answer__c A2 = new Answer__c();
		A2.Answer_Option__c = 	'1-100';
		A2.Question__c = Q.id;
		insert A2;

		Survey_Results__c result = new Survey_Results__c();
		result.Answer_Lookup__c = A.id;
		result.Question_Answer_ID__c = Q.id;
		result.Lead__c = createL.id;
		results.add(result);

		Survey_Results__c result1 = new Survey_Results__c();
		result1.Answer_Lookup__c = A1.id;
		result1.Lead__c = createL.id;
		result1.Question_Answer_ID__c = Q.id;
		results.add(result1);

		Survey_Results__c result2 = new Survey_Results__c();
		result2.Answer_Lookup__c = A2.id;
		result2.Lead__c = createL.id;
		result2.Question_Answer_ID__c = Q.id;
		results.add(result2);

		Survey_Results__c result3 = new Survey_Results__c();
		result3.Answer_Lookup__c = A2.id;
		result3.Lead__c = createL.id;
		result3.Question_Answer_ID__c = Q.id;
		results.add(result3);

		Survey_Results__c result4 = new Survey_Results__c();
		result4.Answer_Lookup__c = A2.id;
		result4.Lead__c = createL.id;
		result4.Question_Answer_ID__c = Q.id;
		results.add(result4);

		Test.startTest();
		insert results;

		Lead l = [SELECT id, Name, Animal_Count_1__c, Animal_Type_1__c, Lifestage_1__c, Animal_Count_2__c, Animal_Type_2__c, Lifestage_2__c, Animal_Count_3__c, Animal_Type_3__c, Lifestage_3__c, Animal_Count_4__c, Animal_Type_4__c, Lifestage_4__c, Animal_Count_5__c, Animal_Type_5__c, Lifestage_5__c 
					FROM LEAD 
					WHERE id =: createL.id];
		SYSTEM.DEBUG('THIS IS THE LEAD RETRIVED ');
		system.assert(l.Animal_Count_1__c != null);
		Test.stopTest();
	}

	static testMethod void LeadRoute_somePopulated(){
		Lead createL = new Lead();
		createL.Company = 'testCompany';
		createL.lastName 	= 'testLead';
		createL.Animal_Count_1__c = 10;
		createL.Animal_Type_1__c  = 'Test Type';
		insert createL;

		List<Survey_Results__c> results = new List<Survey_Results__c>();

		Question__c Q = new Question__c();
		Q.Animal_Count_Update__c = TRUE;
		insert Q;

		Answer__c A = new Answer__c();
		A.Answer_Option__c = '11-200';
		A.Question__c = Q.id;
		insert A;
		Answer__c A1 = new Answer__c();
		A1.Answer_Option__c =	'12+';
		A1.Question__c = Q.id;
		insert A1;
		Answer__c A2 = new Answer__c();
		A2.Answer_Option__c = 	'1-100';
		A2.Question__c = Q.id;
		insert A2;

		Survey_Results__c result = new Survey_Results__c();

		result.Answer_Lookup__c = A.id;
		result.Question_Answer_ID__c = Q.id;
		result.Lead__c = createL.id;
		results.add(result);

		Survey_Results__c result1 = new Survey_Results__c();
		result1.Answer_Lookup__c = A1.id;
		result1.Lead__c = createL.id;
		result1.Question_Answer_ID__c = Q.id;
		results.add(result1);

		Survey_Results__c result2 = new Survey_Results__c();
		result2.Answer_Lookup__c = A2.id;
		result2.Lead__c = createL.id;
		result2.Question_Answer_ID__c = Q.id;
		results.add(result2);

		Test.startTest();
		insert results;

		Lead l = [SELECT id, Name, Animal_Count_1__c, Animal_Type_1__c, Lifestage_1__c, Animal_Count_2__c, Animal_Type_2__c, Lifestage_2__c, Animal_Count_3__c, Animal_Type_3__c, Lifestage_3__c, Animal_Count_4__c, Animal_Type_4__c, Lifestage_4__c, Animal_Count_5__c, Animal_Type_5__c, Lifestage_5__c 
					FROM LEAD 
					WHERE id =: createL.id];
		SYSTEM.DEBUG('THIS IS THE LEAD RETRIVED ');
		system.assert(l.Animal_Count_1__c != null);
		Test.stopTest();
	}



	static testMethod void ContactRoute_NonePopulated(){
		
		Account acc = new Account();
		acc.Name = 'testAccount';
		insert acc;

		Contact c = new Contact();
		c.FirstName = 'test';
		c.LastName = 'test';
		c.AccountId = acc.id;
		insert c;

		List<Survey_Results__c> results = new List<Survey_Results__c>();
		Question__c Q = new Question__c();
		Q.Animal_Count_Update__c = TRUE;
		insert Q;
		Answer__c A = new Answer__c();
		A.Answer_Option__c = '11-200';
		A.Question__c = Q.id;
		insert A;
		Answer__c A1 = new Answer__c();
		A1.Answer_Option__c =	'12+';
		A1.Question__c = Q.id;
		insert A1;
		Answer__c A2 = new Answer__c();
		A2.Answer_Option__c = 	'1-100';
		A2.Question__c = Q.id;
		insert A2;
		Survey_Results__c result = new Survey_Results__c();
		result.Answer_Lookup__c = A.id;
		result.Question_Answer_ID__c = Q.id;
		result.Contact__c = c.id;
		results.add(result);
		Survey_Results__c result1 = new Survey_Results__c();
		result1.Answer_Lookup__c = A1.id;
		result1.Contact__c = c.id;
		result1.Question_Answer_ID__c = Q.id;
		results.add(result1);
		Survey_Results__c result2 = new Survey_Results__c();
		result2.Answer_Lookup__c = A2.id;
		result2.Contact__c = c.id;
		result2.Question_Answer_ID__c = Q.id;
		results.add(result2);

		Test.startTest();
		insert results;

		List<Animal_Count_Lifestage__c> animalcounts = [SELECT id, Account__c, Animal_Count__c, Animals_Served__c, Animal_Type__c, Lifestage__c
														FROM Animal_Count_Lifestage__c
														WHERE Account__c =: acc.id];
		system.assert(animalcounts.size() > 0);

		Test.stopTest();

	}


	static testMethod void ContactRoute_Populated(){
		
		Account acc = new Account();
		acc.Name = 'testAccount';
		insert acc;

		Animal_Count_Lifestage__c ACLS = new Animal_Count_Lifestage__c();
		ACLS.Account__c = acc.id;
		ACLS.Animal_Count__c   = 12;
		ACLS.Animals_Served__c = 11;
		ACLS.Animal_Type__c 	  = 'Cattle';
		ACLS.Lifestage__c 	  = 'Cattle';
		insert ACLS;

		Contact c = new Contact();
		c.FirstName = 'test';
		c.LastName = 'test';
		c.AccountId = acc.id;
		insert c;

		List<Survey_Results__c> results = new List<Survey_Results__c>();
		Question__c Q = new Question__c();
		Q.Animal_Count_Update__c = TRUE;
		insert Q;
		Answer__c A = new Answer__c();
		A.Answer_Option__c = '11-200';
		A.Question__c = Q.id;
		insert A;
		Answer__c A1 = new Answer__c();
		A1.Answer_Option__c =	'12+';
		A1.Question__c = Q.id;
		insert A1;
		Answer__c A2 = new Answer__c();
		A2.Answer_Option__c = 	'1-100';
		A2.Question__c = Q.id;
		insert A2;
		Survey_Results__c result = new Survey_Results__c();
		result.Answer_Lookup__c = A.id;
		result.Question_Answer_ID__c = Q.id;
		result.Contact__c = c.id;
		results.add(result);
		Survey_Results__c result1 = new Survey_Results__c();
		result1.Answer_Lookup__c = A1.id;
		result1.Contact__c = c.id;
		result1.Question_Answer_ID__c = Q.id;
		results.add(result1);
		Survey_Results__c result2 = new Survey_Results__c();
		result2.Answer_Lookup__c = A2.id;
		result2.Contact__c = c.id;
		result2.Question_Answer_ID__c = Q.id;
		results.add(result2);

		Test.startTest();
		insert results;

		List<Animal_Count_Lifestage__c> animalcounts = [SELECT id, Account__c, Animal_Count__c, Animals_Served__c, Animal_Type__c, Lifestage__c
														FROM Animal_Count_Lifestage__c
														WHERE Account__c =: acc.id];
		system.assert(animalcounts.size() > 0);

		Test.stopTest();

	}

}