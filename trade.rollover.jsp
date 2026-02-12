<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Rollover task = user.getBiz().getTrade().getRollover();
	task.select();
%>


<%@include file="header.jsp"%>

<%
	PurchaseContractEntity contract = task.doTask();
	String displayed = task.isReadOnly() ? "none" : "";			
%>

<script language="JavaScript" src="trade.js"></script>

<form method="POST" name="formMain">				
<%@include file="posted-fields.jsp"%>	

<%if (sc.isListView()) {%><%@include file="trade.rollover.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="trade.rollover.card-view.jsp"%><%}%>

<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">

</form>

<%@include file="footer.jsp"%>

