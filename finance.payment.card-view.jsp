<%
	FinanceEntity finance = task.doTask();	
	PurchaseContractEntity contract = finance.getContract();	
	int k = 0;
	List<FinanceEntity> finances = contract.getFinances();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";
var completed = <%=finance.isCompleted()%>;
var readonly = <%=task.isReadOnly()%>;
/////////////////////////////////////////////
function calculateExchange(o,l)
{
	formatNumberObj(o,l);
}

function setFinanceValue(type, no, ref)
{
	getObj("finance_" + ref).value = getText(type + "_" + ref + "_" + no);
}

function selectLetter(type, no)
{
	if (<%=finance.isCompleted()%>) {	
		return;
	}
	setValue("letter_type", type);
	setFinanceValue(type, no, "payment_date");	
	setFinanceValue(type, no, "exchange_rate");	
	setFinanceValue(type, no, "amount_local");
	setFinanceValue(type, no, "amount_usd");
}

function paymentCheck(cbx,i)
{
	if (getValue("finance_id") == 0) {
		alert("Please create a Finance Ref. First.");
		return;
	}
	if (cbx.checked) {
		//setValue("finance_payment_date", getText("delivery_date_" + i));
		//setValue("finance_payment_tons", getText("delivery_tons_" + i));
	} else {
	} 
	cbxClick(cbx);
}

function newFinance()
{
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract.");
		return;
	}	
	if (addNewListItemById("finance_id","New Finance") >= 0) {
		doPost();
	}
}

function saveFinance()
{
	var finance_id = getValue("finance_id");
	if (finance_id == 0) {
		alert("Please select a Finance Ref..");
		return;
	}
	if (getValue("letter_type") == ' ') {
		alert("Please select a Payment Ref..");		
		return;
	}
	doTask(1);
}

function deleteFinance()
{
	if (confirm("Are you sure to delete " + getSelectedText("finance_id"))) {
		doTask(2);
	}
}	

function financeChange(fid)
{
	setValue("finance_id", fid);
	doPost();
}

function printPayment()
{
	if (getValue("finance_id") <= 0) {
		alert("Please select a Payment Ref.");
		return;
	}
	doTask(6)
}

function newInvoice()
{
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract.");
		return;
	}
	show("invoice_");	
}

function saveInvoice(no)
{
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract.");
		return;
	}
	setValue("no", no);
	doTask(3);
}

function deleteInvoice(no)
{
	if (confirm("Are you sure to delete invoice " + getValue("invoice_ref_number_" + no))) {
		setValue("no", no);
		doTask(5);
	}
}	

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2" style="padding-left:0; padding-right:0">
	<tr>
		<td width="" align="left" valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
		  <tr bgcolor="#EEEEEE">
            <th width="120">Contract Ref.</th>
            <th width="150">Finance Ref. </th>
		  </tr>
          <tr>
            <td><select name="contract_id" id="contract_id" size="20" class="style11" style="width:100%;" onchange="setValue('finance_id',0);doPost()"><%=Html.selectOptionsX(dao.getPurchaseContractDao().list(),sc.contract_id,"All")%></select></td>
            <td><select name="finance_id" id="finance_id" size="20" class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptionsX(finances,finance.getIdLong(),"All")%></select></td>
          </tr>
          <tr style="display:<%=displayed%>">
            <td>&nbsp;</td>
            <td>
		  		<img id="new_btn" src="images/new.gif" border="0" width="15" height="15" onClick="newFinance()">
		  		<img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="deleteFinance()"></td>			
          </tr>
      </table></td>
		<td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
            <tr>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr bgcolor="#EEEEEE" style="display:">
            <th width="120">Status</th>
            <th>Supplier</th>
            <th>Grade</th>
            </tr>
          <tr style="display:">
            <td><%@include file="inc/filter.status.jsp"%></td>
            <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onchange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
            </tr>
        </table></td>
            </tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0; border-bottom:0" align="left">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
					<tr bgcolor="#DDDDDD" align="left">
					  <th width="30" align="right">Id&nbsp;</th>
					  <th width="150">Contract Ref.</th>
					  <th width="80">Date</th>
					  <th width="150">Supplier</th>
					  <th width="180">Grade</th>					  
				      <th width="80">Type</th>
			          <th>Status</th>
				  </tr>
					<tr>
					  <td align="right" bgcolor="#DDDDDD"><strong><%=contract.getIdLong()%></strong>&nbsp;</td>
					  <td><%=contract.getRefNumber()%></td>
					  <td><%=DateTime.dateToStr(contract.contract_date)%></td>
					  <td><%=contract.getSeller().short_name%></td>
					  <td><%=contract.getGrade().short_name%></td>
				      <td><%=contract.getContractType().short_name%></td>
			          <td><%=contract.isFixed()?"Fixed":"Unfixed"%></td>
				  </tr>
				</table>				
				</div></td>
			</tr>
			<tr style="display:none">
				<td><strong>Pre-Payment Letter </strong></td>
			</tr>
			<tr style="display:none">
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0; border-bottom:0" align="left">
					<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style11">
						<tr bgcolor="#DDDDDD">
					  		<th width="130" rowspan="2">Pre-Payment Ref.</th>
							<th width="70" rowspan="2">Delivery<br />Date</th>
					  		<th width="70" rowspan="2">P.Payment<br />Date</th>		
							<th width="70" rowspan="2">Kgs</th>												
							<th colspan="3">Pre-Payment (<%=location.currency%>)</th>																		
						    <th width="40" rowspan="2">&nbsp;</th>																		
							<th rowspan="2">&nbsp;</th>
						</tr>
						<tr bgcolor="#DDDDDD">
						  <th width="90">Amount</th>
					      <th width="80">VAT</th>
					      <th width="90">Total</th>
					  </tr>
