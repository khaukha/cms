<%
    User user = CMS.getUser(pageContext);
	Report task = user.getBiz().getWareHouse().getReport();
	task.select();
%>
<%@include file="reports.jsp"%>
