<%
	ShippingEntity  shipping = task.getShipping();
	task.doTask(shipping);
	SaleContractEntity contract = shipping.getContract();
	ShippingFeeEntity shipping_fee = shipping.getShippingFee();
	ShippingCostEntity shipping_cost = shipping_fee.getShippingCost();
	BagCostEntity bag_cost = dao.getBagCostDao().getByKey(shipping_cost.month_end, shipping.packing_id);
	boolean completed = shipping.isCompleted();
	String dis = shipping.getIdLong()==0?"disabled":"";
	sc.filter_contract_id = contract.getIdLong();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

var completed = <%=shipping.status == 2%>;
var readonly = <%=task.isReadOnly()%>;

function viewShippingFee(shipping_fee_id)
{	
	setView(0);
	document.formMain.action = "traffic.shipping-fee.jsp";
	document.formMain.submit();
}

function doAllocation()
{
	doLink("warehouse.allocation.jsp?alloc_type=S");
}

function doCardView()
{
	if (getValue("contract_id") == 0) {
		alert("Please select a contract.");
		return;
	}

	setValue("view",1);
	doPost();
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

function printSA()
{
	var inst_id = getValue("inst_id");
	if (inst_id == 0) {
		alert("Please select a Shipping Instruction");
		return;
	}
	if (inst_id < 0) {
		alert("Please save Shipping Instruction before printing.");
		return;
	}
	doTask(6);
}

function quantityChanged(tons)
{
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
	if (<%=shipping.isNull()%>) {
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
	if (<%=shipping.isNull()%>) {
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
		<td width="120"><select name="filter_warehouse_id" id="filter_warehouse_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_warehouse_id,"Warehouse (All)")%></select></td>
		<td width="80"><select name="filter_status" id="filter_status" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"Status (All)")%></select></td>
		<td width="120"><select name="filter_buyer_id" id="filter_buyer_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"Buyer (All)")%></select></td>
		<td width="200"><select name="filter_grade_id" id="filter_grade_id" size=1 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getGradeFilter(),sc.filter_grade_id,"Grade (All)")%></select></td>
		<td>&nbsp;</td>
		<td align="right"><%@include file="search.jsp"%></td>
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
              <td><select name="contract_id" size=20 class="style11" id="contract_id" style="width:120px;" onChange="itemSelected(this);"><%=Html.selectOptionsX(dao.getSaleContractDao().getList(),sc.contract_id,"All")%></select></td>
              </tr>
          </table></td>
	  	  <td valign="top" width="130px"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
            <tr bgcolor="#DDDDDD">
			  <td align="center" width="130px"><strong>SI Ref</strong></td>
            </tr>
            <tr>
              <td><select name="inst_id" size=20 class="style11" id="inst_id" style="width:130px;" onChange="doPost();"><%=Html.selectOptionsX(contract.getShippings(),shipping.getIdLong(),"All")%></select></td>
            </tr>
        <tr style="display:<%=displayed%>">
          <td>
		  <img id="new_btn" src="images/new.gif" border="0" onClick="new_SI();">
		  <img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="del_SI()"></td>
          </tr>
          </table></td>
          <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
            <tr bgcolor="#DDDDDD">
              <td align="center"><strong><%=shipping.getRefNumber()%> (<%=shipping.getIdLong()%>)</strong></td>
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
		FinalInvoiceEntity iv = task.getFinalInvoice(con);
		siv.add(iv);
%>
              <input type="hidden" name="wn_id_<%=i%>"  id="wn_id_<%=i%>"  value="<%=con.getIdLong()%>">
              <input type="hidden" name="status_<%=i%>" id="status_<%=i%>" value="<%=con.status%>">
              <tr id="wn_<%=i%>" onClick="highlightOn(this,2);" style="display:<%=con.isNull()?"none":""%>">
                <th bgcolor="#DDDDDD" align="right"><%=iv.getIdLong()%>&nbsp;</th>
                <td><input type="text" name="fin_inv_ref_number_<%=i%>" id="fin_inv_ref_number_<%=i%>" class="style11" style="width:130; font-weight:bold; color:<%=iv.isNull()?"#0000FF":""%>" value="<%=iv.getRefNumber()%>" <%=dis%>></td>
                <td><%=Html.datePicker("fin_inv_invoice_date_" + i, iv.invoice_date, "style11")%></td>
                <td><strong><%=con.getShortRef()%></strong></td>
                <td><input type="text" name="container_no_<%=i%>"  id="container_no_<%=i%>"  class="style11" style="width:90;" value="<%=con.container_no%>" onKeyUp="toUpper(this);"></td>
                <td><%=Html.datePicker("docs_handover_date_" + i, con.docs_handover_date, "style11")%></td>
                <td><%=Html.datePicker("despatch_date_" + i, con.despatch_date, "style11")%></td>
                <td><%=Html.datePicker("arrival_date_" + i, con.arrival_date, "style11")%></td>
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
                <td align="right">Total&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(sum.net_weight,0)%>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(siv.amount_usd,2)%>&nbsp;</td>
                <td style="display:">&nbsp;</td>
                <td>&nbsp;</td>
                <td style="display:none">&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
          </table>
</div>
		
<label style="color:#0033FF; display:<%=shipping.isNull()?"none":""%>" class="style2"> &nbsp; <strong>Cost Estimation of Month &nbsp; <%=DateTime.dateToTerminalMonth(shipping_cost.month_end)%></strong></label>
<div style="border:thin; border-style:solid; border-width:1; border-left:none; border-right:none; width:100%; display:<%=shipping.isNull()?"none":""%>">
<table width="100%" class="style11" cellpadding="0" cellspacing="1">
			<tr bgcolor="#DDDDDD">
			    <th width="30"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
			    <th width="60">Ex.Rate<br />(US$/<%=location.currency%>)</th>
			    <th width="60">Seal<br />(US$/Con)</th>
				<th width="60">THC<br />(US$/Con)</th>
				<th width="60">ENS<br />(US$/Bill)</th>
				<th width="60">Analysis<br />Coffee<br />(US$/Mt)</th>
				<th width="60">Phyto<br />(<%=location.currency%>/Mt)</th>
				<th width="60">Phyto Reg.<br />(<%=location.currency%>/Mt)</th>
				<th width="60">Trans.<br />(<%=location.currency%>/Con)</th>
				<th width="60">LOLO<br />(<%=location.currency%>/Con)</th>
				<th width="60">Fumi<br />(<%=location.currency%>/Con)</th>
				<th width="60">Doc.Serv.<br />(<%=location.currency%>/Bill)</th>
				<th width="60">Dri-Bags<br />(<%=location.currency%>/Kg)</th>
				<th width="60">K.Paper<br />(<%=location.currency%>/Con)</th>
				<th width="60">L.Kraft<br />(<%=location.currency%>/Con)</th>
				<th width="60">Custom<br />(<%=location.currency%>/Bill)</th>
				<th width="60">Vicofa<br />(USD/Mt)</th>
				<th width="60">Cust.Serv.<br />(<%=location.currency%>/Con)</th>
				<th width="60">Bag<br />(<%=location.currency%>/Unit)</th>
				<th width="60">Pallet<br />(<%=location.currency%>/Unit)</th>
				<th width="40">&nbsp;</th>
				<th>&nbsp;</th>
			</tr>
			<tr style="display:<%=shipping_fee.isNull()?"none":""%>">
			  <th bgcolor="#DDDDDD"><%=shipping_cost.getIdLong()%></th>
			  <td><input type="text" name="est_usd_local" id="est_usd_local" class="style11" style="width:60; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.est_usd_local, 0)%>"></td>
			  <td><input type="text" name="seal_cost_usd" id="seal_cost_usd" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.seal_cost_usd, 2)%>"></td>
			  <td><input type="text" name="thc_cost_usd" id="thc_cost_usd" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.thc_cost_usd, 2)%>"></td>
			  <td><input type="text" name="ens_cost_usd" id="ens_cost_usd" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.ens_cost_usd, 2)%>"></td>
			  <td><input type="text" name="analysis_coffee_cost_usd" id="analysis_coffee_cost_usd" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.analysis_coffee_cost_usd, 2)%>"></td>
			  <td><input type="text" name="phyto_cost_local" id="phyto_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.phyto_cost_local, 0)%>"></td>
			  <td><input type="text" name="phyto_reg_cost_local" id="phyto_reg_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.phyto_reg_cost_local, 0)%>"></td>
			  <td><input type="text" name="trans_cost_local" id="trans_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.trans_cost_local, 0)%>"></td>
			  <td><input type="text" name="lolo_cost_local" id="lolo_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.lolo_cost_local, 0)%>"></td>
			  <td><input type="text" name="fumi_cost_local" id="fumi_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.fumi_cost_local, 0)%>"></td>
			  <td><input type="text" name="docs_cost_local" id="docs_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.docs_cost_local, 0)%>"></td>
			  <td><input type="text" name="dri_bags_cost_local" id="dri_bags_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.dri_bags_cost_local, 0)%>"></td>
			  <td><input type="text" name="kraft_paper_cost_local" id="kraft_paper_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.kraft_paper_cost_local, 0)%>"></td>
			  <td><input type="text" name="lining_kraft_cost_local" id="lining_kraft_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.lining_kraft_cost_local, 0)%>"></td>
			  <td><input type="text" name="custom_cost_local" id="custom_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.custom_cost_local, 0)%>"></td>
			  <td><input type="text" name="vicofa_cost_usd" id="vicofa_cost_usd" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.vicofa_cost_usd, 2)%>"></td>
			  <td><input type="text" name="custom_service_cost_local" id="custom_service_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.custom_service_cost_local, 0)%>"></td>
			  <td><input type="text" name="bags_cost_local" id="bags_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(bag_cost.cost_local, 0)%>"></td>
			  <td><input type="text" name="pallets_cost_local" id="pallets_cost_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_cost.pallets_cost_local, 0)%>"></td>
			  <td align="center"><a href="JavaScript:saveShippingCost()" style="display:<%=displayed%>">Save</a></td>
			  <td>&nbsp;</td>
		    </tr>
