<%
	task.doListView();
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function pmClicked(row)
{
	highlightOn(row);
}

function pmDblClicked(payment_id,contract_id)
{
	if (payment_id != null) {
		setValue("payment_id",payment_id);
		setValue("contract_id",contract_id);
	}
	setValue("view",1);
	doPost();
}

function doGenerateReport()
{
	//doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('payment');
}

</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#EEEEEE" align="center">
            <th width="80">Status</th>
            <th width="80">Fixation</th>
            <th width="100">Type</th>
            <th width="130">Purchase Ref. </th>
            <th width="250">Seller</th>
			<th width="200">Grade</th>
          </tr>
			<tr>
			  <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
			  <td><%@include file="inc/filter.fixation.jsp"%></td>
			  <td><select name="filter_contract_type" id="filter_contract_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getContractTypeDao().getPurchaseTypeList(),sc.filter_contract_type,"All")%></select></td>
        	  <td><select name="filter_contract_id" id="filter_contract_id" size="7" class="style11" style="width:100%;" onChange="itemSelected(this)"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(), sc.filter_contract_id, "All")%></select></td>
			  <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
             <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
          </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#EEEEEE">
              <td width="42"  rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif" class="style3"></td>
              <th width="120"  rowspan="2">Payment Ref</th>
              <th width="120" rowspan="2">Seller</th>
              <th width="150" rowspan="2">Grade</th>
              <th width="60"  rowspan="2">T.Mth</th>
              <th rowspan="2">Grade</th>
              <th width="70" rowspan="2">Delivered<br />Tons</th>
              <th width="40" rowspan="2">Disc.<br />%</th>
              <th width="40" rowspan="2">Disc.<br />Mts</th>
              <th width="40" rowspan="2">Prem.<br />Mts</th>
              <th width="60" rowspan="2">Paid<br />Mts</th>
              <th colspan="2">Amount (<%=location.currency%>)</th>
              <th width="30" rowspan="2">Type</th>
              <td width="" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#EEEEEE">
              <th width="90">Prepaid</th>
              <th width="90">Fixed</th>
              </tr>
</table>
<div id="payment_list_view" style="overflow:scroll; height:250px; width:100%">		  
	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<PaymentEntity> payments = dao.getPaymentDao().getPaging().paging();
	PaymentEntity sum_pm = dao.getPaymentDao().getPaging().sumary();
	AdvanceLetterEntity sum_av = dao.getAdvanceLetterDao().newEntity();
	for (int i = 0; i < payments.size(); i++) {
		PaymentEntity payment = payments.get(i);
		PurchaseContractEntity contract = payment.getContract();
		String color = Action.getColor(payment.status);
%>				
                <tr onClick="pmClicked(this)" onDblClick="pmDblClicked(<%=payment.getIdLong()%>,<%=payment.getContract().getIdLong()%>)">
                  <th width="42" align="right" bgcolor="#EEEEEE"><%=payment.getIdLong()%>&nbsp;</th>
                  <td width="120" style="color:<%=color%>"><%=payment.getRefNumber()%></td>
                  <td width="120"><%=contract.getSeller().short_name%></td>
                  <td width="150"><%=contract.getGrade().short_name%></td>
                  <td width="60" align="center"><%=DateTime.dateToTerminalMonth(contract.terminal_month)%></td>
                  <td><%=contract.getGrade().short_name%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(payment.tons)%>&nbsp;</td>
                  <td width="40" align="right"><%=Numeric.numberToStr(payment.discount_quality,2)%>&nbsp;</td>
                  <td width="40" align="right"><%=Numeric.numberToStr(payment.discount_tons,4)%>&nbsp;</td>
                  <td width="40" align="right"><%=Numeric.numberToStr(payment.premium_tons,4)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(payment.getPaymentTons(),4)%>&nbsp;</td>
                  <td width="90" align="right"><%//=Numeric.numberToStr(payment.advance_amount_local,0)%>&nbsp;</td>
                  <td width="90" align="right"><%//=Numeric.numberToStr(payment.getAmountLocal(),0)%>&nbsp;</td>
				  <td width="30" align="center"><%=contract.contract_type%></td>
				  <td>&nbsp;</td>
                  </tr>
<%
	}
%>				
          </table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#EEEEEE">
                  <th width="804" align="center">Total</th>
                  <td width="90" align="right"><strong><%=Numeric.numberToStr(sum_av.amount_local,_dec)%></strong>&nbsp;</td>
                  <td width="90" align="right"><strong><%//=Numeric.numberToStr(sum_pm.getAmountLocal(),0)%></strong>&nbsp;</td>
                  <td width="30">&nbsp;</td>
                  <td width="">&nbsp;</td>
                </tr>
</table>
<div id="payment_report" style="display:none"><%@include file="report.parameter.jsp"%></div>		
<table width="100%" id="payment_buttons" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center"><%@include file="paging.jsp"%></td>
			<td width="60" align="center" style="display:none"><img src="images/report.jpg" onClick="doReport('payment');"></td>
            <td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
		  		  	  
<input type="hidden" name="payment_id"  id="payment_id"  value="0">
<input type="hidden" name="contract_id"  id="contract_id"  value="0">
	


