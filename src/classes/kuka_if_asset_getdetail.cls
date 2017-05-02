@RestResource(urlMapping='/getassetdetail/*')
global with sharing class kuka_if_asset_getdetail {

    
    global class AssetWrapper
    {   
        public Id Id;
        public Id rootAssetId;
 
   		public AssetWrapper(Id Id, Id rootAssetId) {
        	this.Id = Id;   
        	this.rootAssetId = rootAssetId;   
    	}
    }
    
    
    
 @HttpGet 
    global static ResponseHandler GET()
    {
        ResponseHandler response = new ResponseHandler();
        Asset returnAsset = getAsset();

        if(returnAsset!=null)
        {
            response.Status = '200';            
            response.ErrorCode = '';           
            List<AssetWrapper> myAssetWrapper  = new List<AssetWrapper>();            
            myAssetWrapper.add(new AssetWrapper(returnAsset.Id, returnAsset.RootAssetId));
            
            response.Data = myAssetWrapper;
            response.Message = 'Success : Found Asset';
        }
        else
        {
            response.ErrorCode = '404';
            response.Status = 'error';
            response.Message = 'Asset Not Found';
        }
        return response;
    }
    // get asset 12345
    public static Asset getAsset()
    {
        //Read the Request from the URL
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
 		String SerialNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);  
       // String SerialNumber = req.params.get('serial');
        Asset result;
               
        try{
            result = [SELECT Id, RootAssetId, Name, SerialNumber, Description
                        FROM Asset WHERE SerialNumber = :SerialNumber];
        }
        Catch(System.QueryException e)
        {
            //do nothing, if result is empty we add 404 status 
        }
                
        return result;
    }    
    
    global class ResponseHandler {
       public String Status {get; set;}
       public List<AssetWrapper> Data {get;set;}
       public String Message {get;set;}
       public String ErrorCode {get; set;}
    }       
    
}