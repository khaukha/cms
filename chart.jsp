<%@ page import="pc.system.*,ibu.ucms.*,ibu.ucms.biz.*" %>

<%
    User user = CMS.getUser(pageContext);
	if (!user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");
		return;
	}

	Chart task = user.getBiz().chart;
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());	
	
%>

