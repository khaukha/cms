<%
	SaleContractEntity contract = task.getContract();
	SaleInvoiceEntity invoice = task.getInvoice();
	ShippingEntity shipping = invoice.getShipping();
	task.doTask(invoice);
	List<SaleInvoiceEntity> ivs = (List)contract.getProvisionalInvoices();
	ivs.addAll(contract.getPreShipmentInvoices());
	boolean completed = shipping.isCompleted();
	String dis = shipping.getIdLong()==0?"disabled":"";
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

var completed = <%=shipping.status == 2%>;
var readonly = <%=task.isReadOnly()%>;

function invoiceSelect(invoice_id, type)
{
	setValue("invoice_id",invoice_id);
	setValue("type",type);
	doPost();
}

function shippingSelect(inst_id, no)
{
	setValue("inst_id", inst_id);
	setValue("no", no);
	doTask(1);
}

function new_SI()
{
	var name = "Shipping Instruction";
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract for this " + name);
		return;
	}
	if (addNewListItemById("inst_id","New Item") >= 0) doPost();
}

function sav_SI()
{
	if (getValue("inst_id") != 0) doTask(1);
}

function del_SI()
{
	var inst_id = getValue("inst_id");
	if (inst_id == 0) {
		alert("Please select a Shipping Instruction");
		return;
	}
	if (inst_id < 0) return;
	if (confirm("Are you sure to delete " + getSelectedText("inst_id"))) {
		doTask(3);
	}
}

function new_Container(i)
{
	show("wn_" + i);
	highlightOn(getObj("wn_" + i),1);
}	

function sav_Container(i)
{
	setValue("no", i);
	doTask(7);
}

function del_Container(i)
{
	if (getValue("wn_id_" + i) < 0) {
		hide("wn_" + i);
		return;
	}
	if (confirm("Are you sure to delete " + getValue("ref_number_" + i))) {
		setValue("no", i);
		doTask(8);
	}
}

function doPrint(task_id)
{
	var inst_id = getValue("inst_id");
	if (inst_id == 0) {
		alert("Please select a Shipping Instruction.");
		return;
	}
	if (inst_id < 0) {
		alert("Please save Shipping Instruction before printing.");
		return;
	}
	doTask(task_id);
}

function doInvoicing(cbx)
{
	if (<%=shipping.getIdLong()%> <= 0) {
		alert("Please save SI before creating invoice");
		return;
	}
	if (cbx.checked) {
		var bl_date = getValue("bill_of_lading_date");
		if (bl_date != "") {
			setValue("invoice_date",bl_date);
			setValue("due_date",bl_date);
		}
		show("invoice_");
	} else {
		hide("invoice_");
	}
	cbxClick(cbx);
}

function doShippingFee(task_id)
{
	if (<%=shipping.getIdLong()%> <= 0) {
		alert("Please select a Shipping Instruction first.");
		return;
	}
	doTask(task_id);
}

function saveShippingCost()
{
	doShippingFee(13);
}

function newShippingFee()
{
	doShippingFee(14);
}

function saveShippingFee()
{
	doShippingFee(15);
}

function allocate(no)
{
	show("wnc_alloc_" + no);
}

function printFinalInvoice(invoice_id, no)
{
	if (invoice_id <= 0) {
		alert("Please update and save invoice before printing.");
		return;
	}
	setValue("invoice_id",invoice_id);
	setValue("no",no);
	doTask(9);
}
</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="100"><img src="images/shipping-instruction.jpg"></td>
		<td width="100"><select name="type" id="type" size=1 class="style11" style="width:100%;" onChange="doPost();">
		<option value="P" <%=sc.type=='P'?"selected":""%>>Provisional</option>
		<option value="S" <%=sc.type=='S'?"selected":""%>>Pre-Shipment</option>
		<option value="F" <%=sc.type=='F'?"selected":""%>>Final</option>
		</select></td>
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
		<th width="120">&nbsp;</th>
		<th width="130">&nbsp;</th>
		<th><%=contract.getRefNumber()%></th>
	</tr>
	<tr valign="top">
		<td><select name="contract_id" size=20 class="style11" id="contract_id" style="width:120;" onChange="doPost();"><%=Html.selectOptionsX(dao.getSaleContractDao().list(),sc.contract_id,"All")%></select></td>
		<td><select name="_invoice_id" size=20 class="style11" id="_invoice_id" style="width:130;" onChange="doPost();"><%=Html.selectOptionsX(ivs,sc.invoice_id,"All")%></select></td>
		<td rowspan="2">
