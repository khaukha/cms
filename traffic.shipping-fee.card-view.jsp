
<%
	int fee_type_id = task.getFeeTypeId();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

var readonly = <%=task.isReadOnly()%>;

function selectAll(cbx)
{
	if (cbx == null) {
		cbx = getObj("select_all");
		cbx.checked = false;
	}
	for (i = 0;; i++) {
		var o = getObj("shipping_fee_sel_" + i + "_");
		if (o == null) break;
		o.checked = cbx.checked
		//alert(o.checked);
		setCbx(o, o.checked ? 1 : 0);
	}
}

function billClick(row)
{
	highlightOn(row,0);	
}

function newBill()
{
	if (getValue("fee_type_id") == 0) {
		selectAll(null);
		//alert("Please select a fee type.");
		//return;
	}
	show("new_shipping_bill_");
	show("new_shipping_bill_desc_");
	var cbx = getObj("select_all");
	cbx.checked = false;
	selectAll(cbx);
	var radio = getObj("shipping_bill_radio");
	radio.checked = true;
	radio.disabled = false;
	var no = <%=requester.getInt("no",0)%>
	hide("del_" + no);
	hide("sav_" + no);

	show("del_" + 0);
	show("sav_" + 0);
}

function saveShippingBill(no)
{
	if (getValue("fee_type_id") == 0) {
		//alert("Please select a fee type.");
		//return;
	}
	if (getValue("bill_date_" + no) == '') {
		alert("Please input Bill Date");
		return;
	}
	if (getValue("bill_no_" + no) == '') {
		//alert("Please input Bill No.");
		//return;
	}
	setValue("no", no);
	doTask(1);		
}

function deleteShippingBill(no)
{
	if (!confirm("Are you sure to delete Bill Ref. " + getValue("ref_number_" + no))) {	
		return;
	}
	selectAll(null);
	doTask(2);
}

function selectShippingBill(no)
{
	if (getValue("shipping_bill_id_" + no) > 0) {
		setValue("no", no);
		doPost();
	}
}

function updateShippingFees()
{
	if (<%=shipping_bill_id%> <= 0) {
		alert("Please select a Bill.");
		return;
	}
	doTask(3);
}

function printShippingInvoice()
{
	doTask(5);
}


</script>

<form method="POST" name="formMain" action="" onSubmit="">				  
<table width="100%" cellpadding="0" cellspacing="0"  border="0" class="style2" style="padding-top:">
	<tr>
		<td width="50" align="right"><strong>Month</strong> &nbsp;</td>
		<td width="70" align="right"><select name="month_end" id="month_end" size=1 class="style2" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getShippingFeeDao().getMonthFilter(),sc.month_end,"All")%></select></td>
		<td width="40" align="right"><strong>Fee</strong> &nbsp;</td>
		<td width="130"><select name="fee_type_id" id="fee_type_id" size=1 class="style2" style="width:100%;" onChange="doPost();">
			<%=Html.selectOptions(dao.getFeeTypeDao().selectAll(),fee_type_id)%>
			<option  id="x" value="0">Others</option>
        </select></td>
		<td align="right" width="120">Stuffing Date From&nbsp;</td>
		<td width="94"><%=Html.datePicker("stuffing_date_from",requester.getDate("stuffing_date_from"))%></td>
		<td align="center" width="10">&nbsp;To&nbsp;</td>
		<td width="94"><%=Html.datePicker("stuffing_date_to",requester.getDate("stuffing_date_to"))%></td>
		<td>&nbsp; <a href="JavaScript:doPost()">Submit</a></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>
<%String disabled = (fee_type_id == 0 ? "disabled" : "");%>
<table width="100%" cellpadding="0" cellspacing="0"  border="0" class="style11">
	<tr>
		<td width=""><table width="" cellpadding="0" cellspacing="0" class="style11">
			<tr>
				<td valign="top"><table width="" cellpadding="0" cellspacing="1" class="style11">
						<tr bgcolor="#DDDDDD">
							<th width="80" rowspan="2">SI Ref.</th>
							<th width="70" rowspan="2">Stuffing<br />Date</th>
							<th width="60" rowspan="2">Tons</th>
							<th width="40" rowspan="2">Con.</th>
							<th width="80" rowspan="2">Booking No.</th>
							<th colspan="2">Amount(<%=location.currency%>)</th>
							<th width="24" rowspan="2"><input type="checkbox" name="select_all" id="select_all" value="1" onclick="selectAll(this)" <%=disabled%> /></th>
							<th width="18" rowspan="2">&nbsp;</th>
						</tr>
						<tr bgcolor="#DDDDDD">
							<th width="80">Estimation</th>
							<th width="80">Invoice</th>
						</tr>
				</table></td>
			</tr>
			<tr>
				<td style="padding-left:1"><div style="border-style:solid; border-width:1; width:; height:320; overflow:scroll">
		<table width="" cellpadding="0" cellspacing="1" class="style11">
