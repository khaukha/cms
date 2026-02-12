<%
	PaymentEntity payment = task.getPayment();
	PurchaseContractEntity contract = payment.getContract();
	PaymentLetterEntity p_letter = task.getPaymentLetter();
	AdvanceLetterEntity a_letter = task.getAdvanceLetter();
	task.doCarView(payment, p_letter, a_letter);
	QualityDiscountEntity qa = payment.getContract().getGrade().getQualityDiscount(); 
	DiscountEntity dc = payment.getDiscount();

	List<PaymentLetterEntity> pls =	payment.getPaymentLetters();	

	String readonly  = task.isReadOnly() ? "readonly" : "";
	String disabled  = task.isReadOnly() ? "disabled" : "";

	boolean av_show_rms = requester.getBoolean("advance_show_remark", false); 
	boolean pm_show_rms = requester.getBoolean("payment_show_remark", false); 
	boolean av_show_int = requester.getBoolean("advance_show_interest", false); 
	ibu.ucms.biz.trade.FieldBuzz fb = biz.getTrade().getFieldBuzz();
	BatchEntity batch = payment.getDelivery().getBatch();
	boolean is_fb = !batch.isNull() && !batch.isRejected();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

var can_update = <%=!task.isReadOnly()%>;

function dataChanged(o)
{
}

function isPaymentSelected()
{
	if (getValue("payment_id") == 0) {
		alert("Please select a Payment");
		return false;
	}
	return true;
}

function saveDiscount()
{
	if (<%=task.isReadOnly()%>) return;
	if (isPaymentSelected()) {
		doTask(1);
	}
}	

function newPayment()
{
	if (<%=payment.tons == 0%>) {
		alert("Cannot make payment with zero net.");
		return;
	}
	if (<%=!pls.isEmpty()%>) return;
	if (<%=task.isReadOnly()%>) return;
	if (isPaymentSelected()) {
		show('payment');
		show('payment_remark');
	}
}

function newAdvance()
{
	if (<%=task.isReadOnly()%>) return;
	if (isPaymentSelected()) {
		show('advance');
		show('advance_remark');
	}
}

function newInterest()
{
	if (<%=task.isReadOnly()%>) return;
	show('interest');
	//show('advance_remark');
}

function deleteItem(no, tid)
{
	if (<%=task.isReadOnly()%>) return;
	if (confirm("Are you sure to delete this item ?")) {
		setValue("no", no);
		doTask(tid);
	}
}

function printAdvance(no)
{
	if (isPaymentSelected()) {
		setValue("no", no);
		doTask(3)
	}
}

function saveAdvance(no, has)
{
	if (<%=task.isReadOnly()%>) return;
	if (has) return;
	setValue("no", no);
	doTask(4);
}

function deleteAdvance(no, has)
{
	if (has) return;
	deleteItem(no, 5);
}

function savePaymentLetter(no)
{
	if (<%=task.isReadOnly()%>) return;
	if (getValue("contract_price_local") <= 0) {
		//alert("Please input contract price.");		
		//return;
	}
	setValue("no", no);
	doTask(6);
}

function printPaymentLetter(no)
{
	if (!isPaymentSelected()) {
		return;
	}
	if (<%=is_fb && !batch.isCompleted()%>) {
		if (!confirm("This payment has not been confirmed by FieldBuzz yet. Do you want to print a provisional invoice.?")) {
			return;
		}
	}
	//if (isPaymentSelected()) {
	setValue("no", no);
	doTask(7)
	//}
}

function deletePaymentLetter(no)
{
	deleteItem(no, 8);
}

function saveInterest(advance_letter_id, no)
{
	setValue("advance_letter_id", advance_letter_id);
	setValue("no", no);
	doTask(9);
}

function deleteInterest(no)
{
	deleteItem(no, 10);
}

function baseCurrencyChange(o,no)
{
	setDisabled("advance_market_price_usd_" + no, o.value == 'V');
	setDisabled("advance_amount_local_" + no,     o.value == 'U');
}

