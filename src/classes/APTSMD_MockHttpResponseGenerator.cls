global class APTSMD_MockHttpResponseGenerator implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       	req.setHeader('X-UA-Compatible', 'IE=Edge');
        req.setEndpoint('https://ecommdev-ecommmykuka.cs82.force.com/ecomm');
        System.assertEquals('GET', req.getMethod());     
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Host', 'https://apttuscommunity-14f1600abf5.force.com');
        res.setBody(' ');
        res.setStatusCode(200);
        return res;
    }
}