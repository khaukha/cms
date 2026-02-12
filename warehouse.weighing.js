function checkPallet(o)
{
	var keyCode = window.event.keyCode;
	if (keyCode == 13) {
		var value = o.value;
		var id = value.substring(0,2);
		if (id == "PL") {
			if (value.length == 15) doPost();
			else o.value = "";
			return;
		} 
		if (id == "WN") {
			if (value.length == 17 || 14) doPost();
			else o.value = "";
			return;
		} else {
			if (value.length > 0) doPost();
		}
	}
}
/////////////////////////////////////////////////////////////
/*
function new_WNR(i)
{
	show("wnr_" + i);
	setValue("wnr_date_" + i, getNewDate());
	setValue("wnr_time_" + i, getNewTime());
	setValue("wnr_id_"   + i, -1);
}
*/
/*---------------------------------------------------------------------*/
function sum_Weight(type, field)
{
	var s = 0;
	for (var i = 1;; i++) {
		if (getObj(type + "_" + field + "_" + i) == null) break;
		s += toFloat(getValue(type + "_" + field + "_" + i));
	}
	return formatNumber(s + 0.01,1,true);
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
	setValue(type + "_" + field + "_" + i, formatNumber(value,1,false));
	setText (field ,     sum_Weight(type,field));
}

function no_of_bags_Changed(type,i,value)
{
	value = toInt(value);
	var field = "no_of_bags";
	setValue(type + "_" + field + "_" + i, formatNumber(value,0,false));
	//setText (type + "_" + field + "_",     sum_Bag(type,field));
	setText (field , sum_Bag(type,field));
}

function net_Changed(type,i,nw)
{
	nw = toFloat(nw);
	weight_Changed(type,i,"net_weight",nw);	
}

function gross_Changed(type,i,gw)
{
	gw = toFloat(gw);
	weight_Changed(type,i,"gross_weight",gw);
	var tw = toFloat(getValue(type + "_tare_weight_" + i));
	net_Changed(type,i,gw - tw);
}

function tare_Changed(type,i,tw)
{
	tw = toFloat(tw);
	weight_Changed(type,i,"tare_weight",tw);	
	var gw = toFloat(getValue(type + "_gross_weight_" + i));
	net_Changed(type,i,gw - tw);	
}

function bag_Changed(type,i,nb)
{
	nb = toInt(nb);
	no_of_bags_Changed(type,i,"no_of_bags",nb);	
	var tw = nb * 0.0007;
	tare_Changed(type,i,tw);
}