function showRemarks(o, txt)
{
	for (i = 0; ; i++) {	
		var ob = getObj(txt + "_remark" + i);
		if (ob == null) break;
		showObj(ob, o.checked);
	}
}

function intDetail(no)
{
	show("interest_detail" + no);
}

function discountTypeClick(o)
{
	if (o.value == 'V') {
		setEnabled("discount_tons");
		setDisabled("discount_quality");
	} else {
		setDisabled("discount_tons");
		setEnabled("discount_quality");
	}
}

function postFieldBuzz(task_id)
{
	if (<%=batch.isNull()%>) {
		alert("This purchase is not a FieldBuzz project.");
		return;
	}
	if (<%=batch.isCompleted()%>) {
		alert("This payment was confirmed already.");
		return;
	}
	if (<%=batch.isRejected()%>) {
		alert("This batch was rejected already.");
		return;
	}
	if (task_id == 11) {
		if (!confirm("Please confirm the DC prepayment amount is correct.")) {
			return;
		}
	} else if (task_id == 12) {
		if (!confirm("Are you sure to reject this payment?")) {
			return;
		}
	}
	setValue("no", 0);
	doTask(task_id);
}
</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style11">
	<tr>
		<td  width="250" valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
		  <tr bgcolor="#EEEEEE">
            <th width="110">Contract Ref.</th>
            <th width="140">Payment Ref.</th>
          </tr>
          <tr>
            <td><select name="contract_id" id="contract_id" size="25" class="style11" style="width:100%;" onChange="setValue('payment_id',0);itemSelected(this)"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(),sc.contract_id,"All")%></select></td>
            <td valign="top"><select name="payment_id" size=25 class="style11" id="payment_id" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(contract.getPayments(),sc.payment_id,"All")%></select></td>
          </tr>
        </table></td>
		<td valign="top" align="left"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style11">
            <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
          <tr bgcolor="#EEEEEE">
            <th>Status</th>
            <th>Type</th>
            <th>Supplier</th>
            <th>Quality</th>
            <th>Grade</th>
          </tr>
          <tr>
            <td><%@include file="inc/filter.status.jsp"%></td>
            <td><select name="filter_contract_type" id="filter_contract_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getContractTypeDao().getPurchaseTypeList(),sc.filter_contract_type,"All")%></select></td>
            <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
          </tr>
        </table></td>
            </tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0" align="center">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
					<tr bgcolor="#DDDDDD">
					  <th width="120">Purchase Ref.</th>
					  <th width="200">Supplier</th>
					  <th width="250">Grade</th>
					  <th width="100">Differential</th>
					  <th width="100">Quantity Mts</th>
					  <th width="40">Type</th>
					  <th width="50">Status</th>
				      <th>&nbsp;</th>
				  </tr>
					<tr align="center">
						<td><%=contract.getRefNumber()%></td>
						<td><%=contract.getSeller().short_name%></td>
						<td><%=contract.getGrade().short_name%></td>
						<td><%=Numeric.numberToStr(contract.differential_price,2)%></td>
						<td><%=Numeric.numberToStr(payment.tons)%></td>
						<td><%=contract.contract_type%></td>
					    <td><%=contract.isFixed()?"Fixed":"Unfixed"%></td>
						<td>&nbsp;</td>
					</tr>
				</table>				
				</div></td>
			</tr>
			<tr>
			  <td>&nbsp; <strong>Discount</strong></td>
		    </tr>
			<tr style="padding-right:1">
			  <td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0" align="center">
