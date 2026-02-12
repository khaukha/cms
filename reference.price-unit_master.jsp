<%	MasterEntity en = (MasterEntity)ben; %>

	<table width="100%" border="0" align="center" class="style2">
		<tr>
		  <td align="right">Table</td>
		  <td>&nbsp;</td>
		  <td align="" class="style1">PRICE_UNIT_MASTER</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr>
			<td width="98" align="right">ID</td>
			<td width="10">&nbsp;</td>
			<td class="style1"><label id="id"><%=en.getIdInt()%></label></td>
			<td width="10">&nbsp;</td>
		</tr>
          <tr>
            <td align="right">Price Unit </td>
            <td>&nbsp;</td>
            <td><input name="short_name" type="text" id="short_name" style="width:100" value="<%=en.short_name%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Active</td>
            <td>&nbsp;</td>
            <td><%=Html.checkBox("active",en.active)%></td>
            <td>&nbsp;</td>
          </tr>
</table>