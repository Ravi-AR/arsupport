/* *************************************************************************
* Class: MockHttpResponseGenerator
* dateCreated : 10/1/2015
*
* Purpose/Methods:
* - It creates fake response that is used in test classes for HTTP calls.
************************************************************************* */

@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals(system.label.DigigrapghEndPoint+'events/created', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}