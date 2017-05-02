/*
 * @author Aruna Manyam, Apttus
 * @date Nov 1, 2016
 * @description Rest API for SerailzedLicenseAssets GetMethod
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Aruna Manyam         2016-11-01  Newly created 
 */
@RestResource(urlMapping='/APTSDMPSerailzedLicenseAssets/*')
global with sharing class APTSDMP_SerializedAssetsREST {
	@HttpGet
	global static APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper getSerializedAssets() 
   	{
   		RestRequest req = RestContext.request; 
   		//system.debug('req==='+req.requestURI);      
        String AcctId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('AcctId==='+AcctId);
        return APTSDMP_SerializedLicenseAssets.getSerializedAssets(AcctId);
        
    }
    @HttpPost
    global static void updateSetializedAssets()
	{
		 RestRequest req = RestContext.request; 
		 String jsonData =    req.requestBody != null ? req.requestBody.toString() : '';
		 system.debug('jsonData==='+jsonData);
		 APTSDMP_SerializedLicenseAssets.updateSerailizedAssets(jsonData); 
	}
 	
}