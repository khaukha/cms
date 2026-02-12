<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.admin.Account task = user.getBiz().getAdmin().getAccount();
	task.getOwner().clearFocus();
	task.setFocus(true);	
	String displayed = task.isReadOnly() ? "none" : "";	
%>
<%@include file="header.jsp"%>
<%
	UserEntity  account = task.getUser();
	task.doTask(account);	
	String disabled = account.active?"":"disabled";
	String checked = account.active?"checked":"";
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "80%";
function doCheckAll(cbx)
{
	var level = cbx.name.substring(4,5);
	var perm  = cbx.checked ? parseInt(cbx.value) : 0;;
	setValue("level",level);
	setValue("permission",perm);
	doTask(3);
}

function doCheck(cbx,menu)
{
	var perm  = cbx.checked ? parseInt(cbx.value) : 0;
	var type  = cbx.name.substring(0,4);
	var level = cbx.name.substring(4,5);
	var row   = cbx.name.substring(6);
	
	//alert(type);
	
	if (type == "full") {
		var o = getObj("read" + level + "_" + row);
		o.disabled = cbx.checked;
		o.checked  = cbx.checked;
	}
	setValue("level",level);
	//setValue("menu",menu);
	setValue("permission",perm);
	//alert(perm);
	setValue("menu" + level,menu);
	doTask(2);
}

function doSelect(level,menu)
{
	setValue("menu" + level,menu);
	doPost();
}

function newUser()
{
	if (addNewListItemById("user_id","New User") >= 0) doPost();
}

function delUser()
{
	if (parseInt(getValue("user_id")) <= 0) return;
	if (!confirm("Are you sure to delete user '" + getSelectedText("user_id") + "' ?")) return;
	doTask(4);
}

function saveUser()
{
	var user_id = parseInt(getValue("user_id"));
	if (user_id == 0) {
		alert("Please select or add a new user.");
		return;
	}
	var pw = getValue("password");
	var rw = getValue("re_password");
	if (user_id <= 0 && pw == "") {
		alert("The password can not be blank.");
		return;
	}
	if (pw != rw) {
		alert("The password was not correctly confirmed.");
		return;
	}
	doTask(1);
}
</script>

<form method="POST" name="formMain" action="" onSubmit="">				  
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
	 <tr>
	 	<td colspan="2"><img src="images/accounts.jpg"></td>
 	  </tr>
      <tr>
        <td align="center" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr>
            <td bgcolor="#EEEEEE" align="center"><strong>Accounts</strong></td>
          </tr>
          <tr>
            <td><select name="user_id" size=24 class="style2" id="user_id" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(task.getUsers(), account.getIdInt(), "Select a user")%></select></td>
          </tr>
          <tr style="display:<%=displayed%>">
            <td>
				<img src="images/new.gif" border="0" onClick="newUser()">
			<img src="images/delete.gif" width="15" height="15" border="0" onClick="delUser()">	</td>
          </tr>
        </table></td>
        <td width="88%" height="21" align="center" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
          <tr bgcolor="#EEEEEE" align="center">
            <td width="40%"><strong>User Information </strong></td>
            <td width="60%"><strong>Access Rights (R : Read Only, F : Full Control) </strong></td>
          </tr>
          <tr>
            <td valign="top"><table width="100%"  border="1" cellpadding="0" cellspacing="0" class="style2">
                    <tr>
                      <td align="center" height="364"><table width="100%"  border="0" class="style2">
              <tr>
                <th align="right" class="style2">&nbsp;</th>
                <td style="color:#FF0000"><%=account.active?"":"This account is disabled"%>&nbsp;</td>
              </tr>
              <tr>
                <th align="right" class="style2">ID &nbsp;</th>
                <td><%=account.getIdInt()%></td>
              </tr>
              <tr>
                <th width="34%" align="right" class="style2">User Name</th>
                <td width="66%"><input name="user_name" type="text" id="user_name" class="style2" style="width:100%; text-align:left" tabindex="10" value="<%=account.user_name%>" <%=disabled%>></td>
              </tr>
              <tr>
                <th align="right" class="style2">Password</th>
                <td><input name="password" type="password" id="password" class="style2" style="width:100%; text-align:left" tabindex="10" value="" <%=disabled%>></td>
              </tr>
              <tr>
                <th align="right" class="style2">Confirm Password</th>
                <td><input name="re_password" type="password" id="re_password" class="style2" style="width:100%; text-align:left" tabindex="10" value="" <%=disabled%>></td>
              </tr>
              <tr>
                <th align="right" class="style2">Full Name</th>
                <td><input name="full_name" type="text" id="full_name" class="style2" style="width:100%; text-align:left" tabindex="10" value="<%=account.full_name%>" <%=disabled%>></td>
              </tr>
              <tr style="display:">
                <th align="right" class="style2">Location</th>
                <td><select name="location_id" id="location_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getLocationDao().selectAll(), account.location_id, "Select Location")%></select></td>
              </tr>
              <tr>
                <th align="right" class="style2">Max Login</th>
                <td><input name="max_login" type="text" id="max_login" class="style2" style="width:40px; text-align:right" tabindex="10" value="<%=account.max_login%>" <%=disabled%>></td>
              </tr>
              <tr style="display:">
                <td align="right">Admin</td>
                <td><%=Html.checkBox("admin",account.admin)%> &nbsp;&nbsp; Read Only &nbsp;<%=Html.checkBox("read_only", account.read_only)%></td>
              </tr>
              <tr>
                <td align="right">Active</td>
                <td><%=Html.checkBox("active",account.active)%></td>
              </tr>
            </table></td>
                    </tr>
            </table></td>
            <td><table width="100%"  border="1" align="center" cellpadding="0" cellspacing="0" class="style2">
			  <tr>
			    <td height="364" width="33%" valign="top"><table width="100%"  border="0" class="style2">
				  <tr bgcolor="#CCFFFF" align="center">
				    <td width="13%">R</td>
				    <td width="13%">F</td>
				    <th width="74%">Access Rights</th>
				    </tr>
