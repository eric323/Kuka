public without sharing class APTSMD_OrderUtils
{


    public static APTSMD_OrderDetails GetOrderHistory(String strOrderId,String strCartID)
    {


        List<APTSMD_OrderDetails.LineItems> lstLineItems = new List<APTSMD_OrderDetails.LineItems>();
        APTSMD_OrderDetails objOrder = new APTSMD_OrderDetails();

        system.debug('strOrderId == '+strOrderId);
        system.debug('strCartID == '+strCartID);
        for(Apttus_Config2__LineItem__c lineItem : [select id,Name,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__Country__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__State__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__City__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__Street__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestStreet__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestCity__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestState__c , Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestCountry__c , Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestCode__c ,
    Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Owner.Name,  Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__PostalCode__c, Apttus_Config2__ConfigurationId__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Name,Apttus_Config2__Description__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Order_Amount__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Shipping_Charges__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Shipping_Method__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Tax_On_Order_Amount__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Ship_To_Name__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Ship_To_Number__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__ShipToAccountId__r.ShippingCity,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__ShipToAccountId__r.ShippingCountry,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__ShipToAccountId__r.ShippingState,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__ShipToAccountId__r.ShippingStreet,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__ShipToAccountId__r.ShippingPostalCode,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__OrderDate__c,APTSMD_Bundle_Product_Code__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__Status__c,Apttus_Config2__PriceUom__c,Apttus_Config2__Uom__c,Apttus_Config2__Quantity__c,Apttus_Config2__ListPrice__c,Apttus_Config2__BaseExtendedPrice__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__IsPricePending__c, Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Promotion__c,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__r.Name,Apttus_Config2__OptionId__r.ProductCode, Apttus_Config2__BasePrice__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Id =: strOrderId and Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__Status__c!='Cancelled'])
        {
            //where Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Id =: strOrderId

            //where Apttus_Config2__ConfigurationId__c =: strCartID

            if(objOrder.Order_Number == null)
            {
                objOrder.Order_Number = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Name;
                objOrder.Order_ID = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__c;
                ObjOrder.dOrderAmount = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Order_Amount__c;
                ObjOrder.dShippingCharges = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Shipping_Charges__c;
                ObjOrder.dTaxAmount = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Tax_On_Order_Amount__c;
                ObjOrder.Shipto_Name = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Ship_To_Name__c;
                //ObjOrder.dOrderAmount = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Order_Amount__c;
                ObjOrder.Shipto_Address1 = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__Street__c;
                ObjOrder.Shipto_City = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__City__c;
                ObjOrder.Shipto_State = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__State__c;
                ObjOrder.Shipto_Zip = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__PostalCode__c;
                ObjOrder.Shipto_Country = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Account_Location__r.Apttus_Config2__Country__c;
                objOrder.Order_Date = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__OrderDate__c;
                objOrder.Product_Code = lineItem.APTSMD_Bundle_Product_Code__c;
                objOrder.Order_Status = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Apttus_Config2__Status__c;

                objOrder.Shipping_Method_Value = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Shipping_Method__c;

                ObjOrder.Promotion = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Promotion__c != null ? lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_Promotion__c : 0.00;

                objOrder.GuestShipTo_Street = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestStreet__c;
                objOrder.GuestShipTo_City = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestCity__c ;
                objOrder.GuestShipTo_State = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestState__c ;
                objOrder.GuestShipTo_Country = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestCountry__c ;
                objOrder.GuestShipTo_Code = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.APTSMD_GuestCode__c;
                objOrder.owner = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_Config2__OrderId__r.Owner.Name;


            }
            APTSMD_OrderDetails.LineItems objLine = new APTSMD_OrderDetails.LineItems();
            if(lineItem.Apttus_Config2__LineType__c.equalsIgnoreCase('option')){
                objLine.Item_Name = lineItem.Apttus_Config2__OptionId__r.Name;
                objLine.PartNumber = lineItem.Apttus_Config2__OptionId__r.ProductCode;
            }else{
                objLine.Item_Name = lineItem.Apttus_Config2__ProductId__r.Name;
                objLine.PartNumber = lineItem.APTSMD_Bundle_Product_Code__c;
            }

            String strLineDesc = lineItem.Apttus_Config2__Description__c;
            //strLineDesc = strLineDesc.replace('"','&#34;');
            objLine.Item_Desc = strLineDesc;
            objLine.lineType = lineItem.Apttus_Config2__LineType__c;
            objLine.UOM = lineItem.Apttus_Config2__Uom__c;
            objLine.quantity = lineItem.Apttus_Config2__Quantity__c;
            objLine.Unit_Price = lineItem.Apttus_Config2__ListPrice__c;
            objLine.Total_Price = lineItem.Apttus_Config2__NetPrice__c;
            objLine.lineItemPrice = lineItem.Apttus_Config2__BasePrice__c;

            ObjOrder.line_Items.add(objLine);
            //lineItemDetails.add(objLine);
        }

        //ObjOrder.line_Items = lineItemDetails;
        return objOrder;
    }



    public static String SaveOrderDetails(APTSMD_OrderDetails orderInfo)
    {
        system.debug('orderInfo == '+orderInfo);
        System.debug('>> cartId : '+orderInfo.cartId);
        //Update Price of CART

        //cartUtils.updateCartPrice(orderInfo.Cart_ID);
        /*for(Apttus_Config2__LineItem__c lineItem : [select id from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__IsPricePending__c =: true and Apttus_Config2__ConfigurationId__c =: orderInfo.Cart_ID])
        {
            Cartutils.updateCartPrice(lineItem.Id);

        }*/
        Apttus_Config2__Order__c objOrderUpdate = new Apttus_Config2__Order__c();

        objOrderUpdate.Id = orderInfo.Order_ID;
        objOrderUpdate.APTSMD_Account_Location__c=orderInfo.accLocation_Id;
        objOrderUpdate.APTSMD_Order_Amount__c = orderInfo.dOrderAmount;
        objOrderUpdate.APTSMD_Tax_On_Order_Amount__c = orderInfo.dTaxAmount == null ? 0.00 : orderInfo.dTaxAmount;
        objOrderUpdate.APTSMD_Shipping_Charges__c = orderInfo.dShippingCharges == null ? 0.00 : orderInfo.dShippingCharges;
        if(!orderInfo.multipleShipment){//for Multipleshipment no need to save this
            objOrderUpdate.APTSMD_Ship_To_Name__c = orderInfo.Shipto_Name;
            objOrderUpdate.APTSMD_Ship_To_Number__c = orderInfo.ShipTo_Phone;
            objOrderUpdate.APTSMD_Shipping_Method__c = orderInfo.Shipping_Method_Value;
            objOrderUpdate.APTSMD_Shipping_Instructions__c = orderInfo.Shipping_Instructions;
        }
        objOrderUpdate.Apttus_Config2__Status__c = 'Pending';
        objOrderUpdate.Apttus_Config2__OrderDate__c = System.DateTime.Now();
        objOrderUpdate.Apttus_Config2__Description__c = '';
        objOrderUpdate.APTSMD_Promotion__c = orderInfo.Promotion;
        objOrderUpdate.Apttus_Config2__PONumber__c = orderInfo.poNumber;

        objOrderUpdate.APTSMD_GuestStreet__c = orderInfo.GuestShipTo_Street;
        objOrderUpdate.APTSMD_GuestCity__c = orderInfo.GuestShipTo_City;
        objOrderUpdate.APTSMD_GuestState__c = orderInfo.GuestShipTo_State;
        objOrderUpdate.APTSMD_GuestCountry__c = orderInfo.GuestShipTo_Country;
        objOrderUpdate.APTSMD_GuestCode__c = orderInfo.GuestShipTo_Code;

            objOrderUpdate.APTSMD_PAYMENT_TYPE__c = 'Credit_Card';
            objOrderUpdate.APTSMD_CREDIT_CARD_APPROVAL_CODE__c = orderInfo.cyberSourceResponse != null ? orderInfo.cyberSourceResponse.authorizationCode : '';
            objOrderUpdate.APTSMD_CREDIT_CARD_APPROVAL_DATE__c = System.today();
            //objOrderUpdate.Bank_ID__c = GenerateBankId(orderInfo);

        objOrderUpdate.Apttus_Config2__BillToAccountId__c = orderInfo.BillTo_Account_Id != null && orderInfo.BillTo_Account_Id != '' ? orderInfo.BillTo_Account_Id : null;

        if(!orderInfo.multipleShipment){//for Multipleshipment no need to save this
            objOrderUpdate.Apttus_Config2__SoldToAccountId__c = orderInfo.ShipTo_Account_Id != null && orderInfo.ShipTo_Account_Id != '' ? orderInfo.ShipTo_Account_Id : null;
            objOrderUpdate.Apttus_Config2__ShipToAccountId__c = orderInfo.ShipTo_Account_Id != null && orderInfo.ShipTo_Account_Id != '' ? orderInfo.ShipTo_Account_Id : null;
        }
        Map<Id,Account> mapAccts = new Map<Id,Account>([SELECT Id,Name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,
                                ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where id=: orderInfo.BillTo_Account_Id OR id=: orderInfo.ShipTo_Account_Id]);


        if(!mapAccts.isEmpty())
        {
            Account billToAccount = mapAccts.get(orderInfo.BillTo_Account_Id);

            if(billToAccount!= null)
            {
                objOrderUpdate.APTSMD_BillingStreet__c = billToAccount.BillingStreet;
                objOrderUpdate.APTSMD_BillingCity__c = billToAccount.BillingCity;
                objOrderUpdate.APTSMD_BillingState__c = billToAccount.BillingState;
                objOrderUpdate.APTSMD_BillingPostalCode__c = billToAccount.BillingPostalCode;
                objOrderUpdate.APTSMD_BillingCountry__c = billToAccount.BillingCountry;
                objOrderUpdate.APTSMD_CustomerBillingName__c = billToAccount.Name;
            }
            if(!orderInfo.multipleShipment){//for Multipleshipment no need to save this

                Account shipToAccount = mapAccts.get(orderInfo.ShipTo_Account_Id);

                if(shipToAccount!= null)
                {

                    objOrderUpdate.APTSMD_ShippingStreet__c = shipToAccount.ShippingStreet;
                    objOrderUpdate.APTSMD_ShippingCity__c = shipToAccount.ShippingCity;
                    objOrderUpdate.APTSMD_ShippingState__c = shipToAccount.ShippingState;
                    objOrderUpdate.APTSMD_ShippingPostalCode__c = shipToAccount.ShippingPostalCode;
                    objOrderUpdate.APTSMD_ShippingCountry__c = shipToAccount.ShippingCountry;
                    objOrderUpdate.APTSMD_CustomerShippingName__c = shipToAccount.Name;
                }
            }

        }


        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        objOrderUpdate.APTSMD_Account__c = objContact.accountId;
        //update status and activation date
        objOrderUpdate.Apttus_Config2__Type__c = 'Completed';
        objOrderUpdate.Apttus_Config2__Status__c = 'Pending';
        objOrderUpdate.Apttus_Config2__ActivatedDate__c = System.now();
        objOrderUpdate.APTSSP_Source__c='E-Commerce';
        //system.debug('Order Details in Save::::'+objOrderUpdate);
        upsert objOrderUpdate;
        Apttus_Config2__Order__c updatedOrder = [select id,Name,Apttus_Config2__Status__c from Apttus_Config2__Order__c where id =: objOrderUpdate.Id];

        //Create record in staging table to process ERP
        createStagingRecord(updatedOrder);
        //sendEmailNotifications(objOrderUpdate.Id);
        //system.debug('updatedOrder===='+updatedOrder);
        //create Order Line Items
        System.debug('>>Creating Line Items');
        createOrderLineItems(orderInfo.Order_ID);
        //createOpportunity(orderInfo.Order_ID);
        createAsset(orderInfo.Order_ID);
        return updatedOrder.Id;

    }

    private static void createOrderLineItems(String orderId){
        String configId;
        List<Apttus_Config2__ProductConfiguration__c> lstOrderConfig = [SELECT Id,Name,OwnerId,Apttus_Config2__Status__c FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__OrderId__c =:orderId];

        if(!lstOrderConfig .isEmpty()){
            configId = lstOrderConfig[0].Id;
            // Create Order Line Item using CPQ API
            lstOrderConfig[0].Apttus_Config2__Status__c = 'Finalized';
            // Create the request
            Apttus_Config2.CPQStruct.SynchronizeCartRequestDO request = new Apttus_Config2.CPQStruct.SynchronizeCartRequestDO();

            // Add request parameters
            request.CartId =configId;

            // Synchronize cart
            Apttus_Config2.CPQStruct.SynchronizeCartResponseDO result = Apttus_Config2.OrderWebService.synchronizeCart(request);
            System.debug('Order Line ITem Result : '+result);
            update lstOrderConfig[0];
        }
    }

    //Private method commented out because of line 184, it was commented out by default and the method is not used anywhere
   //private static void createOpportunity(String orderId){
       // User user = [select contactId from user where id =: UserInfo.getUserId()];
        //Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        //Account objUserAcc = [select id,Name,APTSMD_Dealer_del__c,APTSMD_Pricing_Agreement_Number__c from Account where id =: objContact.accountId];
        //Apttus_Config2__Order__c orderObj = [select id,Name,Apttus_Config2__PriceListId__c FROM Apttus_Config2__Order__c where Id =: orderId];
        //List<Apttus_Config2__PriceList__c> priceList = [SELECT id,name FROM Apttus_Config2__PriceList__c WHERE name='Greentech'];

       //Opportunity opp = new Opportunity();
        //opp.AccountId = objUserAcc.id;
        //opp.Name = 'Opportunity for '+orderObj.name;
        //opp.CloseDate = System.Today().addYears(1);
        //opp.StageName = 'Qualification';
       // opp.APTSMD_Partner_Opportunity__c = TRUE;

       // if(!priceList .isEmpty()){
       //     opp.Price_List__c = priceList[0].id; //orderObj.Apttus_Config2__PriceListId__c;
        //}
        //opp.APTSMD_Partner_Opportunity__c = TRUE;

       // insert opp;

       // orderObj.Apttus_Config2__RelatedOpportunityId__c = opp.id;
       // update orderObj;

   // }


    //Code By Mayur :  CreateQuote - change the configuration from Order to Proposal
    public static APTSMD_ProposalDetails createQuote(String storePriceList, APTSMD_cartWrapper cartInfo){
        Apttus_Proposal__Proposal__c quote;
        list <Apttus_Presales_eCommerce_Settings__c> ecommSettingList = new list<Apttus_Presales_eCommerce_Settings__c>();
        Apttus_Presales_eCommerce_Settings__c eCommSetting=  Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();

        List <Apttus_Config2__Order__c> listOfOrder = new list<Apttus_Config2__Order__c>();
        System.debug('>>>Create Quote: Cart info : '+cartInfo);
        User user = [select contactId from user where id =: UserInfo.getUserId()];
        Contact objContact = user.contactId != null ? [select id,accountId from Contact where id =: user.contactId] : APTSMD_categoriesUtils.getGuestContact();
        Account objUserAcc = [select id,Name,APTSMD_Dealer_del__c,APTSMD_Pricing_Agreement_Number__c from Account where id =: objContact.accountId];
        Apttus_Config2__PriceList__c priceList = getPriceList(storePriceList,objUserAcc);
        if(priceList !=null){
            Opportunity oppty = createOpportunity(objUserAcc,priceList);
            quote = createProposal(objUserAcc,priceList,oppty);
            string configurationId;
            //change configuration business object to proposal
            Apttus_Config2__ProductConfiguration__c prodConfig;
            List<Apttus_Config2__ProductConfiguration__c> prodConfigList = [SELECT Id,Name,Apttus_Config2__BusinessObjectId__c,Apttus_Config2__BusinessObjectType__c,Apttus_QPConfig__Proposald__c,Apttus_Config2__OrderId__c,Apttus_Config2__Status__c,Apttus_Config2__PriceListId__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id=:cartInfo.CartId LIMIT 1];

            if(!prodConfigList.isEmpty()){
                prodConfig = prodConfigList[0];

                //get the orders to delete
                listOfOrder = [SELECT id FROM Apttus_Config2__Order__c WHERE id=:prodConfig.Apttus_Config2__OrderId__c];
                System.debug('-->> Get Order--> '+listOfOrder);
                prodConfig.Apttus_QPConfig__Proposald__c = quote.Id;
                prodConfig.Apttus_Config2__BusinessObjectId__c = quote.Id;
                prodConfig.Apttus_Config2__BusinessObjectRefId__c = quote.Id; //to be use in new CPQ Feb package
                prodConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
                // prodConfig.Apttus_Config2__Status__c = 'Saved';
                prodConfig.Apttus_Config2__OrderId__c = null;
                prodConfig.Apttus_Config2__PriceListId__c = priceList.Id;

                update prodConfig;
                 System.debug('*************************prodConfig : ' +prodConfig);
                //set Order status to cancelled
                // List<Apttus_Config2__Order__c> orderList = [SELECT Id,Name,Apttus_Config2__Status__c FROM Apttus_Config2__Order__c WHERE Id=:cartInfo.OrderId LIMIT 1];
                // if(!orderList.isEmpty()){
                //     orderList[0].Apttus_Config2__Status__c = 'Cancelled';
                //     update orderList;
                // }

                //Reprice Quote

                Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
                objUpdatePriceRequestDO.CartId = prodConfig.Id;
                Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);

                configurationId = prodConfig.Id;


            }
            System.debug('*************************quote created: ');
            System.debug('------------------------quote :'+quote);
            quote.APTSMD_eCommerce_Proposal__c = TRUE;

            //-----------------------
            //finalize the cart
            Apttus_CPQApi.CPQ.FinalizeCartRequestDO finalRequest = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();
            finalRequest.CartId = configurationId;
            Apttus_CPQApi.CPQ.FinalizeCartResponseDO finalResponse = Apttus_CPQApi.CPQWebService.finalizeCart(finalRequest);

            if(eCommSetting.APTSMD_Generate_Billing_Schedule__c){
                String APTSMD_OrderID = createOrder(quote);


                prodConfig.Apttus_Config2__OrderId__c = APTSMD_OrderID;
                prodConfig.Apttus_Config2__Status__c = 'Finalized';
                update prodConfig;
                System.debug('---------------prodConfig :'+prodConfig);
                Apttus_Config2__Order__c order = new Apttus_Config2__Order__c(Id = APTSMD_OrderID, Apttus_QPConfig__ProposalId__c = prodConfig.Apttus_QPConfig__Proposald__c,Apttus_Config2__ActivatedDate__c=null);
                update order;
                synchronizeCart(prodConfig);
                createAsset(APTSMD_OrderID);
                order.Apttus_Config2__ActivatedDate__c=date.today();
                update order;
                Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(Id = prodConfig.Apttus_QPConfig__Proposald__c, Apttus_QPConfig__AutoActivateOrder__c = true, Apttus_Proposal__Approval_Stage__c = 'Accepted');
                update proposal;
                 System.debug('---------------proposal :'+proposal);
            }

        }
        System.debug('-->> Before Delete Order--> '+listOfOrder);
        delete listOfOrder;
        return getProposalDetails(quote.id,cartInfo.CartId);
        //return null;

    }

     //-*********----------------------------------------rudraRudra

     private static String  createOrder(Apttus_Proposal__Proposal__c quote)
    {
        // Create the request
        Apttus_Config2.CPQStruct.CreateOrderRequestDO request = new Apttus_Config2.CPQStruct.CreateOrderRequestDO();

        // Add request parameters
        request.AccountId = quote.Apttus_Proposal__Account__c;
        request.PriceListId = quote.Apttus_Proposal__Account__r.Price_List__c;
        request.PricingDate = Datetime.now();

        // Create a new order
        Apttus_Config2.CPQStruct.CreateOrderResponseDO result = Apttus_Config2.OrderWebService.createOrder(request);
        // Assign orderId to local variable
        return result.OrderSO.Id;
    }

      private static void synchronizeCart(Apttus_Config2__ProductConfiguration__c prodConfig)
    {
        // Create the request
        Apttus_Config2.CPQStruct.SynchronizeCartRequestDO request = new Apttus_Config2.CPQStruct.SynchronizeCartRequestDO();

        // Add request parameters
        request.CartId = prodConfig.Id;

        // Synchronize cart
        Apttus_Config2.CPQStruct.SynchronizeCartResponseDO result = Apttus_Config2.OrderWebService.synchronizeCart(request);
    }

    private static void createAsset(String orderId)
    {
        // Create the request
        Apttus_Config2.CPQStruct.CreateAssetRequestDO request = new Apttus_Config2.CPQStruct.CreateAssetRequestDO();

        // Add request parameters
        request.OrderId = orderId;

        // Create Asset Line Items
        Apttus_Config2.CPQStruct.CreateAssetResponseDO result = Apttus_Config2.OrderWebService.createAsset(request);
    }

    //-----------------------------------------rudra --------------

    //get Price List related to Account
    //@Return Price List Object
    public static Apttus_Config2__PriceList__c getPriceList(String PLId,Account acc){
        List<Apttus_Config2__PriceList__c> priceList;
        if(PLId != null){
            priceList = [select id,name from Apttus_Config2__PriceList__c where id =:PLId  limit 1];
        }
        else{
            priceList = [select id,name from Apttus_Config2__PriceList__c where APTSMD_District__c =: acc.APTSMD_Dealer_del__c limit 1];
        }

        return !priceList.isEmpty()? priceList[0] :null;
    }

    //createOpportunity
    //@param Account and Price List Object
    //@Return Opportunity object
    public static Opportunity createOpportunity(Account acc,Apttus_Config2__PriceList__c priceList){
        Opportunity opp = new Opportunity();
        if(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().containsKey('Tier1 Systems')){
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Tier1 Systems').getRecordTypeId();
        }
        opp.Name = acc.Name+' Opportunity From Ecommerce';
        opp.AccountId = acc.id;
        opp.CloseDate = System.Today().addYears(1);
        opp.StageName = 'Qualification';
        opp.Price_List__c = priceList.id;

        //Set default pricebook to opportunity
        Pricebook2 pb2 = [SELECT Id,Name FROM PriceBook2 WHERE IsStandard=TRUE LIMIT 1];
        opp.Pricebook2Id = pb2 !=null ? pb2.Id :null;
        insert opp;
        return opp;
    }
    //createOpportunity
    //@param Account, Price List and Opportunity Object
    //@Return Opportunity object
    public static Apttus_Proposal__Proposal__c createProposal(Account acc,Apttus_Config2__PriceList__c priceList,Opportunity oppty){
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.Apttus_Proposal__Proposal_Name__c = 'Proposal for '+acc.Name+' from Ecommerce';
        proposal.Apttus_Proposal__Account__c = acc.Id;
        proposal.Apttus_Proposal__Opportunity__c = oppty.Id;
        proposal.Apttus_QPConfig__PriceListId__c = priceList.Id;

        if(Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().containsKey('Tier1 Systems')){
            proposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Tier1 Systems').getRecordTypeId();
        }
        proposal.APTSMD_eCommerce_Proposal__c = TRUE;
        //to do other Proposal fields like Billing Preference etc.
        insert  proposal;
        return proposal;
    }

    //Create cartWrapper for Proposal
    //@param Proposal Id and Product configuration id
    //@return APTSMD_cartWrapper object
    public static APTSMD_ProposalDetails getProposalDetails(String strproposalId,String strCartID){


        List<APTSMD_ProposalDetails.proposalLineItems> lstLineItems = new List<APTSMD_ProposalDetails.proposalLineItems>();
        APTSMD_ProposalDetails objProposal = new APTSMD_ProposalDetails();
        objProposal.lineItems = new List<APTSMD_ProposalDetails.proposalLineItems>();
        Apttus_Config2__ProductConfiguration__c config = [SELECT id,name,Apttus_QPConfig__Proposald__r.Name,Apttus_QPConfig__Proposald__r.id,Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c FROM Apttus_Config2__ProductConfiguration__c WHERE id=:strCartID LIMIT 1];
        if(config!=null){
            objProposal.proposalID = config.Apttus_QPConfig__Proposald__r.id;
            objProposal.proposalNumber = config.Apttus_QPConfig__Proposald__r.Name;
            objProposal.name = config.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Name__c;
            objProposal.cartId = config.id;
        }
        system.debug('strOrderId == '+strproposalId);
        system.debug('strCartID == '+strCartID);
        for(Apttus_Config2__LineItem__c lineItem : [select id,Name,Apttus_Config2__PriceUom__c,Apttus_Config2__Description__c,Apttus_Config2__Uom__c,Apttus_Config2__Quantity__c,Apttus_Config2__ListPrice__c,Apttus_Config2__BaseExtendedPrice__c,Apttus_Config2__ProductId__r.Name,Apttus_Config2__NetPrice__c,Apttus_Config2__ConfigurationId__r.Apttus_Config2__IsPricePending__c, Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__LineType__c,Apttus_Config2__OptionId__r.Name,Apttus_Config2__OptionId__r.ProductCode from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Id =: strproposalId AND Apttus_Config2__ConfigurationId__c=:strCartID])
        {

            APTSMD_ProposalDetails.proposalLineItems objLine = new APTSMD_ProposalDetails.proposalLineItems();
            if(lineItem.Apttus_Config2__LineType__c.equalsIgnoreCase('option')){
                objLine.itemName = lineItem.Apttus_Config2__OptionId__r.Name;
                objLine.productCode = lineItem.Apttus_Config2__OptionId__r.ProductCode;
            }else{
                objLine.itemName = lineItem.Apttus_Config2__ProductId__r.Name;
                objLine.productCode = lineItem.Apttus_Config2__ProductId__r.ProductCode;
            }
            String strLineDesc = lineItem.Apttus_Config2__Description__c;
            //strLineDesc = strLineDesc.replace('"','&#34;');
            objLine.itemDesc = strLineDesc;
            objLine.lineType = lineItem.Apttus_Config2__LineType__c;
            //objLine.UOM = lineItem.Apttus_Config2__Uom__c;
            objLine.quantity = lineItem.Apttus_Config2__Quantity__c;
            objLine.listPrice = lineItem.Apttus_Config2__ListPrice__c;
            objLine.netPrice = lineItem.Apttus_Config2__NetPrice__c;


            objProposal.lineItems.add(objLine);

        }


        return objProposal;
    }

    private static void createStagingRecord(Apttus_Config2__Order__c order)
    {

        APTSMD_Web_Methods_Staging_Table__c objStaging = new APTSMD_Web_Methods_Staging_Table__c(APTSMD_Transaction_Id__c = order.Id,APTSMD_Comments__c = 'From Ecommerce',APTSMD_Transaction_Type__c = 'SupplyOrder',APTSMD_Transaction_Status__c = 'N');
        insert objStaging;

    }

    //Reorder Function- thiss will create new order / configuration and line item from eisting order
    public static APTSMD_cartData reorderFunction(String orderID,String CartID){
        Apttus_Config2__Order__c newOrder = cloneOrder(orderID);

        // create new cart
        String newCartId = APTSMD_cartUtils.createCart(newOrder.Id);

        Apttus_Config2__ProductConfiguration__c prodco = [SELECT Id FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__BusinessObjectId__c =: orderID];

        DescribeSObjectResult describeResult = Apttus_Config2__LineItem__c.SObjectType.getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query = 'SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName()+ ' WHERE ' + ' Apttus_Config2__ConfigurationId__c =\''+prodco.Id+'\'';
        // return generic list of sobjects or typecast to expected type
        System.debug('>>>Query : '+query);
        List<Apttus_Config2__LineItem__c> lstCartLineItems = Database.query( query );

        List<Apttus_Config2__LineItem__c> Updatelineitem = new List<Apttus_Config2__LineItem__c>();
        for(Apttus_Config2__LineItem__c temp : lstCartLineItems) {
            Apttus_Config2__LineItem__c lintitem = temp.clone(false, true, false, false);

            lintitem.Apttus_Config2__ConfigurationId__c = newCartId;
            Updatelineitem.add(lintitem);

        }

        if(Updatelineitem.Size()>0) {
            insert Updatelineitem;
            //reprice the cart
           // APTSMD_cartUtils.reprice(newCartId);
        }

        return APTSMD_cartUtils.getCartData();
    }
    //Create the Order from an existing order using CPQ API
    public static Apttus_Config2__Order__c cloneOrder(String orderId){

        List<Apttus_Config2__Order__c> existingOrder = [SELECT id, Apttus_Config2__Status__c,Apttus_Config2__BillToAccountId__c,Apttus_Config2__PriceListId__c FROM Apttus_Config2__Order__c WHERE Id=:orderId];
        if(existingOrder.isEmpty()){
            return null;
        }

        Apttus_Config2.CPQStruct.CreateOrderRequestDO orderReq = new Apttus_Config2.CPQStruct.CreateOrderRequestDO();

        // Add request parameters
        orderReq.AccountId = existingOrder[0].Apttus_Config2__BillToAccountId__c;
        orderReq.PriceListId = existingOrder[0].Apttus_Config2__PriceListId__c;
        orderReq.PricingDate = Datetime.now();

        // Create a new order
        Apttus_Config2.CPQStruct.CreateOrderResponseDO orderResposnse = Apttus_Config2.OrderWebService.createOrder(orderReq);

        List<Apttus_Config2__Order__c> newOrder = [SELECT id, Apttus_Config2__Status__c,Apttus_Config2__BillToAccountId__c,Apttus_Config2__PriceListId__c FROM Apttus_Config2__Order__c WHERE Id=:orderResposnse.OrderSO.Id];
        if(!newOrder.isEmpty()){
            newOrder[0].Apttus_Config2__Status__c ='New';
            update newOrder[0];
        }
        return newOrder[0];
    }



}