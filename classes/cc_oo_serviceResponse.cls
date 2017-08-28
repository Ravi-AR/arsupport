//ClassName:cc_oo_serviceResponse 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shrivaths Kulkarni                         12/13/2016                                      OO-324 - Real-Time Price from JDE

//-----------------------------------------------------------------------------------------------------------------------
public class cc_oo_serviceResponse{
    
    /**
    * @description errorMsg to hold the value error message HTTP/exception message
    */
    public string errorMsg{get;set;}

    /**
    * @description responseStatus to hold status of response
    */
    public integer responseStatus{get;set;}

    /**
    * @description respons is to hold the response from HTTPResponse
    */
    public HTTPResponse response{get;set;}
    
}