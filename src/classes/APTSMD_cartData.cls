global class APTSMD_cartData { 
        public APTSMD_cartWrapper cartWrapper { get; set; }
        public Apttus_CPQApi.CPQ.SelectedProductDO prodItem { get; set; }
        public APTSMD_cartWrapper.cartItems cartItem { get; set; }
        public APTSMD_productDetailsForTaxCalc prodDetailForTax { get; set; }
        public APTSMD_CyberSource_CC_AuthRequest authRequest { get; set; }
        public Set<Id> suggestedProdIds{get;set;}
    }