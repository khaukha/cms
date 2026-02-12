<%@include file="authentication.jsp"%>
<%@ page import="ibu.ucms.biz.traffic.allocation.*" %>

<%	
	Request req = Request.get(request);
	int packing_id = req.getInt("packing_id");

	SplitWNR task = new SplitWNR(usr.getBiz().getTraffic().getAllocation());
	WnrEntity wnr = task.doTask();
	WnrEntity new_wnr = dao.getWnrDao().newEntity(wnr.getWeightNote());
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Split WNR</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<%@include file="packing.jsp"%>

<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/popcalendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../shared/js/Utils.js"></SCRIPT>

<script language="javascript">

function doSplit()
{
	//window.close();
	if (getValue("gross_weight") <= 0 || getValue("tare_weight") < 0 || getValue("net_weight") <= 0) {
		//window.close();
		alert("Invalid input data");
		return;
	}
	setValue("task_id",1);
	document.formMain.submit();
}

function doMerge(wnr_id, is_allocated)
{
	if (is_allocated) {
		alert("This item has been allocated.");
		return;
	}
	setValue("wnr_id_", wnr_id);
	setValue("task_id",2);
	document.formMain.submit();
}

function calNetWeight(type)
{
	type = (type == null) ? '' : '_' + type;
	var gross = getValue("gross_weight" + type);
	var tare  = getValue("tare_weight"  + type);
	var net = gross - tare;
	setValue("net_weight"  + type,formatNumber(net,1,false));
}

function calSplit(id,type)
{
	var s0 = getText(id + "_0");
	var s1 = getValue(id + "_1");
	var s2 = getValue(id);
	var s = (type == null) ? s0 - s2 : s0 - s1;
	
	
	var type1 =  (type == null) ? "_1" : "";
	if (s > 0)	{
		setValue(id + type1, formatNumber(s,1,false));
	} else {
		setValue(id, "");
	}

	if (type == null) calNetWeight(1);
	else calNetWeight();
}

function packingChanged()
{
	if (getValue("packing_id") == 0) {
		setValue("no_of_bags","");
		getObj("no_of_bags").readOnly = true;
	} else {
		getObj("no_of_bags").readOnly = false;
	}
}
</script>

<link href="style.css" rel="stylesheet" type="text/css">

<form action="" method="post" name="formMain" style="width:100%;">

<input type="hidden" name="uid"     id="uid"     value="<%=usr.getuid()%>">
<input type="hidden" name="wnr_id"  id="wnr_id"  value="<%=req.getLong("wnr_id")%>">
<input type="hidden" name="task_id"  id="task_id"  value="0">
<input type="hidden" name="wnr_id_"  id="wnr_id_"  value="0">  

