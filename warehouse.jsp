<%@include file="authentication.jsp"%>
<%
	WareHouse task = user.getBiz().getWareHouse();
	task.getOwner().clearFocus();
	task.setFocus(true);
	task.forwardToChild(user.getuid());	
%>

