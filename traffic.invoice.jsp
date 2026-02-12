<%
	request.setCharacterEncoding("utf-8");
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.traffic.Invoice task = user.getBiz().getTraffic().getInvoice();
	task.select();	
	String displayed = task.isReadOnly() ? "none" : "";			
	user.getSearchCriteria().type = 'P';
%>

<%@include file="header.jsp"%>

<script language="JavaScript" src="traffic.js"></script>

<form method="POST" name="formMain" action="" onSubmit="">		
<%@include file="posted-fields.jsp"%>	

<%if (sc.isListView()) {%><%@include file="traffic.invoice.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="traffic.invoice.card-view.jsp"%><%}%>

<input type="hidden" name="type" id="type"  value="P">
</form>
<%@include file="footer.jsp"%>
