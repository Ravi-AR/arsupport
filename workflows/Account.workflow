<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Account_E_mail_Alert</fullName>
        <ccEmails>danielle.nelson@magnet360.com</ccEmails>
        <description>New Account E-mail Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>System_Admins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Customer_Account</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Sharing</fullName>
        <field>Share__c</field>
        <literalValue>Yes</literalValue>
        <name>Account Sharing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Account_Record_Type_Changed</fullName>
        <description>Date Account Record Type Changed</description>
        <field>Date_Account_Record_Type_Changed__c</field>
        <formula>Today()</formula>
        <name>Date Account Record Type Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Direct_Producer_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Direct_Producer_Account_Save</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Direct Producer Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Duplicate_Account_Identified_By</fullName>
        <description>Indicates who identified the duplicate account.</description>
        <field>Duplicate_Identified_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Duplicate Account Identified By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Duplicate_Account_Identified_Date_Time</fullName>
        <description>The date/time the duplicate account was identified.</description>
        <field>Duplicate_Identified_Date__c</field>
        <formula>now()</formula>
        <name>Duplicate Account Identified Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Large_Herd_Initiative</fullName>
        <description>Updates the Large Herd Initiative Indicator with &quot;Yes&quot; when the Initiative contains Large Herd Initiative.  The purpose of updating this indicator is because it is used in an Account sharing rule,</description>
        <field>Large_Herd_Initiative_Indicator__c</field>
        <literalValue>Yes</literalValue>
        <name>Large Herd Initiative || Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Large_Herd_Initiative_No</fullName>
        <description>Updates Large Herd Initiative field so it is not used in the sharing rule.</description>
        <field>Large_Herd_Initiative_Indicator__c</field>
        <literalValue>No</literalValue>
        <name>Large Herd Initiative || No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_City_Update</fullName>
        <description>Updates Mapping Address with Shipping Address</description>
        <field>BillingCity</field>
        <formula>ShippingCity</formula>
        <name>Mapping City Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_Country_Update</fullName>
        <field>BillingCountry</field>
        <formula>ShippingCountry</formula>
        <name>Mapping Country Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_Postal_Zip_Code_Update</fullName>
        <field>BillingPostalCode</field>
        <formula>ShippingPostalCode</formula>
        <name>Mapping Postal/Zip Code Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_State_Update</fullName>
        <field>BillingState</field>
        <formula>ShippingState</formula>
        <name>Mapping State Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_Street_Update</fullName>
        <field>BillingStreet</field>
        <formula>ShippingStreet</formula>
        <name>Mapping Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Account_Sharing_Field_Update</fullName>
        <description>The partner account sharing number is equal to the Associated Dealer Account number</description>
        <field>Partner_Account_Sharing__c</field>
        <formula>Associated_Dealer_Account_Number__c</formula>
        <name>Partner Account Sharing Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Account_Record_Type</fullName>
        <description>Popoulates field with the previous record type value.</description>
        <field>Previous_Value_Record_Type__c</field>
        <formula>PRIORVALUE( Account_Record_Type_Text__c   )</formula>
        <name>Previous Account Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prospect_Direct_Producer_Record_Type_Upd</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Direct_Producer_Account_Save</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Prospect Direct Producer Record Type Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prospect_Retail_Producer_Record_Type_Upd</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Retail_Producer_Account_Save</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Prospect Retail Producer Record Type Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Prospect_Direct_Producer</fullName>
        <description>Sets the Account Record Type field on conversion to an Account to Prospect Direct Producer Account. if the Account Record Type (Hidden) field is Prospect Direct Producer Account.</description>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Direct_Producer_Account_Save</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type-Prospect Direct Producer.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Prospect_Retail_Producer_Acc</fullName>
        <description>Sets the Account Record Type field when a Lead is converted to an Account with the Lead Record Type (Hidden) field of Prospect Retail Producer Account.</description>
        <field>RecordTypeId</field>
        <lookupValue>Prospect_Retail_Producer_Account_Save</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type-Prospect Retail Producer Acc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Retail_Producer_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Retail_Producer_Account_Save</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Retail Producer Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Top_200_Dairy_No</fullName>
        <description>Field update for the Top 200 Dairy field so it will not be used in a sharing rule.</description>
        <field>Top_200_Dairy_Indicator__c</field>
        <literalValue>No</literalValue>
        <name>Top 200 Dairy || No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Mapping_URL_Link</fullName>
        <field>Mapping_URL_Link__c</field>
        <formula>SUBSTITUTE(IF(
AND(
 ISBLANK(Billing_Street__c),
 ISBLANK(Billing_City__c),
 ISBLANK(Billing_State_Province__c),
 ISBLANK(Billing_Country__c)),
 &apos;&apos;, &apos;https://maps.google.com/maps?q=&apos; &amp;  IF(ISBLANK(Billing_Street__c), &apos;&apos;, Billing_Street__c) &amp; IF(ISBLANK(Billing_City__c), &apos;&apos;, &apos;,&apos; &amp; Billing_City__c) &amp; IF(ISBLANK(Billing_State_Province__c), &apos;&apos;, &apos;,&apos; &amp; Billing_State_Province__c) &amp; IF(ISBLANK( Billing_Country__c), &apos;&apos;, &apos;,&apos; &amp;  Billing_Country__c)), &apos; &apos;, &apos;+&apos;)</formula>
        <name>Update Mapping URL Link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Top_200_Dairy_Field_Yes</fullName>
        <description>Updates the Top 200 Diary field with &quot;Yes&quot;</description>
        <field>Top_200_Dairy_Indicator__c</field>
        <literalValue>Yes</literalValue>
        <name>Update Top 200 Dairy Field || Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Direct Producer Record Type Update</fullName>
        <actions>
            <name>Direct_Producer_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Direct Producer Account</value>
        </criteriaItems>
        <description>Updates the record type upon create.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Duplicate Accounts</fullName>
        <actions>
            <name>Duplicate_Account_Identified_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Duplicate_Account_Identified_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Duplicate_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Duplicate Account Identifier</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Large Herd Initiative %7C%7C No</fullName>
        <actions>
            <name>Large_Herd_Initiative_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule to update the Large Herd Initiative field so it is not used in a sharing rule.</description>
        <formula>Not(INCLUDES( Initiative__c , &quot;GLR Large Herd Initiative&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Large Herd Initiative %7C%7C Yes</fullName>
        <actions>
            <name>Large_Herd_Initiative</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule to update the Large Herd Initiative field so it can be used in a sharing rule,</description>
        <formula>INCLUDES( Initiative__c , &quot;GLR Large Herd Initiative&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mapping Address Update for Prospect %26 Other Account Types</fullName>
        <actions>
            <name>Mapping_City_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mapping_Country_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mapping_Postal_Zip_Code_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mapping_State_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mapping_Street_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>,Prospect Retail Producer Account,Prospect Direct Producer Account,Other Account,Prospect Dealer-Coop Account,Retail Producer Account,Retail Producer Account.,Direct Producer Account.,Prospect Direct Producer Account.,Prospect Retail Producer Account.</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ShippingStreet</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ShippingCity</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ShippingState</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingStreet</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingCity__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingState__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Updates the Mapping Address with the Shipping Address upon new account creation for Prospect and Other Account types.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Customer Account</fullName>
        <actions>
            <name>New_Account_E_mail_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Account_External_ID_JDE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>A e-mail notification is sent to the system administrator with a new customer account is created through the integration.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Partner Account Sharing</fullName>
        <actions>
            <name>Partner_Account_Sharing_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect Retail Producer Account,Prospect Direct Producer Account,Direct Producer Account,National Account,Other Account,Direct Producer Account.,Prospect Direct Producer Account.,Prospect Retail Producer Account.</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retail Producer Account,Retail Producer Account.</value>
        </criteriaItems>
        <description>The Partner Account Sharing field is populated with the Associated Dealer Account Number</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Phase 2 Account Sharing</fullName>
        <actions>
            <name>Account_Sharing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Account.Associated_Dealer_18_Digit_ID__c</field>
            <operation>equals</operation>
            <value>001j000000MSVN4AAP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Associated_Dealer_18_Digit_ID__c</field>
            <operation>equals</operation>
            <value>001j0000002Xdk7AAC</value>
        </criteriaItems>
        <description>Sharing rule for training SFDC Phase 2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Previous Record Type Value</fullName>
        <actions>
            <name>Date_Account_Record_Type_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Previous_Account_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow records the previous record type.</description>
        <formula>ISCHANGED(Account_Record_Type_Text__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prospect Direct Producer Record Type Update</fullName>
        <actions>
            <name>Prospect_Direct_Producer_Record_Type_Upd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect Direct Producer Account</value>
        </criteriaItems>
        <description>Updates the record type upon create.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prospect Retail Producer Record Type Update</fullName>
        <actions>
            <name>Prospect_Retail_Producer_Record_Type_Upd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect Retail Producer Account</value>
        </criteriaItems>
        <description>Updates the record type upon create.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Record Type-Prospect Direct Producer Account%2E</fullName>
        <actions>
            <name>Record_Type_Prospect_Direct_Producer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Record_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>Prospect Direct Producer Account.</value>
        </criteriaItems>
        <description>Sets the Account Record Type field when a Lead is converted to an Account with the Lead Record Type (Hidden) field of Prospect Direct Producer Account.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Record Type-Prospect Retail Producer Account%2E</fullName>
        <actions>
            <name>Record_Type_Prospect_Retail_Producer_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Record_Type_Hidden__c</field>
            <operation>equals</operation>
            <value>Prospect Retail Producer Account.</value>
        </criteriaItems>
        <description>Sets the Account Record Type field when a Lead is converted to an Account with the Lead Record Type (Hidden) field of Prospect Retail Producer Account.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Retail Producer Record Type Update</fullName>
        <actions>
            <name>Retail_Producer_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retail Producer Account</value>
        </criteriaItems>
        <description>Updates the record type upon create.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Top 200 Dairy %7C%7C No</fullName>
        <actions>
            <name>Top_200_Dairy_No</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule to update the Top 200 Dairy field so it will not be used in a sharing rule.</description>
        <formula>Not(INCLUDES( Initiative__c , &quot;Top 200 Dairy&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Top 200 Dairy %7C%7C Yes</fullName>
        <actions>
            <name>Update_Top_200_Dairy_Field_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule to update the Top 200 Dairy field so it can be used in a sharing rule.</description>
        <formula>INCLUDES( Initiative__c , &quot;Top 200 Dairy&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Mapping URL Link</fullName>
        <actions>
            <name>Update_Mapping_URL_Link</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL(Id))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
