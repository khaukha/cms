<script language="javascript">
function saveDelivery(inst_id, no)
{
	if (inst_id == 0) {
		alert("Please select a Delivery Instruction.");
		return;
	}
	setValue("inst_id", inst_id);
	setValue("no", no);
	doTask(11);
}

function deleteDelivery(inst_id, txt)
{
	if (confirm("Are you sure to delete " + txt)) {
		setValue("inst_id", inst_id);
		doTask(12);
	}
}
</script>
<div style="border-style:solid; border-width:1; width:auto">
						<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                          <tr bgcolor="#DDDDDD">
                            <th width="40" rowspan="2" align="right">Id&nbsp;</th>
                            <th width="120" rowspan="2">DI Ref </th>
                            <th width="120" rowspan="2">Delivery<br>Warehouse</th>
                            <th width="150" rowspan="2">Packing</th>
                            <th colspan="3">Proposal</th>
                            <th colspan="3">Delivered</th>
                            <th width="50">&nbsp;</th>
                            <th width="50">&nbsp;</th>
                            <th width="130">&nbsp;</th>
                            <th>&nbsp;</th>
                          </tr>
                          <tr bgcolor="#DDDDDD">
                            <th width="94">Date</th>
                            <th width="80">Tons</th>
                            <th width="70">Bags</th>
                            <th width="68">Date</th>
                            <th width="68">Tons</th>
                            <th width="68">Bags</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                          </tr>
<%
	DeliveryEntity _di = dao.getDeliveryDao().newEntity(contract);
	DeliveryEntity sdi = dao.getDeliveryDao().newEntity(contract);
	List<DeliveryEntity> dis = contract.getDeliveries();
	dis.add(_di);
	for (int i = 0; i < dis.size(); i++) {
	    DeliveryEntity di = dis.get(i);
		sdi.add(di);
%>	
                  <tr id="<%=di.isNull()?"_new_di_":""%>" class="style2" onClick="highlightOn(this);" onDblClick="toPage('trade.di.jsp',<%=di.getIdLong()%>)" style="display:<%=di.isNull()?"none":""%>">
                    <td align="right" bgcolor="#DDDDDD"><a href="JavaScript:toPage('trade.di.jsp',<%=di.getIdLong()%>)"><strong><%=di.getIdLong()%></strong></a>&nbsp;</td>
                    <td><input type="text" name="di_ref_number_<%=i%>" id="di_ref_number_<%=i%>" class="style11" style="width:120;" value="<%=di.getRefNumber()%>"></td>
                    <td ><select name="di_warehouse_id_<%=i%>" id="di_warehouse_id_<%=i%>" class="style11" style="width:120;"><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(location_id),di.warehouse_id,"")%></select></td>
                    <td ><select name="di_packing_id_<%=i%>" id="di_packing_id_<%=i%>" class="style11" style="width:150;"><%=Html.selectOptions(dao.getPackingDao().selectAll(),di.packing_id,"")%></select></td>
                    <td><%=Html.datePicker("di_proposed_date_"+i,di.proposed_date,"style11")%></td>
                    <td><input type="text" name="di_tons_<%=i%>" id="di_tons_<%=i%>" class="style11" style="width:80; text-align:right" value="<%=Numeric.numberToStr(di.tons,4)%>"></td>
                    <td><input type="text" name="di_no_of_bags_<%=i%>" id="di_no_of_bags_<%=i%>" class="style11" style="width:70; text-align:right" value="<%=Numeric.numberToStr(di.no_of_bags,0)%>"></td>
                    <td align="center"><%=DateTime.dateToStr(di.delivery_date)%></td>
                    <td align="right"><%=Numeric.numberToStr(di.delivered_tons,4)%>&nbsp;</td>
                    <td align="right"><%=Numeric.numberToStr(di.delivered_bags,0)%>&nbsp;</td>
                    <td align="center"><a href="JavaScript:saveDelivery(<%=di.getIdLong()%>,<%=i%>)" style="display:<%=displayed%>">Save</a></td>
                    <td align="center"><a href="JavaScript:deleteDelivery(<%=di.getIdLong()%>,'<%=di.getRefNumber()%>')" style="display:<%=displayed%>">Delete</a></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                  </tr>			  
<%
	}
%>						  
                  <tr bgcolor="#DDDDDD">
                    <td align="center"><img src="../shared/images/new.gif" title="Create New DI" onClick="show('_new_di_');//toPage('traffic.di.jsp',-1)" style="display:<%=displayed%>"></td>
                    <th align="center">Total</th>
                    <td align="right"><strong>&nbsp;</strong></td>
                    <td align="right">&nbsp;</td>
                    <td align="right">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="right"><strong><%=Numeric.numberToStr(sdi.delivered_tons,4)%></strong>&nbsp;</td>
                    <td align="right"><strong><%=Numeric.numberToStr(sdi.delivered_bags,0)%></strong>&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                  </tr>						  
</table>
</div>