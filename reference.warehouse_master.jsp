<%//	WarehouseEntity en = (WarehouseEntity)ben; %>
<%@include file="authentication.jsp"%>
<%	
	ibu.ucms.biz.reference.MasterList task = user.getBiz().getReference().getMasterList();
	String displayed = task.isReadOnly() ? "none" : "";	

	long selected_id = task.getSelectedId();
	
	WarehouseDAO mdao  = dao.getWarehouseDao();	
	WarehouseEntity en = mdao.getById(selected_id); 
	String dis = en.active?"":"disabled";

	selected_id = task.doTask(en);
%>
<input type="hidden" name="location_id" id="location_id"  value="<%=location_id%>">


    <table width="100%" border="0" class="style2" cellpadding="0" cellspacing="0">
      <tr valign="top" bgcolor="#DDDDDD">
	  	<th width="240" align="center" class="style1">Value</th>
        <th align="center">Detail</th>
      </tr>
      <tr>
	  	<td valign="top"><select name="selected_id" id="selected_id" size="26" class="style2" style="width:100%" onChange="doPost()"><%=Html.selectOptionsX(mdao.selectByLocationId(location_id), en.getIdInt())%></select></td>
        <td align="center" valign="center">
		
<table width="100%" border="0" class="style2">
		<tr>
		  <td width="12%" align="right">Table</td>
		  <td width="2%" >&nbsp;</td>
		  <td width="85%" class="style1">WAREHOUSE_MASTER</td>
		  <td width="1%">&nbsp;</td>
	  </tr>
		<tr>
			<td align="right">ID</td>
			<td>&nbsp;</td>
		  <td class="style1"><label id="id"><%=en.getIdInt()%></label></td>
			<td>&nbsp;</td>
		</tr>
          <tr>
            <td align="right">Name </td>
            <td>&nbsp;</td>
            <td><input name="short_name" type="text" id="short_name" style="width:100%" value="<%=en.short_name%>" <%=dis%>></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Code</td>
            <td>&nbsp;</td>
            <td><input name="code" type="text" id="code" style="width:100" value="<%=en.code%>" <%=dis%>></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Address</td>
            <td>&nbsp;</td>
            <td><input name="address" type="text" id="address" style="width:100%" value="<%=en.address%>" <%=dis%>></td>
            <td>&nbsp;</td>
          </tr>
          
          <tr style="display:none">
            <td align="right">City</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Active</td>
            <td>&nbsp;</td>
            <td><%=Html.checkBox("active",en.active)%></td>
            <td>&nbsp;</td>
          </tr>
</table>

	</td>
      </tr>
	  <tr style="display:<%=displayed%>">
	  	<td valign="middle"><img src="images/new.gif" width="15" height="15" onClick="doAddNew()">
			<img src="images/delete.gif" width="15" height="15" onClick="doDelete()" style="display:none"></td>
	  	<td align="left" valign="middle"><img src="images/update.gif" width="15" height="15" onClick="doTask(1)"></td>
	  </tr>
    </table>

<script language="javascript">
	if (<%=selected_id%> == -1) {		
		var idx = addNewListItem(document.formMain.selected_id, "New Item");
	}
</script>
