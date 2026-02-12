<%@ page import="ibu.ucms.biz.warehouse.weighing.wn.*" %>
<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.warehouse.Weighing task = user.getBiz().getWareHouse().getWeighing();
	task.select();
%>

<%@include file="header.jsp"%>

<script language="javascript" src="warehouse.weighing.js"></script>

<%
	if (sc.wn_type == Const.NONE) sc.wn_type = 'I';
	String jsp_page = sc.isListView() ? "warehouse.weighing.list-view.jsp" : "warehouse.weighing.card-view.jsp";
%>

<script language="javascript">
	var wn_type = "<%=sc.wn_type%>";
</script>


<form method="POST" name="formMain" action="" onSubmit="">			
	<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td><img src="images/weight-notes.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>

<jsp:include page="<%=jsp_page%>">
	<jsp:param name="uid" value="<%=user.getuid()%>" />
</jsp:include>

</form>

<%@include file="footer.jsp"%>

