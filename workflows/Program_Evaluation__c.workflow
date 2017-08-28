<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Program_Evaluation_UC_avg_wt_out_Update</fullName>
        <description>Field update to update UC avg wt out field.</description>
        <field>UC_avg_wt_out__c</field>
        <formula>UC_Avg_Wt_Out_Result_Field__c</formula>
        <name>Program Evaluation: UC avg wt out Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Program Evaluation%3A Update UC avg wt out</fullName>
        <actions>
            <name>Program_Evaluation_UC_avg_wt_out_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Program_Evaluation__c.Diff_ADG_Input__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow rule to update UC avg wt out Field when Diff ADG % Input field is populated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
