<%@ page import="pc.system.*,ibu.ucms.*" %>

<%
    User user = CMS.getUser(pageContext);
	Report task = user.getBiz().getAdmin().getReport();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="reports.jsp"%>
