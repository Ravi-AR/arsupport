<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Business_Builder_Enrollment_Amount</fullName>
        <description>Business Builder Enrollment Amount</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AMA_Expense_Approval_Request/Business_Builder_Enrollment_Amount</template>
    </alerts>
    <fieldUpdates>
        <fullName>SS_Set_External_Id_for_Program_Year</fullName>
        <field>SellingSupportExternalId__c</field>
        <formula>BusinessBuilderProgramYear__r.Name + &quot;-&quot; +  Account__r.Account_External_ID_JDE__c</formula>
        <name>SS-Set External Id for Program Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Selling_Support_Balance_Record_Name</fullName>
        <description>Selling Support Balance Record Name Update</description>
        <field>Name</field>
        <formula>BusinessBuilderProgramYear__r.Name</formula>
        <name>Selling Support Balance Record Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetAccountStatustoEligible</fullName>
        <field>BusinessBuilderProgramStatus__c</field>
        <literalValue>Eligible</literalValue>
        <name>Set Account Status to Eligible</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Status_to_Enrolled</fullName>
        <description>Sets the enrollment status on the Account to Enrolled</description>
        <field>BusinessBuilderProgramStatus__c</field>
        <literalValue>Enrolled</literalValue>
        <name>Set Account Status to Enrolled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Account Selling Support Balance Name</fullName>
        <actions>
            <name>Selling_Support_Balance_Record_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SellingSupportProgramYear__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Account Selling Support Balance Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Business Builder Enrollment Amount</fullName>
        <actions>
            <name>Business_Builder_Enrollment_Amount</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email to Dealer when an Enrollment Amount is added to their Selling Support Program Year</description>
        <formula>AND(  CreatedBy.Profile.Name = &quot;Dealer Community User&quot;,   ISPICKVAL(BusinessBuilderProgramStatus__c , &quot;Enrolled&quot;),  Program_Year_Allocation__c &gt;= 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Dealer Account Eligible</fullName>
        <actions>
            <name>SetAccountStatustoEligible</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.BusinessBuilderProgramStatus__c</field>
            <operation>equals</operation>
            <value>Ineligible</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BusinessBuilderProgramStatus__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SellingSupportProgramYear__c.BusinessBuilderProgramStatus__c</field>
            <operation>equals</operation>
            <value>Not Enrolled</value>
        </criteriaItems>
        <description>If the dealer account status is NULL or Ineligible, update status to Eligible</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dealer Account Enrolled</fullName>
        <actions>
            <name>Set_Account_Status_to_Enrolled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.BusinessBuilderProgramStatus__c</field>
            <operation>notEqual</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>SellingSupportProgramYear__c.BusinessBuilderProgramStatus__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <description>If the selling support status is Enrolled for any SSPY, set Account status as &apos;Enrolled&apos;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SS-Set External Id for Program Year</fullName>
        <actions>
            <name>SS_Set_External_Id_for_Program_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>BusinessBuilderProgramYear__r.Name + &quot;-&quot; +  Account__r.Account_External_ID_JDE__c</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