<%@include file="trade.payment.card-view.other.jsp"%>
			  </div></td>
			</tr>
			<tr style="padding-right:1; padding-top:1">
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0; border-top:0" align="center">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
	<tr bgcolor="#DDDDDD">
	    <th width="94" rowspan="2">Delivery<br />Date</th>
	    <th colspan="2">Discount</th>
		<th rowspan="2" align="left">&nbsp;Remark</th>
		<th width="36" rowspan="2" align="center">Done</th>
	    <th width="42" rowspan="2" align="center">&nbsp;</th>
	    <th rowspan="2" align="center">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD">
	  <th width="70"><%=location.currency%>/Mt</th>
	  <th width="60">Mts</th>
	</tr>
	<tr>
	  <th align="center"><%=Html.datePicker("delivery_date", payment.delivery_date, "style11")%></th>
	  <td><input name="discount_price_local" type="text" id="discount_price_local" class="style11" style="width:70; text-align:right" value="<%=Numeric.numberToStr(payment.discount_price_local,0)%>" onChange="dataChanged(this)" <%=readonly%>></td>
	  <th style="color:#FF0000"><%=Numeric.numberToStr(payment.discount_tons - payment.husks_tons, 3)%>&nbsp;</th>
	  <td><input name="discount_txt" type="text" id="discount_txt" class="style11" style="width:100%;" value="<%=payment.discount_txt%>" <%=readonly%>></td>
	  <td align="center"><%=Html.checkBox("discount_status", dc.status)%></td>
	  <td align="center"><a href="JavaScript:saveDiscount()" class="style11" style="display:<%=displayed%>">Save</a></td>
	  <td align="center">&nbsp;</td>
	</tr>
</table>
				</div></td>
			</tr>			
          </table></td>
	</tr>
</table>
<div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0; border-left:0; display:none" align="center">
				    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
                      <tr bgcolor="#DDDDDD">
                        <th width="42" rowspan="2">Id</th>
                        <th width="30" rowspan="2">DC</th>
                        <th width="84" rowspan="2">Pre-Payment<br />Date</th>
                        <th width="42" rowspan="2">Pre-<br />Paid%</th>
                        <th width="56" rowspan="2">Base<br />Currency</th>
                        <th width="62" rowspan="2">Price<br />(USD/Mt)</th>
                        <th width="52" rowspan="2">Exch.<br />Rate</th>
                        <th width="92" rowspan="2">A.Amount<br /><%=location.currency%></th>
                        <th width="60" rowspan="2">Stop<br />Loss</th>
                        <th colspan="3">Interest</th>
                        <th width="82" rowspan="2">Fixation<br />Date</th>
                        <th width="42" rowspan="2">Comp.</th>
                        <th colspan="4" rowspan="2"><a href="JavaScript:newAdvance()" class="style11" style="display:<%=displayed%>">New Pre-Payment</a></th>
                        <th>Remarks <%=Html.checkBox("advance_show_remark", av_show_rms, "showRemarks(this,'advance')")%></th>
                      </tr>
                      <tr bgcolor="#DDDDDD">
                        <th width="32">Rate</th>
                        <th width="32">Days</th>
                        <th width="82">Amount</th>
                        <th>&nbsp;</th>
                      </tr>
                      
