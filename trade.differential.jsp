<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Differential task = user.getBiz().getTrade().getDifferential();
	task.select();
	String displayed = task.isReadOnly() ? "none" : "";			
%>

<%@include file="header.jsp"%>

<%
	QualityEntity quality = task.doTask();
	java.sql.Date pre_month = DateTime.previousMonth(sc.getMonthEnd());
	int screen = requester.getInt("screen", -1);
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

function validate(o)
{
	if (o == null) return;
	o.value = trim(o.value);
	if (o.value.length > 0) {
		formatNumberObj(o,2);
	}
}

function doCopy(o, no)
{
	validate(o);
	//var value = format getValue("value_0_" + no);
	for (i = 1; i < 10 ; i++) {
		var name = "value_" + i + "_" + no;
		if (getObj(name) == null) break;
		setValue(name, o.value);
	}
	var name = "value_l_" + no;
	setValue(name, o.value);
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

<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2" style="padding-top:1">
      <tr>
	  	<td width="300"><img src="images/differentials.jpg"></td>
        <td width="90" align="right">Select Quality &nbsp;</td>
        <td width="120"><select name="quality_id" id="quality_id" class="style2" style="width:118px;"  onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.quality_id)%></select></td>
        <td align="right" width="100">Month-End &nbsp;</td>
		<td width="60"><select name="month" id="month" class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(Html.months,sc.month)%></select></td>
		<td width="60"><select name="year" id="year" class="style2" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(Html.years,sc.year)%></select></td>
		<td align="right">Screen &nbsp;</td>
		<td width="70"><select name="screen" id="screen" class="style2" style="width:68px;" onChange="doPost();">
			<option value="-1" <%=screen==-1?"selected":""%>>All</option>
			<option value="12" <%=screen==12?"selected":""%>>12</option>
			<option value="13" <%=screen==13?"selected":""%>>13</option>
			<option value="14" <%=screen==14?"selected":""%>>14</option>
			<option value="15" <%=screen==15?"selected":""%>>15</option>
			<option value="16" <%=screen==16?"selected":""%>>16</option>
			<option value="17" <%=screen==17?"selected":""%>>17</option>
			<option value="18" <%=screen==18?"selected":""%>>18</option>
			<option value="0"  <%=screen== 0?"selected":""%>>Others</option>
		</select></td>
      </tr>
</table>


<table  width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
  <tr bgcolor="#DDDDDD">
    <th align="left">&nbsp; <%=quality.short_name%> &nbsp;-&nbsp; <%=DateTime.dateToTerminalMonth(sc.getMonthEnd())%></th>
  </tr>

<%	
	int num = 5;
	java.sql.Date[] tms = task.getTerminalMonths(num);
%>        
<%  for (int i = 0; i < tms.length; i++) {%> <input type="hidden" name="tm_<%=i%>" id ="tm_<%=i%>" value="<%=tms[i]%>" /> 
<% } %>
</table>


<div style="border:thin; border-style:solid; border-width:1; width:100%; margin-left:1; margin-right:1;">	

<table  width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
        <tr bgcolor="#DDDDDD">
          <th width="300">Grade</th>
          <th width="50">Code</th>
          <th width="60">Local<br />Market</th>
          <th width="60"><%=DateTime.dateToTerminalMonth(tms[0])%></th>
          <th width="60"><%=DateTime.dateToTerminalMonth(tms[1])%></th>
          <th width="60"><%=DateTime.dateToTerminalMonth(tms[2])%></th>
          <th width="60"><%=DateTime.dateToTerminalMonth(tms[3])%></th>
          <th width="60"><%=DateTime.dateToTerminalMonth(tms[4])%></th>
          <th width="60">Later</th>
          <th width="60"><img src="../shared/images/refresh.gif"  style="cursor:pointer" onclick="doPost()" title="Refresh" /></th>
          <th>&nbsp;</th>
        </tr>
</table>
			
<div style="width:100%; overflow:scroll; height:350px;">
<table  width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
<%
	List<GradeEntity> grades = task.getGrades();
	DifferentialEntity[] dis = new DifferentialEntity[num];
	boolean existed = false;
	for (int i = 0; i < grades.size(); i++) {
		GradeEntity grade = grades.get(i);
		DifferentialEntity lm = task.getDifferential(grade.getIdInt(), null);
		existed = existed || !lm.isNull();
		for (int j = 0; j < num; j++) {
			dis[j] = task.getDifferential(grade.getIdInt(), tms[j]);
			existed = existed || !dis[j].isNull();
		}
		DifferentialEntity dl = task.getDifferential(grade.getIdInt(), DateTime.NullDate);
		existed = existed || !dl.isNull();
%>		
		<input type="hidden" name="grade_id_<%=i%>" id ="grade_id_<%=i%>" value="<%=grade.getIdInt()%>" />
        <tr bgcolor="#EEEEEE" onclick="highlightOn(this)">
          <td width="300" align="left"><%=grade.short_name%></td>
          <td width="50"><input name="grade_code_<%=i%>" type="text" id="grade_code_<%=i%>" class="style2" style="width:48px; text-align:center" value="<%=grade.grade_code%>" /></td>
          <td width="60"><input name="value_m_<%=i%>" type="text" id="value_m_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=lm.isNull()?"":Numeric.numberToStr(lm.value,2)%>" onchange="validate(this)" /></td>
          <td width="60"><input name="value_0_<%=i%>" type="text" id="value_0_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=dis[0].isNull()?"":Numeric.numberToStr(dis[0].value,2)%>" onchange="doCopy(this,<%=i%>)" /></td>
          <td width="60"><input name="value_1_<%=i%>" type="text" id="value_1_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=dis[1].isNull()?"":Numeric.numberToStr(dis[1].value,2)%>" onchange="validate(this)" /></td>
          <td width="60"><input name="value_2_<%=i%>" type="text" id="value_2_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=dis[2].isNull()?"":Numeric.numberToStr(dis[2].value,2)%>" onchange="validate(this)" /></td>
          <td width="60"><input name="value_3_<%=i%>" type="text" id="value_3_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=dis[3].isNull()?"":Numeric.numberToStr(dis[3].value,2)%>" onchange="validate(this)" /></td>
          <td width="60"><input name="value_4_<%=i%>" type="text" id="value_4_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=dis[4].isNull()?"":Numeric.numberToStr(dis[4].value,2)%>" onchange="validate(this)" /></td>
          <td width="60"><input name="value_l_<%=i%>" type="text" id="value_l_<%=i%>" class="style2" style="width:58px; text-align:right" value="<%=dl.isNull()?"":Numeric.numberToStr(dl.value,2)%>" onchange="validate(this)" /></td>
          <td width="60" align="center"><a href="javaScript:saveRow(<%=i%>)" style="display:<%=displayed%>">Save</a></td>
          <td align="center">&nbsp;</td>
        </tr>
<%
	}
%>
</table>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2" style="padding:1">
        <tr bgcolor="#DDDDDD">
          <td width="150" style="display:<%=displayed%>">&nbsp; <a href="javaScript:saveAll()" style="display:<%=existed?"":"none"%>">Save All</a><a href="JavaScript:doTask(4)" style="display:<%=existed?"none":""%>" class="style2">Copy From <strong><%=DateTime.dateToTerminalMonth(pre_month)%></strong></a></td>
		  <td>&nbsp;</td>
		  <td width="60" align="right">&nbsp; <a href="javaScript:doTask(3);">Report</a> &nbsp;</td>
        </tr>
</table>
</div>
    <input type="hidden" name="no"       id="no"       value="-1" />
</form>  

<%@include file="footer.jsp"%>

