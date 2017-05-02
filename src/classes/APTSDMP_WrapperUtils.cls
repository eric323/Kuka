/*
 * @author Aruna Manyam, Apttus
 * @date Nov 1, 2016
 * @description Wrapper classe for newly created classes
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-01  Newly created 
 */
global class APTSDMP_WrapperUtils {
	global APTSDMP_WrapperUtils(){}
	//Get Serialized License Assets
    global class SerializedLicenseAssetsWrapper
    {
        //public string errorMessage;
       // public boolean IsSuccess;
        public List<SerializedWrapper> LicenseAssets;
    }
    global class SerializedWrapper
    {   
        public Id Id;
        public string ProductName;
        public string CustomerName;
        public string Status;
        public string IntegrationStatus;
        public string IntegrationMessage;
        public Id RoboAsset;
        public Id ControllerAsset;
        public Date ActivationDate;
        public Date ExpirationDate;


    } 
   public class ProductAttributeRulesWrapper
    {
        public List<ProductAttributeRules> lstPdtRules;
        public String errorMessage;
        public boolean isSuccess;
    }
    public class ProductAttributeRules
    {
        public String RuleName;
        public String ConditionCriteria;
        public String ConditionCriteraExp;
        public Boolean isActive;
        public String Action;
        public String ActionCriteria;
        //public String ActionName;
        public String TargetField;
        public String ValueExp;
        
    }
   
}