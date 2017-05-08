public with sharing class APTSMD_eCommController {
	public APTSMD_eCommController(APTSMD_ApttusLabAngularJS sc){

	}

	@RemoteAction
	public static Apttus_Config2__PriceListItem__c getProductWithPrice(String productId){
		  List<sObject> ret = Database.query('SELECT ' + APTSMD_eCommUtils.getPriceListItemFields() + ', ' + APTSMD_eCommUtils.productReferenceFields() + ' FROM Apttus_Config2__PriceListItem__c WHERE Apttus_Config2__ProductId__c = \'' + productId + '\'');
			return (Apttus_Config2__PriceListItem__c) ret.get(0);
	}

}