<table width="100%" cellpadding="0" cellspacing="1"  border="0" class="style2">
			<tr bgcolor="#CCFFFF">
				<th width="120">Sales Ref</th>
				<th width="120">Invoice Ref</th>
				<th width="80">Packing</th>
				<th width="60">Qty</th>
				<th width="60">Net (Mt)</th>
				<th width="60">EX. Rate</th>
				<th width="70">USD</th>
				<th width="80">UGX</th>
				<th width="80">&nbsp;</th>
				<th>&nbsp;</th>
			</tr>
<%
	for (int i = 0; i < ivs.size(); i++) {
		SaleInvoiceEntity iv = ivs.get(i);
		if (iv.isFinal()) continue;
		ShippingEntity si = iv.getShipping();
%>			
			<tr onClick="highlightOn(this,0)" bgcolor="#EEEEEE" align="center">
				<td><%=contract.getShortRef()%></td>
				<td><%=iv.getShortRef()%></td>
				<td><%=si.getPacking().short_name%></td>
				<td><%=Numeric.numberToStr(iv.no_of_bags,0)%></td>
				<td><%=Numeric.numberToStr(iv.net_weight/1000,2)%></td>
				<td><%=Numeric.numberToStr(iv.exchange_rate,0)%></td>
				<td><%=Numeric.numberToStr(iv.amount_usd,2)%></td>
				<td><%=Numeric.numberToStr(iv.amount_local,0)%></td>
				<td><input name="invoice_id" id="invoice_id_<%=i%>" type="radio" value="<%=iv.getIdLong()%>" <%=iv.getIdLong()==invoice.getIdLong()?"checked":""%> onClick="invoiceSelect(<%=iv.getIdLong()%>,'<%=iv.getType()%>')" /></td>
				<td>&nbsp;</td>
			</tr>
<%
	}
%>			
</table>
<table width="100%" cellpadding="0" cellspacing="1"  border="0" class="style2">
			<tr bgcolor="#CCFFFF">
				<th width="120">Sales Ref</th>
				<th width="120">Shipping Ref</th>
				<th width="80">Packing</th>
				<th width="60">Qty</th>
				<th width="60">Net (Mt)</th>
				<th width="60">Pro.</th>
				<th width="60">Pre.</th>
				<th width="80">&nbsp;</th>
				<th>&nbsp;</th>
			</tr>
<%
	List<ShippingEntity> sis = contract.getShippings();
	for (int i = 0; i < sis.size(); i++) {
		ShippingEntity si = sis.get(i);
		long iv_id = invoice.isProvisional() ? si.pro_invoice_id : si.pre_invoice_id;
		//si.getProvisionalInvoice().isNull();
		//isProvisional()
%>			
			<tr align="center" bgcolor="#EEEEEE">
				<td><%=contract.getShortRef()%></td>
				<td><%=si.getShortRef()%></td>
				<td><%=si.getPacking().short_name%></td>
				<td><%=Numeric.numberToStr(si.no_of_bags,0)%></td>
				<td><%=Numeric.numberToStr(si.tons,2)%></td>
				<td><%=Html.checkBox("shipping_"+i,iv_id==invoice.getIdLong(),"shippingSelect("+si.getIdLong()+","+i+")")%></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
<%
	}
%>			
</table>		
		</td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	  <td><img id="new_btn" src="images/new.gif" border="0" onClick="new_SI();">&nbsp;<img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="del_SI()"></td>
  </tr>
</table>


