<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function biClicked(row)
{
	highlightOn(row);
}

function sfDblClicked(row, sf_id)
{
	if (sf_id != null) {
		//setValue("sf_id",sf_id);
	}
	doCardView();
}

function doGenerateReport()
{
	//hide('stuffing_date_filter');
	//doReport('sf','(Shipment Date)');
	doTask(4);
}

function cancelGenerateReport()
{
	show("stuffing_date_filter");
	cancelReport("sf");
}

</script>
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD">
		<th width="80">Month</th>
		<th width="94">Stuffing From</th>
		<th width="94">To</th>
		<th width="60">&nbsp;</th>
		<th>&nbsp;</th>
	</tr>
	<tr>
	  <td><select name="month_end" id="month_end" size=1 class="style11" style="width:100%;" onChange="doPost();" ><%=Html.selectOptions(dao.getShippingFeeDao().getMonthFilter(),sc.month_end,"All")%></select></td>
	  <td><%=Html.datePicker("stuffing_date_from",requester.getDate("stuffing_date_from"),"style11")%></td>
	  <td><%=Html.datePicker("stuffing_date_to",requester.getDate("stuffing_date_to"),"style11")%></td>
	  <td align="center"><a href="JavaScript:doPost()">Submit</a></td>
	  <td align="right"><%@include file="search.jsp"%></td>
  </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr align="center" bgcolor="#DDDDDD">
		<td width="42"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></td>
		<th width="90">SI Ref.</th>
		 <th width="40">Month</th>
		<th width="50">Bill</th>
		<th width="50">Seal</th>
		<th width="60">THC</th>
		<th width="60">Phyto</th>
		<th width="60">Phyto<br />Reg.</th>
		<th width="60">Trans.</th>
		<th width="60">LOLO</th>
		<th width="60">Fumi.</th>
		<th width="50">Docs</th>
		<th width="60">Dri<br />Bags</th>
		<th width="60">Kraft<br />Paper</th>
		<th width="60">Lining<br />K.Paper</th>
		<th width="50">Custom</th>
		<th width="60">Vicofa</th>
		<th width="60">Custom<br />Service</th>
		<th width="60">Bags</th>
		<th width="60">Pallets</th>
		<th width="50">Marks</th>
		<th width="">&nbsp;</th>
		</tr>
</table>
<div id="sf_list_view" style="overflow:scroll; height:300px; width:100%;">		  
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<ShippingEntity> sis = task.getShippings();
	ShippingFeeEntity sum = dao.getShippingFeeDao().newEntity();
	for (int i = 0; i < sis.size(); i++) {
		ShippingEntity si = sis.get(i);
		ShippingFeeEntity fee = si.getShippingFee();
		sum.add(fee);
		String bgcolor = i%2==1?"":"#CCFFFF";
%>				
                <tr onClick="biClicked(this)" onDblClick="sfDblClicked(this,<%=fee.getIdLong()%>)" bgcolor="<%=bgcolor%>" style=" padding-bottom:1">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=si.getIdLong()%>&nbsp;</th>
                  <td width="90"><a href="JavaScript:viewSI(<%=si.getIdLong()%>)"><%=si.getShortRef()%></a></td>
                  <td width="40" align="center"><%=DateTime.dateToTerminalMonth(fee.month_end)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(fee.bill_fee_local,_dec)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(fee.seal_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.thc_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.phyto_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.phyto_reg_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.trans_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.lolo_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.fumi_fee_local,_dec)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(fee.docs_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.dri_bags_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.kraft_paper_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.lining_kraft_fee_local,_dec)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(fee.custom_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.vicofa_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.custom_service_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.bags_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(fee.pallets_fee_local,_dec)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(fee.marking_fee_local,_dec)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" style="font-weight:bold;"  align="right">
		<td width="42" bgcolor="#DDDDDD">&nbsp;</td>
		<td width="90" align="center">Total</td>
		<td width="40">&nbsp;</td>
                  <td width="50" align="right"><%=Numeric.numberToStr(sum.bill_fee_local,_dec)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(sum.seal_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.thc_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.phyto_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.phyto_reg_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.trans_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.lolo_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.fumi_fee_local,_dec)%></td>
                  <td width="50" align="right"><%=Numeric.numberToStr(sum.docs_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.dri_bags_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.kraft_paper_fee_local,_dec)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(sum.lining_kraft_fee_local,_dec)%></td>
                <td width="50"><%=Numeric.numberToStr(sum.custom_fee_local,_dec)%></td>
                <td width="60"><%=Numeric.numberToStr(sum.vicofa_fee_local,_dec)%></td>
                <td width="60"><%=Numeric.numberToStr(sum.custom_service_fee_local,_dec)%></td>
                <td width="60"><%=Numeric.numberToStr(sum.bags_fee_local,_dec)%></td>
                <td width="60"><%=Numeric.numberToStr(sum.pallets_fee_local,_dec)%></td>
                <td width="50"><%=Numeric.numberToStr(sum.marking_fee_local,_dec)%></td>
                <td width="">&nbsp;</td>
              </tr>
</table>
<table width="100%"  border="0" class="style11">
	<tr>
		<td>&nbsp;</td>
		  <td align="right">From Month &nbsp;&nbsp;</td>
  	      <td width="60"><select name="from_month" id="from_month" class="style11" style="width:100%;"><%=Html.selectOptions(Html.months,requester.getInt("from_month",DateTime.getCurMonth()))%></select></td>
	      <td width="60"><select name="from_year" id="from_year" class="style11" style="width:100%;"><%=Html.selectOptions(Html.years,requester.getInt("from_year",DateTime.getCurYear()))%></select></td>
		  <td width="30" align="center">To</td>
	  	  <td width="60"><select name="month" id="month" class="style11" style="width:100%;" onchange=""><%=Html.selectOptions(Html.months,requester.getInt("month",DateTime.getCurMonth()))%></select></td>
	  	  <td width="60"><select name="year" id="year" class="style11" style="width:100%;" onchange=""><%=Html.selectOptions(Html.years,requester.getInt("year",DateTime.getCurYear()))%></select></td>
          <td align="center" width="60"><img src="images/report.jpg"onClick="doTask(4);"></td>
		  <td align="center" width="60"><img id="bt_card_view" src="images/cardview.jpg" onClick="doCardView();"></td>
	</tr>
</table>			


