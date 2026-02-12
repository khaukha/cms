
var LD = new Array("Jan","Mar","May","Jul","Sep","Nov");
var NY = new Array("Mar","May","Jul","Sep","Dec");

var cdate = new Date();

function oneYear(idx,tmonth, amonth)
{
	var year = cdate.getYear() - 1;
	var len = amonth.length;
	var k = len*idx + 1;
	var yy = (idx+year)%100;
	var sy = yy.toString();
	if (yy <= 9) sy = "0" + sy;
	for (var i = 0; i < len; i++, k++) {
    	tmonth.options[k] = new Option(amonth[i] + "-" + sy);
    	tmonth.options[k].value = "01-" + amonth[i] + "-" + sy;
    	tmonth.options[k].title = amonth[i] + "-" + sy;
	}
}

function changeTerMth(month_id,terminal_market,first)
{
	if (month_id == null) month_id = "terminal_month";
	if (terminal_market == null) terminal_market = parseInt(getValue("terminal_market_id")); 
	if (terminal_market == 0) {
		var quality_id = parseInt(getValue("quality_id"));
		terminal_market = quality_id == 1 ? 2 : 1;
	}
	
	if (first == null) first = true;
	
    var terminal_month = getObj(month_id);
	if (first) {
    	terminal_month.options.length = 0;
    	terminal_month.options[0] = new Option("");
    	terminal_month.options[0].value = "";
    	terminal_month.options[0].title = "";
	}
	
	for (var i = 0; i < 4; i++) {
    	if (terminal_market == 2) {//"NYC"
			oneYear(i,terminal_month,NY);
		} else {
			oneYear(i,terminal_month,LD);
		}
	}
}


function checkContractType(contract_type)
{
	var ptbf_dis = false;
	if (contract_type == 'O' || contract_type == 'L' || contract_type == 'W') {
		getObj("is_PTBF_0").checked = true;
		ptbf_dis = true;		
		//return;
	}
	if (contract_type == 'T' || contract_type == 'C') {
		getObj("is_PTBF_1").checked = true;
		ptbf_dis = true;
		//return;
	}
	getObj("is_PTBF_0").disabled = ptbf_dis;
	getObj("is_PTBF_1").disabled = ptbf_dis;
	//show("is_PTBF_", !ptbf_dis);
}

function checkOutRight(out_right, is_fixed)
{
	setEnabled("exchange_rate", out_right);
	setEnabled("contract_price", out_right);
	setEnabled("contract_price_local", out_right);
	if (out_right) {
		getObj("pricing_type_fixed").checked = true;
	} else {
		getObj("pricing_type_fixed").checked = is_fixed;
		getObj("pricing_type_unfixed").checked = !is_fixed;
	}
}

function contractTypeChanged(o, contract_type, is_fixed)
{
	if (o != null) contract_type = o.value;
	
	checkContractType(contract_type);

    var out_right = getObj("is_PTBF_0").checked;
	if (contract_type == 'O' || contract_type == 'L' || contract_type == 'W') {
		out_right = true;
	}
	checkOutRight(out_right, is_fixed);
}

function statusChange(obj)
{
	var o1 = getObj("completed_date");
	var o2 = getObj("completed_date_");
	o1.disabled = (obj.value <= 1);
	o2.disabled = (obj.value <= 1);
}

function pricingTypeChanged(obj,called)
{
	if (obj == null) obj = getObj("pricing_type_unfixed"); 
	var isUnfixed = obj.checked && obj.value == 'U';
	if (called == null) called = false;
	if (called) {
		setCbxById("out_right_",isUnfixed?0:1);
	}
}

function outRightChanged(obj)
{
	var fx = getObj("pricing_type_fixed"); 
	var uf = getObj("pricing_type_unfixed");		
	if (obj.checked) {
		fx.checked = true; 
	} else {
		uf.checked = true; 		
	}
	fx.disabled = false;
	uf.disabled = false;
	pricingTypeChanged(uf, false);
	cbxClick(obj);

	var ro = !obj.checked;
	getObj("contract_price_local").readOnly = ro
	getObj("contract_price").readOnly = ro;
	getObj("exchange_rate").readOnly = ro;
	getObj("hedge_price").readOnly = ro;
}
/* Price */
function exchangeRateChange(obj)
{
	formatNumberObj(obj,0);		
	var ex = toFloat(obj.value);
	var price_local = getFloat("contract_price_local");
	priceChange(price_local, ex);
}


function differentialChange()
{
	var hedge_price = getFloat("hedge_price");
	var contract_price = getFloat("contract_price");
	var diff = getObj("differential_price");
	diff.value = contract_price - hedge_price;
	formatNumberObj(diff,2);	
}

