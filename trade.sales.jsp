<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Sales task = user.getBiz().getTrade().getSales();
	task.select();
	String displayed = task.isReadOnly() ? "none" : "";		
%>


<%@include file="header.jsp"%>
<%
	sc.filter_warehouse_id = 0;
%>
<script language="JavaScript" src="trade.js"></script>

<%if (sc.isListView()) {%><%@include file="trade.sales.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="trade.sales.card-view.jsp"%><%}%>

<%@include file="footer.jsp"%>

