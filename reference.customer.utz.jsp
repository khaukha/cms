<script language="javascript" type="text/javascript">
function newUtz()
{
	show("new_utz_");
	
}

function showPurchase(utz_id)
{
	var url = "reference.utz.purchase.jsp?uid=<%=user.getuid()%>&utz_id=" + utz_id;
	var vReturnValue = window.showModalDialog(url,window,"status:false;dialogWidth:1000px;dialogHeight:480px;center:yes");	
}
</script>

<div style="width:100%; border-width:1; border-style:solid; overflow:; height:;">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr bgcolor="#DDDDDD">
	  <th width="40" rowspan="2">Id</th>
		<th width="60" rowspan="2">Crop</th>
		<th colspan="4">Mts</th>
		<th colspan="2" rowspan="2"><a href="JavaScript:newUtz()" style="display:<%=displayed%>">New</a></th>
		<th rowspan="2">&nbsp;</th>
	</tr>
		<tr bgcolor="#DDDDDD">
		<th width="80">Registered</th>
		<th width="80">UTZ</th>
		<th width="80">4C</th>
		<th width="80">Balance</th>
	</tr>
<%
	List<UtzProjectEntity> utzs = cust.getUtzProjects();
	UtzProjectEntity nu = dao.getUtzProjectDao().newEntity();
	utzs.add(0,nu);
	for (int i = 0; i < utzs.size(); i++) {
		UtzProjectEntity utz = utzs.get(i);
		List<PurchaseContractEntity> cts = utz.getContracts();
		String txt = "";		
%>								
	<input type="hidden" name="utz_id_<%=i%>"  id="utz_id_<%=i%>"  value="<%=utz.getIdLong()%>">
	<tr id="<%=utz.isNull()?"new_utz_":""%>" style="display:<%=utz.isNull()?"none":""%>">
	  <th align="right" bgcolor="#DDDDDD"><%=utz.getIdLong()%>&nbsp;</th>
		<td><select name="crop_<%=i%>" id="crop_<%=i%>" size=1 class="style2" style="width:100%;"><%=Html.selectOptions(Html.years,utz.crop,"")%></select></td>
		<td><input name="registered_tons_<%=i%>" id="registered_tons_<%=i%>" type="text" class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(utz.registered_tons)%>"></td>
		<td align="right"><strong><%=Numeric.numberToStr(utz.delivered_utz_tons)%></strong>&nbsp;</td>
		<td align="right"><strong><%=Numeric.numberToStr(utz.delivered_4c_tons)%></strong>&nbsp;</td>
		<td align="right"><strong><%=Numeric.numberToStr(utz.open_tons)%></strong>&nbsp;</td>
		<td width="50" align="center"><a href="JavaScript:saveUtz(<%=i%>)" style="display:<%=displayed%>">Save</a>&nbsp;</td>
		<td width="50" align="center"><a href="JavaScript:deleteUtz(<%=i%>)" style="display:<%=displayed%>">Del.</a>&nbsp;</td>
		<td><a href="JavaScript:showPurchase(<%=utz.getIdLong()%>)" title="<%=txt%>" style="display:none">Show Purchase</a></td>
	</tr>
<%
	}
%>								
</table>
</div>