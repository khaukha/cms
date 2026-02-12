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
function print_DSI(dsi,task_id)
{
	var name = dsi == "di" ? "Delivery Instruction" : "Shipping Instruction";
	var inst_id = getValue("inst_id");
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

function gross_Changed(type,i,gw)
{
	//setValue(type + "_gross_weight_" + i, formatNumber(gw,4,false));
	//setText(type + "_gross_weight_", sum_Weight(type,"gross_weight"));
	weight_Changed(type,i,"gross_weight",gw);
}

function tare_Changed(type,i,tw)
{
	weight_Changed(type,i,"tare_weight",tw);	
	var nw = toFloat(getValue(type + "_net_weight_" + i));
	gross_Changed(type,i,nw + tw);	
}

function bag_Changed(type,i,nb)
{
	no_of_bags_Changed(type,i,"no_of_bags",nb);	
	var tw = nb * 0.0007;
	tare_Changed(type,i,tw);
}

function net_Changed(type,i,nw)
{
	weight_Changed(type,i,"net_weight",nw);	
	var kg = toFloat(getValue("kg_per_bag"));
	if (kg == 0) kg = 60;
	var nb = toInt((nw*1000 + kg - 1)/kg);
	bag_Changed(type,i,nb);
}

/*-----------------------------------------------------------------------------*/
function getPage_WRC(wrc)
{
	return wrc == "wr" ? "traffic.di.jsp" : "traffic.si.jsp";
}

function update_WRC(wrc,i,task_id)
{
	var wrc_tons = toFloat(getText(wrc + "_net_weight_"));
	var dsi_tons = toFloat(getValue("tons"));
	if (wrc_tons > dsi_tons) {
		if (!confirm("Warning : The total WR/WC tons (" + wrc_tons + ") is greater than DI/SI tons (" + dsi_tons + "). Continue ?")) {
			return;
		}
	}
	if (task_id == null) task_id = 10;
	setValue("task_id", task_id);
	doLink(getPage_WRC(wrc) + "?no=" + i);
}

function del_WRC(wrc,i,task_id,s)
{
	if (getValue(wrc + "_id_" + i) <= 0) {
		setValue(wrc + "_gross_weight_" + i,"");
		setValue(wrc + "_tare_weight_" + i,"");
		setValue(wrc + "_net_weight_" + i,"");
		setValue(wrc + "_no_of_bags_" + i,"");

		setTotal(wrc);	

		hide(wrc + "_" + i);
		return;
	}
	if (s == null) s = "Are you sure to delete WR/WC " + getText(wrc + "_ref_number_" + i);
	if (confirm(s)) {
		if (task_id == null) task_id = 11;
		setValue("task_id", task_id);
		doLink(getPage_WRC(wrc) + "?no=" + i);
	}
}