<%
	List<PaymentEntity> payments = contract.getPayments();	
	AdvanceLetterEntity av_sum = dao.getAdvanceLetterDao().newEntity();
	double av_tons = 0;	
	for (int i = 0; i < payments.size(); i++) {
		PaymentEntity pm = payments.get(i);
		List<AdvanceLetterEntity> avs = pm.getAdvanceLetters();
		for (int j = 0; j < avs.size(); j++, k++) {
			AdvanceLetterEntity av = avs.get(j);
			av_sum.add(av);	
			av_tons += pm.getPaymentTons();
%>						
						<tr onClick="highlightOn(this,0)">
							<td><%=pm.getRefNumber()%></td>
							<td align="center"><%=DateTime.dateToStr(pm.delivery_date)%></td>
						    <td align="center"><%=DateTime.dateToStr(av.date)%></td>
						    <td align="right"><%=Numeric.numberToStr(av.getPaymentTons()*1000,0)%>&nbsp;</td>
						    <td align="right"><%=Numeric.numberToStr(av.amount_local,0)%>&nbsp;</td>							
						    <td align="right"><%=Numeric.numberToStr(av.vat_local,0)%>&nbsp;</td>							
						    <td align="right"><%=Numeric.numberToStr(av.total_amount_local,0)%>&nbsp;</td>		
							<td align="center"><input name="letter_id" type="radio" value="<%=av.getIdLong()%>" <%=finance.letter_type=='A' && finance.letter_id == av.getIdLong() ? "checked" : ""%> onclick="selectLetter('A',<%=k%>)" /></td>					
							<td>&nbsp;</td>
						</tr>
<%
		}
	}
%>						
						<tr bgcolor="#DDDDDD" align="right">
					  		<th>Total</th>
					  		<th>&nbsp;</th>		
							<th>&nbsp;</th>
							<th><%=Numeric.numberToStr(av_tons,4)%>&nbsp;</th>												
							<th><%=Numeric.numberToStr(av_sum.amount_local,_dec)%></th>																		
						    <th><%=Numeric.numberToStr(av_sum.vat_local,_dec)%></th>																		
						    <th><%=Numeric.numberToStr(av_sum.total_amount_local,_dec)%></th>																		
						    <th>&nbsp;</th>																		
							<th>&nbsp;</th>
						</tr>
					</table>
				</div></td>
			</tr>
			<tr style="display:none">
				<td><strong>Payment Letter </strong></td>
			</tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0" align="left">
			  	<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style11">
					<tr bgcolor="#DDDDDD">
					  <th width="30" rowspan="2" align="right">Id&nbsp;</th>
					  <th width="130" rowspan="2">Payment Ref.</th>
					  <th width="60" rowspan="2">Delivery<br />Date</th>
					  <th width="60" rowspan="2">Fixation<br />Date</th>
					  <th width="60" rowspan="2">Payment<br />Date</th>
					  <th width="60" rowspan="2">Kgs</th>
					  <th width="50" rowspan="2">Ex.Rate</th>
					  <th colspan="2">Price<br></th>
					  <th colspan="2">Amount</th>
					  <th width="40" rowspan="2">&nbsp;</th>
			          <th rowspan="2">&nbsp;</th>
				  </tr>
					<tr bgcolor="#DDDDDD">
					  <th width="60"><%=location.currency%>/Kg</th>
					  <th width="60">USD/Mt</th>
					  <th width="80"><%=location.currency%></th>
				      <th width="70">USD</th>
			      </tr>
