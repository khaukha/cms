<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.warehouse.BridgeScale task = user.getBiz().getWareHouse().getBridgeScale();
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";
%>


<%@include file="header.jsp"%>

<form method="POST" name="formMain" action="" onSubmit="">		
	<%@include file="posted-fields.jsp"%>

	<%if (sc.isListView()) {%><%@include file="warehouse.bridge-scale.list-view.jsp"%><%}%>
	<%if (sc.isCardView()) {%><%@include file="warehouse.bridge-scale.card-view.jsp"%><%}%>

</form>

<%@include file="footer.jsp"%>