<%
	for (int i = 0; i < user.getChildSize() ; i++) { 
		Task ts = (Task)(user.getTask(i));
		String menu = ts.getTaskName();
		String name = ts.getTaskName().substring(0,1).toUpperCase() + ts.getTaskName().substring(1).toLowerCase();
		int perm = task.getPermission(account, menu, 1);
%>
                  <tr id="<%=menu%>" style="z-index:1">
                    <td><input type="checkbox" name="read1_<%=i%>" id="read1_<%=i%>" value="1" onClick="doCheck(this,'<%=menu%>')"; <%=(perm&1)==1?checked:""%> <%=task.isReadOnly()||(perm&3)==3?"disabled":disabled%>></td>
                    <td><input type="checkbox" name="full1_<%=i%>" id="full1_<%=i%>" value="3" onClick="doCheck(this,'<%=menu%>')"; <%=(perm&3)==3?checked:""%> <%=task.isReadOnly()?"disabled":disabled%> ></td>
                    <td><a href="javascript:doSelect(1,'<%=menu%>');" style="color:#000000 "><%=name%></a></td>
                  </tr>
<%
	}
%>				  
                </table></td>
			    <td width="33%" valign="top"><table width="100%"  border="0" class="style2">
				  <tr bgcolor="#CCFFFF" align="center">
                    <td width="13%">R</td>
                    <td width="13%">F</td>
                    <th width="74%">Access Rights</th>
                  </tr>
