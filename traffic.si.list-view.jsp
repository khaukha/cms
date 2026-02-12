<%
	task.doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

function doCardView()
{
	setValue("view",1);
	doPost();
}

function siClicked(row)
{
	highlightOn(row);
}

function siDblClicked(row,contract_id,inst_id)
{
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	if (inst_id != null) {
		setValue("inst_id",inst_id);
	}
	doCardView();
}

function new_SI()
{
	var name = "Shipping Instruction";
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract for this " + name);
		return;
	}	
	setValue("inst_id",-1);
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('si');
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
<tr>
	<td width="100"><img src="images/shipping-instruction.jpg"></td>
	<td align="right"><%@include file="search.jsp"%></td>
</tr>
</table>		
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#EEEEEE" align="center">
		<th width="100">Status</th>
		<th width="150">Warehouse</th>
		<th width="180">Contract Ref</th>
		<th width="180">Buyer</th>
		<th width="180">Destination</th>
		<th width="100">Quality</th>
		<th width="">Grade</th>			
		<th width="120">Shipment Month</th>
	</tr>
<tr>
    <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
	<td><select name="filter_warehouse_id" id="filter_warehouse_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_warehouse_id,"All")%></select></td>
	<td><select name="filter_contract_id" id="filter_contract_id" size="7" class="style11" style="width:100%;" onChange="setValue('contract_no',0);itemSelected(this)"><%=Html.selectOptionsX(dao.getSaleContractDao().list(), sc.filter_contract_id, "All")%></select></td>
	<td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
    <td><select name="filter_destination_id" id="filter_destination_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPortDao().selectAll(),sc.filter_destination_id,"All")%></select></td>
	<td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.filter_quality_id, "All")%></select></td>
    <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getShippingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
    <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getShippingDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
</tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr align="center" bgcolor="#EEEEEE">
                <td width="42" rowspan="2" onClick="doPost();"><img src="../shared/images/refresh.gif"></td>
                <th width="110" rowspan="2">SI Ref</th>
                <th width="120"  rowspan="2">Buyer</th>
                <th width="120"  rowspan="2">Forwarder</th>
                <th width="180" rowspan="2">Grade</th>
                <th width="100" rowspan="2">Packing</th>
                <th colspan="2">Allocated</th>
                <th colspan="2">Shipped</th>
                <th colspan="2">Del. Period</th>
                <th width="" rowspan="2">&nbsp;</th>
              </tr>
              <tr align="center" bgcolor="#EEEEEE">
                <th width="70">Bags</th>
                <th width="70">Kgs</th>
                <th width="70">Bags</th>
                <th width="70">Kgs</th>
                <th width="70">From</th>
                <th width="70">To</th>
              </tr>
</table>
<div id="si_list_view" style="overflow:scroll; height:250px; width:100%">		  
			  <table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<ShippingEntity> sis = dao.getShippingDao().getPaging().paging();
	ShippingEntity total = dao.getShippingDao().getPaging().sumary();
	for (int i = 0; i < sis.size(); i++) {
		ShippingEntity si = sis.get(i);
		if (si.allocated_tons > 0 && si.allocated_bags == 0) {
			si.sumAllocations();
			si.update();
		}
		String color = Action.getColor(si.status);
%>				
                <tr onClick="siClicked(this)" onDblClick="siDblClicked(this,<%=si.getContract().getIdLong()%>,<%=si.getIdLong()%>)">
                  <th width="42" align="right" bgcolor="#EEEEEE"><%=si.getIdLong()%>&nbsp;</th>
                  <td width="110" style="color:<%=color%>"><%=si.getRefNumber()%></td>
                  <td width="80" style="display:none"><%=si.getContract().getRefNumber()%></td>
                  <td width="120"><%=si.getContract().getBuyer().short_name%></td>
                  <td width="120"><%=si.getContract().getForwarder().short_name%></td>
                  <td width="180"><%=si.getGrade().short_name%> &nbsp; </td>
                  <td width="100"><%=si.getPacking().short_name%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(si.allocated_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(si.allocated_tons*1000,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(si.delivered_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(si.delivered_tons*1000,0)%>&nbsp;</td>
                  <td width="70" align="center"><%=DateTime.dateToStr(si.first_date)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(si.last_date)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#EEEEEE" style="font-weight:bold;"  align="right">
			  	<td width="42" bgcolor="#EEEEEE">&nbsp;</td>
                <td width="634" align="center">Total</td>
                <td width="70"><%=Numeric.numberToStr(total.allocated_bags,0)%>&nbsp;</td>
                <td width="70"><%=Numeric.numberToStr(total.allocated_tons*1000,0)%>&nbsp;</td>
                <td width="70"><%=Numeric.numberToStr(total.delivered_bags,0)%>&nbsp;</td>
                <td width="70"><%=Numeric.numberToStr(total.delivered_tons*1000,0)%>&nbsp;</td>
                <td width="">&nbsp;</td>
              </tr>
</table>
<div id="si_report" style="display:none;"><%@include file="report.parameter.jsp"%></div>			
<table id="si_buttons" width="100%"  border="0" class="style2" cellpadding="0" cellspacing="1">
        <tr>
          <td width="20"><img src="images/new.gif" border="0" width="15" height="15" onClick="new_SI()" style="display:<%=displayed%>"></td>
		  <td align="center"><%@include file="paging.jsp"%></td>
          <td align="right" width="60"><img src="images/report.jpg" width="55" height="18" onClick="doReport('si','(Shipment Date)');"></td>
		  <td align="right" width="60"><img id="bt_card_view" src="images/cardview.jpg" width="55" onClick="doCardView();"></td>
        </tr>
</table>
	  
	<input type="hidden" name="inst_id"  id="inst_id"  value="0">
	<input type="hidden" name="contract_id"  id="contract_id"  value="0">

