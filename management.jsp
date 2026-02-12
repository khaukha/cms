<%@include file="authentication.jsp"%>
<%
	Management task = user.getBiz().getManagement();
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());	
%>
