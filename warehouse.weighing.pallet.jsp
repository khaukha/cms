<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="ibu.ucms.*, pc.sql.data.*, pc.util.*, ngv.share.util.*, ibu.ucms.entity.*" %>

<%
    User user = CMS.getUser(pageContext);
	
	if (user == null || !user.isAuthenticated()) {
		//response.sendRedirect("logon.jsp");	
		return;
	}

	ibu.ucms.biz.warehouse.weighing.Pallet task = user.getBiz().getWareHouse().weighing.getPallet();
	SearchCriteriaEntity sc = user.getSearchCriteria();
	sc.set();
	task.doTask();
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Check Pallet Weight</title>

<link href="style.css" rel="stylesheet" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/Utils.js"></SCRIPT>

<script language="javascript" src="warehouse.weighing.js"></script>

<SCRIPT LANGUAGE="JavaScript">

function doPost(task_id)
{
	if (task_id == null) task_id = 0;
	setValue("task_id", task_id);
	document.formMain.submit();
}

function doClose()
{	
	//window.returnValue = ;
	window.close();
}

</SCRIPT>

</head>

<body leftmargin="16px">
<form id="formMain" name="formMain" method="post" action="warehouse.weighing.pallet.jsp" style="width:100%" target="_self">
<br>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="style2">
	<tr>
		<td width="60px" align="right">Scale No &nbsp;</td>
		<td width="80px"><select name="scale_id" id="scale_id" class="style2" style="width:80px;" onChange="setFocus('pallet_id');"><%=Html.selectOptions(user.getDao().getScaleDao().selectAll(),sc.scale_id)%></select></td>
		<td width="80px" align="right">Pallet ID &nbsp;</td>
		<td><input name="pallet_id" id="pallet_id" type="text"  autocomplete="off" class="style2" style="width:150px; text-align:center; font-weight:bold" onKeyUp="checkPallet(this)"></td>	
	</tr>
</table>					  
<div style="border:thin; border-style:solid; border-width:1; width:100%;" align="center">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="style2">
	<tr bgcolor="#DDDDDD">
		<th width="60px">No</th>
		<th>Pallet Ref.</th>
		<th width="80px">Date </th>
		<th width="80px">Weight</th>
      </tr>
<%
	List<PalletEntity> pallets = task.getCheckedPallets();
	double total_weight = 0;
	double gross_weight = user.getDao().getScaleDao().getGrossWeight();
    for (int i = 0; i < pallets.size(); i++) {
		PalletEntity en = pallets.get(i);
		total_weight += en.value;
%>	
	<tr onClick="highlightOn(this);" bgcolor="#EEEEEE">
		<td align="right"><%=i+1%>&nbsp;</td>
		<td><%=en.short_name%></td>
		<td align="center"><%=en.date%></td>
		<td align="right"><%=en.value%> &nbsp;</td>
      </tr>
<%
	}
%>	
	<tr bgcolor="#CCCCCC" style="font-weight:bold">
		<td>&nbsp;</td>
		<td align="center">Total <%=pallets.size()%> Pallet(s)</td>
		<td align="center">&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(total_weight,1)%> &nbsp;</td>
      </tr>
	<tr bgcolor="#DDDDDD" style="font-weight:bold">
		<td>&nbsp;</td>
		<td align="center">Current</td>
		<td align="center">&nbsp;</td>
		<td align="right" style="color:#0000FF"><%=Numeric.numberToStr(gross_weight,1)%> &nbsp;</td>
      </tr>
	<tr bgcolor="#CCCCCC" style="font-weight:bold">
	  <td>&nbsp;</td>
	  <td align="center">Different</td>
	  <td align="center">&nbsp;</td>
	  <td align="right" style="color:#FF0000"><%=Numeric.numberToStr(total_weight - gross_weight,1)%> &nbsp;</td>
	  </tr>
</table>

<script language="javascript">
	setFocus("pallet_id");
</script>
</div>    
<table width="100%" class="style2">
	<tr>
		<td style="font-weight:bold; color:#FF0000"><%=user.getMessage()%></td>
		<td align="right"><input class="style2" type="button" name="Clear" value="Clear" onClick="doPost(1)"></td>
		<td align="right" width="40px"><input class="style2" type="button" name="Close" value="Close" onClick="doClose()"></td>
	</tr>
</table>

	<input type="hidden" name="uid"  id="uid"  value="<%=user.getuid()%>">
	<input type="hidden" name="task_id"  id="task_id"  value="0">

</form>
</body>
</html>
