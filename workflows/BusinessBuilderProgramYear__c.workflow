<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_External_ID_BBPY</fullName>
        <description>Set External ID BBPY</description>
        <field>BBPYExternal_ID__c</field>
        <formula>Name</formula>
        <name>Set External ID BBPY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Set External ID BBPY</fullName>
        <actions>
            <name>Set_External_ID_BBPY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set External ID for Business Builder Program Year</description>
        <formula>Name &lt;&gt;  BBPYExternal_ID__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
