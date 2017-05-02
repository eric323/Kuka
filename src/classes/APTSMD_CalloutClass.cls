public class APTSMD_CalloutClass {
	 public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/foo/bar');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
	
        res.setBody('<?xml version="1.0"?>' + 
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' + 
    '<soap:Header>' + 
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" soap:mustUnderstand="1">' + 
            '<u:Timestamp u:Id="_0">' + 
                '<u:Created>yyyy-MM-dd\'T\'hh:mm:ss\'Z\'</u:Created>' + 
                '<u:Expires></u:Expires>' + 
            '</u:Timestamp>' + 
            '<wsse:UsernameToken u:Id="123">' + 
                '<wsse:Username>test</wsse:Username>' + 
                '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">csKey</wsse:Password>' +
           '</wsse:UsernameToken>' + 
        '</wsse:Security>' + 
    '</soap:Header>' + 
    '<soap:Body xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' + 
        '<replyMessage xmlns="urn:schemas-cybersource-com:transaction-data-1.58">' + 
                    '<decision xmlns="urn:schemas-cybersource-com:transaction-data-1.58">decision = test</decision>' +
                    '<reasonCode xmlns="urn:schemas-cybersource-com:transaction-data-1.58"> reasonCode = reason </reasonCode> ' +
            '<merchantID>csMechantID</merchantID>' + 
            '<merchantReferenceCode>refCode</merchantReferenceCode>' + 
            '<clientLibrary>SFDC_APEX</clientLibrary>' + 
            '<billTo>' + 
                '<firstName>name</firstName>' + 
                '<lastName>lastname</lastName>' + 
                '<street1>street</street1>' + 
                '<city>city</city>' + 
                '<state>state</state>' + 
                '<postalCode>postalcode</postalCode>' + 
                '<country>country</country>' + 
                '<phoneNumber>phone</phoneNumber>' + 
                '<email>mail</email>' + 
                '<ipAddress>ipadress</ipAddress>' +
            '</billTo>' + 
            '<purchaseTotals>' + 
                '<currency>currenct</currency>' + 
                '<grandTotalAmount>total</grandTotalAmount>' + 
            '</purchaseTotals>' + 
            '<card>' + 
                '<accountNumber>accoutn</accountNumber>' + 
                '<expirationMonth>expirnumb</expirationMonth>' + 
                '<expirationYear>expirationyear</expirationYear>' + 
                '<replyMessage xmlns="urn:schemas-cybersource-com:transaction-data-1.58">' + 
                    '<decision xmlns="urn:schemas-cybersource-com:transaction-data-1.58">test</decision>'+
                    '<reasonCode xmlns="urn:schemas-cybersource-com:transaction-data-1.58"> reasonCode = reason </reasonCode> ' +
                 '</replyMessage>' + 
            '</card>' + 

            '<ccAuthService run="true"/>' + 
            '<ccCaptureService run="money"/>' + 
        '</replyMessage>' + 
    '</soap:Body>' + 
'</soap:Envelope>');
         Dom.Document doc = new Dom.Document();
        doc.load(res.getBody());
         System.debug('DOC ELEMENT ROOT ###' + doc.getRootElement());
         Dom.XMLNode envelope = doc.getRootElement();
         Dom.XMLNode x = envelope.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
         Dom.XMLNode y = x.getChildElement('replyMessage', 'urn:schemas-cybersource-com:transaction-data-1.58');
         System.debug('X #### ' + y);
          Dom.XMLNode decision = y.getChildElement('decision','urn:schemas-cybersource-com:transaction-data-1.58');
         System.debug('DECIS ' + decision);
         Dom.XmlNode reason = decision.getChildElement('reasonCode','urn:schemas-cybersource-com:transaction-data-1.58');         
         System.debug(reason);
         return res;
    }
}