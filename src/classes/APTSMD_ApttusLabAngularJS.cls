global without sharing class APTSMD_ApttusLabAngularJS {

    public String accountName { get; set; }
    public String accountEmail { get; set; }
    public String isValidUser {get;set;}
    public String loginUser {get;set;}
    public Boolean userSupportedRegion {get;set;}
    public String loginPassword {get;set;}
    public String searchFilterRefine{get;set;}
    public string productReviewList{get;set;}
    public string strlstProductwrapAll{get;set;}
    public String searchFilterRefinedynamic{get;set;}
    public String refinesearchque {get;set;}
    public string mode{get;set;}
    public string loginMessage {get;set;}
    public Boolean APTSMD_showErrorLogin {get;set;}
    public string currencySym{get;set;}
    public string store{get;set;}
    public string title{get;set;}
    public string topDealProdIds{get;set;}
    public string weHavePickedProdIds{get;set;}
    public string pastOrderProdIds{get;set;}
    public String logo{get;set;}
    public String banner {get;set;}
    public String promoImagesJSON {get;set;}
    public String storePriceList {get;set;}
    public String contractpriceliststore {get; set;}
    public String Cybersource {get; set;}
    public static Set<String> fieldvalueapiname {get;set;}
    public static APTSMD_CyberSource_CC_AuthRequest  authreq;
    public static APTSMD_eCom_CallOutResult resultcard;
    public static string resultmessage{get;set;}
    public APTSMD_Store__c storeRecord {get;set;}
    public String fieldsetNameVsLabelJson{get;set;}
    public String topCategoryName{get;set;}
    public String userLogoURL{get;set;}
    public decimal dExchangeRate{get;set;}
    public String CategoryLabel{get;set;}
    public String UserLanguage{get;set;}

    public String localAccountId{get{return '0015800000Z3OUZAA3';}}
    public String accountId{get;set;}


    public APTSMD_ApttusLabAngularJS instance{get{return this;} private set;}

    public APTSMD_ApttusLabAngularJS() {
        fieldvalueapiname = new set<String>();
        authreq=new APTSMD_CyberSource_CC_AuthRequest();
        resultcard=new APTSMD_eCom_CallOutResult();
        store='';
        topDealProdIds = '';
        weHavePickedProdIds = '';
        pastOrderProdIds = '';
        logo='';
        storePriceList ='';
        Cybersource = '';
        banner='';
        contractpriceliststore ='';
        List<String> promoImages = new List<String>();
        String storeId = apexpages.currentpage().getparameters().get('storeId');
        APTSMD_Store__c storeRecord;
        dExchangeRate = 0.00;

        try{
            User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            accountId = [SELECT AccountId FROM Contact WHERE Id = :u.ContactId].AccountId;
        }catch(QueryException e){System.debug(LoggingLevel.ERROR, e.getMessage());}


        if(storeId != null){
            DescribeSObjectResult describeResult = APTSMD_Store__c.SObjectType.getDescribe();
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            String query = 'SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName()+ ' WHERE ' + ' Id=\''+storeId+'\'';
            // return generic list of sobjects or typecast to expected type
            System.debug('>>>Query : '+query);
            List<APTSMD_Store__c> storeList = Database.query( query );
            if(!storeList.isEmpty()){
                storeRecord = storeList[0];
            }
             /*[select id,APTSMD_NumberOfProducts__c,APTSMD_Based_On_Past_Order_1__r.id,APTSMD_Credit_Card_Provider__c,APTSMD_Contract_Price_List__c,APTSMD_Based_On_Past_Order_2__r.id,APTSMD_Based_On_Past_Order_3__r.id,APTSMD_We_Have_Picked_Product_1__r.id,APTSMD_We_Have_Picked_Product_2__r.id,APTSMD_We_Have_Picked_Product_3__r.id,APTSMD_Banner_Image__c,APTSMD_Store_Logo__c,APTSMD_Promotion1__c,APTSMD_Promotion2__c,APTSMD_Promotion3__c,APTSMD_Top_Deal_Product_1__r.id,APTSMD_Top_Deal_Product_2__r.id,APTSMD_Top_Deal_Product_3__r.id,APTSMD_Price_List__c,APTSMD_Action_Color__c,APTSMD_Header_Color__c,APTSMD_Accent_Color__c,APTSMD_Page_Title__c
                                    FROM APTSMD_Store__c
                                    WHERE id=:storeId]; */


            store = JSON.serialize(storeRecord);
            title='TIER 1';
            if(storeRecord != null){
                storePriceList = storeRecord.APTSMD_Price_List__c;
                 if(storeRecord.APTSMD_Contract_Price_List__c != null){
                    contractpriceliststore = storeRecord.APTSMD_Contract_Price_List__c;
                }
                if(storeRecord.APTSMD_Credit_Card_Provider__c != null){
                    Cybersource = storeRecord.APTSMD_Credit_Card_Provider__c;
                }

                if(storeRecord.APTSMD_Banner_Image__c != null){
                    banner = storeRecord.APTSMD_Banner_Image__c;
                }
                if(storeRecord.APTSMD_Store_Logo__c != null){
                    logo = storeRecord.APTSMD_Store_Logo__c;
                }
                if(storeRecord.APTSMD_Promotion1__c != null){
                    promoImages.add(storeRecord.APTSMD_Promotion1__c);
                }
                if(storeRecord.APTSMD_Promotion2__c != null){
                    promoImages.add(storeRecord.APTSMD_Promotion2__c);
                }
                if(storeRecord.APTSMD_Promotion3__c != null){
                    promoImages.add(storeRecord.APTSMD_Promotion3__c);
                }
                if(storeRecord.APTSMD_Page_Title__c != null){
                    title = storeRecord.APTSMD_Page_Title__c;
                }
                // Code Added By Mehul Parmar - Start ( Top Deal Section,Past Order Section,Specail Products Section )
                List<APTSMD_Product_Recommendation__c> allProductRecommendations = [select id,name,APTSMD_Product__c,APTSMD_Recommendation_Type__c from APTSMD_Product_Recommendation__c where APTSMD_Store__c =:storeId];
                if(!allProductRecommendations.isEmpty()){
                    for(APTSMD_Product_Recommendation__c recommendation : allProductRecommendations){
                        if(recommendation.APTSMD_Recommendation_Type__c == 'Top Deal'){
                            topDealProdIds += recommendation.APTSMD_Product__c+'#';
                        }
                        else if(recommendation.APTSMD_Recommendation_Type__c == 'Past Order'){
                            pastOrderProdIds += recommendation.APTSMD_Product__c+'#';
                        }
                        else{
                            weHavePickedProdIds +=recommendation.APTSMD_Product__c+'#';
                        }
                    }
                }

                // Code Added By Mehul Parmar - End



                // if(storeRecord.APTSMD_Top_Deal_Product_1__c != null){
                //     topDealProdIds += storeRecord.APTSMD_Top_Deal_Product_1__c+'#';
                // }
                // if(storeRecord.APTSMD_Top_Deal_Product_2__c != null){
                //     topDealProdIds += storeRecord.APTSMD_Top_Deal_Product_2__c+'#';
                // }
                // if(storeRecord.APTSMD_Top_Deal_Product_3__c != null){
                //     topDealProdIds += storeRecord.APTSMD_Top_Deal_Product_3__c+'#';
                // }

                // if(storeRecord.APTSMD_We_Have_Picked_Product_1__c != null){
                //     weHavePickedProdIds += storeRecord.APTSMD_We_Have_Picked_Product_1__c+'#';
                // }
                // if(storeRecord.APTSMD_We_Have_Picked_Product_2__c != null){
                //     weHavePickedProdIds += storeRecord.APTSMD_We_Have_Picked_Product_2__c+'#';
                // }
                // if(storeRecord.APTSMD_We_Have_Picked_Product_3__c != null){
                //     weHavePickedProdIds += storeRecord.APTSMD_We_Have_Picked_Product_3__c+'#';
                // }

                // if(storeRecord.APTSMD_Based_On_Past_Order_1__c != null){
                //     pastOrderProdIds += storeRecord.APTSMD_Based_On_Past_Order_1__c+'#';
                // }
                // if(storeRecord.APTSMD_Based_On_Past_Order_2__c != null){
                //     pastOrderProdIds += storeRecord.APTSMD_Based_On_Past_Order_2__c+'#';
                // }
                // if(storeRecord.APTSMD_Based_On_Past_Order_3__c != null){
                //     pastOrderProdIds += storeRecord.APTSMD_Based_On_Past_Order_3__c+'#';
                // }
                promoImagesJSON = JSON.serialize(promoImages);
            }
        }

        isValidUser = UserInfo.getUserType() == 'Guest' ? 'false' : 'true';
        loginMessage ='';
        userLogoURL = [SELECT SmallPhotoUrl FROM User WHERE User.ID =: UserInfo.getUserid() LIMIT 1].SmallPhotoUrl;
        List<APTSMD_CategoryWrapperClass> allWrappers = APTSMD_CategoriesUtils.getCategoriesForPriceList(storeRecord.APTSMD_Price_List__c);
        currencySym=populateCurrencyUser();
        dExchangeRate = getCurrencyExchangeRate();
         Set<String> categoriesIdSet = new Set<String>();
         CategoryLabel = Label.ecomm_Categories;
         UserLanguage = UserInfo.getLanguage();
         User u = [SELECT Id, APTSDMP_eCommerce_Region__c FROM User Where Id = :UserInfo.getUserId()];
         if(u.APTSDMP_eCommerce_Region__c == 'Supported Region')
            userSupportedRegion = true;
        else
            userSupportedRegion = false;
        // system.debug('Category Label NAme==='+System.Label.ecomm_Categories);
         //         system.debug('UserInfo==='+UserInfo.getLanguage());

       // List<categoryWrapperClass> allWrappers = (List<categoryWrapperClass>)JSON.deserialize(categories,List<categoryWrapperClass>.class);
       //Refine search code
        // for(APTSMD_categoryWrapperClass wrapCategory : allWrappers){
        //     categoriesIdSet.add(wrapCategory.Level1CategoryId);
        // }
        // end
        // for(APTSMD_categoryWrapperClass wrapCategory : allWrappers){
        //     categoriesIdSet.add(wrapCategory.Level1CategoryId);
        //     if(wrapCategory.lstChildCategories != null && wrapCategory.lstChildCategories.Size()>0) {
        //         for(APTSMD_categoryWrapperClass.childCategories temp : wrapCategory.lstChildCategories) {
        //             if(temp.strCategoryId != null) {
        //                 categoriesIdSet.add(temp.strCategoryId);

        //             }
        //         }

        //     }

        // }
        for(APTSMD_categoryWrapperClass wrapCategory : allWrappers){
            categoriesIdSet.add(wrapCategory.Level1CategoryId);
            if(wrapCategory.childcat != null && wrapCategory.childcat.Size()>0) {
                for(APTSMD_categoryWrapperClass temp : wrapCategory.childcat) {
                    if(temp.Level1CategoryId != null) {
                        categoriesIdSet.add(temp.Level1CategoryId);

                    }
                }

            }

        }
        system.debug('catgorySet************:'+categoriesIdSet);
        Map<String,String> apinameandcatID = new Map<String,String>();
        Map<String,String> labelnameandcatID = new Map<String,String>();

        Set<String> fieldvalue = new Set<String>();
        List<Apttus_Config2__ClassificationHierarchy__c> allClassification = [select id,name,Apttus_Config2__SearchFilterFields__c, APTSMD_Primary_Product__c from Apttus_Config2__ClassificationHierarchy__c  where id in : categoriesIdSet];
        for(Apttus_Config2__ClassificationHierarchy__c temp: allClassification ) {
        //system.debug('Mansi***************************2222'+ temp);
          //  system.debug('Mansi***************************2222'+ temp.Apttus_Config2__SearchFilterFields__c);
            if(temp.Apttus_Config2__SearchFilterFields__c != null) {
                 String[] tmpString = temp.Apttus_Config2__SearchFilterFields__c.split(';');
                //  fieldapiname = temp.Apttus_Config2__SearchFilterFields__c.split(';');
                 //system.debug('Mansi***************************1111'+ tmpString );
                For(String s : tmpString) {
                    fieldvalue.add(s);
                    fieldvalueapiname.add(s);
                    //system.debug('*****************fieldvalueapiname'+fieldvalueapiname);
                    String catids;
                           if(apinameandcatID.containsKey(s)) {
                               catids = apinameandcatID.get(s);

                           }
                           catids = catids +','+temp.Id;
                        //   mlist.add(f.getLabel());
                        //   groupMap.put(label,mlist);
                    apinameandcatID.put(s,catids);
            }

            }



        }
        Schema.DescribeFieldResult fieldResult = Apttus_Config2__ClassificationHierarchy__c.Apttus_Config2__SearchFilterFields__c.getDescribe();
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();
        List<String> productFields = new List<String>();
        List<String> fieldList = new List<String>();
        Map<String,String> refineSearchfieldNameValueMap = new Map<String,String>();
        Map<String,List<String>> groupMap = new Map<String,List<String>>();
        Schema.sObjectType sobject_type = Product2.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

        for(String temp: fieldvalue) {
            if(temp != null) {
                //Schema.Describefieldresult fieldResult1 = Schema.Apttus_Config2__ClassificationHierarchy__c.temp;
                 //fieldResult1 = fieldResult1.getSObjectField().getDescribe();
                 List<Schema.PicklistEntry> pick_list_values = field_map.get(temp).getDescribe().getPickListValues();
                 /*Schema.DescribeFieldResult fieldResult1 = Product2.Name.getDescribe();
                   List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();*/

                   for(Schema.picklistEntry f : pick_list_values){


                            //String fieldName = f.getValue().substring(0,currentFieldResult.getName().length()-3);
                            fieldList.add(f.getValue());
                            String apiName = f.getValue();
                            String label = field_map.get(temp).getDescribe().getLabel();
                           // system.debug('apinamedyn***********'+apinameandcatID);
                            for(String apinamedyn : apinameandcatID.keySet()) {
                                // String labelname = apinameandcatID.get(apinamedyn);
                                if(apinamedyn == temp) {
                                    labelnameandcatID.put(label,apinameandcatID.get(apinamedyn));
                                    system.debug('labelname**********'+labelnameandcatID);
                                }
                            }
                            //System.debug('f.getLabel() :'+f.getLabel());

                            refineSearchfieldNameValueMap.put(f.getLabel(),label);
                            // refinesearchdynamic.put(label,f.getLabel());

                            productFields.add(f.getLabel());
                            //System.debug('>>> refineSearchfieldNameValueMap : '+refineSearchfieldNameValueMap);

                            //refine search code
                            List<String> mlist;
                           if(groupMap.containsKey(label)) {
                               mlist = groupMap.get(label);

                           }else{
                               mlist = new List<String>();
                           }
                           mlist.add(f.getLabel());
                           groupMap.put(label,mlist);
                            System.debug('>>> groupMap : '+groupMap);
                            //refine search end

                    }
                    for (String str : groupMap.keySet())
                    {
                        //System.debug('LabelPicklist'+str);
                        //System.debug('LabelPicklistpicklistvalue'+groupMap.get(str));
                    }

            }



        }
        List<refineSearchParentWrapper> refineSearchParentListdynamic = new List<refineSearchParentWrapper>();
        for(String temp : groupMap.keySet()) {
            List<refineSearchChildWrapper> refineSearchchildListdynamic = new List<refineSearchChildWrapper>();
            for(String tempchild: groupMap.get(temp)) {
                refineSearchChildWrapper refinechilddyn = new refineSearchChildWrapper(tempchild);
                // refinechilddyn.name = tempchild;
                refineSearchchildListdynamic.add(refinechilddyn);
            }
            String catId = labelnameandcatID.get(temp);
            system.debug('**********CategoryString'+catId);
            refineSearchParentWrapper refinedyn = new refineSearchParentWrapper(temp,refineSearchchildListdynamic,catId);
            // refinedyn.refineSearchKey = temp;

            // refinedyn.wrapper = refineSearchchildListdynamic;
            refineSearchParentListdynamic.add(refinedyn);

        }
        system.debug('refinedyn************'+refineSearchParentListdynamic);
        searchFilterRefinedynamic= JSON.serialize(refineSearchParentListdynamic);
        refinesearchque = JSON.serialize(fieldvalue);
        // for(Schema.picklistEntry f : ple){
        //     //if(f.getLabel() == 'APTSCU_Availability__c' || f.getLabel() == 'APTSMD_Rating__c'){
        //     if(f.getLabel() == 'APTSMD_Rating__c'){
        //         //String fieldName = f.getValue().substring(0,currentFieldResult.getName().length()-3);
        //         fieldList.add(f.getValue());
        //         String apiName = f.getValue();
        //         String label = Schema.SObjectType.Product2.fields.getMap().get(apiName).getDescribe().getLabel();
        //         System.debug('f.getLabel() :'+f.getLabel());

        //         refineSearchfieldNameValueMap.put(f.getLabel(),label);
        //         productFields.add(f.getLabel());
        //         System.debug('>>> Product Fields : '+productFields);
        //     }
        // }

        Schema.SObjectType t = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult r = t.getDescribe();
        MAP<String,Schema.SObjectField> productFieldsMap = r.fields.getMap();

        List<String> productFieldsToEncode = new List<String>();
        List<String> productFieldsNotToEncode = new List<String>();

        Map<String,String> searchFieldValuesMap2 = new Map<String,String>();
        Map<String,List<String>> searchFieldValuesMap = new Map<String,List<String>>();

        for(String productField : productFieldsMap.keySet()) {
            Schema.DescribeFieldResult currentFieldResult = productFieldsMap.get(productField).getDescribe();

            // Add fieldName to the set to create object in javascript
            if(productField.contains(currentFieldResult.getName())) {
                if(currentFieldResult.getType() == Schema.DisplayType.String || currentFieldResult.getType() == Schema.DisplayType.Textarea || currentFieldResult.getType() == Schema.DisplayType.Picklist) {
                    //if(currentFieldResult.getName() == 'APTSCU_Availability__c' || currentFieldResult.getName() == 'APTSMD_Rating__c'){
                    if(currentFieldResult.getName() == 'APTSMD_Rating__c'){
                        String fieldName = currentFieldResult.getName().substring(0,currentFieldResult.getName().length()-3);
                        productFieldsToEncode.add(fieldName);
                    }
                }else{
                     //if(currentFieldResult.getName() == 'APTSCU_Availability__c' || currentFieldResult.getName() == 'APTSMD_Rating__c'){
                     if(currentFieldResult.getName() == 'APTSMD_Rating__c'){
                         String fieldName = currentFieldResult.getName().substring(0,currentFieldResult.getName().length()-3);
                        productFieldsNotToEncode.add(fieldName);
                    }
                    //productFieldsNotToEncode.add(currentFieldResult.getName());
                }
            }

            for(String currentField : fieldList){
                if(!currentField.equalsIgnoreCase(currentFieldResult.getName()))
                    continue;

                List<Schema.picklistEntry> currentPLE = currentFieldResult.getPicklistValues();
                List<String> currentfieldList = new List<String>();
                String currentFieldValueString;

                for(Schema.picklistEntry f:currentPLE) {
                    if(!f.getValue().equalsIgnoreCase('Out Of Stock')){
                    currentfieldList.add(f.getValue());
                    if(currentFieldValueString == null || currentFieldValueString == ''){
                        currentFieldValueString = f.getValue();
                    }
                    else{
                        currentFieldValueString = currentFieldValueString + ';' + f.getValue();
                    }
                    }
                }

                String fieldName = currentField.substring(0,currentField.length()-3);
                if(fieldName.indexOf('APTSCU_') > -1 || fieldName.indexOf('APTSMD_') > -1){
                    fieldName = fieldName.substring(7,fieldName.length());
                }
                searchFieldValuesMap.put(fieldName,currentfieldList);
                searchFieldValuesMap2.put(fieldName,currentFieldValueString);
            }

        }
        for(String map1 :searchFieldValuesMap.keySet()){
            System.debug(map1 + ':' +searchFieldValuesMap.get(map1));
        }
        System.debug('New One');
        for(String map2 :searchFieldValuesMap2.keySet()){
            System.debug(map2 + ':' +searchFieldValuesMap2.get(map2));
        }
        List<refineSearchParentWrapper> refineSearchParentList = new List<refineSearchParentWrapper>();
        for(String str : searchFieldValuesMap.keySet()){
            List<refineSearchChildWrapper> wrapperList = new List<refineSearchChildWrapper>();
            List<String> allData = searchFieldValuesMap.get(str);
            for(String strData : allData){
                refineSearchChildWrapper wrap = new refineSearchChildWrapper(strData);
               wrapperList.add(wrap);
            }
            refineSearchParentWrapper parentWrapper = new refineSearchParentWrapper(str,wrapperList,null);
            refineSearchParentList.add(parentWrapper);
        }
        searchFilterRefine = JSON.serialize(refineSearchParentList);


        // Code - Rudra (Start)

        List<APTSMD_Product_Review__c> allReviews = [select id,name,APTSMD_Product__c,APTSMD_Rating__c,APTSMD_Review__c from APTSMD_Product_Review__c];
        productReviewList = JSON.serialize(allReviews);




        Map<string,APTSMD_ProductWrapperClass> prodIdVsProductWrapperClass = new Map<string,APTSMD_ProductWrapperClass>();
        List<APTSMD_ProductWrapperClass> lstProductwrapAll = New List<APTSMD_ProductWrapperClass>();
        List<product2> result=[select id,Name,Description,ProductCode, APTSMD_Long_Description__c, family, APTSDMP_Target_Group__c, APTSDMP_Objective__c, APTSDMP_Prerequisites__c, APTSDMP_Contents__c, APTSDMP_Remarks__c, APTSDMP_Ecomm_Product_Description_1__c, APTSDMP_Ecomm_Product_Description_2__c, APTSDMP_Ecomm_Product_Description_3__c, APTSDMP_Ecomm_Product_Description_4__c, APTSDMP_Ecomm_Product_Description_5__c from product2 WHERE APTSDMP_Show_in_Ecommerce__c = TRUE];
        For(product2 catresult : result) {
            APTSMD_ProductWrapperClass wrap = New APTSMD_ProductWrapperClass (catresult.id);
            wrap.ProductId = catresult.id;
            wrap.ProductCode= catresult.ProductCode;
            wrap.ProductName=catresult.Name;
            wrap.Description=catresult.Description;
            wrap.family = catresult.family;
            /*wrap.target = catresult.APTSDMP_Target_Group__c;
            wrap.objective = catresult.APTSDMP_Objective__c;
            wrap.prereqs = catresult.APTSDMP_Prerequisites__c;
            wrap.contents = catresult.APTSDMP_Contents__c;
            wrap.remarks = catresult.APTSDMP_Remarks__c;*/
            wrap.longDescription = catresult.APTSMD_Long_Description__c;
            wrap.eCommDesc1 = catresult.APTSDMP_Ecomm_Product_Description_1__c;
            wrap.eCommDesc1 = catresult.APTSDMP_Ecomm_Product_Description_2__c;
            wrap.eCommDesc1 = catresult.APTSDMP_Ecomm_Product_Description_3__c;
            wrap.eCommDesc1 = catresult.APTSDMP_Ecomm_Product_Description_4__c;
            wrap.eCommDesc1 = catresult.APTSDMP_Ecomm_Product_Description_5__c;
            //wrap.Prices=catresult.Prices;
            prodIdVsProductWrapperClass.put(catresult.id,wrap);
            lstProductwrapAll.add(wrap);
        }
        //-------Quering all reviews and wrapping it up into variable wrap...
        List<APTSMD_Product_Review__c> allProdReview=[select APTSMD_Product__c,APTSMD_Rating__c,APTSMD_Review__c from APTSMD_Product_Review__c where APTSMD_Product__c in :prodIdVsProductWrapperClass.keyset()];
        for(APTSMD_Product_Review__c i : allProdReview){
            if(prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).reviews==NULL){
                prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).reviews= new List<APTSMD_Product_Review__c>();
            }
            prodIdVsProductWrapperClass.get(i.APTSMD_Product__c).reviews.add(i);
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

        strlstProductwrapAll=JSON.serialize(lstProductwrapAll);

        // Code - Rudra (End)

        prepareFieldSetMap();
        getTopCategoryName();
    }
    //MNS- gettopCategoryName
    public void getTopCategoryName(){
        List<Apttus_Config2__PriceListCategory__c> priceListCategory = [SELECT Id,Name,Apttus_Config2__HierarchyId__c FROM Apttus_Config2__PriceListCategory__c WHERE Apttus_Config2__PriceListId__c=:storePriceList];
        Map<Id,String> mapCategoryTranslations = new Map<Id,String>();
        for(Apttus_Config2__CategoryTranslation__c obj :[Select Id,Name,Apttus_Config2__CategoryHierarchy__c From Apttus_Config2__CategoryTranslation__c Where Apttus_Config2__Language__c=:UserInfo.getLanguage()])
         {
            mapCategoryTranslations.put(obj.Apttus_Config2__CategoryHierarchy__c,obj.Name);
         }
         system.debug('mapCategoryTranslations==='+mapCategoryTranslations);
        if(!priceListCategory.isEmpty()){
            List<Apttus_Config2__ClassificationHierarchy__c> classificationHir = [SELECT Id,Name,Apttus_Config2__Label__c FROM Apttus_Config2__ClassificationHierarchy__c WHERE Apttus_Config2__HierarchyId__c=:priceListCategory[0].Apttus_Config2__HierarchyId__c AND Apttus_Config2__AncestorId__c=NULL AND Apttus_Config2__PrimordialId__c=NULL];
           if(!classificationHir.isEmpty())
           {
                if(mapCategoryTranslations.containsKey(classificationHir[0].Id))
                {
                    topCategoryName = mapCategoryTranslations.get(classificationHir[0].Id);
                }
                else
                {
                topCategoryName = classificationHir[0].Apttus_Config2__Label__c;
                }
            }
        }
    }

    //MNS- FieldSet map
    public void prepareFieldSetMap(){
        Map<String,String> fieldsetNameVsLabelMap = new Map<String,String>();
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Product2.fieldSets.getMap().get('APTSMD_EcommerceFields').getFields();
        /*List<Schema.FieldSetMember> fields = new List<Schema.FieldSetMember>();
        for(Integer i=tempFields.size()-1;i>=0;i--){
            fields.add(tempFields.get(i));
        }*/

         for(Schema.FieldSetMember f : fields) {
            fieldsetNameVsLabelMap.put(f.getFieldPath(),f.getLabel());
        }
        fieldsetNameVsLabelJson = JSON.serialize(fieldsetNameVsLabelMap);

    }

    //end
     //card verfication
     @RemoteAction
     public static string createauthrequest(String authreqJson)
    {
        system.debug('inside apex'+authreqJson);
        authreqJson=authreqJson.substringBetween('[', ']');
        authreq = (APTSMD_CyberSource_CC_AuthRequest)JSON.deserialize(authreqJson, APTSMD_CyberSource_CC_AuthRequest.class);
        system.debug(' final authreq :'+authreq);
        resultcard=authorizeCreditCard(authreq);
        system.debug('result :'+resultcard);
        resultmessage=resultcard.message;
        system.debug('resultmessage :'+resultmessage);
        return resultmessage;
    }
    //By Mayu-- get currency
    public String populateCurrency(String plId){
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact con = user.contactId != null ? [select id,accountId, Account.APTSMD_Dealer_del__c from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        //Contact con = [Select Account.Name, Account.Dealer_del__c from Contact where Id =: user.ContactId];
        Apttus_Config2__PriceList__c priceList = [Select APTSMD_Currency__c from Apttus_Config2__PriceList__c where id=:plId LIMIT 1];

        return !String.isBlank(priceList.APTSMD_Currency__c)?priceList.APTSMD_Currency__c:'$';
    }

    public String populateCurrencyUser()
    {
        String curren = '€';
        if(UserInfo.getDefaultCurrency() == 'USD')
        {
            curren = '$';
        }
        if(UserInfo.getDefaultCurrency() == 'GBP')
        {
            curren = '£';
        }
        if(UserInfo.getDefaultCurrency() == 'HUF')
        {
            curren = 'Ft';
        }
        if(UserInfo.getDefaultCurrency() == 'CHF')
        {
            curren = 'CHF';
        }
        if(UserInfo.getDefaultCurrency() == 'PLN')
        {
            curren = 'zł';
        }
        if(UserInfo.getDefaultCurrency() == 'CZK')
        {
            curren = 'Kč';
        }
        if(UserInfo.getDefaultCurrency() == 'TRY')
        {
            curren = '₺';
        }
        if(UserInfo.getDefaultCurrency() == 'RUB')
        {
            curren = 'руб';
        }
        if(UserInfo.getDefaultCurrency() == 'SEK')
        {
            curren = 'kr';
        }
        if(UserInfo.getDefaultCurrency() == 'NOK')
        {
            curren = 'kr';
        }
        if(UserInfo.getDefaultCurrency() == 'CAD')
        {
            curren = '$';
        }
        if(UserInfo.getDefaultCurrency() == 'MXN')
        {
            curren = '$';
        }
        if(UserInfo.getDefaultCurrency() == 'BRL')
        {
            curren = 'R$';
        }
        if(UserInfo.getDefaultCurrency() == 'MYR')
        {
            curren = 'RM';
        }
        if(UserInfo.getDefaultCurrency() == 'KRW')
        {
            curren = '₩';
        }
        if(UserInfo.getDefaultCurrency() == 'INR')
        {
            curren = '₹';
        }
        if(UserInfo.getDefaultCurrency() == 'TWD')
        {
            curren = 'NT$';
        }
        if(UserInfo.getDefaultCurrency() == 'JPY')
        {
            curren = '¥';
        }
        if(UserInfo.getDefaultCurrency() == 'CNY')
        {
            curren = '¥';
        }
        if(UserInfo.getDefaultCurrency() == 'AUD')
        {
            curren = '$';
        }
        if(UserInfo.getDefaultCurrency() == 'THB')
        {
            curren = '฿';
        }
        return curren;
    }
    // Code added by Mehul Parmar - Start
   @RemoteAction
    public static Map<string,APTSMD_ProductWrapperClass>  getProductDetails(String SelectedIds) {
         List<String> allIds = SelectedIds.split(',');
         Map<string,APTSMD_ProductWrapperClass> ProductIdMappedWithWrapper = new  Map<string,APTSMD_ProductWrapperClass>();
         Map<id, product2> productDetailsMap = new Map<Id,product2>([select id, Apttus_Config2__IconId__c, Apttus_Config2__Icon__c, Name,APTSMD_product_rating_indicator_src__c,APTSMD_Rating__c from product2 where Id in :allIds ORDER BY ID DESC]);
         for(Id prodId :productDetailsMap.keyset() ) {
             APTSMD_ProductWrapperClass wrap = new APTSMD_ProductWrapperClass(prodId);
             wrap.ImageURL = productDetailsMap.get(prodId).Apttus_Config2__IconId__c;
             wrap.productname = productDetailsMap.get(prodId).Name;
             wrap.productId = prodId ;
             wrap.ratingURL = productDetailsMap.get(prodId).APTSMD_product_rating_indicator_src__c;
             wrap.rating = productDetailsMap.get(prodId).APTSMD_Rating__c;
             ProductIdMappedWithWrapper.put(prodId, wrap );

         }
          set<Id> prodIdList = new set<Id>();
        map<string,Apttus_Config2__PriceListItem__c> idVsPLI= new map<string,Apttus_Config2__PriceListItem__c>();
        for (Apttus_Config2__PriceListItem__c PLIDetails: [select Id, Apttus_Config2__ListPrice__c, Apttus_Config2__ProductId__c from Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductId__c In :allIds  order by createddate desc]){
            if(prodIdList.contains(PLIDetails.Apttus_Config2__ProductId__c)) {
            }
            else {
                prodIdList.add(PLIDetails.Apttus_Config2__ProductId__c);
                ProductIdMappedWithWrapper.get(PLIDetails.Apttus_Config2__ProductId__c ).PriceItem= PLIDetails;
            }
        }
       return  ProductIdMappedWithWrapper ;
         //Map<string,ProductWrapperClass> mapDetails =  productsUtils.getFeatureListByProductId(allIds);
         //return mapDetails ;
    }

    public static void putDataIntoMap(Map<String, List<APTSMD_FeatureData>> valueMap,String key,APTSMD_FeatureData featureObj){
        if(valueMap.get(key) == null){
            List<APTSMD_FeatureData> featuresList = new List<APTSMD_FeatureData>();
            featuresList.add(featureObj);
            valueMap.put(key,featuresList);
        }
        else
            valueMap.get(key).add(featureObj);
    }

   @RemoteAction
    public static Map<String, Map<String,String>>  getFeatureSets(String SelectedIds) {
    list<Apttus_CPQApi.CPQ.FeatureInfoResponseDO> productFeatureInfosResponse;
    Map<String, List<Apttus_CPQApi.FeatureSupport.FeatureInfo>> featureSets;

    List<String> allIds = SelectedIds.split(',');
         system.debug('allIds '+ allIds );
        Apttus_CPQApi.CPQ.FeatureInfoRequestDO request = new Apttus_CPQApi.CPQ.FeatureInfoRequestDO();
        request.ProductIds = allIds ;
        productFeatureInfosResponse =  Apttus_CPQApi.CPQWebService.compareProducts(request);
        //return productFeatureInfosResponse;
        Map<id, product2> productDetailsMap = new Map<Id,product2>([select id, Apttus_Config2__IconId__c, Apttus_Config2__Icon__c, Name from product2 where Id in :allIds ORDER BY Id]);
        map<String, List<Apttus_CPQApi.FeatureSupport.FeatureInfo>> featureInfosByFeatureSetName = new map<String, List<Apttus_CPQApi.FeatureSupport.FeatureInfo>>();
        Map<String, Map<String,String>> productFeatureMap = new Map<String, Map<String,String>>();
         Map<String, List<APTSMD_FeatureData>> productFeatureObjMap = new Map<String, List<APTSMD_FeatureData>>();
        if(allIds.size() > 0 && productFeatureInfosResponse.size() > 0) {
            /*for(Id prodId : allIds) {
                List<Apttus_CPQApi.FeatureSupport.FeatureInfo > fInfos;
                for(Apttus_CPQApi.CPQ.FeatureInfoResponseDO responses : productFeatureInfosResponse){
                    if(responses.ProductId == prodId){
                        fInfos = responses.FeatureInfos;
                    }
                }
                if(fInfos != null && fInfos.size() > 0) {
                    for(Apttus_CPQApi.FeatureSupport.FeatureInfo fInfo : fInfos) {
                        if(!featureInfosByFeatureSetName.containsKey(fInfo.productFeatureSet.Name)) {
                            featureInfosByFeatureSetName.put(fInfo.productFeatureSet.Name, new List<Apttus_CPQApi.FeatureSupport.FeatureInfo>());
                        }

                        featureInfosByFeatureSetName.get(fInfo.productFeatureSet.Name).add(fInfo);
                    }
                }
            }*/
            for(Apttus_CPQApi.CPQ.FeatureInfoResponseDO responses : productFeatureInfosResponse){

                List<Apttus_CPQApi.FeatureSupport.FeatureInfo>  fInfos = responses.FeatureInfos;

                if(fInfos != null && fInfos.size() > 0) {
                    for(Apttus_CPQApi.FeatureSupport.FeatureInfo fInfo : fInfos) {
                        for(Apttus_CPQApi.FeatureSupport.ProductFeatureValue f : fInfo.productFeatureSet.Features) {
                            if(f.Value != null && f.IsIncluded) {
                                //if(!productFeatureMap.containsKey(f.Name)) {
                                //    productFeatureMap.put(f.Name, new List<String>{f.Value});
                                //}else{
                                //    List<String> existingValues = productFeatureMap.get(f.Name);
                                //    existingValues.add(f.Value);
                                 //   productFeatureMap.put(f.Name, existingValues);
                               // }
                               putDataIntoMap(productFeatureObjMap,f.Name,new APTSMD_FeatureData(f.ProdId,f.Value));
                             }
                             else if(f.IsIncluded){
                                // if(!productFeatureMap.containsKey(f.Name)) {
                                 //   productFeatureMap.put(f.Name, new List<String>{'N/A'});
                                //}else{
                                //    List<String> existingValues = productFeatureMap.get(f.Name);
                                 //   existingValues.add('N/A');
                                 //   productFeatureMap.put(f.Name, existingValues);
                                 //   }
                                 putDataIntoMap(productFeatureObjMap,f.Name,new APTSMD_FeatureData(f.ProdId,'N/A'));


                             }
                        }
                    }
                }
            }
        }
        /*
        for(String product: productFeatureMap.keyset()) {
            List<String> productValueSize = productFeatureMap.get(product);
            for(Integer i=productValueSize.size()-1 ;i<allIds.size() ;i++){
                productFeatureMap.get(product).add('');
            }
        }*/
    System.Debug('@@@@productFeatureObjMap:'+productFeatureObjMap);
    for(String featureName: productFeatureObjMap.keyset()) {
        List<APTSMD_FeatureData> featureLst = productFeatureObjMap.get(featureName);
        Map<String,String> prodIdVsFeatureMap = new Map<String,String>();
        List<Map<String,String>> featureStrLst = new list<Map<String,String>>();
        featureLst.sort();
        for(APTSMD_FeatureData featureObj : featureLst){

            prodIdVsFeatureMap.put(featureObj.productId,featureObj.FeatureValue);

        }
        featureStrLst.add(prodIdVsFeatureMap);
        productFeatureMap.put(featureName,prodIdVsFeatureMap);
    }
     System.Debug('@@@@productFeatureMap:'+productFeatureMap);
        return productFeatureMap;

        /*featureSets = featureInfosByFeatureSetName;
        return featureSets ; */
    }






    @RemoteAction
    global static List<List<String>> getAllSelectedFilters(String categories){
        Set<String> categoriesIdSet = new Set<String>();
        List<APTSMD_categoryWrapperClass> allWrappers = (List<APTSMD_categoryWrapperClass>)JSON.deserialize(categories,List<APTSMD_categoryWrapperClass>.class);
        for(APTSMD_categoryWrapperClass wrapCategory : allWrappers){
            categoriesIdSet.add(wrapCategory.Level1CategoryId);
        }
        List<Apttus_Config2__ClassificationHierarchy__c> allClassification = [select id,name,Apttus_Config2__SearchFilterFields__c, APTSMD_Primary_Product__c from Apttus_Config2__ClassificationHierarchy__c  where id in : categoriesIdSet];

        Schema.DescribeFieldResult fieldResult = Apttus_Config2__ClassificationHierarchy__c.Apttus_Config2__SearchFilterFields__c.getDescribe();
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();
        List<String> productFields = new List<String>();
        List<String> fieldList = new List<String>();
        Map<String,String> refineSearchfieldNameValueMap = new Map<String,String>();
        for(Schema.picklistEntry f : ple){
            fieldList.add(f.getValue());
            String apiName = f.getValue();
            String label = Schema.SObjectType.Product2.fields.getMap().get(apiName).getDescribe().getLabel();
            refineSearchfieldNameValueMap.put(f.getValue(),label);
            productFields.add(f.getValue());
        }

        Schema.SObjectType t = Schema.getGlobalDescribe().get('Product2');
        Schema.DescribeSObjectResult r = t.getDescribe();
        MAP<String,Schema.SObjectField> productFieldsMap = r.fields.getMap();

        List<String> productFieldsToEncode = new List<String>();
        List<String> productFieldsNotToEncode = new List<String>();

        Map<String,String> searchFieldValuesMap2 = new Map<String,String>();
        Map<String,List<String>> searchFieldValuesMap = new Map<String,List<String>>();

        for(String productField : productFieldsMap.keySet()) {
            Schema.DescribeFieldResult currentFieldResult = productFieldsMap.get(productField).getDescribe();

            // Add fieldName to the set to create object in javascript
            if(productField.contains(currentFieldResult.getName())) {
                if(currentFieldResult.getType() == Schema.DisplayType.String || currentFieldResult.getType() == Schema.DisplayType.Textarea || currentFieldResult.getType() == Schema.DisplayType.Picklist) {
                    productFieldsToEncode.add(currentFieldResult.getName());
                }else{
                    productFieldsNotToEncode.add(currentFieldResult.getName());
                }
            }

            for(String currentField : fieldList){
                if(!currentField.equalsIgnoreCase(currentFieldResult.getName()))
                    continue;

                List<Schema.picklistEntry> currentPLE = currentFieldResult.getPicklistValues();
                List<String> currentfieldList = new List<String>();
                String currentFieldValueString;

                for(Schema.picklistEntry f:currentPLE) {
                    currentfieldList.add(f.getValue());
                    if(currentFieldValueString == null || currentFieldValueString == ''){
                        currentFieldValueString = f.getValue();
                    }
                    else{
                        currentFieldValueString = currentFieldValueString + ';' + f.getValue();
                    }
                }
                searchFieldValuesMap.put(currentField,currentfieldList);
                searchFieldValuesMap2.put(currentField,currentFieldValueString);
            }

        }
        for(String map1 :searchFieldValuesMap.keySet()){
            System.debug(map1 + ':' +searchFieldValuesMap.get(map1));
        }
        System.debug('New One');
        for(String map2 :searchFieldValuesMap2.keySet()){
            System.debug(map2 + ':' +searchFieldValuesMap2.get(map2));
        }
        // System.debug('searchFieldValuesMap :'+searchFieldValuesMap);
        // System.debug('searchFieldValuesMap2 :'+searchFieldValuesMap2);
        return searchFieldValuesMap.values();
    }

   // Code added by Mehul Parmar - End
    @RemoteAction
    Public static APTSMD_eCom_CallOutResult getTax(String postalCode,Double amt,List<APTSMD_productDetailsForTaxCalc> lst_Products,String strCity,String strStreet,String strCountry,String strState,string strShipMethod)
    {
        system.debug('Address == '+strCity+' '+strStreet + ' ' + strCountry + ' ' +strShipMethod);
        //User objUser = [select contactid from User where id =:Userinfo.getUserid()];
        //Contact cId = [select Account.OracleCSNBillTo__c from Contact where id =:objUser.contactid];
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact cId = user.contactId != null ? [select id,accountId, Account.APTSMD_OracleCSNBillTo__c from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        decimal dShipAmt = APTSMD_cartUtils.CalculateShippingCharges(amt,strShipMethod);
        system.debug('dShipAmt == '+dShipAmt);
        APTSMD_eCom_VertexDetails vertex = new APTSMD_eCom_VertexDetails();
        vertex.destination_postalcode = postalCode;
        //Add Shipping Product Codes for TAX
        APTSMD_productDetailsForTaxCalc prodDetails = new APTSMD_productDetailsForTaxCalc();
        string strProdCode =  Label.APTSMD_Product_Code_For_Shipping;
        prodDetails.ProductCode = strProdCode.replace('&','&amp;');
        prodDetails.Quantity = 1;
        prodDetails.UnitPrice = dShipAmt;
        lst_Products.add(prodDetails);
        system.debug('lst_Products == '+lst_Products);
        vertex.lst_Prods = lst_Products;
        vertex.destination_customerCode = cId.Account.APTSMD_OracleCSNBillTo__c;
        if(strCountry == null || strCountry == '')
                strCountry = 'US';
        vertex.destination_country = strCountry;
        vertex.destination_streetAddress = strStreet;
        vertex.destination_City = strCity;
        vertex.destination_mainDiv = strState;
        APTSMD_eCom_VertexUitlity util = new APTSMD_eCom_VertexUitlity();
        String result = util.doVertexCallout(vertex);
        System.debug('vertex result: ' + result);
        return (APTSMD_eCom_CallOutResult)JSON.deserialize(result,APTSMD_eCom_CallOutResult.class);
    }

    @RemoteAction
    public static APTSMD_cartData modifyCartItemQuantity(String strItemID, string CartId, Integer iQuantity,String strProductId) {
        return APTSMD_cartUtils.modifyCartItemQuantity(strItemID, CartId, iQuantity,strProductId);
    }

    @RemoteAction
    public static void createCartItems(List<Apttus_CPQApi.CPQ.SelectedProductDO> lstSelProducts,String CartID,String strProductId) {
        //cartUtils.createCartItems(lstSelProducts, CartID);
    }

    @RemoteAction
    public static APTSMD_cartData addCartItem(string strProdId,integer iQuantity,String CartID) {
        return APTSMD_cartUtils.addCartItem(strProdId,iQuantity,CartID);
    }

    @RemoteAction
    public static APTSMD_cartData addBundleWithOptions(string strProd,String CartID) {
        APTSMD_ProductWrapperClass product = (APTSMD_ProductWrapperClass)JSON.deserialize(strProd,APTSMD_ProductWrapperClass.class);
        return APTSMD_cartUtils.addBundleWithOptions(product,CartID);
    }

    @RemoteAction
    public static APTSMD_cartData updateCartLineItems(string strCart) {
        APTSMD_cartWrapper cart = (APTSMD_cartWrapper)JSON.deserialize(strCart,APTSMD_cartWrapper.class);
        return APTSMD_cartUtils.updateCartLineItems(cart);
    }

    @RemoteAction
    public static APTSMD_cartData removeCartItem(string itemId, String CartID) {
        return APTSMD_cartUtils.removeCartItem(CartID, itemId);
    }
    //Mayur- Clone Cart Item
    @RemoteAction
    public static  APTSMD_cartWrapper.cartItems cloneCartItem(string itemId, String CartID,String prodId,Integer quantity) {
        return APTSMD_cartUtils.cloneCartItem(CartID, itemId,prodId,quantity);
    }

    @RemoteAction
    public static APTSMD_cartData getCartDetails() {
      return APTSMD_cartUtils.getCartData();
    }

    //MSN - Get Recommended Data by constrainrules
    @RemoteAction
    public static APTSMD_cartData getCartSuggestedProduct() {

       return APTSMD_cartUtils.getCartSuggestedProduct();
    }

    @RemoteAction
    public static APTSMD_cartData repriceCart(String CartID) {

       return APTSMD_cartUtils.repriceCart(CartID);
    }



    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> searchProducts(String plId, String cplId, String searchQuery, Integer lim){
      searchQuery += '*';
      List<APTSMD_ProductWrapperClass> allProducts = APTSMD_ApttusLabAngularJS.getProductsList(plId, cplId, '[]');
      List<APTSMD_ProductWrapperClass> returnList = new List<APTSMD_ProductWrapperClass>();

      List<List<sObject>> results = (List<List<sObject>>)[FIND :searchQuery IN ALL FIELDS RETURNING Product2(Id), Apttus_Config2__ProductTranslation__c(Apttus_Config2__ProductId__c) LIMIT :lim];
      Set<Id> addedRecords = new Set<Id>();
      for(List<sObject> parentList : results){
        for(sObject parentProduct : parentList){
          String recordId = (parentProduct.getSObjectType() == Schema.Apttus_Config2__ProductTranslation__c.getSObjectType()) ? (String) parentProduct.get('Apttus_Config2__ProductId__c') : (String) parentProduct.get('Id');
          Boolean breaking = false;
          for(APTSMD_ProductWrapperClass childProduct : allProducts){
            if(childProduct.ProductId == recordId && !addedRecords.contains(childProduct.ProductId)){
              returnList.add(childProduct);
              addedRecords.add(childProduct.ProductId);
              if(returnList.size() >= lim){
                breaking = true;
                break;
              }
            }
          }
          if(breaking)
            break;
        }
      }
      return returnList;
    }

    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getProductsWithLimit(String plId, String categoryId, String searchQuery, Integer lim){
      List<APTSMD_ProductWrapperClass> returnList = new List<APTSMD_ProductWrapperClass>();
      if(searchQuery != null)
        returnList = searchProducts(plId, null, searchQuery, lim);
      else{
        for(APTSMD_ProductWrapperClass wrapper : APTSMD_ApttusLabAngularJS.getProductsList(plId, null, '[]')){
          if(categoryId != null && categoryId != '' && categoryId == wrapper.parentCategoryId)
            returnList.add(wrapper);
          else if(categoryId == null || categoryId == '')
            returnList.add(wrapper);

          if(returnList.size() >= lim)
            break;
        }
      }
      return returnList;
    }

    @RemoteAction
    public static APTSMD_ProductWrapperClass getProductWrapper(String plId, String productId){
      APTSMD_ProductWrapperClass retProduct = null;
      List<APTSMD_ProductWrapperClass> allProducts = APTSMD_ApttusLabAngularJS.getProductsList(plId, '', '[]');
      for(APTSMD_ProductWrapperClass wrapper : APTSMD_ApttusLabAngularJS.getProductsList(plId, null, '[]')){
        if(wrapper.ProductId == productId)
          retProduct = wrapper;
      }
      return retProduct;
    }

    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getProductsList(String PLId,String cPlid,String rfqc){
        return APTSMD_productsUtils.getProductsOnCategories(PLId,cPlid,rfqc);
    }

    //MNS
    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getRecommendedProducts(String prodId, String pLId, String cPlid){
        return APTSMD_productsUtils.getRecommendedProducts(prodId,pLId,cPlid);
    }

    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getGuidedProducts(String PLId,string Cplid){
        return APTSMD_productsUtils.getGuidedProducts(PLId,Cplid);
        //return null;

    }

    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getPickedUpProducts(String ProductIds,String PLId,string Cplid){
        return APTSMD_productsUtils.getPickedUpProducts(ProductIds,PLId,Cplid);
        //return null;

    }

    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getPastOrderProducts(String ProductIds,String PLId,string Cplid){
        return APTSMD_productsUtils.getPastOrderProducts(ProductIds,PLId,Cplid);
        //return null;

    }

    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getTopDealProducts(String ProductIds,String PLId,String Cplid){
      Decimal exchangeRate = APTSMD_ApttusLabAngularJS.getCurrencyExchangeRate();
      List<APTSMD_ProductWrapperClass> wrapperList = APTSMD_productsUtils.getTopDealProducts(ProductIds,PLId,Cplid);
      for(APTSMD_ProductWrapperClass wrapper : wrapperList){
        wrapper.listPriceConverted = wrapper.PriceItem.Apttus_Config2__ListPrice__c * exchangeRate;
      }
      return wrapperList;
    }

    @RemoteAction
    public static void createOrderFromStore(String PLId) {
        APTSMD_cartUtils.getCartDetails(PLId);
    }

     @RemoteAction
    public static void updatePriceOnCart(String CartId) {
        APTSMD_cartUtils.updateCartPrice(CartId);
    }

    @RemoteAction
    public static List<APTSMD_CategoryWrapperClass> getCategoriesList(String PLId)
    {
        return APTSMD_CategoriesUtils.getCategoriesForPriceList(PLId);
    }
    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getProductsByCategory(String categoryId)
    {
        return APTSMD_productsUtils.getProductsByCategory(categoryId);
    }

    @RemoteAction
    public static List<APTSMD_ProductOptionGroupWrapper > getBundleConfigurations(String productId)
    {
        return APTSMD_productsUtils.getBundleConfigurations(productId);
    }
    @RemoteAction
    public static APTSMD_ProductWrapperClass getProductConfigurations(String strProd)
    {
        APTSMD_ProductWrapperClass product = (APTSMD_ProductWrapperClass)JSON.deserialize(strProd,APTSMD_ProductWrapperClass.class);
        return APTSMD_productsUtils.getProductConfigurations(product);
    }

    @RemoteAction
    public static Map<string,APTSMD_ProductWrapperClass> getFeatureListByProductId(List<id> prodId)
    {
        return APTSMD_productsUtils.getFeatureListByProductId(prodId);
    }


    @RemoteAction
    public static List<APTSMD_ProductWrapperClass> getAlsoBoughtProducts(List<id> prodId)
    {
        return APTSMD_productsUtils.getAlsoBoughtProducts (prodId);
    }
    @RemoteAction
    public static APTSMD_cartData reorderfunction(String orderID,String CartID)
    {
        return APTSMD_OrderUtils.reorderFunction(orderID,CartID);
        // return APTSMD_productsUtils.getAlsoBoughtProducts (prodId);
    }

     @RemoteAction
    Public static APTSMD_ContactWrapper getAddressInfo()
    {
       Id userID = Userinfo.getUserId();
      // Id userId = '005c0000001SFfP';

       APTSMD_ContactWrapper contWrapper=new APTSMD_ContactWrapper();
       contWrapper.addressWrapper=new List<APTSMD_AddressWrapper>();
       //Contact objContact = [select id,accountId,account.APTSMD_csn__c,account.OracleCSNBillTo__c,FirstName,LastName,Phone,Fax,Email from Contact where id in (select contactId from user where id =: userID)];
       User user = [select contactId from user where id =: UserInfo.getUserId()];
       Contact objContact = user.contactId != null ? [select id,accountId, account.APTSMD_csn__c,account.APTSMD_OracleCSNBillTo__c , FirstName , LastName, Phone, Email, Fax from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
       system.debug('objContact == '+objContact);
       system.debug('objContact Account == '+objContact.account.APTSMD_csn__c);
       system.debug('objContact Account == '+objContact.account.APTSMD_OracleCSNBillTo__c);
       list <Apttus_Config2__AccountLocation__c> accLocList = new list<Apttus_Config2__AccountLocation__c>();
       accLocList = [SELECT id,Apttus_Config2__IsDefault__c,Apttus_Config2__AccountId__c,Apttus_Config2__City__c,Apttus_Config2__Country__c,Apttus_Config2__PostalCode__c,Apttus_Config2__State__c,Apttus_Config2__Street__c,Apttus_Config2__AccountId__r.APTSMD_Card_Number__c,Apttus_Config2__AccountId__r.APTSMD_Saved_Card__c,Apttus_Config2__AccountId__r.APTSMD_Sub_String__c FROM Apttus_Config2__AccountLocation__c WHERE Apttus_Config2__AccountId__c=:objContact.accountId];
       //for(Account objAcc : [select id,BillingCity, APTSMD_Saved_Card__c, APTSMD_CSN__c,APTSMD_Sub_String__c, APTSMD_Card_Number__c, BillingCountry, BillingState, BillingStreet, BillingPostalCode, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode from Account where APTSMD_OracleCSNBillTo__c =: objContact.account.APTSMD_OracleCSNBillTo__c and APTSMD_Account_Status__c =: 'Customer'])
       for(Apttus_Config2__AccountLocation__c accLoc : accLocList )
       {

            APTSMD_AddressWrapper addWrapper = new APTSMD_AddressWrapper();

            //Billing Info
            //addWrapper.Id = objAcc.id;
            //addWrapper.Id = accLoc.Apttus_Config2__AccountId__c;
            addWrapper.Id = accLoc.Id;
            addWrapper.accountId = accLoc.Apttus_Config2__AccountId__c;
            addWrapper.FirstName = objContact.FirstName ;
            addWrapper.LastName= objContact.LastName;
            /*addWrapper.Billing_City = objAcc.BillingCity;
            addWrapper.Billing_Country = objAcc.BillingCountry;
            addWrapper.Billing_State = objAcc.BillingState;
            addWrapper.Billing_Street = objAcc.BillingStreet;
            addWrapper.Billing_Postal_Code = objAcc.BillingPostalCode;
            addWrapper.CardNumber = objAcc.APTSMD_Card_Number__c;
            addWrapper.SavedCard = objAcc.APTSMD_Saved_Card__c;
            addWrapper.SubString = objAcc.APTSMD_Sub_String__c;*/
            if(accLoc.Apttus_Config2__IsDefault__c){
                addWrapper.Billing_City = accLoc.Apttus_Config2__City__c;
                addWrapper.Billing_Country = accLoc.Apttus_Config2__Country__c;
                addWrapper.Billing_State = accLoc.Apttus_Config2__State__c;
                addWrapper.Billing_Street = accLoc.Apttus_Config2__Street__c;
                addWrapper.Billing_Postal_Code = accLoc.Apttus_Config2__PostalCode__c;
            }
            addWrapper.CardNumber = accLoc.Apttus_Config2__AccountId__r.APTSMD_Card_Number__c;
            addWrapper.SavedCard = accLoc.Apttus_Config2__AccountId__r.APTSMD_Saved_Card__c;
            addWrapper.SubString = accLoc.Apttus_Config2__AccountId__r.APTSMD_Sub_String__c;
            //Shipping Info
            /*addWrapper.Shipping_City = objAcc.ShippingCity;
            addWrapper.Shipping_Country = objAcc.ShippingCountry;
            addWrapper.Shipping_State = objAcc.ShippingState;
            addWrapper.Shipping_Street = objAcc.ShippingStreet;
            addWrapper.Shipping_Postal_Code = objAcc.ShippingPostalCode;*/
            addWrapper.Shipping_City = accLoc.Apttus_Config2__City__c;
            addWrapper.Shipping_Country = accLoc.Apttus_Config2__Country__c;
            addWrapper.Shipping_State = accLoc.Apttus_Config2__State__c;
            addWrapper.Shipping_Street = accLoc.Apttus_Config2__Street__c;
            addWrapper.Shipping_Postal_Code = accLoc.Apttus_Config2__PostalCode__c;
            contWrapper.addressWrapper.add(addWrapper);

       }
       contWrapper.Id=objContact.id;
       contWrapper.FirstName=objContact.FirstName;
       contWrapper.LastName=objContact.LastName;
       String strPhone = objContact.Phone != null ? objContact.Phone.replace('-','').substring(0,10) : '';
       contWrapper.Phone = strPhone;
       contWrapper.Fax=objContact.Fax;
       contWrapper.Email=objContact.Email;
       system.debug('Wrapper == '+contWrapper);
       contWrapper.cardWrapper = getCarWrapperdDetails(objContact.id);
       return contWrapper;


    }
    private static List<APTSMD_ecomCardWrapper> getCarWrapperdDetails(Id contactid){
        List<APTSMD_ecomCardWrapper> returnList = new List<APTSMD_ecomCardWrapper>();
        List<APTSMD_CardDetails__c> cardList = [SELECT Id,Name,APTSMD_SubString__c,APTSMD_SavedCard__c FROM APTSMD_CardDetails__c WHERE APTSMD_Contact__c=:contactid];
        if(!cardList.isEmpty()){
            for(APTSMD_CardDetails__c obj : cardList){
                APTSMD_ecomCardWrapper card = new APTSMD_ecomCardWrapper();
                card.subString = obj.APTSMD_SubString__c;
                card.savedCard = obj.APTSMD_SavedCard__c;
                returnList.add(card);
            }
        }
        return returnList;
    }
    //added by sharanya
    @RemoteAction
    public static boolean saveAddress(string address){
        list<Apttus_Config2__AccountLocation__c> newAccLocList = new list<Apttus_Config2__AccountLocation__c>();
        newAccLocList = (List<Apttus_Config2__AccountLocation__c>)JSON.deserialize(address, List<Apttus_Config2__AccountLocation__c>.class);
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact con = user.contactId != null ? [select id,accountId, Account.APTSMD_Dealer_del__c from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        for(Apttus_Config2__AccountLocation__c accLoc : newAccLocList){
            accLoc.Apttus_Config2__AccountId__c=con.accountId;
        }
        insert newAccLocList;
        return true;
    }

    @RemoteAction
    public static Apttus_Config2__AccountLocation__c saveSingleAddress(Apttus_Config2__AccountLocation__c address){
      User user = [select contactId from user where id =: UserInfo.getUserId()];
      Contact con = user.contactId != null ? [select id,accountId, Account.APTSMD_Dealer_del__c from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
      address.Apttus_Config2__AccountId__c=con.accountId;
      insert address;
      return address;
    }
    //added by sharanya


    @RemoteAction
    public static APTSMD_eCom_CallOutResult authorizeCreditCard(APTSMD_CyberSource_CC_AuthRequest ccDetails)
    {
        String result ='';
        APTSMD_apttuslabUtils utility = new APTSMD_apttuslabUtils();
        System.debug('ccDetails :'+ccDetails);
        ccDetails.currencyType = 'USD';
        result = utility.processCCAuthRequest(ccDetails,false);
        System.debug('result 1:'+result);
        APTSMD_eCom_CallOutResult ecomResult = new APTSMD_eCom_CallOutResult();
        ecomResult = (APTSMD_eCom_CallOutResult)JSON.deserialize(result,APTSMD_eCom_CallOutResult.class);

        String str1 = ecomResult.message;
        String str2 = str1.substringAfterLast('-');
        system.debug('str2::::'+str2);
        if(str2 != null && str2 != '')
        {
            APTSMD_CreditCardReasonCodes__c ccSettings = APTSMD_CreditCardReasonCodes__c.getInstance(str2);
            String str3 = ccSettings.APTSMD_Description__c;
            system.debug('str3str3:::::'+str3);
            ecomResult.message = str3;
            system.debug('Result:::'+ ecomResult.message);

        }
        return ecomResult;


    }
    //-----Code By Mayur- Create Quote
     @RemoteAction
    public static APTSMD_ProposalDetails createQuote(String storePriceList,String strcartInfo)
    {
       system.debug('cartInfo == '+strcartInfo);
       APTSMD_cartWrapper cartInfo = (APTSMD_cartWrapper)JSON.deserialize(strcartInfo,APTSMD_cartWrapper.class);
       system.debug('cartInfo == '+cartInfo);

       return APTSMD_OrderUtils.createQuote(storePriceList,cartInfo);

    }

     @RemoteAction
    public static String SubmitOrder(APTSMD_OrderDetails orderInfo)
    {
       system.debug('orderInfo == '+orderInfo);
       return APTSMD_OrderUtils.SaveOrderDetails(orderInfo);

    }

    @RemoteAction
    public static Decimal ShippingCharges(Decimal dOrderAmount,String strShipMethod)
    {
       //Update BANK ID and Order details
        return APTSMD_cartUtils.CalculateShippingCharges(dOrderAmount,strShipMethod);

    }

    @RemoteAction
    public static rateRR ShippingChargesFedex(Decimal cartAmount, Integer cartSize, String shippingStreet, String shippingCity,
                                                String shippingState, String shippingCountry, String shippingPostalCode, String shipType) {
        //set up rate request
        boolean getAllRatesFlag = false; // set to true to get the rates for different service types
        fedexComWsRateV16.RateRequest request = new fedexComWsRateV16.RateRequest();
        request.ClientDetail = createClientDetail();
        request.WebAuthenticationDetail = createWebAuthenticationDetail();
        request.ReturnTransitAndCommit = true;
        //
        fedexComWsRateV16.TransactionDetail transactionDetail = new fedexComWsRateV16.TransactionDetail();
        transactionDetail.CustomerTransactionId = 'apex sample - Rate Request'; // The client will get the same value back in the response
        request.TransactionDetail = transactionDetail;
        //
        fedexComWsRateV16.VersionId versionId = new fedexComWsRateV16.VersionId();
        versionId.ServiceId = 'crs';
        versionId.Major = 16;
        versionId.Intermediate = 0;
        versionId.Minor = 0;
        request.Version = versionId;
        //
        fedexComWsRateV16.RequestedShipment requestedShipment = new fedexComWsRateV16.RequestedShipment();
        requestedShipment.ShipTimestamp = Datetime.now();
        requestedShipment.DropoffType = 'REGULAR_PICKUP';
        String serviceType = '';
        if (! getAllRatesFlag) {
            if(shipType == 'Overnight'){
                serviceType = 'PRIORITY_OVERNIGHT';
            }
            else if(shipType == 'Second Day'){
                serviceType = 'FEDEX_2_DAY';
            }
            else if(shipType == 'Ground'){
                serviceType = 'FEDEX_GROUND';
            }
            requestedShipment.ServiceType = serviceType;
            requestedShipment.PackagingType = 'YOUR_PACKAGING';
        }
        //
        fedexComWsRateV16.Party shipper = new fedexComWsRateV16.Party();
        fedexComWsRateV16.Contact shipperContact = new fedexComWsRateV16.Contact();
        shipperContact.PersonName = 'Kyle Bernard';
        shipperContact.CompanyName = 'Apttus';
        shipperContact.PhoneNumber = '0805522713';
        fedexComWsRateV16.Address shipperAddress = new fedexComWsRateV16.Address(); // Origin information
        shipperAddress.StreetLines = new String[] {'1400 Fashion Island Blvd #200'};
        shipperAddress.City = 'San Mateo';
        shipperAddress.StateOrProvinceCode = 'CA';
        shipperAddress.PostalCode = '94404';
        shipperAddress.CountryCode = 'US';
        shipper.Contact = shipperContact;
        shipper.Address = shipperAddress;
        requestedShipment.Shipper = shipper;
        //
        //check to see if shipping address
        fedexComWsRateV16.Party recipient = new fedexComWsRateV16.Party();
        fedexComWsRateV16.Contact recipientContact = new fedexComWsRateV16.Contact();
        recipientContact.PersonName = 'Customer';
        recipientContact.CompanyName = 'Recipient Company Name';
        recipientContact.PhoneNumber = '1234567890';
        fedexComWsRateV16.Address recipientAddress = new fedexComWsRateV16.Address(); // Destination information
            recipientAddress.StreetLines = new String[] {shippingStreet};
            recipientAddress.City = shippingCity;
            recipientAddress.StateOrProvinceCode = shippingState;
            recipientAddress.PostalCode = shippingPostalCode;
            if(shippingCountry == 'USA' || shippingCountry == 'United States' || shippingCountry == 'United States of America'){
                shippingCountry = 'US';
            }
            recipientAddress.CountryCode = shippingCountry;
            recipientAddress.Residential = false;
            recipient.Contact = recipientContact;
            recipient.Address = recipientAddress;
            requestedShipment.Recipient = recipient;
        //
        fedexComWsRateV16.Payment shippingChargesPayment = new fedexComWsRateV16.Payment();
        shippingChargesPayment.PaymentType = 'SENDER';
        fedexComWsRateV16.Payor payor = new fedexComWsRateV16.Payor();
        fedexComWsRateV16.Party responsibleParty = new fedexComWsRateV16.Party();
        responsibleParty.AccountNumber = getPayorAccountNumber();
        fedexComWsRateV16.Address responsiblePartyAddress = new fedexComWsRateV16.Address();
        responsiblePartyAddress.CountryCode = 'US';
        responsibleParty.Address = responsiblePartyAddress;
        responsibleParty.Contact = new fedexComWsRateV16.Contact();
        payor.ResponsibleParty = responsibleParty;
        shippingChargesPayment.Payor = payor;
        requestedShipment.ShippingChargesPayment = shippingChargesPayment;
        //
        //loop through line items to add them in packages
        Integer pkgCount = 0;
        List<fedexComWsRateV16.RequestedPackageLineItem> rpli = new List<fedexComWsRateV16.RequestedPackageLineItem>();
        //
        for(Integer i = 0; i < cartSize; i++){
            fedexComWsRateV16.RequestedPackageLineItem rp = new fedexComWsRateV16.RequestedPackageLineItem();
                rp.ItemDescription = 'packge '+ String.valueOf(i+1);
                rp.GroupPackageCount = 1;
                fedexComWsRateV16.Weight weight = new fedexComWsRateV16.Weight();
                weight.Units = 'LB';
                weight.Value = 2.0;
                rp.Weight = weight;

                //
                fedexComWsRateV16.Money money = new fedexComWsRateV16.Money();
                money.Currency_x = 'USD';
                money.Amount = cartAmount/cartSize;
                rp.InsuredValue = money;
                //
                fedexComWsRateV16.Dimensions dimensions = new fedexComWsRateV16.Dimensions();
                dimensions.Length = 1;
                dimensions.Width = 1;
                dimensions.Height = 1;
                dimensions.Units = 'IN';
                rp.Dimensions = dimensions;
                fedexComWsRateV16.PackageSpecialServicesRequested pssr = new fedexComWsRateV16.PackageSpecialServicesRequested();
                rp.SpecialServicesRequested = pssr;
                pkgCount ++;
                rpli.add(rp);
        }
        requestedShipment.RequestedPackageLineItems = rpli;
        //
        requestedShipment.PackageCount = pkgCount;
        request.RequestedShipment = requestedShipment;
        //
        fedexComWsRateV16.RateReply reply = new fedexComWsRateV16.RateReply();
        try {
            fedexComWsRateV16.RateServicePort port = new fedexComWsRateV16.RateServicePort();
            //
            system.debug('check rate request: ' + request);
            reply = port.getRates(request.WebAuthenticationDetail, request.ClientDetail, request.TransactionDetail, request.Version, request.ReturnTransitAndCommit, request.CarrierCodes, request.VariableOptions, request.ConsolidationKey, request.RequestedShipment); // Service call
            system.debug('request sent, check reply : ' + reply);
            if (isResponseOk(reply.HighestSeverity)) {
            }
            //printNotificationds(reply.getNotifications());

        } catch (Exception e) {
            system.debug('There is an Exception: ' + e);
        }
        //
        return new rateRR(request,reply);
    }

    @RemoteAction
    public static String userDetails()
    {
        return UserInfo.getFirstName() + ' ' + Userinfo.getLastName();
    }
     @RemoteAction
    public static List<APTSMD_orderHistory> getOrderHstory()
    {
        //APTSMD_CartUtils.createOrderHistory(PLId);
        return APTSMD_CartUtils.getOrderHstory();
    }


    @RemoteAction
    public static List<APTSMD_assetHistory> getAssetHstory()
    {
        //Get current contact and account details of the logged in user.
        //Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        Account objUserAcc = [select id,name from Account where id =: objContact.accountId];
        system.debug('ASSET*****************List');
        List<APTSMD_assetHistory> lstAssetHistory = new List<APTSMD_assetHistory>();
        List<Apttus_Config2__AssetLineItem__c> assetSO = [select id,Apttus_Config2__AssetStatus__c,Name,CreatedBy.FirstName,
                                                CreatedBy.LastName,CreatedDate,Apttus_Config2__PurchaseDate__c,Apttus_Config2__ProductId__r.name,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c from Apttus_Config2__AssetLineItem__c where Apttus_Config2__AccountId__c=:objUserAcc.id  order by CreatedDate DESC LIMIT 6];
        // for(Apttus_Config2__AssetLineItem__c  objAsset : [select id,Apttus_Config2__AssetStatus__c,Name,CreatedBy.FirstName,
        //                                         CreatedBy.LastName,CreatedDate,Apttus_Config2__PurchaseDate__c,Apttus_Config2__ProductId__r.name,Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c from Apttus_Config2__AssetLineItem__c where Apttus_Config2__AccountId__c=:objUserAcc.id  order by CreatedDate DESC LIMIT 6])

        for(Apttus_Config2__AssetLineItem__c  objAsset : assetSO)

        {
                system.debug('ASSET*****************List1');
                APTSMD_assetHistory assetRec = new APTSMD_assetHistory();
                assetRec.AssetId = objAsset.Id;
                assetRec.AssetStatus = objAsset.Apttus_Config2__AssetStatus__c;
                assetRec.AssetNumber = objAsset.Name;
                assetRec.UserName = objAsset.CreatedBy.FirstName + ' ' + objAsset.CreatedBy.Lastname;
                assetRec.AssetDate = objAsset.Apttus_Config2__PurchaseDate__c ;
                assetRec.ProductName= objAsset.Apttus_Config2__ProductId__r.name;
                assetRec.StartDate= objAsset.Apttus_Config2__StartDate__c;
                assetRec.EndDate= objAsset.Apttus_Config2__EndDate__c;
                lstAssetHistory.add(assetRec);

        }
        system.debug('ASSET*****************List3');
        return lstAssetHistory;
    }


    @RemoteAction
    public static String getContactUSInfo()
    {
        return Label.APTSMD_eComContactUs;
    }


    @RemoteAction
    public static APTSMD_OrderDetails getOrderHistory(String strOrderId,String strCartID)
    {
        return APTSMD_OrderUtils.getOrderHistory(strOrderId,strCartID);
    }

   @RemoteAction
    public static List<String> cardTypes()
    {
        List<String> lstTypes;
        lstTypes = new List<String>{'AMEX','MASTERCARD','VISA'};

       return lstTypes;
    }

    @RemoteAction
    public static APTSMD_ContactWrapper shipDetails()
    {
        APTSMD_ContactWrapper objWrapper = new APTSMD_ContactWrapper();
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();

        for(Contact ct : [select id,AccountId,Name,Phone from Contact where id =: objContact.id])
        {
            objWrapper.FullName = ct.Name;
            objWrapper.Phone = ct.Phone;

        }
        return objWrapper;

    }

     @RemoteAction
    public static boolean checkOrderIsPlacedAlready(String strOrderId)
    {
       List<Apttus_Config2__Order__c> lstOrderHistory = [select id,Apttus_Config2__Status__c,Apttus_Config2__PriceListId__c from Apttus_Config2__Order__c where Apttus_Config2__Status__c !=: 'New' and id =: strOrderId];
       if(!lstOrderHistory.isEmpty())
            return true;
        return false;

    }

    @RemoteAction
    public static String getUserCurrency(String plId) {
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact con = user.contactId != null ? [select id,accountId, Account.APTSMD_Dealer_del__c from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        //Contact con = [Select Account.Name, Account.Dealer_del__c from Contact where Id =: user.ContactId];
        Apttus_Config2__PriceList__c priceList = [Select APTSMD_Currency__c from Apttus_Config2__PriceList__c where id=:plId LIMIT 1];
        return priceList.APTSMD_Currency__c;
    }

    @RemoteAction
    public static List<APTSMD_EcommPromotion> EcommercePromotions() {
        List<APTSMD_EcommPromotion> promotions = new List<APTSMD_EcommPromotion>();
        for(APTSMD_Ecommerce_Promotions__c promo : [Select Name, APTSMD_Promotional_Product__c, APTSMD_Promotional_Product__r.Name, APTSMD_Promotional_Product__r.Apttus_Config2__IconId__c, APTSMD_Promotional_Product__r.Description, APTSMD_Promotion_Price__c from APTSMD_Ecommerce_Promotions__c]) {
            promotions.add(new APTSMD_EcommPromotion(promo.APTSMD_Promotional_Product__r.Name, promo.APTSMD_Promotional_Product__r.Apttus_Config2__IconId__c, promo.APTSMD_Promotional_Product__r.Description, promo.APTSMD_Promotional_Product__c, promo.APTSMD_Promotion_Price__c));
        }

        return promotions;
    }

    @RemoteAction
    public static String guestShipToAccount(String shippingStreet, String shippingCity, String shippingState, String shippingCountry, String shippingPostalCode) {
        String accountId = '00161000003aErS';
        Account acc = new Account(id=accountId);
        acc.shippingStreet = shippingStreet;
        acc.shippingCity = shippingCity;
        acc.shippingState = shippingState;
        acc.shippingCountry = shippingCountry;
        acc.shippingPostalCode = shippingPostalCode;

        return shippingPostalCode;
    }


    @RemoteAction
    public static Decimal PromotionAmount(String cartId, String promoCode) {
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(id=cartId);
        config.Apttus_Config2__CouponCodes__c = promoCode;
        update config;

        System.debug('>>> Cart ID --'+cartId);
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = cartId;
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);

        Decimal totalPromotion = 0.00;

        for(Apttus_Config2__LineItem__c li : [Select Apttus_Config2__IncentiveAdjustmentAmount__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =: cartId]) {
            totalPromotion += li.Apttus_Config2__IncentiveAdjustmentAmount__c != null ? li.Apttus_Config2__IncentiveAdjustmentAmount__c :0.00;
            System.debug('>>>> incentive adjustment amount >> '+li.Apttus_Config2__IncentiveAdjustmentAmount__c);
        }

        if(totalPromotion < 0)
            totalPromotion = (-1)*totalPromotion;

        /*
        List<Apttus_Config2__Incentive__c> promotions = [Select Amount__c from Apttus_Config2__Incentive__c where Apttus_Config2__IncentiveCode__c =: promoCode];
        if(promotions.size() > 0) {
            return (promotions.get(0).Amount__c/100);
        }else{
            return 0;
        }
        */
        return totalPromotion;

    }

    //fedex rating helper functions start
    private static fedexComWsRateV16.ClientDetail createClientDetail() {
        fedexComWsRateV16.ClientDetail clientDetail = new fedexComWsRateV16.ClientDetail();
        APTSMD_FedExIntegration__c accountInfo = APTSMD_FedExIntegration__c.getInstance('System Properties');
        //system.debug('accountInfo: ' + accountInfo);

        String accountNumber = accountInfo.APTSMD_AccountNumber__c;
        String meterNumber = accountInfo.APTSMD_MeterNumber__c;

        clientDetail.AccountNumber = accountNumber;
        clientDetail.MeterNumber = meterNumber;
        return clientDetail;
    }

    private static fedexComWsRateV16.WebAuthenticationDetail createWebAuthenticationDetail() {
        fedexComWsRateV16.WebAuthenticationCredential wac = new fedexComWsRateV16.WebAuthenticationCredential();
        APTSMD_FedExIntegration__c accountInfo = APTSMD_FedExIntegration__c.getInstance('System Properties');
        String key = accountInfo.APTSMD_key__c;
        String password = accountInfo.APTSMD_password__c;
        wac.Key = key;
        wac.Password = password;
        fedexComWsRateV16.WebAuthenticationDetail output = new fedexComWsRateV16.WebAuthenticationDetail();
        output.UserCredential = wac;
        return output;
    }

    private static boolean isResponseOk(String notificationSeverityType) {
        if (notificationSeverityType == null) {
            return false;
        }
        if (notificationSeverityType == 'WARNING' ||
            notificationSeverityType == 'NOTE'    ||
            notificationSeverityType == 'SUCCESS') {
            return true;
        }
        return false;
    }

    private static String getPayorAccountNumber() {
        // See if payor account number is set as system property,
        // if not default it to "XXX"
        APTSMD_FedExIntegration__c accountInfo = APTSMD_FedExIntegration__c.getInstance('System Properties');
        String accountNumber = accountInfo.APTSMD_AccountNumber__c;
        return accountNumber;
    }

    public class rateRR {
        public fedexComWsRateV16.RateRequest request {get;set;}
        public fedexComWsRateV16.RateReply reply {get;set;}
        public rateRR(fedexComWsRateV16.RateRequest request, fedexComWsRateV16.RateReply reply){
            this.request = request;
            this.reply = reply;
        }
    }

     public  static String getpriceMatrix() {
          List <Apttus_Config2__PriceRuleEntry__c> lstPriceRuleEntry = [SELECT Id, Apttus_Config2__Dimension1Value__c,
                                       Apttus_Config2__AdjustmentAmount__c, Apttus_Config2__AdjustmentType__c
                                       FROM Apttus_Config2__PriceRuleEntry__c WHERE Apttus_Config2__PriceRuleId__c = 'a111a0000007kwy' limit 100];
          return JSON.serialize(lstPriceRuleEntry);
     }

     @RemoteAction
     public static Map<String, String> login(String username, String password){
       Id guestUserId = UserInfo.getUserId();
       PageReference p = Site.login(username, password, '/APTSMD_SKOECommCatalog');
       if(p != null){
        User u = [SELECT Id, Name FROM User WHERE Username = :username LIMIT 1];
        try{
            Apttus_Config2__Order__c lastOrder = [SELECT Id, OwnerId FROM Apttus_Config2__Order__c WHERE OwnerId = :guestUserId AND Apttus_Config2__Status__c =: 'New' ORDER BY CreatedDate desc LIMIT 1];
            lastOrder.OwnerId = u.Id;
            update lastOrder;
         }catch(QueryException e){
           //Supress exception, we don't care if there's no cart to update
           //return new Map<String, String>{'success' => 'false', 'message' => e.getMessage()};
         }
         return new Map<String, String>{'success' => 'true', 'message' => p.getUrl()};
       }else{
         return new Map<String, String>{'success' => 'false', 'message' => System.Label.APTSDMP_LoginErrorMessage};
       }
     }

     public PageReference login() {
        try {
            String storeId = apexpages.currentpage().getparameters().get('storeId');
            APTSMD_showErrorLogin = false;

            String retURL = '/APTSMD_SKOECommCatalog';
            if(storeId !=null){
                retURL+='?storeId='+storeId;
            }
            String guestId = userInfo.getUserId();
            if(!String.isBlank(mode) && mode.equalsIgnoreCase('cart')){
                retURL +='&checkout=1';

                System.debug('>> GUest ID : '+guestId);
            }
            PageReference newPage = Site.login(loginUser, loginPassword,retURL);
            if(!String.isBlank(guestId) && newPage !=null ) {

                  List<User> newLoginUser = [SELECT ID,NAme FROM User WHERE Username=:loginUser];
                  String newUser = newLoginUser[0].id;
                  System.debug('>> New User : '+newUser);

                  List<Apttus_Config2__Order__c> lstOrderHistory = [select id,Apttus_Config2__Status__c,Apttus_Config2__PriceListId__c, CreatedDate from Apttus_Config2__Order__c where OwnerId=: guestId and Apttus_Config2__Status__c =: 'New' order by CreatedDate desc];
                  System.debug('>>> Guest User Order ID : '+lstOrderHistory);
                  if(!lstOrderHistory.isEmpty()){
                      for(Apttus_Config2__Order__c obj: lstOrderHistory ){
                          obj.OwnerId = newUser;
                      }
                      update lstOrderHistory;
                  }
            }
            if(newPage == null){
                APTSMD_showErrorLogin = true;
                loginMessage = System.Label.APTSDMP_LoginErrorMessage;
            }
            userLogoURL = [SELECT SmallPhotoUrl FROM User WHERE User.ID =: UserInfo.getUserid() LIMIT 1].SmallPhotoUrl;
            return newPage;
        }
        catch (Exception ex) {
            loginMessage =  ex.getMessage();

            return null;
        }
    }
    public class refineSearchParentWrapper{
        public String refineSearchKey{get;set;}
        public List<refineSearchChildWrapper> wrapper{get;set;}
        public boolean showChilds{get;set;}
        public string categoryId {get; set;}
        public boolean showfilter {get; set;}
        public refineSearchParentWrapper(String refineSearchName,List<refineSearchChildWrapper> wrap,String categoryId){
            this.refineSearchKey = refineSearchName;
            this.wrapper = wrap;
            this.showChilds=true;
            this.showfilter = true;
            this.categoryId = categoryId;
        }

    }
    public class refineSearchChildWrapper{
        public String name{get;set;}
        public boolean status{get;set;}

        public refineSearchChildWrapper(String nm){
            this.name = nm;
            this.status=false;
        }
    }
    public static decimal getCurrencyExchangeRate()
    {
        CurrencyType exchangeRate;
        if(UserInfo.getDefaultCurrency() != 'EUR')
        {
            exchangeRate = [SELECT Id, ConversionRate,IsoCode FROM CurrencyType Where IsoCode=: UserInfo.getDefaultCurrency()];
            return exchangeRate.ConversionRate;
        }
        return 1;

    }
    @RemoteAction
    public static APTSDMP_WrapperUtils.ProductAttributeRulesWrapper getProductAttributeRules(Id strProd)
    {
        return APTSDMP_ProductAttributeRules.getProductAttributeRules(strProd);
    }
    //To update loggedin user's language
  @RemoteAction
  public static void updateUserLanguage(String strLang)
  {
     if(strLang!='')
     {
        User uObj = [Select Id,LanguageLocaleKey From User Where Id=:UserInfo.getUserId()];
        uObj.LanguageLocaleKey = strLang;
        update uObj;
     }

  }
}