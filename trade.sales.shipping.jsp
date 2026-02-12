<div style="border-style:solid; border-width:1; width:auto">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                          <tr bgcolor="#DDDDDD">
                            <th width="40" rowspan="2">No</th>
                            <th width="120" rowspan="2">SI Ref </th>
                            <th width="120" rowspan="2">Destination</th>
                            <th width="80" rowspan="2">Packing</th>
                            <th colspan="2">Shipped</th>
                            <th colspan="2">Shipment Period </th>
                            <th colspan="2">Invoice</th>
                            <th>&nbsp;</th>
                          </tr>
                          <tr bgcolor="#DDDDDD">
                            <th width="70">Tons</th>
                            <th width="70">Bags</th>
                            <th width="68">From</th>
                            <th width="68">To</th>
                            <th width="120">Ref No. </th>
                            <th width="68">Date</th>
                            <th>&nbsp;</th>
                          </tr>
<%
	if (contract.isNull() || contract.isCancelled()) {
		displayed = "none";
	}
	ShippingEntity ssi = dao.getShippingDao().newEntity(contract);
	List<ShippingEntity> sis = contract.getShippings();
	for (int i = 0; i < sis.size(); i++) {
		ShippingEntity si = sis.get(i);
		ssi.add(si);
%>	
                  <tr onClick="highlightOn(this);" onDblClick="toPage('traffic.si.jsp',<%=si.getIdLong()%>)">
                    <td align="center" bgcolor="#DDDDDD"><strong><%=i+1%></strong></td>
                    <td ><%=si.getRefNumber()%></td>
                    <td><%=si.getDestination().short_name%> &nbsp;</td>
                    <td><%=si.getPacking().short_name%> &nbsp;</td>
                    <td align="right"><%=Numeric.numberToStr(si.delivered_tons,3)%></td>
                    <td align="right"><%=si.delivered_bags%></td>
                    <td align="center"><%=DateTime.dateToStr(si.first_date)%></td>
                    <td align="center"><%=DateTime.dateToStr(si.last_date)%></td>
                    <td align="center"><%=si.getPreShipmentInvoice().getRefNumber()%></td>
                    <td align="center"><%=DateTime.dateToStr(si.getPreShipmentInvoice().invoice_date)%></td>
                    <td align="center">&nbsp;</td>
                  </tr>			  
<%
	}
%>						  
                  <tr class="style2" bgcolor="#DDDDDD">
                    <td align="center"><img src="../shared/images/new.gif" onClick="toPage('traffic.si.jsp',-1)" title="Add a new Shipping Instruction" style="display:<%=displayed%>"></td>
                    <th align="center">Total</th>
                    <td align="center">&nbsp;</td>
                    <td align="right">&nbsp;</td>
                    <td align="right"><strong><%=Numeric.numberToStr(ssi.delivered_tons,3)%></strong></td>
                    <td align="right"><strong><%=ssi.delivered_bags%></strong></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                  </tr>						  
</table>
</div>