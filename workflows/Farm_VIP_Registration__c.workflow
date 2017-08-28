<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Farm_VIP_Registration_Approval_Notification</fullName>
        <description>Farm VIP Registration Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Farm_VIP_Events_Approval_Templates/Farm_VIP_Reg_Nomination_Approved</template>
    </alerts>
    <alerts>
        <fullName>Farm_VIP_Registration_Cancelation_Notification</fullName>
        <description>Farm VIP Registration Cancelation Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>FARM_VIP_Gretchen_Richard_Rod</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Farm_VIP_Events_Approval_Templates/Farm_VIP_Reg_Canceled</template>
    </alerts>
    <alerts>
        <fullName>Farm_VIP_Registration_Confirmation</fullName>
        <description>Farm VIP Registration Confirmation</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Farm_VIP_Events_Approval_Templates/Farm_VIP_Reg_Awaiting_Approval</template>
    </alerts>
    <alerts>
        <fullName>Farm_VIP_Registration_Edited_record_after_has_been_Approved</fullName>
        <description>Farm VIP Registration - Edited record after has been Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>FARM_VIP_Gretchen_Richard_Rod</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Farm_VIP_Events_Approval_Templates/Farm_VIP_Reg_Approved_Record_has_been_Edited</template>
    </alerts>
    <alerts>
        <fullName>Farm_VIP_Registration_Rejection_Notification</fullName>
        <description>Farm VIP Registration Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Farm_VIP_Events_Approval_Templates/Farm_VIP_Reg_Nomination_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Approval_Date</fullName>
        <description>Stores the date that the Farm VIP Registration Record was Approved</description>
        <field>Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Farm VIP Reg: Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Approved</fullName>
        <description>Updates the Approval Status to &quot;Approved&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Farm VIP Reg: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Approved_Record_Type</fullName>
        <description>Updates the Farm VIP Registration record to the &quot;Approved&quot; record type</description>
        <field>RecordTypeId</field>
        <lookupValue>Approved_Farm_VIP_Event_Registration</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Farm VIP Reg: Approved Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Canceled_Record_Type</fullName>
        <description>Updates the Farm VIP Registration record to the &quot;Canceled&quot; record type</description>
        <field>RecordTypeId</field>
        <lookupValue>FarmVIPEventRegistration</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Farm VIP Reg: Canceled Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Cancelled</fullName>
        <description>Updates the Approval Status of the Farm VIP Registration to &quot;Cancelled&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Farm VIP Reg: Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_New</fullName>
        <description>Updates the Approval Status to &quot;New&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>New</literalValue>
        <name>Farm VIP Reg: New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Rejected</fullName>
        <description>Update the Approval Status to &quot;Rejected&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Farm VIP Reg: Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Resubmitted</fullName>
        <description>Update the &quot;Resubmitted&quot; checkbox to true when the approval is</description>
        <field>Re_submitted__c</field>
        <literalValue>1</literalValue>
        <name>Farm VIP Reg: Re-submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_VIP_Reg_Submitted_for_Approval</fullName>
        <description>Updates the Approval Status to &quot;Submitted for Approval&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Farm VIP Reg: Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Farm VIP Reg%3A Canceled Status</fullName>
        <actions>
            <name>Farm_VIP_Registration_Cancelation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Farm_VIP_Reg_Canceled_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notifies the Farm VIP Event Managers of cancelled registrations and updates the Farm VIP Reg. record type</description>
        <formula>AND( RecordType.Name = &quot;Approved Farm VIP Event Registration&quot;,ISPICKVAL( PRIORVALUE( Approval_Status__c ) , &quot;Approved&quot;) ,ISPICKVAL( Approval_Status__c , &quot;Canceled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Re_submit_Farm_VIP_Nomination</fullName>
        <assignedToType>owner</assignedToType>
        <description>Review the rejection comments and please re-submit your nomination for the Farm VIP Event.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Re-submit Farm VIP Nomination</subject>
    </tasks>
</Workflow>
