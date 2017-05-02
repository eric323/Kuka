/*
 * @author Aruna Manyam, Apttus
 * @date November 4, 2016
 * @description Test class for  APTSDMP_CreateSerializedLicenseAssets
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-04  Newly created 
 *  Andreas Meyer        2016-11-23  add billing address for account creation
 */
@isTest
private class APTSDMP_SerializedAssetsTriggerTest 
{
    static testmethod void myUnitTest()
    {
        Test.StartTest();
        Apttus_Config2__PriceList__c objPriceList = new Apttus_Config2__PriceList__c(Name ='DMP - EUR Price List');
        insert objPriceList;
        Account acc = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404',BillingStreet='1400 Fashion Island Blvd.',BillingCity='San Mateo',BillingState='California',
                        BillingCountry='USA',BillingPostalCode='94404');
        insert acc;
        Product2 pdt= new Product2(Name='Test Product',IsActive= true,Family='Serialized License');
        insert pdt;
        Apttus_Config2__Order__c objOrder = new Apttus_Config2__Order__c(Apttus_Config2__Type__c = 'New');
        insert objOrder;
        Apttus_Config2__OrderLineItem__c objOrderLine = new Apttus_Config2__OrderLineItem__c(Apttus_Config2__OrderId__c = objOrder.Id);
        insert objOrderLine;
         Apttus_Config2__AssetLineItem__c objAsset = new Apttus_Config2__AssetLineItem__c(Name='Test Assets',Apttus_Config2__ProductId__c = pdt.Id,
                                    Apttus_Config2__AccountId__c=acc.Id,Apttus_Config2__Quantity__c=5);
        insert objAsset;
        APTSDMP_Serialized_License_Asset__c objSLA = new APTSDMP_Serialized_License_Asset__c(APTSDMP_Billing_Account__c=acc.Id,APTSDMP_Status__c='Active',
                                                            APTSDMP_Original_Asset__c=objAsset.Id,APTSDMP_License_Product__c=pdt.Id);
        insert objSLA;
        APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper wrap = new APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper();
        wrap =  APTSDMP_SerializedLicenseAssets.getSerializedAssets(acc.Id);
        Test.StopTest();
    }
}