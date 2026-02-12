<%
	WeighingImport weighing = task.getWeighingImport();
	weighing.doTask();
%>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	      <tr bgcolor="#DDDDDD" align="center">
            <th width="100">Type</th>
            <th width="100">Status</th>
            <th width="100">Truck No </th>
            <th width="150">Warehouse</th>
            <th width="150">DI Ref.</th>
            <th width="">Grade</th>
            <th width="180">Supplier</th>
            <th width="100">Date</th>
	        </tr>
          <tr>
            <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_truck_no" id="filter_truck_no" size=7 class="style11" style="width:100%;" onchange="doPost();"><%=Html.selectOptionsX(dao.getWnImportDao().getTruckNoFilter(),sc.filter_truck_no,"All")%></select></td>
            <td><select name="filter_warehouse_id" id="filter_warehouse_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptionsX(whse_list,sc.filter_warehouse_id,"All")%></select></td>
            <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onchange="itemSelected(this);"><%=Html.selectOptionsX(weighing.getInstList(),sc.filter_inst_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnImportDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(weighing.selectDateFilter(), sc.filter_date, "All")%></select></td>
            </tr>		  
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="42" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="100" rowspan="2" onClick="doSort(table,'wn.ref_number')">WN  Ref</th>
                  <th width="100" rowspan="2">DI Ref.</th>
                  <th width="140" rowspan="2" >Supplier</th>
                  <th width="180" rowspan="2">Grade</th>
                  <th width="30" rowspan="2">Wh.</th>
                  <th width="40" rowspan="2">Area</th>
                  <th width="70" rowspan="2">Date </th>
                  <th width="60" rowspan="2">Truck<br />No.</th>
                  <th width="60" rowspan="2">Packing</th>
                  <th width="60" rowspan="2">Num</th>
                  <th colspan="3">Kgs</th>
                  <th colspan="2">Stock</th>
                  <th width="" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="60">Gross</th>
                  <th width="60">Tare</th>
                  <th width="60">Net</th>
                  <th width="40">Bags</th>
                  <th width="60">Kgs</th>
                </tr>
	</table>

<div id="weighing_list_view" style="overflow:scroll; height:250px; width:100%;">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
    sc.setFilterDate();
	sc.qr_type = Const.NONE;
	List<WnImportEntity> wns = dao.getWnImportDao().getPaging().paging();
	WnImportEntity sum = dao.getWnImportDao().getPaging().sumary();
	for (int i = 0; i < wns.size(); i++) {
		WnImportEntity wn = wns.get(i);
		String wn_color = Action.getColor(wn.status);
		String kgs_bag = (wn.no_of_bags != 0) ? Numeric.numberToStr(wn.net_weight/wn.no_of_bags,2) : "";
%>				
                <tr onClick="wnClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=wn_color%>"><%=wn.getShortRef()%></td>
                  <td width="100"><%=wn.getInstruction().getShortRef()%></td>
                  <td width="140"><%=wn.getInstruction().getContract().getSeller().short_name%></td>
                  <td width="180"><%=wn.getGrade().short_name%></td>
                  <td width="30" align="center"><%=wn.getWarehouse().code%></td>
                  <td width="40" align="center"><%=wn.getArea().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="60"><%=wn.truck_no%></td>
                  <td width="60"><%=wn.getPacking().short_name%></td>
                  <td width="60" align="right"><%=wn.no_of_bags%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.gross_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.net_weight,0)%>&nbsp;</td>
                  <td width="40" align="right"><%=Numeric.numberToStr(wn.stock_bags,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_weight,0)%>&nbsp;</td>
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
		<td width="788" align="center">Total</td>
		<td width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</td>
		<td width="60"><%=Numeric.numberToStr(sum.gross_weight,0)%>&nbsp;</td>
            <td width="60"><%=Numeric.numberToStr(sum.tare_weight,0)%>&nbsp;</td>
            <td width="60"><%=Numeric.numberToStr(sum.net_weight,0)%>&nbsp;</td>
            <td width="40" align="right"><%=Numeric.numberToStr(sum.stock_bags,0)%>&nbsp;</td>
            <td width="60" align="right"><%=Numeric.numberToStr(sum.stock_weight,0)%>&nbsp;</td>
			<td width="">&nbsp;</td>
		  </tr>
</table>

<div id="weighing_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
	  
<table id="weighing_buttons"  width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td width="20"><img src="../shared/images/new.gif" width="15" height="15" onClick="doAddNew();" style="display:<%=displayed%>"></td>
		<td align="center"><%@include file="paging.jsp"%></td>
        <td width="60" align="center"><img src="images/report.jpg" width="55" height="18" onClick="doReport('weighing','(WN Date)');"></td>
		<td width="60" align="center"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="doCardView();"></td>
  </tr>
</table>		

	


