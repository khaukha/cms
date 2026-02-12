<%@include file="authentication.jsp"%>
<%
	Admin task = user.getBiz().getAdmin();
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());	
%>