<%
	double pl_tons = 0;		
	PaymentLetterEntity pl_sum = dao.getPaymentLetterDao().newEntity();
	for (int i = 0; i < payments.size(); i++) {
		PaymentEntity pm = payments.get(i);
		List<PaymentLetterEntity> pls = pm .getPaymentLetters();
		for (int j = 0; j < pls.size(); j++, k++) {
			PaymentLetterEntity pl = pls.get(j);
			PriceFixationEntity fx = pl.getFixation();
			pl_sum.add(pl);
			pl_tons += pl.getPaymentTons();
			String dis = finance.getIdLong() == 0 ? "disabled" : "";
			if (finance.letter_type=='P' && !finance.getLetter().isNull() && finance.letter_id != pl.getIdLong()) {
				//dis = "disabled";
			}
%>				  
					<tr onClick="highlightOn(this)">
					  <td bgcolor="#DDDDDD" align="right"><strong><%=pl.getIdLong()%></strong>&nbsp;</td>
					  <td style="color:; cursor:"><%=pm.getRefNumber()%></td>
					  <td align="center"><%=DateTime.dateToStr(pm.delivery_date)%></td>
					  <td align="center"><%=DateTime.dateToStr(fx.fixation_date)%></td>
					  <td align="center"><label id="P_payment_date_<%=k%>"><%=DateTime.dateToStr(pl.payment_date)%></label></td>
					  <td align="right"><%=Numeric.numberToStr(pl.getPaymentTons()*1000,0)%>&nbsp;</td>
					  <td align="right"><label id="P_exchange_rate_<%=k%>"><%=Numeric.numberToStr(pl.exchange_rate,0)%></label>&nbsp;</td>
					  <td align="right"><label id="P_price_local_<%=k%>"><%=Numeric.numberToStr(pl.price_local/1000,0)%></label>&nbsp;</td>
					  <td align="right"><label id="P_price_usd_<%=k%>"><%=Numeric.numberToStr(pl.price_usd,2)%></label>&nbsp;</td>
					  <td align="right"><label id="P_amount_local_<%=k%>"><%=Numeric.numberToStr(pl.amount_local,0)%></label>&nbsp;</td>
			          <td align="right"><label id="P_amount_usd_<%=k%>"><%=Numeric.numberToStr(pl.amount_usd,2)%></label>&nbsp;</td>
			          <td align="center"><input name="letter_id" type="radio" value="<%=pl.getIdLong()%>" <%=finance.letter_type=='P' && finance.letter_id == pl.getIdLong() && finance.getIdLong() > 0 ? "checked" : ""%> onclick="selectLetter('P',<%=k%>)" <%=dis%> /></td>
			          <td>&nbsp;</td>
				  </tr>
<%
		}
	}
%>				  
					<tr bgcolor="#DDDDDD">
					  <th>&nbsp;</th>
					  <th>Total &nbsp;</th>
					  <th>&nbsp;</th>
					  <th>&nbsp;</th>
					  <th>&nbsp;</th>
					  <th align="right"><%=Numeric.numberToStr(pl_tons*1000,0)%>&nbsp;</th>
					  <th>&nbsp;</th>
					  <th>&nbsp;</th>
					  <th>&nbsp;</th>
					  <th align="right"><%=Numeric.numberToStr(pl_sum.amount_local,0)%>&nbsp;</th>
					  <th align="right"><%=Numeric.numberToStr(pl_sum.amount_usd,2)%>&nbsp;</th>
					  <th>&nbsp;</th>
			          <th>&nbsp;</th>
				  </tr>
				</table>				
				</div></td>
			</tr>
<%
	FixationLetterEntity fl = contract.getFixationLetter();	
	boolean isTBF = !contract.isOutRight();
