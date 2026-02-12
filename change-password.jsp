<%@ page import="pc.system.*,ibu.ucms.*" %>

<%@include file="header.jsp"%>
<%
    User user = usr;
	usr.doTask();
%>
<script language="javascript">

var message = "<%=user.getResponse().getMessage()%>";
if (message != "null") {
	alert(message);
	<%user.getResponse().setMessage(null);%>
}

function doChange()
{
	if (getValue("old_password") == "") {
		alert("Invalid password");
		getObj("old_password").focus();
		return false;
	}
	if (getValue("new_password") == "") {
		alert("New password can not be empty");
		getObj("new_password").focus();
		return false;
	}
	if (getValue("new_password") != getValue("re_password")) {
		alert("Retype password not correct");
		getObj("new_password").focus();
		return false;
	}
	doTask(1);
}

function keyUp(evt)
{
	var key = (window.Event) ? evt.which : evt.keyCode;
	if (key == 13) {
    	return doChange() ;
	}
    return true;
}

</script>
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	font-style: normal;
	font-weight: normal;
	font-variant: normal;
}
-->
</style>

<form name="formMain" method="post" action="" onSubmit="" >
<div style="border-style:solid; border-width:0; width:800px; height:280px; padding-top:120px" class="style2" align="center">
<table border="0" cellspacing="1" cellpadding="0" class="style1" align="center">
                      <tr>
                        <td colspan="2"><strong>Welcome <%=usr.getFullName()%> to Ibero Uganda</strong></td>
                      </tr>
                      <tr>
                        <td height="12">&nbsp;</td>
						<td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="200">Current password *</td>
                        <td width="200"><input type="password" name="old_password" id="old_password" autocomplete="off" style="font-family:Arial; font-size:12; width:120;">
						<script language="JavaScript">
							document.formMain.old_password.focus();
						</script>
						</td>
                      </tr>
                      <tr> 
                        <td>New password *</td>
                        <td><input type="password" name="new_password" id="new_password" autocomplete="off" style="font-family:Arial; font-size:12; width:120;"></td>
                      </tr>
					  <tr> 
                        <td>Confirm new password *</td>
                        <td><input type="password" name="re_password" id="re_password" autocomplete="off" onKeyPress="javascript:keyUp(event);" style="font-family:Arial; font-size:12; width:120;"></td>
                      </tr>
					  <tr>
					    <td>&nbsp;</td>
					    <td><img src="images/update.gif" width="15" height="15" onClick="doChange()" alt="Ok">&nbsp;<img src="images/delete.gif" width="15" height="15" onClick="javascript: doFilter('home.jsp')" alt="Cancel"></td>
	      </tr>
                    </table>
</div>

	<input type="hidden" name="uid"       id = "uid"      value="<%=usr.getuid()%>">
    <input type="hidden" name="task_id"    id = "task_id"   value="0">
    <input type="hidden" name="linkPage"  id = "linkPage" value="home.jsp">
</form>

<%@include file="footer.jsp"%>