<div style="border:thin; border-style:solid; border-width:1; width:770px" align="center">	
<label class="style2"><br><br><strong>SPLIT WNR FOR ALLOCATION </strong><br><br>&nbsp;</label>
<table  border="0" align="center" cellspacing="1" cellpadding="0" class="style2">
  <tr bgcolor="#DDDDDD">
    <td width="150" align="center">&nbsp;</td>
    <td width="150" align="center"><strong>WNR</strong></td>
    <td width="150" align="center"><strong>Packing</strong></td>
    <td width="60" align="center"><strong>Num</strong></td>
    <td width="60" align="center"><strong>Gross<br>Kgs</strong></td>
    <td width="60" align="center"><strong>Tare<br>Kgs</strong></td>
    <td width="60" align="center"><strong>Net<br>Kgs</strong></td>
    <td width="50" align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td align="center">WNR </td>
    <td align="center"><%=wnr.getRefNumber()%>&nbsp;</td>
    <td align="center"><%=wnr.getPacking().short_name%>&nbsp;</td>
    <td align="right"><label id="no_of_bags_0"><%=wnr.no_of_bags%></label> &nbsp;</td>
    <td align="right"><label id="gross_weight_0"><%=wnr.gross_weight%></label> &nbsp;</td>
    <td align="right"><label id="tare_weight_0"><%=wnr.tare_weight%></label> &nbsp;</td>
    <td align="right"><label id="net_weight_0"><%=wnr.net_weight%></label> &nbsp;</td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td align="center">WNR 1 </td>
    <td align="center"><%=wnr.getRefNumber()%></td>
    <td align="center"><%=wnr.getPacking().short_name%>&nbsp;</td>
    <td align="center"><input type="text" name="no_of_bags_1"   id="no_of_bags_1"   style="width:58px; text-align:right" class="style2" value="<%=wnr.no_of_bags%>" onChange="calSplit('quantity',1)" readonly></td>
    <td align="center"><input type="text" name="gross_weight_1" id="gross_weight_1" style="width:58px; text-align:right" class="style2" value="<%=wnr.gross_weight%>" onChange="calNetWeight(1); calSplit('gross_weight',1);" readonly></td>
    <td align="center"><input type="text" name="tare_weight_1"  id="tare_weight_1"  style="width:58px; text-align:right" class="style2" value="<%=wnr.tare_weight%>"  onChange="calNetWeight(1); calSplit('tare_weight', 1);" readonly></td>
    <td align="center"><input type="text" name="net_weight_1"   id="net_weight_1"   style="width:58px; text-align:right" class="style2" value="<%=wnr.net_weight%>" readonly></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
  <tr bgcolor="#EEEEEE">
    <td align="center">WNR 2 </td>
    <td align="center"><%=new_wnr.getRefNumber()%></td>
    <td align="center"><select name="packing_id" id="packing_id" style="width:150px" onChange="packingChanged();bagChanged(this);"><%=Html.selectOptions(dao.getPackingDao().selectAll(),packing_id,"")%></select></td>
    <td align="center"><input type="text" name="no_of_bags"   id="no_of_bags"   style="width:58px; text-align:right" onChange="calSplit('no_of_bags');quantityChanged(this);"></td>
    <td align="center"><input type="text" name="gross_weight" id="gross_weight" style="width:58px; text-align:right" onChange="calNetWeight();calSplit('gross_weight')"></td>
    <td align="center"><input type="text" name="tare_weight"  id="tare_weight"  style="width:58px; text-align:right" onChange="calNetWeight();calSplit('tare_weight')"></td>
    <td align="center"><input type="text" name="net_weight"   id="net_weight"   style="width:58px; text-align:right;" readonly></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
  <tr bgcolor="#DDDDDD">
    <td height="38" colspan="9" align="center"><a href="javascript:doSplit()" title="Save Change">Save</a> &nbsp;&nbsp;&nbsp;&nbsp; <a href="javascript:window.close()" title="Close Window">Close</a></td>
  </tr>
  <%
	List<WnrEntity> wnrs = wnr.getChildren();
	for (int i = 0; i < wnrs.size(); i++) {
		WnrEntity wr = wnrs.get(i);
  %>
  <tr bgcolor="#EEEEEE">
    <td align="center">Split WNR </td>
    <td align="center"><%=wr.getRefNumber()%></td>
    <td align="center"><%=wr.getPacking().short_name%>&nbsp;</td>
    <td align="center"><input type="text" name="no_of_bags_"   id="no_of_bags_" style="width:60px;text-align:right" value="<%=wr.no_of_bags%>" readonly></td>
    <td align="center"><input type="text" name="gross_weight_" id="gross_weight_" style="width:60px;text-align:right" value="<%=wr.gross_weight%>" readonly></td>
    <td align="center"><input type="text" name="tare_weight_"  id="tare_weight_"  style="width:60px;text-align:right" value="<%=wr.tare_weight%>" readonly></td>
    <td align="center"><input type="text" name="net_weight_"   id="net_weight_"   style="width:60px;text-align:right" value="<%=wr.net_weight%>" readonly></td>
    <td align="center"><a href="javascript:doMerge(<%=wr.getIdLong()%>,<%=wr.isAllocated()%>)" style="display:<%=wr.isAllocated()?"none":""%>">Delete</a></td>
    <td align="center">&nbsp;</td>
  </tr>
  <%
  	}
  %>
</table>
</div>	
</form>
<script language="javascript">
	getObj("no_of_bags").readOnly = getValue("packing_id") == 0;
	setFocus("no_of_bags"); 
</script>
<%@include file="done.jsp"%>

</body>
</html>
