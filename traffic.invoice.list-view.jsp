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

function rowClick(row,contract_id,invoice_id)
{
	highlightOn(row);
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	if (invoice_id != null) {
		setValue("invoice_id",inst_id);
	}
}

function rowDblClick(row,contract_id,invoice_id)
{
	rowClick(row,contract_id,invoice_id);
	doCardView();
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('iv');
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
		<th width="100">Type</th>
		<th width="100">Status</th>
		<th width="120">Contract Ref</th>
		<th width="150">Buyer</th>
		<th width="150">Forwarder</th>
		<th width="180">Destination</th>
		<th width="100">Quality</th>
		<th width="">Grade</th>			
		<th width="120">Invoice Month</th>
	</tr>
<tr>
    <td><select name="type" id="type" size=7 class="style11" style="width:100%;" onChange="doPost();">
		<option value="P" <%=sc.type=='P'?"selected":""%>>Provisional</option>
		<option value="S" <%=sc.type=='S'?"selected":""%>>Pre-Shipment</option>
		<option value="F" <%=sc.type=='F'?"selected":""%>>Final</option>
	</select></td>
	<td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
	<td><select name="filter_contract_id" id="filter_contract_id" size="7" class="style11" style="width:100%;" onChange="setValue('contract_no',0);itemSelected(this)"><%=Html.selectOptionsX(dao.getSaleContractDao().getList(), sc.filter_contract_id, "All")%></select></td>
	<td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
    <td><select name="filter_forwarder_id" id="filter_forwarder_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getForwarderFilter(),sc.filter_forwarder_id,"All")%></select></td>
    <td><select name="filter_destination_id" id="filter_destination_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPortDao().selectAll(),sc.filter_destination_id,"All")%></select></td>
	<td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.filter_quality_id, "All")%></select></td>
    <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getShippingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
    <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(task.getSalesInvoiceDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
</tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr align="center" bgcolor="#EEEEEE">
                <td width="42" rowspan="2" onClick="doPost();"><img src="../shared/images/refresh.gif"></td>
                <th width="110" rowspan="2">Invoice Ref</th>
                <th width="110" rowspan="2">Sales Ref</th>
                <th width="120"  rowspan="2">Buyer</th>
                <th width="120"  rowspan="2">Forwarder</th>
                <th width="120"  rowspan="2">Destination</th>
                <th width="150" rowspan="2">Grade</th>
                <th width="100" rowspan="2">Packing</th>
                <th width="60" rowspan="2">Invoice<br>Date</th>
                <th width="60" rowspan="2">Price</th>
                <th colspan="2">Quantity</th>
                <th colspan="2">Amount</th>
                <th width="" rowspan="2">&nbsp;</th>
              </tr>
              <tr align="center" bgcolor="#EEEEEE">
                <th width="60">Bags</th>
                <th width="70">Mts</th>
                <th width="70">USD</th>
                <th width="80">UGX</th>
              </tr>
</table>
<div id="iv_list_view" style="overflow:scroll; height:250px; width:100%">		  
			  <table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<SaleInvoiceEntity> ivs = task.getSalesInvoiceDao().getPaging().paging();
	SaleInvoiceEntity total = (SaleInvoiceEntity)task.getSalesInvoiceDao().getPaging().sumary();
	for (int i = 0; i < ivs.size(); i++) {
		SaleInvoiceEntity iv = ivs.get(i);
		SaleContractEntity ct = iv.getContract();
		ShippingEntity si = iv.getShipping();
		String color = Action.getColor(ct.status);
%>				
                <tr onClick="rowClick(this,<%=iv.contract_id%>,<%=iv.getIdLong()%>)" onDblClick="rowDblClick(this,<%=iv.contract_id%>,<%=iv.getIdLong()%>)">
                  <th width="42" align="right" bgcolor="#EEEEEE"><%=iv.getIdLong()%>&nbsp;</th>
                  <td width="110"><%=iv.getShortRef()%></td>
                  <td width="110" style="color:<%=color%>"><%=ct.getRefNumber()%></td>
                  <td width="120"><%=ct.getBuyer().short_name%></td>
                  <td width="120"><%=ct.getForwarder().short_name%></td>
                  <td width="120"><%=ct.getDestination().short_name%></td>
                  <td width="150"><%=si.getGrade().short_name%></td>
                  <td width="100"><%=si.getPacking().short_name%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(iv.invoice_date)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(iv.price_usd,2)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(iv.no_of_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(iv.net_weight/1000,2)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(iv.amount_usd,2)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(iv.amount_local,0)%>&nbsp;</td>
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
                <td width="70"><%//=Numeric.numberToStr(total.allocated_bags,0)%>&nbsp;</td>
                <td width="70"><%//=Numeric.numberToStr(total.allocated_tons,0)%>&nbsp;</td>
                <td width="70"><%//=Numeric.numberToStr(total.delivered_bags,0)%>&nbsp;</td>
                <td width="70"><%//=Numeric.numberToStr(total.delivered_tons*1000,0)%>&nbsp;</td>
                <td width="">&nbsp;</td>
              </tr>
</table>
<div id="iv_report" style="display:none;"><%@include file="report.parameter.jsp"%></div>			
<table id="iv_buttons" width="100%"  border="0" class="style2" cellpadding="0" cellspacing="1">
        <tr>
		  <td align="center"><%@include file="paging.jsp"%></td>
          <td align="center" width="60"><img src="images/report.jpg" onClick="doReport('iv','(Invoice Date)');"></td>
		  <td align="center" width="60"><img id="bt_card_view" src="images/cardview.jpg" onClick="doCardView();"></td>
        </tr>
</table>
	  
<input type="hidden" name="contract_id"  id="contract_id"  value="0">
<input type="hidden" name="invoice_id"  id="invoice_id"  value="0">
