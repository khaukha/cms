<%
	task.doTask(null);
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript" type="text/javascript">

getObj("main_window").width = "";

function report()
{
	show("date_type_");
	show("all_location_");
	doReport("purchase","");
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
	cancelReport('purchase');
}

</script>
<form method="POST" name="formMain" action="" onSubmit="">
<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr>
				<td><img src="images/purchase-offer.jpg"></td>
				<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#EEEEEE" align="center">
            <th width="100px">Status</th>
            <th width="100px">Type</th>
            <th width="100px">Fixation</th>
            <th width="150px">Supplier</th>
			<th width="100px">Quality</th>
            <th>Grade</th>
            <th width="100px">Term.Month</th>
            <th width="100px">Last Date</th>
		  </tr>
			<tr>
			  <td><select name="filter_status" size="7" id="filter_status" class="style11" style="width:100" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
			  <td><select name="filter_contract_type" id="filter_contract_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getContractTypeDao().getPurchaseTypeFilter(),sc.filter_contract_type,"All")%></select></td>
			  <td><%@include file="inc/filter.fixation.jsp"%></td>
			  <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
             <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="setValue('filter_grade_id',0);doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_terminal_month" id="filter_terminal_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getPurchaseContractDao().getTerminalMonthFilter(),sc.filter_terminal_month,"All")%></select></td>
             <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getPurchaseContractDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
		  </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#DDDDDD">
              <td width="42"  rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></td>
              <th width="90"  rowspan="2">Purchase Ref</th>
              <th width="150" rowspan="2">Supplier</th>
              <th width="60"  rowspan="2">T.Mth</th>
              <th width="65"  rowspan="2">Date</th>
              <th width="180" rowspan="2">Grade</th>
              <th width="100" rowspan="2">Destination</th>
              <th width="70" rowspan="2">Last Date </th>
              <th colspan="3">Tons</th>
              <th colspan="2">Fixation Tons </th>
              <td width="16" rowspan="2">&nbsp;</td>
              <td width="" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#DDDDDD">
              <th width="70">Total</th>
              <th width="70">Delivered</th>
              <th width="70">Balance</th>
              <th width="70">Fixed</th>
              <th width="70">Unfixed</th>
            </tr>
</table>

<div id="purchase_list_view" style="overflow:scroll; height:250px; width:100%"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<PurchaseContractEntity> cts = dao.getPurchaseContractDao().getPaging().paging();
	PurchaseContractEntity sum = dao.getPurchaseContractDao().getPaging().sumary();
	for (int i = 0; i < cts.size(); i++) {
		PurchaseContractEntity ct = cts.get(i);
		ct.open_tons = ct.getOpenTons();
		if (ct.isCancelled()) {
			ct.tons = 0;
			ct.open_tons = 0;
			ct.fixed_lots = 0;
		}
		String color = Action.getColor(ct.status);
%>				
                <tr onClick="ctClicked(this,<%=ct.getIdLong()%>)" onDblClick="setValue('view',1);doTask();">
                  <td width="42" align="right" bgcolor="#DDDDDD"><%=ct.getIdLong()%>&nbsp;</td>
                  <td width="90" style="color:<%=color%>"><%=ct.getRefNumber()%></td>
                  <td width="150"><%=ct.getSeller().short_name%></td>
                  <td width="60" align="center"><%=DateTime.dateToTerminalMonth(ct.terminal_month)%></td>
                  <td width="65" align="center"><%=DateTime.dateToStr(ct.contract_date)%></td>
                  <td width="180"><%=ct.getGrade().short_name%></td>
                  <td width="100"><%=ct.getDestination().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(ct.last_date)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.delivered_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.open_tons,3)%>&nbsp;</td>
                  <td width="70" align="center"><%=Numeric.numberToStr(ct.fixed_tons, 3)%>&nbsp;</td>
                  <td width="70" align="center"><%=Numeric.numberToStr(ct.unfixed_tons,3)%>&nbsp;</td>
				  <td width="16" align="center"><%=ct.contract_type%></td>
				  <td>&nbsp;</td>
      </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#DDDDDD" style="cursor:pointer" title=''>
                  <th width="42" align="center">&nbsp;</th>
                  <th width="721" align="center">Total</th>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.tons,3)%></strong>&nbsp;</td>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.delivered_tons,3)%></strong>&nbsp;</td>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.open_tons,3)%></strong>&nbsp;</td>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.fixed_tons,3)%></strong>&nbsp;</td>
                  <td width="70"><strong><%=Numeric.numberToStr(sum.unfixed_tons,3)%></strong>&nbsp;</td>
                  <td width="16">&nbsp;</td>
                  <td width="">&nbsp;</td>
                </tr>
</table>	  

<div id="purchase_report" style="display:none;"><%@include file="report.parameter.jsp"%></div>

<table id="purchase_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20"><img src="../shared/images/new.gif" width="15" height="15" onClick="new_Contract();" style="display:<%=displayed%>"></td>
            <td align="center"><%@include file="paging.jsp"%></td>
			<td width="60" align="center"><img src="images/report.jpg" onClick="report();"></td>
            <td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
		
<input type="hidden" name="contract_id"  id="contract_id"  value="0">
	
</form>
