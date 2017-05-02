/*
 * Class : APTSMD_GreenTechMaintenance
 * Usage : Used to update Custom setting fields required in GreenTech Ecommerce
 * Developed By: Mayur Soni
 * Created On: 03-Mar-2016
 */

public class APTSMD_GreenTechMaintenance{
    
    public static final String ONESTAR='oneStarRating';
    public static final String TWOSTAR='twoStarRating';
    public static final String THREESTAR='threeStarRating';
    public static final String FOURSTAR='fourStarRating';
    public static final String FIVESTAR='fiveStarRating';
    public static final String SINGLESTAR='singleStar';
    public static final String SIDEBANNER='SideBannerGT';
    
    
    public static void updateCustomSettings(){
        System.debug('running together with jonathan');
        updateAdminName();
        //updatePartnerURL();
        updateStarImageIds();    
        updateSiteAndStoreRecord();
        System.debug('nico finished first though');
        updateStoreImageIdFields();
        // TO DO: Add   
    }
    
    //methods to populate Site urls in APTSMD_Site__c and APTSMD_Store__c objects 
    // By Sagar Jogi
    public static void updateSiteAndStoreRecord () {
        List<APTSMD_Site__c> ecommereceSite = [select id,Name,APTSMD_Site_URL__c from APTSMD_Site__c where Name='Ecommerce'];
        String instance;
        string instanceUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        
        string sitenamefromcustomsetting = Apttus_Presales_eCommerce_Settings__c.getInstance().GreenTech_Ecommerce_Name__c;
        
        if(sitenamefromcustomsetting == null) {
            sitenamefromcustomsetting = 'ecommerce';
        }
        
        List<site> sitelist = [SELECT id,MasterLabel,Name,UrlPathPrefix,Subdomain from site where Name=:sitenamefromcustomsetting];
        
        set<id> ecommsiteid = new set<id>();
        
        instanceUrl += '/' + sitelist[0].id;
        
        for(APTSMD_Site__c ecommsite:ecommereceSite) {
            ecommsite.APTSMD_Site_URL__c = instanceUrl;
            ecommsiteid.add(ecommsite.id);
        }
        update ecommereceSite;
        // string storeurl = 'https://' + sitelist[0].Subdomain + '.force.com/'+sitelist[0].UrlPathPrefix;
        // List<APTSMD_Store__c> storelist = [select id,APTSMD_Site_URL__c from APTSMD_Store__c where APTSMD_Site__c IN :ecommsiteid];
        // for(APTSMD_Store__c store: storelist) {
        //     store.APTSMD_Site_URL__c = storeurl;
        // }
        // update storelist;
    }
    
    
    //For GreenTech it is required to update Admin User field
    private static void updateAdminName(){
        User adminUser = [select FirstName,LastName from user where id =: UserInfo.getUserId()];
        Apttus_Config2__ConfigSystemProperties__c config  =  Apttus_Config2__ConfigSystemProperties__c.getValues('System Properties');
        if(config != null){
            config.Apttus_Config2__AdminUser__c = adminUser.FirstName + ' ' + adminUser.LastName;
            update config;    
        }
        
    }
    
    
    
