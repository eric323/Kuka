public without sharing class APTSMD_productsUtils
{
    public static String priceLsitJson{get;set;}
    public static List<APTSMD_ProductWrapperClass> lstProductwrapAll{get;set;}
    //public static String contractpricelist;
    public static Map<Id,Apttus_Config2__AttributeGroupTranslation__c> mappdtGrpTranslations {get;set;}
    public static List<APTSMD_ProductWrapperClass> getProductsByCategory(Id CategoryId)
    {
        //a2Hc0000000Gu8L
        Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
        Account objUserAcc = [select id,APTSMD_Dealer_del__c from Account where id =: objContact.accountId];
        Apttus_Config2__PriceList__c priceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];

        //Apttus_Config2__PriceList__c priceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c =: 'Chicago' limit 1];
        Apttus_CPQApi.CPQ.ProductSearchResultDO result  =
                                  Apttus_CPQApi.CPQWebService.getProductsForPriceListCategory(priceList.Id,CategoryId);
        system.debug('res====='+result);
        Map<string,APTSMD_ProductWrapperClass> prodIdVsProductWrapperClass = new Map<string,APTSMD_ProductWrapperClass>();
        lstProductwrapAll = New List<APTSMD_ProductWrapperClass>();
        For(Apttus_CPQApi.CPQ.ProductDO catresult : result.Products) {
            system.debug('catresult == '+catresult);
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass (catresult.ProductId);
            wrap.ProductId = catresult.ProductId;
            wrap.ProductCode= catresult.ProductCode;
            wrap.ProductName=catresult.Name;
            wrap.Description=catresult.Description;
            wrap.ImageUrl=catresult.ImageUrl;
            wrap.ContentUrl=catresult.ContentUrl;
            wrap.HasPrices=catresult.HasPrices;

            //wrap.Prices=catresult.Prices;
            wrap.Quantity=1;

            prodIdVsProductWrapperClass.put(catresult.ProductId,wrap);
            lstProductwrapAll.add(wrap);
        }
        //-------Quering all reviews and wrapping it up into variable wrap...

       return lstProductwrapAll;

    }

    //Code by Mayur- For Bundle Options
    public static APTSMD_ProductWrapperClass getProductConfigurations(APTSMD_ProductWrapperClass product){
        if(product.hasOptions){
            product.prodOptionGroups = getBundleConfigurations(product.ProductId);
        }
        if(product.hasAttributes){
            product.prodAttributeGroups = getProductAttributes(product.ProductId);
        }
        return product;
    }

    public static Id getPriceListId(){
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        Account objUserAcc = [select id,APTSMD_Dealer_del__c from Account where id =: objContact.accountId];
        List<Apttus_Config2__PriceList__c> priceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];
        return !priceList.isEmpty()? priceList[0].id : '';

    }
    public static List<APTSMD_ProductOptionGroupWrapper> getBundleConfigurations(Id productId){
        System.debug('Bundle Config ');
        List<APTSMD_ProductOptionGroupWrapper> retList = new List<APTSMD_ProductOptionGroupWrapper>();
        Id priceListId = getPriceListId();
        Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO resultOG = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(priceListId, productId);
        System.debug('ResultOG  #' + resultOG);
        List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> selectedBundleOptionGroupsList;
        Map<String,Decimal> bundleOptionsPrice;
        Map<String,String> mapCompIdVsCompProductName = new Map<String,String>();
        //bundle selected
        if(resultOG != null && resultOG.HasOptionGroups){
            //configure = true;
            //bundleSelected = true;
            Set<String> productOptionGroup = new Set<String>();
            Set<String> productOptionComponent = new Set<String>();
            List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> optionGroups = resultOG.OptionGroups;

            selectedBundleOptionGroupsList = new List<Apttus_CPQApi.CPQ.ProductOptionGroupDO>();
            flattenOptionGroupList(selectedBundleOptionGroupsList, optionGroups);
            List<Id> optionIds = new List<Id>();
            bundleOptionsPrice = new map<String,Decimal>();
            for(Apttus_CPQApi.CPQ.ProductOptionGroupDO og : selectedBundleOptionGroupsList){

                for(Apttus_CPQApi.CPQ.ProductOptionComponentDO oc : og.OptionComponents){
                    optionIds.add(oc.ComponentProductId);
                    productOptionComponent.add(oc.ComponentId);
                    mapCompIdVsCompProductName.put(oc.ComponentId,oc.Name);
                    if(!bundleOptionsPrice.containsKey(oc.ComponentProductId)) {
                        if(oc.Prices.size() > 0 && oc.Prices[0].value != null){
                            bundleOptionsPrice.put(oc.ComponentProductId, oc.Prices[0].value);
                        }else{
                            bundleOptionsPrice.put(oc.ComponentProductId, 0.00);
                        }
                    }

                }
            }

            //Query Product Option Component
            Map<String,List<Apttus_Config2__ProductOptionComponent__c>> productOptionComponentMap = new Map<String,List<Apttus_Config2__ProductOptionComponent__c>>();

            for(Apttus_Config2__ProductOptionComponent__c prodOptGrp : Database.query(sobjetQuery('Apttus_Config2__ProductOptionComponent__c',null,null,null,null)+' where ID IN : productOptionComponent')) {
                List<Apttus_Config2__ProductOptionComponent__c> opCom ;

                if(productOptionComponentMap.containsKey(prodOptGrp.Apttus_Config2__ProductOptionGroupId__c)) {
                    opCom = productOptionComponentMap.get(prodOptGrp.Apttus_Config2__ProductOptionGroupId__c);
                }else{
                    opCom = new List<Apttus_Config2__ProductOptionComponent__c>();
                }
                opCom.add(prodOptGrp);
                productOptionComponentMap.put(prodOptGrp.Apttus_Config2__ProductOptionGroupId__c, opCom);
            }

            for(String str : productOptionComponentMap.KeySet()) {
                system.debug('--------- str = ' + str);
                productOptionGroup.add(str);
            }

            system.debug('--------- productOptionGroup = ' + productOptionGroup);

            //Query Product Option Group
            Map<String,Apttus_Config2__ProductOptionGroup__c> productOptionGroupMap = new Map<String,Apttus_Config2__ProductOptionGroup__c>();

            for(Apttus_Config2__ProductOptionGroup__c prodOptGrp : Database.query(sobjetQuery('Apttus_Config2__ProductOptionGroup__c',null,null,null,'Apttus_Config2__OptionGroupId__r.Name,(Select Id from Attachments)')+' where ID IN : productOptionGroup')) {
                productOptionGroupMap.put(prodOptGrp.Id, prodOptGrp);
            }


            system.debug('--------- productOptionGroupMap = ' + productOptionGroupMap);

            // Create Wrapper
            for(String prodOptGrpId : productOptionComponentMap.keySet()) {
                Apttus_Config2__ProductOptionGroup__c prodOptGrp = productOptionGroupMap.get(prodOptGrpId);
                system.debug('--------- prodOptGrp = ' + prodOptGrp);
                system.debug('--------- prodOptGrpId = ' + prodOptGrpId);
                List<APTSMD_ProductOptionComponentWrapper> prodOptComList = new List<APTSMD_ProductOptionComponentWrapper>();
                for(Apttus_Config2__ProductOptionComponent__c prodOptCom : productOptionComponentMap.get(prodOptGrpId)) {
                    APTSMD_ProductOptionComponentWrapper prodOptCompDO = new APTSMD_ProductOptionComponentWrapper(prodOptCom.Id, prodOptCom.name,mapCompIdVsCompProductName.get(prodOptCom.Id), prodOptCom.Apttus_Config2__AllowCloning__c, prodOptCom.Apttus_Config2__ComponentProductId__c,
                                                    prodOptCom.Apttus_Config2__Default__c, prodOptCom.Apttus_Config2__DefaultQuantity__c, prodOptCom.Apttus_Config2__InclusionCriteria__c, prodOptCom.Apttus_Config2__MaxQuantity__c, prodOptCom.Apttus_Config2__MinQuantity__c,
                                                    prodOptCom.Apttus_Config2__ParentProductId__c, prodOptCom.Apttus_Config2__ProductOptionGroupId__c, prodOptCom.Apttus_Config2__Modifiable__c, prodOptCom.Apttus_Config2__RelationshipType__c, prodOptCom.Apttus_Config2__Required__c,
                                                    prodOptCom.Apttus_Config2__Sequence__c,bundleOptionsPrice.get(prodOptCom.Apttus_Config2__ComponentProductId__c));
                    prodOptComList.add(prodOptCompDO);
                }

                String optGrpIconId = '';
                if(prodOptGrp.Attachments != null && prodOptGrp.Attachments.size()>0) {
                    optGrpIconId = '/servlet/servlet.FileDownload?file='+prodOptGrp.Attachments.get(0).Id;
                }else{
                    optGrpIconId = '/resource/NoImage';
                }
                APTSMD_ProductOptionGroupWrapper prodOptGrpDO = new APTSMD_ProductOptionGroupWrapper(prodOptGrp.Id, prodOptGrp.name,prodOptGrp.Apttus_Config2__OptionGroupId__r.Name, prodOptGrp.Apttus_Config2__IsHidden__c, prodOptGrp.Apttus_Config2__IsLeaf__c,
                                                    prodOptGrp.Apttus_Config2__IsPicklist__c, prodOptGrp.Apttus_Config2__Left__c, prodOptGrp.Apttus_Config2__Level__c, prodOptGrp.Apttus_Config2__MaxOptions__c, prodOptGrp.Apttus_Config2__MinOptions__c, prodOptGrp.Apttus_Config2__MaxTotalQuantity__c,
                                                    prodOptGrp.Apttus_Config2__MinTotalQuantity__c, prodOptGrp.Apttus_Config2__ModifiableType__c, prodOptGrp.Apttus_Config2__OptionGroupId__c, prodOptGrp.Apttus_Config2__ParentOptionGroupId__c,
                                                    prodOptGrp.Apttus_Config2__ProductId__c, prodOptGrp.Apttus_Config2__Right__c, prodOptGrp.Apttus_Config2__RootOptionGroupId__c, prodOptGrp.Apttus_Config2__RootSequence__c, prodOptGrp.Apttus_Config2__Sequence__c, prodOptComList,optGrpIconId);

                retList.add(prodOptGrpDO);
            }

        }
        return retList;
    }
    private static void flattenOptionGroupList(List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> optionGroupList, List<Apttus_CPQApi.CPQ.ProductOptionGroupDO> optionGroupsDO){
        for(Apttus_CPQApi.CPQ.ProductOptionGroupDO og : optionGroupsDO){
            optionGroupList.add(og);
            if(og.HasChildOptionGroups){
                flattenOptionGroupList(optionGroupList, og.ChildOptionGroups);
            }
        }
    }

    public static String sobjetQuery( String SobjectApiName , String conditionalField ,String condition,String comparingFieldvalue,String additionalFields ){
       String query = '';

       Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

       Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

       for(String fieldName : fieldMap.keyset()){
           if(query == null || query == ''){
               query = fieldName;
           }else{
               query = query + ',' + fieldName;
           }

       }
       if(additionalFields != null && additionalFields != '')
               query = 'Select' + ' ' + query +','+additionalFields+' '+' from ' + SobjectApiName;
       else
               query = 'Select' + ' ' + query+' '+' from ' + SobjectApiName;
       system.debug('------------>'+query);
       if((conditionalField != null && conditionalField != '' ) && (condition != null && condition != '') && (comparingFieldvalue != null && comparingFieldvalue != null))
               query = query + ' ' + 'Where '+conditionalField+' '+condition+' '+comparingFieldvalue+'';



       return query;
    }

    //Code By Mayur-get ProductAttributes
    public static List<APTSMD_ProductAttributeGroupWrapper> getProductAttributes(Id productId){
        List<APTSMD_ProductAttributeGroupWrapper> retList = new List<APTSMD_ProductAttributeGroupWrapper>();
        String strName = '';
        List<Apttus_Config2__ProductAttributeGroup__c> prodAttributeGrpList = getAttributeGroups(productId);
        if(!prodAttributeGrpList.isEmpty()){
            for(Apttus_Config2__ProductAttributeGroup__c attrGrp : prodAttributeGrpList){

                if(attrGrp.Apttus_Config2__Attributes__r.size()>0)
                {
                    if(mappdtGrpTranslations != null)
                    {
                        if(mappdtGrpTranslations.containsKey(attrGrp.Id))
                        {
                            Apttus_Config2__AttributeGroupTranslation__c pdtObj = mappdtGrpTranslations.get(attrGrp.Id);
                            system.debug('pdtObj=='+pdtObj);
                            strName = pdtObj.Apttus_Config2__Name__c;
                        }
                    }
                     system.debug('strName==='+strName);
                    List<APTSMD_ProductAttributeWrapper> prodAttribList = new List<APTSMD_ProductAttributeWrapper>();

                    for(Apttus_Config2__ProductAttribute__c attribute : attrGrp.Apttus_Config2__Attributes__r){
                        prodAttribList.add(new APTSMD_ProductAttributeWrapper(attribute.Apttus_Config2__Field__c,attrGrp.Apttus_Config2__BusinessObject__c));
                    }
                   if(strName == null || strName =='')
                    {
                     retList.add(new APTSMD_ProductAttributeGroupWrapper(attrGrp.Name,prodAttribList));
                    }
                    else
                    {
                        retList.add(new APTSMD_ProductAttributeGroupWrapper(strName,prodAttribList));
                    }
                    system.debug('retList=='+retList);
                }
            }
        }
        return retList;
    }
    //Fetch all the attribute groups associated with the line items
    public static List<Apttus_Config2__ProductAttributeGroup__c> getAttributeGroups(Id productID)
    {   List<Apttus_Config2__ProductAttributeGroup__c> retList;
        List<Apttus_Config2__AttributeGroupTranslation__c> pdtGrpTransalations;
        try
        {
            Set<Id> groupIdSet = new Set<Id>();

            // fetch the details from product attribute group member
            List<Apttus_Config2__ProductAttributeGroupMember__c> lstGroups = [select Id,Apttus_Config2__AttributeGroupId__c FROM Apttus_Config2__ProductAttributeGroupMember__c WHERE Apttus_Config2__ProductId__c = :productID ORDER BY Apttus_Config2__AttributeGroupId__c ASC];

            // loop over the result and add the grounp id to the set
            for(Apttus_Config2__ProductAttributeGroupMember__c gm : lstGroups)
            {
                groupIdSet.add(gm.Apttus_Config2__AttributeGroupId__c);
            }
           system.debug('groupIdSet==='+groupIdSet);
           // fetch the details from product attribute group object
           retList = [select Id,Name,Apttus_Config2__TwoColumnAttributeDisplay__c,Apttus_Config2__BusinessObject__c,(select Apttus_Config2__Field__c,Apttus_Config2__IsReadOnly__c FROM Apttus_Config2__Attributes__r ORDER BY Apttus_Config2__Sequence__c ASC) FROM Apttus_Config2__ProductAttributeGroup__c WHERE Id IN :groupIdSet ORDER BY name ASC];
           mappdtGrpTranslations =new Map<Id,Apttus_Config2__AttributeGroupTranslation__c>();
           for(Apttus_Config2__AttributeGroupTranslation__c pdt: [SELECT Id,Name,Apttus_Config2__Name__c,Apttus_Config2__ProductAttributeGroupId__c,Apttus_Config2__Language__c FROM Apttus_Config2__AttributeGroupTranslation__c Where Apttus_Config2__Language__c=:UserInfo.getLanguage() AND Apttus_Config2__ProductAttributeGroupId__c IN :groupIdSet/*user.LanguageLocaleKey */])
           {
               mappdtGrpTranslations.put(pdt.Apttus_Config2__ProductAttributeGroupId__c,pdt);
           }
           system.debug('mappdtGrpTranslations==='+mappdtGrpTranslations);
             return retList;
        }
        catch(Exception ex)
        {
            system.debug('Error from getAttributeGroups: ' + ex.getMessage());
            return null;
        }
    }

    public static List<APTSMD_ProductWrapperClass>  getAlsoBoughtProducts(List<Id> prodId){



        Set<id> recommendedProdIds= new set<id>();

        for(APTSMD_Recommended_Product__c i : [select APTSMD_Recommended_Product__r.id,APTSMD_Recommended_Product__r.Name,APTSMD_Product__r.id,APTSMD_Recommended_Product__r.APTSMD_Rating__c,APTSMD_Recommended_Product__r.APTSMD_product_image_url__c,APTSMD_Recommended_Product__r.APTSMD_product_rating_indicator_src__c,APTSMD_Recommended_Product__r.ProductCode,APTSMD_Recommended_Product__r.APTSMD_Rating_Indicator__c,APTSMD_Recommended_Product__r.Description,APTSMD_Recommended_Product__r.Apttus_Config2__Icon__c,APTSMD_Recommended_Product__r.Apttus_Config2__HasOptions__c,APTSMD_Recommended_Product__r.Apttus_Config2__Customizable__c,APTSMD_Recommended_Product__r.Apttus_Config2__HasAttributes__c from APTSMD_Recommended_Product__c WHERE APTSMD_ShowInFrequentlyPurchase__c=TRUE ORDER BY CreatedDate DESC Limit 4]){

            recommendedProdIds.add(i.APTSMD_Recommended_Product__r.id);
        }

        Map<string,APTSMD_ProductWrapperClass> prodIdVsProductWrapperClass = new Map<string,APTSMD_ProductWrapperClass>();
        List<APTSMD_ProductWrapperClass> lstProductwrap = New List<APTSMD_ProductWrapperClass>();
        List<product2> result=[select id,Name,Apttus_Config2__IconId__c,APTSCU_Availability__c,APTSMD_Long_Description__c,APTSMD_product_rating_indicator_src__c, Description,ProductCode,
                                APTSMD_Number_of_1_Star__c,APTSMD_Number_of_2_Star__c,APTSMD_Number_of_3_Star__c,APTSMD_Number_of_4_Star__c,APTSMD_Number_of_5_Star__c,APTSMD_Rebates__c,APTSMD_Loyalty__c,APTSMD_Promotions__c,APTSMD_Rating__c,APTSMD_Rating_Indicator__c,Apttus_Config2__HasOptions__c,Apttus_Config2__Customizable__c,Apttus_Config2__HasAttributes__c from product2 where id in :recommendedProdIds];

        For(product2 catresult : result) {
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass (catresult.id);
            wrap.ProductId = catresult.id;
            wrap.ProductCode= catresult.ProductCode;
            wrap.ProductName=catresult.Name;
            if(catresult.APTSMD_Number_of_1_Star__c <>NULL && catresult.APTSMD_Number_of_2_Star__c <>NULL && catresult.APTSMD_Number_of_3_Star__c<>NULL  && catresult.APTSMD_Number_of_4_Star__c<>NULL  && catresult.APTSMD_Number_of_5_Star__c<>NULL ){
                wrap.star1='width:'+catresult.APTSMD_Number_of_1_Star__c+'%;';
                wrap.star2='width:'+catresult.APTSMD_Number_of_2_Star__c+'%;';
                wrap.star3='width:'+catresult.APTSMD_Number_of_3_Star__c+'%;';
                wrap.star4='width:'+catresult.APTSMD_Number_of_4_Star__c+'%;';
                wrap.star5='width:'+catresult.APTSMD_Number_of_5_Star__c+'%;';
            }
            wrap.ImageUrl = catresult.Apttus_Config2__IconId__c;
            wrap.Description=catresult.Description;
            wrap.availability = catresult.APTSCU_Availability__c;
            //wrap.customerAlsoBoughts=listCAB;
            wrap.loyalty = catresult.APTSMD_Loyalty__c;
            wrap.rebate = catresult.APTSMD_Rebates__c;
            wrap.promotions = catresult.APTSMD_Promotions__c;
            wrap.rating = catresult.APTSMD_Rating__c;
            wrap.ratingURL = catresult.APTSMD_Rating_Indicator__c;
            wrap.hasOptions = catresult.Apttus_Config2__HasOptions__c;
            wrap.hasAttributes = catresult.Apttus_Config2__HasAttributes__c;
            wrap.mustConfigure = catresult.Apttus_Config2__Customizable__c;
            wrap.productDetails=catresult;
            //wrap.recomProds=productIdVsRecom.get(catresult.id);
            //wrap.Prices=catresult.Prices;
            prodIdVsProductWrapperClass.put(catresult.id,wrap);

            lstProductwrap.add(wrap);
        }

        set<Id> prodIdList = new set<Id>();

        for (Apttus_Config2__PriceListItem__c PLIDetails: [select Id, Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__r.IsActive =True and  Apttus_Config2__ProductId__c in :recommendedProdIds  order by createddate]){
            if(prodIdList.contains(PLIDetails.Apttus_Config2__ProductId__c)) {
            }
            else {
                prodIdList.add(PLIDetails.Apttus_Config2__ProductId__c);
                prodIdVsProductWrapperClass.get(PLIDetails.Apttus_Config2__ProductId__c ).PriceItem= PLIDetails;
            }
        }

        return lstProductwrap;

        /*
        map<id,Apttus_Config2__PriceListItem__c> pliMap= new map<id,Apttus_Config2__PriceListItem__c>();
        for (Apttus_Config2__PriceListItem__c pli : [select Id, Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__c,
                                                    Apttus_Config2__ProductId__r.Name,
                                                    Apttus_Config2__ProductId__r.APTSMD_Rating__c,Apttus_Config2__ProductId__r.product_image_url__c,
                                                    Apttus_Config2__ProductId__r.APTSMD_product_rating_indicator_src__c,Apttus_Config2__ProductId__r.ProductCode,
                                                    Apttus_Config2__ProductId__r.Rating_Indicator__c,Apttus_Config2__ProductId__r.Description,
                                                    Apttus_Config2__ProductId__r.Apttus_Config2__Icon__c,Apttus_Config2__ProductId__r.APTSCU_Availability__c
                                                    from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c in :recommendedProdIds order by createddate limit 5]){
            pliMap.put(pli.Apttus_Config2__ProductId__c,pli);
        }
        List<Apttus_Config2__PriceListItem__c> pli= new List<Apttus_Config2__PriceListItem__c>();
        for(string ide : pliMap.keySet()){
            pli.add(pliMap.get(ide));
        }
        return pli;
        */
    }

    public static Map<string,APTSMD_ProductWrapperClass> getFeatureListByProductId(List<Id> prodId){
        Map<string,List<Apttus_Config2__ProductFeatureValue__c >> productIdVsFeatures = new Map<string,List<Apttus_Config2__ProductFeatureValue__c >>();

        for(Apttus_Config2__ProductFeatureValue__c i : [select id,Apttus_Config2__Value__c,name,Apttus_Config2__FeatureId__r.name,Apttus_Config2__ProductId__c  from Apttus_Config2__ProductFeatureValue__c]){
            if(productIdVsFeatures.get(i.Apttus_Config2__ProductId__c)==NULL){
                productIdVsFeatures.put(i.Apttus_Config2__ProductId__c,new List<Apttus_Config2__ProductFeatureValue__c >() );
            }
            productIdVsFeatures.get(i.Apttus_Config2__ProductId__c).add(i);
        }


        Set<id> recommendedProdIds= new set<id>();


        Map<string,APTSMD_ProductWrapperClass.recommProd> idVsRecomWrapper=new Map<string,APTSMD_ProductWrapperClass.recommProd>();


        Map<string,List<APTSMD_ProductWrapperClass.recommProd>> rP = new Map<string,List<APTSMD_ProductWrapperClass.recommProd>>();
        for(APTSMD_Recommended_Product__c i : [select APTSMD_Recommended_Product__r.id,APTSMD_Recommended_Product__r.Name,APTSMD_Product__r.id,APTSMD_Recommended_Product__r.APTSMD_Rating__c,APTSMD_Recommended_Product__r.APTSMD_product_image_url__c,APTSMD_Recommended_Product__r.APTSMD_product_rating_indicator_src__c,APTSMD_Recommended_Product__r.ProductCode,APTSMD_Recommended_Product__r.APTSMD_Rating_Indicator__c,APTSMD_Recommended_Product__r.Description,APTSMD_Recommended_Product__r.Apttus_Config2__Icon__c, APTSMD_Recommended_Product__r.Apttus_Config2__HasOptions__c,APTSMD_Recommended_Product__r.Apttus_Config2__Customizable__c from APTSMD_Recommended_Product__c where APTSMD_Product__r.IsActive =True]){
            if(rP.get(i.APTSMD_Product__r.id)==NULL){
                rP.put(i.APTSMD_Product__r.id,new List<APTSMD_ProductWrapperClass.recommProd>());
            }
            APTSMD_ProductWrapperClass.recommProd newrp= new APTSMD_ProductWrapperClass.recommProd();

            newrp.recomProd=i;

            recommendedProdIds.add(i.APTSMD_Recommended_Product__r.id);
            idVsRecomWrapper.put(i.APTSMD_Recommended_Product__r.id,newrp);
            rp.get(i.APTSMD_Product__r.id).add(newrp);
        }



        set<Id> recprodIdList = new set<Id>();
        for (Apttus_Config2__PriceListItem__c PLIDetails: [select Id, Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c in:recommendedProdIds order by createddate]){
            if(recprodIdList.contains(PLIDetails.Apttus_Config2__ProductId__c)) {
            }
            else {
                recprodIdList.add(PLIDetails.Apttus_Config2__ProductId__c);
                idVsRecomWrapper.get(PLIDetails.Apttus_Config2__ProductId__c).PriceItem=PLIDetails;

            }
        }


        Map<string,APTSMD_ProductWrapperClass> prodIdVsProductWrapperClass = new Map<string,APTSMD_ProductWrapperClass>();
        List<APTSMD_ProductWrapperClass> lstProductwrap = New List<APTSMD_ProductWrapperClass>();
        List<product2> result=[select id,Name,Apttus_Config2__IconId__c,APTSCU_Availability__c,APTSMD_Long_Description__c,APTSMD_product_rating_indicator_src__c, Description,ProductCode,
                                APTSMD_Number_of_1_Star__c,APTSMD_Number_of_2_Star__c,APTSMD_Number_of_3_Star__c,APTSMD_Number_of_4_Star__c,APTSMD_Number_of_5_Star__c,Apttus_Config2__HasOptions__c,Apttus_Config2__Customizable__c,Apttus_Config2__HasAttributes__c, APTSDMP_Slider_Pic_1__c, APTSDMP_Slider_Pic_2__c, APTSDMP_Slider_Pic_3__c, APTSDMP_Slider_Pic_4__c  from product2 where IsActive = True];


        boolean isCustomerAlsoBoughtBinded=false;
        For(product2 catresult : result) {
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass (catresult.id);
            wrap.ProductId = catresult.id;
            wrap.ProductCode= catresult.ProductCode;
            wrap.ProductName=catresult.Name;
            if(catresult.APTSMD_Number_of_1_Star__c <>NULL && catresult.APTSMD_Number_of_2_Star__c <>NULL && catresult.APTSMD_Number_of_3_Star__c<>NULL  && catresult.APTSMD_Number_of_4_Star__c<>NULL  && catresult.APTSMD_Number_of_5_Star__c<>NULL ){
                wrap.star1='width:'+catresult.APTSMD_Number_of_1_Star__c+'%;';
                wrap.star2='width:'+catresult.APTSMD_Number_of_2_Star__c+'%;';
                wrap.star3='width:'+catresult.APTSMD_Number_of_3_Star__c+'%;';
                wrap.star4='width:'+catresult.APTSMD_Number_of_4_Star__c+'%;';
                wrap.star5='width:'+catresult.APTSMD_Number_of_5_Star__c+'%;';
                /*List<Integer> starArr = new List<Integer>();
                starArr[0] = Integer.valueOf(catresult.Number_of_5_Star__c);
                starArr [1] = Integer.valueOf(catresult.Number_of_4_Star__c);
                starArr [2] = Integer.valueOf(catresult.Number_of_3_Star__c);
                starArr [3] = Integer.valueOf(catresult.Number_of_2_Star__c);
                starArr [4] = Integer.valueOf(catresult.Number_of_1_Star__c);
                wrap.ratingCountArray = starArr;*/
            }

            wrap.ImageUrl = catresult.Apttus_Config2__IconId__c;
            wrap.Description=catresult.Description;
            wrap.features=productIdVsFeatures.get(catresult.id);
            wrap.rProd=rp.get(catresult.id);
            wrap.hasOptions = catresult.Apttus_Config2__HasOptions__c;
            wrap.mustConfigure = catresult.Apttus_Config2__Customizable__c;
            wrap.hasAttributes = catresult.Apttus_Config2__HasAttributes__c;
            //wrap.customerAlsoBoughts=listCAB;


            wrap.productDetails=catresult;
            //wrap.recomProds=productIdVsRecom.get(catresult.id);
            //wrap.Prices=catresult.Prices;
            prodIdVsProductWrapperClass.put(catresult.id,wrap);
            lstProductwrap.add(wrap);
        }
        //-------Quering all reviews and wrapping it up into variable wrap...
        List<APTSMD_Product_Review__c> allProdReview=[select APTSMD_Product__c,APTSMD_rating_indicator__c,APTSMD_Rating__c,APTSMD_Review__c,APTSMD_Reviewed_By__c,APTSMD_Reviewed_On__c from APTSMD_Product_Review__c where APTSMD_Product__c in :prodIdVsProductWrapperClass.keyset()];
        for(APTSMD_Product_Review__c i : allProdReview){
            if(prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).reviews==NULL){
                prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).reviews= new List<APTSMD_Product_Review__c>();
            }
            prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).reviews.add(i);
        }
        //Querying and setting up price list item
        set<Id> prodIdList = new set<Id>();

        for (Apttus_Config2__PriceListItem__c PLIDetails: [select Id, Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__r.IsActive =True  order by createddate]){
            if(prodIdList.contains(PLIDetails.Apttus_Config2__ProductId__c)) {
            }
            else {
                prodIdList.add(PLIDetails.Apttus_Config2__ProductId__c);
                prodIdVsProductWrapperClass.get(PLIDetails.Apttus_Config2__ProductId__c ).PriceItem= PLIDetails;

            }
        }

        //-------Quering over questions and its answers
        List<APTSMD_Question__c> allQuestions = [select id,APTSMD_Product__c,APTSMD_Question__c from APTSMD_Question__c where APTSMD_Product__c in :prodIdVsProductWrapperClass.keySet()];
        List<APTSMD_Answer__c> allAnswers =[select id,APTSMD_Answer__c,APTSMD_Question__c from APTSMD_Answer__c where APTSMD_Question__r.APTSMD_Product__c in :prodIdVsProductWrapperClass.keySet()];

        Map<string,List<APTSMD_Answer__c>> queVsAns= new Map<string,List<APTSMD_Answer__c>>();
        for (APTSMD_Answer__c i :allAnswers ){
            if(queVsAns.get(i.APTSMD_Question__c)==NULL){
                queVsAns.put(i.APTSMD_Question__c,new List<APTSMD_Answer__c>());
            }
            queVsAns.get(i.APTSMD_Question__c).add(i);
        }

        Map<string,List<APTSMD_ProductWrapperClass.qNa>> productVsQuestionsWrapp= new Map<string,List<APTSMD_ProductWrapperClass.qNa>>();

        for(APTSMD_Question__c i : allQuestions){
            if(prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).quesAnditsAnswers==NULL){
                List<APTSMD_ProductWrapperClass.qNa> qnaList= new List<APTSMD_ProductWrapperClass.qNa>();
                prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).quesAnditsAnswers= qnaList;
                productVsQuestionsWrapp.put(i.APTSMD_Product__c,qnaList);
            }
            APTSMD_ProductWrapperClass.qNa qnaWrapp= new APTSMD_ProductWrapperClass.qNa();
            qnaWrapp.eachquestions=i;
            qnaWrapp.answers=queVsAns.get(i.id);
            productVsQuestionsWrapp.get(i.APTSMD_Product__c).add(qnaWrapp);
        }
        return prodIdVsProductWrapperClass;
    }

      public static List<APTSMD_ProductWrapperClass> getProductsOnCategories(String PLId,String cPlid,String rsq)
    {
        system.debug('######3Contra---fieldapiname'+rsq);
        String refinesearchstring = rsq.substringBetween('[', ']');
        system.debug('************refinesearchstring'+refinesearchstring);
        String[] refinesearchstringarray = refinesearchstring.split(', ');

        system.debug('************refinesearchstringarray'+refinesearchstringarray.size());
        system.debug('######3Contra---2'+cPlid);
        String contractpricelist = cPlid;
        system.debug('######3Contra---3'+contractpricelist);
        //Id priceListId = 'a2nc0000000DAAB';
        User user = [select contactId,LanguageLocaleKey from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        //Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
        Account objUserAcc = [select id,APTSMD_Dealer_del__c,APTSMD_Pricing_Agreement_Number__c  from Account where id =: objContact.accountId];
        Apttus_Config2__PriceList__c priceList;
        if(PLId != null){
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where id=:PLId limit 1];
        }
        else{
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];
        }
        //Code for Contractged Pricing - Mayur
        Map<String,Apttus_Config2__PriceListItem__c> mapProdIdVsContractedPLI;
        if(UserInfo.getUserType() != 'Guest'){ //check Contract pricing only if User is login
            if(objUserAcc.APTSMD_Pricing_Agreement_Number__c != null ) {
                    mapProdIdVsContractedPLI = getContractedPrices(objUserAcc.APTSMD_Pricing_Agreement_Number__c,contractpricelist);
            }
        }
        /*if(objUserAcc.APTSMD_Pricing_Agreement_Number__c != null ) {
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where Apttus_Config2__ContractNumber__c =: objUserAcc.APTSMD_Pricing_Agreement_Number__c limit 1];
        }else{
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];
        }*/

        //Apttus_Config2__PriceList__c priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];

       // Apttus_Config2__PriceList__c priceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c =: 'Chicago' limit 1];
        Map<String,Apttus_Config2__PriceListItem__c> mapPirceItems = new Map<String,Apttus_Config2__PriceListItem__c>();
        for(Apttus_Config2__PriceListItem__c objLineItem : [select id,Apttus_Config2__ListPrice__c,Apttus_Config2__MaxPrice__c,Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__AllowManualAdjustment__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__AllowProration__c,Apttus_Config2__Active__c,Apttus_Config2__AllocateGroupAdjustment__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__PriceListId__c =: priceList.Id ])
        {
            String strKey = objLineItem.Apttus_Config2__PriceListId__c + ' ' + objLineItem.Apttus_Config2__ProductId__c;
            mapPirceItems.put(strKey,objLineItem);
        }
        system.debug('mapPirceItems == '+mapPirceItems);
        Map<Id,Attachment> mapProdAttachments = new Map<Id,Attachment>();
        Map<Id,Attachment> mapCatAttachments = new Map<Id,Attachment>();
        for(Attachment objAttach : [select id,name,parentId,parent.Name from Attachment where parentId in (select id from product2)])
        {
            if(String.valueOf(objAttach.parentId).startsWith('01t'))
            {
                mapProdAttachments.put(objAttach.parentId,objAttach);
            }
            if(String.valueOf(objAttach.parentId).startsWith('a2H'))
            {
                mapCatAttachments.put(objAttach.parentId,objAttach);
            }

        }

        system.debug('Category== '+priceList.Apttus_Config2__Categories__r);
        system.debug('mapPirceItems == '+mapPirceItems);
        //Id levelZeoCategoryID = 'a2Ic0000000DMZiEAO';
        Map<Id,Apttus_Config2__ProductTranslation__c> mapPdtTranslations = new  Map<Id,Apttus_Config2__ProductTranslation__c>();
        for(Apttus_Config2__ProductTranslation__c pdtTranslation : [SELECT APTSDMP_Ecomm_UoM__c,APTSDMP_Ecomm_Frequency__c, Apttus_Config2__Description__c,Apttus_Config2__Family__c,Apttus_Config2__Language__c,Apttus_Config2__Name__c,Apttus_Config2__ProductCode__c,Apttus_Config2__ProductId__c,APTSDMP_Ecomm_Product_Description_1__c,APTSDMP_Ecomm_Product_Description_2__c,APTSDMP_Ecomm_Product_Description_3__c,APTSDMP_Ecomm_Product_Description_4__c,APTSDMP_Ecomm_Product_Description_5__c,APTSMD_Long_Description__c FROM Apttus_Config2__ProductTranslation__c WHERE Apttus_Config2__Language__c=:UserInfo.getLanguage()])
        {
        		mapPdtTranslations.put(pdtTranslation.Apttus_Config2__ProductId__c,pdtTranslation);
        }
        system.debug('mapPdtTranslations===='+mapPdtTranslations);
        Apttus_Config2__ClassificationName__c objClassification = [select id from Apttus_Config2__ClassificationName__c where Apttus_Config2__Active__c =: true and Id =: priceList.Apttus_Config2__Categories__r.get(0).Apttus_Config2__HierarchyId__c];
        lstProductwrapAll = New List<APTSMD_ProductWrapperClass>();
        Set<Id> prodIds = new Set<Id>();
        for(Apttus_Config2__ProductHierarchyView__c objProdView : [select id,Name,Apttus_Config2__ChildProductId__c from Apttus_Config2__ProductHierarchyView__c where Apttus_Config2__PriceListId__c =: priceList.Id and Apttus_Config2__HierarchyId__c =: objClassification.Id AND (NOT(Apttus_Config2__ChildProductId__r.Name LIKE '%Apttus%'))]){
            prodIds.add(objProdView.Apttus_Config2__ChildProductId__c);
        }
        Map<Id,Product2> prodIdVsProduct = prepareProductMap(prodIds);

        for(Apttus_Config2__ProductHierarchyView__c objProdView : [select id,Name,Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Frequency__c,Apttus_Config2__ChildProductId__r.APTSMD_GuidedProducts__c,Apttus_Config2__ChildProductId__r.APTSMD_product_rating_indicator_src__c,Apttus_Config2__ChildProductId__r.APTSCU_Availability__c,Apttus_Config2__ChildProductId__r.APTSMD_Rating__c,Apttus_Config2__HierarchyId__c,Apttus_Config2__ChildProductId__r.APTSMD_is_Comparable__c,Apttus_Config2__ParentClassificationId__c,Apttus_Config2__ParentClassificationId__r.Name,Apttus_Config2__ParentClassificationId__r.Apttus_Config2__AncestorId__c,Apttus_Config2__ChildProductId__c,Apttus_Config2__ChildProductId__r.ProductCode,Apttus_Config2__ChildProductId__r.Name,Apttus_Config2__ChildProductId__r.Description,Apttus_Config2__ChildProductId__r.Family,Apttus_Config2__ParentClassificationId__r.Apttus_Config2__AncestorId__r.Name,Apttus_Config2__ChildProductId__r.APTSMD_SearchDescription__c,Apttus_Config2__ParentClassificationId__r.Apttus_Config2__AncestorId__r.Apttus_Config2__AncestorId__c,
        Apttus_Config2__ChildProductId__r.Apttus_Config2__HasOptions__c,Apttus_Config2__ChildProductId__r.Apttus_Config2__Customizable__c, Apttus_Config2__ChildProductId__r.Apttus_Config2__HasAttributes__c,Apttus_Config2__ChildProductId__r.APTSMD_Rebates__c,Apttus_Config2__ChildProductId__r.APTSMD_Promotions__c,Apttus_Config2__ChildProductId__r.APTSMD_Loyalty__c,Apttus_Config2__ChildProductId__r.APTSMD_Long_Description__c, Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_1__c, Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_2__c, Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_3__c, Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_4__c, Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_5__c,Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_UoM__c from Apttus_Config2__ProductHierarchyView__c where Apttus_Config2__PriceListId__c =: priceList.Id and Apttus_Config2__HierarchyId__c =: objClassification.Id AND (NOT(Apttus_Config2__ChildProductId__r.Name LIKE '%Apttus%')) AND Apttus_Config2__ChildProductId__r.APTSDMP_Show_in_Ecommerce__c = TRUE])
        {
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass(objProdView.Apttus_Config2__ChildProductId__c);
            //if(objProdView.Apttus_Config2__ChildProductId__r.ProductCode != '16OZSEALS' && objProdView.Apttus_Config2__ChildProductId__r.ProductCode != 'ININK67') continue;
            //if(objProdView.Apttus_Config2__ChildProductId__r.ProductCode != 'ISINK2') continue;

            wrap.productDetails = prodIdVsProduct.get(objProdView.Apttus_Config2__ChildProductId__c);
            wrap.ProductId = objProdView.Apttus_Config2__ChildProductId__c;
            wrap.ProductCode= objProdView.Apttus_Config2__ChildProductId__r.ProductCode;
            wrap.isComparable= objProdView.Apttus_Config2__ChildProductId__r.APTSMD_is_Comparable__c;
            wrap.ProductName=objProdView.Apttus_Config2__ChildProductId__r.Name;
            wrap.ratingURL=objProdView.Apttus_Config2__ChildProductId__r.APTSMD_product_rating_indicator_src__c;
            wrap.rating= objProdView.Apttus_Config2__ChildProductId__r.APTSMD_Rating__c;
            wrap.availability=objProdView.Apttus_Config2__ChildProductId__r.APTSCU_Availability__c;
            wrap.isGuidedProd = objProdView.Apttus_Config2__ChildProductId__r.APTSMD_GuidedProducts__c;   //By Mayur
            wrap.Description=objProdView.Apttus_Config2__ChildProductId__r.Description;
            wrap.SearchDescription = objProdView.Apttus_Config2__ChildProductId__r.APTSMD_SearchDescription__c;
            wrap.parentCategoryId = objProdView.Apttus_Config2__ParentClassificationId__c;
            wrap.loyalty = objProdView.Apttus_Config2__ChildProductId__r.APTSMD_Loyalty__c;
            wrap.rebate = objProdView.Apttus_Config2__ChildProductId__r.APTSMD_Rebates__c;
            wrap.promotions = objProdView.Apttus_Config2__ChildProductId__r.APTSMD_Promotions__c;
            wrap.showProduct =true;
            wrap.longDescription = objProdView.Apttus_Config2__ChildProductId__r.APTSMD_Long_Description__c;

           wrap.eCommDesc1 = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_1__c;
            wrap.eCommDesc2 = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_2__c;
            wrap.eCommDesc3 = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_3__c;
            wrap.eCommDesc4 = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_4__c;
            wrap.eCommDesc5 = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Product_Description_5__c;
            wrap.frequency = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_Frequency__c;
            wrap.ecommUOM = objProdView.Apttus_Config2__ChildProductId__r.APTSDMP_Ecomm_UoM__c;
            if(mapPdtTranslations.size()>0)
            {
            	if(mapPdtTranslations.containsKey(objProdView.Apttus_Config2__ChildProductId__c))
            	{
	            	Apttus_Config2__ProductTranslation__c objPdtTranslation =  mapPdtTranslations.get(objProdView.Apttus_Config2__ChildProductId__c);
	            	//system.debug('objPdtTranslation===='+objPdtTranslation);
	            	wrap.ProductName=objPdtTranslation.Apttus_Config2__Name__c;
	            	wrap.Description=objPdtTranslation.Apttus_Config2__Description__c;
                    wrap.ProductCode= objPdtTranslation.Apttus_Config2__ProductCode__c;
                    wrap.eCommDesc1 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_1__c;
                    wrap.eCommDesc2 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_2__c;
                    wrap.eCommDesc3 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_3__c;
                    wrap.eCommDesc4 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_4__c;
                    wrap.eCommDesc5 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_5__c;
                    wrap.frequency = objPdtTranslation.APTSDMP_Ecomm_Frequency__c;
                    wrap.longDescription = objPdtTranslation.APTSMD_Long_Description__c;
                    wrap.family = objPdtTranslation.Apttus_Config2__Family__c;
                    wrap.ecommUOM = objPdtTranslation.APTSDMP_Ecomm_UoM__c;
	            }
            }
            if(mapProdAttachments.containsKey(wrap.ProductId) && mapProdAttachments.get(wrap.ProductId) != null)
                wrap.ImageUrl = 'servlet/servlet.FileDownload?file='+mapProdAttachments.get(wrap.ProductId).Id;
            if(mapCatAttachments.containsKey(wrap.ProductId) && mapCatAttachments.get(wrap.ProductId) != null)
                wrap.Level1CategoryImageURL = 'servlet/servlet.FileDownload?file='+mapCatAttachments.get(wrap.parentCategoryId).Id;
            //wrap.ContentUrl=objProdView.ContentUrl;
            String strKey = priceList.Id + ' ' + wrap.ProductId;
            if(objProdView.Apttus_Config2__ParentClassificationId__r.Apttus_Config2__AncestorId__r.Apttus_Config2__AncestorId__c == null)
                wrap.ancestorCategoryId = wrap.parentCategoryId;
            else
                wrap.ancestorCategoryId = objProdView.Apttus_Config2__ParentClassificationId__r.Apttus_Config2__AncestorId__c;
            wrap.cat = objProdView.Apttus_Config2__ParentClassificationId__r.Apttus_Config2__AncestorId__r.Name;
            wrap.subCat = objProdView.Apttus_Config2__ParentClassificationId__r.Name;
            if(mapPirceItems.containsKey(strKey))
            {
                system.debug('strKey == '+strKey);
                Apttus_Config2__PriceListItem__c objPriceItem = mapPirceItems.get(strKey);
                system.debug('objPriceItem == '+objPriceItem);
                // for contracted Pricing
                if(mapProdIdVsContractedPLI != null){
                    if(mapProdIdVsContractedPLI.containsKey(wrap.ProductId)){
                            wrap.PriceItem = mapProdIdVsContractedPLI.get(wrap.ProductId);
                            wrap.isContracted = true;
                            wrap.PriceItem2 = objPriceItem;
                    }else{
                            wrap.PriceItem = objPriceItem;
                            wrap.isContracted = false;
                    }
                }else{
                    wrap.PriceItem = objPriceItem;
                    wrap.isContracted = false;
                }
                //wrap.PriceItem = objPriceItem;
                wrap.HasPrices=true;
                //wrap.Prices = new List<Apttus_CPQApi.CPQ.PriceDO>{obj.PriceDO};
                //
                wrap.hasOptions = objProdView.Apttus_Config2__ChildProductId__r.Apttus_Config2__HasOptions__c;
                wrap.mustConfigure = objProdView.Apttus_Config2__ChildProductId__r.Apttus_Config2__Customizable__c;

                wrap.hasAttributes = objProdView.Apttus_Config2__ChildProductId__r.Apttus_Config2__HasAttributes__c;


            }
            wrap.Quantity=1;
            if(wrap.PriceItem != null)
                lstProductwrapAll.add(wrap);

        }
            if(refinesearchstringarray != null) {
            String querystr = '';

            List<String> AIPValuesList = new List<String>();
            for(String s : refinesearchstringarray) {
                if(String.isNotEmpty(s.trim())){
                    AIPValuesList.add(s);
                    querystr += s+',';
                }
            }

            system.debug('*************AIPValuesList '+ AIPValuesList);
            system.debug('*************AIPValuesListSize '+ AIPValuesList.size());
           // system.debug('lstProductwrapAll==='+lstProductwrapAll);
            querystr = 'SELECT '+querystr + 'ID FROM Product2';
            //system.debug('****************querystr'+querystr);
            List<Product2> prorefinesearch = Database.query(querystr);
            //Integer i = 0;
            for(Product2 tempref: prorefinesearch) {
                for(APTSMD_ProductWrapperClass tempref2 : lstProductwrapAll) {
                    if(tempref.Id == tempref2.ProductId) {
                        //system.debug('*************tempref '+ tempref);
                        //system.debug('*************tempref2 '+ tempref2);
                        String refineSearch = '';
                        for(Integer i = 0; i<AIPValuesList.size(); i++){
                            if(tempref.getSobjectType().getDescribe().fields.getMap().containsKey(AIPValuesList.get(i))){
                                system.debug('*************temprefValue '+ tempref.get(AIPValuesList.get(i)));
                                if(tempref.get(AIPValuesList.get(i)) != null){
                                    //system.debug('*************AIPValues '+ AIPValuesList.get(i));
                                    if(refineSearch==null){
                                         //system.debug('*************API Name Value1'+ tempref.get(AIPValuesList.get(i)));
                                         //system.debug('*************API Name Value1'+  String.valueOf(tempref.get(AIPValuesList.get(i))));
                                         refineSearch  = String.valueOf(tempref.get(AIPValuesList.get(i)));
                                    } else{
                                        //system.debug('*************API Name Value2'+ tempref.get(AIPValuesList.get(i)));
                                        //system.debug('*************API Name Value2'+  String.valueOf(tempref.get(AIPValuesList.get(i))));
                                        refineSearch  = refineSearch +','+ String.valueOf(tempref.get(AIPValuesList.get(i)));
                                    }
                                }else{
                                    //system.debug('*************value is not available'+ tempref.get(AIPValuesList.get(i)));
                                }
                            }else{
                                //system.debug('*************API Name '+ AIPValuesList.get(i) + ' not exists');
                            }
                        }
                        if(refineSearch!=null){
                            //system.debug('*************Print Value ******** ');
                            tempref2.Refinesearchstring =  refineSearch;
                            //system.debug('***************tempref2.Refinesearchstring'+tempref2.Refinesearchstring);
                        }
                    }

                }
            }

        }

        return lstProductwrapAll;

    }
    //MNS -
    public static Map<Id,Product2> prepareProductMap(Set<Id> prodIds){
        Map<Id,Product2> returnMap= new Map<Id,Product2>();
        DescribeSObjectResult describeResult = Product2.SObjectType.getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = 'SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName()+ ' WHERE ' + ' Id IN:prodIds';
        // return generic list of sobjects or typecast to expected type
        System.debug('>>>Query : '+query);
        List<Product2> prodList = Database.query( query );
        for(Product2 prod : prodList){
            returnMap.put(prod.Id,prod);
        }
        return returnMap;

    }
    //Code to retrieve Guided Products - By Mayur
    public static List<APTSMD_ProductWrapperClass> getGuidedProducts(String PLId,String cplid)
    {
       String whereCls = 'where APTSMD_GuidedProducts__c=TRUE';
        return getSpecialProducts(whereCls,PLId,cplid);
    }

    public static List<APTSMD_ProductWrapperClass> getTopDealProducts(String prodIds,String PLId,String cplid)
    {
        List<APTSMD_ProductWrapperClass> productListToreturn = new List<APTSMD_ProductWrapperClass>();
        List <String> prodIdsList = prodIds.split('#');
        prodIds = prodIds.replaceAll('#','\',\'');
        String inClause='(\''+prodIds+'\')';
        String whereCls = 'where id IN '+inClause ;
        List<APTSMD_ProductWrapperClass> productList= getSpecialProducts(whereCls,PLId,cplid);
        for(String s : prodIdsList){
            for (APTSMD_ProductWrapperClass prodWrap : productList){
                if(s==prodWrap.ProductId){
                    productListToreturn.add(prodWrap);
                }
            }
        }

        return productListToreturn;
    }

    public static List<APTSMD_ProductWrapperClass> getPickedUpProducts(String prodIds,String PLId,String cPlid)
    {
       List<APTSMD_ProductWrapperClass> productListToreturn = new List<APTSMD_ProductWrapperClass>();
        List <String> prodIdsList = prodIds.split('#');
        prodIds = prodIds.replaceAll('#','\',\'');
        String inClause='(\''+prodIds+'\')';
        String whereCls = 'where id IN '+inClause ;
        List<APTSMD_ProductWrapperClass> productList= getSpecialProducts(whereCls,PLId,cPlid);
        for(String s : prodIdsList){
            for (APTSMD_ProductWrapperClass prodWrap : productList){
                if(s==prodWrap.ProductId){
                    productListToreturn.add(prodWrap);
                }
            }
        }

        return productListToreturn;
    }

    public static List<APTSMD_ProductWrapperClass> getPastOrderProducts(String prodIds,String PLId,String cPlid)
    {
       List<APTSMD_ProductWrapperClass> productListToreturn = new List<APTSMD_ProductWrapperClass>();
        List <String> prodIdsList = prodIds.split('#');
        prodIds = prodIds.replaceAll('#','\',\'');
        String inClause='(\''+prodIds+'\')';
        String whereCls = 'where id IN '+inClause ;
        List<APTSMD_ProductWrapperClass> productList= getSpecialProducts(whereCls,PLId,cPlid);
        for(String s : prodIdsList){
            for (APTSMD_ProductWrapperClass prodWrap : productList){
                if(s==prodWrap.ProductId){
                    productListToreturn.add(prodWrap);
                }
            }
        }

        return productListToreturn;
    }


    public static List<APTSMD_ProductWrapperClass> getSpecialProducts(String whereClause,String PLId,String cPlid){
         //Id priceListId = 'a2nc0000000DAAB';
        String contractpricelist = cPlid;
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        //Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
        Account objUserAcc = [select id,APTSMD_Dealer_del__c,APTSMD_Pricing_Agreement_Number__c  from Account where id =: objContact.accountId];
        Map<Id,Apttus_Config2__ProductTranslation__c> mapPdtTranslations = new  Map<Id,Apttus_Config2__ProductTranslation__c>();
        for(Apttus_Config2__ProductTranslation__c pdtTranslation : [SELECT APTSDMP_Ecomm_Frequency__c,Apttus_Config2__Description__c,Apttus_Config2__Family__c,Apttus_Config2__Language__c,Apttus_Config2__Name__c,Apttus_Config2__ProductCode__c,Apttus_Config2__ProductId__c,APTSDMP_Ecomm_Product_Description_1__c,APTSDMP_Ecomm_Product_Description_2__c,APTSDMP_Ecomm_Product_Description_3__c,APTSDMP_Ecomm_Product_Description_4__c,APTSDMP_Ecomm_Product_Description_5__c,APTSMD_Long_Description__c FROM Apttus_Config2__ProductTranslation__c WHERE Apttus_Config2__Language__c=:UserInfo.getLanguage()])
        {
        		mapPdtTranslations.put(pdtTranslation.Apttus_Config2__ProductId__c,pdtTranslation);
        }

        Apttus_Config2__PriceList__c priceList;
        if(PLId != null){
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where id=:PLId limit 1];
        }
        //Code for Contractged Pricing - Mayur
        Map<String,Apttus_Config2__PriceListItem__c> mapProdIdVsContractedPLI;
        if(UserInfo.getUserType() != 'Guest'){ //check Contract pricing only if User is login
            if(objUserAcc.APTSMD_Pricing_Agreement_Number__c != null ) {
                    mapProdIdVsContractedPLI = getContractedPrices(objUserAcc.APTSMD_Pricing_Agreement_Number__c,contractpricelist);
            }
        }
       /* if(objUserAcc.APTSMD_Pricing_Agreement_Number__c != null ) {
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where Apttus_Config2__ContractNumber__c =: objUserAcc.APTSMD_Pricing_Agreement_Number__c limit 1];
        }else{
            priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];
        }
        */
        //Apttus_Config2__PriceList__c priceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];

       // Apttus_Config2__PriceList__c priceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c =: 'Chicago' limit 1];
        Map<String,Apttus_Config2__PriceListItem__c> mapPirceItems = new Map<String,Apttus_Config2__PriceListItem__c>();
        for(Apttus_Config2__PriceListItem__c objLineItem : [select id,Apttus_Config2__ListPrice__c,Apttus_Config2__MaxPrice__c,Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__AllowManualAdjustment__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__AllowProration__c,Apttus_Config2__Active__c,Apttus_Config2__AllocateGroupAdjustment__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__PriceListId__c =: priceList.Id ])
        {
            String strKey = objLineItem.Apttus_Config2__PriceListId__c + ' ' + objLineItem.Apttus_Config2__ProductId__c;
            mapPirceItems.put(strKey,objLineItem);
        }
        system.debug('mapPirceItems == '+mapPirceItems);
        Map<Id,Attachment> mapProdAttachments = new Map<Id,Attachment>();
        Map<Id,Attachment> mapCatAttachments = new Map<Id,Attachment>();
        for(Attachment objAttach : [select id,name,parentId,parent.Name from Attachment where parentId in (select id from product2)])
        {
            if(String.valueOf(objAttach.parentId).startsWith('01t'))
            {
                mapProdAttachments.put(objAttach.parentId,objAttach);
            }
            if(String.valueOf(objAttach.parentId).startsWith('a2H'))
            {
                mapCatAttachments.put(objAttach.parentId,objAttach);
            }

        }

        system.debug('Category== '+priceList.Apttus_Config2__Categories__r);
        system.debug('mapPirceItems == '+mapPirceItems);
        //Id levelZeoCategoryID = 'a2Ic0000000DMZiEAO';
        Apttus_Config2__ClassificationName__c objClassification = [select id from Apttus_Config2__ClassificationName__c where Apttus_Config2__Active__c =: true and Id =: priceList.Apttus_Config2__Categories__r.get(0).Apttus_Config2__HierarchyId__c];
        lstProductwrapAll = New List<APTSMD_ProductWrapperClass>();
        //String query = 'select id,Name,APTSMD_product_rating_indicator_src__c,APTSCU_Availability__c,APTSMD_Rating__c,APTSMD_is_Comparable__c,ProductCode,Description,Family,APTSMD_SearchDescription__c,APTSMD_GuidedProducts__c,Apttus_Config2__HasOptions__c,Apttus_Config2__Customizable__c,Apttus_Config2__HasAttributes__c,APTSMD_Rebates__c,APTSMD_Loyalty__c,APTSMD_Promotions__c from Product2 '+whereClause;
        DescribeSObjectResult describeResult = Product2.SObjectType.getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = 'SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName()+ ' '+whereClause;
        System.debug('>>> Query : '+query);
        List<product2> productList = Database.query(query);
        for(Product2 objProdView : productList)
        {
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass(objProdView.id);
            //if(objProdView.Apttus_Config2__ChildProductId__r.ProductCode != '16OZSEALS' && objProdView.Apttus_Config2__ChildProductId__r.ProductCode != 'ININK67') continue;
            //if(objProdView.Apttus_Config2__ChildProductId__r.ProductCode != 'ISINK2') continue;
            wrap.productDetails = objProdView;
            wrap.ProductId = objProdView.id;
            wrap.ProductCode= objProdView.ProductCode;
            wrap.longDescription = objProdView.APTSMD_Long_Description__c;
            wrap.isComparable= objProdView.APTSMD_is_Comparable__c;
            wrap.ProductName=objProdView.Name;
            wrap.ratingURL=objProdView.APTSMD_product_rating_indicator_src__c;
            wrap.loyalty = objProdView.APTSMD_Loyalty__c;
            wrap.rebate = objProdView.APTSMD_Rebates__c;
            wrap.promotions = objProdView.APTSMD_Promotions__c;
            wrap.rating= objProdView.APTSMD_Rating__c;
            wrap.availability=objProdView.APTSCU_Availability__c;
            wrap.isGuidedProd = objProdView.APTSMD_GuidedProducts__c;   //By Mayur
            wrap.Description=objProdView.Description;
            wrap.SearchDescription = objProdView.APTSMD_SearchDescription__c;
            wrap.hasOptions = objProdView.Apttus_Config2__HasOptions__c;
            wrap.mustConfigure = objProdView.Apttus_Config2__Customizable__c;
            wrap.hasAttributes = objProdView.Apttus_Config2__HasAttributes__c;
            wrap.eCommDesc1 = objProdView.APTSDMP_Ecomm_Product_Description_1__c;
            wrap.eCommDesc2 = objProdView.APTSDMP_Ecomm_Product_Description_2__c;
            wrap.eCommDesc3 = objProdView.APTSDMP_Ecomm_Product_Description_3__c;
            wrap.eCommDesc4 = objProdView.APTSDMP_Ecomm_Product_Description_4__c;
            wrap.eCommDesc5 = objProdView.APTSDMP_Ecomm_Product_Description_5__c;
            wrap.frequency = objProdView.APTSDMP_Ecomm_Frequency__c;

            if(mapPdtTranslations.size()>0)
            {
            	if(mapPdtTranslations.containsKey(objProdView.Id))
            	{
	            	Apttus_Config2__ProductTranslation__c objPdtTranslation =  mapPdtTranslations.get(objProdView.Id);
	            	system.debug('objPdtTranslation===='+objPdtTranslation);
	            	wrap.ProductName=objPdtTranslation.Apttus_Config2__Name__c;
	            	wrap.Description=objPdtTranslation.Apttus_Config2__Description__c;
                    wrap.ProductCode= objPdtTranslation.Apttus_Config2__ProductCode__c;
                    wrap.eCommDesc1 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_1__c;
                    wrap.eCommDesc2 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_2__c;
                    wrap.eCommDesc3 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_3__c;
                    wrap.eCommDesc4 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_4__c;
                    wrap.eCommDesc5 = objPdtTranslation.APTSDMP_Ecomm_Product_Description_5__c;
                    wrap.longDescription = objPdtTranslation.APTSMD_Long_Description__c;
                    wrap.family = objPdtTranslation.Apttus_Config2__Family__c;
                    wrap.frequency = objPdtTranslation.APTSDMP_Ecomm_Frequency__c;
	            }
            }

            //wrap.parentCategoryId = objProdView.Apttus_Config2__ParentClassificationId__c;
            if(mapProdAttachments.containsKey(wrap.ProductId) && mapProdAttachments.get(wrap.ProductId) != null)
                wrap.ImageUrl = 'servlet/servlet.FileDownload?file='+mapProdAttachments.get(wrap.ProductId).Id;
            if(mapCatAttachments.containsKey(wrap.ProductId) && mapCatAttachments.get(wrap.ProductId) != null)
                wrap.Level1CategoryImageURL = 'servlet/servlet.FileDownload?file='+mapCatAttachments.get(wrap.parentCategoryId).Id;
            //wrap.ContentUrl=objProdView.ContentUrl;
            String strKey = priceList.Id + ' ' + wrap.ProductId;

            if(mapPirceItems.containsKey(strKey))
            {
                system.debug('strKey == '+strKey);
                Apttus_Config2__PriceListItem__c objPriceItem = mapPirceItems.get(strKey);
                system.debug('objPriceItem1  == '+objPriceItem);

                // for contracted Pricing
                if(mapProdIdVsContractedPLI != null){
                    if(mapProdIdVsContractedPLI.containsKey(wrap.ProductId)){
                            wrap.PriceItem = mapProdIdVsContractedPLI.get(wrap.ProductId);
                            wrap.isContracted = true;
                            wrap.PriceItem2 = objPriceItem;
                    }else{
                            wrap.PriceItem = objPriceItem;
                            wrap.isContracted = false;
                    }
                }else{
                    wrap.PriceItem = objPriceItem;
                    wrap.isContracted = false;
                }
                //wrap.PriceItem = objPriceItem;
                wrap.HasPrices=true;
                //wrap.Prices = new List<Apttus_CPQApi.CPQ.PriceDO>{obj.PriceDO};


            }
            wrap.Quantity=1;
            if(wrap.PriceItem != null)
                lstProductwrapAll.add(wrap);

        }
        System.debug('Wrap Prod'+ lstProductwrapAll);
        return lstProductwrapAll;
    }
    //Method to get Contracted Price for the given Agreement Number
    //Returns Map of Product Id => PLI object
    public static Map<String,Apttus_Config2__PriceListItem__c> getContractedPrices(String agreementNum,String contractpricelist){
        Map<String,Apttus_Config2__PriceListItem__c> retMap = new Map<String,Apttus_Config2__PriceListItem__c>();
        //  String storeId = apexpages.currentpage().getparameters().get('storeId');
        system.debug('#######Contract1');
        //User user = [select contactId from user where id = '00536000000JZbU'];
        // APTSMD_Store__c store = [SELECT Id,APTSMD_APTSMD_Contract_Price_List__c FROM APTSMD_Store__c WHERE id =: storeId];
         List<Apttus_Config2__PriceList__c> lstPriceList = new List<Apttus_Config2__PriceList__c>();
         system.debug('######3Contra---4'+contractpricelist);
        if(contractpricelist!=null && String.isNotEmpty(contractpricelist)) {
            system.debug('#######Contract'+contractpricelist);
          lstPriceList = [select id ,(Select Apttus_Config2__HierarchyId__c from Apttus_Config2__Categories__r) from Apttus_Config2__PriceList__c where id =: contractpricelist limit 1];
        }
        if(!lstPriceList.isEmpty()){
            Apttus_Config2__PriceList__c priceList = lstPriceList[0];
            for(Apttus_Config2__PriceListItem__c objLineItem : [select id,Apttus_Config2__ListPrice__c,Apttus_Config2__MaxPrice__c,Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__AllowManualAdjustment__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__AllowProration__c,Apttus_Config2__Active__c,Apttus_Config2__AllocateGroupAdjustment__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__PriceListId__c =: priceList.Id ]){
                    retMap.put(objLineItem.Apttus_Config2__ProductId__c,objLineItem);
            }
        }

        return retMap;
    }

    //MNS - Get recommended products by querying Constraint Rules
    // It will return the recommended product list
    public static List<APTSMD_ProductWrapperClass> getRecommendedProducts(String prodId, String pLId, String cPlid){
        Set<Id> suggestedProdId = getContraintRuleData(prodId);
        if(suggestedProdId != null && !suggestedProdId.isEmpty()){
            return prepareProductWrapper(suggestedProdId,pLId,cPlid);
        }
        return null;

    }

    public static Set<id> getContraintRuleData(String prodId){
        List<Apttus_Config2__ConstraintRuleCondition__c> ruleConditionList = [SELECT id,Name,Apttus_Config2__ProductId__c,Apttus_Config2__ConstraintRuleId__c,Apttus_Config2__MatchInPrimaryLines__c FROM Apttus_Config2__ConstraintRuleCondition__c WHERE Apttus_Config2__ProductId__c=:prodId AND Apttus_Config2__ProductScope__c='Product' AND Apttus_Config2__MatchInPrimaryLines__c=TRUE AND Apttus_Config2__ConstraintRuleId__r.Apttus_Config2__Active__c=TRUE];
        Set<Id> constraintRuleIds = new Set<Id>();
        Set<Id> returnSet = new Set<Id>();
        if(!ruleConditionList.isEmpty()){
            for(Apttus_Config2__ConstraintRuleCondition__c obj : ruleConditionList){
                constraintRuleIds.add(obj.Apttus_Config2__ConstraintRuleId__c);
            }
            List<Apttus_Config2__ConstraintRuleAction__c> ruleActionList = [SELECT id,Name,Apttus_Config2__ProductId__c FROM Apttus_Config2__ConstraintRuleAction__c WHERE Apttus_Config2__ConstraintRuleId__c IN:constraintRuleIds AND Apttus_Config2__ActionType__c='Inclusion' AND Apttus_Config2__ActionIntent__c='Show Message' AND Apttus_Config2__ProductScope__c='Product'];
            if(!ruleActionList.isEmpty()){
                for(Apttus_Config2__ConstraintRuleAction__c action : ruleActionList){
                    returnSet.add(action.Apttus_Config2__ProductId__c);
                }
                return returnSet;
            }
        }
        return null;
    }
    /*
     * MNS -  this method perepares the poduct wrappers
     * @param: product ids, price list and contracted price list
     * @return: List<APTSMD_ProductWrapperClass>
    */
    public static List<APTSMD_ProductWrapperClass> prepareProductWrapper(Set<Id> prodIds,String pLId, String cPlid){
        List<APTSMD_ProductWrapperClass> returnList = new List<APTSMD_ProductWrapperClass>();

        //prepare contract pricing map
        Map<String,Apttus_Config2__PriceListItem__c> mapProdIdVsContractedPLI;
        if(UserInfo.getUserType() != 'Guest'){ //check Contract pricing only if User is login
            mapProdIdVsContractedPLI = getContractedPrices('',cPlid);
        }
        //prepare normal price map
        Map<String,Apttus_Config2__PriceListItem__c> mapPirceItems = new Map<String,Apttus_Config2__PriceListItem__c>();
        for(Apttus_Config2__PriceListItem__c objLineItem : [select id,Apttus_Config2__ListPrice__c,Apttus_Config2__MaxPrice__c,Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__PriceIncludedInBundle__c,Apttus_Config2__AllowManualAdjustment__c,Apttus_Config2__PriceType__c,Apttus_Config2__PriceUom__c,Apttus_Config2__AllowProration__c,Apttus_Config2__Active__c,Apttus_Config2__AllocateGroupAdjustment__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__PriceListId__c =:pLId ])
        {
            String strKey = objLineItem.Apttus_Config2__PriceListId__c + '#' + objLineItem.Apttus_Config2__ProductId__c;
            mapPirceItems.put(strKey,objLineItem);
        }

        //to get attachment ids
        Map<Id,Attachment> mapProdAttachments = new Map<Id,Attachment>();
        for(Attachment objAttach : [select id,name,parentId,parent.Name from Attachment where parentId in: prodIds]){
            mapProdAttachments.put(objAttach.parentId,objAttach);
        }


        List<product2> productList = [select id,Name,APTSMD_product_rating_indicator_src__c,APTSCU_Availability__c,APTSMD_Rating__c,APTSMD_is_Comparable__c,ProductCode,Description,Family,APTSMD_SearchDescription__c,APTSMD_GuidedProducts__c,Apttus_Config2__HasOptions__c,Apttus_Config2__Customizable__c,Apttus_Config2__HasAttributes__c,APTSMD_Rebates__c,APTSMD_Loyalty__c,APTSMD_Promotions__c from Product2 WHERE Id IN: prodIds];
        for(Product2 objProdView : productList)
        {
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass(objProdView.id);
            wrap.ProductId = objProdView.id;
            wrap.ProductCode= objProdView.ProductCode;
            wrap.isComparable= objProdView.APTSMD_is_Comparable__c;
            wrap.ProductName=objProdView.Name;
            wrap.ratingURL=objProdView.APTSMD_product_rating_indicator_src__c;
            wrap.loyalty = objProdView.APTSMD_Loyalty__c;
            wrap.rebate = objProdView.APTSMD_Rebates__c;
            wrap.promotions = objProdView.APTSMD_Promotions__c;
            wrap.rating= objProdView.APTSMD_Rating__c;
            wrap.availability=objProdView.APTSCU_Availability__c;
            wrap.isGuidedProd = objProdView.APTSMD_GuidedProducts__c;   //By Mayur
            wrap.Description=objProdView.Description;
            wrap.SearchDescription = objProdView.APTSMD_SearchDescription__c;
            wrap.hasOptions = objProdView.Apttus_Config2__HasOptions__c;
            wrap.mustConfigure = objProdView.Apttus_Config2__Customizable__c;
            wrap.hasAttributes = objProdView.Apttus_Config2__HasAttributes__c;

            //wrap.parentCategoryId = objProdView.Apttus_Config2__ParentClassificationId__c;
            if(mapProdAttachments.containsKey(wrap.ProductId) && mapProdAttachments.get(wrap.ProductId) != null)
                wrap.ImageUrl = 'servlet/servlet.FileDownload?file='+mapProdAttachments.get(wrap.ProductId).Id;



            String strKey = pLId+ '#' + wrap.ProductId;

            if(mapPirceItems.containsKey(strKey))
            {
                system.debug('strKey == '+strKey);
                Apttus_Config2__PriceListItem__c objPriceItem = mapPirceItems.get(strKey);
                system.debug('objPriceItem1  == '+objPriceItem);

                // for contracted Pricing
                if(mapProdIdVsContractedPLI != null){
                    if(mapProdIdVsContractedPLI.containsKey(wrap.ProductId)){
                            wrap.PriceItem = mapProdIdVsContractedPLI.get(wrap.ProductId);
                            wrap.isContracted = true;
                            wrap.PriceItem2 = objPriceItem;
                    }else{
                            wrap.PriceItem = objPriceItem;
                            wrap.isContracted = false;
                    }
                }else{
                    wrap.PriceItem = objPriceItem;
                    wrap.isContracted = false;
                }
                //wrap.PriceItem = objPriceItem;
                wrap.HasPrices=true;

            }
            wrap.Quantity=1;
            if(wrap.PriceItem != null)
                returnList.add(wrap);
        }
        return returnList;
    }


}