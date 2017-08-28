<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Profile_Change_Date</fullName>
        <description>Profile Change Date</description>
        <field>Profile_Change_Date__c</field>
        <formula>today()</formula>
        <name>Profile Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Profile_Changed_By</fullName>
        <description>Who was the user who changed the user&apos;s profile?</description>
        <field>Profile_Changed_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Profile Changed By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Profile_Previous</fullName>
        <description>Updates the users previous profile</description>
        <field>Profile_Previous__c</field>
        <formula>PRIORVALUE(  Profile_Current__c  )</formula>
        <name>Profile Previous</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Role_Change_By</fullName>
        <description>Identifies who changed the users role</description>
        <field>Role_Changed_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Role Change By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Role_Change_Date</fullName>
        <description>The date a user&apos;s role changes.</description>
        <field>Role_Change_Date__c</field>
        <formula>today()</formula>
        <name>Role Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Role_Previous</fullName>
        <description>Identified what the previous role of the user was.</description>
        <field>Role_Previous__c</field>
        <formula>PRIORVALUE( Role_Current__c )</formula>
        <name>Role Previous</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_By</fullName>
        <description>Identifies who change the &quot;Active&quot; field on the user record.</description>
        <field>Status_Changed_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Status Change By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_Date</fullName>
        <description>Identifies when the &quot;Active&quot; was changed on a user record.</description>
        <field>Status_Change_Date__c</field>
        <formula>today()</formula>
        <name>Status Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Previous</fullName>
        <description>Identified what the previous status was on a user record.</description>
        <field>Status_Previous__c</field>
        <formula>PRIORVALUE( Status_Current__c )</formula>
        <name>Status Previous</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Profile_Current_Field</fullName>
        <description>Updates the Profile Current field</description>
        <field>Profile_Current__c</field>
        <formula>Profile.Name</formula>
        <name>Update Profile Current Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Role_Current_Field</fullName>
        <description>Updates the Role Current  field on the User record</description>
        <field>Role_Current__c</field>
        <formula>UserRole.Name</formula>
        <name>Update Role Current Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Current_Field</fullName>
        <description>Updates the Status Current field via workflow.</description>
        <field>Status_Current__c</field>
        <formula>if(IsActive =True,&quot;Active&quot;,&quot;Inactive&quot;)</formula>
        <name>Update Status Current Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>User Profile Tracking</fullName>
        <actions>
            <name>Profile_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Profile_Changed_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Profile_Previous</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the following fields on the user record:  Profile Previous, Profile Change Date, Profile Changed By</description>
        <formula>ISCHANGED( Profile_Current__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Role Tracking</fullName>
        <actions>
            <name>Role_Change_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Role_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Role_Previous</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the following fields on the user record:  Role Previous, Role Change Date, Role Changed By</description>
        <formula>ISCHANGED( Role_Current__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Status Tracking</fullName>
        <actions>
            <name>Status_Change_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Previous</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the following fields on the user record:  Status Previous, Status Change Date, Status Changed By</description>
        <formula>ISCHANGED(Status_Current__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User update to Current Profile%2C Current Role %26 Current Status</fullName>
        <actions>
            <name>Update_Profile_Current_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Role_Current_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_Current_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the following text fields:  Current Profile, Current Role and Current Status</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
