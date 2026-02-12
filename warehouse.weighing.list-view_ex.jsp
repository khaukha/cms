<%
	WeighingExport weighing = task.getWeighingExport();
	weighing.doTask();
%>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	      <tr bgcolor="#DDDDDD">
            <th width="100">Type</th>
            <th width="100">Status</th>
            <th width="100">Truck No </th>
            <th width="150"><input name="search_inst" id="search_inst" type="text"  class="style11" style="width:150;" value="<%=search_inst%>" onKeyUp="doSearch1(event)"></th>
            <th width="150">Buyer</th>
            <th width="100">Warehouse</th>
            <th width="100">Quality</th>
            <th width="">Grade</th>
            <th width="100">Date</th>
  </tr>
          <tr>
            <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_truck_no" id="filter_truck_no" size=7 class="style11" style="width:100%;" onchange="doPost();"><%=Html.selectOptionsX(dao.getWnExportDao().getTruckNoFilter(),sc.filter_truck_no,"All")%></select></td>
            <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onchange="itemSelected(this)"><%=Html.selectOptionsX(weighing.getInstList(),sc.filter_inst_id,"All")%></select></td>
             <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
            <td><select name="filter_warehouse_id" id="filter_warehouse_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(whse_list,sc.filter_warehouse_id,"All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="qualityChange()"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnExportDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(weighing.selectDateFilter(),sc.filter_date,"All")%></select></td>
  </tr>		  
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="42" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="100" rowspan="2">WN Ref</th>
                  <th width="90" rowspan="2">Container No.</th>
                  <th width="90" rowspan="2">Seal No.</th>
                  <th width="100" rowspan="2">SI Ref</th>
                  <th width="140" rowspan="2">Buyer</th>
                  <th width="180" rowspan="2">Grade</th>
                  <th width="70" rowspan="2">Date </th>
                  <th width="80" rowspan="2">Warehouse</th>
                  <th width="80" rowspan="2">Packing</th>
                  <th width="60" rowspan="2">#Bags</th>
                  <th colspan="3">Kgs</th>
                  <th width="" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="70">Gross</th>
                  <th width="60">Tare</th>
                  <th width="70">Net</th>
                </tr>
</table>

<div id="weighing_list_view" style="overflow:scroll; height:250px; width:100%">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.inst_type = 'S';
	sc.setFilterDate();
	List<WnExportEntity> wns = dao.getWnExportDao().getPaging().paging();
	WnExportEntity sum = dao.getWnExportDao().getPaging().sumary();
	double sum_pending_weight = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnExportEntity wn = wns.get(i);				
		FinalInvoiceEntity iv = wn.getInvoice();
		if (wn.net_weight != iv.net_weight) {
    		iv.save(wn);
		}
		double pending_weight = wn.isCompleted() ? 0 : Math.max(wn.allocated_weight - wn.net_weight,0);
		sum_pending_weight += pending_weight;
		String wn_color = Action.getColor(wn.status);
%>				
                <tr onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=wn_color%>"><%=wn.getShortRef()%></td>
                  <td width="90"><%=wn.container_no%></td>
                  <td width="90"><%=wn.seal_no%></td>
                  <td width="100"><%=wn.getInstruction().getShortRef()%></td>
                  <td width="140"><%=wn.getInstruction().getContract().getBuyer().short_name%></td>
                  <td width="180"><%=wn.getGrade().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="80"><%=wn.getWarehouse().short_name%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.no_of_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.gross_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.net_weight,0)%>&nbsp;</td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table></div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right" bgcolor="#DDDDDD">
		  	<td width="42">&nbsp;</td>
            <td width="938" align="center">Total</td>
            <td width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</td>
            <td width="70"><%=Numeric.numberToStr(sum.gross_weight,0)%>&nbsp;</td>
            <td width="60"><%=Numeric.numberToStr(sum.tare_weight,0)%>&nbsp;</td>
            <td width="70"><%=Numeric.numberToStr(sum.net_weight,0)%>&nbsp;</td>
			<td width="">&nbsp;</td>
          </tr>
</table>

<div id="weighing_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
<table id="weighing_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
               <tr>
                 <td width="20"><img src="../shared/images/new.gif" onClick="doAddNew();" style="display:<%=displayed%>"></td>
				 <td align="center"><%@include file="paging.jsp"%></td>
                 <td width="60" align="center"><img src="images/report.jpg" onClick="doReport('weighing','(WN Date)');"></td>
				 <td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="doCardView();"></td>
               </tr>
</table>