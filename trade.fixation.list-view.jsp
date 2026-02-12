<%
	ContractDAO ct_dao = task.getContractDao();
	task.doTask();
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

function ctClicked(row,contract_id,contract_type)
{
	if (contract_id != null) {
		//setValue("contract_id",contract_id);
	}
	if (contract_type != null) {
		//setValue("contract_type",contract_type);
	}
	highlightOn(row,0);
}

function ctDblClicked(row,contract_id,contract_type)
{
	if (contract_id != null) {
		setValue("contract_id",contract_id);
	}
	if (contract_type != null) {
		setValue("contract_type",contract_type);
	}
	setValue('view',1);
	doTask();	
}

function report(txt, task_id)
{
	doReport("fixation",txt,task_id);
}

</script>
<form method="POST" name="formMain" action="" onSubmit="">
<%@include file="posted-fields.jsp"%>	

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td><img src="images/fixation.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#EEEEEE">
            <th width="100">Type</th>
			<th width="80">Contract Type</th>
			<th width="80">Fixation</th>
			<th width="180">Grade</th>
			<th width="120">Buyer</th>
            <th>Seller</th>
            <th width="120">Market</th>
            <th width="120">Term. Month</th>
            <th width="120">Fixation Date </th>
		  </tr>
			<tr>
			  <td><%@include file="inc/filter.contract.jsp"%></td>
              <td><%if (sc.type=='P') {%><%@include file="inc/filter.purchase.jsp"%><%} else {%><%@include file="inc/filter.sales.jsp"%><%}%></td>
              <td><%@include file="inc/filter.fixation.jsp"%></td>
              <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(ct_dao.getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
              <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(ct_dao.getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
             <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(ct_dao.getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
             <td><select name="terminal_market_id" id="terminal_market_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().listByTerminalMarket(),sc.terminal_market_id,"All")%></select></td>
            <td><select name="filter_terminal_month" id="filter_terminal_month" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getTerminalMonthFilter(),sc.filter_terminal_month,"All")%></select></td>
            <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getPriceFixationDao(sc.type).selectDateFilter(),sc.filter_date,"All")%></select></td>
		  </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
            <tr align="center" bgcolor="#EEEEEE">
              <td width="42" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></td>
              <th width="90" rowspan="2">Contract Ref.</th>
              <th width="150" rowspan="2">Grade</th>
              <th width="110" rowspan="2"><%=sc.type=='S'?"Buyer":"Seller"%></th>
              <th width="60" rowspan="2">Market</th>
              <th width="70" rowspan="2">Month</th>
              <th width="70" rowspan="2">Diff.</th>
              <th width="70" rowspan="2">Fixation<br />Date</th>
              <th width="70" rowspan="2">Ex.Rate</th>
              <th colspan="2">Avg. Price </th>
              <th colspan="3">Fixation Tons</th>
              <th colspan="2">Fixation Lots </th>
              <td width="" rowspan="2">&nbsp;</td>
            </tr>
            <tr align="center" bgcolor="#EEEEEE">
              <th width="70">USD</th>
              <th width="80"><%=location.currency%></th>
              <th width="70">Delivered</th>
              <th width="70">Fixed</th>
              <th width="70">Unfixed</th>
              <th width="60">Fixed</th>
              <th width="60">Unfixed</th>
            </tr>
</table>
<div id="fixation_list_view" style="overflow:scroll; height:250px; width:100%">		  
	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterDate();
	List<ContractEntity> cts = ct_dao.getPaging().paging();
	ContractEntity sum = (ContractEntity)ct_dao.getPaging().sumary();
	for (int i = 0; i < cts.size(); i++) {
		ContractEntity ct = cts.get(i);
		int status = ct.isFixed() ? 2 : 1;
		String color = Action.getColor(status);
%>				
                <tr onClick="ctClicked(this,<%=ct.getIdLong()%>,'<%=ct.contract_type%>')" onDblClick="ctDblClicked(this,<%=ct.getIdLong()%>,'<%=ct.contract_type%>');">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=ct.getIdLong()%>&nbsp;</th>
                  <td width="90" style="color:<%=color%>"><%=ct.getRefNumber()%></td>
                  <td width="150"><%=ct.getGrade().short_name%></td>				  
                  <td width="110"><%=ct.getType()=='S'?ct.getBuyer().short_name:ct.getSeller().short_name%></td>
                  <td width="60" align="center"><%=ct.getGrade().getQuality().terminal_market%></td>
                  <td width="70" align="center"><%=DateTime.dateToTerminalMonth(ct.terminal_month)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.differential_price,2)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(ct.fixation_date)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.exchange_rate,2)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.contract_price,2)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(ct.contract_price_local,_dec)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.delivered_tons,3)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.fixed_tons)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(ct.unfixed_tons,3)%>&nbsp;</td>
                  <td width="60" align="right"><%=ct.fixed_lots%>&nbsp;</td>
                  <td width="60" align="right"><%=ct.unfixed_lots%>&nbsp;</td>
				  <td>&nbsp;</td>
                </tr>				
<%			
	}
%>				
    </table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#EEEEEE">
                  <th width="892"  align="center">Total</th>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.delivered_tons,3)%></strong>&nbsp;</td>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.fixed_tons,3)%></strong>&nbsp;</td>
                  <td width="70" align="center"><strong><%=Numeric.numberToStr(sum.unfixed_tons,3)%></strong>&nbsp;</td>
                  <td width="60" align="center"><strong><%=Numeric.numberToStr(sum.fixed_lots,0)%></strong>&nbsp;</td>
                  <td width="60" align="center"><strong><%=Numeric.numberToStr(sum.unfixed_lots,0)%></strong>&nbsp;</td>
				  <td width="">&nbsp;</td>
                </tr>
</table>
<div id="fixation_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
<table id="fixation_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr>
            <td width="30px">&nbsp;</td>
			<td align="center"><%@include file="paging.jsp"%></td>
			<td width="80" align="center"><a href="JavaScript:report('(Fixation Date)',4)">Price Fixation</a></td>
            <td width="60" align="center"><img src="../shared/images/report.jpg" onClick="report('(Contract Date)',5)"></td>
            <td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="setValue('view',1);doPost();"></td>
          </tr>
</table>
				  		  	  
<input type="hidden" name="contract_id"  id="contract_id"  value="0">
</form>

