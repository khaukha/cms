<%
	SaleContractEntity contract = task.getContract();
	SaleInvoiceEntity invoice = task.getInvoice(contract);
	task.doTask(invoice);
	List<SaleInvoiceEntity> ivs = (List)contract.getProvisionalInvoices();
	ivs.addAll(contract.getPreShipmentInvoices());
	if (invoice.isNew()) {
		ivs.add(invoice);
	}
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function contractClick(obj)
{
	getObj("invoice_id_new").checked = false;
	var o = getObj("invoice_id_0");
	if (o != null) o.checked = true;
	itemSelected(obj);
}

function invoiceClick(type)
{
	setValue("type",type);
	doPost();
}

function saveInvoice(no)
{
	setValue("no", no);
	doTask(1);
}

function deleteInvoice(inv_ref)
{
	if (!<%=invoice.isEmpty()%>) {
		alert("Please remove all SIs from this Invoice first.");
		return;
	}
	if (confirm("Are you sure to delete " + inv_ref)) {
		doTask(2);
	}
}

function shippingSelect(inst_id, no)
{
	if (<%=invoice.getIdLong() <= 0%>) {
		alert("Please save the invoice fisrt.");
		return;
	}
	setValue("inst_id", inst_id);
	setValue("no", no);
	doTask(3);
}

function printInvoice()
{
	doTask(4);
}

function newInvoice(type)
{
	getObj("invoice_id_new").checked = true;
	setValue("type", type);
	doPost();
}	

function shippingClick()
{
	doPost();
}
function finInvoiceSelect(fin_invoice_id,no)
{
	setValue("fin_invoice_id", fin_invoice_id);
	setValue("no", no);
	doTask(5);
}

function saveFinalInvoice(fin_invoice_id, no)
{
	setValue("fin_invoice_id", fin_invoice_id);
	setValue("no", no);
	doTask(6);
}

function printFinalInvoice(fin_invoice_id)
{
	if (fin_invoice_id <= 0) {
		alert("Pleasave select invoice before printing.");
		return;
	}
	setValue("fin_invoice_id",fin_invoice_id);
	doTask(7);
}
</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr>
		<th width="120" style="color:#FF0000; font-size:12px; font-family:"Times New Roman", Times, serif">INVOICES</th>
		<td width="120"><select name="filter_forwarder_id" id="filter_forwarder_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getForwarderFilter(),sc.filter_forwarder_id,"Forwarder (All)")%></select></td>
		<td width="80"><select name="filter_status" id="filter_status" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"Status (All)")%></select></td>
		<td width="120"><select name="filter_buyer_id" id="filter_buyer_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"Buyer (All)")%></select></td>
		<td width="200"><select name="filter_grade_id" id="filter_grade_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getGradeFilter(),sc.filter_grade_id,"Grade (All)")%></select></td>
		<td>&nbsp;</td>
		<td align="right"><%@include file="search.jsp"%></td>
  </tr>
</table>		
<table width="100%" cellpadding="0" cellspacing="1"  border="0" class="style2">
	<tr bgcolor="#DDDDDD">
		<th width="120">Sales Ref.</th>
		<th><%=contract.getRefNumber()%></th>
	</tr>
	<tr valign="top">
		<td><select name="contract_id" size=20 class="style11" id="contract_id" style="width:120;" onChange="contractClick(this);"><%=Html.selectOptionsX(dao.getSaleContractDao().list(),sc.contract_id,"All")%></select></td>
		<td>
<div style="border:thin; border-style:solid; border-width:1; border-left:;border-right:0; width:100%; height:">		
<table width="100%" cellpadding="0" cellspacing="1"  border="0" class="style11">
	<tr bgcolor="#DDDDDD">
		<th width="42">Id</th>
		<th width="100">Sales Ref</th>
		<th width="94">Date </th>
		<th width="80">Quality</th>
		<th width="80">Grade</th>
		<th width="80">Packing</th>
		<th width="50">Qty</th>
		<th width="60">Net (Mt)</th>
		<th width="60">Price</th>
		<th width="70">Currency</th>
		<th width="120">Forwarder</th>
		<th>&nbsp;</th>
	</tr>
	<tr bgcolor="#EEEEEE">
		<th align="right" bgcolor="#DDDDDD"><%=contract.getIdLong()%>&nbsp;</th>
		<td><%=contract.getRefNumber()%></td>
		<td align="center"><%=DateTime.dateToStr(contract.contract_date)%></td>
		<td><%=contract.getGrade().getQuality().short_name%></td>
		<td><%=contract.getGrade().short_name%></td>
		<td><%=contract.getPacking().short_name%></td>
		<td align="right"><%=Numeric.numberToStr(contract.no_of_bags,0)%>&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(contract.tons,2)%>&nbsp;</td>		
		<td align="right"><%=Numeric.numberToStr(contract.getPrice(),2)%>&nbsp;</td>
		<td><%=contract.getPriceUnit().short_name%>&nbsp;</td>
		<td><%=contract.getForwarder().short_name%></td>
		<td>&nbsp;</td>
	</tr>