<%
	int no = 0;
	List<AdvanceLetterEntity> avs = payment.getAdvanceLetters();
	AdvanceLetterEntity _av = dao.getAdvanceLetterDao().newEntity(payment);
	_av.discount_included = false;
	avs.add(_av);
	for (int i = 0; i < avs.size(); i++) {
		AdvanceLetterEntity av = avs.get(i);
		if (av.interest_rate <= 0 && av.getPayment().getContract().isConsignment()) {
			av.interest_rate = 1.2;
		}
%>					  
					<input type="hidden" name="advance_letter_id_<%=i%>"  id="advance_letter_id_<%=i%>"  value="<%=av.getIdLong()%>">		
                      <tr id="<%=av.isNull()?"advance":""%>" style="display:<%=av.isNull()?"none":""%>" align="center">
                        <th bgcolor="#DDDDDD"><%=av.getIdLong()%></th>
                        <th><%=Html.checkBox("advance_discount_included_" + i, av.discount_included)%></th>
                        <td><%=Html.datePicker("advance_date_" + i,av.date)%></td>
                        <td><input type="text" name="advance_percent_<%=i%>" 			id="advance_percent_<%=i%>" 			class="style11" style="width:42; text-align:right" value="<%=Numeric.numberToStr(av.getPercent(),2)%>"></td>
                        <td><select name="advance_base_currency_<%=i%>" id="advance_base_currency_<%=i%>" size=1 class="style11" style="width:56;" onchange="baseCurrencyChange(this,<%=i%>)"><%=Html.selectOptions(dao.getCurrencyDao().selectAll(), av.base_currency)%></select></td>
                        <td><input type="text" name="advance_market_price_usd_<%=i%>" id="advance_market_price_usd_<%=i%>"	class="style11" style="width:62; text-align:right" value="<%=Numeric.numberToStr(av.market_price_usd,2)%>" <%=av.base_currency=='U'?"":"disabled"%>></td>
                        <td><input type="text" name="advance_exchange_rate_<%=i%>" 		id="advance_exchange_rate_<%=i%>" 		class="style11" style="width:52; text-align:right" value="<%=Numeric.numberToStr(av.exchange_rate,0)%>" <%=av.isNull()?"disabled":""%>></td>
                        <td><input type="text" name="advance_amount_local_<%=i%>" 		id="advance_amount_local_<%=i%>" 			class="style11" style="width:92; text-align:right" value="<%=Numeric.numberToStr(av.amount_local,_dec)%>" <%=av.base_currency=='V'?"":"disabled"%>></td>
                        <th align="right"><%=Numeric.numberToStr(av.stop_loss,2)%></th>
                        <td><input type="text" name="advance_interest_rate_<%=i%>" 		id="advance_interest_rate_<%=i%>"		class="style11" style="width:32; text-align:right"  value="<%=av.interest_rate%>"></td>
                        <td><input type="text" name="advance_interest_days_<%=i%>" 		id="advance_interest_days_<%=i%>"		class="style11" style="width:32; text-align:right"  value="<%=av.interest_days%>" <%=av.isNull()?"disabled":""%>></td>
                        <td align="right"><strong><%=Numeric.numberToStr(av.interest_amount_local,_dec)%></strong>&nbsp;</td>
                        <td><select name="advance_payment_letter_id_<%=i%>" id="advance_payment_letter_id_<%=i%>" class="style11" style="width:82;"><%=Html.selectOptions(task.getPaymentLetterDateList(payment.getIdLong()),av.payment_letter_id)%></select></td>
                        <td><%=Html.checkBox("advance_status_" + i,av.status)%></td>
                        <td width="40"><a href="JavaScript:saveAdvance(<%=i%>,<%=av.hasDetails()%>)" class="style11" <%=av.hasDetails()?"disabled":""%> style="display:<%=displayed%>">Save</a></td>
                        <td width="40"><a href="JavaScript:deleteAdvance(<%=i%>,<%=av.hasDetails()%>)" class="style11" <%=av.hasDetails()?"disabled":""%> style="display:<%=displayed%>">Delete</a></td>
                        <td width="40"><a href="JavaScript:printAdvance(<%=i%>)" class="style11">Print</a></td>
                        <td width="40"><a href="JavaScript:intDetail(<%=i%>)" class="style11" style="display:<%=displayed%>">Detail</a></td>
                        <th><%=av.isNull()?"New":""+av.getIdLong()%></th>
                      </tr>
					  <tr id="advance_remark<%=av.isNull()?"":""+i%>" style="display:<%=av.isNull()||!av_show_rms?"none":""%>">
					  	<td colspan="3" align="right">Remark &nbsp;</td>
						<td colspan="15"><input name="advance_remark_<%=i%>" type="text" id="advance_remark_<%=i%>" class="style11" style="width:100%;" value="<%=av.remark%>"></td>
						<td>&nbsp;</td>
					  </tr>		
					  <tr id="interest_detail<%=av.isNull()?"":""+i%>" style="display:<%=av.isNull() || !av.hasDetails()?"none":""%>">
					    <td align="right">&nbsp;</td>
					  	<td align="right">&nbsp;</td>
						<td colspan="17"><%@include file="trade.payment.interest.jsp"%></td>
					  </tr>		
<%	
	}
%>					  			  
                    </table>
