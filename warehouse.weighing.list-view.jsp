<%@include file="authentication.jsp"%>
<%@ page import="ibu.ucms.biz.warehouse.weighing.wn.*" %>

<%
	ibu.ucms.biz.warehouse.Weighing task = user.getBiz().getWareHouse().getWeighing();
	String displayed = task.isReadOnly() ? "none" : "";	
	List whse_list = dao.getWarehouseDao().selectByLocationId(location_id);
	String search_inst = requester.getString("search_inst","");
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

var can_update = <%=!task.isReadOnly()%>;

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

function wnDblClicked(row,wn_id,inst_id)
{
	/*
	if (wn_id != null) { 
		setValue("wn_id",wn_id);
	}
	if (inst_id != null) {  
		setValue("inst_id",inst_id);
	}
	*/
	wnClicked(row,wn_id,inst_id);
	setValue("filter_date","");
	setValue('view',1);
	doTask()
}

function doCardView()
{
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	doTask(7);
}

function cancelGenerateReport()
{
	cancelReport('weighing');
}

function doAddNew()
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}
	if (getValue("inst_id") == 0) {
		alert("Please select a DI/PO.");
		return;
	}
	setValue("wn_id",-1);
	setValue("view",1);
	doPost();
}

function wnTypeChange()
{
	setValue('inst_id',0);
	setValue('wn_id',0);
	doPost();
}

function qualityChange()
{
	setValue('filter_grade_id',0);
	doPost();
}
</script>
	<%sc.type = ' ';%>
	<%if (sc.wn_type == Const.WN_IMPORT)    {%><%@include file="warehouse.weighing.list-view_im.jsp"%><%}%>
	<%if (sc.wn_type == Const.WN_EX_PRO)    {%><%@include file="warehouse.weighing.list-view_xp.jsp"%><%}%>
	<%if (sc.wn_type == Const.WN_IN_PRO)    {%><%@include file="warehouse.weighing.list-view_ip.jsp"%><%}%>
	<%if (sc.wn_type == Const.WN_EXPORT)    {%><%@include file="warehouse.weighing.list-view_ex.jsp"%><%}%>
	<%if (sc.wn_type == Const.WN_TRUCKING)  {%><%@include file="warehouse.weighing.list-view_tr.jsp"%><%}%>
	<%if (sc.wn_type == Const.WN_RECEIVING) {%><%@include file="warehouse.weighing.list-view_rv.jsp"%><%}%>
	<%if (sc.wn_type == Const.WN_SAMPLE)    {%><%@include file="warehouse.weighing.list-view_sa.jsp"%><%}%>

	  
<input type="hidden" name="wn_id"  id="wn_id"  value="0">
<input type="hidden" name="inst_id"  id="inst_id"  value="0">
