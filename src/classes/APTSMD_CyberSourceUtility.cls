/*
 * This Class provides utility methods to Call out an exernal web service provided by CyberSource for Credit Card Authorization and such. 
 * Please refer to the CyberSource Documentation at: http://www.cybersource.com/developers/integration_methods/simple_order_and_soap_toolkit_api/
 * The CyberSource settings like end point URL etc. are defined in Salesforce Custom Settings named 'CyberSourceSettings'. 
 */

public class APTSMD_CyberSourceUtility  {

    public static Integer HTTP_OK_STATUS_CODE = 200;

    //CyberSource Settings: from Custom Settings
    public static String CS_MERCHANT_ID;
    public static String CS_CC_ACCEPT;
    public static String CS_END_POINT_URL;
    
    //CyberSource Key: from a Custom Label
    public static String CS_KEY = Label.APTSMD_CYBERSOURCE_KEY;
   
    public APTSMD_CyberSourceUtility() {
        
        CS_MERCHANT_ID = APTSMD_CyberSourceSettings__c.getInstance('CS_MERCHANT_ID').APTSMD_Value__c;
        CS_CC_ACCEPT = APTSMD_CyberSourceSettings__c.getInstance('CS_CC_ACCEPT').APTSMD_Value__c;
        CS_END_POINT_URL = APTSMD_CyberSourceSettings__c.getInstance('CS_END_POINT_URL').APTSMD_Value__c;
    }

    //Sends the CC Auth Service request to Cyber Source. The capture flag indicates weather to capture the payment along with auth.
    //Returns the parsed Webservice response.
    public String sendCCAuthRequest(APTSMD_CyberSource_CC_AuthRequest authRequest, Boolean capturePayment) { 

        String requestXML = buildSOAPRequestForCCAuth(authRequest,capturePayment);
        system.debug('requestXML == '+requestXML);
        HTTPResponse res = sendRequest(requestXML);
        system.debug('res == '+res);
        if(res == null) {
            return '{"result": {"success":false,"exception":true,"message":"Exception trying to callout CyberSource Web Service"}}';
        }
        else {
            return parseResponse(res);
        }   
     }

    //Sends the WebService Requrst to CyberSource and returns the response.
    public HTTPResponse sendRequest(String soapRequest) { 

         HTTPResponse res;
         HttpRequest req = new HttpRequest(); 
 
        //Set HTTPRequest Method
        req.setMethod('POST');

        System.debug('soapRequest :'+soapRequest); 

        //Set HTTPRequest header properties
        req.setHeader('content-type', 'application/xml');
        req.setEndpoint(CS_END_POINT_URL);

        //Set the HTTPRequest body    
        req.setBody(soapRequest);   

        Http http = new Http();
         system.debug('req == '+req);
  
        try {
            //Execute web service call here     
            res = http.send(req);  
            system.debug('res == '+res);
        } catch(System.CalloutException e) {
            //Exception handling goes here....
             System.debug('@@#@#@#@## Cyber Source Web Servvice Callout Exception');
             System.debug(e);
        }
        return res;
    }

     //parse the soap response and return a JSON result.
    public String parseResponse(HTTPResponse res) {

        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String cyberSourceNS = 'urn:schemas-cybersource-com:transaction-data-1.58';

        Dom.Document doc = new Dom.Document();
        doc.load(res.getBody());

        //Retrieve the root element for this document.
        Dom.XMLNode envelope = doc.getRootElement();
        Dom.XMLNode bodyElement= envelope.getChildElement('Body',soapNS);
    
        if(res.getStatusCode() == HTTP_OK_STATUS_CODE) {
            Dom.XMLNode replyMessageNode = bodyElement.getChildElement('replyMessage',cyberSourceNS);
            String decision = replyMessageNode.getChildElement('decision',cyberSourceNS).getText();
            system.debug('replyMessageNode: '+ replyMessageNode);
            system.debug('decision: ' + decision);
            if(decision == CS_CC_ACCEPT) {
                return '{"result": {"success":true,"exception":false,"message":"Credit Card Authorized"}}';
            }
            else {
                String reasonCode = replyMessageNode.getChildElement('reasonCode',cyberSourceNS).getText();
                return '{"result": {"success":false,"exception":false,"message":"Credit Card Declined. Reason Code-' + reasonCode + '"}}' ;
            }
        }
        else {
            String soapFault = bodyElement.getChildElement('Fault',soapNS).getChildElement('faultstring',null).getText();
            return '{"result": {"success":false,"exception":false,"message":"Error Calling CyberSource Web Service-"' + soapFault + '"}}' ;
        }
    }

