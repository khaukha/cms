<script type="text/javascript" language="javascript">
function saAllocation(cbx, sample_id)
{
	setValue("check", cbx.checked ? 1 : 0);
	setValue("sample_id", sample_id);
	doTask(11);
}
</script>
<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
	<tr bgcolor="#DDDDDD">
	  <th width="40">Id</th>
		<th width="130">Sample Ref</th>
		<th width="70">Date</th>
		<th width="60">Kgs</th>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>	
<div style="overflow:scroll; height:250px; width:100%">
<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
<%
	List<WnrSampleEntity> wnss = dao.getWnrSampleDao().getByWnaId(0);
	wnss.addAll(dao.getWnrSampleDao().getByWnaId(wn.getIdLong()));
	double sum_sa = 0;
	for (int i = 0; i < wnss.size(); i++) {
		WnrSampleEntity wns = wnss.get(i);
		boolean checked = (wns.wna_id == wn.getIdLong() && wn.getIdLong() > 0);
		if (checked) sum_sa += wns.net_weight;
		String dis = wn.getIdLong() <= 0 ? "disabled" : "";
%>	
	<tr onClick="highlightOn(this)">
	  <td width="40" align="right" bgcolor="#DDDDDD"><strong><%=wns.getIdLong()%></strong>&nbsp;</td>
		<td width="130"><%=wns.getRefNumber()%></td>
		<td width="70" align="center"><%=DateTime.dateToStr(wns.date)%></td>
		<td width="60" align="right"><%=Numeric.numberToStr(wns.net_weight,1)%>&nbsp;</td>
		<td><%=Html.checkBox("wns_"+i, checked, "saAllocation(this," + wns.getIdLong() + ")",dis)%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%
	}
%>
</table>
</div>
<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">

	<tr bgcolor="#DDDDDD">
	  <th width="40">&nbsp;</th>
		<th width="130">&nbsp;</th>
		<th width="70">&nbsp;</th>
		<th width="60" align="right"><%=Numeric.numberToStr(sum_sa,1)%></th>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>
	<input type="hidden" name="sample_id"  id="sample_id"  value="0">
	<input type="hidden" name="check"  id="check"  value="0">

