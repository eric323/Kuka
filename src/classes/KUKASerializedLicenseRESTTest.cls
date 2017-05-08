/*
 * @Description : Test class for KUKASerializedLicenseREST apex class
 *
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Arokia Joseph      2017-04-13   Initial Version  
 */
@isTest(seeAllData=true)
private class KUKASerializedLicenseRESTTest 
{
    private static Apttus_Config2__PriceList__c objPriceList;
    private static Account acc;
    private static Product2 pdt;
    private static Product2 pdt1;
    private static Apttus_Config2__Order__c objOrder;
    private static Apttus_Config2__OrderLineItem__c objOrderLine;
    private static Apttus_Config2__AssetLineItem__c objAsset;
    private static APTSDMP_Serialized_License_Asset__c objSLA;
    private static string strUrl;    
    private static User pu;
    
    @isTest static void init()
    {
        objPriceList = new Apttus_Config2__PriceList__c(Name ='DMP - EUR Price List');
        insert objPriceList;
        
        pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        /*
        acc = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404');
                        */
        acc = new Account(Name='Test Account12',ShippingStreet='1400 Fashion Island2 Blvd.1',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94424',BillingStreet='14002 Fashion Island Blvd.',BillingCity='San Mateo',BillingState='California',
                        BillingCountry='USA',BillingPostalCode='94424');                       
        insert acc;
        pdt= new Product2(Name='Test Xpert Product',IsActive= true,Family='Serialized License');
        insert pdt;
        pdt1= new Product2(Name='Test Xpert Product1',IsActive= true,Family='Serialized License');
        insert pdt1;
        objOrder = new Apttus_Config2__Order__c(Apttus_Config2__Type__c = 'New');
        insert objOrder;
        objOrderLine = new Apttus_Config2__OrderLineItem__c(Apttus_Config2__OrderId__c = objOrder.Id);
        insert objOrderLine;
        objAsset = new Apttus_Config2__AssetLineItem__c(Name='Test Assets',Apttus_Config2__ProductId__c = pdt.Id,
                                    Apttus_Config2__AccountId__c=acc.Id,Apttus_Config2__Quantity__c=5);
        insert objAsset;
        objSLA = new APTSDMP_Serialized_License_Asset__c(Contact__c= pu.ContactId,APTSDMP_Billing_Account__c=acc.Id,APTSDMP_Status__c='Active',APTSDMP_Original_Asset__c=objAsset.Id,APTSDMP_License_Product__c=pdt.Id);
        insert objSLA;
        strUrl= System.URL.getSalesforceBaseUrl().getHost();
        
    }
    static testMethod void myUnitTest()
    {
        init();
        
        Test.StartTest();
      
        String str = String.valueOf(pu.username);
       // system.debug('str===='+str);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://+strUrl+/services/apexrest/KUKASerializedLicenses/'+str+'';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
   
        KUKA_WrapperUtils.SerializedXpertLicenseWrapper responseHandlerObj = KUKASerializedLicenseREST.GET();  
        System.assertEquals(responseHandlerObj.Status, 'Success');
        Test.StopTest();
    }
    
      static testMethod void myUnitTest_Employee()
    {
        init();
        
        Test.StartTest();
      
        String str = String.valueOf(pu.username);
       // system.debug('str===='+str);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://+strUrl+/services/apexrest/KUKASerializedLicenses/'+str+'';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
   
        KUKA_WrapperUtils.SerializedXpertLicenseWrapper responseHandlerObj = KUKASerializedLicenseREST.GET();  
        System.assertEquals(responseHandlerObj.Status, 'Success');
        Test.StopTest();
    }
    
    
      static testMethod void myUnitTest_Invalid()
    {
        init();
        
        Test.StartTest();
      
        String str = String.valueOf(pu.username);
       // system.debug('str===='+str);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://+strUrl+/services/apexrest/KUKASerializedLicenses/test';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
   
        KUKA_WrapperUtils.SerializedXpertLicenseWrapper responseHandlerObj = KUKASerializedLicenseREST.GET();  
        System.assertEquals(responseHandlerObj.Status, 'Error');
        Test.StopTest();
    }
    
    
     static testMethod void myUnitTest_InvalidInput()
    {
         init();
        
        Test.StartTest();
      
        String str = String.valueOf(pu.username);
       // system.debug('str===='+str);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://+strUrl+/services/apexrest/KUKASerializedLicenses/';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
   
        KUKA_WrapperUtils.SerializedXpertLicenseWrapper responseHandlerObj = KUKASerializedLicenseREST.GET();  
        System.assertEquals(responseHandlerObj.Status, 'Error');
        Test.StopTest();
    }
    
    

    
 
    
    
}