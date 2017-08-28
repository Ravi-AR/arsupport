<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_Email_Alert_PMI_Contact_Us_Form</fullName>
        <ccEmails>coscott@landolakes.com</ccEmails>
        <description>Contact Email Alert || PMI Contact Us Form</description>
        <protected>false</protected>
        <senderAddress>purinacrmsupport@landolakes.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PMI_Contact_Us_Email/PMI_Contact_Us_Contact_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Prebook_Authrorized_Contact_Request</fullName>
        <ccEmails>purinacustomermarketing@landolakes.com; purinacxprjteamsupport@landolakes.com</ccEmails>
        <description>Prebook Authrorized Contact Request</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Prebook_Emails/Prebook_Authorized_Request_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Date_Resubscribed_to_emails</fullName>
        <description>The date the contact resubscribed to emails</description>
        <field>Date_Resubscribed__c</field>
        <formula>Today()</formula>
        <name>Contact || Date Resubscribed to emails.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_PMI_Contact_Us_Date_Filled_Out</fullName>
        <description>The date the PMI Contact Us web form was filled out.</description>
        <field>PMI_Contact_Us_Date_Question_Asked__c</field>
        <formula>Now()</formula>
        <name>Contact PMI Contact Us | Date Filled Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Pardot_Vet_Conversion_Date</fullName>
        <description>Updates the Pardot Conversation Date field with today dates.</description>
        <field>Pardot_Vet_Pricing_Conversion_Date__c</field>
        <formula>today()</formula>
        <name>Contact || Pardot Vet Conversion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Unsubscribe_from_Emails</fullName>
        <description>The date the Contract unsubscribed from emails.</description>
        <field>Date_Unsubscribed__c</field>
        <formula>Today()</formula>
        <name>Contact || Unsubscribe from Emails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Time_Duplicated_Identified</fullName>
        <field>Duplicate_Identified__c</field>
        <formula>now()</formula>
        <name>Date/Time Duplicated Identified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Digigraph_Last_Update</fullName>
        <description>Used to update the Digigraph Last Updated field when the phone, email or mobile phone number change.</description>
        <field>Digigraph_Last_Update__c</field>
        <formula>Now()</formula>
        <name>Digigraph Last Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dup_Field</fullName>
        <field>Duplicated_Identifed_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Update Duplicate Identified By Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Contact %7C%7C Date Unsubscribe from Emails</fullName>
        <actions>
            <name>Contact_Unsubscribe_from_Emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>The contact unsubscribes from emails.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact %7C%7C Email Resubmitted Date %28Opt Out%29</fullName>
        <actions>
            <name>Contact_Date_Resubscribed_to_emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the email opt out changes to &quot;false&quot;, capture the resubmited date.</description>
        <formula>ANd( 
ISCHANGED( HasOptedOutOfEmail ) , 
HasOptedOutOfEmail = False, 
Text( Date_Unsubscribed__c ) = &quot;&quot;, 
Text( Date_Resubscribed__c ) = &quot;&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact %7C%7C Pardot Vet Pricing Conversion Date</fullName>
        <actions>
            <name>Contact_Pardot_Vet_Conversion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Pardot Vet Conversion date.</description>
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
        <fullName>Contacts %7C%7C Resubscribed to Emails</fullName>
        <actions>
            <name>Contact_Date_Resubscribed_to_emails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Date_Unsubscribed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Date the Contact resubscribed to emails.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Digigraph Last Update</fullName>
        <actions>
            <name>Digigraph_Last_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates when the contact email, phone or mobile phone number changes.</description>
        <formula>And(  IsNew(),  Or(  Not(IsBlank(Email)),  Not(IsBlank(Phone)),  Not(IsBlank(MobilePhone))  ))   ||   And(  Not(IsNew()),  Or(  ISCHANGED(Email),  ISCHANGED(Phone),  ISCHANGED(MobilePhone)  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Duplicate Contact Identification</fullName>
        <actions>
            <name>Date_Time_Duplicated_Identified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dup_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Duplicate_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Shows who last updated the field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PMI Contact Us %7C%7C Contact Email Alert</fullName>
        <actions>
            <name>Contact_Email_Alert_PMI_Contact_Us_Form</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email when a PMI Contact Us web form is mapped to a lead.</description>
        <formula>AND(
 IsNew(),
 Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot;,
 text(Contact_Converted_From_Lead__c)  &lt;&gt; &quot;Yes&quot;
)

 || 

AND(
 Not(IsNew()),
 Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot;,
 IsBlank(PRIORVALUE(Web_Form_PMI_Contact_Us__c))
)

||

And(
 Not(IsNew()),
 Web_Form_PMI_Contact_Us__c = &quot;PMI Contact Us&quot;,
 IsChanged(PMI_Contact_Us_Question__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PMI Contact Us %7C%7C Date Filled Out</fullName>
        <actions>
            <name>Contact_PMI_Contact_Us_Date_Filled_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The date and time the PMI Contact Us web form was filled out.</description>
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
        <fullName>Prebook Authorized Request</fullName>
        <actions>
            <name>Prebook_Authrorized_Contact_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Request_Prebook_Access__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends and email to have the contact switched to Prebook Authorized (and set up a user for the contact)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
