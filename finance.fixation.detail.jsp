<div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" align="right">
		<th width="120" align="center">Contract</th>
		<th width="80" align="center">Date</th>
		<th width="60">Volume</th>
		<th width="60">Hedge</th>
		<th width="60">Diff.</th>
		<th width="60">Price</th>
		<th align="left">&nbsp;&nbsp;Supplier</th>
		<th align="left">Grade</th>
	</tr>
	<tr>
		<th><%=contract.getRefNumber()%></th>
		<td align="center"><%=DateTime.dateToStr(contract.contract_date)%></td>
		<td align="right"><%=Numeric.numberToStr(contract.delivered_tons)%></td>
		<td align="right"><%=Numeric.numberToStr(contract.hedge_price,2)%></td>
		<td align="right"><%=Numeric.numberToStr(contract.differential_price,2)%></td>
		<td align="right"><%=Numeric.numberToStr(contract.contract_price,2)%></td>
		<td>&nbsp;&nbsp;<%=contract.getSeller().short_name%></td>
		<td><%=contract.getGrade().short_name%></td>
	</tr>
</table>
</div>

<div style="border:thin; border-style:solid; border-width:1; width:100%; border-top:0; border-right:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" align="right" style="font-weight:bold">
		<th width="80" align="center">Fixation Date</th>
		<th width="60">Volume</th>
		<th width="60">Hedge</th>
		<th width="60">Diff.</th>
		<th width="60">Price</th>
		<th>&nbsp;</th>
	</tr>
<%
	List<PriceFixationEntity> fxs = contract.getPriceFixations();
	double fixed_tons = 0;
	for (PriceFixationEntity fx : fxs) {
		fixed_tons += fx.tons;
%>	
	<tr align="right">
		<td align="center"><%=DateTime.dateToStr(fx.fixation_date)%></td>
		<td><%=Numeric.numberToStr(fx.tons)%></td>
		<td><%=Numeric.numberToStr(fx.hedge_price,2)%></td>
		<td><%=Numeric.numberToStr(fx.getContract().differential_price,2)%></td>
		<td><%=Numeric.numberToStr(fx.contract_price,2)%></td>
		<td>&nbsp;</td>
	</tr>	
<%
	}
%>
	<tr align="right" bgcolor="#DDDDDD">
		<th>Average</th>
		<th><%=Numeric.numberToStr(fixed_tons)%></th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th><%=Numeric.numberToStr(contract.contract_price, 2)%></th>
		<th>&nbsp;</th>
	</tr>
</table>
</div>

<div style="border:thin; border-style:solid; border-width:1; width:100%; border-top:0; border-right:0;">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" align="right" style="font-weight:bold">
	  <th width="40" rowspan="2">ID&nbsp;</th>
		<th width="120" rowspan="2" align="left">Payment Ref.</th>
		<th width="70" rowspan="2" align="center">Delivery<br>Date</th>
		<th width="60" rowspan="2">Volume</th>
		<th colspan="3" align="center">Discount</th>
		<th width="60" rowspan="2" align="center">Price<br>($/Mt)</th>
		<th width="60" rowspan="2" align="center">Amount<br>(Usd)</th>
		<th rowspan="2">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD" align="right" style="font-weight:bold">
      <th width="40">Mt</th>
	  <th width="40">%</th>
      <th width="40">$/Mt</th>
  </tr>
<%
	List<FinanceEntity> fis = new ArrayList();
	PaymentEntity spm = dao.getPaymentDao().newEntity(contract);//.newPayment();
	List<PaymentEntity> pms = contract.getPayments();
	for (PaymentEntity pm : pms) {
		for (AdvanceLetterEntity av : pm.getAdvanceLetters()) {
			fis.addAll(av.getFinances());
		}
%>	
	<tr align="right">
	  <td align="right"><%=pm.getIdLong()%>&nbsp;</td>
		<td align="left"><%=pm.getRefNumber()%></td>
		<td align="center"><%=DateTime.dateToStr(pm.delivery_date)%></td>
		<td><%=Numeric.numberToStr(pm.tons)%></td>
		<td><%=Numeric.numberToStr(pm.discount_tons,4)%></td>
		<td><%=Numeric.numberToStr(pm.discount_quality,4)%></td>
		<td><%=Numeric.numberToStr(pm.getDiscountPriceUsd(),2)%></td>
		<td><%=Numeric.numberToStr(pm.getPaymentPriceUsd(),2)%></td>
		<td><%=Numeric.numberToStr(pm.getAmountUsd(),2)%></td>
		<td>&nbsp;</td>
	</tr>
<%
		spm.add(pm);
	}
	spm.setAverage();
