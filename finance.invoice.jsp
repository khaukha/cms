<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.finance.Invoice task = user.getBiz().getFinance().getInvoice();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="header.jsp"%>
<%
	String displayed = task.isReadOnly() ? "none" : "";		
%>

<form method="POST" name="formMain" action="" onSubmit="">
	<%@include file="posted-fields.jsp"%>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td><img src="images/invoice.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>

<%if (sc.isListView()) {%><%@include file="finance.invoice.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="finance.invoice.card-view.jsp"%><%}%>

</form>
<%@include file="footer.jsp"%>

