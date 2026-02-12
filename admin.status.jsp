
<%
    User user = CMS.getUser(pageContext);
	
	if (!user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");	
		return;
	}
	ibu.ucms.biz.admin.Status task = user.getBiz().getAdmin().getStatus();
	task.getOwner().clearFocus();
	task.setFocus(true);

%>

<%@include file="header.jsp"%>

<%
	long heapSize = Runtime.getRuntime().totalMemory();
	long heapMaxSize = Runtime.getRuntime().maxMemory();
	long heapFreeSize = Runtime.getRuntime().freeMemory();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";
function reFresh() 
{
  document.formMain.submit();
}
window.setInterval("reFresh()", 60*1000);

</script>

<form method="POST" name="formMain" action="" onSubmit="">	
<img src="images/status.jpg">			  
<table width="100%" class="style2" cellpadding="1" cellspacing="1">
			<tr>
				<td width="150">Max : <%=Numeric.numberToStr(heapMaxSize,0)%></td>
				<td width="150">Current : <%=Numeric.numberToStr(heapSize,0)%></td>
				<td>Free : <%=Numeric.numberToStr(heapFreeSize,0)%></td>
			</tr>
</table>
<div style="overflow:scroll; height:250px; width:100%"><table width="100%" border="0" cellspacing="1" cellpadding="1" class="style2">
            <tr bgcolor="#DDDDDD">
              <th align="cencer" width="30"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()" /></th>
              <th width="150" align="left">User</th>
              <th width="120">IP</th>
              <th width="150">Access Location</th>
              <th width="120">Active</th>
			  <th width="120">Idle</th>
            </tr>
<%
	List<User> users = task.getActiveUsers();
	for (int i = 0; i < users.size(); i++) {
		User us = users.get(i);
		long dt = us.getTimeWatch().getSeconds();
		String s = Numeric.formatNumber(dt / 60,2) + "'" + Numeric.formatNumber(dt % 60,2) + '"';
%>	  
            <tr bgcolor="#EEEEEE" onclick="highlightOn(this)">
              <td bgcolor="#DDDDDD" align="right"><%=i+1%></td>
              <td><%=us.getUserName()+us.getuid()%></td>
              <td align="center"><%=us.ip_address%></td>
              <td align="center"><%=us.getLocation().short_name%></td>
              <td align="center"><%=DateTime.toString(us.getTimeWatch().getStartTime())%></td>
			  <td align="center"><%=s%></td>
            </tr>
<%
	}
%>	  
</table>
</div>
	<input type="hidden" name="uid"     id="uid"     value="<%=user.getuid()%>">
	<input type="hidden" name="task_id" id="task_id" value="0">
	
</form>


<%@include file="footer.jsp"%>
<%
	//Runtime.getRuntime().gc();
%>
