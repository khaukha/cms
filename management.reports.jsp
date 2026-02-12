<%@ page import="pc.system.*,ibu.ucms.*" %>

<%
    User user = CMS.getUser(pageContext);
	if (!user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");
		return;
	}
	
	Report task = user.getBiz().getManagement().getReport();
	//task.getOwner().clearFocus();
	//task.setFocus(true);
%>

<%@include file="reports.jsp"%>
