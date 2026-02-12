function rowClicked(row,qr_id)
{
	if (qr_id != null) setValue("qr_id",qr_id);
	highlightOn(row);
}

function cardViewClicked()
{
	setValue("view",1);
	doPost();
}

/*----------------------------------------------------------------------------*/
function wrcClicked(type)
{
	if (isVisibled(type + "_show_")) {
		hide(type + "_show_");
		setText(type + "_plus_","+");
		setValue(type + "_show", 0);
	} else {
		show(type + "_show_");
		setText(type + "_plus_","-");
		setValue(type + "_show", 1);
	}
}
/*------------------------------------------------------------------------------*/
function new_DSI(dsi)
{
	var name = dsi == "di" ? "Delivery Instruction" : "Shipping Instruction";
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract that this " + name + " belongs to.");
		return;
	}	
	if (addNewListItemById(dsi + "_id","New Item") >= 0) doPost();
}

function delete_DSI(dsi,s)
{
	var name = dsi == "di" ? "Delivery Instruction" : "Shipping Instruction";
	if (s == null) s = name;
	if (getValue(dsi + "_id") == 0) {
		alert("Please select a " + s);
		return;
	}
	if (getValue(dsi + "_id") > 0) {
		if (confirm("Are you sure to delete " + s + " " + getSelectedText(dsi + "_id"))) {
			doTask(3);
		}
	}
}

function save_DSI(dsi)
{
	var name = dsi == "di" ? "Delivery Instruction" : "Shipping Instruction";
	if (getValue("contract_id") == 0) {
		alert("Please select a contract. for this " + name);
		return;
	}
	if (getValue(dsi + "_id") == 0) {
		alert("Please select a " + name);
		return;
	}
	doTask(1);
}

function print_DSI(dsi,task_id)
{
	var name = dsi == "di" ? "Delivery Instruction" : "Shipping Instruction";
	var inst_id = getValue(dsi + "_id");
	if (inst_id == 0) {
		alert("Please select a " + name);
		return;
	}
	if (inst_id < 0) {
		alert("Please save " + name + " before printing.");
		return;
	}
	if (task_id == null) task_id = 2;
	doTask(task_id);
}

function tonsChanged(tons_id,kg_id)
{
	if (tons_id == null) tons_id = "tons";
	if (kg_id == null) kg_id = "kg_per_bag";
	var tons = toFloat(getValue(tons_id));
	var kg = toFloat(getValue(kg_id));
	if (kg <= 0) kg = 60;
	var num = formatNumber((tons*1000+kg-1)/kg,0,false);
	setValue("no_of_bags",num);
}

function new_WRC(wrc,i)
{
	show(wrc + "_" + i);
	setValue(wrc + "_date_" + i, getNewDate());
	setValue(wrc + "_time_" + i, getNewTime());
	highlightOn(getObj(wrc + "_" + i),1);
}
/*------------------------------------------------------------------------------*/
function sum_Weight(type, field)
{
	var s = 0;
	for (var i = 1;; i++) {
		if (getObj(type + "_" + i) == null) break;
		s += toFloat(getValue(type + "_" + field + "_" + i));
	}
	return formatNumber(s + 0.00001,4,true);
}

function sum_Bag(type, field)
{
	var s = 0;
	for (var i = 1;; i++) {
		if (getObj(type + "_" + i) == null) break;
		s += toInt(getValue(type + "_" + field + "_" + i));
	}
	return formatNumber(s,0,true);
}

function weight_Changed(type,i,field,value)
{
	setValue(type + "_" + field + "_" + i, formatNumber(value,4,false));
	setText (type + "_" + field + "_",     sum_Weight(type,field));
}

function no_of_bags_Changed(type,i,field,value)
{
	setValue(type + "_" + field + "_" + i, formatNumber(value,0,false));
	setText (type + "_" + field + "_",     sum_Bag(type,field));
}

