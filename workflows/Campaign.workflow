<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activate_Campaign_1_day_before_event</fullName>
        <description>Places a check in the Active check box one day before the date of the event.</description>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Activate Campaign 1 day before event.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Active_Status_is_True</fullName>
        <description>Changes the Campaign Active Status to True</description>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Campaign Active Status is True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Region</fullName>
        <description>Updates the Region field on the Customer Event to match the Sales Region of the Event Owner</description>
        <field>Region__c</field>
        <formula>TEXT(Owner.Sales_Region__c)</formula>
        <name>Campaign: Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Status_Registration_Closed</fullName>
        <description>Update the Campaign Status field to &quot;Registration Closed&quot;</description>
        <field>Status</field>
        <literalValue>Registration Closed</literalValue>
        <name>Campaign: Status &quot;Registration Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Status_to_Registration_Open</fullName>
        <description>Update the Campaign Status field to &quot;Registration Open&quot;</description>
        <field>Status</field>
        <literalValue>Registration Open</literalValue>
        <name>Campaign: Status to &quot;Registration Open&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Active_Checkbox</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>IsActive True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Digigraph_Active_False</fullName>
        <description>Update Digigraph Active Status to False</description>
        <field>Digigraph_Active__c</field>
        <literalValue>0</literalValue>
        <name>Digigraph Active False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Digigraph_Active_True</fullName>
        <description>Marks the Digigraph Active Status to True</description>
        <field>Digigraph_Active__c</field>
        <literalValue>1</literalValue>
        <name>Digigraph Active True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inactivate_Campaign</fullName>
        <description>Makes the campaign inactive on end date.</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Inactivate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsActive_False</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>IsActive False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Make_Campaign_Inactive_One_Day_After_End</fullName>
        <description>Make Campaign Inactive One Day After End End Date</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Make Campaign Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Campaign_Active</fullName>
        <description>Make the Campaign active two days before the event.</description>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Mark Campaign Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Campaign_Inactive</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Mark Campaign Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>One_Day_After_End_Date</fullName>
        <description>One day after end date, make campaign inactive,</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>One Day After End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X1_Day_After_End_Date</fullName>
        <description>One day after end date, make the Active Box false.</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>1 Day After End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Activate Event Immediately</fullName>
        <actions>
            <name>Check_Active_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Digigraph_Active_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Events,National/Regional Events</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>notEqual</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Date_of_Event_Indicator__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Sub_type__c</field>
            <operation>notEqual</operation>
            <value>Horse 60 Day Trial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Specie_Focus__c</field>
            <operation>notEqual</operation>
            <value>Pet</value>
        </criteriaItems>
        <description>If the start date of the local event of the local event is today, activate event immediately.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign%3A Local Customer Event Region</fullName>
        <actions>
            <name>Campaign_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Events</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Type</field>
            <operation>equals</operation>
            <value>Local</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Campaign Status</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Events,National/Regional Events</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Completed,Planned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Sub_type__c</field>
            <operation>notEqual</operation>
            <value>Horse 60 Day Trial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Specie_Focus__c</field>
            <operation>notEqual</operation>
            <value>Pet</value>
        </criteriaItems>
        <description>Changes the Campaign Status to active two days before the start date and two dates after the end date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Check_Active_Checkbox</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Digigraph_Active_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Date_of_Event__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Digigraph_Active_False</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>IsActive_False</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deactivate Campaign Immediately</fullName>
        <actions>
            <name>Digigraph_Active_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IsActive_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 or 3 or 4 or 5)</booleanFilter>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Events,National/Regional Events</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Date_of_Event_Indicator__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Sub_type__c</field>
            <operation>equals</operation>
            <value>Horse 60 Day Trial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Specie_Focus__c</field>
            <operation>equals</operation>
            <value>Pet</value>
        </criteriaItems>
        <description>Deactivate Local and Regional Campaigns if the Status is Active</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Farm VIP%3A Registration Closed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Farm VIP Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Registration Open</value>
        </criteriaItems>
        <description>Updates the status of the Farm VIP Event to &quot;Registration Closed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Campaign_Status_Registration_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Date_of_Event__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Farm VIP%3A Registration Open</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Farm VIP Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Planned</value>
        </criteriaItems>
        <description>Sets the Farm VIP Event to &quot;Registration Open&quot; status on the date that Registration Opens</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Campaign_Status_to_Registration_Open</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Registration_Opens__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
