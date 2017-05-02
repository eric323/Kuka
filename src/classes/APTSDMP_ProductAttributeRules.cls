/*
 * @author Aruna Manyam, Apttus
 * @date Nov 8, 2016
 * @description API for Product Attribute Rules
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-08  Newly created 
 */
public with sharing class APTSDMP_ProductAttributeRules {
public APTSDMP_ProductAttributeRules() {}
//To return Attribute rules and actions for the selected product.
public static APTSDMP_WrapperUtils.ProductAttributeRulesWrapper getProductAttributeRules(Id ProductId)
{
    APTSDMP_WrapperUtils.ProductAttributeRulesWrapper returnWrap = new APTSDMP_WrapperUtils.ProductAttributeRulesWrapper();
    List<APTSDMP_WrapperUtils.ProductAttributeRules> lstPdtRules = new List<APTSDMP_WrapperUtils.ProductAttributeRules>();
    try
    {
        if(ProductId!=null)
        {
	          for(Apttus_Config2__ProductAttributeRuleAction__c recPdtRule : [Select Id,Name,Apttus_Config2__ProductAttributeRuleId__c,Apttus_Config2__Action__c,Apttus_Config2__ActionCriteria__c,Apttus_Config2__Field__c,
	                                                    Apttus_Config2__ValueExpression__c,Apttus_Config2__ProductAttributeRuleId__r.Name,Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ConditionCriteria__c,
	                                                    Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__Active__c,Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ProductScope__c, 
	                                                    Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ConditionCriteriaExpression__c from Apttus_Config2__ProductAttributeRuleAction__c Where 
	                                                    (Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ProductScope__c =:ProductId OR Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ProductScope__c INCLUDES(:ProductId)) 
	                                                    and Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__Active__c=:true])
	                                                   
	          {
	              APTSDMP_WrapperUtils.ProductAttributeRules pdtRules = new APTSDMP_WrapperUtils.ProductAttributeRules();
	              pdtRules.RuleName = recPdtRule.Apttus_Config2__ProductAttributeRuleId__r.Name;
	              pdtRules.ConditionCriteria = recPdtRule.Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ConditionCriteria__c;
	              pdtRules.ConditionCriteraExp = recPdtRule.Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__ConditionCriteriaExpression__c;
	              pdtRules.isActive = recPdtRule.Apttus_Config2__ProductAttributeRuleId__r.Apttus_Config2__Active__c;
	              pdtRules.Action = recPdtRule.Apttus_Config2__Action__c;
	              pdtRules.ActionCriteria = recPdtRule.Apttus_Config2__ActionCriteria__c;
	              pdtRules.TargetField = recPdtRule.Apttus_Config2__Field__c;
	              pdtRules.ValueExp = recPdtRule.Apttus_Config2__ValueExpression__c;
	              lstPdtRules.add(pdtRules);
	          }
	          system.debug('lstPdtRules===='+lstPdtRules); 
	          if(!lstPdtRules.isEmpty())
	          {
	              returnWrap.IsSuccess = true;
	              returnWrap.errorMessage = '' ;
	              returnWrap.lstPdtRules = lstPdtRules;
	              return returnWrap;
	          }
	          else
	          {
	              returnWrap.IsSuccess = false;
	              returnWrap.errorMessage = 'Rules/Actions are not defined for the product' ;
	              return returnWrap;
	          }
        }
        else
        {
        	returnWrap.IsSuccess = false;
	        returnWrap.errorMessage = 'Product is needed' ;
	        return returnWrap;
        }
    }
    Catch(Exception ex)
    {
        returnWrap.isSuccess = false;
        returnWrap.errorMessage = ex.getMessage();
        return returnWrap;
    }
}
}