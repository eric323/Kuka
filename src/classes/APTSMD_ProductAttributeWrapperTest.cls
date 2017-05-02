@isTest
public class APTSMD_ProductAttributeWrapperTest {
    static testMethod void test(){
        Product2  testProduct = APTSMD_testUtils.getproduct();
        
        //Schema.getGlobalDescribe().get('Apttus_Config2__ProductAttributeGroup__c').getDescribe().fields.getMap().get('apttus_config2__businessobject__c').getDescribe().getLabel();
        APTSMD_ProductAttributeWrapper wrap = new APTSMD_ProductAttributeWrapper('apttus_config2__businessobject__c', 'Apttus_Config2__ProductAttributeGroup__c');
    }
}