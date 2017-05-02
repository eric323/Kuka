@isTest
public class APTSMD_CreateCustomSettCtrlTest {
    static testMethod void test(){
          Account acc = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404',BillingStreet='1400 Fashion Island Blvd.',BillingCity='San Mateo',BillingState='California',
                        BillingCountry='USA',BillingPostalCode='94404');
        insert acc;
        Test.startTest();
        APTSMD_CreateCustomSettingsController ctrl = new APTSMD_CreateCustomSettingsController();
        ctrl.createAllCustomSettings();
        
        Test.stopTest();
    }
}