<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		response.sendRedirect("logon.jsp");	
		return;
	}
	
	ibu.ucms.biz.trade.TerminalPrice task = user.getBiz().getTrade().getTerminalPrice();
	task.select();
	String displayed = task.isReadOnly() ? "none" : "";			
%>

<%@include file="header.jsp"%>

<%
	String date_txt = DateTime.dateToStr(sc.getDate());
	int quality_id = sc.quality_id;
	if (quality_id == 0) quality_id = Const.ROBUSTA;
	String price_header = quality_id == Const.ROBUSTA ? "LIFFE (USD/Mt)" : "NYC (Cts/Lb)"; 
	QualityEntity quality = dao.getQualityDao().getById(quality_id);
	task.doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

function validatePrice(o,prev)
{
	var diff = o.value - prev;
	if (diff <= -100 || diff >= 100) {
		//alert("The differential " + diff + " is too big. Please check the input value.");
	}
	formatNumberObj(o,2);
	setFocus(o.id);
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
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
      <tr>
	  	<td width="300"><img src="images/terminal-prices.jpg"></td>
        <td width="90" align="right">Select Quality &nbsp;</td>
        <td width="90"><select name="quality_id" id="quality_id" class="style2" style="width:88px;" onchange="doPost()"><%=Html.selectOptions(dao.getQualityDao().selectAll(),quality_id)%></select></td>
        <td align="right" width="60">Date &nbsp;</td>
        <td width="50"><select name="day" id="day" class="style2" style="width:100%;" onChange="doPost();">
<%
	java.sql.Date d1 = DateTime.firstDateOfMonth(sc.getDate());
	if (d1==null) d1 = DateTime.getCurDate(); 
	java.sql.Date d2 = DateTime.lastDateOfMonth(d1);
	while (d1.compareTo(d2) <= 0) {
		String selected = DateTime.getDay(d1) == sc.day ? "selected" : "";
%>
			<option value="<%=DateTime.getDay(d1)%>" <%=selected%>><%=DateTime.getDay(d1)%></option>
<%
      d1 = DateTime.nextDate(d1);
	}
%>		
		</select></td>
		<td width="60"><select name="month" id="month" class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(Html.months,sc.month)%></select></td>
		<td width="60"><select name="year" id="year" class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(Html.years,sc.year)%></select></td>
		<td>&nbsp;</td>
      </tr>
</table>
<div style="background-color:#DDDDDD; width:100%; font-weight:bold" class="style2">&nbsp; <%=quality.short_name%> &nbsp; <%=date_txt%></div>

<div style="border:thin; border-style:solid; border-width:1; width:100%; border-left:none; border-right:none">
      <table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
        <tr bgcolor="#DDDDDD">
          <th width="70" rowspan="2">Month</th>
          <th colspan="5"><%=price_header%></th>
          <th colspan="3">Kampala (1,000 <%=location.currency%>/Mt) </th>
          <th colspan="3">FOB Diff.<br />Grade 2, 5%</th>
          <th rowspan="2">&nbsp;</th>
        </tr>
        <tr bgcolor="#DDDDDD">
          <th width="60">Settle</th>
          <th width="60">Prev.</th>
          <th width="60">+/-</th>
          <th width="60">High</th>
          <th width="60">Low</th>
          <th width="60">Settle</th>
          <th width="60">Prev.</th>
          <th width="60">+/-</th>
          <th width="60">Settle</th>
          <th width="60">Prev.</th>
          <th width="60">+/-</th>
        </tr>
<%
	List<TerminalPriceEntity> tprs = task.getTerminalPrices(quality_id);
	for (int i = 0; i < tprs.size(); i++) {
		TerminalPriceEntity tp = tprs.get(i);
		String tm = DateTime.dateToTerminalMonth(tp.terminal_month);
		TerminalPriceEntity pp = tp.getPreviousPrice();
%>		
		<input type="hidden" name="id_<%=i%>" id ="id_<%=i%>" value="<%=tp.getIdLong()%>" />
		<input type="hidden" name="terminal_month_<%=i%>" id ="terminal_month_<%=i%>" value="<%=tp.terminal_month%>" />
        <tr bgcolor="#EEEEEE" align="right">
          <th bgcolor="#DDDDDD" align="center"><%=tm%></th>
          <td><input name="market_price_<%=i%>" type="text" id="market_price_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=Numeric.numberToStr(tp.market_price,2)%>" onchange="validatePrice(this,<%=pp.market_price%>)" /></td>
          <td><%=Numeric.numberToStr(pp.market_price,2)%>&nbsp;</td>
          <td><%=Numeric.numberToStr(tp.market_price - pp.market_price,2)%>&nbsp;</td>
          <td><input name="high_market_price_<%=i%>" type="text" id="high_market_price_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=Numeric.numberToStr(tp.high_market_price,2)%>" onchange="validatePrice(this,<%=pp.high_market_price%>)" /></td>
          <td><input name="low_market_price_<%=i%>" type="text" id="low_market_price_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=Numeric.numberToStr(tp.low_market_price,2)%>" onchange="validatePrice(this,<%=pp.low_market_price%>)" /></td>
          <td><input name="sg_price_<%=i%>" type="text" id="sg_price_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=Numeric.numberToStr(tp.sg_price,2)%>" onchange="validatePrice(this,<%=pp.sg_price%>)" /></td>
          <td><%=Numeric.numberToStr(pp.sg_price,2)%>&nbsp;</td>
          <td><%=Numeric.numberToStr(tp.sg_price - pp.sg_price,2)%>&nbsp;</td>
          <td><input name="fob_diff_g25_<%=i%>" type="text" id="fob_diff_g25_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=Numeric.numberToStr(tp.fob_diff_g25,2)%>" onchange="validatePrice(this,<%=pp.fob_diff_g25%>)" /></td>
          <td><%=Numeric.numberToStr(pp.fob_diff_g25,2)%>&nbsp;</td>
          <td><%=Numeric.numberToStr(tp.fob_diff_g25 - pp.fob_diff_g25,2)%>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
<%
	}
%>
</table>
</div>
<%
	int tm_month = requester.getInt("tm_month");
	int tm_year = requester.getInt("tm_year");
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
        <tr bgcolor="#DDDDDD">
          <td width="80">&nbsp; <a href="javaScript:doTask(1)" style="display:<%=displayed%>">Save</a></td>
		  <td align="right">Terminal Month/Year For Report &nbsp;</td>
		  <td width="60"><select name="tm_month" id="tm_month" class="style2" style="width:58px;">
			<option value="0" <%=tm_month==0?"selected":""%>>All</option>
			<option value="1" <%=tm_month==1?"selected":""%>>Jan</option>
			<option value="3" <%=tm_month==3?"selected":""%>>Mar</option>
			<option value="5" <%=tm_month==5?"selected":""%>>May</option>
			<option value="7" <%=tm_month==7?"selected":""%>>Jul</option>
			<option value="9" <%=tm_month==9?"selected":""%>>Sep</option>
			<option value="11" <%=tm_month==11?"selected":""%>>Nov</option>
		</select></td>
		  <td width="60"><select name="tm_year" id="tm_year" class="style2" style="width:58px;"><%=Html.selectOptions(Html.years,tm_year,"All")%></select></td>
		  <td width="80" align="right">From Date &nbsp;</td>
          <td width="92"><%=Html.datePicker("report_date_from",sc.report_date_from)%></td>
		  <td width="30" align="center">&nbsp;to&nbsp;</td>
          <td width="92"><%=Html.datePicker("report_date_to",sc.report_date_to)%></td>
          <td width="60" align="right">&nbsp; <a href="javaScript:doTask(3);">Report</a> &nbsp;</td>
        </tr>
</table>
	  	
	<input type="hidden" name="uid"        id="uid"        value="<%=user.getuid()%>" />	
    <input type="hidden" name="task_id"    id ="task_id"   value="0" />
</form>  

<%@include file="footer.jsp"%>

