//Class contains all common utlity methods
public without sharing class APTSMD_apttuslabUtils
{
    //Global variables
    public static final String strDelimiter = ' : ';
    public static void displayDebugMessage(String strKey,Object objDisplayMessage)
    {
        system.debug(strKey + strDelimiter + objDisplayMessage);
    }

    public static void displayPageMessage(ApexPages.Severity severity,String strMessage,boolean bExit)
    {
        ApexPages.addMessage(new ApexPages.Message(severity,strMessage));
        if(bExit) return;
    }

    public String processCCAuthRequest(APTSMD_CyberSource_CC_AuthRequest authRequest, Boolean capturePayment) { 
        APTSMD_CyberSourceUtility paymentUtil = new APTSMD_CyberSourceUtility();
        system.debug('authRequest == '+authRequest);
        authRequest.currencyType = 'USD';
        authRequest.country = authRequest.country == null ? 'US' : authRequest.country;
        
        if(authRequest.phoneNumber == null) authRequest.phoneNumber = '';
        authRequest.cardtype = cardType(authRequest.creditCardType);
        String requestXML = paymentUtil.buildSOAPRequestForCCAuth(authRequest,capturePayment);
        system.debug('requestXML :'+requestXML);
        HTTPResponse res = paymentUtil.sendRequest(requestXML);
        system.debug('res :'+res);
        if(res == null) {
            return '{"success":false,"error":true,"message":"Exception trying to callout CyberSource Web Service"}';
        }
        else {
            return parseResponse(res);
        }   
        }

    public string cardType(String strCardType)
    {
        if(strCardType == 'VISA')
            return '001';
        else if(strCardType == 'MASTERCARD')
            return '002';
        else if(strCardType == 'AMEX')
            return '003';
        else if(strCardType == 'DISCOVER')
            return '004';
        else
            return '';

    }
        
        //parse the soap response and return a JSON result.
        public String parseResponse(HTTPResponse res) 
        {
    
            String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
            String cyberSourceNS = 'urn:schemas-cybersource-com:transaction-data-1.58';
            System.debug(res.getBody());
            Dom.Document doc = new Dom.Document();
            doc.load(res.getBody());
    
            //Retrieve the root element for this document.
            Dom.XMLNode envelope = doc.getRootElement();
            Dom.XMLNode bodyElement= envelope.getChildElement('Body',soapNS);
        
            if(res.getStatusCode() == APTSMD_CyberSourceUtility.HTTP_OK_STATUS_CODE) {
                Dom.XMLNode replyMessageNode = bodyElement.getChildElement('replyMessage',cyberSourceNS);
                String decision = replyMessageNode.getChildElement('decision',cyberSourceNS).getText();
                //utils.log('replyMessageNode: '+ replyMessageNode);
                //utils.log('decision: ' + decision);
                if(decision == APTSMD_CyberSourceUtility.CS_CC_ACCEPT) {
                    System.debug(replyMessageNode.getChildElement('ccAuthReply',cyberSourceNS).getChildElement('authorizationCode',cyberSourceNS).getText());
                    String authCode = replyMessageNode.getChildElement('ccAuthReply',cyberSourceNS).getChildElement('authorizationCode',cyberSourceNS).getText();// authorization code
                    return '{"success":true,"error":false,"message":"Credit Card Authorized","authorizationCode":"'+authCode+'"}';
                }
                else {
                    String reasonCode = replyMessageNode.getChildElement('reasonCode',cyberSourceNS).getText();
                    return '{"success":false,"error":false,"message":"Credit Card Declined. Reason Code-' + reasonCode + '"}' ;
                }
            }
            else {
                String soapFault = bodyElement.getChildElement('Fault',soapNS).getChildElement('faultstring',null).getText();
                return '{"success":false,"error":true,"message":"Error Calling CyberSource Web Service-' + soapFault + '"}' ;
            }
        }
}