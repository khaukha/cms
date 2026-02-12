<%
	LocationEntity en = (LocationEntity)ben; 
	add_new = false;
%>
	<table width="100%" border="0" class="style2">
		<tr>
		  <td width="150" align="right">Table</td>
		  <td>&nbsp;</td>
		  <td lass="style1">LOCATION_MASTER</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr>
			<td width="98" align="right">ID</td>
			<td width="10">&nbsp;</td>
			<td class="style1"><label id="id"><%=en.getIdInt()%></label></td>
			<td width="10">&nbsp;</td>
		</tr>
          <tr>
            <td align="right">Name </td>
            <td>&nbsp;</td>
            <td><input name="short_name" type="text" id="short_name" style="width:300" value="<%=en.short_name%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Code <%=mandatory%></td>
            <td>&nbsp;</td>
            <td><input name="code" type="text" id="code" style="width:40" value="<%=en.code%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Currency <%=mandatory%></td>
            <td>&nbsp;</td>
            <td><input name="currency" type="text" id="currency" style="width:40" value="<%=en.currency%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Foreign Currency <%=mandatory%></td>
            <td>&nbsp;</td>
            <td><input name="foreign_currency" type="text" id="foreign_currency" style="width:40" value="<%=en.foreign_currency%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Active</td>
            <td>&nbsp;</td>
            <td><%=Html.checkBox("active",en.active)%></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
            <td><%=mandatory%>&nbsp;(3 letters in block capital)</td>
            <td>&nbsp;</td>
          </tr>
</table>
<script language="javascript">
function setFieldFocus(value)
{
	setValue("short_name","New Location");
	setFocus("short_name");
}
</script>
