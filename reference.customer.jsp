
<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.reference.Customer task = user.getBiz().getReference().getCustomer();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="header.jsp"%>

<%
	CompanyEntity cust = task.doTask();	
    if (cust.isNew()) {
      cust.short_name = "New Customer";
    }
	if (cust.location_id == 0) {
		cust.location_id = user.getLocationId();
	}
	String customer_type = requester.getString("customer_type","");
	List<OptionEntity> customer_types = dao.getOptionDao().toOptions("is_seller:Seller,is_buyer:Buyer,is_shipper:Shipper,is_service:Service,is_controller:Controller");
%>

<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">
	getObj("main_window").width = "";
</script>

<form method="POST" name="formMain" action="" onSubmit="">
	<%@include file="posted-fields.jsp"%>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
      <tr>
        <th width="80" align="right">Country &nbsp;</th>
	    <th width="180"><select name="filter_country_id" id="filter_country_id" class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getCountryDao().selectAll(),sc.filter_country_id,"All")%></select></th>
	    <th width="60" align="right">Type &nbsp;</th>
		<th width="100"><select name="customer_type" id="customer_type" size=1 class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(customer_types,customer_type,"All")%></select></th>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

	<%if (sc.isListView()) {%><%@include file="reference.customer.list-view.jsp"%><%}%>
	<%if (sc.isCardView()) {%><%@include file="reference.customer.card-view.jsp"%><%}%>
	<input type="hidden" name="search_field"   id="search_field"    value="cu.short_name">
</form>  

<%@include file="footer.jsp"%>

