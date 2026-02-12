
<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.warehouse.PalletWeight task = user.getBiz().getWareHouse().pallet_weight;
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="header.jsp"%>

<%
	task.doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">

getObj("main_window").width = "800";

function add(i)
{
	show("row_" + i);
}

function remove()
{
	var s = "Are you sure to delete this item ?";
	if (confirm(s) == 1) 
	{
		doTask(3);
	}	
}

function save(i)
{
	setValue("no", i);
	doTask(1);
}

function genReport()
{
	doTask(2);
}
</script>

<form method="POST" name="formMain" action="" onSubmit="">				
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  				<tr>
    				<td><img src="images/pallet.jpg"></td>
  				</tr>
</table>
		
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:">
  <tr>
    <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
      <tr bgcolor="#DDDDDD">
        <th width="35"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
        <th width="120">Pallet Ref</th>
        <th width="70">Date</th>
        <th width="60">Time</th>
        <th width="80">Weight<br />(Kgs)</th>
		<th width="40">&nbsp;</th>
		<th>&nbsp;</th>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><div style="overflow:scroll; width:100%; height:350px; border-style:solid; border-width:1; ">
      <table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
<%
	List<PalletEntity> pals = task.getDetails();
	for (int i = 0; i < pals.size(); i++) {
		 PalletEntity pal = pals.get(i);
%>	  
		<input type="hidden" name="pallet_id_<%=i%>" id="pallet_id_<%=i%>" value="<%=pal.getIdLong()%>">
        <tr id="row_<%=i%>" style="display:<%=pal.isNew()?"none":""%>" onClick="highlightOn(this)">
          <th width="35" bgcolor="#EEEEEE" align="right"><%=i+1%></th>
          <td width="120"><input type="text" name="short_name_<%=i%>" id="short_name_<%=i%>" class="style2" style="width:100%; text-align:center" value="<%=pal.short_name%>" readonly></td>
          <td width="70" align="center"><%=DateTime.dateToStr(pal.date)%></td>
		  <td width="60" align="center"><%=DateTime.timeToStr(pal.time)%></td>
		  <td width="80"><input type="text" name="value_<%=i%>" id="value_<%=i%>" class="style2" style="width:100%; text-align:right" value="<%=pal.value%>"></td>
		  <td width="40" align="center"><a href="javascript:save(<%=i%>)" class="style2">Save</a></td>
		  <td>&nbsp;</td>
        </tr>
<%
	}
%>		
      </table>
    </div></td>
  </tr>
  <tr>
    <td><table width="100%" cellpadding="0" cellspacing="0" border="0" class="style2">
		<tr>
			<td align="right"><a href="javascript:add(<%=pals.size()-1%>)" class="style2">New</a></td>
			<td align="right" width="60"><a href="javascript:genReport()" class="style2">Report</a> &nbsp;</td>
		</tr>
	</table></td>
  </tr>
</table>
	
	<input type="hidden" name="uid"     id="uid"      value="<%=user.getuid()%>">		
    <input type="hidden" name="task_id" id ="task_id" value="0">
    <input type="hidden" name="no"      id ="no"      value="-1">
</form>  

<%@include file="../footer.jsp"%>

