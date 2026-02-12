
<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");	
		return;
	}
	
	ibu.ucms.biz.reference.ExchangeRate task = user.getBiz().getReference().exchange_rate;
	
	((Task)task.getOwner()).clearFocus();
	task.setFocus(true);
	//task.forwardToChild(user.getuid());		
%>

<%@include file="header.jsp"%>

<%
	ExchangeRateEntity ex = task.doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">

getObj("main_window").width = "800";

function doAddNew(id)
{
	if (addNewListItemById("exchange_rate_id","New Item") >= 0) 
	{
		doPost();
	}
}

function deleteEx()
{
	var id = "exchange_rate_id";
	var s = "Are you sure to delete item: " + getSelectedText(id) + " (" + getSelectedValue(id) + ")";
	if (confirm(s) == 1) 
	{
		doTask(2);
	}	
}

function saveEx()
{
	if (getValue("date") == "") {
		alert("Please select item to save.");
		return;
	}
	doTask(1);
}
</script>

<form method="POST" name="formMain" action="" onSubmit="">				
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><img src="images/exchange-rate.jpg"></td>
  </tr>
  <tr>
    <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
      <tr bgcolor="#DDDDDD">
        <th width="150">Date</th>
        <th>Detail</th>
        <th width="150">Date</th>
        <th width="150"><%=location.currency%>/USD</th>
      </tr>
      <tr>
        <td valign="top"><select name="exchange_rate_id" id="exchange_rate_id" size=26 class="style11" style="width:100%;" onChange="doPost();">
              <option value="0" selected>All</option>
              <%writer.setOption(task.getExchangeRate_List());%>
              <%writer.setSelected("exchange_rate_id",ex.getIdLong());%>
            </select></td>
        <td><table width="100%"  border="1" cellspacing="1" cellpadding="0">
          <tr>
            <td height="368px"><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
              <tr>
                <td align="right" width="120">ID</td>
                <td align="right" width="5">&nbsp;</td>
                <td><strong><%=ex.getIdLong()%></strong></td>
				</tr>
              
              <tr>
                <td align="right">Date</td>
                <td align="right">&nbsp;</td>
                <td><%=Html.datePicker("date",ex.date)%></td>
				</tr>
              <tr>
                <td align="right"><%=location.currency%>/USD</td>
                <td align="right">&nbsp;</td>
                <td><input name="usd" type="text" id="usd" class="style2" style="width:70px; text-align:right" value="<%=Numeric.numberToStr(ex.usd,0)%>"></td>
				</tr>
            </table></td>
          </tr>
        </table></td>
        <td colspan="2" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><div style="overflow:scroll; height:372px;"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
<%
	List<ExchangeRateEntity> exs = task.getgetExchangeRate_Detail();
	for (int i = 0; i < exs.size(); i++) {
		ExchangeRateEntity exh = exs.get(i);
%>			
  <tr onclick="highlightOn(this)" bgcolor="#EEEEEE">
    <td width="149" align="center"><%=DateTime.dateToStr(exh.date)%></td>
    <td align="right"><%=Numeric.numberToStr(exh.usd,0)%> &nbsp;</td>
  </tr>
<%
	}
%>			
</table>

			</div></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td><img src="../shared/images/new.gif" width="15" height="15" onClick="doAddNew()"></td>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td><img src="../shared/images/update.gif" width="15" height="15" onClick="saveEx()"></td>
              <td align="right">&nbsp;</td>
            </tr>
          </table></td>
        <td colspan="2">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
</table>
  
	<input type="hidden" name="uid"        id="uid"        value="<%=user.getuid()%>">		
    <input type="hidden" name="task_id"    id ="task_id"   value="0">
</form>  

<script language="javascript">
	if (<%=ex.getIdLong()%> == -1) {	
		var idx = addNewListItem(document.formMain.exchange_rate_id,"New Item");
	}
</script>
<%@include file="footer.jsp"%>

