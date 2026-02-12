<%
    User user = CMS.getUser(pageContext);
	Report task = user.getBiz().getFinance().getReport();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="reports.jsp"%>
