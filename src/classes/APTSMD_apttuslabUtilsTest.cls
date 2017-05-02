@isTest
public class APTSMD_apttuslabUtilsTest {
    static testMethod void testCardType(){
        String[] strCardTypes = new List<String> { 'MASTERCARD', 'VISA', 'AMEX', 'DISCOVER', 'nothing'};
        String[] strOutputs = new List<String> { '002', '001', '003', '004', ''};
        
        APTSMD_apttuslabUtils utils = new APTSMD_apttuslabUtils();
        
        for(Integer i = 0; i < 5; i++){
            string strCurrent = strCardTypes[i];
            string strResult = strOutputs[i];
            string strCardResult = utils.cardType(strCurrent);
        	
        	System.assertEquals(strResult, strCardResult);
        }

    } 
    
    static testMethod void testProccessCCReq(){
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        
        APTSMD_CyberSourceSettings__c x = new APTSMD_CyberSourceSettings__c(name = 'CS_MERCHANT_ID', APTSMD_Value__c = 'infodev');
        insert x;
        APTSMD_CyberSourceSettings__c y = new APTSMD_CyberSourceSettings__c(name = 'CS_CC_ACCEPT', APTSMD_Value__c = 'test');
        insert y;
        APTSMD_CyberSourceSettings__c z = new APTSMD_CyberSourceSettings__c(name = 'CS_END_POINT_URL', APTSMD_Value__c = 'http://api.salesforce.com/foo/bar');
        insert z;
        
        APTSMD_apttuslabUtils utils = new APTSMD_apttuslabUtils();
        APTSMD_CyberSource_CC_AuthRequest authReq = new APTSMD_CyberSource_CC_AuthRequest();
		authReq.firstName = 'test';
        authReq.lastName = 'test2';
        authReq.street1 = 'street1';
        authReq.city = 'city';
        authReq.state = 'test state';
        authReq.postalCode= 'test code';
        authReq.country = 'test country';
		authReq.email = 'test@email.cs';
        authReq.cardtype = 'VISA';
        authReq.creditCardType = 'VISA';
        authReq.accountNumber = '123';
        System.assertNotEquals(null, authReq);
        
        
        
       	string output = utils.processCCAuthRequest(authReq, true);
        
        //System.assertNotEquals(null, output);
    }
    
    /*
    static testMethod void testParseResponse(){
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        HttpResponse res = APTSMD_CalloutClass.getInfoFromExternalService();
        
        APTSMD_apttuslabUtils utils = new APTSMD_apttuslabUtils();
        
        System.assertNotEquals(null, utils.parseResponse(res));
    }
	*/
    
    static testMethod void test(){
        
         //init
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        
        HttpResponse res = APTSMD_CalloutClass.getInfoFromExternalService();
        
        APTSMD_apttuslabUtils utils = new APTSMD_apttuslabUtils();
        
        utils.parseResponse(res);
        
        APTSMD_apttuslabUtils.displayPageMessage(ApexPages.Severity.CONFIRM, 'testMssg', false);
        
        APTSMD_apttuslabUtils.displayDebugMessage('key', res);
    }
    
    
    
    
    
    
    
    
    
    
    
    
}