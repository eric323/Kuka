trigger APTSMD_UpdateSiteURL  on APTSMD_Store__c (before Insert) {
    ConnectApi.CommunityPage comPage = ConnectApi.Communities.getCommunities();
    for(ConnectApi.Community com : comPage.communities){
        system.debug('####### '+ com);
        if(com.urlPathPrefix != null){
        if(com.urlPathPrefix.equalsIgnoreCase('ecomm')){
            trigger.new[0].APTSMD_Site_URL__c= com.siteUrl+'/APTSMD_SKOECommHome?storeId=';
        }
        }
    }        
}