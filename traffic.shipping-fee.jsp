<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.traffic.ShippingFee task = user.getBiz().getTraffic().getShippingFee();
	task.getOwner().clearFocus();
	task.setFocus(true);	
	String displayed = task.isReadOnly() ? "none" : "";			
	
%>

<%@include file="header.jsp"%>

<script language="JavaScript" src="traffic.js"></script>

<script language="javascript" type="text/javascript">
function doCardView()
{
	setValue("view",1);
	doPost();
}

function doListView()
{
	setValue("view",0);
	doPost();
}

function viewSI(inst_id)
{	
	setValue("inst_id", inst_id);
	document.formMain.action = "traffic.si.jsp";
	doCardView();
}
</script>

<%
	long shipping_bill_id = task.doTask();
%>

<form method="POST" name="formMain" action="" onSubmit="">		
	<%@include file="posted-fields.jsp"%>	

<% if (sc.isListView()) {%><%@include file="traffic.shipping-fee.list-view.jsp"%><%}%>
<% if (sc.isCardView()) {%><%@include file="traffic.shipping-fee.card-view.jsp"%><%}%>

<input type="hidden" name="inst_id" id="inst_id"  value="0">
<input type="hidden" name="search_field"   id="search_field"    value="si.ref_number">

</form>

<%@include file="footer.jsp"%>
