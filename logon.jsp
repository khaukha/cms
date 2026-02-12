<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" language="java"  errorPage="" %>
<%@ page import="pc.system.*, pc.jsp.*, ibu.ucms.*" %>
<%   
	User user = CMS.getUser(pageContext); 
	String language = Request.get(request).getString("language","");
%>

<script type="text/javascript" language="JavaScript">


//getObj("main_window").width = "";

function doLogon()
{
	var form = document.formMain;
	if ((form.username.value == '') || (form.password.value == ''))
	{
		alert("Username and Password can not be empty");
		form.username.focus();
		return;
	}
	form.submit();
}


function keyUp(evt)
{
	var key = (window.event) ? evt.keyCode : evt.which;
	if (key == 13) {
    	doLogon() ;
		return false;
	}
    return true;
}

function cancelLogon()
{
	var form = document.formMain;
	form.username.value = '';
	form.password.value = ''
	form.username.focus();
}

</script>

 <form style="width:100%" method="POST" name="formMain" action="CMS" onSubmit="">				  

<div style="width:100%; padding-bottom:60" align="center"><img src="images/banner1.gif"></div>
	  

<table width="100%" border="0" cellspacing="1" cellpadding="0" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
	<tr style="padding-bottom:4">
    	<td width="380">&nbsp;</td>
        <td colspan="2" style="font-weight:bold">Welcome to Ibero Uganda Ltd.</td>
    </tr>
              <tr>
                <td>&nbsp;</td>
                <td colspan="2">
                    <table width="100%" border="0" cellspacing="1" cellpadding="0" style="font-family:Arial, Helvetica, sans-serif;font-size:12px">
                      <tr>
                        <td width="80">User Name</td>
                        <td><input type="text" name="username" id="username" autocomplete="off" style="font-family:Arial; font-size:12; width:120;" \></td>
                      </tr>
                      <tr>
                        <td>Password</td>
                        <td><input type="password" name="password" autocomplete="off"  onKeyUp="keyUp(event);" style="font-family:Arial; font-size:12px; width:120px;"></td>
                      </tr>
                      <tr>
                        <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="160">&nbsp;</td>
                              <td width="22"><img src="images/update.gif" width="15" height="15" onClick="doLogon()" alt="Ok"></td>
                              <td><img src="images/delete.gif" width="15" height="15" onClick="cancelLogon()" alt="Cancel"></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table>
                  </td>
              </tr>
              <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px; display:">
                <td>&nbsp;</td>
                <td width="84">&nbsp;</td>
                <td width="586">&nbsp;</td>
              </tr>
</table>

				 
	<input type="hidden" name="uid"       id="uid"       value="<%=user.getuid()%>">		
    <input type="hidden" name="task_id"    id = "task_id"   value="<%=Action.LOGIN%>">
    <input type="hidden" name="linkPage"  id = "linkPage" value="home.jsp">
    <input type="hidden" name="language"  id = "language" value="<%=user.getLanguage()%>">
</form>  

<script language="JavaScript">
	document.formMain.username.focus();
</script>

