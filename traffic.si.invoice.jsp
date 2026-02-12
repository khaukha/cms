<%
	SaleInvoiceEntity pro_inv = task.getProvisionalInvoice(shipping);
	SaleInvoiceEntity pre_inv = task.getPreShipmentInvoice(shipping);
%>
<script language="javascript">
function printInvoice(invoice_id, type)
{
	if (invoice_id <= 0) {
		alert("Please update and save invoice before printing.");
		return;
	}
	setValue("invoice_id",invoice_id);
	setValue("type",type);
	doTask(5);
}

function saveInvoice(prefix)
{
	if (<%=shipping.getIdLong()%> <= 0) {
		alert("Please save SI before creating invoice");
		return;
	}
	if (getValue(prefix + "_inv_invoice_date") == "") {
		//alert("Please input invoice date.");
		//return;
	}
	setValue("prefix", prefix);
	doTask(10);
}

function deleteInvoice(invoice_id, ref_number)
{
	if (confirm("Are you sure to delete invoice " + ref_number + "(" + invoice_id + ")")) {
		setValue("invoice_id", invoice_id);
		doTask(11);
	}
}


</script>
<label style="color:#0033FF; display:<%=shipping.isNull()?"none":"none"%>" class="style2"><strong>Provisional Invoice : </strong></label>
<div style="border-style:solid; border-width:1; border-left:0; width:auto; display:<%=shipping.isNull()?"none":""%>">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                          <tr bgcolor="#DDDDDD">
                            <th width="30" rowspan="2">Id</th>
                            <th width="135" rowspan="2">Provisional Invoice</th>
                            <th width="94" rowspan="2">Date</th>
                            <th colspan="3">Weight (Kgs) </th>
                            <th width="60" rowspan="2">No Of<br>Bags</th>
                            <th width="70" rowspan="2">Price<br>(<%=location.currency%>/bags)</th>
                            <th width="90" rowspan="2">Amount<br>(<%=location.currency%>)</th>
                            <th colspan="3" rowspan="2"><a href="JavaScript:show('pro_inv_')" style="display:<%=pro_inv.isNull()?"":"none"%>">New Provisional Invoice</a></th>
                            <th rowspan="2">&nbsp;</th>
                          </tr>
                          <tr bgcolor="#DDDDDD">
                            <th width="80">Gross</th>
                            <th width="80">Tare</th>
                            <th width="80">Net</th>
                          </tr>
                  <tr id="pro_inv_" onClick="highlightOn(this);" style="display:<%=pro_inv.isNull()?"none":""%>">
                    <td align="center" bgcolor="#DDDDDD"><strong><%=pro_inv.getIdLong()%></strong></td>
                    <td align="center"><input type="text" name="pro_inv_ref_number" id="pro_inv_ref_number" class="style2" style="width:135; font-weight:bold" value="<%=pro_inv.getRefNumber()%>" <%=dis%>></td>
                    <td><%=Html.datePicker("pro_inv_invoice_date", pro_inv.invoice_date)%></td>
                    <td><input type="text" name="pro_inv_gross_weight" id="pro_inv_gross_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(pro_inv.gross_weight,0)%>" onChange="weightChange();" <%=dis%> readonly></td>
                    <td><input type="text" name="pro_inv_tare_weight" id="pro_inv_tare_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(pro_inv.tare_weight,0)%>" onChange="weightChange();" <%=dis%> readonly></td>
                    <td><input type="text" name="pro_inv_net_weight" id="pro_inv_net_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(pro_inv.net_weight,0)%>" onChange="weightChange();" <%=dis%> readonly></td>
                    <td align="center"><input type="text" name="pro_inv_no_of_bags" id="pro_inv_no_of_bags" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(pro_inv.no_of_bags,0)%>" <%=dis%>></td>
                    <td align="center"><input type="text" name="pro_inv_price_local" id="pro_inv_price_local" class="style2" style="width:70; text-align:right" value="<%=Numeric.numberToStr(pro_inv.price_local,0)%>" <%=dis%>></td>
                    <td align="center"><strong><%=Numeric.numberToStr(pro_inv.amount_local,0)%></strong>&nbsp;</td>
                    <td width="68" align="center"><a href="JavaScript:saveInvoice('pro')">Save</a></td>
                    <td width="68" align="center"><a href="JavaScript:deleteInvoice(<%=pro_inv.getIdLong()%>,'<%=pro_inv.getRefNumber()%>')">Delete</a></td>
                    <td width="68" align="center"><a href="JavaScript:printInvoice(<%=pro_inv.getIdLong()%>,'P')">Print</a></td>
                    <td align="center">&nbsp;</td>
                  </tr>			  
