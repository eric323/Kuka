//Class containg Product Option Component Data
public class APTSMD_ProductOptionComponentWrapper {
        public Id productOptionComponentId {get;set;}
        public String name {get;set;}
        public String componentProductName{get;set;}
        public Boolean allowCloning {get;set;}
        public Id componentProductId {get;set;}    
        public Boolean isDefault {get;set;}
        public Decimal defaultQuantity {get;set;}
        public String inclusionCriteria {get;set;}
        public Decimal maxQuantity {get;set;}
        public Decimal mixQuantity {get;set;}
        public Id parentProductId {get;set;}
        public Id productOptionGroupId {get;set;}
        public Boolean modifiable {get;set;}
        public String relationshipType {get;set;}
        public Boolean required {get;set;}
        public Decimal sequence {get;set;}
        public Boolean selected{get;set;}
        public Decimal price{get;set;}
        public APTSMD_ProductOptionComponentWrapper(Id productOptionComponentId, String name, String componentProductName,Boolean allowCloning, Id componentProductId, Boolean isDefault, Decimal defaultQuantity,
                                        String inclusionCriteria, Decimal maxQuantity, Decimal mixQuantity, Id parentProductId, Id productOptionGroupId,
                                        Boolean modifiable, String relationshipType, Boolean required, Decimal sequence,Decimal price) {
            this.productOptionComponentId = productOptionComponentId;
            this.name = name;
            this.componentProductName = componentProductName;
            this.allowCloning = allowCloning;
            this.componentProductId = componentProductId;
            this.isDefault = isDefault;
            this.defaultQuantity = defaultQuantity!=null?defaultQuantity:1;
            this.inclusionCriteria = inclusionCriteria;
            this.maxQuantity = maxQuantity;
            this.mixQuantity = mixQuantity;
            this.parentProductId = parentProductId;
            this.productOptionGroupId = productOptionGroupId;
            this.modifiable = modifiable;
            this.relationshipType = relationshipType;
            this.required = required;
            this.sequence = sequence;
            this.selected = isDefault;
            this.price = price;
        }
}