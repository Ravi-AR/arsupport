<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Rework</fullName>
        <description>Rework</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Area_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>BB_Approver_Sales_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Rework_Line_Item_Notification</template>
    </alerts>
    <alerts>
        <fullName>Rework_Notification</fullName>
        <description>Rework Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Area_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>BB_Approver_Sales_Specialist__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Rework_Line_Item_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>AMA_100_Reimbursement_for_Balance</fullName>
        <field>Total_Spend__c</field>
        <formula>Expense__r.SalesOperationsBalanceAdjustment__c</formula>
        <name>AMA-100% Reimbursement for Balance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMA_Set_Percent_to_100</fullName>
        <field>Reimbursement_Percentage__c</field>
        <formula>1</formula>
        <name>AMA_Set Percent to 100%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Balance_Adjustment_Status_Approved</fullName>
        <description>Update status field to approved when a balance adjustment is created</description>
        <field>ApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Balance Adjustment Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Expense__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Line_Item_Saved</fullName>
        <description>Default the Line Item to &apos;Saved&apos; when created by an Internal User</description>
        <field>Approval_Status__c</field>
        <literalValue>Saved</literalValue>
        <name>Line Item - Saved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AMA-100%25 Reimbursement for Balance Adjustments</fullName>
        <actions>
            <name>AMA_Set_Percent_to_100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Amount Reimbursed ($) to 100% the Expense Amount ($) for Balance Adjustments.</description>
        <formula>Expense__r.RecordType.DeveloperName = &apos;Balance_Adjustment&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AMA-If Balance Adjustment Status Approved</fullName>
        <actions>
            <name>Balance_Adjustment_Status_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Type__c</field>
            <operation>equals</operation>
            <value>Balance Adjustment</value>
        </criteriaItems>
        <description>If type is Balance Adjustment update status to Approved</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Line Item - Saved</fullName>
        <actions>
            <name>Line_Item_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Default the Line Item to &apos;Saved&apos; when created by an Internal User</description>
        <formula>CreatedBy.Profile.Name &lt;&gt; &quot;Dealer Community User&quot; &amp;&amp; ISPICKVAL(Approval_Status__c,&apos;&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Rework</fullName>
        <actions>
            <name>Rework_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notification when a line item is set to &apos;rework&apos;</description>
        <formula>AND(  ISPICKVAL(Approval_Status__c, &apos;Rework&apos;),  CreatedBy.Profile.Name = &apos;Dealer Community User&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rework Line Item Notification</fullName>
        <actions>
            <name>Rework</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AMASellingSupportExpenseLineItem__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rework</value>
        </criteriaItems>
        <description>Notification when Reimbursement Request Line Item is set to &apos;rework&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
