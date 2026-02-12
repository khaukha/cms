<script language="javascript" type="text/javascript">
function new4C()
{
	show("new_4C_");
	
}
</script>

<div style="width:100%; border-width:1; border-style:solid; overflow:; height:;">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
								<tr bgcolor="#DDDDDD">
									<th width="60" rowspan="2">Crop</th>
									<th colspan="3">4C Volume (Mts) </th>
									<th colspan="2" rowspan="2"><a href="JavaScript:new4C()">New</a></th>
								    <th rowspan="2">&nbsp;</th>
								</tr>
								<tr bgcolor="#DDDDDD">
								  <th width="80">Registered</th>
							      <th width="80">Delivered</th>
							      <th width="80">Balance</th>
							  </tr>
<%
	List<_4CProjectEntity> _4cs = cust.get4CProjects();
	_4CProjectEntity _4c = dao.get4CProjectDao().newEntity();
	_4cs.add(0, _4c);
	for (int j = 0; j < _4cs.size(); j++) {
		_4CProjectEntity utz = _4cs.get(j);
		int i = utzs.size() + j;
%>								
								<input type="hidden" name="utz_id_<%=i%>"  id="utz_id_<%=i%>"  value="<%=utz.getIdLong()%>">
								<tr id="<%=utz.isNull()?"new_4C_":""%>" style="display:<%=utz.isNull()?"none":""%>">
									<td><select name="crop_<%=i%>" id="crop_<%=i%>" size=1 class="style2" style="width:100%;"><%=Html.selectOptions(Html.years,utz.crop,"")%></select></td>
									<td><input name="registered_tons_<%=i%>" id="registered_tons_<%=i%>" type="text" class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(utz.registered_tons)%>"></td>
									<td align="right"><strong><%=Numeric.numberToStr(utz.delivered_tons)%></strong>&nbsp;</td>
									<td align="right"><strong><%=Numeric.numberToStr(utz.open_tons)%></strong>&nbsp;</td>
									<td width="50" align="center"><a href="JavaScript:saveUtz(<%=i%>,'4')">Save</a></td>
								    <td width="50" align="center"><a href="JavaScript:deleteUtz(<%=i%>,'4')">Del.</a></td>
								    <td>&nbsp;</td>
								</tr>
<%
	}
%>								
</table>
</div>