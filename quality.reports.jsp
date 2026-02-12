<%
    User user = CMS.getUser(pageContext);
	Report task = user.getBiz().getQuality().getReport();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="reports.jsp"%>