</table>		
<table width="100%" cellpadding="0" cellspacing="1"  border="0" class="style11">
			<tr bgcolor="#CCFFFF">
			  <th width="42" rowspan="2">Id</th>
				<th width="100" rowspan="2">Invoice Ref</th>
				<th width="94" rowspan="2">Invoice Date </th>
				<th width="80" rowspan="2">Packing</th>
				<th width="50" rowspan="2">Qty</th>
				<th width="60" rowspan="2">Net (Mt)</th>
				<th width="50" rowspan="2">Exch.<br>Rate</th>
				<th width="60" rowspan="2">Price</th>
				<th width="70" rowspan="2">Currency</th>
				<th colspan="2">Amount</th>
				<th width="30" rowspan="2"><input name="invoice_id" id="invoice_id_new" type="radio" value="-1" style="display:none" /></th>
				<td align="center" colspan="2"><a href="JavaScript:newInvoice('P')" style="display:">New Pro.Invoice</a></td>
				<th width="50" rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
			</tr>
			<tr bgcolor="#CCFFFF">
			  <th width="70">USD</th>
	          <th width="80">UGX</th>
		      <td align="center" colspan="2"><a href="JavaScript:newInvoice('S')" style="display:">New Pre.Invoice</a></td>
        </tr>
<%
	for (int i = 0; i < ivs.size(); i++) {
		SaleInvoiceEntity iv = ivs.get(i);
		//if (iv.isFinal()) continue;
		SaleContractEntity ct = iv.getContract();
		String currency = iv.isProvisional() ? "UGX/Bag" : ct.getPriceUnit().short_name;
		boolean is_selected = iv.getIdLong()==invoice.getIdLong();
		String _disp = is_selected?"":"none";
%>			
			<tr onClick="highlightOn(this,0)" bgcolor="#EEEEEE" id="invoice_<%=iv.getIdLong()%>">
			  <th align="right" bgcolor="#DDDDDD"><%=iv.getIdLong()%>&nbsp;</th>
				<td><%=iv.getShortRef()%></td>
				<td><%=Html.datePicker("invoice_date_"+i, iv.invoice_date, "style11", iv.getIdLong()==invoice.getIdLong()||iv.isNew()?"":"disabled")%></td>
				<td><%=ct.getPacking().short_name%></td>
				<td align="right"><%=Numeric.numberToStr(iv.no_of_bags,0)%>&nbsp;</td>
				<td align="right"><%=Numeric.numberToStr(iv.net_weight/1000,2)%>&nbsp;</td>
				<td align="right"><%=Numeric.numberToStr(iv.exchange_rate,0)%>&nbsp;</td>
				<td><input type="text" name="price_<%=i%>" id="price_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(iv.getPrice(),2)%>" <%=(iv.isProvisional()&&is_selected)||iv.isNew()?"":"disabled"%>></td>
				<td><%=currency%></td>
				<td align="right"><%=Numeric.numberToStr(iv.amount_usd,2)%>&nbsp;</td>
				<td align="right"><%=Numeric.numberToStr(iv.amount_local,0)%>&nbsp;</td>
				<td align="center"><input name="invoice_id" id="invoice_id_<%=i%>" type="radio" value="<%=iv.getIdLong()%>" <%=is_selected?"checked":""%> onClick="invoiceClick('<%=iv.getType()%>')" /></td>
				<td width="50" align="center"><a href="JavaScript:saveInvoice(<%=i%>)" style="display:<%=_disp%>">Save</a></td>
				<td width="50" align="center"><a href="JavaScript:deleteInvoice('<%=iv.getShortRef()%>')" style="display:<%=_disp%>">Delete</a></td>
				<td width="50" align="center"><a href="JavaScript:printInvoice()" style="display:<%=_disp%>">Print</a></td>
				<td>&nbsp;</td>
			</tr>
<%
	}
%>			
</table>
<table width="100%" cellpadding="0" cellspacing="1"  border="0" class="style11">
			<tr bgcolor="#CCFFFF">
			  <th width="42" rowspan="2">Id</th>
				<th width="100" rowspan="2">Shipping Ref</th>
				<th width="120" rowspan="2">Forwarder</th>
				<th width="80" rowspan="2">Packing</th>
				<th width="60" rowspan="2">Qty</th>
				<th width="60" rowspan="2">Net (Mt)</th>
				<th colspan="3">Invoice</th>
				<th width="30" rowspan="2">&nbsp;</th>
				<th rowspan="2">&nbsp;</th>
			</tr>
			<tr bgcolor="#CCFFFF">
			  <th width="110">Provisional</th>
	          <th width="110">Preshipment</th>
		      <th width="40">Select</th>
		</tr>
