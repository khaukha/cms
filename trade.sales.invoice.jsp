<%
	SaleInvoiceEntity inv = contract.getProvisionalInvoice();
	if (inv.isNull()) {
		inv.setNew();
		inv.ref_number = dao.getSalesInvoiceDao().getNewRefNumber();//"New Invoice";
	}
%>	

<script language="javascript">
function saveInvoice()
{
	doTask(11);
}

function deleteInvoice(ref_number)
{
	if (confirm("Are you sure to delete invoice " + ref_number)) {
		doTask(12);
	}
}

function printInvoice()
{
	if (<%=inv.isNull()%>) {
		alert("Please update and save the invoice first.");
		return;
	}
	doTask(13);
}
</script>
<label style="color:#0033FF; display:<%=contract.isNull()?"none":""%>" class="style2"><strong>Provisional Invoice : </strong></label>
<div style="border-style:solid; border-width:1; width:auto; display:<%=contract.isNull()||(contract.isCancelled()&&inv.isNull())?"none":""%>">
<table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
                          <tr style="font-weight:bold" bgcolor="#DDDDDD" align="center">
                            <th width="30" rowspan="2">Id</th>
                            <th width="120" rowspan="2">Invoice No</th>
                            <th width="94" rowspan="2">Date</th>
                            <th colspan="3">Weight (Kgs) </th>
                            <th width="60" rowspan="2">No Of<br>Bags</th>
                            <th width="80" rowspan="2">Price<br>(<%=location.currency%>/bags)</th>
                            <th width="100" rowspan="2">Amount<br>(<%=location.currency%>)</th>
                            <th rowspan="2">&nbsp;</th>
                            <th rowspan="2">&nbsp;</th>
                            <th rowspan="2">&nbsp;</th>
                            <th rowspan="2">&nbsp;</th>
                          </tr>
                          <tr style="font-weight:bold" bgcolor="#DDDDDD" align="center">
                            <th width="80">Gross</th>
                            <th width="80">Tare</th>
                            <th width="80">Net</th>
                          </tr>
                  <tr onClick="highlightOn(this);">
                    <td align="center" bgcolor="#DDDDDD"><strong><%=inv.getIdLong()%></strong></td>
                    <td align="center"><input type="text" name="inv_ref_number" id="inv_ref_number" class="style2" style="width:120;" value="<%=inv.getRefNumber()%>" <%=dis%>></td>
                    <td><%=Html.datePicker("inv_invoice_date",inv.invoice_date)%></td>
                    <td><input type="text" name="inv_gross_weight" id="inv_gross_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(inv.gross_weight,2)%>" onChange="weightChange();" <%=dis%>></td>
                    <td><input type="text" name="inv_tare_weight" id="inv_tare_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(inv.tare_weight,2)%>" onChange="weightChange();" <%=dis%>></td>
                    <td><input type="text" name="inv_net_weight" id="inv_net_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(inv.net_weight,2)%>" onChange="weightChange();" <%=dis%>></td>
                    <td align="center"><input type="text" name="inv_no_of_bags" id="inv_no_of_bags" class="style2" style="width:60; text-align:right" value="<%=Numeric.numberToStr(inv.no_of_bags,0)%>" <%=dis%>></td>
                    <td align="center"><input type="text" name="inv_price_local" id="inv_price_local" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(inv.price_local,_dec)%>" <%=dis%>></td>
                    <td align="center"><strong><%=Numeric.numberToStr(inv.amount_local)%></strong>&nbsp;</td>
                    <td width="68" align="center"><a href="JavaScript:saveInvoice()">Save</a></td>
                    <td width="68" align="center"><a href="JavaScript:deleteInvoice('<%=inv.getRefNumber()%>')">Delete</a></td>
                    <td width="68" align="center"><a href="JavaScript:printInvoice()">Print</a></td>
                    <td align="center">&nbsp;</td>
                  </tr>			  
</table>
</div>