/*
 * @author Aruna Manyam, Apttus
 * @date Nov 18, 2016
 * @description Class for APTSDMP_LineItemsComponent.component
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-18  Newly created 
 */
public class APTSDMP_GetLineItems {
	public APTSDMP_GetLineItems() {}
	public static Id oId {get;set;}
    public static List<Apttus_Config2__LineItem__c> getLineItems()
    {
        List<Apttus_Config2__LineItem__c> lineItems;
        lineItems = [SELECT Id,Apttus_Config2__Quantity__c, Apttus_Config2__BasePrice__c ,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Description,Apttus_Config2__Description__c, Apttus_Config2__ListPrice__c,Apttus_Config2__NetPrice__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c =: oId];
        //system.debug('lineItems===='+lineItems.size()); 
        return lineItems;
    }
}