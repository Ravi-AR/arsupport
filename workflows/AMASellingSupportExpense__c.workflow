<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Credit_Memo_Notification</fullName>
        <description>Credit Memo Notification - Initial</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Credit_Memo_Applied</template>
    </alerts>
    <alerts>
        <fullName>Credit_Memo_Notification_Rework</fullName>
        <description>Credit Memo Notification - Rework</description>
        <protected>false</protected>
        <recipients>
            <field>CloneExpensefromCreatedByUser__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Credit_Memo_Applied</template>
    </alerts>
    <alerts>
        <fullName>Line_Item_Rework_Notification</fullName>
        <description>Line Item Rework Notification - Initial</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Rework_Line_Item_Notification</template>
    </alerts>
    <alerts>
        <fullName>Line_Item_Rework_Notification_Rework</fullName>
        <description>Line Item Rework Notification - Rework</description>
        <protected>false</protected>
        <recipients>
            <field>CloneExpensefromCreatedByUser__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Rework_Line_Item_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sales_Admin_Rework_Notification</fullName>
        <description>Sales Admin Rework Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Sales_Admin_Rework_Notification</template>
    </alerts>
    <alerts>
        <fullName>Submission_Confirmation_to_Creator</fullName>
        <description>Submission Confirmation to Creator - Initial</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Initial_Submission_Email_Creator</template>
    </alerts>
    <alerts>
        <fullName>Submission_Confirmation_to_Dealer_Rework</fullName>
        <description>Submission Confirmation to Dealer - Rework</description>
        <protected>false</protected>
        <recipients>
            <field>CloneExpensefromCreatedByUser__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Initial_Submission_Email_Creator</template>
    </alerts>
    <fieldUpdates>
        <fullName>AMA_Set_to_Complete_Not_Paid</fullName>
        <field>Internal_Status__c</field>
        <literalValue>Complete - Not Paid</literalValue>
        <name>AMA-Set to Complete-Not Paid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMA_Set_to_Complete_Paid_In_Full</fullName>
        <field>Internal_Status__c</field>
        <literalValue>Complete - Paid in Full</literalValue>
        <name>AMA-Set to Complete-Paid In Full</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AMA_Set_to_Complete_Partially_Paid</fullName>
        <description>Status (internal) Complete Partially Paid</description>
        <field>Internal_Status__c</field>
        <literalValue>Complete - Partially Paid</literalValue>
        <name>Internal Status Complete-Partially Paid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Update_Initial</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Approval Status Update Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Balance_Adjustment_Approved</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Complete - Paid in Full</literalValue>
        <name>Balance Adjustment Paid In Full</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Balance_Adjustment_Record_Type_Update</fullName>
        <description>Validation to update the Reimbursement Record Type to match the Type field. If Type is set to &apos;Balance Adjustment&apos;, set the record type to &apos;Balance Adjustment&apos;.</description>
        <field>RecordTypeId</field>
        <lookupValue>Balance_Adjustment</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Balance Adjustment Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_Paid_In_Full</fullName>
        <description>Complete Paid In Full - Dealer Facing</description>
        <field>ApprovalStatus__c</field>
        <literalValue>Complete - Paid in Full</literalValue>
        <name>Complete Paid In Full</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Facing_Status_Complete_Not_Paid</fullName>
        <description>Set Dealer Facing Status - Complete Not Paid</description>
        <field>ApprovalStatus__c</field>
        <literalValue>Complete - Not Paid</literalValue>
        <name>Dealer Facing Status - Complete Not Paid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Status_Complete_Not_Paid</fullName>
        <description>Dealer Status Complete Not Paid</description>
        <field>ApprovalStatus__c</field>
        <literalValue>In Progress</literalValue>
        <name>Dealer Status Complete Not Paid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Status_Complete_Partially_Paid</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Complete - Partially Paid</literalValue>
        <name>Dealer Status Complete Partially Paid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Status_In_Progress</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>In Progress</literalValue>
        <name>Dealer Status - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_facing_Status_Complete_Partially</fullName>
        <description>Set Dealer Facing Status Complete Partially Paid</description>
        <field>ApprovalStatus__c</field>
        <literalValue>Complete - Partially Paid</literalValue>
        <name>Dealer Facing Status Complete Partially</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Entered_by_Sales_Admin_Internal</fullName>
        <description>Entered by Sales Admin (Internal Facing Status)</description>
        <field>Internal_Status__c</field>
        <literalValue>Entered by Sales Admin</literalValue>
        <name>Entered by Sales Admin Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Approved_by_ASM</fullName>
        <description>Internal - Approved by ASM</description>
        <field>Internal_Status__c</field>
        <literalValue>Approved by Area Sales Manager</literalValue>
        <name>Internal - Approved by ASM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Approved_by_Sales_Options</fullName>
        <description>Internal - Approved by_Sales_Operations</description>
        <field>Internal_Status__c</field>
        <literalValue>Approved Sales Operations</literalValue>
        <name>Internal - Approved by_Sales_Operations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Approved_by_Sales_Specialist</fullName>
        <description>Approved by Sales Specialist</description>
        <field>Internal_Status__c</field>
        <literalValue>Approved by Sales Specialist</literalValue>
        <name>Internal - Approved by Sales Specialist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Status_Initial_Submission</fullName>
        <description>Internal Status Initial Submission</description>
        <field>Internal_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Internal Status Initial Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reimbursement_Adjustment_Balance_Percent</fullName>
        <description>Set reimbursement balance to 100%</description>
        <field>Reimbursement_Percentage__c</field>
        <formula>1</formula>
        <name>Reimbursement Adjustment Balance Percent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reimbursement_Request_Record_Type_Update</fullName>
        <description>Update Reimbursement Record Type Based on Type Expense</description>
        <field>RecordTypeId</field>
        <lookupValue>Reimbursement_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Reimbursement Request Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reimbursement_Type</fullName>
        <field>Type__c</field>
        <literalValue>Expense</literalValue>
        <name>Reimbursement Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_by_ASM_Internal</fullName>
        <description>Rejected by ASM</description>
        <field>Internal_Status__c</field>
        <literalValue>Rejected by Area Sales Manager</literalValue>
        <name>Rejected by ASM Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_by_Sales_Operations_Internal</fullName>
        <description>Rejected by Sales Operations Internal</description>
        <field>Internal_Status__c</field>
        <literalValue>Rejected by Sales Operations</literalValue>
        <name>Rejected by Sales Operations Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_by_Sales_Specialist_Internal</fullName>
        <description>Rejected by Sales Specialist Internal</description>
        <field>Internal_Status__c</field>
        <literalValue>Rejected by Sales Specialist</literalValue>
        <name>Rejected by Sales Specialist Internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Saved</fullName>
        <description>Field: Status (internal), &apos;Saved&apos; = Status (dealer facing), &apos;Saved&apos;</description>
        <field>Internal_Status__c</field>
        <literalValue>Saved</literalValue>
        <name>Saved internal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Saved_on_recall</fullName>
        <description>Saved on recall</description>
        <field>ApprovalStatus__c</field>
        <literalValue>Saved</literalValue>
        <name>Saved on recall dealer facing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_internal_Complete_paid_in_full</fullName>
        <description>Status (internal)-Complete paid in full</description>
        <field>Internal_Status__c</field>
        <literalValue>Complete - Paid in Full</literalValue>
        <name>Balance Adjustment Internal Paid In Full</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date</fullName>
        <description>Update date when record is submitted for Approval</description>
        <field>Submitted_for_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AMA-Autopopulate Reimbursement Type</fullName>
        <actions>
            <name>Reimbursement_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Dealer Community User</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AMA-Set to Complete-Not Paid</fullName>
        <actions>
            <name>AMA_Set_to_Complete_Not_Paid</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dealer_Facing_Status_Complete_Not_Paid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Internal_Status__c</field>
            <operation>equals</operation>
            <value>Approved Sales Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Rejected_Line_Item_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Approved_Line_Item_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Update Internal Status to Complete Not Paid when no line items are approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AMA-Set to Complete-Paid In Full</fullName>
        <actions>
            <name>AMA_Set_to_Complete_Paid_In_Full</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Complete_Paid_In_Full</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Internal_Status__c</field>
            <operation>equals</operation>
            <value>Approved Sales Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Rejected_Line_Item_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Approved_Line_Item_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CreditMemo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AMA-Set to Complete-Partially Paid</fullName>
        <actions>
            <name>AMA_Set_to_Complete_Partially_Paid</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dealer_facing_Status_Complete_Partially</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Internal_Status__c</field>
            <operation>equals</operation>
            <value>Approved Sales Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Rejected_Line_Item_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Approved_Line_Item_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CreditMemo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Balance Adjustment Status Approved and Percent</fullName>
        <actions>
            <name>Balance_Adjustment_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reimbursement_Adjustment_Balance_Percent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_internal_Complete_paid_in_full</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Type__c</field>
            <operation>equals</operation>
            <value>Balance Adjustment</value>
        </criteriaItems>
        <description>Reimbursement Type &apos; Balance Adjustment&apos; set Status to Approved and Percent</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Memo Applied</fullName>
        <actions>
            <name>Credit_Memo_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CreditMemo__c</field>
            <operation>greaterThan</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Total__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Internal_Status__c</field>
            <operation>equals</operation>
            <value>Complete - Paid in Full,Complete - Partially Paid</value>
        </criteriaItems>
        <description>When credit memo is complete set status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Memo Applied - Initial</fullName>
        <actions>
            <name>Credit_Memo_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CreditMemo__c</field>
            <operation>greaterThan</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Total__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Internal_Status__c</field>
            <operation>equals</operation>
            <value>Complete - Paid in Full,Complete - Partially Paid</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CloneExpensefromCreatedByUser__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When credit memo is complete set status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Memo Applied - Rework</fullName>
        <actions>
            <name>Credit_Memo_Notification_Rework</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CreditMemo__c</field>
            <operation>greaterThan</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Total__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Internal_Status__c</field>
            <operation>equals</operation>
            <value>Complete - Paid in Full,Complete - Partially Paid</value>
        </criteriaItems>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.CloneExpensefromCreatedByUser__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When credit memo is complete set status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>In Progress Partially Paid</fullName>
        <actions>
            <name>Dealer_Status_Complete_Partially_Paid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.ApprovalStatus__c</field>
            <operation>equals</operation>
            <value>Complete - Partially Paid</value>
        </criteriaItems>
        <description>If Status (internal) equals Complete Partially Paid Update Status (dealer facing) to  Complete Partially Paid</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Line Item Rework Notification - Initial</fullName>
        <actions>
            <name>Line_Item_Rework_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification to the Dealer when a line item is set to &apos;Rework&apos; and Sales Operations has approved or rejected the Reimbursement Request</description>
        <formula>OR( AND(  Number_of_Rework_Items__c &gt; 0,  CreatedBy.Profile.Name = &quot;Dealer Community User&quot;,  ISBLANK(CloneExpensefromCreatedByUser__c),  ISPICKVAL(Internal_Status__c, &apos;Complete - Partially Paid&apos;),  NOT(ISBLANK(CreditMemo__c))), AND(  Number_of_Rework_Items__c &gt; 0,  CreatedBy.Profile.Name = &quot;Dealer Community User&quot;,  ISBLANK(CloneExpensefromCreatedByUser__c),  ISPICKVAL(Internal_Status__c, &apos;Complete - Not Paid&apos;),  ISBLANK(CreditMemo__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Line Item Rework Notification - Rework</fullName>
        <actions>
            <name>Line_Item_Rework_Notification_Rework</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification to the Dealer when an already Reworked line item line item is set to &apos;Rework&apos; (again) and Sales Operations has approved or rejected the Reimbursement Request</description>
        <formula>OR( AND(  Number_of_Rework_Items__c &gt; 0,  CreatedBy.Profile.Name = &quot;Sales Operations&quot;,  NOT(ISBLANK(CloneExpensefromCreatedByUser__c)),  ISPICKVAL(Internal_Status__c, &apos;Complete - Partially Paid&apos;),  NOT(ISBLANK(CreditMemo__c))), AND(  Number_of_Rework_Items__c &gt; 0,  CreatedBy.Profile.Name = &quot;Sales Operations&quot;,  NOT(ISBLANK(CloneExpensefromCreatedByUser__c)),  ISPICKVAL(Internal_Status__c, &apos;Complete - Not Paid&apos;),  ISBLANK(CreditMemo__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update BA RR Record Type Based on Type</fullName>
        <actions>
            <name>Balance_Adjustment_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Type__c</field>
            <operation>equals</operation>
            <value>Balance Adjustment</value>
        </criteriaItems>
        <description>Validation to update the Reimbursement Record Type to match the Type field. If Type is set to &apos;Balance Adjustment&apos;, set the record type to &apos;Balance Adjustment&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update RR RR Record Type Based on Type</fullName>
        <actions>
            <name>Reimbursement_Request_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AMASellingSupportExpense__c.Type__c</field>
            <operation>equals</operation>
            <value>Expense</value>
        </criteriaItems>
        <description>Validation to update the Reimbursement Record Type to match the Type field. If Type is set to &apos;Expense&apos;, set the Record Type to &apos;Reimbursement Request&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
