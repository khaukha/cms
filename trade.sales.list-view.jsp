
<%
	task.doTask(null);
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function report()
{
	show("date_type_");
	doReport('sales','');
}

function ctClicked(row,contract_id)
{
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	highlightOn(row);
}

function new_Contract()
{
	setValue("contract_id", -1);
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('sales');
}

function salesConfirmation()
{
	if (getValue("filter_buyer_id") == 0) {
		alert("Please select a buyer.");
		return;
	}
	doReport('sales','(Contract Date)', 9);
}
</script>
<form method="POST" name="formMain" action="" onSubmit="">			
<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr>
				<td><img src="images/sales-contract.jpg"></td>
				<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#DDDDDD" align="center">
            <th width="100px">Status</th>
            <th width="120px">Type</th>
            <th width="100px">Fixation</th>
            <th width="180px">Buyer</th>
            <th width="100px">Quality</th>
            <th>Grade</th>
            <th width="100px">Term. Month</th>
            <th width="100px">Last Date</th>
          </tr>
			<tr>
			  <td ><select name="filter_status" size="7" id="filter_status" class="style11" style="width:100" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
			  	<td><select name="filter_contract_type" id="filter_contract_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getContractTypeDao().getSalesTypeList(),sc.filter_contract_type,"All")%></select></td>
			  <td><%@include file="inc/filter.fixation.jsp"%></td>
			  <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
             <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="setValue('filter_grade_id',0);doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_terminal_month" id="filter_terminal_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getSaleContractDao().getTerminalMonthFilter(),sc.filter_terminal_month,"All")%></select></td>
             <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getSaleContractDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
          </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#DDDDDD">
              <td width="42"  rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></td>
              <th width="90"  rowspan="2" onClick="">Contract Ref</th>
              <th width="90" rowspan="2" onClick="">Buyer</th>
              <th width="90"  rowspan="2">BR S.No.</th>
              <th width="60"  rowspan="2">BR P.No. </th>
              <th width="50"  rowspan="2">T.Mth</th>
              <th width="65"  rowspan="2">Date</th>
              <th width="180" rowspan="2">Grade</th>
              <th width="90" rowspan="2">Packing</th>
              <th colspan="2">Shipping Period</th>
              <th colspan="3">Tons</th>
              <th colspan="2">Fixation Lots </th>
              <td width="16" rowspan="2">&nbsp;</td>
              <td width="" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#DDDDDD">
              <td width="70" onClick="">First Date </td>
              <td width="70" onClick="">Last Date </td>
              <th width="70">Total</th>
              <th width="70">Shipped</th>
              <th width="70">Balance</th>
              <th width="60">Fixed</th>
              <th width="60">Unfixed</th>
            </tr>
</table>

<div id="sales_list_view" style="overflow:scroll; height:250px; width:100%"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<SaleContractEntity> cts = dao.getSaleContractDao().getPaging().paging();
	SaleContractEntity sum = dao.getSaleContractDao().getPaging().sumary();
	for (int i = 0; i < cts.size(); i++) {
		SaleContractEntity ct = cts.get(i);
		ct.open_tons = ct.getOpenTons();
		if (ct.isCancelled()) {
			ct.tons = 0;
			ct.open_tons = 0;
			ct.fixed_lots = 0;
		}
		//sum.add(ct);
		String color = Action.getColor(ct.status);
%>				
                <tr onClick="ctClicked(this,<%=ct.getIdLong()%>)" onDblClick="setValue('view',1);doTask();" title="<%=ct.description%>">
                  <td width="42" align="right" bgcolor="#DDDDDD"><%=ct.getIdLong()%>&nbsp;</td>
                  <td width="90" style="color:<%=color%>"><%=ct.getRefNumber()%></td>
                  <td width="90"><%=ct.getBuyer().short_name%></td>
                  <td width="90"><%=ct.bric_ref%></td>
                  <td width="60"><%=ct.buyer_ref%></td>
                  <td width="50" align="center"><%=DateTime.dateToTerminalMonth(ct.terminal_month)%></td>
                  <td width="65" align="center"><%=DateTime.dateToStr(ct.contract_date)%></td>
                  <td width="180"><%=ct.getGrade().short_name%></td>
                  <td width="90"><%=ct.getPacking().short_name%> (<%=ct.no_of_bags%>)</td>
                  <td width="70" align="center"><%=DateTime.dateToStr(ct.first_date)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(ct.last_date)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.delivered_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.open_tons,3)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(ct.fixed_lots,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(ct.unfixed_lots,0)%>&nbsp;</td>
				  <td width="16" align="center"><%=ct.contract_type%></td>
				  <td>&nbsp;</td>
      </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#DDDDDD">
				  <td width="42">&nbsp;</td>
                  <th width="864" align="center">Total</th>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.tons,3)%></strong>&nbsp;</td>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.delivered_tons,3)%></strong>&nbsp;</td>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.open_tons,3)%></strong>&nbsp;</td>
                  <td width="60"><strong><%=Numeric.numberToStr(sum.fixed_lots,0)%></strong>&nbsp;</td>
                  <td width="60"><strong><%=Numeric.numberToStr(sum.unfixed_lots,0)%></strong>&nbsp;</td>
                  <td width="16">&nbsp;</td>
                  <td width="">&nbsp;</td>
                </tr>
</table>

<div id="sales_report" style="display:none;"><%@include file="report.parameter.jsp"%></div>

<table id="sales_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr>
            <td width="20"><img src="../shared/images/new.gif" style="display:<%=displayed%>" onClick="new_Contract();"></td>
            <td align="center"><%@include file="paging.jsp"%></td>			
            <td width="120" align="right"><a href="JavaScript:salesConfirmation()" style="display:">Sales Confirmation</a> &nbsp;</td>
			<td width="60" align="right"><img src="images/report.jpg" width="55" height="18" onClick="report();"></td>
            <td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>

	<input type="hidden" name="contract_id"  id="contract_id"  value="0">
	
</form>