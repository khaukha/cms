<%@include file="authentication.jsp"%>
<%	
	ibu.ucms.biz.reference.MasterList task = user.getBiz().getReference().getMasterList();
	String displayed = task.isReadOnly() ? "none" : "";	
	long selected_id = task.getSelectedId();	
	AreaDAO mdao  = dao.getAreaDao();
	AreaEntity en = mdao.getById(selected_id); 
	if (en.isNull()) en.warehouse_id = sc.warehouse_id;
	selected_id = task.doTask(en);
%>

    <table width="100%" border="0" class="style2" cellpadding="0" cellspacing="0">
      <tr valign="top" bgcolor="#DDDDDD">
	  	<th width="200" align="center" class="style1">Value</th>
        <th align="center">Detail</th>
      </tr>
      <tr>
	  	<td valign="top"><select name="selected_id" id="selected_id" size="26" class="style2" style="width:100%" onChange="doPost()"><%=Html.selectOptions(mdao.getByWarehouseId(sc.warehouse_id), en.getIdInt())%></select></td>
        <td align="center" valign="center">
		
<table width="100%" border="0" class="style2">
		<tr>
		  <td width="150" align="right">Table</td>
		  <td width="10">&nbsp;</td>
		  <td lass="style1">AREA_MASTER</td>
		  <td width="10">&nbsp;</td>
	  </tr>
		<tr>
			<td align="right">ID</td>
			<td>&nbsp;</td>
			<td class="style1"><label id="id"><%=en.getIdInt()%></label></td>
			<td>&nbsp;</td>
		</tr>
          <tr>
            <td align="right">Warehouse <%=mandatory%></td>
            <td>&nbsp;</td>
            <td><select name="warehouse_id" id="warehouse_id" class="style2" style="width:150;" onChange="doPost();"><%=Html.selectOptions(user.selectWarehouse(),sc.warehouse_id)%></select></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Name </td>
            <td>&nbsp;</td>
            <td><input name="short_name" type="text" id="short_name" style="width:150" value="<%=en.short_name%>"></td>
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
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
</table>

	</td>
      </tr>
	  <tr style="display:<%=displayed%>">
	  	<td valign="middle"><img src="images/new.gif" width="15" height="15" onClick="doAddNew()">
			<img src="images/delete.gif" width="15" height="15" onClick="doDelete()"></td>
	  	<td align="left" valign="middle"><img src="images/update.gif" width="15" height="15" onClick="doTask(1)"></td>
	  </tr>
    </table>

<script language="javascript">
	if (<%=selected_id%> == -1) {		
		var idx = addNewListItem(document.formMain.selected_id, "New Item");
	}
</script>

