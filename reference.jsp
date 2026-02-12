<%@include file="authentication.jsp"%>
<%
	Reference task = user.getBiz().getReference();
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());	
%>