<%
  ShippingEntity sum_si = dao.getShippingDao().newEntity();
  List<ShippingEntity> sis = task.getShippings();
  double sum_fee_local = 0;
  double sum_inv_local = 0;  
  for (int i = 0; i < sis.size(); i++) {
  	ShippingEntity si = sis.get(i);
	ShippingFeeEntity fee = si.getShippingFee();
	ShippingBillFeeEntity sbf = dao.getShippingBillFeeDao().getByKey(shipping_bill_id, fee.getIdLong());
	double fee_local = fee.getFeeVnd(fee_type_id);
	double inv_local = fee.getInvVnd(fee_type_id);
	sum_fee_local += fee_local;
	sum_inv_local += inv_local;
	sum_si.add(si);
%>				
				<input type="hidden" name="shipping_fee_id_<%=i%>" id="shipping_fee_id_<%=i%>" value="<%=fee.getIdLong()%>">	
				<tr onclick="highlightOn(this,1)">
					<td width="78"><a href="JavaScript:viewSI(<%=si.getIdLong()%>)"><%=si.getShortRef()%></a></td>
					<td width="70" align="center"><%=DateTime.dateToStr(si.stuffing_date)%></td>
					<td width="60" align="right"><%=Numeric.numberToStr(si.delivered_tons,2)%>&nbsp;</td>
					<td width="40" align="right"><%=Numeric.numberToStr(si.no_of_containers,1)%>&nbsp;</td>
					<td width="80"><%=si.booking_no%></td>
					<td width="80" align="right"><%=Numeric.numberToStr(fee_local,_dec)%>&nbsp;</td>
					<td width="80" align="right"><%=Numeric.numberToStr(inv_local,_dec)%>&nbsp;</td>
					<td width="24" align="center"><%=Html.checkBox("shipping_fee_sel_" + i,!sbf.isNull(),"",disabled)%></td>
				  </tr>
<%
	}
%>						
		</table></div></td>
			</tr>
	<tr>
		<td><table width="" cellpadding="0" cellspacing="1" class="style11">
				<tr bgcolor="#DDDDDD" style="padding:1" align="right">
					<td width="54">&nbsp;</td>
					<td width="70">&nbsp;</td>
					<th width="60"><%=Numeric.numberToStr(sum_si.delivered_tons,2)%></th>
					<th width="40"><%=Numeric.numberToStr(sum_si.no_of_containers,2)%></th>
					<td width="80">&nbsp;</td>
					<th width="80"><%=Numeric.numberToStr(sum_fee_local,_dec)%>&nbsp;</th>
					<th width="80"><%=Numeric.numberToStr(sum_inv_local,_dec)%></th>
					<th width="24" align="center"><img src="../shared/images/update.gif" onclick="updateShippingFees()" style="display:<%=displayed%>" /></th>
					<th width="17">&nbsp;</th>
				  </tr>
			</table></td>
	</tr>
		</table></td>
		<td width="" valign="top"><table width="" cellpadding="0" cellspacing="0"  border="0" class="style11">
			<tr>
				<td><table width="" border="0" cellpadding="0" cellspacing="1" class="style11">
				<tr bgcolor="#DDDDDD">
				    <th width="100" rowspan="2">Bill Ref.</th>
					<th width="94" rowspan="2">Bill Date</th>
					<th width="88" rowspan="2">Bill No</th>
					<th width="80">Amount</th>
					<th width="200" rowspan="2" style="display:none">Description</th>
				    <th width="24" rowspan="2">&nbsp;</th>
				    <th width="24" rowspan="2">Del</th>
				    <th width="24" rowspan="2">Sav</th>
			        <th width="17" rowspan="2">&nbsp;</th>
				</tr>
				<tr bgcolor="#DDDDDD">
				  <th>(<%=location.currency%>)</th>
				  </tr>
				</table></td>
			</tr>
			<tr>
				<td style="padding-left:1; padding-right:1"><div style="border-style:solid; border-width:1; width:; height:320; overflow:scroll">
					<table width="100%" cellpadding="0" cellspacing="1" class="style11">