    //builds the XML request for CyberSource CC Auth Service. The capture flag indicates weather to capture the payment along with auth.
    public String buildSOAPRequestForCCAuth(APTSMD_CyberSource_CC_AuthRequest authRequest,Boolean capturePayment) {

        Blob aes = Crypto.generateAesKey(128);
        String guid = EncodingUtil.convertToHex(aes);

        DateTime dt = system.now();
        TimeZone tz = UserInfo.getTimeZone();
        system.debug('TimeZone :'+tz);
        DateTime localTime = dt.AddSeconds(tz.getOffset(dt)/1000);

        return '<?xml version="1.0"?>' + 
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' + 
    '<soap:Header>' + 
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" soap:mustUnderstand="1">' + 
            '<u:Timestamp u:Id="_0">' + 
                '<u:Created>' + localTime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + '</u:Created>' + 
                '<u:Expires>' + localTime.addDays(2).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + '</u:Expires>' + 
            '</u:Timestamp>' + 
            '<wsse:UsernameToken u:Id="' + guid + '">' + 
                '<wsse:Username>' + CS_MERCHANT_ID + '</wsse:Username>' + 
                '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + CS_KEY + '</wsse:Password>' +
           '</wsse:UsernameToken>' + 
        '</wsse:Security>' + 
    '</soap:Header>' + 
    '<soap:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' + 
        '<requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-1.58">' + 
            '<merchantID>' + CS_MERCHANT_ID + '</merchantID>' + 
            '<merchantReferenceCode>' + authRequest.referenceCode + '</merchantReferenceCode>' + 
            '<clientLibrary>SFDC_APEX</clientLibrary>' + 
            '<billTo>' + 
                '<firstName>' + authRequest.firstName + '</firstName>' + 
                '<lastName>' + authRequest.lastName + '</lastName>' + 
                '<street1>' + authRequest.street1 + '</street1>' + 
                '<city>' + authRequest.city + '</city>' + 
                '<state>' + authRequest.state + '</state>' + 
                '<postalCode>' + authRequest.postalCode + '</postalCode>' + 
                '<country>' + authRequest.country + '</country>' + 
                '<phoneNumber>' + authRequest.phoneNumber + '</phoneNumber>' + 
                '<email>' + authRequest.email + '</email>' + 
                '<ipAddress>' + authRequest.ipAddress + '</ipAddress>' +
            '</billTo>' + 
            '<purchaseTotals>' + 
                '<currency>' + authRequest.currencyType + '</currency>' + 
                '<grandTotalAmount>' + authRequest.amount + '</grandTotalAmount>' + 
            '</purchaseTotals>' + 
            '<card>' + 
                '<accountNumber>' + authRequest.accountNumber + '</accountNumber>' + 
                '<expirationMonth>' + authRequest.expirationMonth + '</expirationMonth>' + 
                '<expirationYear>' + authRequest.expirationYear + '</expirationYear>' + 
                '<cardType>' + authRequest.cardtype + '</cardType>' + 
            '</card>' + 

            '<ccAuthService run="true"/>' + 
            '<ccCaptureService run="' + capturePayment + '"/>' + 
        '</requestMessage>' + 
    '</soap:Body>' + 
'</soap:Envelope>' ;

    }  
}