<table width="100%" cellpadding="0" cellspacing="0"  border="0" class="style2">
	<tr>
	  <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
        <tr>
          <td valign="top" width="120px"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
            <tr bgcolor="#DDDDDD">
			  <td align="center" width="120px"><strong>Contract Ref</strong></td>
              </tr>
            <tr>
              <td><select name="contract_id" size=20 class="style11" id="contract_id" style="width:120px;" onChange="doPost();"><%=Html.selectOptionsX(dao.getSaleContractDao().list(),sc.contract_id,"All")%></select></td>
              </tr>
          </table></td>
	  	  <td valign="top" width="130px"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
            <tr bgcolor="#DDDDDD">
			  <th align="center" width="130px">Invoice Ref</th>
            </tr>
            <tr>
              <td><select name="inst_id" size=20 class="style11" id="inst_id" style="width:130px;" onChange="doPost();"><%=Html.selectOptionsX(dao.getShippingDao().list(false),shipping.getIdLong(),"All")%></select></td>
            </tr>
        <tr style="display:<%=displayed%>">
          <td>
		  <img id="new_btn" src="images/new.gif" border="0" onClick="new_SI();">
		  <img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="del_SI()"></td>
          </tr>
          </table></td>
          <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
            <tr bgcolor="#DDDDDD">
              <td align="center"><strong>Detail</strong></td>
            </tr>
            <tr>
              <td><%@include file="traffic.si.input.jsp"%></td>
            </tr>
            <tr>
              <td><table width="100%"  border="0">
          <tr class="style2">
            <td width="20"><img id="save_btn_" src="../shared/images/update.gif" width="15" height="15" border="0" onClick="sav_SI()" style="display:<%=displayed%>"></td>
			<td>&nbsp;</td>
			<td align="right" width="90"><a href="JavaScript:doPrint(20)">Loading Order</a></td>
			<td align="right" width="60"><img src="../shared/images/report.jpg" onClick="doTask(12)" title="Report WN Allocation"></td>
			<td align="right" width="60"><img src="images/sa-advise.jpg" onClick="printSA()" title="Print Shipping Advise"></td>
			<td align="right" width="60"><img src="../shared/images/print.jpg" title="Print Shipping Instruction" onClick="doPrint(2)"></td>
			<td align="right" width="60"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost();"></td>
          </tr>
        </table></td>
            </tr>
          </table></td>
        </tr>
      </table></td>
    </tr>
</table>
<%//@include file="traffic.si.invoice.jsp"%>
<label class="style2" style="color:#0033FF; display:<%=shipping.isNull()?"none":""%>"> &nbsp; <strong>Final Invoices : </strong></label>
<div style="border:thin; border-style:solid; border-width:1; border-left:0;border-right:0; width:100%; display:<%=shipping.isNull()?"none":""%>">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" style="font-weight:bold" align="center">
                <th width="30">Id&nbsp;</th>
                <td width="130">Final Invoice</td>
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
                <td width="36">&nbsp;</td>
                <td width="36">&nbsp;</td>
                <td width="36">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
