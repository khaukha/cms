<%
	task.getImportTask().doTask();
%>
<link href="style.css" rel="stylesheet" type="text/css">

<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style11">
	<tr bgcolor="#DDDDDD">
	  <th width="42" rowspan="2">Id&nbsp;</th>
		<th width="94" rowspan="2">Date</th>
		<th width="100" rowspan="2">Material</th>
		<th width="50" rowspan="2">Qty</th>
		<th colspan="4">Cost / USD</th>
		<th width="70" rowspan="2">Invoice</th>
		<th width="40" rowspan="2">% VAT</th>
		<th width="300" rowspan="2">Remark</th>
		<th colspan="2" rowspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost();"></th>
	    <th rowspan="2">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD">
	  <th width="60">Material</th>
      <th width="60">Freight</th>
      <th width="60">Insur.</th>
      <th width="60">Other</th>
  </tr>
<%
	List<MaterialImportEntity> mis = task.getImportTask().getMaterialImports();
	MaterialImportEntity mi = dao.getMaterialImportDao().newEntity();
	mi.setNew();
	mi.material_id = material_id;
	mis.add(mi);
	for (int i = 0; i < mis.size(); i++) {
		mi = mis.get(i);
%>
    <input type="hidden" name="material_import_id_<%=i%>" id="material_import_id_<%=i%>" value="<%=mi.getIdLong()%>" />
	<tr id="<%=mi.isNull()?"material_import_":""%>" style="display:<%=mi.isNull()?"none":""%>">
	  <th align="right" bgcolor="#DDDDDD"><%=mi.getIdLong()%>&nbsp;</th>
		<td><%=Html.datePicker("date_" + i,mi.date,"style11")%></td>
		<td><select name="material_id_<%=i%>" id="material_id_<%=i%>" size=1 class="style11" style="width:100;"><%=Html.selectOptions(mlist, mi.material_id)%></select></td>
		<td><input type="text" name="quantity_<%=i%>"   id="quantity_<%=i%>"   class="style11" style="width:50; text-align:right" value="<%=Numeric.numberToStr(mi.quantity,0)%>"></td>
		<td><input type="text" name="material_cost_usd_<%=i%>"  id="material_cost_usd_<%=i%>"  class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(mi.material_cost_usd,_dec)%>"></td>
		<td><input type="text" name="freight_cost_usd_<%=i%>" id="freight_cost_usd_<%=i%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(mi.freight_cost_usd,_dec)%>"></td>
		<td><input type="text" name="insurance_cost_usd_<%=i%>" id="insurance_cost_usd_<%=i%>"    class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(mi.insurance_cost_usd,_dec)%>"></td>
		<td><input type="text" name="other_cost_usd_<%=i%>" id="other_cost_usd_<%=i%>"    class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(mi.other_cost_usd,_dec)%>"></td>
		<th align="right"><%=Numeric.numberToStr(mi.getAmountUsd(),_dec)%>&nbsp;</th>
		<td><input type="text" name="vat_percent_<%=i%>"    id="vat_percent_<%=i%>"    class="style11" style="width:40; text-align:right" value="<%=Numeric.numberToStr(mi.vat_percent,0)%>" ></td>
		<td><input type="text" name="remark_<%=i%>"    id="remark_<%=i%>"    class="style11" style="width:300;" value="<%=mi.remark%>"></td>
		<td width="50" align="center"><a href="JavaScript:save(<%=i%>)" style="display:<%=displayed%>">Save</a></td>
		<td width="50" align="center"><a href="JavaScript:remove(<%=i%>)" style="display:<%=displayed%>">Del.</a></td>
	    <td width="" align="center">&nbsp;</td>
	</tr>	
<%
	}
%>
	<tr bgcolor="#DDDDDD">
	  <td>&nbsp;</td>
		<td align="center"><a href="javascript:genReport()">Report</a></td>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th colspan="2"><a href="JavaScript:add()" style="display:<%=displayed%>">New</a></th>
		<td align="center">&nbsp;</td>
	</tr>
</table>