</table>
</div>

<label style="color:#0033FF; display:<%=shipping.isNull()?"none":"none"%>" class="style2"> &nbsp; <strong>Pre-Shipment Invoice : </strong></label>

<div style="border:thin; border-style:solid; border-width:1; border-left:none; border-top:0; border-right:none; width:100%; display:<%=shipping.isNull()?"none":""%>">
<table width="100%" id="invoice_"  border="0" cellspacing="1" cellpadding="0" class="style2">
                  <tr bgcolor="#DDDDDD">
                    <th width="30" rowspan="2" bgcolor="#DDDDDD">Id</th>
                    <th width="135" rowspan="2">Pre-Shipment Invoice</th>
                    <th width="94" rowspan="2">Date </th>
                    <th colspan="3">Weight (Kgs)</th>
                    <th width="60" rowspan="2">No Of<br>Bags</th>
                    <th width="70" rowspan="2">Price<br>Cts/Lb</th>
                    <th width="90" rowspan="2">Amount<br>US$</th>
                    <th colspan="3" rowspan="2"><a href="JavaScript:show('pre_inv_')" style="display:<%=pre_inv.isNull()?"":"none"%>">New Pre-Shipment Invoice</a></th>
                    <th rowspan="2">&nbsp;</th>
                  </tr>
                  <tr bgcolor="#DDDDDD">
                    <th width="80">Gross</th>
                    <th width="80">Tare</th>
                    <th width="80">Net</th>
                  </tr>

                  <tr id="pre_inv_" onClick="highlightOn(this);" style="display:<%=pre_inv.isNull()?"none":""%>">
                    <td align="center" bgcolor="#DDDDDD"><strong><%=pre_inv.getIdLong()%></strong></td>
                    <td align="center"><input type="text" name="pre_inv_ref_number" id="pre_inv_ref_number" class="style2" style="width:135; font-weight:bold" value="<%=pre_inv.getRefNumber()%>" readonly></td>
                    <td align="center"><%=Html.datePicker("pre_inv_invoice_date",pre_inv.invoice_date)%></td>
                    <td align="right"><input type="text" name="pre_inv_gross_weight" id="pre_inv_gross_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(pre_inv.gross_weight,0)%>" readonly></td>
                    <td align="right"><input type="text" name="pre_inv_tare_weight"  id="pre_inv_tare_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(pre_inv.tare_weight,0)%>" readonly></td>
                    <td align="right"><input type="text" name="pre_inv_net_weight"   id="pre_inv_net_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(pre_inv.net_weight,0)%>"></td>
                    <td align="right"><input type="text" name="pre_inv_no_of_bags"   id="pre_inv_no_of_bags" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(pre_inv.no_of_bags,0)%>"></td>
                    <td align="right"><input type="text" name="pre_inv_price_cts"    id="pre_inv_price_cts" class="style2" style="width:70; text-align:right" value="<%=Numeric.numberToStr(pre_inv.price_cts,2)%>" readonly></td>
                    <td align="right"><input type="text" name="pre_inv_amount_usd"   id="pre_inv_amount_usd" class="style2" style="width:90; text-align:right" value="<%=Numeric.numberToStr(pre_inv.amount_usd,2)%>" readonly></td>
                    <td width="68" align="center" style="display:<%=displayed%>"><a href="JavaScript:saveInvoice('pre')" class="style2">Save</a></td>
                    <td width="68" align="center" style="display:<%=displayed%>"><a href="JavaScript:deleteInvoice(<%=pre_inv.getIdLong()%>, '<%=pre_inv.getRefNumber()%>')" class="style2">Delete</a></td>
                    <td width="68" align="center"><a href="JavaScript:printInvoice(<%=pre_inv.getIdLong()%>,'S')" class="style2">Print</a></td>
                    <td align="center">&nbsp;</td>
                  </tr>
                </table>
</div>

	<input type="hidden" name="invoice_id"  id="invoice_id"  value="0">	
	<input type="hidden" name="prefix"  id="prefix"  value="">	
	<input type="hidden" name="type"  id="type"  value="P">	
