<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Delivery task = user.getBiz().getTrade().getDelivery();
	task.select();		
	String displayed = task.isReadOnly() ? "none" : "";			
%>


<%@include file="header.jsp"%>

<script language="JavaScript" src="traffic.js"></script>

<%if (sc.isListView()) {%><%@include file="trade.di.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="trade.di.card-view.jsp"%><%}%>

<%@include file="footer.jsp"%>

