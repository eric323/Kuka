/* 
			########## Author : N.P. Singh #############
			####### Added Date: 31 Dec, 2014 ###########
			######Last Modified Date: 6 Jan, 2015 ######
*/
/* -------------------------##########################################----------------------------- */
/* --------------------CSS override Code from Existing MDO CSS override file----------------------- */
/* -------------------------##########################################----------------------------- */
/* -------------------------##########################################----------------------------- */


.aptProductImage
{
	width:75px !important; 
}
img.aptCartLineItemIcon
{
	max-width: 75px;
	max-height: 75px;
	padding-left: 30px;
	padding-right: 30px;
}
.totalsTableContainer 
{
	font-size: 1.1em;
}
.idCommands
{
	border: 1px solid #c2c2c2 !important;
	width: 75% !important;
	margin-left: 12.5% !important;
	margin-right: 12.5% !important;
}

/* -------------------------##########################################----------------------------  */
/* -------Custom CSS color theme override Theme for Old UI(Non-fixed Header/footer bar)-----------  */
/* -------------------------##########################################----------------------------  */
/* -------------------------##########################################----------------------------  */

/*       -------------- Custom CSS Theme override --------------         */
/*       ---- override the Overall colour Appearance of CPQ ----         */

/* 
	I used only one color property for CSS color theme modification, so just need to change the color code by replacing entire color code by your own
	
	MainColor:-- #1797c0   |-- For Main color theme modification that is used in buttons, main overlay bars, section headers and text and category hover color	
	
*/

/* 
		--------------- CSS override section start here ------------		
*/

/* Secondary Section Header Bar CSS Change */
.aptPageTitleBarPanel{
	background: #FF5800 !important;
	border: 1px solid #FF5800 !important;
}

/* button hover color CSS override */
.aptListButton{
	background: #FF5800 !important;
	background-color: #FF5800 !important;
}

/* Active category overley CSS change */
.aptCarrouselItemActive{
	border: 1px solid #FF5800 !important;
	box-shadow: 0px 0px 15px #C73D39 !important;
}

/* Category carousel hover CSS override */
.image_carousel div.aptCarrouselItem{
	border: 1px solid #FF5800 !important;
	/*box-shadow: 0px 0px 15px #CFEEF8 !important;*/
}

/* Search button bg color CSS override */
.apt-doSearchButton{
	background-color: #FF5800!important;
}

/* Category section browse catelog color CSS override */
.apt-browse-catalog-title{
	background-color: #FF5800 !important;
}

/* Browse section lines hover CSS override */
.columnview li:hover{
	background-color : #FF5800 !important;
}

/* Cart Panel Action Dropdown hover CSS override */
.apt-list-dropdown .aptListButton:hover {
	background: #FF5800 !important;
}
/*Catalog page spacing CSS override*/
div.aptProductBottomButttons{
	padding:0px !important;
}
.aptProductInfoContainer{
	padding:5px 5px 0px !important;
}

/* Last total row color CSS override on Cart Screen page  || Only Applicable when Total section of cart is visible
   --- This CSS property will change the background color of the last total section row ---
.totalsLastRow {
	background-color: rgb(250, 187, 187) !important;
} */

/* Disbaled button override CSS code */
.aptButtonDisabled {
	background: gray !important;
	cursor: default;
}
.image_carousel div.aptCarrouselItem:hover{
	box-shadow: 0px 0px 15px #149BC7 !important;
}
.aptCarrouselItemActive{
	box-shadow: 0px 0px 15px #149BC7 !important;
}
/* Pop up Button*/
body input.btn{
	padding: 4px 3px;
	background: #ff5800 !important;
}
.button {
    /* background-color: #A5E0BB; */
    background: #FF5800 !important;
    color: #ffffff !important;
}
/* -------------------------##########################################----------------------------  */
/* ---------Custom CSS color theme override Theme for New UI(fixed Header/footer bar)-------------  */
/* -------------------------##########################################----------------------------  */
/* -------------------------##########################################----------------------------  */


/*       -------------- Custom CSS Theme override --------------         */
/*       ---- override the Overall colour Appearance of CPQ ----         */

/* I have used two color properties for CSS color theme modification, so just need to change the color code by replacing entire color code by your own
	
	MainColor:-- #FF5800   |-- For Main color theme change that is used in buttons, main overlay bars, section headers and text and category hover color
	DarkColor:-- #085B76   |-- for secondary Search bar panel on the Catalog page which is used as dark color;
	
*/

/* 
		--------------- CSS override section start here ------------		
*/

/* Main header bar CSS Change */
.cartTable{
	background: #FF5800 !important;    
}

/* button hover color CSS override */
.aptListButton:hover{
	background: #FF5800 !important;
	background-color: #FF5800 !important;
}

/* Dropdown button CSS Override */
a.aptMoreButton:hover {
background-color: #FF5800 !important;
}

/* Search button bg color CSS override */
.apt-doSearchButton{
	background-color: #FF5800!important;
}

/* Secondary Serach container bg Color CSS override */
#idSearchContainer{
	background-color: #085B76 !important;
}

