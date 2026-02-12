<%
	request.setCharacterEncoding("utf-8");
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.traffic.Processing task = user.getBiz().getTraffic().getProcessing();
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";			
%>

<%@include file="header.jsp"%>

<form method="POST" name="formMain" action="" onSubmit="">		
<%@include file="posted-fields.jsp"%>

<%if (sc.isListView()) {%><%@include file="traffic.processing.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="traffic.processing.card-view.jsp"%><%}%>

</form>

<%@include file="footer.jsp"%>


