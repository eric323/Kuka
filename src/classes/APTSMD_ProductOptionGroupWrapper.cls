//Class containg Product option Group data wrapper
public class APTSMD_ProductOptionGroupWrapper {
        public Id productOptionGroupId {get;set;}
        public String name {get;set;}
        public String optionGroupName{get;set;}
        public Boolean isHidden {get;set;}
        public Boolean isLeaf {get;set;}
        public Boolean isPicklist {get;set;}
        public Decimal left {get;set;}
        public Decimal level {get;set;}
        public Decimal maxOptions {get;set;}
        public Decimal minOptions {get;set;}
        public Decimal maxTotalQuantity {get;set;}
        public Decimal minTotalQuantity {get;set;}
        public String modifiableType {get;set;}
        public Id optionGroupId {get;set;}
        public Id parentOptionGroupId {get;set;}
        public Id productId {get;set;}
        public Decimal right {get;set;}
        public Id rootOptionGroupId {get;set;}
        public Decimal rootSequence {get;set;}
        public Decimal sequence {get;set;}
        public List<APTSMD_ProductOptionComponentWrapper> optionComponent {get;set;}
        public String iconId {get;set;}
        public String selectedprods{get;set;} 
        
        public APTSMD_ProductOptionGroupWrapper(Id productOptionGroupId, String name,String optionGroupName, Boolean isHidden, Boolean isLeaf, Boolean isPicklist, Decimal left, Decimal level, 
                                    Decimal maxOptions, Decimal minOptions, Decimal maxTotalQuantity, Decimal minTotalQuantity, String modifiableType,
                                    Id optionGroupId, Id parentOptionGroupId, Id productId, Decimal right, Id rootOptionGroupId, Decimal rootSequence,
                                    Decimal sequence, List<APTSMD_ProductOptionComponentWrapper> optionComponent, String iconId) {
            this.productOptionGroupId = productOptionGroupId;
            this.name = name;
            this.optionGroupName = optionGroupName;
            this.isHidden = isHidden;
            this.isLeaf = isLeaf;
            this.isPicklist = isPicklist;
            this.left = left;
            this.level = level;
            this.maxOptions = maxOptions;
            this.minOptions = minOptions;
            this.maxTotalQuantity = maxTotalQuantity;
            this.minTotalQuantity = minTotalQuantity;
            this.modifiableType = modifiableType;
            this.optionGroupId = optionGroupId;
            this.parentOptionGroupId = parentOptionGroupId;
            this.productId = productId;
            this.right = right;
            this.rootOptionGroupId = rootOptionGroupId;
            this.rootSequence = rootSequence;
            this.sequence = sequence;
            this.optionComponent = optionComponent;
            this.iconId = iconId;
        }

}