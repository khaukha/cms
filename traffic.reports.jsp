<%
    User user = CMS.getUser(pageContext);
	if (!user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");
		return;
	}
	
	Report task = user.getBiz().getTraffic().getReport();
	task.select();
%>

<%@include file="reports.jsp"%>
