<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_Email_Alert_PMI_Lead_Contact_Us_Form</fullName>
        <ccEmails>coscott@landolakes.com</ccEmails>
        <description>Lead Email Alert || PMI Lead Contact Us Form</description>
        <protected>false</protected>
        <senderAddress>purinacrmsupport@landolakes.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PMI_Contact_Us_Email/PMI_Contact_Us_Lead_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Acknowledged_By</fullName>
        <description>Who switched the Lead Status from Qualified to something else.</description>
        <field>Acknowledged_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Acknowledged By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acknowledgement_Date</fullName>
        <description>Updates the &quot;Acknowledgement Date&quot; with the date the lead status was changed from Qualified.</description>
        <field>Acknowledged_Date__c</field>
        <formula>Today()</formula>
        <name>Acknowledgement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cattle_Count_Prior_Value</fullName>
        <description>Updates the prior value of the Cattle Count</description>
        <field>Cattle_Count_Prior_Value__c</field>
        <formula>PRIORVALUE(  Cattle_Count__c  )</formula>
        <name>Cattle Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cattle_Prior_Update</fullName>
        <description>Cattle Prior Update</description>
        <field>Cattle_Prior_Update__c</field>
        <formula>PriorValue( Date_Cattle_Updated__c )</formula>
        <name>Cattle Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Companion_Prior_Update</fullName>
        <description>Companion Prior Update</description>
        <field>Companion_Prior_Update__c</field>
        <formula>PriorValue( Date_Companion_Updated__c )</formula>
        <name>Companion Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dairy_Count_Prior_Value</fullName>
        <description>Dairy Count Prior Value</description>
        <field>Dairy_Count_Prior_Value__c</field>
        <formula>PRIORVALUE( Dairy_Count__c )</formula>
        <name>Dairy Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dairy_Prior_Update</fullName>
        <description>Dairy Prior Update</description>
        <field>Dairy_Prior_Update__c</field>
        <formula>PriorValue( Date_Dairy_Updated__c )</formula>
        <name>Dairy Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Lead_Inactive</fullName>
        <description>Date the lead became inactive</description>
        <field>Inactive_Date__c</field>
        <formula>Today()</formula>
        <name>Date Lead Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Lead_Qualified</fullName>
        <description>Date the lead became qualified</description>
        <field>Qualified_Date__c</field>
        <formula>Today()</formula>
        <name>Date Lead Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Will_Not_Pursue</fullName>
        <description>Date will not pursue</description>
        <field>Will_Not_Pursue_Date__c</field>
        <formula>Today()</formula>
        <name>Date Will Not Pursue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deer_Count_Prior_Value</fullName>
        <description>Deer Count Prior Value</description>
        <field>Deer_Count_Prior_Value__c</field>
        <formula>priorvalue( Deer_Count__c )</formula>
        <name>Deer Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deer_Prior_Update</fullName>
        <description>Deer Prior Update</description>
        <field>Deer_Prior_Update__c</field>
        <formula>PriorValue( Date_Deer_Updated__c )</formula>
        <name>Deer Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Digigraph_Last_Update</fullName>
        <description>The date the email, phone or mobile phone number were last modified.</description>
        <field>Digigraph_Last_Update__c</field>
        <formula>Now()</formula>
        <name>Digigraph Last Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update</fullName>
        <description>Update the Flock Conversion Date</description>
        <field>Pardot_Flock_Conversion_Date__c</field>
        <formula>Today()</formula>
        <name>Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Will_Not_Pursue_Date</fullName>
        <description>Date the Lead Status is moved to Will Not Pursue</description>
        <field>Will_Not_Pursue_Date__c</field>
        <formula>today()</formula>
        <name>Field Update || Will Not Pursue Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Horse_Count_Prior_Value</fullName>
        <description>Populates the prior value of the Horse Count field.</description>
        <field>Horse_Count_Prior_Value__c</field>
        <formula>PRIORVALUE( Horse_Count__c )</formula>
        <name>Horse Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Horse_Prior_Update</fullName>
        <description>Horse Prior Update</description>
        <field>Horse_Prior_Update__c</field>
        <formula>PriorValue( Date_Horse_Updated__c )</formula>
        <name>Horse Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Classification_Inactive</fullName>
        <description>Identified Inactive Leads</description>
        <field>Lead_Classification__c</field>
        <literalValue>Inactive</literalValue>
        <name>Lead Classification || Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Classification_Marketing</fullName>
        <description>If the critiera in the workflow are met, classify the Lead as &quot;Marketing&quot;</description>
        <field>Lead_Classification__c</field>
        <literalValue>Marketing Lead</literalValue>
        <name>Lead Classification = Marketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Classification_Marketing_Lead_N</fullName>
        <description>The lead classification is updated to &quot;Marketing (No Email)</description>
        <field>Lead_Classification__c</field>
        <literalValue>Marketing Lead (No Email)</literalValue>
        <name>Lead Classification || Marketing Lead (N</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Classification_Potential_Sales</fullName>
        <description>Identifies that this lead is a potential sales lead</description>
        <field>Lead_Classification__c</field>
        <literalValue>Potential Sales Lead</literalValue>
        <name>Lead Classification || Potential Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Classification_Sales_Lead</fullName>
        <description>Indentifies that this lead is a &quot;Sales&quot; lead.</description>
        <field>Lead_Classification__c</field>
        <literalValue>Sales Lead</literalValue>
        <name>Lead Classification || Sales Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Classification_Testing</fullName>
        <description>Indicates a lead that is used for Testing</description>
        <field>Lead_Classification__c</field>
        <literalValue>Testing</literalValue>
        <name>Lead Classification || Testing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conversion_Animal_Count</fullName>
        <description>Populates the Animal Count (Hidden) field with the Animal Count field</description>
        <field>Animal_Count_Hidden__c</field>
        <formula>Animal_Count_1__c</formula>
        <name>Lead Conversion - Animal Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conversion_Animal_Type</fullName>
        <description>Populates the Animal Type (Hidden) field with the Animal Type field</description>
        <field>Animal_Type_Hidden__c</field>
        <formula>TEXT(Animal_Type_1__c)</formula>
        <name>Lead Conversion - Animal Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conversion_Date</fullName>
        <description>Date the Lead was Converted</description>
        <field>Lead_Conversion_Date__c</field>
        <formula>today()</formula>
        <name>Lead || Conversion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Conversion_Lifestage</fullName>
        <description>Populates the Lifestage (Hidden) field with the Lifestage field</description>
        <field>Lifestage_Hidden__c</field>
        <formula>TEXT(Lifestage_1__c)</formula>
        <name>Lead Conversion - Lifestage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Creator</fullName>
        <description>Identified the user who created the lead.</description>
        <field>Lead_Created_By__c</field>
        <formula>CreatedBy.Full_Name__c</formula>
        <name>Lead Creator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Date_Resubscribed_to_Emails</fullName>
        <description>Date the lead resubscribed to receive emails.</description>
        <field>Date_Resubscribed__c</field>
        <formula>Today()</formula>
        <name>Lead || Date Resubscribed to Emails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Date_Unsubscribed_from_Emails</fullName>
        <description>The date the lead opted out of emails.</description>
        <field>Date_Unsubscribed__c</field>
        <formula>Today()</formula>
        <name>Lead || Date Unsubscribed from Emails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Lead_Reviewer2</fullName>
        <description>Updates the Lead Reviewer Field with the Lead Reviewer so it can map over to the Opportunity.</description>
        <field>Lead_Reviewer2__c</field>
        <formula>Lead_Reviewer__r.Full_Name__c</formula>
        <name>Lead || Lead Reviewer2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Lead_Stage_Update</fullName>
        <description>Updates the Lead Stage to &quot;Will Not Pursue&quot;</description>
        <field>Status</field>
        <literalValue>Will Not Pursue</literalValue>
        <name>Lead || Lead Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Milkings_Cows_is_Blank</fullName>
        <description>The number of milking cows is blank</description>
        <field>Milking_Cows__c</field>
        <literalValue>0</literalValue>
        <name>Lead || Milkings Cows is Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_Purina_Inactive_Lead_Queue</fullName>
        <description>The owner of the lead is the Purina Inactive Lead Queue</description>
        <field>OwnerId</field>
        <lookupValue>Purina_Leads_Queue_Inactive</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Owner || Purina Inactive Lead Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Owner_is_Purina_Leads_Queue</fullName>
        <description>Lead Owner is Purina Leads Queue</description>
        <field>OwnerId</field>
        <lookupValue>Purina_Leads_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Owner is Purina Leads Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Pardot_Vet_Pricing_Update</fullName>
        <description>Updates the Pardot Vet Pricing Date with today&apos;s date on the lead.</description>
        <field>Pardot_Vet_Pricing_Conversion_Date__c</field>
        <formula>today()</formula>
        <name>Lead || Pardot Vet Pricing Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Record_Type_Producer_Consumer_Lead</fullName>
        <description>Changes the Lead record Type to Producer/Consumer Lead</description>
        <field>RecordTypeId</field>
        <lookupValue>Producer_Consumer_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead Record Type=Producer/Consumer Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Record_Type_Purina_Producer</fullName>
        <description>Changes the Lead Record Type to Producer Lead</description>
        <field>RecordTypeId</field>
        <lookupValue>Producer_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead Record Type=Purina Producer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Record_Type_is_Producer_Consumer</fullName>
        <description>Changes the record type of inactive leads to producer/consumer lead.</description>
        <field>RecordTypeId</field>
        <lookupValue>Producer_Consumer_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead Record Type is Producer/Consumer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Open</fullName>
        <description>Lead Status = Open</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Lead Status = Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Prior_Value</fullName>
        <description>Lead Status Prior Value</description>
        <field>Status_Prior_Value__c</field>
        <formula>PRIORVALUE( Status)</formula>
        <name>Lead Status Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_to_Unqualified</fullName>
        <description>Changes the lead status to Unqualified.</description>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>Lead Status to Unqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Type_Producer</fullName>
        <description>Sets the Lead Type as a Producer if the Animal Type and Counts meet the correct criteria</description>
        <field>Lead_Type__c</field>
        <literalValue>Producer</literalValue>
        <name>Lead Type - Producer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Will_Not_Pursue</fullName>
        <description>Remove the checkbox from Will Not Pursue</description>
        <field>Will_Not_Pursue__c</field>
        <literalValue>0</literalValue>
        <name>Lead || Will Not Pursue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_is_Purina_Queue_Inactive</fullName>
        <description>Field update that updates the Purina Lead Queue Inactive</description>
        <field>OwnerId</field>
        <lookupValue>Purina_Leads_Queue_Inactive</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner is Purina Queue Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PMI_Contact_Us_Lead_Date_Filled_Out</fullName>
        <description>The date and time the PMI Contact Us Web Form was filled out.</description>
        <field>PMI_Contact_Us_Date_Question_Asked__c</field>
        <formula>Now()</formula>
        <name>PMI Contact Us Lead || Date Filled Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pet_Count_Prior_Value</fullName>
        <description>Pet count prior value</description>
        <field>Pet_Count_Prior_Value__c</field>
        <formula>priorvalue(Pet_Count__c)</formula>
        <name>Pet Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pet_Prior_Update</fullName>
        <description>Pet Prior Update</description>
        <field>Pet_Prior_Update__c</field>
        <formula>PriorValue( Date_Pet_Updated__c )</formula>
        <name>Pet Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populates_Lead_Date_Unqualified_with_t</fullName>
        <description>Populates Lead &quot;Unqualified Date&quot; with today&apos;s date.</description>
        <field>Unqualified_Date__c</field>
        <formula>today()</formula>
        <name>Populates Lead &quot;Date Unqualified&quot;  Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Poultry_Count_Prior_Value</fullName>
        <description>Poultry Count Prior Value</description>
        <field>Poultry_Count_Prior_Value__c</field>
        <formula>priorvalue(Poultry_Count__c)</formula>
        <name>Poultry Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Poultry_Prior_Update</fullName>
        <description>Poultry Prior Update</description>
        <field>Poultry_Prior_Update__c</field>
        <formula>PriorValue( Date_Poultry_Updated__c )</formula>
        <name>Poultry Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Value_of_Companion_Count</fullName>
        <description>Prior Value of Companion Count</description>
        <field>Companion_Count_Prior_Value__c</field>
        <formula>priorvalue(Companion_Count__c)</formula>
        <name>Prior Value of Companion Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Value_of_Lead_Status</fullName>
        <description>The prior value of the Status field.</description>
        <field>Status_Prior_Value__c</field>
        <formula>PRIORVALUE(Status)</formula>
        <name>Prior Value of Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Record_Type_Hidden</fullName>
        <description>Sets the Lead Record Type (Hidden) field for conversion to an Account</description>
        <field>Lead_Record_Type_Hidden__c</field>
        <formula>CASE(Lead_Sub_Type__c,
&quot;Direct Producer&quot;, &quot;Prospect Direct Producer Account.&quot;,
&quot;Retail Producer&quot;, &quot;Prospect Retail Producer Account.&quot;,NULL
)</formula>
        <name>Set Lead Record Type (Hidden)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Show_Count_Prior_Value</fullName>
        <description>Show County Prior Value</description>
        <field>Show_Count_Prior_Value__c</field>
        <formula>priorvalue(Show_Count__c)</formula>
        <name>Show Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Show_Prior_Update</fullName>
        <description>Show Prior Update</description>
        <field>Show_Prior_Update__c</field>
        <formula>PriorValue( Date_Show_Updated__c )</formula>
        <name>Show Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Will_Not_Pursue_Re_evaluate</fullName>
        <description>Changes the status of the a Lead to &quot;Will Not Pursue || Re-evaluate</description>
        <field>Status</field>
        <literalValue>Will Not Pursue || Re-evaluate</literalValue>
        <name>Stage || Will Not Pursue Re-evaluate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Unqualified_Re_evalute</fullName>
        <description>The status of the lead is changed to &quot;Unqualified || Re-evaluate&quot;.</description>
        <field>Status</field>
        <literalValue>Unqualified || Re-evaluate</literalValue>
        <name>Status = Unqualified || Re-evaluate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_WIll_Not_Pursue</fullName>
        <description>Lead Status will change to &quot;Will Not Pursue&quot; when the Will Not Pursue checkbox is checked.</description>
        <field>Status</field>
        <literalValue>Will Not Pursue</literalValue>
        <name>Status || WIll Not Pursue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Swine_Count_Prior_Value</fullName>
        <description>Swine Count Prior Value</description>
        <field>Swine_Count_Prior_Value__c</field>
        <formula>priorvalue(Swine_Count__c)</formula>
        <name>Swine Count Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Swine_Prior_Update</fullName>
        <description>Swine Prior Update</description>
        <field>Swine_Prior_Update__c</field>
        <formula>PriorValue( Date_Swine_Updated__c )</formula>
        <name>Swine Prior Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Owner</fullName>
        <description>Update Lead Owner to Purina Queue</description>
        <field>OwnerId</field>
        <lookupValue>Purina_Leads_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Lead Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Function_who_Converted_the_Lead</fullName>
        <description>The use function of the person who converted the Lead</description>
        <field>User_Function_Who_Converted_Lead__c</field>
        <formula>text($User.Function__c)</formula>
        <name>User Function who Converted the Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Web_Form_Name_Prior_Value</fullName>
        <description>The prior value of the Web Form Name field.</description>
        <field>Web_Form_Name_Prior_Value__c</field>
        <formula>PRIORVALUE(Web_Form_Name__c)</formula>
        <name>Web Form Name Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Will_Not_Pursue_False</fullName>
        <description>Will Not Pursue - False</description>
        <field>Will_Not_Pursue__c</field>
        <literalValue>0</literalValue>
        <name>Will Not Pursue - False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X18_Digit_Lead_ID_Mapping</fullName>
        <description>Updates the 18 Digit Lead ID (Mapping) field to the 18 Digit Lead ID</description>
        <field>X18_Digit_Lead_ID_Mapping__c</field>
        <formula>X18_Digit_Lead_ID__c</formula>
        <name>18 Digit Lead ID (Mapping)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>18 Digit Lead ID</fullName>
        <actions>
            <name>X18_Digit_Lead_ID_Mapping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the 18 Digit Lead ID (Mapping) field so it can map over to the Opportunity.</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ampli-Calf %26 Ampli-Calf Purina Proof</fullName>
        <actions>
            <name>Lead_Milkings_Cows_is_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Web_Form_Dairy_Product_Pages__c</field>
            <operation>equals</operation>
            <value>Dairy Ampli-Calf</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Web_Form_Dairy_Product_Pages__c</field>
            <operation>equals</operation>
            <value>Dairy Ampli-Calf Purina Proof</value>
        </criteriaItems>
        <description>If the dairy web form is Ampli-Calf or Ampli-Calf Purina Proof, then the number of milking cows should be blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cattle Count Prior Value</fullName>
        <actions>
            <name>Cattle_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Cattle Count field</description>
        <formula>ischanged(Cattle_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cattle Prior Update</fullName>
        <actions>
            <name>Cattle_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Cattle Update</description>
        <formula>ischanged(Date_Cattle_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Companion Count Prior Value</fullName>
        <actions>
            <name>Prior_Value_of_Companion_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Companion Count field</description>
        <formula>ischanged(Companion_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Companion Prior Update</fullName>
        <actions>
            <name>Companion_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Companion Update</description>
        <formula>ischanged(Date_Companion_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dairy Count Prior Value</fullName>
        <actions>
            <name>Dairy_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Dairy Count field</description>
        <formula>Ischanged(Dairy_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dairy Prior Update</fullName>
        <actions>
            <name>Dairy_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Dairy Update</description>
        <formula>ischanged(Date_Dairy_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date Lead Inactive</fullName>
        <actions>
            <name>Date_Lead_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Owner_is_Purina_Queue_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>If the lead is moved to the stage of &quot;Inactive&quot; change the lead owner to the Inactive Purina Lead Queue and stames the &quot;Date Lead Inactive&quot; field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date Lead Qualified</fullName>
        <actions>
            <name>Date_Lead_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <description>Date the lead became Qualified</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date Lead Status Moved to Will Not Pursue</fullName>
        <actions>
            <name>Field_Update_Will_Not_Pursue_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Will Not Pursue</value>
        </criteriaItems>
        <description>Date the Lead Status was moved to Will Not Pursue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date Lead Unqualified</fullName>
        <actions>
            <name>Populates_Lead_Date_Unqualified_with_t</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified</value>
        </criteriaItems>
        <description>Captures the date the lead was put in the &quot;Unqualified Date&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deer Count Prior Value</fullName>
        <actions>
            <name>Deer_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Deer Count field</description>
        <formula>ischanged(Deer_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deer Prior Update</fullName>
        <actions>
            <name>Deer_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Deer Update</description>
        <formula>ischanged(Date_Deer_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Digigraph Last Update</fullName>
        <actions>
            <name>Digigraph_Last_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The date the email, phone or mobile phone number were last updated</description>
        <formula>And( IsNew(), Or( Not(IsBlank(Email)), Not(IsBlank(Phone)), Not(IsBlank(MobilePhone)) ))  ||   And( Not(IsNew()), Or( ISCHANGED(Email), ISCHANGED(Phone), ISCHANGED(MobilePhone) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Horse Count Prior Value</fullName>
        <actions>
            <name>Horse_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Horse Count field</description>
        <formula>Ischanged( Horse_Count__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Horse Prior Update</fullName>
        <actions>
            <name>Horse_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Horse Update</description>
        <formula>ischanged( Date_Horse_Updated__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C%7C Date Resubscribed to Emails</fullName>
        <actions>
            <name>Lead_Date_Resubscribed_to_Emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Date_Unsubscribed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>The date the lead resubscribed to emails</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C%7C Date Resubscribed to Emails %28IsChanged%29</fullName>
        <actions>
            <name>Lead_Date_Resubscribed_to_Emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The date the Email Opt Out changed from True to False when the &quot;opt out&quot; changed.</description>
        <formula>ANd(
  ISCHANGED( HasOptedOutOfEmail ) ,
  HasOptedOutOfEmail = False,
  Text( Date_Unsubscribed__c ) = &quot;&quot;,
  Text( Date_Resubscribed__c ) = &quot;&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C%7C Date Unsubscribed from Emails</fullName>
        <actions>
            <name>Lead_Date_Unsubscribed_from_Emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Date the Lead &quot;Opted Out&quot; of emails.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C%7C Flock Conversion Date</fullName>
        <actions>
            <name>Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populates the Flock Conversion Date</description>
        <formula>and( 
ISNEW(),
Not(isblank(text(Where_are_you_at_with_your_flock__c)))
)
||
and(
Not(ISNEW()),
Not(isblank(text(Where_are_you_at_with_your_flock__c))),
isblank(PRIORVALUE(Where_are_you_at_with_your_flock__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead %7C%7C Vet Pricing Conversion Date</fullName>
        <actions>
            <name>Lead_Pardot_Vet_Pricing_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The Pardot date the lead was flagged as Vet Pricing for Mazura</description>
        <formula>and( 
ISNEW(), 
Not(isblank(Web_Form_Mazuri_Vet_Pricing__c)) 
) 
|| 
and( 
Not(ISNEW()), 
ischanged(Web_Form_Mazuri_Vet_Pricing__c)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Acknowledgement</fullName>
        <actions>
            <name>Acknowledged_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acknowledgement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status_Prior_Value__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>If the Lead Record Type is Producer and the Prior Lead Status is &quot;2&quot; for Qualified, then update  the Acknowledgement Date and Acknowledged by fields on the lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Classification %7C%7C Inactive</fullName>
        <actions>
            <name>Lead_Classification_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>Indentified inactive leads.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Classification %7C%7C Marketing Lead</fullName>
        <actions>
            <name>Lead_Classification_Marketing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND ((3 AND 4 AND 5) or (6 AND 7 AND (8 or 9 or 10)) or (11 AND 12 AND (13 or 14) and (15 or 16) and (17 or 18)))</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified,Will Not Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Owner_Function__c</field>
            <operation>notEqual</operation>
            <value>Customer Operations,Marketing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified,Will Not Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>100</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>lessOrEqual</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>lessOrEqual</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>lessThan</operation>
            <value>100</value>
        </criteriaItems>
        <description>Identified a Marketing Lead</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Classification %7C%7C Marketing Lead %28No Email%29</fullName>
        <actions>
            <name>Lead_Classification_Marketing_Lead_N</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND ((3 AND 4 AND 5) or (6 AND 7 AND (8 or 9 or 10)) or (11 AND 12 AND (13 or 14) and (15 or 16) and (17 or 18)))</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified,Will Not Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Owner_Function__c</field>
            <operation>notEqual</operation>
            <value>Customer Operations,Marketing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Unqualified,Will Not Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>100</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>lessThan</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>lessThan</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>lessThan</operation>
            <value>100</value>
        </criteriaItems>
        <description>Identified a Marketing Lead that does not have an email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Classification %7C%7C Potential Sales Lead</fullName>
        <actions>
            <name>Lead_Classification_Potential_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 or (3 AND 4 AND (5 or 6 or 7)))</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Owner_Function__c</field>
            <operation>equals</operation>
            <value>Customer Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Unqualified,Inactive,Will Not Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Horse_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>10</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Dairy_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Cattle_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>100</value>
        </criteriaItems>
        <description>Potential Lead for Sales</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Classification %7C%7C Sales Lead</fullName>
        <actions>
            <name>Lead_Classification_Sales_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Unqualified,Inactive,Will Not Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Owner_Function__c</field>
            <operation>notEqual</operation>
            <value>Customer Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Kevin Quinlan</value>
        </criteriaItems>
        <description>Identified Sales Leads</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Classification %7C%7C Testing</fullName>
        <actions>
            <name>Lead_Classification_Testing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Kevin Quinlan</value>
        </criteriaItems>
        <description>Indentifies a lead that is used for testing.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Conversion - Primary Animal Type Fields</fullName>
        <actions>
            <name>Lead_Conversion_Animal_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Conversion_Animal_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Conversion_Lifestage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Lead.Animal_Count_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Animal_Type_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lifestage_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <description>Populates the Animal Type (Hidden), Count (Hidden) and Lifestage (Hidden) fields based on the corresponding fields for when the lead is converted into an opportunity</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Created</fullName>
        <actions>
            <name>Lead_Creator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead created is populated in a custom lead field so the value can be mapped over to the opportunity,</description>
        <formula>True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Owner Change to Purina Queue</fullName>
        <actions>
            <name>Update_Lead_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 2 or 3) and 4</booleanFilter>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>SFDC Admin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Digigraph User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Nic Autry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Web_Form_Name_Ask_Team_Purina__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the lead is created by Digigraph or SFDC Admin, change the owner to Purina Lead Queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Owner is Purina Lead Queue</fullName>
        <actions>
            <name>Lead_Record_Type_Producer_Consumer_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Purina Leads Queue</value>
        </criteriaItems>
        <description>If the lead owner is &quot;Purina Leads Queue&quot; then the record type is Producer/Consumer Lead</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Owner is not Purina Lead Queue</fullName>
        <actions>
            <name>Lead_Record_Type_Purina_Producer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Purina Leads Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Purina Leads Queue Inactive</value>
        </criteriaItems>
        <description>If the lead owner is not &quot;Purina Lead Queue&quot; then the record type is Purina Producer Lead</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status %7C%7C Prior Value</fullName>
        <actions>
            <name>Lead_Status_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Prior value of the lead status.</description>
        <formula>ISCHANGED(  Status )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status From Open to Unqualified</fullName>
        <actions>
            <name>Lead_Status_to_Unqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Open_Status_To_Unqualified_Indicator__c</field>
            <operation>equals</operation>
            <value>Unqualified</value>
        </criteriaItems>
        <description>Changes Lead status from Open to Unqualified.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PMI Contact Us %7C%7C Lead Email Alert</fullName>
        <actions>
            <name>Lead_Email_Alert_PMI_Lead_Contact_Us_Form</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email when a PMI Contact Us web form is mapped to a lead.</description>
        <formula>AND( 
IsNew(), 
Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot; 
) 

|| 

AND( 
Not(IsNew()), 
IsConverted = False, 
Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot;, 
IsBlank(PRIORVALUE(Web_Form_PMI_Contact_Us__c)) 
) 

|| 

And( 
Not(IsNew()), 
IsConverted = False, 
Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot;, 
IsChanged(PMI_Contact_Us_Question__c ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PMI Contact Us-Date Question Was Asked</fullName>
        <actions>
            <name>PMI_Contact_Us_Lead_Date_Filled_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The date the question was asked on the PMI Contact Us web form.</description>
        <formula>And( 
IsNew(), 
Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot; 
) 
|| 

And( 
Not(IsNew()), 
IsChanged( PMI_Contact_Us_Question__c ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pet Count Prior Value</fullName>
        <actions>
            <name>Pet_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Pet Count field</description>
        <formula>ischanged(Pet_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pet Prior Update</fullName>
        <actions>
            <name>Pet_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Pet Update</description>
        <formula>ischanged(Date_Pet_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Poultry Count Prior Value</fullName>
        <actions>
            <name>Poultry_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Poultry Count field</description>
        <formula>ischanged(Poultry_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Poultry Prior Update</fullName>
        <actions>
            <name>Poultry_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Poultry Update</description>
        <formula>ischanged(Date_Poultry_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Purina Lead %7C%7C Will Not Pursue</fullName>
        <actions>
            <name>Date_Will_Not_Pursue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Lead_Stage_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Purina Leads Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer Lead,Producer/Consumer Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Will_Not_Pursue__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If the lead owner is not &quot;Purina Lead Queue&quot; then the record type is Purina Producer/Consumer Lead and the &quot;Will Not Pursue&quot; is correct, change the owner of the lead back to Purina Leads Queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Record Type %28Hidden%29</fullName>
        <actions>
            <name>Set_Lead_Record_Type_Hidden</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Record_Type_Hidden__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the Lead Record Type (Hidden) field for conversion to an Account</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Show Count Prior Value</fullName>
        <actions>
            <name>Show_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Show Count field</description>
        <formula>ischanged(Show_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Show Prior Update</fullName>
        <actions>
            <name>Show_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Show Update</description>
        <formula>ischanged(Date_Show_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Swine Count Prior Value</fullName>
        <actions>
            <name>Swine_Count_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous value of the Show Count field</description>
        <formula>ischanged(Swine_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Swine Prior Update</fullName>
        <actions>
            <name>Swine_Prior_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populates the previous Swine Update</description>
        <formula>ischanged(Date_Swine_Updated__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Reviewer2</fullName>
        <actions>
            <name>Lead_Lead_Reviewer2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Producer/Consumer Lead,Producer Lead</value>
        </criteriaItems>
        <description>This field gets updated to match the Lead Reviewer Field so it can be mapped over to the Account</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Web Form Lead Prior Value</fullName>
        <actions>
            <name>Web_Form_Name_Prior_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Displays the prior value of the Web Form Name field</description>
        <formula>ischanged( Web_Form_Name__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
