<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="ibu.ucms.*, pc.sql.data.*, pc.util.*, ngv.share.util.*, ibu.ucms.entity.*" %>

<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		//response.sendRedirect("logon.jsp");	
		return;
	}

	DAO dao = user.getDao();
	SearchCriteriaEntity sc = user.getSearchCriteria();
	sc.set();

	user.setActive();
	//ibu.ucms.biz.warehouse.weighing.Check task = user.getBiz().getWareHouse().weighing.getCheck();
	ibu.ucms.biz.warehouse.weighing.BridgeScale task = user.getBiz().getWareHouse().getWeighing().getBridgeScale();
	WnEntity wn = dao.getWnImportDao().newEntity();//task.getWn();
	//ScaleEntity scale = task.doTask(wn);
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Weight Check</title>

<link href="style.css" rel="stylesheet" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/Utils.js"></SCRIPT>

<script language="javascript" src="warehouse.weighing.js"></script>

<SCRIPT LANGUAGE="JavaScript">
var suspend = false;
/*
function reFresh() 
{
  if (suspend) return;
  document.formMain.submit();
}
window.setInterval("reFresh()", 5000);
*/
function doClose()
{	
	window.close();
}

function check(cbx, wnr_id)
{
	suspend = true;
	setValue("wnr_id", wnr_id);
	doTask(cbx.checked?1:2);
}

function genReport()
{
	suspend = true;
	doTask(3);
}
</SCRIPT>

</head>

<body leftmargin="16px">
<form id="formMain" name="formMain" method="post" action="warehouse.weighing.check.jsp"  class="style2" target="_self">
<strong><%=wn.getRefNumber()%></strong>&nbsp;&nbsp;(<strong><%=wn.getGrade().short_name%></strong>)
<table width="" border="0" cellpadding="1" cellspacing="1" class="style2">
	<tr>
		<td width="60px" align="right">Scale No &nbsp;</td>
		<td width="80px"><select name="scale_id" id="scale_id" class="style2" style="width:80px;" onChange=""><option value="6" selected>Scale 6</option></select></td>
		<td width="100px" align="right">Weighing Type &nbsp;</td>
		<td width="100px"><select name="wn_type" id="wn_type" class="style2" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
		<td width="100px" align="right">DI/SI/TR Ref &nbsp;</td>
		<td width="100px"><select name="inst_id" id="inst_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%//=Html.selectOptionsX(weighing.getInst_List(), sc.inst_id, "All")%></select></td>
		<td width="100px" align="right">Truck No &nbsp;</td>
		<td width="120"><input name="truck_no" id="truck_no" type="text"  class="style2" style="width:100%; text-align:center; font-weight:bold" value="<%//=%>" ></td>	
		<td>&nbsp;<a href="JavaScript:doPost(1)" style="display:none">OK</a></td>
		<td align="right">&nbsp;</td>
	</tr>
</table>					  
<div style="border:thin; border-style:solid; border-width:1; width:" align="">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="style2">
	<tr bgcolor="#DDDDDD">
		<th width="30" rowspan="2">No</th>
		<th width="130" rowspan="2">WN Ref.</th>
		<th width="80" rowspan="2">Date </th>
		<th width="80" rowspan="2">Time</th>
		<th colspan="3">Gross (Kgs) </th>
      <th width="80" rowspan="2">Check<%//=scale.getRefNumber()%></th>
	<th width="" rowspan="2">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD">
	  <th width="80">Old</th>
	  <th width="80">New</th>
	<th width="80">Diff</th>
	</tr>
<%
	List<WnrEntity> wnrs = wn.getWnrs();
	double sum_old_weight = 0, sum_new_weight = 0, sum_diff_weight = 0;
    for (int i = 0; i < wnrs.size(); i++) {
		WnrEntity en = wnrs.get(i);
		WnrCheckEntity wnc = user.getDao().getWnrCheckDao().getById(en.getIdLong());
		sum_old_weight += wnc.isNull() ? 0 : en.gross_weight;
		sum_new_weight += wnc.gross_weight;
		double diff_weight = wnc.isNull() ? 0 : wnc.gross_weight - en.gross_weight;
		sum_diff_weight += diff_weight;
%>	
	<tr onClick="highlightOn(this);" bgcolor="#EEEEEE">
		<td align="right"><%=i+1%>&nbsp;</td>
		<td><%=en.getRefNumber()%></td>
		<td align="center"><%=DateTime.dateToStr(en.date)%></td>
		<td align="center"><%=DateTime.timeToStr(en.time)%></td>
		<td align="right"><%=Numeric.numberToStr(en.gross_weight,1)%>&nbsp;</td>
      	<td align="right"><%=Numeric.numberToStr(wnc.gross_weight,1,"")%>&nbsp;</td>
        <td align="right" style="color:#FF0000; font-weight:bold"><%=Numeric.numberToStr(diff_weight,1,"")%>&nbsp;</td>
        <td align="center"><%=Html.checkBox("check_"+i, !wnc.isNull(), "check(this, " + en.getIdLong() + ")")%></td>
	<td align="center">&nbsp;</td>
	</tr>
<%
	}
%>	
	<tr bgcolor="#CCCCCC" style="font-weight:bold">
		<td align="right">&nbsp;</td>
		<td align="center">Total</td>
		<td align="center">&nbsp;</td>
		<td align="center">&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(sum_old_weight,1)%>&nbsp;</td>
        <td align="right"><%=Numeric.numberToStr(sum_new_weight,1)%>&nbsp;</td>
        <td align="right" style="color:#FF0000; font-weight:bold"><%=Numeric.numberToStr(sum_diff_weight,1)%>&nbsp;</td>
        <td align="right">&nbsp;</td>
	<td align="right">&nbsp;</td>
	</tr>
</table>

</div>    
<table width="100%" class="style2">
	<tr>
		<td><input class="style2" type="button" name="Report" value="Report" onClick="genReport()"></td>
		<td style="font-weight:bold; color:#FF0000"><%=user.getMessage()%></td>
		<td align="right">&nbsp;</td>
		<td align="right" width="40px"><input class="style2" type="button" name="Close" value="Close" onClick="doClose()"></td>
	</tr>
</table>

	<input type="hidden" name="uid"  id="uid"  value="<%=user.getuid()%>">
	<input type="hidden" name="task_id"  id="task_id"  value="0">
	<input type="hidden" name="wn_id"  id="wn_id"  value="<%=sc.wn_id%>">
	<input type="hidden" name="wnr_id"  id="wnr_id"  value="0">

</form>

<script language="javascript">
	//setValue("browser",(isMac() || isOpera()) ? "1" : "0");
</script>

<%@include file="done.jsp"%>

</body>
</html>
<%
	//user.getResponse().viewReport();
%>

