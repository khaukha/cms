<%request.setCharacterEncoding("utf-8");%>

<%@ page import="ibu.ucms.biz.quality.qr.wn.*" %> 

<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.quality.QR task = user.getBiz().getQuality().getQR();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>


<%@include file="header.jsp"%>

<%
	sc.warehouse_id = 0;
%>

<form method="POST" name="formMain" action="" onSubmit="">		
<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td><img src="images/quality-report.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>		  

<%if (sc.isListView()) {%><%@include file="quality.qr.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="quality.qr.card-view.jsp"%><%}%>


</form>

<script language="javascript">
	setFocus('search_key');
</script>		

<%@include file="footer.jsp"%>

