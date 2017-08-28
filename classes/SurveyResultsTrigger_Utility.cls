public class SurveyResultsTrigger_Utility {

	// CHECK DIGI-GRAPH SURVEY INFORMATION COMMING OVER.
	public void checkSurveyResult(List<Survey_Results__c> newList){

		// see if the animal count update flag is true.
		List<Survey_Results__c> flagged = new List<Survey_Results__c>();
		for(Survey_Results__c sr : newList){
			if(sr.Animal_Count_Update__c == true){
				flagged.add(sr);
			}
		}

		if(flagged.size() > 0){
			List<Survey_Results__c> onLead = new List<Survey_Results__c>();
			List<Survey_Results__c> onContact = new List<Survey_Results__c>();

			for(Survey_Results__c sr : flagged){
				if(sr.Lead__c != null){
					onLead.add(sr);
				}
				if(sr.Contact__c != null){
					onContact.add(sr);
				}
			}

			if(onLead.size() > 0){
				SYSTEM.DEBUG('LEAD LOGIC CALLED : list: ' +onLead);
				leadLogic(onLead);
			}
			if(onContact.size() > 0){
				SYSTEM.DEBUG('Contact LOGIC CALLED : list: ' +onContact);
				contactLogic(onContact);
			}
		}
	}// End checksurveyresult.

	public void leadLogic(List<Survey_Results__c> l_sr){
		List<ID> l_ids = new List<ID>();
		Map<ID, List<Survey_Results__c>> lead_SR = new Map<ID, List<Survey_Results__c>>();

		for(Survey_Results__c sr : l_sr){
			l_ids.add(sr.Lead__c);

			if(lead_SR.containsKey(sr.Lead__c)){
				List<Survey_Results__c> temp_list = lead_SR.get(sr.Lead__c);
				temp_list.add(sr);
			}else{
				List<Survey_Results__c> temp_list = new List<Survey_Results__c>();
				temp_list.add(sr);
				lead_SR.put(sr.Lead__c, temp_list);
			}
		}
		// Query all lead records.
		Map<ID, Lead> leads = new Map<ID, Lead>([SELECT id, Name, Animal_Count_1__c, Animal_Type_1__c, Lifestage_1__c, Animal_Count_2__c, Animal_Type_2__c, Lifestage_2__c, Animal_Count_3__c, Animal_Type_3__c, Lifestage_3__c, Animal_Count_4__c, Animal_Type_4__c, Lifestage_4__c, Animal_Count_5__c, Animal_Type_5__c, Lifestage_5__c, Digigraph_Origin_1__c, Digigraph_Origin_2__c, Digigraph_Origin_3__c, Digigraph_Origin_4__c, Digigraph_Origin_5__c
							FROM Lead WHERE id IN : l_ids]);

		// Leads for update
		List<Lead> l_for_update = new List<Lead>();

		for(ID lid : lead_SR.keySet()){

			Lead cur_lead = leads.get(lid);
			List<Survey_Results__c> surveyResults = lead_SR.get(lid);

			List<String> filled_slots = Lead_slots_filled(cur_lead);
			if(filled_slots.size() == 5){									// lead is has full animal counts.
				SYSTEM.DEBUG('::LEAD IS FULL - no room for animal count / lifestages. ');
			}else{	
				if(surveyResults.size() > 0){								// If there are survey results populate them into the lead.
					if(OriginCheck_Okay(cur_lead) == true){
						Lead poulated_lead = pouplateLead(cur_lead, filled_slots, surveyResults);
						l_for_update.add(poulated_lead);
					}
				}
			}
		}
		// Update the leads with potential new values 
		if(l_for_update.size() > 0){
			try{
				update l_for_update;
			}catch(DmlException e){
				SYSTEM.DEBUG('Error occured : update lead :: ' + e.getMessage());
			}
		}
	}// End leadLogic.

	// populate the lead fields depending on which ones are filled.
	public Lead pouplateLead(Lead l, List<String> slots, List<Survey_Results__c> surv){
		
		Integer count = 0;
		List<String> filled_slots = slots;

		for(Survey_Results__c sr : surv){

			List<String> range = new List<String>();
			Decimal low;
			Decimal high;
			Decimal count_value;
			if(sr.Answer_Option_Formula__c != null){
				if(sr.Answer_Option_Formula__c.contains('-')==true){	// Value is a range.
					range 	= sr.Answer_Option_Formula__c.split('-');
					low 	= Decimal.valueOf(range[0]);
					high 	= Decimal.valueOf(range[1]);
					count_value = low;									// Set count to lowest value in the range.
				}else if(sr.Answer_Option_Formula__c.contains('+')==true){
					String substr = sr.Answer_Option_Formula__c.remove('+');
					count_value = Decimal.valueOf(substr);				// Set count to the value with out the plus sign.
				}else{
					SYSTEM.DEBUG('Survey_Results__c.Answer_Option_Formula__c Doesn\'t contain + or - ');
				}
			}
			
			// Get the next AnimalCount field to populate if one exists.
			Integer spot = getNextSpot(filled_slots);				
			if(spot == 6){
				//ALLL SLOTS FILLED.
			}else{

				if(spot == 1){
					l.Animal_Count_1__c = count_value;
					l.Digigraph_Origin_1__c = true;
					l.Animal_Type_1__c  = sr.Animal_Type__c;
					//l.Lifestage_1__c		
				}else if(spot == 2){
					l.Animal_Count_2__c	= count_value;
					l.Digigraph_Origin_2__c = true;
					l.Animal_Type_2__c  = sr.Animal_Type__c;
					//l.Lifestage_2__c		
				}else if(spot == 3){
					l.Animal_Count_3__c = count_value;
					l.Digigraph_Origin_3__c = true;
					l.Animal_Type_3__c  = sr.Animal_Type__c;
					//l.Lifestage_3__c	
				}else if(spot == 4){
					l.Animal_Count_4__c = count_value;
					l.Digigraph_Origin_4__c = true;
					l.Animal_Type_4__c  = sr.Animal_Type__c;
					//l.Lifestage_4__c	
				}else if(spot == 5){
					l.Animal_Count_5__c = count_value;
					l.Digigraph_Origin_5__c = true;
					l.Animal_Type_5__c  = sr.Animal_Type__c;
					//l.Lifestage_5__c	
				}
					
				filled_slots.add(String.valueOf(spot));
			}
			count++;
		}
		return l;
	}

	public Integer getNextSpot(List<String> filled_slots){
		Integer ret = 1;
		Map<String, String> f_slots = new Map<String, String>();
		for(String s : filled_slots){
			f_slots.put(s, s);
		}
		if(filled_slots.size() == 0){
			ret = 1;
		}else{
			if(f_slots.containsKey('1')){
				if(f_slots.containsKey('2')){
					if(f_slots.containsKey('3')){
						if(f_slots.containsKey('4')){
							if(f_slots.containsKey('5')){
								ret = 6;
							}else{
								ret = 5;
							}
						}else{
							ret = 4;
						}
					}else{
						ret = 3;
					}
				}else{
					ret = 2;
				}
			}else{
				ret = 1;
			}
		}
		return ret;
	}

	// Check to see where the survey result record originated from. 
	// If there are animal count and life stage records populated that don't have Digigraph_Origin = true -- Return False.
	// Else return true. 
	public Boolean OriginCheck_Okay(Lead l){
		Boolean ret = true;
		// If any of these fields are filled out that means a "record" exists.  
		if(l.Animal_Count_1__c != null || l.Animal_Type_1__c != null || l.Lifestage_1__c != null){
			if(l.Digigraph_Origin_1__c == true){
				// good.
			}else{
				ret = false;
			}
		}
		if(l.Animal_Count_2__c != null || l.Animal_Type_2__c != null || l.Lifestage_2__c != null){
			if(l.Digigraph_Origin_2__c == true){
				// good.
			}else{
				ret = false;
			}
		}
		if(l.Animal_Count_3__c != null || l.Animal_Type_3__c != null || l.Lifestage_3__c != null){
			if(l.Digigraph_Origin_3__c == true){
				// good.
			}else{
				ret = false;
			}
		}
		if(l.Animal_Count_4__c != null || l.Animal_Type_4__c != null || l.Lifestage_4__c != null){
			if(l.Digigraph_Origin_4__c == true){
				// good.
			}else{
				ret = false;
			}
		}
		if(l.Animal_Count_5__c != null || l.Animal_Type_5__c != null || l.Lifestage_5__c != null){
			if(l.Digigraph_Origin_5__c == true){
				// good.
			}else{
				ret = false;
			}
		}
		return ret;
	}

	// returns slots available for the animal count.
	public List<String> Lead_slots_filled(Lead l){
		
		List<String> slots = new List<String>();
		// If one of the fields are filled out consider the animal count "record" filled out.
		if(l.Animal_Count_1__c != null || l.Animal_Type_1__c != null || l.Lifestage_1__c != null){
			slots.add('1');
		}
		if(l.Animal_Count_2__c != null || l.Animal_Type_2__c != null || l.Lifestage_2__c != null){
			slots.add('2');
		}
		if(l.Animal_Count_3__c != null || l.Animal_Type_3__c != null || l.Lifestage_3__c != null){
			slots.add('3');
		}
		if(l.Animal_Count_4__c != null || l.Animal_Type_4__c != null || l.Lifestage_4__c != null){
			slots.add('4');
		}
		if(l.Animal_Count_5__c != null || l.Animal_Type_5__c != null || l.Lifestage_5__c != null){
			slots.add('5');
		}
		return slots;
	}


	// LOGIC for the contact path rote
	// This will insert animal count and life stage records on the related account record. 
	public void contactLogic(List<Survey_Results__c> c_sr){

		List<ID> c_ids = new List<ID>();
		Map<ID, List<Survey_Results__c>> contact_SR = new Map<ID, List<Survey_Results__c>>();
		Map<ID, ID> conid_to_accid = new Map<ID, ID>();
		List<ID> a_ids = new List<ID>();

		for(Survey_Results__c sr : c_sr){
			c_ids.add(sr.Contact__c);

			if(contact_SR.containsKey(sr.Contact__c)){
				List<Survey_Results__c> temp_list = contact_SR.get(sr.Contact__c);
				temp_list.add(sr);
			}else{
				List<Survey_Results__c> temp_list = new List<Survey_Results__c>();
				temp_list.add(sr);
				contact_SR.put(sr.Contact__c, temp_list);
			}
		}

		Map<ID, Contact> contacts = new Map<ID, Contact>([SELECT id, Name, AccountId
							FROM Contact WHERE id IN : c_ids]);
		system.debug('contacts '+ contacts);
		for(ID cid : contacts.keySet()){
			conid_to_accid.put(cid, contacts.get(cid).AccountId);
			a_ids.add(contacts.get(cid).AccountId);
		}

		List<Animal_Count_Lifestage__c> animalcounts = [SELECT id, Account__c, Animal_Count__c, Animals_Served__c, Animal_Type__c, Lifestage__c
														FROM Animal_Count_Lifestage__c WHERE Account__c IN : a_ids];
		Map<ID, List<Animal_Count_Lifestage__c>> aid_animals = new Map<ID, List<Animal_Count_Lifestage__c>>();
		
		for(Animal_Count_Lifestage__c ac : animalcounts){
			if(aid_animals.containsKey(ac.Account__c)){
				List<Animal_Count_Lifestage__c> tempL = aid_animals.get(ac.Account__c);
				tempL.add(ac);
			}else{
				List<Animal_Count_Lifestage__c> tempL = new List<Animal_Count_Lifestage__c>();
				tempL.add(ac);
				aid_animals.put(ac.Account__c, tempL);
			}
		}

		List<Animal_Count_Lifestage__c> animalCounts_forInsert = new List<Animal_Count_Lifestage__c>();

		for(ID cid : contact_SR.keySet()){
			Contact c = contacts.get(cid);
			List<Animal_Count_Lifestage__c> tempACounts = new List<Animal_Count_Lifestage__c>();
			if(aid_animals.containsKey(cid)){
				tempACounts = aid_animals.get(c.AccountId);
			}
			List<Survey_Results__c> tempSR = contact_SR.get(cid);
			if(tempACounts.size() > 0){
				// DON'T CREATE RECORDS
			}else{
				// START CREATING RECORDS.
				for(Survey_Results__c sr : tempSR){
					List<String> range = new List<String>();
					Decimal low;
					Decimal high;
					Decimal count_value;
					if(sr.Answer_Option_Formula__c.contains('-')==true){	// Value is a range.
						range 	= sr.Answer_Option_Formula__c.split('-');
						low 	= Decimal.valueOf(range[0]);
						high 	= Decimal.valueOf(range[1]);
						count_value = low;									// Set count to lowest value in the range.
					}else if(sr.Answer_Option_Formula__c.contains('+')==true){
						String substr = sr.Answer_Option_Formula__c.remove('+');
						count_value = Decimal.valueOf(substr);				// Set count to the value with out the plus sign.
					}else{
						SYSTEM.DEBUG('Survey_Results__c.Answer_Option_Formula__c Doesn\'t contain + or - ');
					}
					Animal_Count_Lifestage__c tempACL = new Animal_Count_Lifestage__c();
					tempACL.Animal_Type__c = sr.Animal_Type__c;
					tempACL.Animal_Count__c = count_value;
					tempACL.Account__c		= c.AccountId;
					animalCounts_forInsert.add(tempACL);
				}
			}
		}
	
	// DEBUG
	SYSTEM.DEBUG('INSERT ANIMAL COUNTS ---- CONTACT ROUTE -----');
	SYSTEM.DEBUG('animal counts for insert :: ' + animalCounts_forInsert);
	// DEBUG
		try{
			insert animalCounts_forInsert;
		}catch(DmlException e){
			SYSTEM.DEBUG('ERROR OCCURED ON INSERT Animal_Count_Lifestage__c :: ' + e.getMessage());
		}

	}//END contactLogic.




}