/* Category section browse catelog color CSS override */
.apt-browse-catalog-title{
	background-color: #FF5800 !important;
}

/* Browse section lines hover CSS override */
.columnview li:hover{
	background-color : #FF5800 !important;
}

/* Cart Panel Action Dropdown hover CSS override */
.apt-list-dropdown .aptListButton:hover {
	background: #FF5800 !important;
}

/* Left and right button Color change on hover */
a.apt-left-btn:hover, a.apt-right-btn:hover{
	background-color : #FF5800 !important;
}




/* -------------------------##########################################----------------------------  */
/* -----Custom CSS override to hide Total Section from the Cart Page(Works with All Design)-------  */
/* -------------------------##########################################----------------------------  */
/* -------------------------##########################################----------------------------  */



/* -------------------- Total Section of CART override ---------------------  */
/* Prevent to apply for main cart section */
/* uncomment the below code to hidden the Cart total section Completely */

/*
div.apt-main-content.apt-page-content  div.aptRoundedDiv.aptPageTitleBarPanel{
	display:block !important; 
}
/* Prevent to apply Line Items Section of Cart Panel 
div.apt-main-content.apt-page-content  div.idResultStatsPanel.aptRoundedDiv{
	display:block !important;
}
/* Apply to only Total Panel of Cart panel 
div.apt-main-content.apt-page-content div.aptRoundedDiv {
	display:none;
}
*/


/*
	CSS Changes For Angular UI
*/

/* Header CSS for cart, catalog,bundle, attribute pages */
.header-global {
    background-color: #FF5800 !important;
    color: #FFF !important;
    padding: .5rem !important;
    position: fixed !important;
    top: 0 !important;
    width: 100% !important;
    height: 2.2rem !important;
    z-index: 100000 !important;
}

/* Child Header*/
.process-trail {
    background-color: #BBBABA !important;
    color: #FFF !important;
    padding: .35rem !important;
    height: 3.2rem !important;
    top: 2.2rem !important;
    width: 100% !important;
    position: absolute !important;
    z-index: 9995 !important;
}

/* Top Header Buttons */
.display-actions-block-top button {
    background: #BBBABA !important;
    border: 2px solid #FF5800;
    color: black !important;
    font-weight: bold !important;
    margin: 0.04rem .45rem !important;
}

/* Buttons */
button.primary {
    background: #FF5800 !important;
    color: #FFF !important;
}
button.primary.active, button.primary:hover {
    background: #FF5800 !important;
}
.main-block__listings .listing-actions .listing-actions-area button {
    width: 8rem !important;
}

/*product name and Links*/
a {
    color:#000 !important;
    text-decoration: none !important;
    -webkit-transition: color .2s ease-in !important;
}
a {
    background-color: transparent !important;
}

/* Selected Cart Icon*/

.main-block__listings .listing-in-cart {
    color: #FF5800 !important;
    font-family: ProximaNovaSoft-Regular !important;
    font-size: .9rem !important;
    margin-left: .5rem !important;
}

/* MINI Cart Css */
.mini-cart__items__item__title span {
    color: #FF5800 !important;
    cursor: pointer !important;
    -webkit-transition: color .2s ease-in !important;
    transition: color .2s ease-in !important;
}
.mini-cart__items i {
    color: #FF5800 !important;
}
/*Button*/
.mini-cart__actions button:not(:nth-child(2)) {
    margin-right: .5rem !important ;
}
.mini-cart__actions__finalize {
    background: #FF5800 !important;
}
button.secondary {
    background: #FF5800 !important;
    color: #FFF !important;
}

/* Category Selection */
.block-refine-subcategories__children .is--active>a {
    background: #FF5800 !important;
    color: #FFF !important;
    border-radius: 5px !important;
}

/* Bottom Panel */
.display-actions-block-bottom {
    background-color: #BBBABA !important;
    height: 3.2rem !important;
}
.display-actions-block-bottom button {
    background: #FF5800 !important;
    color: #ffffff !important;
    margin: .4rem .25rem !important;
}

/* Cart Page */
.main-cart-col:first-child>div .pbBody .dataCol span, .main-cart-col:first-child>div h3 span, .pbBody .main-cart-col:first-child>div .dataCol span {
    color: #FF5800 !important;
    cursor: pointer !important;
    -webkit-transition: color .2s ease-in !important;
    transition: color .2s ease-in !important;
}

.checkbox-override input[type=checkbox]:checked+label {
    background: #FF5800 !important;
    border: none !important;
}

/* Attribute & Option Page */
.radio-override input[type=radio]:checked+label:after {
    background: #FFF !important;
    border-color: #FF5800 !important;
}

.product-option__name>label {
    color: #FF5800 !important;
    font-family: ProximaNovaSoft-Regular !important;
    line-height: 1.125rem !important;
    margin-bottom: 0 !important;
    margin-top: .2rem !important;
}
.main-configure-product__product-nav li {
    color: #FF5800 !important;
    display: inline-block !important;
    font-family: ProximaNovaSoft-Semibold !important;
    font-size: 1rem !important;
    padding: .5rem 0 1rem !important;
}