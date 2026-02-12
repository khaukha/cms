<%@include file="authentication.jsp"%>
<%	
	ibu.ucms.biz.reference.MasterList task = user.getBiz().getReference().getMasterList();
	String displayed = task.isReadOnly() ? "none" : "";	

	long selected_id = task.getSelectedId();
	
	ProcessingTypeDAO mdao  = dao.getProcessingTypeDao();	
	ProcessingTypeEntity en = mdao.getById(selected_id); 

	selected_id = task.doTask(en);
%>

    <table width="100%" border="0" class="style2" cellpadding="0" cellspacing="0">
      <tr valign="top" bgcolor="#DDDDDD">
	  	<th width="200" align="center" class="style1">Value</th>
        <th align="center">Detail</th>
      </tr>
      <tr>
	  	<td valign="top"><select name="selected_id" id="selected_id" size="26" class="style2" style="width:100%" onChange="doPost()"><%=Html.selectOptions(mdao.selectAll(), en.getIdInt())%></select></td>
        <td align="center" valign="center">

<table width="100%" border="0" class="style2">
		<tr>
		  <td align="right">Table</td>
		  <td>&nbsp;</td>
		  <td align="" class="style1">PROCESSING_TYPE_MASTER</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr>
			<td width="98" align="right">ID</td>
			<td width="10">&nbsp;</td>
			<td class="style1"><label id="id"><%=en.getIdInt()%></label></td>
			<td width="10">&nbsp;</td>
		</tr>
          <tr>
            <td align="right">Code&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="ref_number" type="text" id="ref_number" style="width:60" value="<%=en.getRefNumber()%>"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="right">Name </td>
            <td>&nbsp;</td>
            <td><input name="short_name" type="text" id="short_name" style="width:200" value="<%=en.short_name%>"></td>
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
			<img src="images/delete.gif" width="15" height="15" onClick="doDelete()"></td>
	  	<td align="left" valign="middle"><img src="images/update.gif" width="15" height="15" onClick="doTask(1)"></td>
	  </tr>
    </table>

<script language="javascript">
	if (<%=selected_id%> == -1) {		
		var idx = addNewListItem(document.formMain.selected_id, "New Item");
	}
</script>
