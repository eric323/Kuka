public  without sharing class APTSMD_categoriesUtils
    {
        public static Map<Id,String> mapCategoryTranslations {get;set;} 
        public static String contactCategories;
        public static List<APTSMD_CategoryWrapperClass> getCategoriesForPriceList(String PLId)
        {
            //call method to get contact categories
            User user = [select contactId from user where id = :UserInfo.getUserId()];
            
            

            

            
            //try
            //{
                //Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
                //Contact objContact = [select id,accountId from Contact where id =: '003c000000XBt3h'];
                //Account objUserAcc = [select id,Dealer_del__c from Account where id =: objContact.accountId];
                //Apttus_Config2__PriceList__c objPriceList = [select id from Apttus_Config2__PriceList__c where District__c =: objUserAcc.Dealer_del__c];
                List<APTSMD_CategoryWrapperClass> lstCategories = prepareWrapper(getCategories(null,PLId));
                system.debug('lstCategories == '+lstCategories);
            	

            // Need to update the logic to process the APTSMD_CategoryWrapperClass class to remove the categories from the list

          /*

          Try{
                lstCategories = compareCategories(lstCategories);
            }catch(Exception e) {
                system.debug(e.getMessage());
            }  */
                return lstCategories;
            //}
            //catch(System.QueryException queryEx)
            //{
                //APTSMD_neoPostUtils.displayPageMessage(ApexPages.Severity.ERROR,'No valid Account/Contact found for this user.',true);
            //}
        }
        
   public static Apttus_CPQApi.CPQ.CategorySearchResultDO  getCategories(Apttus_Config2__PriceList__c objPriceList,String PLId) {        //a2nc0000000DAAB
            User user = [select contactId from user where id = :UserInfo.getUserId()];
            Contact objContact = user.contactId != null ? [select id,accountId, Product_Categories__c from Contact where id = :user.contactId] : getGuestContact();
			system.debug('string compare contact = ' + objContact);

            
            //Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
            Apttus_Config2__PriceList__c priceList;
            if (PLId != null) {
                priceList = [select id from Apttus_Config2__PriceList__c where id = :PLId limit 1];
            } else {
                Account objUserAcc = [select id,APTSMD_Dealer_del__c from Account where id = :objContact.accountId];
                priceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c = :objUserAcc.APTSMD_Dealer_del__c limit 1];
            }
            // Apttus_Config2__PriceList__c priceList = [select id from Apttus_Config2__PriceList__c where District__c =: 'Chicago' limit 1];
            //CPQ API CALL : Retrieving Products and List Prices for a Price List
            System.debug('priceList :: ' + priceList);
            Apttus_CPQApi.CPQ.CategorySearchResultDO categroryResult = Apttus_CPQApi.CPQWebService.getCategoriesForPriceList(priceList.id);
            APTSMD_apttuslabUtils.displayDebugMessage('Categories Response', categroryResult);
            if (categroryResult == null) APTSMD_apttuslabUtils.displayPageMessage(ApexPages.Severity.ERROR, 'No PriceList returned for this user.', true);

            System.debug('This is the categoryResult object ' + categroryResult);
            return categroryResult;

        }
        
        //Method to change the prepareWrapper and remove categories before it is returned
    public static List<APTSMD_CategoryWrapperClass> compareCategories(List<APTSMD_CategoryWrapperClass> lstproductCategory) {
            //Return list of categories for Pilot
            List<APTSMD_CategoryWrapperClass> categoriesList = new List<APTSMD_CategoryWrapperClass>();
         /* List<APTSMD_categoryWrapperClass.childCategories> childCat = new List<APTSMD_categoryWrapperClass.childCategories>();
            Boolean isCategory = false;
            User user = [select contactId from user where id = :UserInfo.getUserId()];
            Contact objContact = user.contactId != null ? [select Id, AccountId, Product_Categories__c from Contact where id = :user.contactId] : getGuestContact();




            //Parse out the multi-select list on the contact object for Product_Categories__c
            String conACategories = objContact.Product_Categories__c;
            List<String> conCategories = new List<String>();
            //conCategories.add('');
            //Creating list of multi Selected values for categories on the contact object
            try {
                system.debug('in ConACategories and conCategories is ' + conCategories.isEmpty());
                if (conACategories != Null) {
                    system.debug('ConACat Good message');
                    conCategories = conACategories.split(';');

                }
            } catch (Exception e) {
                //no error not in debug log
                system.debug('ConACat error message' + e.getMessage());
            }

            //Categories from Custom Setting Apttus_Custom_Categories__c
            List<Apttus_Custom_Categories__c> custSettingCategories = Apttus_Custom_Categories__c.getall().values();
            

           // childCat = lstproductCategory.lstChildCategories;
                try {
                    for (APTSMD_CategoryWrapperClass category: lstproductCategory) {
                        //childCat = category.lstChildCategories;
                        //system.debug(' childCat = ' + childCat);
                        List<APTSMD_CategoryWrapperClass> lstCategories = new List<APTSMD_CategoryWrapperClass>();
                        for (Integer i = 0; i < custSettingCategories.size(); i++) {

                            String catName = category.level1categoryName;
                            //Apttus_Custom_Categories__c aptCustomSetting = custSettingCategories[i];
                            system.debug('catName = ' + catName);
                            String strConCategories = pubContact.Product_Categories__c;
                            Boolean isHasSubcategoryTrue = false;
                            String comparedString = CompareString(catName, strConCategories);
                            
                            //See if there has been a value for Hassubcat property on category
                            if (category.Hassubcat == null){
                                isHasSubcategoryTrue = false;
                                category.Hassubcat = false;
                                system.debug('hasSub = ' + category.Hassubcat);
                            }else{
                                isHasSubcategoryTrue = true;
                            }
                            system.debug('comparedString = ' + comparedString);

                            if (comparedString <> '') {

                                system.debug('Equals true comparedString = ' + comparedString);
                                //<<Add Category>\

                                categoriesList.add(category);
                                system.debug('category.Hassubcat = ' + category.Hassubcat);
                            }
                            /*
                            else if(category.HasChildCategories){

                                    lstCategories = subcategoryextract(category);

                            }
                            */
                            /* else if (isHasSubcategoryTrue) {
                                system.debug('category.Hassubcat = ' + category.Hassubcat);
                                system.debug('In SubCat comparedTrue = ' + comparedTrue);
                                for (APTSMD_categoryWrapperClass.childCategories childsubCategories : childCat) {
                                    system.debug(childsubCategories);
                                    if (CompareString(childsubCategories.strCategoryName)) {
                                        categoriesList.add(category);
                                    }
                                }
                            }*//*
                            {
                                system.debug('In else comparedString = ' + comparedString);
                                //<<Add Category>>
                                categoriesList.add(category);
                            }

                        }
                    }
                }catch(Exception e){
                    system.debug('For Category loop error message' + e.getMessage());
                }*/
            return categoriesList;
        }
        
        
     	//Checks category against the custom settings and the multiselect picklist from contact object. Jade Fischer 5/2/2017
    public static String CompareString(String strCompare, String conACategories) {
        //Return list of categories for Pilot
        
        String returnString = '';
        List<APTSMD_CategoryWrapperClass> categoriesList = new List<APTSMD_CategoryWrapperClass>();
        Boolean isCategory;
        //User user = [select contactId from user where id = :UserInfo.getUserId()];
        //Contact objContact = user.contactId != null ? [select Id, AccountId, Product_Categories__c from Contact where id = :user.contactId] : getGuestContact();
		
        system.debug('in CompareString' + 'conACat = ' + conACategories);
        //system.debug('objContact = ' + objContact);
		//system.debug('string compare contact = ' + objContact);  
        
        //Parse out the multi-select list on the contact object for Product_Categories__c
        //String conACategories = objContact.Product_Categories__c;
        //String conACategories = pubContact.Product_Categories__c;
               
        List<String> conCategories = new List<String>();
        //conCategories.add('');
        
        //Creating list of multi Selected values for categories on the contact object
        if (conACategories != Null) {
            conCategories = conACategories.split(';');
        } else{
            return 'none';
        }
        
		system.debug('conCategories = ' + conCategories);
        //Categories from Custom Setting Apttus_Custom_Category__c
        List<Apt_Custom_Categories__c> custSettingCategories = Apt_Custom_Categories__c.getall().values();
        for (Integer i = 0; i < custSettingCategories.size(); i++) {
            //Apttus_Custom_Categories__c aptCustomSetting = custSettingCategories[i];
            system.debug('customSetting Name ' + custSettingCategories[i].Name + ' strCompare = ' + strCompare);
            system.debug('custSettingCategories = ' + custSettingCategories);
            if (strCompare == custSettingCategories[i].Name) {
                for (String strCat: conCategories) {
                    //system.debug('in conCategory');
                    system.debug('In strCompare customSetting Name ' + custSettingCategories[i].Name + ' strCompare = ' + strCompare);
                    system.debug('strCat Name ' + strCat);
                    if (strCompare == strCat) {
                        system.debug('strCompare == strCat = ' + strCat);
                        returnString = strCat;

                    }
                }
            }
        }
        system.debug('returnString = ' + returnString);
        return returnString;
    }

   //Old Method for changing the categories
     /*
        public static Apttus_CPQApi.CPQ.CategorySearchResultDO compareCategories(Apttus_CPQApi.CPQ.CategorySearchResultDO productCategory) {
            //Return list of categories for Pilot


            Boolean isCategory = false;
            User user = [select contactId from user where id = :UserInfo.getUserId()];
            Contact objContact = user.contactId != null ? [select Id, AccountId, Product_Categories__c from Contact where id = :user.contactId] : getGuestContact();

            //Parse out the multi-select list on the contact object for Product_Categories__c
            String conACategories = objContact.Product_Categories__c;
            List<String> conCategories = new List<String>();
            conCategories.add('');
            try {
                system.debug('in ConACategories');
                if (conACategories != Null) {
                    conCategories = conACategories.split(';');
                }
            } catch (Exception e) {
                system.debug(e.getMessage());
            }

            //Categories from Custom Setting Apttus_Custom_Categories__c
            List<Apttus_Custom_Categories__c> custSettingCategories = Apttus_Custom_Categories__c.getall().values();



            for (Apttus_CPQApi.CPQ.CategoryDO categoryDO: productCategory.Categories) {

                for (Integer i = 0; i < custSettingCategories.size(); i++) {

                    //Apttus_Custom_Categories__c aptCustomSetting = custSettingCategories[i];
                    if (categoryDO.Name == custSettingCategories[i].Name) {
                        for (String strCat: conCategories) {
                            //system.debug('in conCategory');
                            //system.debug('customSetting Name ' + custSettingCategories[i].Name);
                            //system.debug('strCat Name ' + strCat);
                            if (categoryDO.Name == strCat) {
                                //categoryReslultPilot.add(strCat);
                                //isCategory = true;

                                //<<Add Category>>
                                Apttus_CPQApi.CPQ.CategorySearchResultDO.categories.add(categoryDO);
                                //system.debug('customSetting Name ' + custSettingCategories[i].Name);
                            }
                        }
                    }else
                    {
                        //<<Add Category>>
                         Apttus_CPQApi.CPQ.CategorySearchResultDO.categories.add(categoryDO);
                    }

                }


            }
            //categoryResultPilot.Categories = categories;
            if(categoryResultPilot.Categories.size() > 0){
                categoryResultPilot.HasCategories = true;
            }


            return categoryResultPilot;
        }
*/

        
        
        public static List<APTSMD_CategoryWrapperClass> prepareWrapper(Apttus_CPQApi.CPQ.CategorySearchResultDO  categoryResult)
        {
            mapCategoryTranslations = new Map<Id,String>();
            for(Apttus_Config2__CategoryTranslation__c obj :[Select Id,Name,Apttus_Config2__CategoryHierarchy__c From Apttus_Config2__CategoryTranslation__c Where Apttus_Config2__Language__c=:UserInfo.getLanguage()])
             {
                    mapCategoryTranslations.put(obj.Apttus_Config2__CategoryHierarchy__c,obj.Name);
             }
             system.debug('mapCategoryTranslations==='+mapCategoryTranslations);
             List<APTSMD_CategoryWrapperClass> lstCategories = new List<APTSMD_CategoryWrapperClass>();
             for( Apttus_CPQApi.CPQ.CategoryDO catresult : categoryResult.Categories)
             {
                system.debug('catresult = ' + catresult);
                if(catresult.HasChildCategories) 
                {
                    // Compare for Pilot Program Jade Fischer 5/1/2017
                   /* for (Apttus_CPQApi.CPQ.CategoryDO cldCategory : subcategoryextract(catresult))
                    {
                        if (CompareString(String strCompare)
                    }*/


                    lstCategories = subcategoryextract(catresult);


                }
                
            }   
            System.debug('lstCategories :: '+lstCategories);
            //Add filter for Pilot Categories Jade Fischer 5/1/2017
            /*try{
                lstCategories=compareCategories(lstCategories);
            }catch(Exception e){
                system.debug('compareCategories error message ' + e.getStackTraceString());
            }*/

            return lstCategories;
        }
        
        public static List<APTSMD_CategoryWrapperClass> subcategoryextract(Apttus_CPQApi.CPQ.CategoryDO subcat) {
   			User user = [select contactId from user where id = :UserInfo.getUserId()];
            Contact objContact = user.contactId != null ? [select Id, AccountId, Product_Categories__c from Contact where id = :user.contactId] : getGuestContact();

                    List<APTSMD_CategoryWrapperClass> lstCategoriessub = new List<APTSMD_CategoryWrapperClass>();
                    Set<Id> setLevel1Categories = new Set<Id>();
            		//Jade Fischer 5/2/2017
            		String isPilotCategory = '';
            	//comment this line
           
            		String strConCategories = objContact.Product_Categories__c;//class variable
                    String strCategoryName = '';
                    for( Apttus_CPQApi.CPQ.CategoryDO level1Categroy : subcat.ChildCategories)
                    { 
                        
                        APTSMD_CategoryWrapperClass wrap = New APTSMD_CategoryWrapperClass();
                        wrap.Level1CategoryId = level1Categroy.CategoryId;
                        system.debug('wrap.Level1CategoryId =' + wrap.Level1CategoryId);
                        if(mapCategoryTranslations!=null && mapCategoryTranslations.size() > 0)
                        {
                            
                            if(mapCategoryTranslations.containsKey(level1Categroy.CategoryId))
                            {
                                strCategoryName= mapCategoryTranslations.get(level1Categroy.CategoryId);
                            }
                        }
                         if(strCategoryName!= null && strCategoryName!='')
                         {
                           		wrap.level1categoryName = strCategoryName;                             
                         }
                         else 
                         {
                            //check to see if it is in Pilot Category Jade Fischer 5/1/2017
                            String catName = level1Categroy.name; 
                         //comment this 
                             if (strConCategories != ''){
                                 //comment this
                                If(objContact != null){
                                    system.debug('strConCategories ' + strConCategories);
                                    isPilotCategory = CompareString(catName, strConCategories);
                                }
                                system.debug('wrap = ' + level1Categroy.name + ' isPilotCategory = ' + isPilotCategory);
                                
                             	//comment this
                                If (isPilotCategory.right(5) == 'Pilot'){ 
                                    wrap.level1categoryName = level1Categroy.name;
                             //comment these 3 lines
                                }
                             }else {
                                 wrap.level1categoryName = level1Categroy.name;
                             }
                             wrap.level1categoryName = level1Categroy.name;
                         }
                        
                         if(level1Categroy.HasChildCategories)
                        { 
                               System.debug('level1CategroyinIf :: '+level1Categroy);
                               wrap.childcat = subcategoryextract(level1Categroy); 
                               wrap.Hassubcat = True;
        //                     System.debug('level1Categroy :: '+level1Categroy);
        //                     List<APTSMD_CategoryWrapperClass> lstChildCategories = new List<APTSMD_CategoryWrapperClass>();
        //                     for( Apttus_CPQApi.CPQ.CategoryDO  childCategory : level1Categroy.ChildCategories)
        //                     {   
                               
        //                             APTSMD_CategoryWrapperClass childWrapper = new APTSMD_CategoryWrapperClass();
        //                             childWrapper.Level1CategoryId = childCategory.CategoryId;
        //                             childWrapper.level1categoryName = childCategory.name;
                //   if(childCategory.HasChildCategories) {
                //     childWrapper.childcat = subcategoryextract(childCategory);
                  
                //   }
                //   lstChildCategories.add(childWrapper);
                                
        //                     }
        //                     wrap.childcat = lstChildCategories;
                        }
                        //System.debug('level1CategroyoutIf :: '+wrap);
                        lstCategoriessub.add(wrap);
                    } 
                    System.debug('level1CategroyoutIf*********** :: '+lstCategoriessub);
                    return lstCategoriessub;



}
        
        //sub category code end
         public static List<APTSMD_CategoryWrapperClass>  getSubCategoriesbySoql(Id categoryId)
        {
            //CPQ API CALL : Retrieving Products and List Prices for a Price List
            List<Apttus_Config2__ClassificationHierarchy__c> lstCategoriesHierarchy = [select id,name from Apttus_Config2__ClassificationHierarchy__c where  Apttus_Config2__AncestorId__c =: categoryId];
            
            List<APTSMD_CategoryWrapperClass> lstCats = new List<APTSMD_CategoryWrapperClass>();
            for(Apttus_Config2__ClassificationHierarchy__c objCat : lstCategoriesHierarchy)
            {
                APTSMD_CategoryWrapperClass wrap = New APTSMD_CategoryWrapperClass();
                 wrap.Level1CategoryId = objCat.Id;
                  wrap.level1categoryName = objCat.name;
                lstCats.add(wrap);
            }
            return lstCats;
        }
        
        
        
         public static List<APTSMD_CategoryWrapperClass>  getCategoriesbySoql()
        {
            //CPQ API CALL : Retrieving Products and List Prices for a Price List
            List<Apttus_Config2__ClassificationHierarchy__c> lstCategoriesHierarchy = [select id,name from Apttus_Config2__ClassificationHierarchy__c where  Apttus_Config2__Level__c =: 1];
            
            List<APTSMD_CategoryWrapperClass> lstCats = new List<APTSMD_CategoryWrapperClass>();
            for(Apttus_Config2__ClassificationHierarchy__c objCat : lstCategoriesHierarchy)
            {
                APTSMD_CategoryWrapperClass wrap = New APTSMD_CategoryWrapperClass();
                 wrap.Level1CategoryId = objCat.Id;
                  wrap.level1categoryName = objCat.name;
                lstCats.add(wrap);
            }
            return lstCats;
        }
        
        
        public static Contact getGuestContact() {
            
            Contact objContact = [select Id, 
                                  accountId, 
                                  Account.APTSMD_Dealer_del__c,
                                  account.APTSMD_csn__c,
                                  account.APTSMD_OracleCSNBillTo__c,
                                  FirstName,LastName,
                                  Phone,Fax,Email 
                                  from Contact 
                                  where FirstName='Guest' AND LastName='User' limit 1];    
            
            return objContact;
        }
        public static Set<String> getContact(id userId){
            Contact objContact = user.contactId != null ? [select Id, AccountId, Product_Categories__c from Contact where id = :userId] : getGuestContact();
            String conACategories = objContact.Product_Categories__c;
            List<String> conCategories = new List<String>();
            Set<String> rtnCategories = new Set<String>();
            
            conCategories = conACategories.split(';');
            //for (String strCon: conCategories){
                rtnCategories.addAll(conCategories);
            //}
            return rtnCategories;
        }
     
    }