<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");	
		return;
	}
	
	ibu.ucms.biz.finance.ExchangeRate task = user.getBiz().getFinance().getExchangeRate();
	
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";	
%>

<%@include file="header.jsp"%>

<%
	task.doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

function validate(o, l)
{
	if (l == null) l = 0;
	formatNumberObj(o, l);
}

function saveRow(no)
{
	setValue("no", no);
	doTask(2);
}

function saveAll()
{
	doTask(1);
}

function doGenerateReport()
{
	doTask(3);
}

function cancelGenerateReport()
{
	cancelReport('terminal_price');
}
	
</script>
<form method="POST" name="formMain" action="" onSubmit="">	
<%@include file="posted-fields.jsp"%>
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
      <tr>
        <td width="60" align="right">&nbsp; Month &nbsp;</td>
		<td width="60"><select name="month" id="month" class="style11" style="width:60;" onChange="doPost();"><%=Html.selectOptions(Html.months,sc.month)%></select></td>
		<td width="60"><select name="year" id="year" class="style11" style="width:60" onChange="doPost();"><%=Html.selectOptions(Html.years,sc.year)%></select></td>
		<td>&nbsp;</td>
      </tr>
</table>

<div style="border:thin; border-style:solid; border-width:1; border-left:0; border-right:0; border-bottom:0 width:100%;">	
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
        <tr bgcolor="#DDDDDD">
          <th width="100" rowspan="2">Date</th>
          <th colspan="2">Official Rate </th>
          <th width="70" rowspan="2">Market<br />EUR-USD</th>
          <th width="60" rowspan="2"><img src="../shared/images/refresh.gif"  style="cursor:pointer" onclick="doPost()" title="Refresh" /></th>
          <th rowspan="2">&nbsp;</th>
        </tr>
        <tr bgcolor="#DDDDDD">
          <th width="70">USD-<%=location.currency%></th>
          <th width="70">EUR-<%=location.currency%></th>
        </tr>
</table>
	  			
<div style="width:100%; overflow:scroll; height:350px;">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
<%
	List<ExchangeRateEntity> exs = task.getByMonth();
	for (int i = 0; i < exs.size(); i++) {
		ExchangeRateEntity ex = exs.get(i);
%>		
		<input type="hidden" name="ex_id_<%=i%>" id ="ex_id_<%=i%>" value="<%=ex.getIdLong()%>" />
		<input type="hidden" name="date_<%=i%>" id ="date_<%=i%>" value="<%=ex.date%>" />
        <tr bgcolor="#EEEEEE" onclick="highlightOn(this)">
          <th width="100"><%=ex.date%></th>
          <td width="70"><input name="official_usd_local_<%=i%>" type="text" id="official_usd_local_<%=i%>" class="style11" style="width:70; text-align:right" value="<%=Numeric.numberToStr(ex.official_usd_local,0,"")%>" onchange="validate(this)" /></td>
          <td width="70"><input name="official_eur_local_<%=i%>" type="text" id="official_eur_local_<%=i%>" class="style11" style="width:70; text-align:right" value="<%=Numeric.numberToStr(ex.official_eur_local,0,"")%>" onchange="validate(this)" /></td>
          <td width="70" align="right"><input name="market_eur_usd_<%=i%>" type="text" id="market_eur_usd_<%=i%>" class="style11" style="width:70; text-align:right" value="<%=Numeric.numberToStr(ex.market_eur_usd,4,"")%>" onchange="validate(this,4)" /></td>
          <td width="60" align="center"><a href="javaScript:saveRow(<%=i%>)" style="display:<%=displayed%>">Save</a></td>
          <td align="center">&nbsp;</td>
        </tr>
<%
	}
%>
</table>
</div>
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
        <tr bgcolor="#DDDDDD" style="padding:1">
          <td width="70" align="center">&nbsp; <a href="javaScript:saveAll()" style="display:<%=displayed%>">Save All</a></td>
		  <td align="right">Report From &nbsp;</td>
		  <td width="94" align="right"><%=Html.datePicker("report_date_from",sc.report_date_from,"style11")%></td>
		  <td width="30" align="center">To</td>
		  <td width="94" align="right"><%=Html.datePicker("report_date_to",sc.report_date_to,"style11")%></td>
		  <td width="54" align="right" style="display:">&nbsp; <a href="javaScript:doTask(3);">Report</a> &nbsp;</td>
        </tr>
</table>
</div>
    <input type="hidden" name="no"       id="no"       value="-1" />
</form>  

<script language="javascript">
</script>
<%@include file="footer.jsp"%>

