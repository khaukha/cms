<%@ page import="pc.jsp.*, ibu.ucms.biz.chart.*, ibu.ucms.biz.chart.servlet.*" %>

<%
    User user = CMS.getUser(pageContext);

	ibu.ucms.biz.management.Chart chart = user.getBiz().getManagement().getChart();
	char chart_type = Request.get(request).getChar("chart_type", 'I');
%>

<%@include file="header.jsp"%>

<%if (chart_type == 'I') {%><%@include file="chart.import.jsp"%><%}%> 
<%if (chart_type == 'E') {%><%@include file="chart.export.jsp"%><%}%>

<%@include file="footer.jsp"%>

