/*
 * @author Aruna Manyam, Apttus
 * @date Nov 9, 2016
 * @description Test class for APTSDMP_ProductAttributeRules
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-09  Newly created 
 *  Andreas Meyer        2016-11-23  add billing address for account creation
 */
@isTest
private class APTSDMP_ProductAttributeRulesTest {
    private static Apttus_Config2__PriceList__c objPriceList;
    private static Account acc;
    private static Product2 pdt;
    private static Product2 pdt1;
    private static Apttus_Config2__Order__c objOrder;
    private static Apttus_Config2__ProductAttributeRule__c pdtRule;
    private static Apttus_Config2__ProductAttributeRuleAction__c pdtAction;
    static
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
        pdtRule = new Apttus_Config2__ProductAttributeRule__c(Name='MaaS360 Per Device',
                            Apttus_Config2__ConditionCriteriaExpression__c='$.Apttus_Config2__AttributeValueId__r.MaaS360LicenseUnitType__c==Per Device',
                            Apttus_Config2__Active__c = true,Apttus_Config2__ProductScope__c=pdt.Id);
        insert pdtRule;
        pdtAction= new Apttus_Config2__ProductAttributeRuleAction__c(Apttus_Config2__Action__c='hidden',
            Apttus_Config2__ValueExpression__c='test',Apttus_Config2__ProductAttributeRuleId__c=pdtRule.Id);
        insert pdtAction;
    }
    @isTest static void test_method_one() 
    {
        
        Test.StartTest();
        APTSDMP_ProductAttributeRules rules = new APTSDMP_ProductAttributeRules();
        
        APTSDMP_WrapperUtils.ProductAttributeRulesWrapper  wrap = new APTSDMP_WrapperUtils.ProductAttributeRulesWrapper();
        wrap =  APTSDMP_ProductAttributeRules.getProductAttributeRules(pdt.Id);
        Test.StopTest();
    }
    
    @isTest static void test_method_two() {
        
        Test.StartTest();
            APTSDMP_WrapperUtils.ProductAttributeRulesWrapper  wrap = new APTSDMP_WrapperUtils.ProductAttributeRulesWrapper();
            wrap =  APTSDMP_ProductAttributeRules.getProductAttributeRules(pdt1.Id);
        Test.StopTest();
    }
    @isTest static void test_method_three() {
        
        Test.StartTest();
            APTSDMP_WrapperUtils.ProductAttributeRulesWrapper  wrap = new APTSDMP_WrapperUtils.ProductAttributeRulesWrapper();
            wrap =  APTSDMP_ProductAttributeRules.getProductAttributeRules(null);
        Test.StopTest();
    }
    
}