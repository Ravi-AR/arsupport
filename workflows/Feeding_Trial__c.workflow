<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>E_mail_Notification_of_New_Feeding_Trial</fullName>
        <description>E-mail Notification of New Feeding Trial</description>
        <protected>false</protected>
        <recipients>
            <recipient>purinacrmsupport@landolakes.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Feeding_Trial_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Approver_of_Cattle_Feeding_Trial_Submission</fullName>
        <description>Notify Approver of Cattle Feeding Trial Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>dhshain@landolakes.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cattle_Feeding_Trial_Approval_Process/Notify_Approver_of_Cattle_Feeding_Trial_Submission</template>
    </alerts>
    <alerts>
        <fullName>Notify_Submitter_Cattle_Feeding_Trial_Approved</fullName>
        <description>Notify Submitter Cattle Feeding Trial Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cattle_Feeding_Trial_Approval_Process/Notify_Submitter_of_Cattle_Feeding_Trial_Approval</template>
    </alerts>
    <alerts>
        <fullName>Notify_Submitter_Cattle_Feeding_Trial_Rejected</fullName>
        <description>Notify Submitter Cattle Feeding Trial Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Lead_Purina_Sales_Person__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cattle_Feeding_Trial_Approval_Process/Notify_Submitter_of_Cattle_Feeding_Trial_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Pending</fullName>
        <field>Feeding_Trial_Status__c</field>
        <literalValue>Feeding Trial Complete - Pending Approval</literalValue>
        <name>Update Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <description>Update Status to Approved</description>
        <field>Feeding_Trial_Status__c</field>
        <literalValue>Feeding Trial Complete - Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Pending</fullName>
        <field>Feeding_Trial_Status__c</field>
        <literalValue>Feeding Trial Complete - Pending Approval</literalValue>
        <name>Update Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <description>update status to rejected</description>
        <field>Feeding_Trial_Status__c</field>
        <literalValue>Feeding Trial Complete - Not Approved</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>New Feeding Trial</fullName>
        <actions>
            <name>E_mail_Notification_of_New_Feeding_Trial</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Feeding_Trial__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Sends an e-mail notification when a new feeding trial record has been created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