%>									
			<tr style="display:<%=isTBF?"none":"none"%>">
				<td><strong>Final Fixation Letter </strong></td>
			</tr>
			<tr style="display:<%=isTBF?"":"none"%>; padding-bottom:1;">
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; border-right:0; border-top:0" align="left">
					<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style11">
						<tr bgcolor="#DDDDDD">
					  		<th width="130" rowspan="2">Fixation Ref.</th>
					  		<th width="70" rowspan="2">Fixation<br />Date</th>		
							<th width="70" rowspan="2">Tons</th>												
							<th width="70" rowspan="2">Price<br />(USD)</th>	
						    <th width="70" rowspan="2">Discount<br />%</th>
						    <th width="70" rowspan="2">Ex.<br />Rate</th>
						    <th colspan="3">Payment (USD)</th>																		
						    <th width="40" rowspan="2">&nbsp;</th>
						    <th rowspan="2">&nbsp;</th>
						</tr>
						<tr bgcolor="#DDDDDD">
						  <th width="90">Amount</th>
					      <th width="80">VAT</th>
					      <th width="90">Total</th>
					  </tr>
						<tr id="fixation" onClick="highlightOn(this,0)" style="display:<%=fl.isNull()?"none":""%>">
							<td><%=fl.getRefNumber()%></td>
							<td align="center"><%=DateTime.dateToStr(contract.fixation_date)%></td>
						    <td align="right"><%=Numeric.numberToStr(fl.tons,4)%>&nbsp;</td>
						    <td align="right"><%=Numeric.numberToStr(fl.price_usd,2)%>&nbsp;</td>
						    <td align="right"><%=Numeric.numberToStr(fl.discount_quality,4)%>&nbsp;</td>
						    <td align="right"><input type="text" name="fixation_exchange_rate" id="fixation_exchange_rate" class="style11" style="width:68px; text-align:right" value="<%=Numeric.numberToStr(fl.exchange_rate,0)%>"></td>
						    <td align="right"><%=Numeric.numberToStr(fl.amount_usd,2)%>&nbsp;</td>							
						    <td align="right"><%=Numeric.numberToStr(fl.vat_usd,2)%>&nbsp;</td>							
						    <td align="right"><%=Numeric.numberToStr(fl.total_amount_local,2)%>&nbsp;</td>		
							<td align="center"><input name="letter_id" id="letter_f" type="radio" value="<%=fl.getIdLong()%>" <%=finance.letter_type=='F' && finance.letter_id == fl.getIdLong() ? "checked" : ""%> onclick="selectLetter('F',<%=k%>)" /></td>					
							<td><%=fl.getIdLong()%>&nbsp;</td>
						</tr>
					</table>
				</div></td>
			</tr>			
      </table></td>
	</tr>
</table>
<div style="border:thin; border-style:solid; border-width:1; width:100%; border-left:0; border-right:0" align="left">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
					<tr bgcolor="#DDDDDD">
					  <th width="130" rowspan="2">Payment Ref.</th>
					  <th width="120" rowspan="2">Letter Ref.</th>
					  <th width="80" rowspan="2">Sun Acc.<br>Ref.</th>
					  <th width="80" rowspan="2">Payment<br />Date</th>
					  <th width="70" rowspan="2">Kgs</th>
					  <th width="80" rowspan="2">Type</th>
					  <th width="60" rowspan="2">Ex.Rate</th>
					  <th colspan="2">Amount</th>
				      <th width="40" rowspan="2">Comp.</th>
				      <th width="" rowspan="2">&nbsp;</th>
				  </tr>
					<tr bgcolor="#DDDDDD">
					  <th width="90"><%=location.currency%></th>
				      <th width="70">USD</th>
				  </tr>
					
