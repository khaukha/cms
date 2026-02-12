<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.warehouse.Material task = user.getBiz().getWareHouse().getMaterial();
	task.select();
	String displayed = task.isReadOnly() ? "none" : "";	
%>

<%@include file="header.jsp"%>

<%
	int material_id = requester.getInt("material_id");
	List<MaterialEntity> mlist = dao.getMaterialDao().selectAll();
	char mtask = requester.getChar("mtask",'I');
%>

<script language="javascript" type="text/javascript">
function add()
{
	var id = getValue("mtask") == 'I' ? "material_import_" : "material_allocation_";
	show(id);//"material_import_");
}

function save(no)
{
	setValue("no", no);
	doTask(1);
}

function remove(no)
{
	if (confirm("Are you sure to delete the selected item.")) {
		setValue("no", no);
		doTask(2);
	}
}

function genReport()
{
	doTask(3);
}

</script>
<form method="POST" name="formMain" action="" onSubmit="">
	<%@include file="posted-fields.jsp"%>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
			<tr>
			  <th width="60" align="right">Task &nbsp;</th>
			  <th width="100"><select name="mtask" id="mtask" class="style11" style="width:100" onChange="doPost();">
			  	<option value="I" <%=mtask=='I'?"selected":""%>>Import</option>
			  	<option value="A" <%=mtask=='A'?"selected":""%>>Allocation</option>
			  </select></th>
   	        	<th width="60" align="right">Month &nbsp;</th>
				<td width="60"><select name="month" id="month" class="style11" style="width:60;" onChange="doPost();"><%=Html.selectOptions(Html.months,sc.month,"All")%></select></td>
				<td width="60"><select name="year" id="year" class="style11" style="width:60;" onChange="doPost();"><%=Html.selectOptions(Html.years,sc.year,"All")%></select></td>
				<td width="80" align="right"><strong>Material</strong> &nbsp;</td>
			    <td width="150"><select name="material_id" id="material_id" size=1 class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptions(mlist, material_id, "All")%></select></td>
				<td align="right">&nbsp;<%//@include file="search.jsp"%></td>
</table>

	<%if (mtask == 'I'){%><%@include file="warehouse.material.import.jsp"%><%}%>
	<%if (mtask == 'A'){%><%@include file="warehouse.material.allocation.jsp"%><%}%>

   <input type="hidden" name="no"  id="no"  value="-1" />
</form>
<%@include file="footer.jsp"%>

