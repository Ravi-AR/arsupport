<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Distributor_Alert_Cooked_Tubs_Turned_Red_All</fullName>
        <description>Distributor Alert Cooked Tubs || Turned Red (All)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Area_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Brian_Gier</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Dealer_Business_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Dealer_Business_Specialist</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Distribution_Alerts_Cooked_Tubs</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Inside_Sales_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Inside_Sales_Users</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Regional_Directors</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Specialists_Tech_Sales_Spec</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>rlthode@landolakes.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Distribution_Alerts_Cooked_Tubs/Cattle_Cooked_Tubs_Distribution_Alert_When_Red_ASM</template>
    </alerts>
    <alerts>
        <fullName>Distributor_Alert_Cooked_Tubs_Turned_Yellow_or_Green</fullName>
        <description>Distributor Alert Cooked Tubs || Turned Yellow or Green</description>
        <protected>false</protected>
        <recipients>
            <recipient>Area_Sales_Managers</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Brian_Gier</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Dealer_Business_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Dealer_Business_Specialist</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Distribution_Alerts_Cooked_Tubs</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Inside_Sales_Manager</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Inside_Sales_Users</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Regional_Directors</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales_Specialists_Tech_Sales_Spec</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>rlthode@landolakes.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Distribution_Alerts_Cooked_Tubs/Cattle_Cooked_Tubs_Distribution_Alert_When_Yellow_or_Green</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Previous_Value</fullName>
        <field>Previous_Status_Description__c</field>
        <formula>text(PRIORVALUE(Status_Description__c ))</formula>
        <name>Update Previous Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Distribution Alert Field Updates</fullName>
        <actions>
            <name>Update_Previous_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Distribution_Alert__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Cooked Tubs</value>
        </criteriaItems>
        <description>Distribution Alert Field Updates</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
