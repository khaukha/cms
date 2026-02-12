<%
	WeighingReceiving weighing = task.getWeighingReceiving();
	weighing.doTask();
	sc.location_id = 0;
%>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	      <tr bgcolor="#DDDDDD">
            <th width="100">Type</th>
            <th width="100">Status</th>
            <th width="150">From</th>
            <th width="150">To</th>
            <th width="150">Trucking Ref.</th>
            <th width="">Grade</th>
            <th width="100">Date</th>
  </tr>
          <tr>
            <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
             <td><select name="filter_source_id" id="filter_source_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_source_id,"All")%></select></td>
             <td><select name="filter_destination_id" id="filter_destination_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_destination_id,"All")%></select></td>
            <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onchange="itemSelected(this);"><%=Html.selectOptionsX(weighing.getInstList(),sc.filter_inst_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnReceivingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(weighing.selectDateFilter(), sc.filter_date, "All")%></select></td>
  </tr>		  
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr bgcolor="#DDDDDD">
                  <th width="42" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="100" rowspan="2">WN  Ref</th>
                  <th width="100" rowspan="2">Trucking Ref</th>
                  <th width="60" rowspan="2">Truck<br />No</th>
                  <th width="90" rowspan="2">From</th>
                  <th width="80" rowspan="2">To</th>
                  <th width="180" rowspan="2">Grade</th>
                  <th width="30" rowspan="2">Wh</th>
                  <th width="40" rowspan="2">Ar.</th>
                  <th width="70" rowspan="2">Date </th>
                  <th width="60" rowspan="2">Packing</th>
                  <th width="60" rowspan="2">Num</th>
                  <th colspan="4">Mts</th>
                  <th width="" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="70">Gross</th>
                  <th width="60">Tare</th>
                  <th width="70">Net</th>
                  <th width="60">Stock</th>
                </tr>
</table>
<div id="weighing_list_view" style="overflow:scroll; height:250px; width:100%"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
    sc.setFilterDate();
	List<WnReceivingEntity> wns = dao.getWnReceivingDao().getPaging().paging();
	WnReceivingEntity sum = dao.getWnReceivingDao().getPaging().sumary();
	for (int i = 0; i < wns.size(); i++) {
		WnReceivingEntity wn = wns.get(i);
		String wn_color = Action.getColor(wn.status);
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=wn_color%>"><%=wn.getShortRef()%></td>
                  <td width="100"><%=wn.getTrucking().getRefNumber()%></td>
                  <td width="60"><%=wn.getTrucking().truck_no%></td>
                  <td width="90"><%=wn.getTrucking().getFrom().short_name%></td>
                  <td width="80"><%=wn.getTrucking().getDestination().short_name%></td>
                  <td width="180"><%=wn.getGrade().short_name%></td>
                  <td width="30" align="center"><%=wn.getWarehouse().code%></td>
                  <td width="40" align="center"><%=wn.getArea().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="60"><%=wn.getPacking().short_name%></td>
                  <td width="60" align="right"><%=wn.no_of_bags%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.gross_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight/1000)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.net_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_weight/1000)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right" bgcolor="#DDDDDD">
		  <td width="42">&nbsp;</td>
            <td width="819" align="center">Total</td>
            <td width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</td>
            <td width="70"><%=Numeric.numberToStr(sum.gross_weight/1000)%>&nbsp;</td>
            <td width="60"><%=Numeric.numberToStr(sum.tare_weight/1000)%>&nbsp;</td>
            <td width="70"><%=Numeric.numberToStr(sum.net_weight/1000)%>&nbsp;</td>
            <td width="60"><%=Numeric.numberToStr(sum.stock_weight/1000)%>&nbsp;</td>
			<td width="">&nbsp;</td>
          </tr>
</table>
<div id="weighing_report" style="display:none"><%@include file="report.parameter.jsp"%></div>	
<table id="weighing_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="20"><img src="../shared/images/new.gif" width="15" height="15" onClick="doAddNew();" style="display:<%=displayed%>"></td>
		<td align="center">&nbsp;<%@include file="paging.jsp"%></td>
        <td width="60" align="right"><img src="images/report.jpg" width="55" height="18" onClick="doReport('weighing','(WN Date)');"></td>
		<td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="doCardView();"></td>
    </tr>
</table>  

