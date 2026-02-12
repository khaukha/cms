
<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");	
		return;
	}
	
	ibu.ucms.biz.reference.UtzProject task = user.getBiz().getReference().utz_proj;
	
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="header.jsp"%>

<%
	sc.filter_location = 3;
	
	CompanyEntity cust = task.doTask();	
	
    if (cust.isNew()) {
      cust.short_name = "New Customer";
    }
	if (cust.location_id == 0) {
	  cust.location_id = user.getLocationId();
	}

	boolean over_register = requester.getBoolean("over_register"); 
%>

<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">
	getObj("main_window").width = "";
</script>

<form method="POST" name="formMain" action="" onSubmit="">
	<%@include file="posted-fields.jsp"%>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2" style="padding:1">
      <tr>
        <th width="60" align="right">Crop &nbsp;</th>
        <th width="60"><select name="filter_crop" id="filter_crop" size=1 class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(Html.years,sc.filter_crop,"All")%></select></th>
		<td width="180" align="right" style="display:<%=sc.isListView()?"":""%>">Show Only Exceed Register</td>
		<td style="display:<%=sc.isListView()?"":""%>"><%=Html.checkBox("over_register", over_register, "doPost()")%></td>
	    <td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

	<%if (sc.isListView()) {%><%@include file="reference.utz-project.list-view.jsp"%><%}%>
	<%if (sc.isCardView()) {%><%@include file="reference.customer.card-view.jsp"%><%}%>
	<input type="hidden" name="search_field"   id="search_field"    value="cu.short_name">
</form>  

<%@include file="footer.jsp"%>