</div>
<div style="border:thin; border-style:solid; border-width:1; width:100%; border-top:; border-right:0; border-left:0" align="center">
  <table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
    <tr bgcolor="#DDDDDD">
      <th width="42" rowspan="2" bgcolor="#DDDDDD">Id</th>
      <th width="30" rowspan="2" bgcolor="#DDDDDD">DC</th>
      <th width="84" rowspan="2">Fixation<br />
        Date </th>
      <th width="94" rowspan="2">Payment<br />
        Date</th>
      <th width="50" rowspan="2">Paid<br>
        Mts</th>
      <th width="50" rowspan="2">Exch.<br />
        Rate</th>
      <th colspan="2" style="display:">Price</th>
      <th colspan="2">Amount</th>
      <th colspan="2" rowspan="2"><a href="JavaScript:newPayment()" class="style11" style="display:<%=displayed%>">New Payment</a></th>
      <th rowspan="2">Print</th>
      <th width="80" rowspan="2"><%=is_fb?"Field Buzz Batch No":"&nbsp;"%></th>
      <th rowspan="2">Remarks <%=Html.checkBox("payment_show_remark", av_show_rms, "showRemarks(this,'payment')")%></th>
    </tr>
    <tr bgcolor="#DDDDDD">
      <th width="70"><%=location.currency%>/Mt</th>
      <th width="70">USD/Mt</th>
      <th width="80"><%=location.currency%></th>
      <th width="70">USD</th>
    </tr>
    <%
	//List<PaymentLetterEntity> pls =	payment.getPaymentLetters();	
	PaymentLetterEntity _pl = dao.getPaymentLetterDao().newEntity(payment);
	_pl.discount_included = false;
	_pl.vat = 0;
	pls.add(_pl);
	for (int i = 0; i < pls.size(); i++) {
		PaymentLetterEntity pl = pls.get(i);	
		PriceFixationEntity fx = pl.getFixation();
%>
    <input type="hidden" name="payment_letter_id_<%=i%>"  id="payment_letter_id_<%=i%>"  value="<%=pl.getIdLong()%>">
    <tr id="<%=pl.isNew()?"payment":""%>" align="center" style="display:<%=pl.isNew()?"none":""%>">
      <td bgcolor="#DDDDDD"><strong><%=pl.getIdLong()%></strong></td>
      <td><%=Html.checkBox("payment_discount_included_" + i, pl.discount_included)%></td>
      <td><select name="fixation_id_<%=i%>" id="fixation_id_<%=i%>" class="style11" style="width:84;">
          <%=Html.selectOptions(task.getFixationDateList(payment.getContract().getIdLong()),pl.fixation_id)%>
      </select></td>
      <td><%=Html.datePicker("payment_payment_date_" + i,pl.payment_date, "style11")%></td>
      <th align="right"><%=Numeric.numberToStr(pl.tons,3)%>&nbsp;</th>
      <td><input type="text" name="payment_exchange_rate_<%=i%>" 			id="payment_exchange_rate_<%=i%>" 		class="style11" style="width:50; text-align:right"  value="<%=Numeric.numberToStr(pl.exchange_rate,0)%>" <%=pl.isNull()?"disabled":""%> /></td>
      <td align="right"><strong><%=Numeric.numberToStr(fx.contract_price_local,0)%></strong>&nbsp;</td>
      <td align="right"><strong><%=Numeric.numberToStr(fx.contract_price,2)%></strong>&nbsp;</td>
      <th align="right"><%=Numeric.numberToStr(pl.amount_local,0)%>&nbsp;</th>
      <th align="right"><%=Numeric.numberToStr(pl.amount_usd,2)%>&nbsp;</th>
      <td width="50"><a href="JavaScript:savePaymentLetter(<%=i%>)" class="style11" style="display:<%=displayed%>">Save</a></td>
      <td width="50"><a href="JavaScript:deletePaymentLetter(<%=i%>)" class="style11" style="display:<%=displayed%>">Delete</a></td>
      <td width="50"><a href="JavaScript:printPaymentLetter(<%=i%>)" class="style11">GRN</a></td>
      <th><%=batch.batch_no%></th>
      <th style="color:#FF0000"><%=fb.getMessage()%>&nbsp;</th>
    </tr>
    <tr id="payment_remark<%=pl.isNull()?"":""+i%>" style="display:<%=pl.isNull()||!pm_show_rms?"none":""%>">
      <td align="right">&nbsp;</td>
      <td align="right">&nbsp;</td>
      <td align="right">Remark &nbsp;</td>
      <td colspan="7"><input name="payment_remark_<%=i%>" type="text" id="payment_remark_<%=i%>" class="style11" style="width:100%;" value="<%=pl.remark%>"></td>
    </tr>
    <%
	}
