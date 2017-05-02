/*
 * @author Aruna Manyam, Apttus
 * @date November 4, 2016
 * @description Test class for APTSDMP_SerializedAssetsREST
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-04  Newly created 
 *  Andreas Meyer        2016-11-23  add billing address for account creation
 */
@isTest
private class APTSDMP_SerializedAssetsRESTTest 
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
    
    @isTest static void init()
    {
        objPriceList = new Apttus_Config2__PriceList__c(Name ='DMP - EUR Price List');
        insert objPriceList;
        /*
        acc = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404');
                        */
        acc = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404',BillingStreet='1400 Fashion Island Blvd.',BillingCity='San Mateo',BillingState='California',
                        BillingCountry='USA',BillingPostalCode='94404');                       
        insert acc;
        pdt= new Product2(Name='Test Product',IsActive= true,Family='Serialized License');
        insert pdt;
        pdt1= new Product2(Name='Test Product1',IsActive= true,Family='Serialized License');
        insert pdt1;
        objOrder = new Apttus_Config2__Order__c(Apttus_Config2__Type__c = 'New');
        insert objOrder;
        objOrderLine = new Apttus_Config2__OrderLineItem__c(Apttus_Config2__OrderId__c = objOrder.Id);
        insert objOrderLine;
        objAsset = new Apttus_Config2__AssetLineItem__c(Name='Test Assets',Apttus_Config2__ProductId__c = pdt.Id,
                                    Apttus_Config2__AccountId__c=acc.Id,Apttus_Config2__Quantity__c=5);
        insert objAsset;
        objSLA = new APTSDMP_Serialized_License_Asset__c(APTSDMP_Billing_Account__c=acc.Id,APTSDMP_Status__c='Active',APTSDMP_Original_Asset__c=objAsset.Id,APTSDMP_License_Product__c=pdt.Id);
        insert objSLA;
        strUrl= System.URL.getSalesforceBaseUrl().getHost();
        
    }
    static testMethod void myUnitTest()
    {
        init();
        
        Test.StartTest();
        String str = String.valueOf(acc.Id);
       // system.debug('str===='+str);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://+strUrl+/services/apexrest/APTSDMPSerailzedLicenseAssets/'+str+'';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper wrap = new APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper();
        wrap = APTSDMP_SerializedAssetsREST.getSerializedAssets();
        Test.StopTest();
    }
    static testMethod void myUnitTest1()
    {
        init();
        
        Test.StartTest();
       // String JsonMsg=JSON.serialize(slaObj);
       // system.debug('JsonMsg====='+JsonMsg);
        String JsonMsg= '{"LicenseAssets" : [{"Id" : "'+objSLA.Id+'","APTSDMP_Billing_Account__c" : "'+acc.Id+'","APTSDMP_Integration_Status__c" : "In Progress","APTSDMP_License_Product__c" : "'+pdt.Id+'", "APTSDMP_Original_Asset__c" : "'+objAsset.Id+'","APTSDMP_Status__c" : "Active" }]}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://+strUrl+/services/apexrest/APTSDMPSerailzedLicenseAssets/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        APTSDMP_SerializedAssetsREST.updateSetializedAssets();
        Test.StopTest();
    }
}