<%
	ShippingEntity ssi = dao.getShippingDao().newEntity();
	List<ShippingEntity> sis = contract.getShippings();
	for (int i = 0; i < sis.size(); i++) {
		ShippingEntity si = sis.get(i);
		ssi.add(si);
		ProvisionalInvoiceEntity pro_iv = si.getProvisionalInvoice();
		PreShipmentInvoiceEntity pre_iv = si.getPreShipmentInvoice();
		long iv_id = invoice.isProvisional() ? si.pro_invoice_id : si.pre_invoice_id;
		SaleInvoiceEntity _iv = invoice.isProvisional() ? pro_iv : pre_iv;
		String _dis = "";
		String pro_cl = invoice.isProvisional() ? "#0000FF;font-weight:bold" : "";
		String pre_cl = invoice.isPreShipment() ? "#0000FF;font-weight:bold" : "";
		if (!_iv.isNull() && _iv.getIdLong() != invoice.getIdLong()) {
			_dis = "disabled";
			pro_cl = invoice.isProvisional() ? "" : "";
			pre_cl = invoice.isPreShipment() ? "" : "";
		}
%>			
			<tr bgcolor="#EEEEEE" onClick="highlightOn(this,1)">
			    <th id="_shipping_<%=si.getIdLong()%>" align="right" bgcolor="#DDDDDD"><%=si.getIdLong()%>&nbsp;</th>
				<td><%=si.getShortRef()%></td>
				<td><%=si.getForwarder().short_name%></td>
				<td><%=si.getPacking().short_name%></td>
				<td align="right"><%=Numeric.numberToStr(si.no_of_bags,0)%>&nbsp;</td>
				<td align="right"><%=Numeric.numberToStr(si.tons,2)%>&nbsp;</td>
				<td style="color:<%=pro_cl%>"><%=pro_iv.getShortRef()%></td>
				<td style="color:<%=pre_cl%>"><%=pre_iv.getShortRef()%></td>
				<td align="center"><%=Html.checkBox("shipping_"+i,iv_id==invoice.getIdLong(),"shippingSelect("+si.getIdLong()+","+i+")",_dis)%></td>
				<td align="center"><input name="inst_id" id="inst_id_<%=i%>" type="radio" value="<%=si.getIdLong()%>" <%=si.getIdLong()==sc.inst_id?"checked":""%> onClick="shippingClick()" /></td>
				<td>&nbsp;</td>
			</tr>
<%
	}	
%>			
		<tr bgcolor="#DDDDDD">
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th align="right"><%=Numeric.numberToStr(ssi.no_of_bags,0)%>&nbsp;</th>
			<th align="right"><%=Numeric.numberToStr(ssi.tons,2)%></th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
	</table>
</div>		
</td>
	</tr>
	<tr>
		<td style="color:#0033FF;">&nbsp;<strong>Final Invoices</strong></td>
		<td align="right"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost();">&nbsp;</td>
	</tr>
</table>
<div style="border:thin; border-style:solid; border-width:1; border-left:0;border-right:0; width:100%;">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" style="font-weight:bold" align="center">
                <td width="42">Id&nbsp;</td>
                <td width="100">Final Invoice</td>
                <td width="94">Invoice<br>Date </td>
                <td width="84">WN-EX Ref </td>
                <td width="90">Drop-off<br>Container No</td>
                <td width="94">Docs H/Over<br>Date</td>
                <td width="94">Despatch<br>Date</td>
                <td width="94">Arrival<br>Date</td>
                <td width="90">Export<br>Container No</td>
                <td width="56">UCDA<br>Seal No </td>
                <td width="56">ACE<br>Seal No</td>
                <td width="40">Bags</td>
                <td width="50">Net<br>(Kgs)</td>
                <td width="50">Price<br>(Cts/Lb)</td>
                <td width="70">Amount<br>(USD)</td>
                <td width="30">Sel.</td>
                <td width="36">&nbsp;</td>
                <td width="36">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
