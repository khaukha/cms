<%
	task.doTask(null, null);
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function wnTypeChange()
{
	setValue('inst_id',0);
	setValue('truck_weight_id',0);
	doPost();
}

function doCardView()
{
	setValue("view",1);
	doPost();
}

function twDblClicked(row, tw_id)
{
	if (tw_id != null) { 
		setValue("truck_weight_id", tw_id);
	}
	setValue("view",1);
	doTask()
}

function doGenerateReport()
{
	doTask(5);
}

function genReport()
{
	//show("date_type_");
	//show("all_location_");
	doReport("bridge_scale","");
}

</script>
		  
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td style="font-size:14px;">&nbsp;&nbsp;<strong>BRIDGE SCALE</strong></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
          <tr bgcolor="#EEEEEE" class="style3" align="center" style="font-weight:bold">
            <th width="100">Type</th>
            <th width="100">Status</th>
            <th width="100">Date</th>
            <th width="120">Truck No</th>
            <th>&nbsp;</th>
            </tr>
          <tr>
            <td valign="top"><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(true),sc.wn_type)%></select></td>
            <td valign="top"><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td valign="top"><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckWeightDao().selectDateFilter(), sc.filter_date, "All")%></select></td>
            <td valign="top"><select name="filter_truck_no" id="filter_truck_no" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckWeightDao().getTruckNoFilter(),sc.filter_truck_no,"All")%></select></td>
            <td valign="top">&nbsp;</td>
            </tr>
</table>

<div id="bridge_scale_list_view">
	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="center" bgcolor="#DDDDDD" style="cursor:pointer" title='' onMouseOver="window.status=''" >
                  <th width="40" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="80" rowspan="2">Truck No</th>
                  <th width="120" rowspan="2">Contract Ref.</th>
                  <th colspan="3">In</th>
                  <th colspan="3">Out</th>
                  <th colspan="3">Gross WT (Mts)</th>
                  <th width="200" rowspan="2">&nbsp;Remark</th>
                  <th rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD" style="cursor:pointer" title='' onMouseOver="window.status=''" >
                  <th width="70">Date</th>
                  <th width="60">Time</th>
                  <th width="70">Mts</th>
                  <th width="70">Date</th>
                  <th width="60">Time</th>
                  <th width="70">Mts</th>
                  <th width="70">B.Scale</th>
                  <th width="70">E.Scale</th>
                  <th width="70">Diff</th>
                </tr>
	</table>

<div style="overflow:scroll; height:250px; width:100%;"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<TruckWeightEntity> tws = dao.getTruckWeightDao().search(sc);
	TruckWeightEntity sum = dao.getTruckWeightDao().newEntity();
	for (int i = 0; i < tws.size(); i++) {
		TruckWeightEntity tw = tws.get(i);
		sum.add(tw);
		//if (i >= 200) continue;
		String color = Action.getColor(tw.status);
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="twDblClicked(this,<%=tw.getIdLong()%>)">
                  <td width="40" align="right" bgcolor="#DDDDDD"><strong><%=tw.getIdLong()%></strong>&nbsp;</td>
                  <td width="80" style="color:<%=color%>"><%=tw.getRefNumber()%></td>
                  <td width="120"><%=tw.getInstruction().getRefNumber()%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(tw.date)%></td>
                  <td width="60" align="center"><%=DateTime.timeToStr(tw.time_in)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tw.weight_in/1000,3)%>&nbsp;</td>
                  <td width="70" align="center"><%=DateTime.dateToStr(tw.date_out)%></td>
                  <td width="60" align="center"><%=DateTime.timeToStr(tw.time_out)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tw.weight_out/1000,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tw.gross_weight/1000)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tw.e_gross_weight/1000)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tw.diff_weight/1000)%>&nbsp;</td>
                  <td width="200">&nbsp;<%=tw.remark%></td>
                  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>

	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#DDDDDD">
                  <th width="30">&nbsp;</th>
                  <th width="">Total</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.weight_in/1000,3)%>&nbsp;</th>
				  <th width="60">&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.weight_out/1000,3)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.gross_weight/1000)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.e_gross_weight/1000)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.diff_weight/1000)%>&nbsp;</th>
                  <th width="200" align="right">                  
                  <th width="16" align="right">                  
                </tr>
	</table>

</div>	  

<div id="bridge_scale_report" style="display:none"><%@include file="report.parameter.jsp"%></div>

<table id="bridge_scale_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
			<td>&nbsp;</td>
          <td align="right"><img style="display:" src="images/report.jpg" width="55" height="18" onClick="genReport();"></td>
    	  <td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="doCardView();"></td>
        </tr>
</table>
	<input type="hidden" name="inst_id" id="inst_id"  value="0">
	<input type="hidden" name="truck_weight_id" id="truck_weight_id"  value="0">

