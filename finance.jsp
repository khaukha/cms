<%@include file="authentication.jsp"%>
<%
	Finance task = user.getBiz().getFinance();
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());	
%>


