global without sharing class cc_oo_MockHttpResponse implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;
    protected HttpResponse res;

    /*global cc_oo_MockHttpResponse(HttpResponse res) {
        this.res = res;
    }*/

    global cc_oo_MockHttpResponse(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    global HTTPResponse respond(HTTPRequest req) {
        if (res != null) {
            return res;
        } else {
            HttpResponse res = new HttpResponse();
            for (String key : this.responseHeaders.keySet()) {
                res.setHeader(key, this.responseHeaders.get(key));
            }
            res.setBody(this.body);
            res.setStatusCode(this.code);
            res.setStatus(this.status);
            return res;
        }

    }
}