<%
	List<FinalInvoiceEntity> fivs = contract.getFinalInvoices();	
	//List<WnExportEntity> cons = shipping.getWeightNotes();
	//WnExportEntity _wn = dao.getWnExportDao().newEntity(shipping);
	//_wn.status = 2;
	//cons.add(_wn);
	WnExportEntity swn = dao.getWnExportDao().newEntity();
	FinalInvoiceEntity siv = dao.getFinalInvoiceDao().newEntity();
	//int grade_id = shipping.grade_id;
	for (int i = 0; i < fivs.size(); i++) {
		FinalInvoiceEntity iv = fivs.get(i);
		WnExportEntity wn = iv.getWnExport();
		WnExportEntity con = wn;
		ShippingEntity si = wn.getShipping();
		swn.addTons(wn);		
		long wne_id = con.getIdLong();
		siv.add(iv);
		String _dis = "";
		if (!si.isNull() && si.getIdLong() != sc.inst_id) {
			_dis = "disabled";
		}
%>
              <input type="hidden" name="wn_id_<%=i%>"  id="wn_id_<%=i%>"  value="<%=wn.getIdLong()%>">
              <input type="hidden" name="status_<%=i%>" id="status_<%=i%>" value="<%=wn.status%>">
              <tr id="wn_<%=i%>" onClick="highlightOn(this,2);" style="display:<%=con.isNull()?"none":""%>">
                <th bgcolor="#DDDDDD" align="right"><%=iv.getIdLong()%>&nbsp;</th>
                <td><%=iv.getShortRef()%></td>
                <td><%=Html.datePicker("fin_invoice_date_" + i, iv.invoice_date,"style11")%></td>
                <td><%=con.getShortRef()%></td>
                <td><input type="text" name="container_no_<%=i%>"  id="container_no_<%=i%>"  class="style11" style="width:90;" value="<%=con.container_no%>" onKeyUp="toUpper(this);"></td>
                <td><%=Html.datePicker("docs_handover_date_" + i, con.docs_handover_date,"style11")%></td>
                <td><%=Html.datePicker("despatch_date_" + i, con.despatch_date,"style11")%></td>
                <td><%=Html.datePicker("arrival_date_" + i, con.arrival_date,"style11")%></td>
                <td><input type="text" name="export_container_no_<%=i%>"  id="export_container_no_<%=i%>"  class="style11" style="width:90;" value="<%=con.export_container_no%>" onKeyUp="toUpper(this);"></td>
                <td><input type="text" name="seal_no_<%=i%>"       id="seal_no_<%=i%>"       class="style11" style="width:56;" value="<%=con.seal_no%>"></td>
                <td><input type="text" name="ace_seal_no_<%=i%>"      id="ace_seal_no_<%=i%>"      class="style11" style="width:56;" value="<%=con.ace_seal_no%>" onKeyUp="toUpper(this);"></td>
                <td><input type="text" name="no_of_bags_<%=i%>"    id="no_of_bags_<%=i%>"    class="style11" style="width:40; text-align:right" value="<%=con.no_of_bags%>"></td>
                <th align="right"><%=Numeric.numberToStr(con.net_weight,0)%>&nbsp;</th>
                <th align="right"><%=Numeric.numberToStr(iv.price_cts,2)%>&nbsp;</th>
                <th align="right"><%=Numeric.numberToStr(iv.amount_usd,2)%>&nbsp;</th>
                <td align="center"><%=Html.checkBox("fin_invoice_"+i,wn.inst_id==sc.inst_id,"finInvoiceSelect("+iv.getIdLong()+","+i+")",_dis)%></td>
                <td align="center"><a href="JavaScript:saveFinalInvoice(<%=iv.getIdLong()%>)" style="display:<%=displayed%>">Save</a></td>
                <td align="center"><a href="JavaScript:printFinalInvoice(<%=iv.getIdLong()%>)" style="display:<%=displayed%>">Print</a></td>
                <td align="center">&nbsp;</td>
              </tr>
<%
	}
%>
              <tr style="font-weight:bold" bgcolor="#DDDDDD">
                <th><img src="../shared/images/new.gif" title="New Final Invoice" onClick="newFinalInvoice(<%=fivs.size()-1%>)" style="display:none"></th>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right">Total&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(swn.no_of_bags,0)%>&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(swn.net_weight,0)%>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(siv.amount_usd,2)%>&nbsp;</td>
                <td style="display:">&nbsp;</td>
                <td style="display:">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
  </table>
</div>
	<input type="hidden" name="no" id="no" value="-1">	
	<input type="hidden" name="inst_id" id="inst_id" value="0">	
	<input type="hidden" name="fin_invoice_id" id="fin_invoice_id" value="0">	
	<input type="hidden" name="type" id="type" value="<%=invoice.getType()%>">	

<script language="javascript">
	highlightOn(getObj("invoice_<%=sc.invoice_id%>"),0);
	highlightOn(getObj("shipping_<%=sc.inst_id%>"),0);
</script>


