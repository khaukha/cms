<%
	task.doTask(null);
%>


<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";
function poClicked(row,inst_id)
{
	if (inst_id != null) setValue("inst_id",inst_id);
	highlightOn(row);
}


function new_PO()
{
	if (getValue("filter_type_id") <= 0) {
		alert("Please select Processing Type");
		return;
	}
	setValue("inst_id",-1);
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	var task_id = getValue("task_id");
	if (task_id == 0) task_id = 4;
	doTask(task_id);
}

function cancelGenerateReport()
{
	cancelReport("po");
}

function reportDetails()
{
	setValue("task_id",5);
	doReport("po");
}
	
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr>
			<td><img src="images/processing-orders.jpg"></td>
			<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#DDDDDD" align="center">
            <th>Status</th>
            <th>Type</th>
            <th>Quality</th>
            <th>Grade</th>			
            <th>Completion Date</th>
		  </tr>
	<tr>
            <td><%@include file="inc/filter.status.jsp"%></td>
            <td><select name="filter_type_id" id="filter_type_id" size="7" class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptions(dao.getProcessingTypeDao().selectAll(), sc.filter_type_id, "All")%></select></td>
			<td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.filter_quality_id, "All")%></select></td>
             <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getProcessingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getProcessingDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
	</tr>        
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr align="center" bgcolor="#DDDDDD">
                <th width="42" rowspan="2"><img src="../shared/images/refresh.gif" onClick="doPost();" style="cursor:pointer"></th>
                <th width="100" rowspan="2">PO Ref</th>
                <th width="70"  rowspan="2">Date</th>
                <th width="100"  rowspan="2">Type</th>
                <th width="180" rowspan="2">Grade</th>
                <th width="80" rowspan="2">Packing</th>
                <th colspan="4">Processing</th>
                <th colspan="3">Weight Loss </th>
                <th colspan="2">Processing Period</th>
                <th width="60" rowspan="2">Comp.<br />Date</th>
                <th width="" rowspan="2">&nbsp;</th>
              </tr>
              <tr align="center" bgcolor="#DDDDDD">
                <th width="70">Allocated</th>
                <th width="70">In-Pro.</th>
                <th width="70">Ex-Pro.</th>
                <th width="70">Bal.</th>
                <th width="60">Storage</th>
                <th width="60">Pro.</th>
                <th width="50">%</th>
                <th width="60">From</th>
                <th width="60">To</th>
              </tr>
</table>	

<div id="po_list_view" style="overflow:scroll; height:250px; width:100%;"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<ProcessingEntity> pos = dao.getProcessingDao().getPaging().paging();
	ProcessingEntity sum = dao.getProcessingDao().getPaging().sumary();
	for (int i = 0; i < pos.size(); i++) {
		ProcessingEntity po = pos.get(i);
		if (po.xp_loss_tons != po.getXpLossTons()) {
	    	po.xp_loss_tons  = po.getXpLossTons();
			po.update();
		}
		//sum.add(po);
		String color = Action.getColor(po.status);
		String wl_percent = (po.getXpLossPercent() > 0) ? Numeric.numberToStr(po.getXpLossPercent()) : "-&nbsp;&nbsp;&nbsp;&nbsp;";
%>				
                <tr onClick="poClicked(this,<%=po.getIdLong()%>)" onDblClick="setValue('view',1);doPost();">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=po.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=color%>;"><%=po.getShortRef()%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(po.date)%></td>
                  <td width="100"><%=po.getProcessingType().short_name%></td>
                  <td width="180"><%=po.getGrade().short_name%></td>
                  <td width="80"><%=po.getPacking().short_name%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(po.allocated_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(po.ip_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(po.xp_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(po.getOpenTons(),3)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(po.ip_loss_tons,3)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(po.xp_loss_tons,3)%>&nbsp;</td>
                  <td width="50" align="right"><%=wl_percent%>&nbsp;</td>
                  <td width="60" align="center"><%=DateTime.dateToStr(po.first_date)%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(po.last_date)%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(po.completed_date)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
	</table>
</div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD">
			  	<th width="42" bgcolor="#DDDDDD">&nbsp;</th>
                <th width="534" align="center">Total</th>
                <th width="70" align="right"><%=Numeric.numberToStr(sum.allocated_tons,3)%>&nbsp;</th>
                <th width="70" align="right"><%=Numeric.numberToStr(sum.ip_tons,3)%>&nbsp;</th>
                <th width="70" align="right"><%=Numeric.numberToStr(sum.xp_tons,3)%>&nbsp;</th>
                <th width="70" align="right"><%=Numeric.numberToStr(sum.getOpenTons(),3)%>&nbsp;</th>
                <th width="60" align="right"><%=Numeric.numberToStr(sum.ip_loss_tons,3)%>&nbsp;</th>
                <th width="60" align="right"><%=Numeric.numberToStr(sum.xp_loss_tons,3)%>&nbsp;</th>
                <th width="50">&nbsp;</th>
                <th width="60">&nbsp;</th>
                <th width="60">&nbsp;</th>
                <th width="60">&nbsp;</th>
                <th width="">&nbsp;</th>
              </tr>
</table>
<div id="po_report" style="display:none; width:100%"><%@include file="report.parameter.jsp"%></div>
<table id="po_buttons" width="100%"  border="0" class="style2" cellpadding="0" cellspacing="0">
		  <tr>
		  	 <td width="20" style="display:<%=displayed%>"><img src="images/new.gif" border="0" width="15" height="15" onClick="new_PO()"></td>
			 <td align="center"><%@include file="paging.jsp"%></td>
			 <td align="right" width="60" style="display:"><a href="JavaScript:reportDetails()" class="style2">Details</a> &nbsp;</td>
             <td align="right" width="60"><img src="images/report.jpg" width="55" height="18" onClick="doReport('po');"></td>
			 <td align="right" width="60"><img id="bt_card_view" src="images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
	      </tr>
</table>
  
	<input type="hidden" name="inst_id"  id="inst_id"  value="0">