<%
	FinanceEntity sfi = dao.getFinanceDao().newEntity();
	//List<FinanceEntity> finances = contract.getFinances();
	for (int i = 0; i < finances.size(); i++) {
		FinanceEntity fi = finances.get(i);
		sfi.add(fi);
%>				  
					<tr id="frow_<%=fi.getIdLong()%>" onClick="financeChange(<%=fi.getIdLong()%>)">
					  <td><%=fi.getRefNumber()%></td>
					  <td><%=fi.getLetter().getPayment().getRefNumber()%></td>
					  <td><%=fi.payment_ref%></td>                 
					  <td align="center"><%=DateTime.dateToStr(fi.payment_date)%></td>
					  <td align="right"><%=Numeric.numberToStr(fi.getLetter().getPaymentTons()*1000,0)%>&nbsp;</td>
					  <td align="center"><%=fi.getTypeDesc()%></td>
					  <td align="right"><%=Numeric.numberToStr(fi.exchange_rate,0)%>&nbsp;</td>
					  <td align="right"><%=Numeric.numberToStr(fi.amount_local,0)%>&nbsp;</td>
					  <td align="right"><%=Numeric.numberToStr(fi.amount_usd,2)%>&nbsp;</td>
					  <td align="center"><%=fi.status==2?"Yes":"No"%></td>
					  <th align="left"><%=fi.getLetter().getTypeDesc()%></th>
				  </tr>
<%
	}
%>				  
					<tr bgcolor="#DDDDDD">
					  <th align="right">&nbsp;</th>
					  <th align="right">&nbsp;</th>
					  <th align="right">Total &nbsp;</th>
					  <td>&nbsp;</td>
					  <td align="right">&nbsp;</td>
					  <td>&nbsp;</td>
					  <td align="right">&nbsp;</td>
					  <th align="right"><%=Numeric.numberToStr(sfi.amount_local,0)%>&nbsp;</th>
					  <th align="right"><%=Numeric.numberToStr(sfi.amount_usd,2)%>&nbsp;</th>
					  <td align="center">&nbsp;</td>
					  <th>&nbsp;</th>
				  </tr>
				</table>
</div>

<strong>Payment</strong>
<div style="border:thin; border-style:solid; border-width:1; width:100%; border-left:0; border-right:0" align="center">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
					<tr bgcolor="#DDDDDD">
					  <th width="120">Payment Ref.</th>
					  <th width="100">Sun Acc Ref.</th>
					  <th width="94">Payment<br />Date</th>
					  <th width="60">Kgs</th>
					  <th width="90">Type</th>
					  <th width="50">Ex.Rate </th>
					  <th width="80">Amount<br /><%=location.currency%></th>
				      <th width="70">Amount<br />USD</th>
				      <th align="left">Remark</th>
				      <th width="32">Done</th>
				      <th width="40">&nbsp;</th>
				      <th width="40">&nbsp;</th>
				  </tr>
					
					<tr id="payment_" style="display:<%=finance.getIdLong()==0?"none":""%>">
					  <td><%=finance.getRefNumber()%></td>
					  <td><input type="text" name="finance_payment_ref" id="finance_payment_ref" class="style2" style="width:100%;" value="<%=finance.payment_ref%>"></td>
					  <td><%=Html.datePicker("finance_payment_date",finance.payment_date)%></td>
					  <td align="right"><strong><%=Numeric.numberToStr(finance.getLetter().getPaymentTons()*1000,0)%></strong>&nbsp;</td>
					  <td><select name="finance_type" id="finance_type" class="style2" style="width:100%;">
                			<option value="B" <%=finance.type=='B'?"selected":""%>>Before VAT</option>
                			<option value="V" <%=finance.type=='V'?"selected":""%>>VAT</option>
                			<option value="A" <%=finance.type=='A'?"selected":""%>>After VAT</option>
              			</select></td>
					  <td><input type="text" name="finance_exchange_rate" id="finance_exchange_rate" class="style2" style="width:50; text-align:right" value="<%=Numeric.numberToStr(finance.exchange_rate,0)%>" <%=finance.isNull()?"disabled":""%>></td>
					  <td><input type="text" name="finance_amount_local" id="finance_amount_local" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(finance.amount_local,0)%>"></td>
					  <td><input type="text" name="finance_amount_usd" id="finance_amount_usd" class="style2" style="width:70; text-align:right" value="<%=Numeric.numberToStr(finance.amount_usd,2)%>"></td>
				      <td align="center"><input type="text" name="finance_remark" id="finance_remark" class="style11" style="width:100%;" value="<%=finance.remark%>"></td>
				      <td align="center"><%=Html.checkBox("finance_status",finance.status)%></td>
				      <td align="center"><a href="JavaScript:saveFinance()" class="style2" style="display:<%=displayed%>">Save</a></td>
				      <td><a style="display:<%=location_id==3?"":"none"%>" href="JavaScript:printPayment()" class="style2">Print</a></td>
				</table>				
</div>

