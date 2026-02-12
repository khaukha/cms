<%
	request.setCharacterEncoding("utf-8");
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.reference.MasterList task = user.getBiz().getReference().getMasterList();
%>

<%@include file="header.jsp"%>

<%
	MasterListDAO ml_dao = dao.getMasterListDao();
	MasterListEntity ml = task.getMasterList();
	String jsp_page = ml.isNull() ? "reference.blank_master.jsp" : "reference." + ml.getRefNumber() + ".jsp";
%>

<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">
getObj("main_window").width = "";

function doAddNew()
{
	if (addNewListItemById("selected_id","New Item") >= 0) {
		doPost();
	}
}

function doDelete(id)
{
	if (id == null) id = "selected_id";
	var s = "Are you sure to delete item: " + getSelectedText(id) + " (" + getSelectedValue(id) + ")";
	if (confirm(s) == 1) {
		doTask(2);
	}	
}
</script>

<form method="POST" name="formMain" action="" onSubmit="">	
<%@include file="posted-fields.jsp"%>			  
<div><img src="images/master-list.jpg"></div>

<table border="0" width="" class="style2" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="150"><div style=" background-color:#DDDDDD" align="center"><strong>Master List</strong></div><select name="ml_id" size=26 class="style2" id="ml_id" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(ml_dao.selectAll(), ml.getIdInt())%></select></td>
		<td width="800"><jsp:include page="<%=jsp_page%>">
				<jsp:param name="uid" value="<%=user.getuid()%>" />
				<jsp:param name="ml_id" value="<%=ml.getIdInt()%>" />
		</jsp:include></td>
	</tr>
</table>

</form>  


<%@include file="footer.jsp"%>

