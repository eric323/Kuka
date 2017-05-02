/*
 * @author Aruna Manyam, Apttus
 * @date November 15, 2016
 * @description Test class for APTSDMP_WrapperUtils
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-15  Newly created 
 */
@isTest
private class APTSDMP_WrapperUtilsTest {
	
	@isTest static void test_method_one() 
	{
		APTSDMP_WrapperUtils.SerializedWrapper cls = new APTSDMP_WrapperUtils.SerializedWrapper();
		cls.ProductName = 'Test Product';
		cls.CustomerName = 'Test Account';
		cls.Status = 'Status';
		cls.IntegrationStatus = 'Status';
		cls.IntegrationMessage = 'Message';
		cls.RoboAsset = 'a0w3E00000A2GPJ';
		cls.ControllerAsset = 'a0w3E00000A2GPJ';
		cls.ActivationDate = Date.today();
		cls.ExpirationDate = Date.today();
		
	}
	
}