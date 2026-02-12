<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.warehouse.Consolidation task = user.getBiz().getWareHouse().getConsolidation();
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";
%>


<%@include file="header.jsp"%>

<form method="POST" name="formMain" action="" onSubmit="">		
	<%@include file="posted-fields.jsp"%>

	<%if (sc.isListView()) {%><%@include file="warehouse.consolidation.list-view.jsp"%><%}%>
	<%if (sc.isCardView()) {%><%@include file="warehouse.consolidation.card-view.jsp"%><%}%>

</form>

<%@include file="footer.jsp"%>

