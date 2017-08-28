<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Farm_VIP_Opportunity_Reminder</fullName>
        <description>Farm VIP Opportunity Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>purinacrmsupport@landolakes.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Farm_VIP_Opportunity_Reminder/Farm_VIP_Opportunity_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Farm_VIP_Opportunity_Reminder_14_Days_After_Anticipated_Close_Date</fullName>
        <description>Farm VIP Opportunity Reminder - 14 Days After Anticipated Close Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>purinacrmsupport@landolakes.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Farm_VIP_Opportunity_Reminder/Farm_VIP_Opportunity_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>Date_Opportunity_Stage_Moved_to_Won</fullName>
        <description>Date the Opportunity Stage is moved to Closed Won</description>
        <field>Date_Stage_is_Moved_to_Closed_Won__c</field>
        <formula>today()</formula>
        <name>Date Opportunity Stage Moved to Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Oppty_Moved_to_Closed_Won</fullName>
        <description>Date the Opportunity was moved to closed won.</description>
        <field>Date_Stage_is_Moved_to_Closed_Won__c</field>
        <formula>today()</formula>
        <name>Date Oppty Moved to Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lifestage_N_A</fullName>
        <description>Lifestage = N/A</description>
        <field>Life_Stage__c</field>
        <literalValue>N/A</literalValue>
        <name>Lifestage = N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Type_Default_New_Business</fullName>
        <description>Updates the Opportunity type to New Business when this field is blank when the opportunity is created.</description>
        <field>Type</field>
        <literalValue>New Business</literalValue>
        <name>Opportunity Type Default &quot;New Business&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Opportunity_Closed_Won_Date</fullName>
        <description>Removes the date from the Date Stage Moved to Closed Won field.</description>
        <field>Date_Stage_is_Moved_to_Closed_Won__c</field>
        <name>Remove Opportunity Closed Won Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Anticipated Close Date within 5 Days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Emails the Opportunity Owner within 5 days of the Anticipated Close Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Date Moved to Closed Won</fullName>
        <actions>
            <name>Date_Opportunity_Stage_Moved_to_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>Date the Opportunity is moved to Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Farm VIP Email Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Owner_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Campaign_FARM_VIP_Indicator__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prospecting,Negotiating</value>
        </criteriaItems>
        <description>Email reminder to close FARM VIP opportunities if the close date is in the past.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Farm_VIP_Opportunity_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Farm_VIP_Opportunity_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity %7C%7C Removes date from Date Moved to Closed Won</fullName>
        <actions>
            <name>Remove_Opportunity_Closed_Won_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_Stage_is_Moved_to_Closed_Won__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If the Stage is not Closed Won, removes the date from the Date Moved to Closed Won,</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Lead Type Update</fullName>
        <actions>
            <name>Opportunity_Type_Default_New_Business</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Agronomy Opportunity,General Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Updates the Opportunity Type to &quot;New Business&quot; if this field is left blank when the opportunity is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Lifestage when Animal Type is Bee</fullName>
        <actions>
            <name>Lifestage_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Species__c</field>
            <operation>equals</operation>
            <value>Bee Colonies</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Life_Stage__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Lifestage when Animal Type is Bee</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
