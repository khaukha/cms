<%
	task.doTask(null);
	boolean show_unnormal = requester.getBoolean("show_unnormal", false);
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";
var table = 'traffic.trucking';

function rowDoubleClick(trucking_id)
{
	if (trucking_id != null) {
		setValue("trucking_id",trucking_id);
	}
	setValue("view",1);
	doPost();
	//highlightOn(row);
}


function newTrucking()
{
	setValue("trucking_id",-1);
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport("trucking");
}

</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr>
			<td width="120"><img src="images/trucking.jpg"></td>
			<td width="150" align="right">Show Unnormal Truckings&nbsp;</td>
			<td><%=Html.checkBox("show_unnormal", show_unnormal, "doPost()")%></td>
			<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          		<tr bgcolor="#DDDDDD">
          		  <th width="120">Status</th>
          		  <th width="120">From</th>
          		  <th width="120">To</th>
            	  <th width="200">Forwarder</th>
          		  <th width="100">Quality</th>
          		  <th>Grade</th>			
            	  <th width="100">Trucking Date</th>
		  		</tr>
				<tr>
					<td><%@include file="inc/filter.status.jsp"%></td>
				  	<td><select name="filter_source_id" id="filter_source_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_source_id,"All")%></select></td>
				  	<td><select name="filter_destination_id" id="filter_destination_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_destination_id,"All")%></select></td>
				 	<td><select name="filter_forwarder_id" id="filter_forwarder_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getForwarderList(),sc.filter_forwarder_id,"All")%></select></td>
            		<td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.filter_quality_id, "All")%></select></td>
				  	<td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getGradeDao().selectAll(),sc.filter_grade_id,"All")%></select></td>
					<td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckingDao().selectDateFilter(),sc.filter_date,"All")%></select></td>
				</tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr align="center" bgcolor="#DDDDDD">
                <th width="42" rowspan="2"><img src="../shared/images/refresh.gif" onClick="doPost();" style="cursor:pointer"></th>
                <th width="94" rowspan="2">Trucking Ref.</th>
                <th width="60" rowspan="2">Truck<br />No.</th>
                <th width="150" rowspan="2">From</th>
                <th width="100" rowspan="2">To</th>
                <th width="180" rowspan="2">Grade</th>
                <th width="60" rowspan="2">From<br />Date</th>
                <th width="60" rowspan="2">To<br />Date</th>
                <th colspan="2"> Loaded</th>
                <th colspan="2">Unloaded</th>
                <th colspan="2">Diff.</th>
                <th width="" rowspan="2">&nbsp;</th>
    </tr>
              <tr align="center" bgcolor="#DDDDDD">
                <th width="70">Bags</th>
                <th width="70">Kgs</th>
                <th width="60">Bags</th>
                <th width="60">Kgs</th>
                <th width="60">Bags</th>
                <th width="60">Kgs</th>
              </tr>
</table>

<div id="trucking_list_view" style="overflow:scroll; height:260px; width:100%">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterDate();
	List<TruckingEntity> trs = show_unnormal ? task.getProblemTruckings() : dao.getTruckingDao().getPaging().paging();
	TruckingEntity sum = show_unnormal ? dao.getTruckingDao().newEntity() : dao.getTruckingDao().getPaging().sumary();
	for (int i = 0; i < trs.size(); i++) {
		TruckingEntity tr = trs.get(i);
		String color;
		if (show_unnormal) {
			if (sc.filter_source_id != 0 && tr.source_id != sc.filter_source_id) continue;
			if (sc.filter_destination_id != 0 && tr.destination_id != sc.filter_destination_id) continue;
			color= "#FF0000";
		} else {
			color = Action.getColor(tr.status);
		}
		String bgcolor = i%2==1?"":"#CCFFFF";
		if (show_unnormal) sum.add(tr);
%>				
                <tr bgcolor="<%=bgcolor%>" onClick="highlightOn(this)" onDblClick="rowDoubleClick(<%=tr.getIdLong()%>);">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=tr.getIdLong()%>&nbsp;</th>
                  <td width="94" style="color:<%=color%>"><%=tr.getRefNumber()%></td>
                  <td width="60"><%=tr.truck_no%></td>
                  <td width="150"><%=tr.getFrom().short_name%></td>
                  <td width="100"><%=tr.getDestination().short_name%></td>
                  <td width="180"><%=tr.getGrade().short_name%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(tr.date)%></td>
                  <td width="60" align="center"><%=tr.isCompleted()?DateTime.dateToStr(tr.completed_date):""%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tr.no_of_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tr.net_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(tr.delivered_bags,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(tr.delivered_tons*1000,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(tr.delivered_bags-tr.no_of_bags,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(tr.delivered_tons*1000-tr.net_weight,0)%>&nbsp;</td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" style="font-weight:bold;" align="right">
                <td width="753" align="center">Total</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(sum.net_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.delivered_bags,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.delivered_tons*1000,0)%>&nbsp;</td>
                <td width="60"><%=Numeric.numberToStr(sum.delivered_bags-sum.no_of_bags,0)%>&nbsp;</td>
                <td width="60"><%=Numeric.numberToStr(sum.delivered_tons*1000-sum.net_weight,0)%>&nbsp;</td>
                <td width="">&nbsp;</td>
              </tr>
</table>
			
<div id="trucking_report" style="display:none"><%@include file="report.parameter.jsp"%></div>	

<table id="trucking_buttons" width="100%"  border="0" class="style2" cellpadding="0" cellspacing="0">
		  <tr>
		  	 <td width="20" style="display:<%=displayed%>"><img src="images/new.gif" border="0" width="15" height="15" onClick="newTrucking()"></td>
			 <td align="center"><div style="display:<%=show_unnormal?"none":""%>"><%@include file="paging.jsp"%></div></td>
             <td align="right" width="60"><img src="images/report.jpg" width="55" height="18" onClick="doReport('trucking','');"></td>
			 <td align="right" width="60"><img id="trucking_card_view" src="images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
	      </tr>
</table>
  	
<input type="hidden" name="trucking_id"   id="trucking_id"    value="0">
	
