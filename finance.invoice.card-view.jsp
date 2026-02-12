<%
	SaleContractEntity contract = dao.getSaleContractDao().getById(sc.contract_id);
	FinalInvoiceEntity invoice = task.getInvoice();	
	task.doTask(invoice);	
	ShippingEntity shipping = invoice.getShipping();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";
var completed = <%=invoice.status == 2%>;
var readonly = <%=task.isReadOnly()%>;
/////////////////////////////////////////////
function confirm_Invoice()
{
	var invoice_id = getValue("invoice_id");
	if (invoice_id == 0) {
		alert("Please select an invoice.");
		return;
	}	
	doTask(1);
}

</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td width="300" valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
		  <tr bgcolor="#EEEEEE">
            <th width="50%">Contract Ref.</th>
            <th>Invoice Ref.</th>
          </tr>
          <tr>
            <td><select name="contract_id" id="contract_id" size="24" class="style11" style="width:100%;" onchange="setValue('invoice_id',0);doPost()"><%=Html.selectOptionsX(dao.getSaleContractDao().list(),sc.contract_id,"All")%></select></td>
            <td valign="top"><select name="invoice_id" size=24 class="style11" id="invoice_id" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(contract.getFinalInvoices(),sc.invoice_id,"Select Invoice")%></select></td>
          </tr>
          <tr style="display:none">
            <td>&nbsp;</td>
            <td><img src="../shared/images/new.gif" border="0" width="15" height="15" onClick="new_Invoice()">
			<img src="../shared/images/delete.gif" width="15" height="15" border="0" onClick="delete_Invoice()"></td>
          </tr>
        </table></td>
		<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
            <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
          <tr bgcolor="#EEEEEE">
            <th>Status</th>
            <th>Buyer</th>
            <th>Quality</th>
            <th>Grade</th>
          </tr>
          <tr>
            <td><%@include file="inc/filter.status.jsp"%></td>
            <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
            <td><%@include file="inc/filter.quality.jsp"%></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getShippingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
          </tr>
        </table></td>
            </tr>
			<tr>
				<td style="font-weight:bold">Sales Information</td>
			</tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%;" align="center">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
					<tr bgcolor="#DDDDDD">
					  <th width="150">Sales Ref.</th>
					  <th width="150">Shipping Ref. </th>
					  <th width="120">Type</th>
					  <th>Buyer</th>
					  <th>Grade</th>
					  <th>Destination</th>
					  <th>Inv. Date</th>
					  <th>Shipped Tons</th>
				      <th>&nbsp;</th>
				  </tr>
					<tr align="center" style="font-weight:bold">
						<td><%=contract.getRefNumber()%></td>
						<td><%=shipping.getRefNumber()%></td>
						<td ><%=contract.getContractType().short_name%></td>
						<td ><%=contract.getBuyer().short_name%></td>
						<td><%=contract.getGrade().short_name%></td>
						<td><%=shipping.getDestination().short_name%></td>
						<td><%=DateTime.dateToStr(invoice.invoice_date)%></td>
						<td><%=Numeric.numberToStr(invoice.net_weight/1000)%></td>
					    <td>&nbsp;</td>
					</tr>
				</table>				
				</div></td>
			</tr>
			<tr>
				<td><strong>Payment Confirmation </strong></td>
			</tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; height:172px; padding-top:16px" align="center">
<table width="100%" border="0" cellspacing="0" cellpadding="1" class="style2">
  <tr>
    <td align="right" width="150px">Invoice Ref &nbsp;</td>
    <td width="150px"><strong><%=invoice.getRefNumber()%></strong></td>
    <td width="150px">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="right">Payment Date &nbsp;</td>
    <td><%=Html.datePicker("payment_date",invoice.payment_date)%></td>
    <td align="right">Amount (USD) &nbsp;</td>
    <td><input type="text" name="amount" id="amount" class="style2" style="width:100px; text-align:right" value="<%=Numeric.numberToStr(invoice.amount_usd,2)%>" readonly></td>
  </tr>
  <tr style="display:">
    <td align="right">Price (Cts/Lb) &nbsp;</td>
    <td><input type="text" name="price_cts" id="price_cts" class="style2" style="width:92px; text-align:right" value="<%=Numeric.numberToStr(invoice.price_cts,2)%>" readonly></td>
    <td align="right">Exchange Rate &nbsp;</td>
    <td><input type="text" name="exchange_rate" id="exchange_rate" class="style2" style="width:100px; text-align:right" value="<%=Numeric.numberToStr(invoice.exchange_rate,2)%>"></td>
  </tr>
  <tr style="display:<%=contract.isLocalSales()?"":""%>">
    <td align="right">Equivalence (USD/Mt) &nbsp;</td>
    <td><input type="text" name="price_usd" id="price_usd" class="style2" style="width:92px; text-align:right" value="<%=Numeric.numberToStr(invoice.price_usd,2)%>" readonly></td>
    <td align="right">Amount (<%=location.currency%>) &nbsp;</td>
    <td><input type="text" name="amount_local" id="amount_local" class="style2" style="width:100px; text-align:right" value="<%=Numeric.numberToStr(invoice.amount_local,0)%>" readonly></td>
  </tr>
  <tr>
    <td align="right">Completed &nbsp;</td>
    <td><%=Html.checkBox("status",invoice.status)%></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

				</div></td>
			</tr>
			<tr>
				<td align="right">
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
			          <td width="20"><img id="save_btn_" src="../shared/images/update.gif" width="15" height="15" border="0" onClick="confirm_Invoice()" style="display:<%=displayed%>"></td>
                      <td>&nbsp;</td>
                      <td align="right" width="60"><img src="../shared/images/print.jpg" width="55" height="18" border="0" onClick="doTask(2)" style="display:none"></td>
                      <td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" title="Back To List View Screen" onClick="setValue('view',0);doPost();"></td>
                    </tr>
                  </table>			    </td>
			</tr>			
          </table></td>
	</tr>
	
</table>

<input type="hidden" name="no" id="no" value="-1">		
	

<script language="javascript">
	if (readonly) 
	{
		hide("update_btn");
    }
	
	if (<%=invoice.getIdLong() == -1%>) {	
		var idx = addNewListItem(document.formMain.payment_id,"<%=invoice.getRefNumber()%>");
	}

</script>