<label style="display:none"><strong>Invoices</strong></label>
<div style="display:none; border:thin; border-style:solid; border-width:1; width:100%; border-left:0; border-right:0;" align="center">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2" style="display:none">
	<tr bgcolor="#DDDDDD">
	  <th width="20">&nbsp;</th>
		<th width="80">Invoice No</th>
		<th width="94">Invoice Date</th>
		<th width="100">Amount B.VAT</th>
		<th width="40">VAT%</th>
		<th width="100">VAT Amount</th>
		<th width="100">Amount A.VAT</th>
		<th align="left">Remark</th>
		<td width="45" align="center"><a href="JavaScript:newInvoice()" class="style2" style="display:<%=displayed%>">New</a></td>
	    <td width="45" align="center">&nbsp;</td>
	    <td>&nbsp;</td>
	</tr>
<%
	PurchaseInvoiceEntity siv = dao.getPurchaseInvoiceDao().newEntity();
	List<PurchaseInvoiceEntity> ivs = contract.getPurchaseInvoices();
	ivs.add(contract.newPurchaseInvoice());
	for (int i = 0; i < ivs.size(); i++) {
		PurchaseInvoiceEntity iv = ivs.get(i);
		siv.add(iv);
%>	
	<input type="hidden" name="invoice_id_<%=i%>"  id="invoice_id_<%=i%>"  value="<%=iv.getIdLong()%>">
	<tr id="<%=iv.isNull()?"invoice_":""%>" style="display:<%=iv.isNull()?"none":""%>">
	    <th align="right" bgcolor="#DDDDDD"><%=i+1%>&nbsp;</th>
		<td><input type="text" name="invoice_ref_number_<%=i%>" id="invoice_ref_number_<%=i%>" class="style2" style="width:100%;" value="<%=iv.getRefNumber()%>"></td>
		<td><%=Html.datePicker("invoice_invoice_date_"+i, iv.invoice_date)%></td>
		<td><input type="text" name="invoice_amount_local_<%=i%>" id="invoice_amount_local_<%=i%>" class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(iv.amount_local,_dec)%>"></td>
		<td><input type="text" name="invoice_vat_<%=i%>" id="invoice_vat_<%=i%>" class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(iv.vat,0)%>"></td>
		<th align="right"><%=Numeric.numberToStr(iv.vat_local,_dec)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(iv.total_amount_local,_dec)%>&nbsp;</th>
		<th><input type="text" name="invoice_remark_<%=i%>" id="invoice_remark_<%=i%>" class="style2" style="width:100%;" value="<%=iv.remark%>"></th>
		<td align="center"><a href="JavaScript:saveInvoice(<%=i%>)" class="style2" style="display:<%=displayed%>">Save</a></td>
	    <td align="center"><a href="JavaScript:deleteInvoice(<%=i%>)" class="style2" style="display:<%=displayed%>">Delete</a></td>
	    <td>&nbsp;</td>
	</tr>
<%
	}
%>
	<tr bgcolor="#DDDDDD">
	    <th align="right" bgcolor="#DDDDDD">&nbsp;</th>
		<th colspan="2">Total</th>
		<th align="right"><%=Numeric.numberToStr(siv.amount_local,_dec)%>&nbsp;</th>
		<th align="right">&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(siv.vat_local,_dec)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(siv.total_amount_local,_dec)%>&nbsp;</th>
		<th align="right">&nbsp;</th>
		<td align="center">&nbsp;</td>
	    <td align="center">&nbsp;</td>
	    <td>&nbsp;</td>
	</tr>
</table>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
	<tr>
		<td align="right"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost();"></td>
	</tr>
</table>

<input type="hidden" name="letter_type"  id="letter_type"  value="<%=finance.letter_type%>">
<input type="hidden" name="no"  id="no"  value="-1">
	
<script language="javascript">
	var o = getObj("frow_" + getValue("finance_id"));
	highlightOn(o,1);

	if (readonly) 
	{
		hide("update_btn");
    }
	
	setCbxById("completed_");

	if (<%=finance.isNew()%>) {	
		var idx = addNewListItem(document.formMain.finance_id,"<%=finance.getRefNumber()%>");
		var radios = document.getElementsByTagName('input'); 
		for (var i = 0; i < radios.length; i++) {     
			var o = radios[i];
			if (o.type === 'radio' && o.checked && o.name === 'letter_id') { 
				o.checked = false;
			} 
		} 	
	}

</script>