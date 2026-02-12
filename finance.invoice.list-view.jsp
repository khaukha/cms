<%
	task.doTask(null);
	sc.contract_type = ' ';
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function ivClicked(row,invoice_id)
{
	if (invoice_id != null) {
		setValue("invoice_id",invoice_id);
	}
	highlightOn(row);
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('invoice');
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#EEEEEE"c>
            <th width="120px">Status</th>
            <th width="180px">Buyer</th>
			<th width="120px">Quality</th>
            <th width="">Grade</th>
            <th width="120px">Term. Month</th>
            <th width="120px">Last Date</th>
          </tr>
			<tr>
			  <td><%@include file="inc/filter.status.jsp"%></td>
			  <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
             <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getShippingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_terminal_month" id="filter_terminal_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getSaleContractDao().getTerminalMonthFilter(),sc.filter_terminal_month,"All")%></select></td>
             <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getSaleContractDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
          </tr>
</table>

<div id="invoice_list_view">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#DDDDDD">
              <td width="42"  rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif" style="cursor:pointer"></td>
              <th width="100"  rowspan="2">Invoice Ref.</th>
              <th width="90"  rowspan="2">Contract Ref. </th>
              <th width="80" rowspan="2">Buyer</th>
              <th width="60"  rowspan="2">T.Mth</th>
              <th width="60"  rowspan="2">Invoice Date</th>
              <th width="60"  rowspan="2">B/L Date</th>
              <th width="150" rowspan="2">Grade</th>
              <th width="50" rowspan="2">Bags</th>
              <th width="70" rowspan="2">Tons</th>
              <th width="60" rowspan="2"> Price<br />USD</th>
              <th colspan="3">Amount</th>
              <td width="" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#DDDDDD">
              <th width="90">USD</th>
              <th width="60">Ex.Rate</th>
              <th width="100"><%=location.currency%></th>
            </tr>
  </table>

<div id="invoice_list_view" style="overflow:scroll; height:250px; width:100%; display:">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<FinalInvoiceEntity> invoices =  dao.getFinalInvoiceDao().getPaging().paging();
	FinalInvoiceEntity sum = dao.getFinalInvoiceDao().getPaging().sumary();	
	for (int i = 0; i < invoices.size(); i++) {
		FinalInvoiceEntity invoice = invoices.get(i);
		WnExportEntity wn = invoice.getWnExport();
		ShippingEntity shipping = wn.getShipping();
		SaleContractEntity contract = shipping.getContract();
		String color = Action.getColor(invoice.status);
%>				
                <tr onClick="ivClicked(this,<%=invoice.getIdLong()%>)" onDblClick="setValue('view',1);doTask();">
                  <th width="42" align="right" bgcolor="#EEEEEE"><%=invoice.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=color%>"><%=invoice.getShortRef()%></td>
                  <td width="90"><%=contract.getRefNumber()%></td>
                  <td width="80"><%=contract.getBuyer().short_name%></td>
                  <td width="60" align="center"><%=DateTime.dateToTerminalMonth(contract.terminal_month)%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(invoice.invoice_date)%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(shipping.bill_of_lading_date)%></td>
                  <td width="150"><%=contract.getGrade().short_name%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(invoice.no_of_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(invoice.net_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(invoice.price_usd,2)%>&nbsp;</td>
                  <td width="90" align="right"><%=Numeric.numberToStr(invoice.amount_usd,2)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(invoice.exchange_rate,0)%>&nbsp;</td>
                  <td width="100" align="right"><%=Numeric.numberToStr(invoice.amount_local,0)%>&nbsp;</td>
				  <td>&nbsp;</td>
      </tr>
<%
	}
%>				
</table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#EEEEEE" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
                  <td width="832" align="center">Total</td>
                  <td width="90" align="right"><%=Numeric.numberToStr(sum.amount_usd,2)%>&nbsp;</td>
                  <td width="60" align="right">&nbsp;</td>
                  <td width="100" align="right"><%=Numeric.numberToStr(sum.amount_local,0)%>&nbsp;</td>
                  <td width="">&nbsp;</td>
                </tr>
</table>

</div>	  

<div id="invoice_report" style="display:none"><%@include file="report.parameter.jsp"%></div>

<table id="invoice_buttons"  width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><%@include file="paging.jsp"%></td>
			<td width="60" align="center"><img src="images/report.jpg" onClick="doTask(4);//doReport('invoice');"></td>
            <td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
		
<input type="hidden" name="invoice_id"  id="invoice_id"  value="0">
	