function hedgePriceChange(obj)
{
	formatNumberObj(obj,2);	
	differentialChange();
}

function priceChange(price_local, ex)
{
	if (ex > 0) {
		var obj = getObj("contract_price");
		obj.value = (price_local / ex).toFixed(2); 
		formatNumberObj(obj, 2);
		differentialChange();
	}
}

function contractPriceLocalChange(obj)
{
	formatNumberObj(obj,0);	
	var price_local = toFloat(obj.value);
	var ex = getFloat("exchange_rate");
	priceChange(price_local, ex);
}
/* End Price */
function lotToTon(lots,tm_id,tons_per_lot)
{
	if (lots == null) lots = 0;
	if (tons_per_lot == null) tons_per_lot = toFloat(getValue("tons_per_lot"));
	if (tons_per_lot == 0) tons_per_lot = 5; 
	switch (tm_id) {
		case 1 : return toFloat(lots*tons_per_lot); //LIFFE
		case 2 : return toFloat(lots*17.01); //NYC
	}
	return 0;
}

function idiv(a, b)
{
	if (b == 0) return 0;
	var c = a / b;
	var d = toInt(c);
	return (c - d > 0) ? d + 1 : d;  
}

function tonToLot(tons,tm_id,tons_per_lot)
{
	//if (tons == null) tons = 0;
	if (tons == null) tons = toFloat(getValue("tons"));
	if (tm_id == null) tm_id = toInt(getValue("terminal_market_id"));
	if (tons_per_lot == null) tons_per_lot = toFloat(getValue("tons_per_lot"));
	if (tons_per_lot == 0) tons_per_lot = 5; 
	var haft_lot = tons_per_lot/2;
	switch (tm_id) {
		case 1 : return toInt((tons + haft_lot)/tons_per_lot); //LIFFE
		case 2 : return toInt((tons+8.5)/17.01); //NYC
	}
	return 0;
}

function calculateLots()
{
	var tons = toFloat(getValue("tons"));
	var qu_id = toInt(getValue("quality_id"));
	var tons_per_lot = toFloat(getValue("tons_per_lot"));
	if (tons_per_lot == 0) tons_per_lot = (qu_id == 2 ? 10 : 17.01); 
	var haft_lot = tons_per_lot/2;
	var lots = toInt((tons + haft_lot)/tons_per_lot);
	if (tons > 0 && lots == 0) lots = 1;
	setValue("no_of_lots", lots);
	return 0;
}

function doPrint(task_id)
{
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a Contract.");
		return;
	}
	if (contract_id < 0) {
		alert("Please save Contract before printing.");
		return;
	}
	doTask(task_id);
}

function calculateBags()
{
	var tons = toFloat(getValue("tons"));
	var kg = toFloat(getValue("kg_per_bag"));
	if (kg <= 0) kg = 60;
	var num = formatNumber((tons*1000+kg-1)/kg,0,false);
	var o = getObj("no_of_bags");
	//setValue("no_of_bags",num);
	o.value = num;
	formatNumberObj(o,0);
	//
	//setValue("no_of_lots",tonToLot(tons));
}	

/////////////////////////////////////////
function toPage(page,inst_id)
{
	setValue("view",1);
	setValue("inst_id",inst_id);
	document.formMain.action = page;
	doPost();
}

function rowClicked(row,contract_id)
{
	if (contract_id != null) setValue("contract_id",contract_id);
	highlightOn(row);
}

function new_Contract()
{
	if (addNewListItemById("contract_id","New Item") >= 0) doPost();
}

function del_Contract()
{
	if (confirm("Are you sure to delte " + getSelectedText("contract_id"))) doTask(3);
}

function doListView()
{
	//setValue("chuc_mung",-1);
	setValue("pricing_type"," ");
	setValue("location_id",0);
	setValue("consignment",-1);
	setValue("buyer_id",0);
	setValue("seller_id",0);
	setValue("quality_id",0);
	setValue("grade_id",0);
	setValue("terminal_month","0000-00");
	setValue("filter_date_from","0000-00");
	setValue('view',0);
	doTask();
}
///////////////////////////////////////////
var sDescription="";  

function selectDescription()
{
	var url = "trade.grade-description.jsp?uid=<%=user.getuid()%>&grade_id=" + getValue("grade_id")+"&grade="+getSelectedText("grade_id");
	var vReturnValue = window.showModalDialog(url,window,"status:false;dialogWidth:800px;dialogHeight:400px;center:yes");
}

function updateDescription()
{
    setValue("description", sDescription);
}





