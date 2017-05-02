public without sharing class APTSMD_cartUtils
{

    public static string strOrderId;

    public static APTSMD_cartWrapper getCartDetails(String PLId)
    {
        //Id userId = '00536000000K7cj';

        Id userId = userInfo.getUserId();
        System.debug('>> user ID in get cart details :'+userId);
        //List<Apttus_Config2__Order__c> lstOrderHistory = [select id,Apttus_Config2__Status__c,Apttus_Config2__PriceListId__c, CreatedDate from Apttus_Config2__Order__c where createdById =: userId and Apttus_Config2__Status__c =: 'New' order by CreatedDate desc];
        List<Apttus_Config2__Order__c> lstOrderHistory = [select id,Apttus_Config2__Status__c,Apttus_Config2__PriceListId__c, CreatedDate from Apttus_Config2__Order__c where ownerID=: userId and Apttus_Config2__Status__c =: 'New' order by CreatedDate desc];
        system.debug('lstOrderHistory === '+lstOrderHistory);
        //return createOrderHistory();
        if(lstOrderHistory.isEmpty())
            return createOrderHistory(PLId);
        else
        {
            List<Apttus_Config2__ProductConfiguration__c> lstCartRecs = [select id,name from Apttus_Config2__ProductConfiguration__c where Apttus_Config2__OrderId__c =: lstOrderHistory[0].Id limit 1];
            if(lstCartRecs.isEmpty())
            {
                 return createOrderHistory(PLId);
            }
            else{
                return getCartHistory(lstOrderHistory[0].Id,lstCartRecs[0].id);
            }
        }



    }

    public static APTSMD_cartWrapper createOrderHistory(String PLId)
    {
        //Get current contact and account details of the logged in user.
        //Contact objContact = [select id,accountId from Contact where id in (select contactId from user where id =: UserInfo.getUserId())];
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        // String storeId = apexpages.currentpage().getparameters().get('storeId');
        //User user = [select contactId from user where id = '00536000000JZbU'];
        // APTSMD_Store__c store = [SELECT Id,APTSMD_APTSMD_Contract_Price_List__c FROM APTSMD_Store__c WHERE id =: storeId];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        Account objUserAcc = [select id,APTSMD_Dealer_del__c, APTSMD_Pricing_Agreement_Number__c from Account where id =: objContact.accountId];
        Apttus_Config2__PriceList__c objPriceList ;
        // if(store.APTSMD_APTSMD_Contract_Price_List__c != null) {
        //     system.debug('***********ContractPricing######'+store.APTSMD_APTSMD_Contract_Price_List__c);
        //     // Apttus_Config2__PriceList__c objPriceList ;
        //     objPriceList = [select id from Apttus_Config2__PriceList__c where id =: store.APTSMD_APTSMD_Contract_Price_List__c];
        //     system.debug('***********ContractPricing######'+objPriceList);
        // }else {

            system.debug('not contract*************');

            /* if(objUserAcc.APTSMD_Pricing_Agreement_Number__c != null ) {
                objPriceList = [select id from Apttus_Config2__PriceList__c where Apttus_Config2__ContractNumber__c =: objUserAcc.APTSMD_Pricing_Agreement_Number__c limit 1];
            }else{
                objPriceList = [select id from Apttus_Config2__PriceList__c where APTSMD_District__c =: objUserAcc.APTSMD_Dealer_del__c limit 1];
            } */
            if(PLId != null){
                objPriceList = [select id from Apttus_Config2__PriceList__c where id=:PLId limit 1];
            }
            else{
                String storeName = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults().APTSMD_DefaultStore__c;

                APTSMD_Store__c store = [SELECT Id,Name,APTSMD_Price_List__c FROM APTSMD_Store__c WHERE Name=:StoreName];
                objPriceList = [select id from Apttus_Config2__PriceList__c where id =: store.APTSMD_Price_List__c limit 1];
            }
        // }


        //Create order history record
        Apttus_Config2.CPQStruct.CreateOrderRequestDO orderReq = new Apttus_Config2.CPQStruct.CreateOrderRequestDO();

        // Add request parameters
        orderReq.AccountId = objUserAcc.Id;
        orderReq.PriceListId = objPriceList.Id;
        orderReq.PricingDate = Datetime.now();

        // Create a new order
        Apttus_Config2.CPQStruct.CreateOrderResponseDO orderResposnse = Apttus_Config2.OrderWebService.createOrder(orderReq);
        List<Apttus_Config2__Order__c> newOrder = [SELECT id, Apttus_Config2__Status__c FROM Apttus_Config2__Order__c WHERE Id=:orderResposnse.OrderSO.Id];
        if(!newOrder.isEmpty()){
            newOrder[0].Apttus_Config2__Status__c ='New';
            update newOrder[0];
        }
        strOrderId = orderResposnse.OrderSO.Id;
        Id cartId = createCart(strOrderId);
        APTSMD_cartWrapper cartDetails = prepareCartWrapper(strOrderId,cartId);
        system.debug('New Cart Wrapper == '+cartDetails);
        return cartDetails;

    }

    public static APTSMD_cartWrapper prepareCartWrapper(String strOrdId,string strCartId)
    {
        APTSMD_cartWrapper wrap = new APTSMD_cartWrapper();
        wrap.OrderId = strOrdId;
        wrap.CartId = strCartId;
        return wrap;
    }

    public static Id createCart(String strOrdId)
    {
        // Create config properties
        List<Apttus_Config2.Property> configProps = new List<Apttus_Config2.Property>();
        // Create the request
        Apttus_Config2.CPQStruct.CreateCartRequestDO cartRequest = new Apttus_Config2.CPQStruct.CreateCartRequestDO();

        // Add request parameters
        cartRequest.OrderId = strOrdId;

        //request.Properties.addAll(configProps);

        // Create a new cart for Order
        Apttus_Config2.CPQStruct.CreateCartResponseDO cartResp = Apttus_Config2.OrderWebService.createCart(cartRequest);

        // Get the cart Id
        return cartResp.CartId;
    }

    public static APTSMD_cartWrapper getCartHistory(String strOrdId,string strCartId)
    {//added Apttus_Config2__BasePrice__c in query
        List<Apttus_Config2__LineItem__c> lstCartLineItems = [select id,Apttus_Config2__BasePrice__c ,Apttus_Config2__ProductId__c,Apttus_Config2__LineType__c,Apttus_Config2__ProductId__r.APTSMD_Lead_Time__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Name, Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c, Apttus_Config2__ProductId__r.Description,Apttus_Config2__Quantity__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c,Apttus_Config2__OptionId__r.Name,Apttus_Config2__NetPrice__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c=: strOrdId and Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__Status__c =: 'New' ORDER BY Apttus_Config2__ProductId__r.Name];
        APTSMD_cartWrapper cWrapper = new APTSMD_cartWrapper();

        User u = [SELECT LanguageLocaleKey FROM User WHERE ID = :UserInfo.getUserId()];

        //Map of attachment id to product ids
        Set<Id> productIdSet = new Set<Id>();
        for(Apttus_Config2__LineItem__c li : lstCartLineItems){
          productIdSet.add(li.Apttus_Config2__ProductId__c);
        }

        Map<Id, Id> productAttachmentMap = new Map<Id, Id>();
        for(Product2 p : [SELECT Id, (SELECT Id FROM Attachments ORDER BY LastModifiedDate DESC LIMIT 1) FROM Product2 WHERE Id IN :productIdSet]){
          if(p.Attachments != null && p.Attachments.size() > 0)
            productAttachmentMap.put(p.Id, p.Attachments.get(0).Id);
        }


        //Map of product id to product translation
        Map<Id, Apttus_Config2__ProductTranslation__c> translationMap = new Map<Id, Apttus_Config2__ProductTranslation__c>();
        for(Apttus_Config2__ProductTranslation__c pt : [SELECT Id, Apttus_Config2__ProductId__c, Apttus_Config2__Name__c, APTSDMP_Ecomm_UoM__c FROM Apttus_Config2__ProductTranslation__c WHERE Apttus_Config2__ProductId__c IN :productIdSet AND Apttus_Config2__Language__c = :u.LanguageLocaleKey]){
          translationMap.put(pt.Apttus_Config2__ProductId__c, pt);
        }

        //cWrapper.cartLineItems lstLineItems = new cWrapper.cartLineItems();

        Map<String,List<Apttus_Config2__LineItem__c>> mapBundleVsOptionsLI = getBundleVsOptionsMap(lstCartLineItems);

        cWrapper.OrderId = strOrdId;
        cWrapper.CartId = strCartId;
        for(Apttus_Config2__LineItem__c obj : lstCartLineItems)
        {
            if(obj.Apttus_Config2__LineType__c.equalsIgnoreCase('Product/Service')){
                APTSMD_cartWrapper.cartItems lineItem = new APTSMD_cartWrapper.cartItems();
                lineItem.ProductId = obj.Apttus_Config2__ProductId__c;
                lineItem.attachmentId = productAttachmentMap.get(obj.Apttus_Config2__ProductId__c);
                lineItem.ProductName = (translationMap.get(obj.Apttus_Config2__ProductId__c) != null) ? translationMap.get(obj.Apttus_Config2__ProductId__c).Apttus_Config2__Name__c : obj.Apttus_Config2__ProductId__r.Name;
                lineItem.iQuantity = integer.ValueOf(obj.Apttus_Config2__Quantity__c);
                lineItem.lineItemPrice = obj.Apttus_Config2__ListPrice__c;
                lineItem.lineItemId = obj.Id;
                lineItem.UOM = (translationMap.get(obj.Apttus_Config2__ProductId__c) != null) ? translationMap.get(obj.Apttus_Config2__ProductId__c).APTSDMP_Ecomm_UoM__c : obj.Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c;
                lineItem.leadTime = obj.Apttus_Config2__ProductId__r.APTSMD_Lead_Time__c;
                lineItem.netPrice = obj.Apttus_Config2__NetPrice__c;
                /*wrap.ProductCode = obj.Apttus_Config2__BaseProductId__r.ProductCode;
                wrap.ProductName =obj.Apttus_Config2__BaseProductId__r.Name;
                wrap.Description = obj.Apttus_Config2__BaseProductId__r.Description;

                wrap.dPrice = obj.Apttus_Config2__ListPrice__c;
                wrap.OrderId = obj.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c;
                wrap.CartId = obj.Apttus_Config2__ConfigurationId__c;*/
                if(mapBundleVsOptionsLI.containsKey(obj.Apttus_Config2__ProductId__c)){
                    List<APTSMD_cartWrapper.cartItems> optItems = new List<APTSMD_cartWrapper.cartItems>();
                    for(Apttus_Config2__LineItem__c lItem : mapBundleVsOptionsLI.get(obj.Apttus_Config2__ProductId__c)){
                        APTSMD_cartWrapper.cartItems cartItem = new APTSMD_cartWrapper.cartItems();
                        cartItem.ProductId = lItem.Apttus_Config2__ProductId__c;
                        cartItem.iQuantity = integer.ValueOf(lItem.Apttus_Config2__Quantity__c);
                        cartItem.lineItemPrice = lItem.Apttus_Config2__ListPrice__c;
                        cartItem.basePrice = lItem.Apttus_Config2__BasePrice__c;
                        cartItem.lineItemId = lItem.Id;
                        cartItem.leadTime = lItem.Apttus_Config2__ProductId__r.APTSMD_Lead_Time__c;
                        cartItem.optName = lItem.Apttus_Config2__OptionId__r.Name;
                        cartItem.UOM = lItem.Apttus_Config2__Uom__c;
                        optItems.add(cartItem);
                    }
                    if(!optItems.isEmpty()){
                        lineItem.optionLineItems = optItems;
                        lineItem.bundlePrice = obj.Apttus_Config2__NetPrice__c;


                    }
                }

                cWrapper.cartLineItems.add(lineItem);
                }
        }
        //cWrapper.cartLineItems = lstLineItems;
        return cWrapper;

    }

    public static Map<String,List<Apttus_Config2__LineItem__c>> getBundleVsOptionsMap(List<Apttus_Config2__LineItem__c> lstCartLineItems){
        Map<String,List<Apttus_Config2__LineItem__c>> retMap = new Map<String,List<Apttus_Config2__LineItem__c>>();
        for(Apttus_Config2__LineItem__c lineItem : lstCartLineItems){
            if(lineItem.Apttus_Config2__LineType__c.equalsIgnoreCase('Option')){
                if(retMap.containsKey(lineItem.Apttus_Config2__ProductId__c)){
                    retMap.get(lineItem.Apttus_Config2__ProductId__c).add(lineItem);
                }else{
                    retMap.put(lineItem.Apttus_Config2__ProductId__c,new List<Apttus_Config2__LineItem__c>{lineItem});
                }
            }
        }
        return retMap;
    }

    public static APTSMD_cartData addCartItem(string strProdId,integer iQuantity,String CartID)
    {
        Set<Id> suggestedProdIds = new Set<Id>();
        If(!checkProductExistsforThisCart(strProdId,iQuantity,CartID))
        {
            suggestedProdIds = addMultipleProducts(strProdId,iQuantity,CartID);
        }
        if(!suggestedProdIds.isEmpty()){
            return getCartData(suggestedProdIds);
        }
        return getCartData();


    }

    //Apply ConstraintRules
    public static Set<Id> applyConstraintRules(String CartID){
        Apttus_CPQApi.CPQWebService.associateConstraintRules(CartId,new  List<Integer>());
        Apttus_CPQApi.CPQWebService.applyConstraintRules(CartId, false);
        return getConstraintRuleResultMessage(CartId);
    }
    //Get the Suggested product Ids for applied Constraint Rules
    public static Set<Id> getConstraintRuleResultMessage(String cartId){
        Apttus_CPQApi.CPQ.ConstraintResultDO constraintResult = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(cartId);
        List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = constraintResult.ConstraintRuleActions;
        System.debug('-----Applied Actions-------'+appliedActionDOList);
        Set<Id> suggestedProdIds = new Set<Id>();
        for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList){
            //add those products whose auto execution is false
            if(appliedActDO.ActionType.equalsIgnoreCase('Inclusion') && appliedActDO.IsAutoExecuted==false){
                for(Id prodId : appliedActDO.SuggestedProductIds){
                    suggestedProdIds.add(prodId);
                }
            }
        }
        return suggestedProdIds;
    }

    //Reprice the Cart
    public static Boolean reprice(Id cartId){
        Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
        objUpdatePriceRequestDO.CartId = cartId;
        Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
        return result.IsPricePending;

    }
    public static Set<Id> addMultipleProducts(string strProdId,integer iQuantity,String CartID){
        Apttus_CPQApi.CPQ.AddMultiProductRequestDO prodRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO ();
            prodRequest.CartId = CartID;
            prodRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
            Apttus_CPQApi.CPQ.SelectedProductDO objSelectedProd = new Apttus_CPQApi.CPQ.SelectedProductDO();
            objSelectedProd.ProductId = strProdId;
            objSelectedProd.Quantity = iQuantity;
            objSelectedProd.Comments = 'Inserted via ecommerce.';
            prodRequest.SelectedProducts.add(objSelectedProd);
            Apttus_CPQApi.CPQ.AddMultiProductResponseDO prodResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(prodRequest);


            //apply ConstraintRules
            Set<Id> suggestedProdIds = applyConstraintRules(CartID);
            System.debug('Constraint Rule Messages------- '+suggestedProdIds);
            //reprice
            if(reprice(CartID)){// If price pending for other product in cart call reprice again
                reprice(CartID);
            }

            //Update Cart Pricing flag

            List<Apttus_Config2__ProductConfiguration__c> lstCart = new List<Apttus_Config2__ProductConfiguration__c>();
            APTSMD_cartWrapper cWrapper = new APTSMD_cartWrapper();

            for(Apttus_Config2__LineItem__c obj:  [select id, Apttus_Config2__BasePrice__c, Name,Apttus_Config2__Description__c,Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :CartID AND Apttus_Config2__LineType__c='Product/Service'])
            {
                APTSMD_cartWrapper.cartItems lineItem = new APTSMD_cartWrapper.cartItems();
                lineItem.ProductId = obj.Apttus_Config2__ProductId__c;
                lineItem.iQuantity = integer.ValueOf(obj.Apttus_Config2__Quantity__c);
                lineItem.lineItemPrice = obj.Apttus_Config2__ListPrice__c;
                lineItem.basePrice = obj.Apttus_Config2__BasePrice__c;
                lineItem.lineItemId = obj.Id;
                lineItem.UOM = obj.Apttus_Config2__Uom__c;
                cWrapper.OrderId = obj.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c;
                cWrapper.CartId = CartID;
                cWrapper.cartLineItems.add(lineItem);
            }
            for(Apttus_Config2__ProductConfiguration__c obj : [select id,Apttus_Config2__IsPricePending__c from Apttus_Config2__ProductConfiguration__c where id =: CartID])
            {
                obj.Apttus_Config2__IsPricePending__c = true;
                lstCart.add(obj);
            }
            if(lstCart.size() > 0)
                update lstCart;
            return suggestedProdIds;
    }
    //Code by Mayur - AddBundleProducts

    public static APTSMD_cartData addBundleWithOptions(APTSMD_ProductWrapperClass product,String CartId){
        Set<Id> suggestedProdIds;
        if(product.hasOptions){// For Bundle products
            Decimal bundleLineNumber = addBundle(CartId,product);
            System.debug('---Line Number---'+bundleLineNumber);
            List<Apttus_Config2__ProductConfiguration__c> lstCart = new List<Apttus_Config2__ProductConfiguration__c>();
            APTSMD_cartWrapper cWrapper = new APTSMD_cartWrapper();

            for(Apttus_Config2__LineItem__c obj:  [select id,Apttus_Config2__BasePrice__c, Name,Apttus_Config2__Description__c,Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :CartID AND Apttus_Config2__LineType__c='Product/Service'])
            {
                APTSMD_cartWrapper.cartItems lineItem = new APTSMD_cartWrapper.cartItems();
                lineItem.ProductId = obj.Apttus_Config2__ProductId__c;
                lineItem.iQuantity = integer.ValueOf(obj.Apttus_Config2__Quantity__c);
                lineItem.lineItemPrice = obj.Apttus_Config2__ListPrice__c;
                lineItem.basePrice = obj.Apttus_Config2__BasePrice__c;
                lineItem.lineItemId = obj.Id;
                lineItem.UOM = obj.Apttus_Config2__Uom__c;
                cWrapper.OrderId = obj.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c;
                cWrapper.CartId = CartID;
                cWrapper.cartLineItems.add(lineItem);
            }
            for(Apttus_Config2__ProductConfiguration__c obj : [select id,Apttus_Config2__IsPricePending__c from Apttus_Config2__ProductConfiguration__c where id =: CartID])
            {
                obj.Apttus_Config2__IsPricePending__c = true;
                lstCart.add(obj);
            }
            if(lstCart.size() > 0)
                    update lstCart;

            //adding attributes
            if(product.hasAttributes){

                List<APTSMD_ProductAttributeGroupWrapper> prodAttributeGroups = product.prodAttributeGroups;
                Map<String,Object> attrbVsValueMap = new Map<String,Object>();
                for(APTSMD_ProductAttributeGroupWrapper grp : prodAttributeGroups){
                    for(APTSMD_ProductAttributeWrapper attr : grp.productAttributes){
                        Object val;
                        if(attr.fieldType.equalsIgnoreCase('Integer')){
                            val = Integer.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('Double')){
                            val = Decimal.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('Date')){

                            	val = Date.valueOf(attr.selectedValue);

                        }else if(attr.fieldType.equalsIgnoreCase('Boolean')){
                            val = Boolean.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('DateTime')){

                            	val = DateTime.valueOf(attr.selectedValue);

                        }else if(attr.fieldType.equalsIgnoreCase('PICKLIST')){
                            val = String.valueOf(attr.selectedValue).split(',')[1];
                    	}else{
                            val = String.valueOf(attr.selectedValue);
                        }

                        attrbVsValueMap.put(attr.name,val);
                    }
                }
                Apttus_Config2__LineItem__c lineItem = [SELECT id,name from Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :CartID AND Apttus_Config2__LineType__c='Product/Service' AND Apttus_Config2__LineNumber__c=:bundlelineNumber];
                String query = 'SELECT Id, Apttus_Config2__LineItemId__c';
                for(String key : attrbVsValueMap.keySet()){
                	query+= ', ' + key;
                }
                String temp = lineItem.id;
                query+= ' FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c=:temp';

                Apttus_Config2__ProductAttributeValue__c pav= Database.query(query);

                for(String key : attrbVsValueMap.keySet()){
                	system.debug('key===='+key);
                	system.debug('value===='+attrbVsValueMap.get(key));
                        pav.put(key,attrbVsValueMap.get(key));
                }

                if(lineItem!=null){

                    pav.Apttus_Config2__LineItemId__c = lineItem.Id;
                }
                update pav;
            }
            Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
            // add request parameters
            objUpdatePriceRequestDO.CartId = CartID;
            // update price for the cart
            Apttus_CpqApi.CPQ.UpdatePriceResponseDO result =
            Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
            /*
            //get Net Price for Bundle
            Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO request = new
            Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO();
            request.CartId = CartID;
            request.LineNumber = bundleLineNumber;
            Apttus_CPQApi.CPQ.ComputeNetPriceResponseDO priceResponse =
            Apttus_CPQApi.CPQWebService.computeNetPriceForBundle(request); */
        }else{
            if(product.hasAttributes){ //if only attributes are available add single product then add attribute
                Apttus_CPQApi.CPQ.AddMultiProductRequestDO prodRequest = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO ();
                prodRequest.CartId = CartID;
                prodRequest.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();
                Apttus_CPQApi.CPQ.SelectedProductDO objSelectedProd = new Apttus_CPQApi.CPQ.SelectedProductDO();
                objSelectedProd.ProductId = product.ProductId;
                objSelectedProd.Quantity = product.Quantity;
                objSelectedProd.Comments = 'Inserted via Ecommerce site.';
                prodRequest.SelectedProducts.add(objSelectedProd);
                Apttus_CPQApi.CPQ.AddMultiProductResponseDO prodResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(prodRequest);

                Decimal lineNumber = prodResponse.LineNumbers.get(0);


                List<APTSMD_ProductAttributeGroupWrapper> prodAttributeGroups = product.prodAttributeGroups;
                Map<String,Object> attrbVsValueMap = new Map<String,Object>();
                for(APTSMD_ProductAttributeGroupWrapper grp : prodAttributeGroups){
                    for(APTSMD_ProductAttributeWrapper attr : grp.productAttributes){
                        Object val;
                        if(attr.fieldType.equalsIgnoreCase('Integer')){
                            val = Integer.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('Double')){
                            val = Decimal.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('Boolean')){
                            val = Boolean.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('Date')){
                            val = Date.valueOf(attr.selectedValue);
                        }
                        else if(attr.fieldType.equalsIgnoreCase('DateTime')){
                            val = DateTime.valueOf(attr.selectedValue);
                        }else if(attr.fieldType.equalsIgnoreCase('PICKLIST')){
                            val = String.valueOf(attr.selectedValue).split(',')[1];
                    	}else{
                            val = String.valueOf(attr.selectedValue);
                        }

                        attrbVsValueMap.put(attr.name,val);
                    }
                }
                Apttus_Config2__LineItem__c lineItem = [SELECT id,name from Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :CartID AND Apttus_Config2__LineType__c='Product/Service' AND Apttus_Config2__LineNumber__c=:lineNumber];
                String query = 'SELECT Id, Apttus_Config2__LineItemId__c';
                for(String key : attrbVsValueMap.keySet()){
                	query+= ', ' + key;
                }
                String temp = lineItem.id;
                query+= ' FROM Apttus_Config2__ProductAttributeValue__c WHERE Apttus_Config2__LineItemId__c=:temp';

                Apttus_Config2__ProductAttributeValue__c pav= Database.query(query);

                for(String key : attrbVsValueMap.keySet()){
                	system.debug('key===='+key);
                	system.debug('value===='+attrbVsValueMap.get(key));
                        pav.put(key,attrbVsValueMap.get(key));
                }

                if(lineItem!=null){

                    pav.Apttus_Config2__LineItemId__c = lineItem.Id;
                }
                update pav;
                Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
                // add request parameters
                objUpdatePriceRequestDO.CartId = CartID;
                // update price for the cart
                Apttus_CpqApi.CPQ.UpdatePriceResponseDO result =
                Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
                    //System.debug('>>> attrbVsValueMap >')
            }
            //apply ConstraintRules
            suggestedProdIds = applyConstraintRules(CartID);
        }
        //apply ConstraintRules
       /*  List<String> message = applyConstraintRules(CartID);
        System.debug('Constraint Rule Messages------- '+message);
        //reprice
        if(!message.isEmpty()){
            if(reprice(CartID)){// If price pending for other product in cart call reprice again
                reprice(CartID);
            }
        } */
        return getCartData(suggestedProdIds);
    }

    public static Decimal addBundle(String CartId,APTSMD_ProductWrapperClass product){
        Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
        request.CartId = CartID;

        request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
        request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
        request.SelectedBundle.SelectedProduct.ProductId = product.ProductId;
        request.SelectedBundle.SelectedProduct.Quantity = product.Quantity > 0? product.Quantity : 1;

        List<Apttus_CPQApi.CPQ.SelectedOptionDO> selectedOptDOList = filterSelectedOptions(product);
        request.SelectedBundle.SelectedOptions = selectedOptDOList;
        System.Debug('request:'+request);
        Apttus_CPQApi.CPQ.AddBundleResponseDO response = Apttus_CPQApi.CPQWebService.addBundle(request);

        System.Debug('response:'+response);

        Decimal lineNumber =  response.LineNumber;

        return lineNumber;

    }
    public static List<Apttus_CPQApi.CPQ.SelectedOptionDO> filterSelectedOptions(APTSMD_ProductWrapperClass product){
        List<Apttus_CPQApi.CPQ.SelectedOptionDO> retList = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
        if(!product.prodOptionGroups.isEmpty()){
            for(APTSMD_ProductOptionGroupWrapper optGroup:product.prodOptionGroups){

                if(optGroup.maxOptions==1){// Radio button is used
                    Apttus_CPQApi.CPQ.SelectedOptionDO selectedOptDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();

                    //to retrieve the selected option details
                    if(optGroup.selectedprods !=null){
                        OptionComponentWrapper optWrap = getOptionComponentWrapper(optGroup.optionComponent,optGroup.selectedprods);
                        selectedOptDO.ComponentId = optWrap.componentId;
                        selectedOptDO.ComponentProductId = optWrap.componentProductId;
                        selectedOptDO.Quantity = optWrap.quantity;

                        //selectedOptDO.CustomFields.add('Apttus_Config2__ParentBundleNumber__c');

                        /*Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
                        liSO.Apttus_Config2__ParentBundleNumber__c = parentBundleNo;
                        selectedOptDO.CustomData = liSO;*/
                        retList.add(selectedOptDO);
                    }
                }else{
                    for(APTSMD_ProductOptionComponentWrapper optComp : optGroup.optionComponent){
                        if(optComp.selected!=null && optComp.selected){
                            Apttus_CPQApi.CPQ.SelectedOptionDO selectedOptDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();

                            selectedOptDO.ComponentId = optComp.productOptionComponentId;
                            selectedOptDO.ComponentProductId = optComp.componentProductId;
                            selectedOptDO.Quantity = optComp.defaultQuantity;

                           // selectedOptDO.CustomFields.add('Apttus_Config2__ParentBundleNumber__c');

                            /*Apttus_Config2__LineItem__c liSO = new Apttus_Config2__LineItem__c();
                            liSO.Apttus_Config2__ParentBundleNumber__c = parentBundleNo;
                            selectedOptDO.CustomData = liSO;*/
                            retList.add(selectedOptDO);
                        }
                    }
                }
            }
        }
        return retList;
    }
    public static OptionComponentWrapper getOptionComponentWrapper(List<APTSMD_ProductOptionComponentWrapper> optComponentList,Id selectedOptId){

        for(APTSMD_ProductOptionComponentWrapper optComp:optComponentList){
            if(optComp.productOptionComponentId == selectedOptId){
                return new OptionComponentWrapper(optComp.productOptionComponentId,optComp.componentProductId,optComp.defaultQuantity);
            }
        }
        return null;
    }
    public static boolean checkProductExistsforThisCart(string strProdId,integer iQuantity,String CartID)
    {
        List<Apttus_Config2__LineItem__c> lstCart = [select id, Name,Apttus_Config2__Description__c,Apttus_Config2__LineType__c,Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :CartID and Apttus_Config2__ProductId__c =: strProdId];
        if(lstCart.isEmpty()) return false;
        Apttus_Config2__LineItem__c updateLineItem = lstCart[0];
        updateLineItem.Apttus_Config2__Quantity__c = updateLineItem.Apttus_Config2__Quantity__c == null ? 0 : updateLineItem.Apttus_Config2__Quantity__c + iQuantity;
        update updateLineItem;
        return true;

    }
    //Code by Mayur - updateCartLineItems from Checkout for Multiple shipments
    public static APTSMD_cartData updateCartLineItems(APTSMD_cartWrapper cart){
        System.debug('>>> Cart Wrapper--'+cart);
        Set<Id> lineItemIds = new Set<Id>();
        Map<Id,APTSMD_cartWrapper.cartItems> lineItemWrapperMap = new Map<Id,APTSMD_cartWrapper.cartItems>();
        for(APTSMD_cartWrapper.cartItems item : cart.cartLineItems){
            lineItemIds.add(item.lineItemId);
            lineItemWrapperMap.put(item.lineItemId,item);
        }
        if(!lineItemIds.isEmpty()){
            List<Apttus_Config2__LineItem__c> lstLineItems = [select id, Name,Apttus_Config2__Description__c,Apttus_Config2__LineType__c,Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c, Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c,Apttus_Config2__ShipToAccountId__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where Id IN: lineItemIds];
            if(!lstLineItems.isEmpty()){
                for(Apttus_Config2__LineItem__c obj : lstLineItems){
                    if(lineItemWrapperMap.containsKey(obj.Id)){
                        obj.Apttus_Config2__ShipToAccountId__c = lineItemWrapperMap.get(obj.Id).shippingDetails.Id;
                        obj.Apttus_Config2__Quantity__c = lineItemWrapperMap.get(obj.Id).iQuantity;
                        obj.Apttus_Config2__PricingStatus__c = 'Pending'; //to reprice the cart again
                    }
                }
                update lstLineItems;
                updateCartPrice(cart.CartId);
                System.debug('>>> REPRICE DONE>>>');
            }
        }
        return getCartData();
    }
    public static void updateCartPrice(Id cartId)
    {

         Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
         objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
          // add request parameters
          objUpdatePriceRequestDO.CartId = cartId;
          // update price for the cart
          Apttus_CpqApi.CPQ.UpdatePriceResponseDO result =
         Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
         system.debug('result == '+result);


    }

    public static APTSMD_cartData removeCartItem(String strCartId,String strLineItemId)
    {
        Set<Id> prodIds;
        try
        {
            Apttus_Config2__LineItem__c objDelete =  [select id,Apttus_Config2__ProductId__c,Apttus_Config2__HasOptions__c from Apttus_Config2__LineItem__c where id =: strLineItemId];
            if(objDelete.Apttus_Config2__HasOptions__c){//for bundle products
                delete [SELECT Id FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ProductId__c=:objDelete.Apttus_Config2__ProductId__c AND Apttus_Config2__LineType__c ='Option'];
            }
            //Check for Any contraintRules associated with this product if exist delete the Applied Rule Info
            //checkAndRemoveAppliedRules(strCartId,objDelete.Apttus_Config2__ProductId__c);

            delete objDelete;
             //remove Constraint Rules
            Apttus_CPQApi.CPQWebService.applyConstraintRulesOnDelete(strCartId, new String[] {objDelete.Apttus_Config2__ProductId__c});
            prodIds = getConstraintRuleResultMessage(strCartId);
        }
        Catch(exception ex)
        {

            system.debug('Error in deleting cart item : '+ex.getMessage());
            throw ex;

        }
        return getCartData(prodIds);
    }

    public static void checkAndRemoveAppliedRules(String cartId,String productId){
        Set<Id> idsToDelete = new Set<Id>();
        // User API to remove product Ids

        //retrieve the Applied Rule Action Info records triggered by the product to be deleted
        List<Apttus_Config2__AppliedRuleActionInfo__c> appliedRuleActionList = [SELECT id,Apttus_Config2__AppliedRuleInfoId__c,Apttus_Config2__TriggeringProductIds__c FROM Apttus_Config2__AppliedRuleActionInfo__c WHERE Apttus_Config2__ConfigurationId__c=:cartId];
        if(!appliedRuleActionList.isEmpty()){
            for(Apttus_Config2__AppliedRuleActionInfo__c arAction : appliedRuleActionList){
                if(arAction.Apttus_Config2__TriggeringProductIds__c.containsIgnoreCase(productId)){
                    idsToDelete.add(arAction.Apttus_Config2__AppliedRuleInfoId__c);
                }
            }
            //DELETE the Applied Rule Info it will delete Actions too as they are in Maste-Detail Relationsship
            DELETE[SELECT Id,Name FROM Apttus_Config2__AppliedRuleInfo__c WHERE ID IN:idsToDelete];
        }
    }
    public static APTSMD_cartWrapper.cartItems cloneCartItem(String strCartId,String strLineItemId,String prodId,Integer quantity){
        try
        {

            /*Apttus_Config2__LineItem__c obj =  [select id,Apttus_Config2__ProductId__c,Apttus_Config2__HasOptions__c from Apttus_Config2__LineItem__c where id =: strLineItemId];
            /*if(obj.Apttus_Config2__HasOptions__c){//for bundle products
                List<Apttus_Config2__LineItem__c> lstClone = [SELECT Id FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ProductId__c=:obj.Apttus_Config2__ProductId__c];
            }*//*
            Apttus_Config2__LineItem__c clonedObj = obj.clone(false,true);
            insert clonedObj;*/
            Set<Id> SuggestedProductIds =  addMultipleProducts(prodId,quantity,strCartId);
            System.debug('--Cloned Line Item- id-');
        }
        Catch(exception ex)
        {

            system.debug('Error in deleting cart item : '+ex.getMessage());
            throw ex;

        }
        APTSMD_cartData cartdata = new APTSMD_cartData();
        APTSMD_cartWrapper lineItemwarpper = new APTSMD_cartWrapper();
        APTSMD_cartWrapper.cartItems lineItem = new APTSMD_cartWrapper.cartItems();
        List<Apttus_Config2__LineItem__c> lstCartLineItems = [select id,Apttus_Config2__BasePrice__c,Apttus_Config2__ProductId__c,Apttus_Config2__LineType__c,Apttus_Config2__ProductId__r.APTSMD_Lead_Time__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Name,Apttus_Config2__ProductId__r.Description,Apttus_Config2__Quantity__c,Apttus_Config2__ListPrice__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c,Apttus_Config2__OptionId__r.Name,Apttus_Config2__NetPrice__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =: strCartId order by createdDate DESC limit 1];
        for(Apttus_Config2__LineItem__c obj : lstCartLineItems)
        {
            if(obj.Apttus_Config2__LineType__c.equalsIgnoreCase('Product/Service')){

                lineItem.ProductId = obj.Apttus_Config2__ProductId__c;
                lineItem.iQuantity = integer.ValueOf(obj.Apttus_Config2__Quantity__c);
                System.debug('>>> INSIDE GET CART HISTORY: '+lineItem.iQuantity);
                lineItem.lineItemPrice = obj.Apttus_Config2__ListPrice__c;
                lineItem.basePrice = obj.Apttus_Config2__BasePrice__c;
                lineItem.lineItemId = obj.Id;
                lineItem.UOM = obj.Apttus_Config2__Uom__c;
                lineItem.leadTime = obj.Apttus_Config2__ProductId__r.APTSMD_Lead_Time__c;
                lineItem.netPrice = obj.Apttus_Config2__NetPrice__c;
                // lineItemwarpper.cartLineItems.add(lineItem);
                // cartdata.cartWrapper = lineItemwarpper;
                // cartdata.add(lineItemwarpper);
            }
        }
        return lineItem;
        // return getCartData();
    }
    public static APTSMD_cartData modifyCartItemQuantity(String strItemID, string CartId, Integer iQuantity,String strProductId)
    {
        try
        {
            List<Apttus_Config2__ProductConfiguration__c> lstCart = new List<Apttus_Config2__ProductConfiguration__c>();

            Apttus_Config2__LineItem__c lineItemId = [select id,Apttus_Config2__PricingStatus__c,Apttus_Config2__Quantity__c,Apttus_Config2__HasOptions__c,Apttus_Config2__LineNumber__c, Apttus_Config2__Uom__c from Apttus_Config2__LineItem__c where id =: strItemID and  Apttus_Config2__ProductId__c =: strProductId];
            //lineItemId.Apttus_Config2__Quantity__c = lineItemId.Apttus_Config2__Quantity__c == null ? 0 :
                                                                //lineItemId.Apttus_Config2__Quantity__c + iQuantity;
            lineItemId.Apttus_Config2__Quantity__c = iQuantity;
            System.debug('>>> INSIDE MODIFY QUANTITY: '+iQuantity);
            lineItemId.Apttus_Config2__PricingStatus__c = 'Pending';

            for(Apttus_Config2__ProductConfiguration__c obj : [select id,Apttus_Config2__IsPricePending__c from Apttus_Config2__ProductConfiguration__c where id =: CartId])
            {
                obj.Apttus_Config2__IsPricePending__c = true;
                lstCart.add(obj);
            }
            if(lstCart.size() > 0)
                update lstCart;

             update lineItemId;
             if(lineItemId.Apttus_Config2__HasOptions__c){
                //get Net Price for Bundle
                Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO request = new
                Apttus_CPQApi.CPQ.ComputeNetPriceRequestDO();
                request.CartId = CartId;
                request.LineNumber = lineItemId.Apttus_Config2__LineNumber__c;
                Apttus_CPQApi.CPQ.ComputeNetPriceResponseDO priceResponse =
                Apttus_CPQApi.CPQWebService.computeNetPriceForBundle(request);
             }else{
                //reprice
                Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
                objUpdatePriceRequestDO.CartId = CartID;
                Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
             }


        }
        catch(Exception ex)
        {

            system.debug('Error in modifying cart item :' + ex.getMessage());
            throw ex;

        }
        //return null;
        return getCartData();
    }

    public static APTSMD_cartData getCartData()
    {
        return getCartDataWrapper();
    }

    //With recommended products
    public static APTSMD_cartData getCartData(Set<id> recomProdIds)
    {
        APTSMD_cartData cd = getCartDataWrapper();
        cd.suggestedProdIds = recomProdIds;

        return cd;
    }

    public static APTSMD_cartData getCartSuggestedProduct(){
        APTSMD_cartData cd = getCartDataWrapper();
        Set<Id> prodIds = getConstraintRuleResultMessage(cd.cartWrapper.CartId);
        cd.suggestedProdIds = prodIds;
        return cd;

    }
    public static APTSMD_cartData getCartDataWrapper(){
        APTSMD_cartWrapper cr = getCartDetails(null);
        Apttus_CPQApi.CPQ.SelectedProductDO prodItem = new Apttus_CPQApi.CPQ.SelectedProductDO();
        APTSMD_cartWrapper.cartItems ci = new APTSMD_cartWrapper.cartItems();
        APTSMD_productDetailsForTaxCalc pdft = new APTSMD_productDetailsForTaxCalc();
        APTSMD_CyberSource_CC_AuthRequest ar = new APTSMD_CyberSource_CC_AuthRequest();

        APTSMD_cartData cd = new APTSMD_cartData();
        cd.cartWrapper  = cr;
        cd.prodItem = prodItem;
        cd.cartItem = ci;
        cd.prodDetailForTax = pdft;
        cd.authRequest = ar;

        return cd;
    }

    public static List<APTSMD_orderHistory> getOrderHstory()
    {
        List<APTSMD_orderHistory> lstOrderHistory = new List<APTSMD_orderHistory>(); //where CreatedById =: UserInfo.getUserId() and Apttus_Config2__Status__c !=: 'New' order by CreatedDate DESC])

        Set<id> orderIdS0 = new Set<Id>();
        List<Apttus_Config2__Order__c> objorderSO = [select id,Apttus_Config2__Status__c,Name,CreatedBy.FirstName,
                                                CreatedBy.LastName,CreatedDate,Owner.FirstName, Owner.LastName,Apttus_Config2__OrderDate__c from Apttus_Config2__Order__c where ownerId=: UserInfo.getUserId() and Apttus_Config2__Status__c !=: 'New' order by CreatedDate DESC];
        system.debug('orderlineitem****************');
        map<String,List<Apttus_Config2__OrderLineItem__c>> groupMap=new Map<String,List<Apttus_Config2__OrderLineItem__c>>();
        for(Apttus_Config2__Order__c temp: objorderSO) {
            orderIdS0.add(temp.Id);
        }
        List<Apttus_Config2__OrderLineItem__c> oli1 = [SELECT Id,Apttus_Config2__ProductId__r.Name,Apttus_Config2__OrderId__c,Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c,Apttus_Config2__BasePrice__c,Apttus_Config2__LineType__c FROM Apttus_Config2__OrderLineItem__c
                                                                WHERE Apttus_Config2__OrderId__c In : orderIdS0];
        system.debug('orderlineitem****************1'+oli1);
        for(Apttus_Config2__OrderLineItem__c temp1 : oli1) {
                List<Apttus_Config2__OrderLineItem__c> mlist;
               if(groupMap.containsKey(temp1.Apttus_Config2__OrderId__c)) {
                   mlist = groupMap.get(temp1.Apttus_Config2__OrderId__c);

               }else{
                   mlist = new List<Apttus_Config2__OrderLineItem__c>();
               }
               mlist.add(temp1);
               groupMap.put(temp1.Apttus_Config2__OrderId__c,mlist);
             system.debug('orderlineitem****************2'+groupMap);
        }
        for(Apttus_Config2__Order__c objOrder : [select id,Apttus_Config2__Status__c,Name,CreatedBy.FirstName,
                                                CreatedBy.LastName,CreatedDate,Owner.FirstName, Owner.LastName,Apttus_Config2__OrderDate__c from Apttus_Config2__Order__c where ownerId=: UserInfo.getUserId() and Apttus_Config2__Status__c !=: 'New' order by CreatedDate DESC])
        {
                APTSMD_orderHistory orderRec = new APTSMD_orderHistory();
                orderRec.OrderId = objOrder.Id;
                orderRec.OrderStatus = objOrder.Apttus_Config2__Status__c;
                orderRec.OrderNumber = objOrder.Name;
                //orderRec.UserName = objOrder.CreatedBy.FirstName + ' ' + objOrder.CreatedBy.Lastname;
                orderRec.UserName = objOrder.Owner.FirstName + ' ' + objOrder.Owner.Lastname;
                //orderRec.OrderDate = date.newinstance(objOrder.CreatedDate.year(), objOrder.CreatedDate.month(), objOrder.CreatedDate.day());
                //orderRec.OrderDate = date.newinstance(objOrder.Apttus_Config2__OrderDate__c.year(), objOrder.Apttus_Config2__OrderDate__c.month(), objOrder.Apttus_Config2__OrderDate__c.day());
                orderRec.OrderDate = objOrder.Apttus_Config2__OrderDate__c;
                List<Apttus_Config2__OrderLineItem__c> orderlineitemlist = groupMap.get(objOrder.Id);
                // List<Apttus_Config2__OrderLineItem__c> oli = [SELECT Id,Apttus_Config2__ProductId__r.Name,Apttus_Config2__Quantity__c,Apttus_Config2__NetPrice__c FROM Apttus_Config2__OrderLineItem__c
                //                                                 WHERE Apttus_Config2__OrderId__c =: objOrder.Id limit 4];
                if(orderlineitemlist!= null && orderlineitemlist.Size()>0) {
                    integer count = 0;
                     for(Apttus_Config2__OrderLineItem__c temp : orderlineitemlist) {
                         if(count < 4) {
                             if(!temp.Apttus_Config2__LineType__c.equalsIgnoreCase('option')){
                                APTSMD_orderHistory.orderlineitem objLine = new APTSMD_orderHistory.orderlineitem();
                                objLine.ProdName = temp.Apttus_Config2__ProductId__r.Name;
                                objLine.Quantity = temp.Apttus_Config2__Quantity__c;
                                objLine.Netprice = temp.Apttus_Config2__NetPrice__c;
                                objLine.lineItemPrice = temp.Apttus_Config2__BasePrice__c;
                                count++;
                                orderRec.orderline.add(objLine);
                            }
                         }else{
                             break;
                         }

                        }
                }

                system.debug('orderlineitem****************3'+orderRec);
                //system.debug('order date::::'+orderRec.OrderDate);
                lstOrderHistory.add(orderRec);

        }
        system.debug('orderlineitem****************4'+lstOrderHistory);
        return lstOrderHistory;

    }

    public static decimal CalculateShippingCharges(Decimal dOrderAmount,String strShipMethod)
    {
        //Shipping_Option__c
        decimal dShippingCharges = 0;
         system.debug('In CalculateShippingCharges == '+strShipMethod);
          system.debug('In CalculateShippingCharges dOrderAmount == '+dOrderAmount);
        for(APTSMD_Shipping_Option__c objShip : [select id,name,APTSMD_FedEDx_Second_Day__c,APTSMD_FedEx_Ground__c,APTSMD_FedEx_Overnight__c,APTSMD_Ground_Percentage__c,APTSMD_Max_Amount__c,APTSMD_Min_Amount__c,APTSMD_OverNight_Percentage__c,APTSMD_SecondDay_Percentage__c from APTSMD_Shipping_Option__c where APTSMD_Min_Amount__c <=: dOrderAmount and APTSMD_Max_Amount__c >=: dOrderAmount])
        {
            system.debug('In CalculateShippingCharges objShip== '+objShip);
            if(strShipMethod == 'Ground')
            {
                if(objShip.APTSMD_FedEx_Ground__c == 0 || objShip.APTSMD_FedEx_Ground__c == null)
                    dShippingCharges = CalculateOnPercentage(dOrderAmount,objShip.APTSMD_Ground_Percentage__c);
                else
                    dShippingCharges = objShip.APTSMD_FedEx_Ground__c;

            }
            else if(strShipMethod == 'Overnight')
            {
                if(objShip.APTSMD_FedEx_Overnight__c == 0 || objShip.APTSMD_FedEx_Overnight__c == null)
                    dShippingCharges = CalculateOnPercentage(dOrderAmount,objShip.APTSMD_OverNight_Percentage__c);
                else
                    dShippingCharges = objShip.APTSMD_FedEx_Overnight__c;

            }
            else if(strShipMethod == 'Second Day')
            {
                if(objShip.APTSMD_FedEDx_Second_Day__c == 0 || objShip.APTSMD_FedEDx_Second_Day__c == null)
                    dShippingCharges = CalculateOnPercentage(dOrderAmount,objShip.APTSMD_SecondDay_Percentage__c);
                else
                    dShippingCharges = objShip.APTSMD_FedEDx_Second_Day__c;

            }


        }
        return dShippingCharges;
    }

    public static APTSMD_cartData repriceCart(String cartId){
        reprice(cartId);
        return getCartData();
    }
    public static decimal CalculateOnPercentage(Decimal dOrderAmount,Decimal dPercentage)
    {
        if(dPercentage == null) dPercentage = 0;
        return (dOrderAmount * dPercentage)/100;
    }
    public class OptionComponentWrapper{
        Id componentId;
        Id componentProductId;
        Decimal quantity;

        public OptionComponentWrapper(Id componentId, Id componentProductId,Decimal quantity){
            this.componentId = componentId;
            this.componentProductId = componentProductId;
            this.quantity = quantity;
        }
    }


}