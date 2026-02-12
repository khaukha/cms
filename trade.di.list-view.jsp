<%
	task.doListView();		
%>

<script language="javascript">
getObj("main_window").width = "";

function doCardView()
{
	setValue("view",1);
	doPost();
}

function diClicked(row)
{
	highlightOn(row);
}

function diDblClicked(row,contract_id,inst_id)
{
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	if (inst_id != null) {
		setValue("inst_id",inst_id);
	}	
	doCardView()
}

function new_DI()
{
	var name = "Delivery Instruction";
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
	cancelReport('di');
}

</script>

<form method="POST" name="formMain" action="" onSubmit="">			
<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr>
			<td><img src="images/delivery-instruction.jpg"></td>
			<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
      <tr bgcolor="#DDDDDD" align="center">
        <th width="120">Status</th>
            <th width="120">Warehouse</th>
            <th width="150">Contract Ref</th>
            <th width="180">Seller</th>
            <th width="120">Quality</th>
            <th>Grade</th>			
            <th width="120">Delivery Month</th>
    </tr>
      <tr>
	    <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
    	<td><select name="filter_warehouse_id" id="filter_warehouse_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptionsX(dao.getWarehouseDao().selectAll(),sc.filter_warehouse_id,"All")%></select></td>
        <td><select name="filter_contract_id" id="filter_contract_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(dao.getPurchaseContractDao().list(),sc.filter_contract_id,"All")%></select></td>
        <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
        <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
        <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
        <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getDeliveryDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
    </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr align="center" bgcolor="#DDDDDD" >
            <th width="42" onClick="doPost();"><img src="../shared/images/refresh.gif"></th>
            <th width="120">DI Ref</th>
            <th width="200">Supplier</th>
            <th width="150">Destination</th>
            <th width="180">Grade</th>
            <th width="100">Packing</th>
			<th width="70">Proposed<br />Date</th>
            <th width="80">Delivered<br />Tons</th>
            <th width="70">Delivered Date</th>
            <th width="">&nbsp;</th>
          </tr>
</table>

<div id="di_list_view" style="overflow:scroll; height:250px; width:100%;"><table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
<%
    sc.setFilterMonth();
	List<DeliveryEntity> dis = dao.getDeliveryDao().getPaging().paging();
	DeliveryEntity sum = dao.getDeliveryDao().getPaging().sumary();
	for (int i = 0; i < dis.size(); i++) {
		DeliveryEntity di = dis.get(i);
		String color = Action.getColor(di.status);
%>				
                <tr onClick="diClicked(this,<%=di.contract_id%>,<%=di.getIdLong()%>)" onDblClick="diDblClicked(this,<%=di.contract_id%>,<%=di.getIdLong()%>)">
                  <th width="42" bgcolor="#DDDDDD"  align="right"><%=di.getIdLong()%>&nbsp;</th>
                  <td width="120" style="color:<%=color%>"><%=di.getRefNumber()%></td>
                  <td width="200"><%=di.getContract().getSeller().short_name%></td>
                  <td width="150"><%=di.getWarehouse().short_name%></td>
                  <td width="180"><%=di.getGrade().short_name%></td>
                  <td width="100"><%=di.getPacking().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(di.proposed_date)%></td>
                  <td width="80" align="right"><%=Numeric.numberToStr(di.delivered_tons)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(di.delivery_date)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table></div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#DDDDDD">
            <th width="868" align="center">Total</th>
            <th width="80" align="right"><%=Numeric.numberToStr(sum.delivered_tons,3)%>&nbsp;</th>
            <th width="70">&nbsp;</th>
			<th width="">&nbsp;</th>
          </tr>
</table>
<div id="di_report" style="display:none"><%@include file="report.parameter.jsp"%></div>						
<table id="di_buttons" width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td width="20"><img src="images/new.gif" border="0" onClick="new_DI()" style="display:<%=displayed%>"></td>
		<td align="center">&nbsp;<%@include file="paging.jsp"%></td>
        <td align="center" width="60"><img src="images/report.jpg" onClick="doReport('di');"></td>
		<td align="center" width="60"><img src="images/cardview.jpg" onClick="doCardView();"></td>
      </tr>
</table>
	
<input type="hidden" name="inst_id"  id="inst_id"  value="0">
<input type="hidden" name="contract_id"  id="contract_id"  value="0">

</form>