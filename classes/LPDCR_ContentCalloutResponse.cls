/******************************************************************************
 * Parent custom class to hold common elements used by the CMS callout responses
 * 
 * @Author: Magnet 360
 * @Date: Mar 23, 2017 
 * @Jira: LPDCR-2230
 */

public virtual class 
LPDCR_ContentCalloutResponse 
{
    public Boolean success { get; set; }
    public Exception ex { get; set; }
    
/******************************************************************************
 * Inner custom exception class to handle exceptions when parsing the JSON response
 */
    public class
    LPDCR_ParsingException
         extends Exception
    {
        public Exception ex { get; set; }
        public String obj_name { get; set; }
        public String json { get; set; }
        
        public
        LPDCR_ParsingException( String a_obj_name, String a_json, Exception a_ex )
        {
            obj_name = a_obj_name;
            json = a_json; 
            ex = a_ex;
        }
    }

} // /END Class