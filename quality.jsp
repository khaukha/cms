<%@include file="authentication.jsp"%>
<%
	Quality task = user.getBiz().getQuality();
	task.getOwner().clearFocus();
	task.setFocus(true);	
	task.forwardToChild(user.getuid());
%>

