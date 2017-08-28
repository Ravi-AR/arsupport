<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Consumer_Open_SR_Reminder</fullName>
        <description>Consumer Open SR Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>feedgreatness@purinamills.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consumer_Group_Templates/Consumer_Open_SR_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Consumer_SR_Auto_Closed</fullName>
        <description>Consumer SR Auto Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>feedgreatness@purinamills.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Consumer_Group_Templates/Consumer_SR_Auto_Closed</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Approved</fullName>
        <description>Credit Amount Approved</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Approved_Transportation</fullName>
        <description>Credit Amount Approved Transportation</description>
        <protected>false</protected>
        <recipients>
            <field>Sr_Transportation_Manager__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Transportation_Director__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Over_10000_Approved</fullName>
        <description>Credit Amount Over $10,000 Approved</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manufacturing_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Over_10000_Approved</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Over_10000_Rejected</fullName>
        <description>Credit Amount Over $10,000 Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manufacturing_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Over_10000_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Over_5000_Approved</fullName>
        <description>Credit Amount Over $5,000 Approved</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manufacturing_Area_Plant_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Over_5000_Approved</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Over_5000_Rejected</fullName>
        <description>Credit Amount Over $5,000 Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manufacturing_Area_Plant_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Over_5000_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Over_5_000_Approved_Shipping_Plant_Area_Plant_Manager</fullName>
        <description>Credit Amount Over $5,000 Approved (Shipping Plant Area Plant Manager)</description>
        <protected>false</protected>
        <recipients>
            <field>Area_Regional_Customer_Ops_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Over_5000_Approved</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Over_5_000_Rejected_Shipping_Plant_Area_Manager</fullName>
        <description>Credit Amount Over $5,000 Rejected (Shipping Plant Area Manager)</description>
        <protected>false</protected>
        <recipients>
            <field>Area_Regional_Customer_Ops_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Over_5000_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Rejected</fullName>
        <description>Credit Amount Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Credit_Amount_Rejected_Transportation</fullName>
        <description>Credit Amount Rejected Transportation</description>
        <protected>false</protected>
        <recipients>
            <field>Sr_Transportation_Manager__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Transportation_Director__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Credit_Approval_Approved</fullName>
        <description>Credit Approval Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Credit_Approval_For_Income_Operations_Pricing_Manager</fullName>
        <description>Credit Approval For Income Operations Pricing Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Income_Operations_Pricing_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Income_Operations_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Credit_Approval_Request</fullName>
        <description>Credit Approval Request</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Request_with_Products</template>
    </alerts>
    <alerts>
        <fullName>Credit_Approval_Submitted_Transportation</fullName>
        <description>Credit Approval Submitted Transportation</description>
        <protected>false</protected>
        <recipients>
            <field>Sr_Transportation_Manager__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Transportation_Director__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Customer_Care_Service_Request_Closed</fullName>
        <description>Customer Care - Service Request Closed</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_SR_Auto_Response/Customer_Care_Service_Request_Closed</template>
    </alerts>
    <alerts>
        <fullName>Customer_Care_Service_Request_Created</fullName>
        <description>Customer Care - Service Request Created</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_SR_Auto_Response/Customer_Care_Phone_Fax_In_Person_Response</template>
    </alerts>
    <alerts>
        <fullName>Email_to_CCM</fullName>
        <description>Email to CCM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer_Ops_Customer_Care_Manager</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Inform_Senior_Transportation_Manager_of_Large_Credit_Approved</fullName>
        <description>Inform Senior Transportation Manager of Large Credit Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Sr_Transportation_Manager__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Large_Credit_Amount_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Inform_Senior_Transportation_Manager_of_Large_Credit_Submitted_for_Approval</fullName>
        <description>Inform Senior Transportation Manager of Large Credit Submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Sr_Transportation_Manager__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Large_Credit_Amount_Submitted_Products</template>
    </alerts>
    <alerts>
        <fullName>Inform_Transportation_Director_of_Large_Credit_Approved</fullName>
        <description>Inform Transportation Director of Large Credit Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Transportation_Director__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Large_Credit_Amount_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Inform_Transportation_Director_of_Large_Credit_Submitted_for_Approval</fullName>
        <description>Inform Transportation Director of Large Credit Submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Transportation_Director__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Large_Credit_Amount_Submitted_Products</template>
    </alerts>
    <alerts>
        <fullName>Liability_Service_Request_reassignment_to_Liability_Team</fullName>
        <description>Liability Service Request reassignment to Liability Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>Liability_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Email_Templates/New_Liability_Case_Urgent_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_Case_Alert</fullName>
        <description>New Case Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Management_Peer_Request__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_Case_Alert_Customer_Care</fullName>
        <description>New Case Alert - Customer Care</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Service_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Case_Notification_Customer_Support</template>
    </alerts>
    <alerts>
        <fullName>New_User_Request</fullName>
        <ccEmails>purinacrmsupport@landolakes.com</ccEmails>
        <description>New User Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>rlthode@landolakes.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>New_User_Request/New_User_Request</template>
    </alerts>
    <alerts>
        <fullName>Plant_Approved_Product_Return</fullName>
        <description>Plant Approved Product Return</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Product_Return_to_Plant_Approved</template>
    </alerts>
    <alerts>
        <fullName>Plant_Denied_Product_Return</fullName>
        <description>Plant Denied Product Return</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Product_Return_to_Plant_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Potential_Product_Liability_SR_No_to_Yes</fullName>
        <description>Potential Product Liability SR - No to Yes</description>
        <protected>false</protected>
        <recipients>
            <recipient>Liability_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>Customer_Ops_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manufacturing_Plant_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Manufacturing_Quality_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Plant_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Quality_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Email_Templates/No_to_Yes_Liability_Case_Urgent_Notification</template>
    </alerts>
    <alerts>
        <fullName>Requesting_Approval_to_Return_Product_to_Plant</fullName>
        <description>Requesting Approval to Return Product to Plant</description>
        <protected>false</protected>
        <recipients>
            <field>Warehouse_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Credit_Approval_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Income_Ops_Pricing_Manager</fullName>
        <description>Send Email to Income Ops Pricing Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations_Approval_Emails/Income_Operations_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_the_requestor_that_the_SFDC_New_User_Request_has_been_received</fullName>
        <description>Send an email to the case creator that the SFDC New User Request has been received.</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>purinacrmsupport@landolakes.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>New_User_Request/New_User_Request_Received</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clear_out_Alternate_Approver_Field</fullName>
        <field>Alternate_Approver__c</field>
        <name>Clear out Alternate Approver Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Farm_and_Ranch_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Farm_Ranch</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Farm and Ranch Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_User_Request_Subject_Update</fullName>
        <description>Updates the Subject with &quot;New User Request&quot;.</description>
        <field>Subject</field>
        <formula>&quot;New User Request&quot;</formula>
        <name>New User Request  &quot;Subject&quot; Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Request_Status_Approved</fullName>
        <description>Updates the Service Request status to Approved</description>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Service Request Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Request_Status_Rejected</fullName>
        <description>Sets the Status to Rejected</description>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Service Request Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Request_Status_Update</fullName>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>Service Request Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Request_Subject_Update</fullName>
        <field>Subject</field>
        <formula>TEXT(Type)</formula>
        <name>Service Request Subject Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Request_Waiting_for_Approval</fullName>
        <description>Service Request is Waiting for Approval</description>
        <field>Status</field>
        <literalValue>Waiting for Approval</literalValue>
        <name>Service Request Waiting for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSC_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>TSC</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>TSC Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Return_Approved_No</fullName>
        <description>Update return approved field for rga process to no</description>
        <field>Return_Approved__c</field>
        <literalValue>No</literalValue>
        <name>Update Return Approved No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Return_Approved_Pending</fullName>
        <description>Update the return approved field for the RGA process to pending</description>
        <field>Return_Approved__c</field>
        <literalValue>Pending</literalValue>
        <name>Update Return Approved_Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Return_Approved_Yes</fullName>
        <description>Update return approved field for the rga process to yes</description>
        <field>Return_Approved__c</field>
        <literalValue>Yes</literalValue>
        <name>Update Return Approved Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Farm and Ranch</fullName>
        <actions>
            <name>Farm_and_Ranch_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9 OR 10 OR 11 OR 12 OR 13 OR 14 OR 15 OR 16 OR 17 OR 18 OR 19 OR 20 OR 21 OR 22 OR 23)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Mass Channel/Farm &amp; Ranch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>536529</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>226552</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>540841</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>583999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>125253</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>245528</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>250684</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>413091</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>451878</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>457209</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>460186</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>469499</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>515889</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>523048</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>532142</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>538533</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>540409</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>540587</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>523048</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>549440</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>555431</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>565533</value>
        </criteriaItems>
        <description>Assigns Service Requests to Farm &amp; Ranch based on the Parent Account Number and if the Record Type is Mass Channel/Farm &amp; Ranch Account Number</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assign TSC</fullName>
        <actions>
            <name>TSC_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Mass Channel/Farm &amp; Ranch</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>318897</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Parent_Account_Number_Formula__c</field>
            <operation>equals</operation>
            <value>369070</value>
        </criteriaItems>
        <description>Assigns Service Requests to TSC based on the Parent Account Number and if the Record Type is Mass Channel/Farm &amp; Ranch Account Number</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Care - Notify Contact of Closed Service Request</fullName>
        <actions>
            <name>Customer_Care_Service_Request_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies Customer Care Contact of Closed Service Request</description>
        <formula>AND(  RecordType.Name = &apos;Customer Care&apos;,  ISPICKVAL(Status, &apos;Closed&apos;),  ContactId &lt;&gt; NULL,  Notify_Contact_of_Closed_Service_Request__c = TRUE,  OR(   ISPICKVAL(Origin, &apos;Phone&apos;),   ISPICKVAL(Origin, &apos;Fax&apos;),   ISPICKVAL(Origin, &apos;In Person&apos;)),  Owner:Queue.QueueName &lt;&gt; &apos;Out of Scope&apos;,  Customer_Ops_Plant_Type__c &lt;&gt; &apos;Out of Scope&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Care - Notify Contact of New Service Request</fullName>
        <actions>
            <name>Customer_Care_Service_Request_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies Customer Care Contact of new Service Request created for them</description>
        <formula>AND(  RecordType.Name = &apos;Customer Care&apos;,  ContactId &lt;&gt; NULL,  Notify_Contact_of_New_Service_Request__c = TRUE,  OR(   ISPICKVAL(Origin, &apos;Phone&apos;),   ISPICKVAL(Origin, &apos;Fax&apos;),   ISPICKVAL(Origin, &apos;In Person&apos;)),  Owner:Queue.QueueName &lt;&gt; &apos;Out of Scope&apos;,  Customer_Ops_Plant_Type__c &lt;&gt; &apos;Out of Scope&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New User Request</fullName>
        <actions>
            <name>New_User_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_User_Request_Subject_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>New User Request</value>
        </criteriaItems>
        <description>New User Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New User Request Received</fullName>
        <actions>
            <name>Send_an_email_to_the_requestor_that_the_SFDC_New_User_Request_has_been_received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>New User Request</value>
        </criteriaItems>
        <description>New User Request Received</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Potential Product Liability SR Email - No to Yes</fullName>
        <actions>
            <name>Potential_Product_Liability_SR_No_to_Yes</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When an SR has the Potential Liability field change from &quot;No&quot; to &quot;Yes. 
Kicks off email alert that notifies plant Quality Team of Potential Product Liability SR that concerns them.</description>
        <formula>AND( ISPICKVAL(PRIORVALUE (Potential_Product_Liability__c),&quot;No&quot;), ISPICKVAL(Potential_Product_Liability__c, &quot;Yes&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service Request - New Service Request Alert</fullName>
        <actions>
            <name>New_Case_Alert_Customer_Care</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Customer_Service_Issue__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Service Request</value>
        </criteriaItems>
        <description>An alert to either the Management/Peer or Customer Care Contact on a new case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Request Status Update</fullName>
        <actions>
            <name>Service_Request_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Service Request</value>
        </criteriaItems>
        <description>Change Status from New to Assigned upon case creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service Request Subject</fullName>
        <actions>
            <name>Service_Request_Subject_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Service Request</value>
        </criteriaItems>
        <description>Updates the Service Request Subject with Issue Type upon creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
