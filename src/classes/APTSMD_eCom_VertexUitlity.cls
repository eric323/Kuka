public without sharing  class APTSMD_eCom_VertexUitlity
{
    public static Integer HTTP_OK_STATUS_CODE = 200;

    //Vertex Settings: from Custom Settings
    public static String VERTEX_USERNAME;
    public static String VERTEX_PASSWORD;
    public static String VERTEX_END_POINT_URL;
    public static String VERTEX_SELLER_CODE;
    public static String VERTEX_SELLER_DIVISION;
    public static String VERTEX_SELLER_DEPT;

    //Modified By Nikhil Sana to get the current date and append it to documentDate
    Date todaysdate = system.today();
    
    public APTSMD_eCom_VertexUitlity()
    {
        VERTEX_USERNAME = APTSMD_VertexSetting__c.getOrgDefaults().APTSMD_User_Name__c;
        VERTEX_PASSWORD = APTSMD_VertexSetting__c.getOrgDefaults().APTSMD_Password__c;
        VERTEX_END_POINT_URL = APTSMD_VertexSetting__c.getOrgDefaults().APTSMD_End_Point__c;      
        VERTEX_SELLER_CODE = APTSMD_VertexSetting__c.getOrgDefaults().APTSMD_Seller_Code__c;
        VERTEX_SELLER_DIVISION = APTSMD_VertexSetting__c.getOrgDefaults().APTSMD_Seller_Division__c;
        VERTEX_SELLER_DEPT = APTSMD_VertexSetting__c.getOrgDefaults().APTSMD_Seller_Dept__c;
    }
    
    public String doVertexCallout(APTSMD_eCom_VertexDetails vDetails)
    {
        String res = '';
           String request = buildSOAPRequestForVertex(vDetails); 
        	System.debug('REQUEST ### ' + request);
           HttpResponse response = sendRequest(request);
           
           System.debug(response);
           
           if(response == null) {
                res = '{"success":false,"error":true,"message":"Exception trying to call Vertex Web Service"}';
            }
            else{
                res = parseResponse(response);
            } 
              
            
        return res;
    }
    
//Sends the WebService Requrst to CyberSource and returns the response.
    public HTTPResponse sendRequest(String soapRequest) { 

         HTTPResponse res;
         HttpRequest req = new HttpRequest(); 
 
        //Set HTTPRequest Method
        req.setMethod('POST');

        System.debug('soapRequest :'+soapRequest); 

        //Set HTTPRequest header properties
        req.setHeader('content-type','text/xml;charset=UTF-8');
        req.setEndpoint(VERTEX_END_POINT_URL);

        //Set the HTTPRequest body    
        req.setBody(soapRequest);   

        Http http = new Http();
  
        try {
            //Execute web service call here     
            res = http.send(req); 
            System.debug(res.getBody());  
        } catch(System.CalloutException e) {
            //Exception handling goes here....
             System.debug('Vertex Web Servvice Callout Exception');
             System.debug(e);
        }
        return res;
    }    
    
    //parse the soap response and return a JSON result.
    public String parseResponse(HTTPResponse resp) {

        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String vertexNS = 'urn:vertexinc:o-series:tps:5:0';
        Dom.Document doc = new Dom.Document();
        doc.load(resp.getBody());

        //Retrieve the root element for this document.
        Dom.XMLNode envelope = doc.getRootElement();
        Dom.XMLNode bodyElement= envelope.getChildElement('Body',soapNS);
        
        if(resp.getStatusCode() == HTTP_OK_STATUS_CODE) {
            Dom.XMLNode vertexEnvelopeElement= bodyElement.getChildElement('VertexEnvelope',vertexNS);
            if(vertexEnvelopeElement!= null)
            {
                Dom.XMLNode responseElement= vertexEnvelopeElement.getChildElement('QuotationResponse',vertexNS);
                //System.debug(responseElement);
                String taxElement= responseElement.getChildElement('TotalTax',vertexNS).getText();
                System.debug(taxElement);
                return '{"success":true,"error":false,"message":"","TaxAmt":"'+taxElement+'"}';         
            }    
            else
            {
                String soapFault = bodyElement.getChildElement('Fault',soapNS).getChildElement('faultstring',null).getText();
                return '{"success":false,"error":true,"message":"Error Calling Vertex Web Service-' + soapFault + '"}' ;          
            }
        }
        else
        {
            String soapFault = bodyElement.getChildElement('Fault',soapNS).getChildElement('faultstring',null).getText();
            soapFault  = soapFault.replace('\n', ' ').replace('\\n', ' ').replace('\r\n', ' ').replace('\\r\\n', ' ');
            return '{"success":false,"error":true,"message":"Error Calling Vertex Web Service-' + soapFault + '"}' ;
        }           
    }    
    
    public String buildSOAPRequestForVertex(APTSMD_eCom_VertexDetails vDetails)
    {
        
              
        //Modified by Nikhil Sana on 10/15/2014   
        //Prepare product elements
        Integer count = 0;
        String products = '';
        String documentDate = '';

        documentDate = Datetime.now().format('yyyy-MM-dd');    
        for(APTSMD_productDetailsForTaxCalc prdDet:vDetails.lst_Prods)
        {   count++;
            products += '<urn:LineItem lineItemNumber="' + count + '">' +
                            '<urn:Product productClass="' + prdDet.ProductCode + '">' + prdDet.ProductCode + '</urn:Product>' +
                            '<urn:Quantity>' + prdDet.Quantity + '</urn:Quantity>' +
                            '<urn:UnitPrice>' + prdDet.UnitPrice + '</urn:UnitPrice>' +
                        '</urn:LineItem>';  
        }       
        return  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:vertexinc:o-series:tps:5:0">' +
            '<soapenv:Body>' +                       
                '<urn:VertexEnvelope>' +
                    '<urn:Login>' +
                        '<urn:UserName>' + VERTEX_USERNAME + '</urn:UserName>'+
                        '<urn:Password>' + VERTEX_PASSWORD + '</urn:Password>'+
                    '</urn:Login>' +
                    '<urn:QuotationRequest returnAssistedParametersIndicator="true" transactionType="SALE" documentDate="' + documentDate + '">' +
                        '<urn:Seller>' +
                            '<urn:Company>' + VERTEX_SELLER_CODE + '</urn:Company>' +
                            '<urn:Division>' + VERTEX_SELLER_DIVISION + '</urn:Division>' +
                            '<urn:Department>' + VERTEX_SELLER_DEPT + '</urn:Department>' +
                        '</urn:Seller>' +
                        '<urn:Customer>' +
                            '<urn:CustomerCode classCode="' + vDetails.destination_customerCode + '"/>' +                            
                            '<urn:Destination>' +
                                '<urn:StreetAddress>' + vDetails.destination_streetAddress + '</urn:StreetAddress>' +
                                '<urn:City>' + vDetails.destination_City + '</urn:City>' +
                                '<urn:MainDivision>' + vDetails.destination_mainDiv + '</urn:MainDivision>' +
                                '<urn:SubDivision>' + vDetails.destination_subDiv + '</urn:SubDivision>' +
                                '<urn:PostalCode>'+ vDetails.destination_postalcode +'</urn:PostalCode>' +
                                '<urn:Country>' + vDetails.destination_country + '</urn:Country>' +
                            '</urn:Destination>' +
                        '</urn:Customer>' +
                        products +
                        '</urn:QuotationRequest>' +
                    '</urn:VertexEnvelope>' +
                '</soapenv:Body>' +
            '</soapenv:Envelope>';
        
    }
    
    /** fault response **/
    /** <?xml version="1.0" ?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><nsf:Fault xmlns:nsf="http://schemas.xmlsoap.org/soap/envelope/"><faultcode>nsf:Client</faultcode><faultstring>User login failed: invalid_login.
        </faultstring><detail><ns:VertexException xmlns:ns="urn:vertexinc:oseries:exception:1:0"><ns:exceptionType>VertexApplicationException</ns:exceptionType><ns:rootCause>User login failed: invalid_login.
        </ns:rootCause></ns:VertexException></detail></nsf:Fault></S:Body></S:Envelope>
    **/
    /** success resposne **/
    /** <?xml version="1.0" ?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><VertexEnvelope xmlns="urn:vertexinc:o-series:tps:5:0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Login><UserName>ecomsrv</UserName>
<Password>eCom729@neo</Password>
</Login>
<QuotationResponse documentDate="2014-10-13" transactionType="SALE"><Customer><Destination taxAreaId="390290000"><PostalCode>19312</PostalCode>
</Destination>
</Customer>
<SubTotal>1000.0</SubTotal>
<Total>1060.0</Total>
<TotalTax>60.0</TotalTax>
<LineItem lineItemNumber="1"><Quantity>1.0</Quantity>
<FairMarketValue>1000.0</FairMarketValue>
<ExtendedPrice>1000.0</ExtendedPrice>
<Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION"><Jurisdiction jurisdictionLevel="STATE" jurisdictionId="31152">PENNSYLVANIA</Jurisdiction>
<CalculatedTax>60.0</CalculatedTax>
<EffectiveRate>0.06</EffectiveRate>
<Taxable>1000.0</Taxable>
<Imposition impositionType="General Sales and Use Tax">Sales and Use Tax</Imposition>
<TaxRuleId>17423</TaxRuleId>
</Taxes>
<TotalTax>60.0</TotalTax>
</LineItem>
</QuotationResponse>
</VertexEnvelope></S:Body></S:Envelope>
**/


}