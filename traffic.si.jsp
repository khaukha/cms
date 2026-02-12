<%
	request.setCharacterEncoding("utf-8");
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.traffic.Shipping task = user.getBiz().getTraffic().getShipping();
	task.getOwner().clearFocus();
	task.setFocus(true);	
	String displayed = task.isReadOnly() ? "none" : "";			
%>

<%@include file="header.jsp"%>

<script language="JavaScript" src="traffic.js"></script>

<form method="POST" name="formMain" action="" onSubmit="">		
<%@include file="posted-fields.jsp"%>	

<%if (sc.isListView()) {%><%@include file="traffic.si.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="traffic.si.card-view.jsp"%><%}%>

<input type="hidden" name="search_field"   id="search_field"    value="si.ref_number">

</form>
<%@include file="footer.jsp"%>
