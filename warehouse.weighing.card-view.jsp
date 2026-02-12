<%@include file="authentication.jsp"%>
<%@include file="packing.jsp"%>

<%@ page import="ibu.ucms.biz.warehouse.weighing.wn.*" %>

<%
	ibu.ucms.biz.warehouse.Weighing task = user.getBiz().getWareHouse().getWeighing();
	boolean auto_weighing = false;
	WnEntity wn = dao.getWnImportDao().newEntity();
	wn.type = sc.wn_type;
	WnrEntity wnr = dao.getWnrDao().newEntity();

	String disabled = task.isReadOnly() ? "disabled" : "";		
	
	String can_modify = auto_weighing ? "readonly" : "";
	String displayed = task.isReadOnly() ? "none" : "";	

	String bal_msg = "";	
	double bal_tons = 0;
	String search_inst = requester.getString("search_inst","");
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";
var can_update = <%=!task.isReadOnly()%>;

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

function wnTypeChange()
{
	setValue('inst_id',0);
	setValue('wn_id',0);
	doPost();
}

function doCheckPallet()
{
	var url = "warehouse.weighing.pallet.jsp?uid=<%=user.getuid()%>&scale_id=" + getValue("scale_id");
	window.open(url,'CheckPallet','left=20,top=20,width=540px,height=600px,toolbar=0,resizable=1');
}

function doCheckWeight(wn_type, wn_id)
{
	if (wn_id <= 0) {
		alert("Please select a Weight Note.");
		return;
	}
	var url = "warehouse.weighing.check.jsp?uid=<%=user.getuid()%>&wn_type=" + wn_type + "&wn_id=" + wn_id;
	window.open(url,'CheckWeight','left=20,top=20,width=740px,height=600px,toolbar=0,resizable=1');
}

function selectWn(inst_id)
{
	setValue("inst_id", inst_id);
	doPost();
}

function printWN()
{
	var url = "warehouse.weighing.print-wn.jsp?uid=<%=user.getuid()%>";
	window.open(url);	
}

function show_WNR(cbx)
{
	for (var i = 1; ; i++) {	
		var o = getObj("wnr_" + i);
		if (o == null) break;
		//if (o.title != "New WNR") showObj(o,cbx.checked);
	}
}

function changePacking()
{
	var  s = getSelectedId("wnr_packing_id");
	setValue("wnr_no_of_bags", parseInt(s))
	setFocus("pallet_id");
}

function delete_WN()
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}

	if ( confirm("Delete " + getSelectedText("wn_id")) ) {
		doTask(3);
	}
}

var sample_weight = 0;
function save_WN()
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}

	if (getValue("wn_id") == 0) {
		alert("Please select a Weight Note.");
		return;
	}

	if (wn_type == 'I' || wn_type == 'X' || wn_type == 'R' || wn_type == 'M') {
		if (getValue('status') == 2) {
			if (getValue('area_id') == 0) {
				alert("Please select area for this WN before completion.");
				return;
			} 
		}
	}
	doTask(1);
}

function new_WN()
{
	var new_item = "New Item";
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}
	var inst_id = getValue("inst_id");
	if (<%=!wn.isSample()%> && inst_id == 0) {
		alert("Please select a DI/SI/PO/TR first.");
		return;
	}	
	setValue("filter_date","");
	setValue("filter_grade_id","0");
	if (addNewListItemById("wn_id", new_item) >= 0) doPost();
}

var running = false;
function pass_RW(o, no)
{
	if (running) {
		alert("Process not completed. Please try again.");
		return;
	}
	running = true;
	setValue("no", no);
	if (o.checked) {
		doTask(9);
	} else {
		doTask(19);
	}
}


</script>
<%
	List scales = dao.getScaleDao().selectAll(true);
%>
<%if (sc.wn_type == Const.WN_IMPORT)    {%><%@include file="warehouse.weighing.card-view_im.jsp"%><%}%>					
<%if (sc.wn_type == Const.WN_IN_PRO)    {%><%@include file="warehouse.weighing.card-view_ip.jsp"%><%}%>					
<%if (sc.wn_type == Const.WN_EXPORT)    {%><%@include file="warehouse.weighing.card-view_ex.jsp"%><%}%>					
<%if (sc.wn_type == Const.WN_EX_PRO)    {%><%@include file="warehouse.weighing.card-view_xp.jsp"%><%}%>					
<%if (sc.wn_type == Const.WN_TRUCKING)  {%><%@include file="warehouse.weighing.card-view_tr.jsp"%><%}%>					
<%if (sc.wn_type == Const.WN_RECEIVING) {%><%@include file="warehouse.weighing.card-view_rv.jsp"%><%}%>					
<%if (sc.wn_type == Const.WN_SAMPLE)    {%><%@include file="warehouse.weighing.card-view_sa.jsp"%><%}%>
	  

	<input type="hidden" name="no"  id="no"  value="0">
	

<script language="javascript">
	show_WNR(getObj("show_wnr_"));

	if (getValue("wn_id") == 0) hide("update_btn");
	if (<%=wn.isNew()%>) {	
		var idx = addNewListItem(document.formMain.wn_id,"<%=wn.getRefNumber()%>");
		setText("ref_number_",getSelectedText("wn_id"));
		setValue("wnr_packing_id",<%=wn.packing_id%>);
		changePacking();
	}

	setText("msg_","<%=bal_msg%>");
	if (<%=bal_tons%> <= 0) {
   		setColor("msg_","#FF0000");
	}						

	if ("<%=wnr.pallet_id%>" != "") {
		switch (<%=wnr.status%>) {
			case -1 :
				setText("msg_","Error: Invalid WNR.");
				setColor("msg_","#FF0000");
				break;
			case 1:
				setText("msg_1","<%=wnr.getRefNumber()%> GW: <%=Numeric.numberToStr(wnr.gross_weight,1)%>");
				setText("msg_2","WL: <%=wnr.getWeightLoss()%> kgs");
				break;			
			case 2 :
				setText("msg_","Check Completed");
				setColor("msg_","#FF0000");
				break;
			default:
				break;			
		}
	} 


</script>

