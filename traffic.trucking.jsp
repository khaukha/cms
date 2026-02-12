<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.traffic.Trucking task = user.getBiz().getTraffic().getTrucking();
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";		
	String readonly  = task.isReadOnly() ? "readonly" : "";
	String disabled  = task.isReadOnly() ? "disabled" : "";
	boolean is_center =  true;
%>

<%@include file="header.jsp"%>

<form method="POST" name="formMain" action="" onSubmit="" class="style2">				  

<%@include file="posted-fields.jsp"%>

<%if (sc.isListView()) {%><%@include file="traffic.trucking.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="traffic.trucking.card-view.jsp"%><%}%>

<input type="hidden" name="search_field"   id="search_field"    value="tk.truck_no">

</form>

<%@include file="footer.jsp"%>