</table>
</div>
		
<table width="100%" class="style2" cellpadding="0" cellspacing="1" style="display:<%=shipping.isNull()?"none":""%>">
			<tr>
				<td width="210" style="color:#0033FF"> &nbsp; <strong>Shipping Fees Estimation of Month</strong> &nbsp;</td>
				<td width="60"><select name="month" id="month" class="style2" style="width:100%;"><%=Html.selectOptions(Html.months,shipping_fee.getMonth(),"")%></select></td>
				<td width="60"><select name="year" id="year" class="style2" style="width:100%;"><%=Html.selectOptions(Html.years,shipping_fee.getYear(),"")%></select></td>
				<td>&nbsp; <a href="JavaScript:newShippingFee()" style="display:<%=task.isReadOnly()||!shipping_fee.isNull()?"none":""%>">New</a></td>
				<td>&nbsp;</td>
			</tr>
</table>
		
<div style="border:thin; border-style:solid; border-width:1; width:100%; border-left:none; border-bottom:none; border-right:0; display:<%=shipping.isNull()?"none":""%>">
<table width="100%" class="style11" cellpadding="0" cellspacing="1" style="display:">
			<tr bgcolor="#DDDDDD">
			    <th width="30"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
			    <th width="50">Bill</th>
				<th width="50">Seal</th>
				<th width="60">THC</th>
				<th width="50">Phyto<br />Fee</th>
				<th width="50">Phyto<br />Reg.</th>
				<th width="60">Trans.</th>
				<th width="50">LOLO</th>
				<th width="50">Fumi</th>
				<th width="50">Doc.</th>
				<th width="50">Dri-Bags</th>
				<th width="60">Kraft<br />Paper</th>
				<th width="60">Lining<br />Kraft</th>
				<th width="60">Custom</th>
				<th width="60">Vicofa</th>
				<th width="60">Custom<br />Service</th>
				<th width="60">Bags</th>
				<th width="60">Pallet</th>
				<th width="60">Marking</th>
				<th width="60">ENS</th>
				<th width="60">Analysis Coffee</th>
				<th width="40"><%=Html.checkBox("shipping_fee_status",shipping_fee.status)%></th>
				<th>&nbsp;</th>
			</tr>
			<tr style="display:<%=shipping_fee.isNull()?"none":""%>">
			    <th bgcolor="#DDDDDD"><a href="JavaScript:viewShippingFee()"><%=shipping_fee.getIdLong()%></a></th>
			    <td><input type="text" name="bill_fee_local" id="bill_fee_local" class="style11" style="width:50; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.bill_fee_local, 0)%>"></td>
				<td><input type="text" name="seal_fee_local" id="seal_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.seal_fee_local, 0)%>"></td>
				<td><input type="text" name="thc_fee_local" id="thc_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.thc_fee_local, 0)%>"></td>
				<td><input type="text" name="phyto_fee_local" id="phyto_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.phyto_fee_local, 0)%>"></td>
				<td><input type="text" name="phyto_reg_fee_local" id="phyto_reg_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.phyto_reg_fee_local, 0)%>"></td>
				<td><input type="text" name="trans_fee_local" id="trans_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.trans_fee_local, 0)%>"></td>
				<td><input type="text" name="lolo_fee_local" id="lolo_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.lolo_fee_local, 0)%>"></td>
				<td><input type="text" name="fumi_fee_local" id="fumi_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.fumi_fee_local, 0)%>" <%=shipping.fumigation?"":"disabled"%>></td>
				<td><input type="text" name="docs_fee_local" id="docs_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.docs_fee_local, 0)%>"></td>
				<td><input type="text" name="dri_bags_fee_local" id="dri_bags_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.dri_bags_fee_local, 0)%>" <%=shipping.dri_bags>0?"":"disabled"%>></td>
				<td><input type="text" name="kraft_paper_fee_local" id="kraft_paper_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.kraft_paper_fee_local, 0)%>" <%=shipping.kraft_paper?"":"disabled"%>></td>
				<td><input type="text" name="lining_kraft_fee_local" id="lining_kraft_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.lining_kraft_fee_local, 0)%>"></td>
				<td><input type="text" name="custom_fee_local" id="custom_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.custom_fee_local, 0)%>"></td>
				<td><input type="text" name="vicofa_fee_local" id="vicofa_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.vicofa_fee_local, 0)%>"></td>
				<td><input type="text" name="custom_service_fee_local" id="custom_service_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.custom_service_fee_local, 0)%>"></td>
				<td><input type="text" name="bags_fee_local" id="bags_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.bags_fee_local, 0)%>"></td>
				<td><input type="text" name="pallets_fee_local" id="pallets_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.pallets_fee_local, 0)%>"></td>
				<td><input type="text" name="marking_fee_local" id="marking_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.marking_fee_local, 0)%>"></td>
				<td><input type="text" name="ens_fee_local" id="ens_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.ens_fee_local, 0)%>"></td>
				<td><input type="text" name="analysis_coffee_fee_local" id="analysis_coffee_fee_local" class="style11" style="width:100%; text-align:right;" value="<%=Numeric.numberToStr(shipping_fee.analysis_coffee_fee_local, 0)%>"></td>
				<td align="center"><a href="JavaScript:saveShippingFee()" style="display:<%=task.isReadOnly()||shipping_fee.isNull()?"none":""%>">Save</a></td>
				<td>&nbsp;</td>
			</tr>
</table>
</div>		
	<input type="hidden" name="no"    id="no"    value="0">	
	<input type="hidden" name="wn_id" id="wn_id" value="0">	

<script language="javascript">
	if (<%=shipping.isNew()%>) {	
		var new_si = "<%=shipping.getRefNumber()%>";
		var idx = addNewListItem(document.formMain.inst_id,new_si);
		setValue("freight","FREIGHT PAYABLE BY BERNHARD ROTHFOS GMBH, HAMBURG");
		setValue("shipper_id",1);
		setValue("no_of_containers",1);
		setValue("tons",<%=shipping.getContract().tons%>);
		if (<%=sc.filter_warehouse_id%> > 0) {
			setValue("warehouse_id", <%=sc.filter_warehouse_id%>);
		}
		var txt =	"Ibero (Uganda) Limited\r\n" +
					"35/119/\r\n" +
					"Natural Robusta Screen\r\n" +
					"Crop\r\n" +
					"Coffee Produce of Uganda\r\n" +
					"60 Kg Net Weight\r\n" +
					"For Export Only";
		setValue("marking_on_bags", txt);
	}
</script>


