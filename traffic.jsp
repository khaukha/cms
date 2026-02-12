<%@ page import="pc.system.*,ibu.ucms.*" %>

<%
    User user = CMS.getUser(pageContext);
	if (!user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");
		return;
	}

	ibu.ucms.biz.Traffic task = user.getBiz().getTraffic();
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());		
%>
