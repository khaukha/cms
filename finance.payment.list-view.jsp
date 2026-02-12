<%
	 task.doTask();	
	 if (sc.filter_month == null) sc.filter_month = "";
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function pmClicked(row,finance_id,contract_id)
{
	highlightOn(row);
	if (finance_id != null) {
		setValue("finance_id",finance_id);
		setValue("contract_id",contract_id);
	}
}

function pmDblClicked(row,finance_id,contract_id)
{
	pmClicked(row,finance_id,contract_id);
	setValue("view",1);
	doPost();
}

function pmReport()
{
	show("date_type_");
	show("all_location_");
	doReport("payment","");
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport("payment");
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#DDDDDD">
            <th width="130">Purchase Ref. </th>
            <th width="">Seller</th>
			<th width="">Grade</th>
            <th width="120">Payment Month </th>
          </tr>
			<tr>
			  <td><select name="contract_id" id="contract_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(dao.getPurchaseContractDao().list(),sc.contract_id,"All")%></select></td>
			  <td valign="top"><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
             <td valign="top"><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td valign="top"><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getFinanceDao().getMonthFilter(),sc.filter_month,"All")%></select></td>
          </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#EEEEEE">
              <td width="42" onClick="doPost()"><img src="../shared/images/refresh.gif" style="cursor:pointer"></td>
              <th width="100">Payment Letter</th>
              <th width="100">Contract Ref</th>
              <th width="120">Seller</th>
              <th width="150">Grade</th>
              <th width="120">Acc. Ref</th>
              <th width="70">Payment Date</th>
              <th width="70">Delivered<br />Kgs</th>
              <th width="70">Paid<br />Kgs</th>
              <th width="90">Amount <%=location.currency%></th>
              <td width="">&nbsp;</td>
            </tr>
</table>
<div id="payment_list_view" style="overflow:scroll; height:250px; width:100%">		  
			  <table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterMonth();
	List<FinanceEntity> fis = dao.getFinanceDao().getPaging().paging();
	FinanceEntity sum = dao.getFinanceDao().getPaging().sumary();
	for (int i = 0; i < fis.size(); i++) {
		FinanceEntity fi = fis.get(i);
		PurchaseContractEntity ct = fi.getContract();
		String color = Action.getColor(fi.status);
%>				
                <tr onClick="pmClicked(this,<%=fi.getIdLong()%>,<%=ct.getIdLong()%>)" onDblClick="pmDblClicked(this,<%=fi.getIdLong()%>,<%=ct.getIdLong()%>)">
                  <th width="42" align="right" bgcolor="#EEEEEE"><%=fi.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=color%>"><%=fi.getShortRef()%></td>
                  <td width="100"><%=fi.getLetter().getPayment().getShortRef()%></td>
                  <td width="120"><%=ct.getSeller().short_name%></td>
                  <td width="150"><%=ct.getGrade().short_name%></td>
                  <td width="120"><%=fi.payment_ref%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(fi.payment_date)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(fi.getLetter().getDeliveredTons()*1000,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(fi.getLetter().getPaymentTons()*1000,0)%>&nbsp;</td>
                  <td width="90" align="right"><%=Numeric.numberToStr(fi.amount_local,0)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>		 
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#EEEEEE" style="font-weight:bold" >
                  <td width="708" align="center">Total</td>
                  <td width="80" align="right"></td>
                  <td width="60">&nbsp;</td>
                  <td width="90" align="right"><%=Numeric.numberToStr(sum.amount_local,0)%>&nbsp;</td>
                  <td width="">&nbsp;</td>
                </tr>
</table> 	  
<div id="payment_report" style="display:none"><%@include file="finance.payment.report.parameter.jsp"%></div>
<table id="payment_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><%@include file="paging.jsp"%></td>
			<td width="60" align="center"><img src="images/report.jpg" onClick="pmReport();"></td>
            <td width="60" align="center"><img src="../shared/images/cardview.jpg"onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
<input type="hidden" name="finance_id"  id="finance_id"  value="0">
	