<%
	Task  ta1 = task.getTask(user,requester.getString("menu1"));
	for (int i = 0; (ta1 != null) && (i < ta1.getChildSize()) ; i++) {
		Task ts = (Task)(ta1.getTask(i));
		String menu = ts.getTaskName();
		int perm = task.getPermission(account, menu, 2);		
		String name = ts.getTaskName().toLowerCase();
		if (name.equals("wn")) name = "Weight Note";
		if (name.equals("stock-plan")) name = "Stock Plan";
		if (name.equals("terminal-price")) name = "Terminal Prices";
		if (name.equals("ave-pc")) name = "Q.Average P.Contract";
		if (name.equals("di")) name = "Delivery Instruction";
		if (name.equals("po")) name = "Processing Order";
		if (name.equals("exchange-rate")) name = "Exchange Rate";
		if (name.equals("master-list")) name = "Master List";
		if (name.equals("si")) name = "Shipping Instruction";
		if (name.equals("shipping-fee")) name = "Shipping Fees";
		
		name = name.substring(0,1).toUpperCase() + name.substring(1);
%>
                  <tr id="<%=menu%>" style="z-index:2">
                    <td><input type="checkbox" name="read2_<%=i%>" id="read2_<%=i%>" value="1" onClick="doCheck(this,'<%=menu%>')"; <%=(perm&1)==1?checked:""%> <%=task.isReadOnly()||(perm&3)==3?"disabled":disabled%>></td>
                    <td><input type="checkbox" name="full2_<%=i%>" id="full2_<%=i%>" value="3" onClick="doCheck(this,'<%=menu%>')"; <%=(perm&3)==3?checked:""%> <%=task.isReadOnly()?"disabled":disabled%>></td>
					<td><a href="javascript:doSelect(2,'<%=menu%>');" style="color:#000000 "><%=name%></a></td>
                  </tr>
<%
	}
%>				  
                </table></td>
				<td width="34%" valign="top"><table width="100%"  border="0" class="style2">
				  <tr bgcolor="#CCFFFF" align="center">
                    <td width="13%">R</td>
                    <td width="13%">F</td>
                    <th width="74%">Access Rights</th>
                  </tr>
<%
	Task  ta2 = task.getTask(ta1,requester.getString("menu2"));
	for (int i = 0; (ta2 != null) && (i < ta2.getChildSize()) ; i++) {
		Task ts = (Task)(ta2.getTask(i));
		String menu = ts.getTaskName();
		int perm = task.getPermission(account, menu, 3);		
		String name = (ts.getTaskName() != null ? ts.getTaskName() : " ").toLowerCase();
		name = name.substring(0,1).toUpperCase() + name.substring(1);
%>
                  <tr id="<%=menu%>" style="z-index:3">
                    <td><input type="checkbox" name="read3_<%=i%>" id="read3_<%=i%>" value="1" onClick="doCheck(this,'<%=menu%>')"; <%=(perm&1)==1?"checked":""%> <%=(perm&3)==3?"disabled":disabled%>></td>
                    <td><input type="checkbox" name="full3_<%=i%>" id="full3_<%=i%>" value="3" onClick="doCheck(this,'<%=menu%>')"; <%=(perm&3)==3?"checked":""%> <%=disabled%>></td>
					<td><a href="javascript:doSelect(3,'<%=menu%>');" style="color:#000000 "><%=name%></a></td>
                  </tr>
                  <%
	}
%>
                </table></td>
			  </tr>
            </table></td>
          </tr>
          <tr>
            <td><a href="javascript:saveUser()"><img src="images/update.gif" width="15" height="15" border="0" style="display:<%=displayed%>"></a></td>
            <td>&nbsp;</td>
          </tr>
        </table></td>
      </tr>
  </table>	
	<input type="hidden" name="uid"     id="uid"     value="<%=user.getuid()%>">
	<input type="hidden" name="task_id" id="task_id" value="0">
	<input type="hidden" name="level"   id="level"   value="0">
	<input type="hidden" name="permission" id="permission" value="0">
	
	<input type="hidden" name="menu1"   id="menu1"   value="<%=requester.getString("menu1","")%>">
	<input type="hidden" name="menu2"   id="menu2"   value="<%=requester.getString("menu2","")%>">
	<input type="hidden" name="menu3"   id="menu3"   value="<%=requester.getString("menu3","")%>">
</form>

<script language="javascript">
	if (<%=account.getIdInt()%> < 0) {	
		var idx = addNewListItem(document.formMain.user_id,"New User");
	}

	var o = getObj("<%=requester.getString("menu1")%>");
	if (o != null && o.style.zIndex == 1) o.bgColor ="#E7E5C4";	
	var o = getObj("<%=requester.getString("menu2")%>");
	if (o != null && o.style.zIndex == 2) o.bgColor ="#E7E5C4";
	var o = getObj("<%=requester.getString("menu3")%>");
	if (o != null && o.style.zIndex == 3) o.bgColor ="#E7E5C4";
</script>

<%@include file="../footer.jsp"%>

