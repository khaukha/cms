<%
	task.getAllocationTask().doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
	<tr bgcolor="#DDDDDD">
	  <th width="94">Date</th>
		<th width="150">Material</th>
		<th width="50">Qty</th>
		<th width="200">For</th>
		<th width="300">Remark</th>
		<th colspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost();"></th>
	</tr>
<%
	List<MaterialAllocationEntity> mas = task.getAllocationTask().getMaterialAllocations();
	MaterialAllocationEntity ma = dao.getMaterialAllocationDao().newEntity();
	ma.setNew();
	ma.material_id = material_id;
	mas.add(ma);
	for (int i = 0; i < mas.size(); i++) {
		ma = mas.get(i);
%>
    <input type="hidden" name="material_allocation_id_<%=i%>" id="material_allocation_id_<%=i%>" value="<%=ma.getIdLong()%>" />
	<tr id="<%=ma.isNull()?"material_allocation_":""%>" style="display:<%=ma.isNull()?"none":""%>">
	  <td><%=Html.datePicker("date_" + i,ma.date)%></td>
		<td><select name="material_id_<%=i%>" id="material_id_<%=i%>" size=1 class="style2" style="width:100%;"><%=Html.selectOptions(mlist, ma.material_id)%></select></td>
		<td><input type="text" name="quantity_<%=i%>"   id="quantity_<%=i%>"   class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(ma.quantity,0)%>"></td>
		<td><select name="type_id_<%=i%>" id="type_id_<%=i%>" size=1 class="style2" style="width:100%;"><%=Html.selectOptions(dao.getMaterialAllocationTypeDao().selectAll(),ma.type_id)%></select></td>
		<td><input type="text" name="remark_<%=i%>"    id="remark_<%=i%>"    class="style2" style="width:100%;" value="<%=ma.remark%>"></td>
		<td width="40" align="center"><a href="JavaScript:remove(<%=i%>)" style="display:<%=displayed%>">Del.</a></td>
		<td width="40" align="center"><a href="JavaScript:save(<%=i%>)" style="display:<%=displayed%>">Save</a></td>
	</tr>	
<%
	}
%>
	<tr bgcolor="#DDDDDD">
	  <td><a href="javascript:genReport()">Report</a></td>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<td align="center"><a href="JavaScript:add()">New</a></td>
	</tr>
</table>