    public static void updatePartnerURL(){
        //get the community url prefix from presales ecomm custom setting, if blank use bps
        String prefix='';
        Apttus_Presales_eCommerce_Settings__c config =  Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
        if(config != null && !String.isBlank(config.APTSMD_PartnerCommunityPrefix__c)){
            prefix = config.APTSMD_PartnerCommunityPrefix__c;
        }else{
            prefix = 'bps';
        }
        try
        {
        ConnectApi.CommunityPage comPage = ConnectApi.Communities.getCommunities();
        for(ConnectApi.Community com : comPage.communities){
            if(com.urlPathPrefix.equalsIgnoreCase(prefix)){
                config.APTSMD_PartnerLoginURL__c= com.loginUrl;
            }
        }
        }
        catch(exception e)
        {
		}


        update config;    
    }
    //Update Documents Ids used in GreenTech Ecommerce
    private static void updateStarImageIds(){
        Map<String,String> mapStarVsDocId = new Map<String,String>();
        List<Folder> greenTechFolder = [SELECT id,name FROM Folder WHERE Name='GreenTech Docs'];
        if(!greenTechFolder.isEmpty()){
            List<Document> listDocuments = [SELECT Id,Name FROM Document WHERE FolderId=:greenTechFolder[0].Id];
            if(!listDocuments.isEmpty()){
                for(Document doc : listDocuments){
                    if(doc.name.equalsIgnoreCase(ONESTAR)){
                        mapStarVsDocId.put(ONESTAR.toLowerCase(),doc.Id);
                    }else if(doc.name.equalsIgnoreCase(TWOSTAR)){
                        mapStarVsDocId.put(TWOSTAR.toLowerCase(),doc.Id);
                    }else if(doc.name.equalsIgnoreCase(THREESTAR)){
                        mapStarVsDocId.put(THREESTAR.toLowerCase(),doc.Id);
                    }else if(doc.name.equalsIgnoreCase(FOURSTAR)){
                        mapStarVsDocId.put(FOURSTAR.toLowerCase(),doc.Id);
                    }else if(doc.name.equalsIgnoreCase(FIVESTAR)){
                        mapStarVsDocId.put(FIVESTAR.toLowerCase(),doc.Id);
                    }else if(doc.name.equalsIgnoreCase(SINGLESTAR)){
                        mapStarVsDocId.put(SINGLESTAR.toLowerCase(),doc.Id);
                    }else if(doc.name.equalsIgnoreCase(SIDEBANNER)){
                        mapStarVsDocId.put(SIDEBANNER.toLowerCase(),doc.Id);
                    }    
                }
                Apttus_Presales_eCommerce_Settings__c config = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
                if(config!=null){
                     if(mapStarVsDocId.containsKey(ONESTAR.toLowerCase())){
                        config.PoorDocId__c = mapStarVsDocId.get(ONESTAR.toLowerCase());
                    }
                    if(mapStarVsDocId.containsKey(TWOSTAR.toLowerCase())){
                        config.NotGoodDocId__c= mapStarVsDocId.get(TWOSTAR.toLowerCase());
                    }
                    if(mapStarVsDocId.containsKey(THREESTAR.toLowerCase())){
                        config.GoodDocId__c= mapStarVsDocId.get(THREESTAR.toLowerCase());
                    }
                    if(mapStarVsDocId.containsKey(FOURSTAR.toLowerCase())){
                        config.VeryGoodDocId__c= mapStarVsDocId.get(FOURSTAR.toLowerCase());
                    }
                    if(mapStarVsDocId.containsKey(FIVESTAR.toLowerCase())){
                        config.ExcellentDocId__c= mapStarVsDocId.get(FIVESTAR.toLowerCase());
                    }
                    if(mapStarVsDocId.containsKey(SINGLESTAR.toLowerCase())){
                        config.APTSMD_ReviewStarDocId__c= mapStarVsDocId.get(SINGLESTAR.toLowerCase());
                    }
                    if(mapStarVsDocId.containsKey(SIDEBANNER.toLowerCase())){
                        config.APTSMD_SideBannerDocId__c= mapStarVsDocId.get(SIDEBANNER.toLowerCase());
                    }
                    update config;
                }
            }
        }
    }
    
    //By Mayur- to update the attachment record ids in store record
    public static void updateStoreImageIdFields(){
        List<APTSMD_Store__C> storeList = [SELECT id,Name,APTSMD_Store_Logo__c,APTSMD_Promotion1__c,APTSMD_Promotion2__c,APTSMD_Promotion3__c,APTSMD_Banner_Image__c FROM APTSMD_Store__c WHERE Name='TIER1 Hardware and Software'];
        if(!storeList.isEmpty()){
            APTSMD_Store__C store = storeList[0];
            List<Attachment> storeImages = [SELECT id,Name,Description FROM Attachment WHERE ParentId=:store.id];
            if(!storeImages.isEmpty()){
                for(Attachment att : storeImages){
                    if(!String.isBlank(att.Description)){
                        store.put(att.Description,att.Id); // Attchment description will have field name of store
                    }
                }
            }

            //update Site URL field
            String url;
            ConnectApi.CommunityPage comPage = ConnectApi.Communities.getCommunities();
            for(ConnectApi.Community com : comPage.communities){
                 if(com.urlPathPrefix != null){
                    if(com.urlPathPrefix.equalsIgnoreCase('ecomm')){
                        url = com.siteUrl+'/APTSMD_SKOECommHome?storeId=';
                    }
                }
            }    

            for(APTSMD_Store__C obj: storeList){
                obj.APTSMD_Site_URL__c = url+obj.id;
            }
            update store; 
        }
    }
}