<%
	List<WnExportEntity> cons = shipping.getWeightNotes();
	WnExportEntity _wn = dao.getWnExportDao().newEntity(shipping);
	//_wn.status = 2;
	cons.add(_wn);
	WnExportEntity sum = dao.getWnExportDao().newEntity();
	FinalInvoiceEntity siv = dao.getFinalInvoiceDao().newEntity();
	int grade_id = shipping.grade_id;
	for (int i = 0; i < cons.size(); i++) {
		WnExportEntity con = cons.get(i);
		sum.addTons(con);		
		long wne_id = con.getIdLong();
		FinalInvoiceEntity iv = con.getInvoice();
		siv.add(iv);
%>
              <input type="hidden" name="wn_id_<%=i%>"  id="wn_id_<%=i%>"  value="<%=con.getIdLong()%>">
              <input type="hidden" name="status_<%=i%>" id="status_<%=i%>" value="<%=con.status%>">
              <tr id="wn_<%=i%>" onClick="highlightOn(this,2);" style="display:<%=con.isNull()?"none":""%>">
                <th bgcolor="#DDDDDD" align="right"><%=iv.getIdLong()%>&nbsp;</th>
                <td><input type="text" name="fin_inv_ref_number_<%=i%>" id="fin_inv_ref_number_<%=i%>" class="style2" style="width:130; font-weight:bold; color:<%=iv.isNull()?"#0000FF":""%>" value="<%=iv.getRefNumber()%>" <%=dis%>></td>
                <td><%=Html.datePicker("fin_inv_invoice_date_" + i, iv.invoice_date)%></td>
                <td><strong><%=con.getShortRef()%></strong></td>
                <td><input type="text" name="container_no_<%=i%>"  id="container_no_<%=i%>"  class="style11" style="width:90;" value="<%=con.container_no%>" onKeyUp="toUpper(this);"></td>
                <td><%=Html.datePicker("docs_handover_date_" + i, con.docs_handover_date)%></td>
                <td><%=Html.datePicker("despatch_date_" + i, con.despatch_date)%></td>
                <td><%=Html.datePicker("arrival_date_" + i, con.arrival_date)%></td>
                <td><input type="text" name="export_container_no_<%=i%>"  id="export_container_no_<%=i%>"  class="style11" style="width:90;" value="<%=con.export_container_no%>" onKeyUp="toUpper(this);"></td>
                <td><input type="text" name="seal_no_<%=i%>"       id="seal_no_<%=i%>"       class="style11" style="width:56;" value="<%=con.seal_no%>"></td>
                <td><input type="text" name="ace_seal_no_<%=i%>"      id="ace_seal_no_<%=i%>"      class="style11" style="width:56;" value="<%=con.ace_seal_no%>" onKeyUp="toUpper(this);"></td>
                <td><input type="text" name="no_of_bags_<%=i%>"    id="no_of_bags_<%=i%>"    class="style11" style="width:40; text-align:right" value="<%=con.no_of_bags%>"></td>
                <th align="right"><%=Numeric.numberToStr(con.net_weight,0)%>&nbsp;</th>
                <th align="right"><%=Numeric.numberToStr(iv.price_cts,2)%>&nbsp;</th>
                <th align="right"><%=Numeric.numberToStr(iv.amount_usd,2)%>&nbsp;</th>
                <td align="center"><a href="JavaScript:sav_Container(<%=i%>)" style="display:<%=displayed%>">Save</a></td>
                <td align="center"><a href="JavaScript:del_Container(<%=i%>)" style="display:<%=displayed%>">Delete</a></td>
                <td align="center" style="display:none"><a href="JavaScript:allocate(<%=i%>)" style="display:<%=displayed%>">Allocation</a></td>
                <td align="center"><a href="JavaScript:printFinalInvoice(<%=iv.getIdLong()%>,<%=i%>)" style="display:<%=displayed%>">Print</a></td>
              </tr>
<%
	}
%>
              <tr class="style11" style="font-weight:bold" bgcolor="#DDDDDD">
                <th><img src="../shared/images/new.gif" title="New Container" onClick="new_Container(<%=cons.size()-1%>)" style="display:<%=displayed%>"></th>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><strong>Total</strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.no_of_bags,0)%></strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.net_weight,0)%></strong>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(siv.amount_usd,2)%>&nbsp;</td>
                <td style="display:">&nbsp;</td>
                <td>&nbsp;</td>
                <td style="display:none">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
  </table>
</div>
	<input type="hidden" name="no" id="no" value="-1">	
	<input type="hidden" name="inst_id" id="inst_id" value="0">	
	<input type="hidden" name="type" id="type" value="<%=invoice.getType()%>">	

<script language="javascript">
	if (<%=shipping.getIdLong()%> == -1) {	
		var new_si = "<%=shipping.getRefNumber()%>";
		var idx = addNewListItem(document.formMain.inst_id,new_si);
		setValue("freight","FREIGHT PAYABLE BY BERNHARD ROTHFOS GMBH, HAMBURG");
		setValue("shipper_id",1);
		setValue("no_of_containers",1);
		setValue("tons",<%=shipping.getContract().tons%>);
		if (<%=sc.filter_warehouse_id%> > 0) {
			setValue("warehouse_id", <%=sc.filter_warehouse_id%>);
		}
	}
</script>


