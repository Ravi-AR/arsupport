/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /******************************************************************************
 * Test class for LPDCR_CC_Products_Controller.cls 
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )

private class LPDCR_CC_Products_ControllerTest {

/******************************************************************************
 * Method to test the constructor with valid user and data 
 */
    static testMethod 
    void 
    test_Constructor_Valid() 
    {
		System.debug( 'START: LPDCR_CC_Products_ControllerTest.test_Constructor_Valid()' );

		User myTester = getTestUser();

		System.runAs(myTester) {
			LOLMyLinksCalloutsTest.loadMyLinksCalloutsDataMock();
			
	        Test.startTest();
	        
	        LPDCR_CC_Products_Controller l_controller = new LPDCR_CC_Products_Controller();
	        System.assert( l_controller != null );
	        
	        system.AssertEquals(true, l_controller.areProdManAvailable, 'Product Manuals should be available');
	        system.AssertEquals('https://productmanuals.lolportals.com/', l_controller.productManualData.myAppUrl, 'Invalid App URL');
	        system.AssertEquals('Purina Feed Manuals', l_controller.productManualData.app_title, 'Invalid App Title');
	
	        Test.stopTest();
		}
		
        System.debug( 'END: LPDCR_CC_Products_ControllerTest.test_Constructor_Valid()' );
    }

/******************************************************************************
 * Method to test the constructor with valid user and data 
 */
    static testMethod 
    void 
    test_Constructor_Invalid() 
    {
		System.debug( 'START: LPDCR_CC_Products_ControllerTest.test_Constructor_Invalid()' );
		
		User myTester = getTestUser();
		
		System.runAs(myTester) {
			// don't load any mock My Link data			
	        Test.startTest();
	        
	        LPDCR_CC_Products_Controller l_controller = new LPDCR_CC_Products_Controller();
	        System.Assert( l_controller != null );
	        
	        system.AssertEquals(false, l_controller.areProdManAvailable, 'Product Manuals should be available');
	
	        Test.stopTest();
		}
		
        System.debug( 'END: LPDCR_CC_Products_ControllerTest.test_Constructor_Invalid()' );
    }

	private static User getTestUser() {
	    
		List<User> myTesters = [SELECT email,FederationIdentifier,FirstName,Id,LastName,Username FROM User WHERE FederationIdentifier = 'sopper81' LIMIT 1 ];
		
		if (myTesters.size() == 0 ) {
			User myTester = new User();
			myTester = [SELECT email,FederationIdentifier,FirstName,Id,LastName,Username FROM User WHERE Profile_Current__c IN ('System Administrator', 'Dealer Community User') AND IsActive = true limit 1];
			myTester.Id = null;
			myTester.FirstName = 'Test';
			myTester.LastName = 'soppeland';
			myTester.email = myTester.email + '.test';
			myTester.Username = myTester.Username + '.test';
			myTester.FederationIdentifier = 'sopper81';
			insert myTester;
			myTesters.add( myTester );
		}
		
		return myTesters[ 0 ];
	}      
    
}