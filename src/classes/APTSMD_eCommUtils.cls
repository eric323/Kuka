public with sharing class APTSMD_eCommUtils {

	public static String getProductFields(){
    return 'Name, Family, ProductCode, Description, IsActive, APTSCU_Availability__c, '
            + 'Apttus_Config2__ConfigurationType__c, Apttus_Config2__HasOptions__c, Apttus_Config2__HasSearchAttributes__c, '
            + 'Apttus_Config2__Icon__c, Apttus_Config2__IconId__c, APTSMD_Long_Description__c, Apttus_Config2__Customizable__c, '
            + 'APTSMD_Number_of_1_Star__c, APTSMD_Number_of_2_Star__c, APTSMD_Number_of_3_Star__c, APTSMD_Number_of_4_Star__c, APTSMD_Number_of_5_Star__c, '
            + 'APTSMD_product_image_url__c, APTSMD_Rating__c';
	}


	public static String getPriceListItemFields(){
    return 'Apttus_Config2__Active__c, Apttus_Config2__Cost__c, Apttus_Config2__DefaultQuantity__c, Apttus_Config2__EffectiveDate__c, Apttus_Config2__Frequency__c, Apttus_Config2__ExpirationDate__c, Apttus_Config2__ListPrice__c, '
            + 'Apttus_Config2__MaxPrice__c, Apttus_Config2__MinPrice__c, Apttus_Config2__MinUsageQuantity__c, Apttus_Config2__MaxUsageQuantity__c, Apttus_Config2__PriceListId__c, Apttus_Config2__PriceMethod__c, '
            + 'Apttus_Config2__PriceType__c, Apttus_Config2__PriceUom__c, Apttus_Config2__ProductId__c, Apttus_Config2__ProductActive__c, Apttus_Config2__RelatedItemId__c, Apttus_Config2__SubType__c, '
            + 'Apttus_Config2__Taxable__c, Apttus_Config2__TaxCodeId__c, Apttus_Config2__TaxInclusive__c, Apttus_Config2__Type__c, Apttus_Config2__RollupPriceToBundle__c, Apttus_Config2__ContractPrice__c';
  }

	public static string productReferenceFields(){
    return APTSMD_eCommUtils.referenceFields('Apttus_Config2__ProductId__r');
  }

  public static String referenceFields(String prefix){
		List<String> res = new List<String>();
		for(String s : getProductFields().split(', ')){
			res.add(prefix + '.' + s);
		}
		return String.join(res, ', ');
  }
}