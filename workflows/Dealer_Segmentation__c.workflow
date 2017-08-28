<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dealer_Segmentation_Email_Alert</fullName>
        <description>Dealer Segmentation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Dealer_Segmentation_Update_Alert</template>
    </alerts>
    <rules>
        <fullName>Dealer Segmentation Prompt</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Prompts the record owner every 6mos to make updates.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Dealer_Segmentation_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Dealer_Segmentation__c.LastModifiedDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