%>
	<tr align="right" bgcolor="#DDDDDD">
	  <td align="left">&nbsp;</td>
	  <td align="left">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <th><%=Numeric.numberToStr(spm.tons,4)%></th>
	  <th><%=Numeric.numberToStr(spm.discount_tons,4)%></th>
	  <th><%=Numeric.numberToStr(spm.discount_quality,4)%></th>
	  <th><%=Numeric.numberToStr(spm.getDiscountPriceUsd(),2)%></th>
	  <th><%=Numeric.numberToStr(spm.getPaymentPriceUsd(),2)%></th>
	  <th><%=Numeric.numberToStr(spm.getAmountUsd(),2)%></th>
	  <td align="left">&nbsp;</td>
  </tr>	
</table>
</div>

<div style="border:thin; border-style:solid; border-width:1; width:100%; border-top:0; border-right:0;">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" align="right" style="font-weight:bold">
		<th width="80" align="left">Pre-Payment<br />
		  Ref</th>
		<th width="80" align="left">Payment<br />Letter Ref</th>
		<th width="60" align="center">Date</th>
		<th width="70">Ex.Rate<br>(<%=location.currency%>/Usd)</th>
		<th width="80">Amount<br>(<%=location.currency%>)</th>
		<th width="80">Amount<br>(Usd)</th>
		<th width="80">&nbsp;</th>
		<th>&nbsp;</th>
	</tr>
<%
	//fis = dao.getFinanceDao().groupPayment(fis);
	FinanceEntity sfi = dao.getFinanceDao().newEntity();
	for (FinanceEntity fi : fis) {
		if (fi.payment_date.after(contract.fixation_date)) continue;
		sfi.add(fi);
%>
	<tr align="right">
		<td align="left"><%=fi.payment_ref%></td>
		<td align="left">&nbsp;</td>
		<td align="center"><%=DateTime.dateToStr(fi.payment_date)%></td>
		<td><%=Numeric.numberToStr(fi.exchange_rate,0)%></td>
		<td><%=Numeric.numberToStr(fi.amount_local,_dec)%></td>
		<td><%=Numeric.numberToStr(fi.amount_usd,2)%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>	
<%
	}
%>
	<tr align="right" bgcolor="#DDDDDD">
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<th><%=Numeric.numberToStr(sfi.amount_local,_dec)%></th>
		<th><%=Numeric.numberToStr(sfi.amount_usd,2)%></th>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>
</div>

<div id="fixation_div" style="border:thin; border-style:solid; border-width:1; width:100%; border-top:0; border-right:0; display:<%=fixation.isNull()?"none":""%>">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" style="font-weight:bold">
		<th width="90" rowspan="2" align="left">Fixation Ref.</th>
		<th width="60" rowspan="2">Date</th>
		<th width="60" rowspan="2">Ex.Rate</th>
		<th width="60" rowspan="2" align="right">Volume</th>
		<th colspan="3">Discount</th>
		<th colspan="2">Payment</th>
		<th width="60" rowspan="2">To be<br />paid($)</th>
		<th width="60" rowspan="2">&nbsp;</th>
		<th width="60" rowspan="2">&nbsp;</th>
		<th rowspan="2">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD" style="font-weight:bold">
	  <th width="50" align="right">Mt</th>
      <th width="50" align="right">%</th>
	  <th width="50" align="right">$/Mt</th>
	  <th width="50">$/Mt</th>
	  <th width="50">$</th>
	</tr>
	<tr align="right">
		<th align="left"><%=fixation.getRefNumber()%></th>
		<th align="center"><%=DateTime.dateToStr(contract.fixation_date)%></th>
		<th><%=Numeric.numberToStr(fixation.exchange_rate,0)%></th>
		<th><%=Numeric.numberToStr(fixation.tons,4)%></th>
		<th><%=Numeric.numberToStr(fixation.discount_tons,4)%></th>
		<th><%=Numeric.numberToStr(fixation.discount_quality,4)%></th>
		<th><%=Numeric.numberToStr(fixation.discount_price_usd,2)%></th>
		<th><%=Numeric.numberToStr(fixation.price_usd,2)%></th>
		<th><%=Numeric.numberToStr(fixation.amount_usd,2)%></th>
		<th style="color:#FF0000"><%=Numeric.numberToStr(fixation.amount_usd-sfi.amount_usd,2)%></th>
		<td align="center"><a href="JavaScript:saveFixation()" style="display:<%=displayed%>">Save</a></td>
		<td align="center"><a href="JavaScript:printFixation()">Print</a></td>
		<td>&nbsp;</td>
	</tr>
</table>
</div>