public class APTSMD_RedirectEcommerceController {

    public PageReference redirect(){
        String retUrl;
        
        //Get deafult Store to redirect
        string storeName = Apttus_Presales_eCommerce_Settings__c.getInstance().APTSMD_DefaultStore__c;
        if(storeName == Null){
            storeName = 'TIER1 Hardware and Software';
        }
        ConnectApi.CommunityPage comPage = ConnectApi.Communities.getCommunities();
        for(ConnectApi.Community com : comPage.communities){
            if(com.urlPathPrefix!=null && com.urlPathPrefix.equalsIgnoreCase('ecomm')){
                retUrl = com.siteUrl;
            }
        }
        List<APTSMD_Store__c> storeList = [SELECT Id,Name FROM APTSMD_Store__c WHERE Name=:storeName LIMIT 1];
        if(!storeList.isEmpty()){
            retUrl +='/APTSMD_SKOECommCatalog?storeId='+storeList[0].Id;
        }else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please add Store Record.'));
        }
        
        return new PageReference(retUrl);
        
    }   
}