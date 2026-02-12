<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#DDDDDD" align="center">
            <th width="110">Type</th>
            <th width="100">Status</th>
            <th width="120">From</th>
            <th width="120">To</th>
            <th width="120">Truck No</th>
            <th>Grade</th>            
            <th width="120">Date</th>
  </tr>
          <tr>
            <td><select name="alloc_type" id="alloc_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%@include file="inc/options.allocation.jsp"%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(), sc.filter_status, "All")%></select></td>
            <td><select name="filter_source_id" id="filter_source_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_source_id,"All")%></select></td>
            <td><select name="filter_destination_id" id="filter_destination_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_destination_id,"All")%></select></td>
		 	<td><select name="filter_truck_no" id="filter_truck_no" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckingDao().getTruckNoFilter(),sc.filter_truck_no,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckingDao().getGradeFilter(0),sc.filter_grade_id,"All")%></select></td>
            <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckingDao().selectDateFilter(),sc.filter_date,"All")%></select></td>
          </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr align="center" bgcolor="#DDDDDD">
                <th width="42"  rowspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
                <th width="110"  rowspan="2">Trucking Ref</th>
                <th width="180" rowspan="2">Grade</th>
                <th width="100" rowspan="2">Packing</th>
                <th width="120" rowspan="2">From</th>
                <th width="120" rowspan="2">To</th>
                <th colspan="3">Kgs</th>
                <th colspan="2">Period</th>
                <th width="" rowspan="2">&nbsp;</th>
              </tr>
              <tr align="center" bgcolor="#DDDDDD">
                <th width="70">Loaded</th>
                <th width="70">Delivered</th>
                <th width="70">Diff.</th>
                <th width="70">From</th>
                <th width="70">To</th>
              </tr>
</table>

<div id="allocation_list_view" style="overflow:scroll; height:250px; width:100%; display:">
		<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterDate();
	double sum_balanced_tons = 0;
	List<TruckingEntity> trs = dao.getTruckingDao().getPaging().paging();
	TruckingEntity	sum = dao.getTruckingDao().getPaging().sumary();	
	for (int i = 0; i < trs.size(); i++) {
		TruckingEntity tr = trs.get(i);
		String color = Action.getColor(tr.status);
%>				
                <tr onClick="instClicked(this,<%=tr.getIdLong()%>)" onDblClick="setValue('view',1);doTask();">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=tr.getIdLong()%>&nbsp;</th>
                  <td width="110" style="color:<%=color%>"><%=tr.getRefNumber()%></td>
                  <td width="180"><%=tr.getGrade().short_name%></td>
                  <td width="100"><%=tr.getPacking().short_name%></td>
                  <td width="120"><%=tr.getSource().short_name%></td>
                  <td width="120"><%=tr.getDestination().short_name%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tr.net_weight,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tr.delivered_tons*1000,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(tr.getDiffWeight(),0)%>&nbsp;</td>
                  <td width="70" align="center"><%=DateTime.dateToStr(tr.date)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(tr.completed_date)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>		
	</table></div>
	
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr style="font-weight:bold" align="right" bgcolor="#DDDDDD">
                <td width="677" align="center">Total</td>
                <td width="70"><%=Numeric.numberToStr(sum.net_weight,0)%>&nbsp;</td>
                <td width="70"><%=Numeric.numberToStr(sum.delivered_tons*1000,0)%>&nbsp;</td>
                <td width="70"><%=Numeric.numberToStr(sum.getDiffWeight(),0)%>&nbsp;</td>
                <td width="70">&nbsp;</td>
				<td width="70">&nbsp;</td>
				<td width="">&nbsp;</td>
              </tr>
</table>

