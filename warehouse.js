function wnClicked(row,wn_id,inst_id)
{
	if (wn_id != null) { 
		setValue("wn_id",wn_id);
	}
	if (inst_id != null) {  
		setValue("inst_id",inst_id);
	}
	highlightOn(row);
}

function cardViewClicked(type)
{
	if (getValue("inst_id") == 0) {
		alert("Please select a " + type.toUpperCase());
		return;
	}

	setValue("view",1);
	doPost();
}

function new_WN(new_item)
{
	//var name = dsi == "di" ? "Delivery Instruction" : "Shipping Instruction";
	var inst_id = getValue("inst_id");
	if (inst_id == 0) {
		alert("Please select a DI/SI that this " + new_item + " belongs to.");
		return;
	}	
	if (addNewListItemById("wn_id",new_item) >= 0) doPost();
}

function save_WN()
{
	doTask(1);
}

function delete_WN()
{
	if ( confirm("Delete Selected Weight Note ") ) {
		doTask(3);
	}
}

function new_WNR(i)
{
	show("wnr_" + i);
	setValue("wnr_date_" + i, getNewDate());
	setValue("wnr_time_" + i, getNewTime());
	setValue("wnr_id_"   + i, -1);
}

function save_WNR(i)
{
	setValue("no", i);
	doTask(2);
}

function delete_WNR(i)
{
	if (getValue("wnr_id_"   + i) == -1) {
		setValue("wnr_id_"   + i, 0);
		hide("wnr_" + i);
	} else {
		if (confirm("Delete WNR " + getValue("wnr_ref_" + i))) {
			setValue("no", i);
			doTask(4);
		}
	}
}

/*---------------------------------------------------------------------*/
function sum_Weight(type, field)
{
	var s = 0;
	for (var i = 1;; i++) {
		if (getObj(type + "_" + field + "_" + i) == null) break;
		s += toFloat(getValue(type + "_" + field + "_" + i));
	}
	return formatNumber(s + 0.00001,4,true);
}

function sum_Bag(type, field)
{
	var s = 0;
	for (var i = 1;; i++) {
		if (getObj(type + "_" + field + "_" + i) == null) break;
		s += toInt(getValue(type + "_" + field + "_" + i));
	}
	return formatNumber(s,0,true);
}


function weight_Changed(type,i,field,value)
{
	setValue(type + "_" + field + "_" + i, formatNumber(value,4,false));
	//setText (type + "_" + field + "_",     sum_Weight(type,field));
	setText (field ,     sum_Weight(type,field));
}

function no_of_bags_Changed(type,i,value)
{
	var field = "no_of_bags";
	setValue(type + "_" + field + "_" + i, formatNumber(value,0,false));
	//setText (type + "_" + field + "_",     sum_Bag(type,field));
	setText (field ,     sum_Bag(type,field));
}

function net_Changed(type,i,nw)
{
	weight_Changed(type,i,"net_weight",nw);	
	//var kg = toFloat(getValue("kg_per_bag"));
	//if (kg == 0) kg = 60;
	//var nb = toInt((nw*1000 + kg - 1)/kg);
	//bag_Changed(type,i,nb);
}

function gross_Changed(type,i,gw)
{
	weight_Changed(type,i,"gross_weight",gw);
	var tw = toFloat(getValue(type + "_tare_weight_" + i));
	//var nw = gw - tw;
	net_Changed(type,i,gw - tw);
}

function tare_Changed(type,i,tw)
{
	weight_Changed(type,i,"tare_weight",tw);	
	var gw = toFloat(getValue(type + "_gross_weight_" + i));
	net_Changed(type,i,gw - tw);	
}

function bag_Changed(type,i,nb)
{
	no_of_bags_Changed(type,i,"no_of_bags",nb);	
	var tw = nb * 0.0007;
	tare_Changed(type,i,tw);
}


