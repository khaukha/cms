<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.finance.Payment task = user.getBiz().getFinance().getPayment();
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";	
%>


<%@include file="header.jsp"%>

<%
	//sc.type = ' ';
	//sc.contract_type = ' ';
%>

<form method="POST" name="formMain" action="" onSubmit="" style="width:100%;" class="style2">				  

<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td><img src="images/payment.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

<%if (sc.isListView()) {%><%@include file="finance.payment.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="finance.payment.card-view.jsp"%><%}%>

<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">

</form>

<%@include file="footer.jsp"%>