<%
	List<ShippingBillEntity> bills = task.getShippingBills();
	ShippingBillEntity bill = dao.getShippingBillDao().newEntity();
	bill.setNew();
	bill.fee_type_id = task.getFeeTypeId();
	bill.ref_number = dao.getShippingBillDao().newRefNumber();
	bills.add(0,bill);
	double sum_amount_local = 0;
	for (int i = 0; i < bills.size(); i++) {
		bill = bills.get(i);
		sum_amount_local += bill.amount_local;
		String disp = (bill.getIdLong() > 0 && bill.getIdLong() != shipping_bill_id ) ? "none" : displayed;
%>				
				<input type="hidden" name="shipping_bill_id_<%=i%>" id="shipping_bill_id_<%=i%>" value="<%=bill.getIdLong()%>">	
				<tr id="<%=bill.isNew()?"new_shipping_bill_":""%>" onclick="billClick(this)" style="display:<%=bill.isNew()?"none":""%>">
				    <td width="100"><input name="ref_number_<%=i%>" type="text" id="ref_number_<%=i%>"   class="style11" style="width:100%;" value="<%=bill.getRefNumber()%>" readonly /></td>
					<td width="94"><%=Html.datePicker("bill_date_" + i,bill.bill_date,"style11")%></td>
					<td width="88"><input name="bill_no_<%=i%>"     type="text" id="bill_no_<%=i%>"     class="style11" style="width:100%;" value="<%=bill.bill_no%>" /></td>
					<td width="80"><input name="amount_local_<%=i%>"  type="text" id="amount_local_<%=i%>"  class="style11" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(bill.amount_local,_dec)%>" /></td>
					<td  width="200" style="display:none">&nbsp;</td>
				    <td width="24" align="center"><input name="shipping_bill_id" id="<%=bill.isNew()?"shipping_bill_radio":""%>" type="radio" value="<%=bill.getIdLong()%>" <%=shipping_bill_id==bill.getIdLong() ? "checked" : ""%> onclick="selectShippingBill(<%=i%>)" <%=bill.isNew()?"disabled":""%> /></td>
				    <td width="24" align="center"><img id="del_<%=i%>" src="../shared/images/delete.gif" onclick="deleteShippingBill(<%=i%>)" style="display:<%=disp%>" /></td>
				    <td width="24" align="center"><img id="sav_<%=i%>" src="../shared/images/update.gif" onclick="saveShippingBill(<%=i%>)" style="display:<%=disp%>" /></td>
			      </tr>
				  <tr id="<%=(bill.isNew() && bill.fee_type_id==0)?"new_shipping_bill_desc_":""%>" style="display:<%=(bill.getIdLong() > 0 && bill.fee_type_id==0)?"":"none"%>">
				  	<td colspan="8"><input name="description_<%=i%>" type="text" id="description_<%=i%>" class="style11" style="width:100%;" value="<%=bill.description%>" /></td>
				  </tr>
<%
	}
%>
					</table>
				</div></td>
			</tr>
		 <tr>
		 	<td><table width="" cellpadding="0" cellspacing="1"  border="0" class="style11">
				<tr bgcolor="#DDDDDD">
				    <td width="100"><img src="../shared/images/new.gif" onclick="newBill()" style="display:<%=displayed%>" /></td>
					<td width="94">&nbsp;</td>
					<td width="88">&nbsp;</td>
					<th width="80" align="right"><%=Numeric.numberToStr(sum_amount_local,_dec)%>&nbsp;</th>
					<td width="200" style="display:none">&nbsp;</td>
					<td width="24">&nbsp;</td>
					<td width="24">&nbsp;</td>
					<td width="24">&nbsp;</td>
					<td width="17">&nbsp;</td>
				  </tr>				
			</table></td>
		 </tr>
		</table></td>
	</tr>
</table>

<table width="100%" cellpadding="0" cellspacing="0"  border="0" class="style2" style="padding-top:1">
	<tr style="display:">
	  <td align="right"><table width="100%" border="0" cellpadding="0" cellspacing="0">
	  		<tr style="padding:1">
				<td>&nbsp;</td>
				<td width="60" align="right"><img src="../shared/images/print.jpg" onClick="printShippingInvoice()"></td>
				<td width="60" align="right"><img src="../shared/images/listview.jpg" onClick="doListView();"></td>
			</tr>
	  	</table></td>
    </tr>
</table>
	<input type="hidden" name="no" id="no" value="<%=requester.getInt("no",-1)%>">	


<script language="javascript">
	//alert(getObj("shipping_bill_div").offsetHeight) = "376px";
	//alert(getObj("x"));
	setValue("fee_type_id", <%=fee_type_id%>);
	//getObj("x").selected = true;
	if (completed || readonly) {
		//setCompletedElements("inst_id","contract_id","search_key");
	}	
</script>


