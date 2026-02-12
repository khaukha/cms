<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Payment task = user.getBiz().getTrade().getPayment();
	task.select();
	String displayed = task.isReadOnly() ? "none" : "";			
%>

<%@include file="header.jsp"%>

<form method="POST" name="formMain" action="" onSubmit="">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td><img src="images/payment.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

<%@include file="posted-fields.jsp"%>
<%if (sc.isListView()) {%><%@include file="trade.payment.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="trade.payment.card-view.jsp"%><%}%>

<input type="hidden" name="type"  id="type" value="P">		

</form>

<%@include file="footer.jsp"%>

