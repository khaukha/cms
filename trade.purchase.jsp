<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");	
		return;
	}

	ibu.ucms.biz.trade.Purchase task = user.getBiz().getTrade().getPurchase();
	task.select();
%>
<%@include file="header.jsp"%>
<%
	String displayed = task.getPermission() != 3 ? "none" : "";	
%>

<script language="JavaScript" src="trade.js"></script>

<%if (sc.isListView()) {%><%@include file="trade.purchase.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="trade.purchase.card-view.jsp"%><%}%>
	
<%@include file="footer.jsp"%>

