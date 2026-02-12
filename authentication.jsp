<%
    ibu.ucms.User user = ibu.ucms.CMS.getUser(pageContext);
	ibu.ucms.User usr = user;
	
	if (!user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");
		return;
	}
%>
<%@include file="init.jsp"%>