%>
  </table>
</div>
		
<div style="border:thin; border-style:solid; border-width:1; width:100%; border-top:0; border-right:0; border-left:0; display:<%=payment.tons>0 && is_fb?"":"none"%>" align="center">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
	<tr bgcolor="#DDDDDD">		
		<th width="42" rowspan="2">Id</th>
		<th width="100" rowspan="2">Batch No</th>
		<th width="150" rowspan="2">DC Name </th>
		<th width="60" rowspan="2" style="color:#0000FF">FB Kgs</th>
		<th width="60" rowspan="2">Paid Kgs</th>
		<th colspan="2">UCFA Commission</th>
		<th width="80" rowspan="2">Batch Value<br>UGX</th>
		<th width="80" rowspan="2" style="color:#0000FF">Prepayment<br>UGX</th>
		<th width="80" rowspan="2" style="color:#0000FF">DC Payment<br>UGX</th>
		<th colspan="6">FieldBuzz Confirmation</th>
		<th rowspan="2">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD">
	  <th width="60">UGX/Kg</th>
      <th width="70">UGX</th>
	  <th width="70">Status</th>
	  <th width="120">Date</th>
	  <th colspan="3">Action</th>
	  <th width="50">Print</th>
	</tr>
	<tr>		
		<th bgcolor="#DDDDDD"><%=batch.getIdLong()%>&nbsp;</th>
		<th align="center"><%=batch.batch_no%></th>
		<th align="center"><%=batch.getDc().dc_name%></th>
		<th align="right" style="color:#0000FF"><%=Numeric.numberToStr(batch.total_kgs,0)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(batch.paid_kgs,0)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(batch.commission_rate,0)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(batch.commission_amount_ugx,0)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(batch.batch_amount_ugx,0)%>&nbsp;</th>
		<th align="right" style="color:#0000FF"><%=Numeric.numberToStr(batch.prepayment_amount_ugx,2)%>&nbsp;</th>
		<th align="right" style="color:#0000FF"><%=Numeric.numberToStr(batch.payment_amount_ugx,2)%>&nbsp;</th>
		<th align="center" style="color:<%=batch.isRejected()?"#FF0000":"#0000FF"%>"><%=batch.getStatusText()%></th>
		<th align="center"><%=batch.getPostDateTimeTxt()%></th>
		<td width="50" align="center"><a href="JavaScript:postFieldBuzz(13)" style="display:<%=batch.isNull()?"none":""%>">Post</a></td>
		<td width="50" align="center"><a href="JavaScript:postFieldBuzz(11)" style="display:<%=batch.isNull()?"none":""%>">Confirm</a></td>
		<td width="50" align="center"><a href="JavaScript:postFieldBuzz(12)" style="display:<%=batch.isNull()?"none":""%>">Reject</a></td>
		<td align="center"><a href="JavaScript:printPaymentLetter(0)" class="style11">GRN</a></td>
		<td>&nbsp;</td>
	</tr>
</table>
</div>
		
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style11">
	<tr>
	  <td>&nbsp;</td>
       <td align="right"><img src="../shared/images/listview.jpg"  onClick="setValue('view',0);doPost();"></td>
    </tr>
</table>

<input type="hidden" name="no"   id="no" value="-1">		
<input type="hidden" name="advance_letter_id"  id="advance_letter_id_" value="0">		

<script language="javascript">
    setValue("view", 1);
    hide('cup_test_input');
	if (!can_update) 
	{
		hide("update_btn");
    }
	
	setCbxById("completed_");

	if (<%=payment.isNew()%>) {	
		var idx = addNewListItem(document.formMain.payment_id,"<%=payment.getRefNumber()%>");
	}


	if (<%=task.isReadOnly()%>) {
		//setCompletedElements("contract_id","payment_id");
	}

</script>


