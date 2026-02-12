
<script language="javascript" type="text/javascript">
getObj("main_window").width = "1000";

function newFixation()
{
	//show("fixation_div");	
	if (getValue("contract_id") <= 0) {
		alert("Please select a contract.");
		return;
	}
	if (<%=!fixation.getContract().getFixationLetter().isNull()%>) {
		alert("The purchase already had final fixation");
		return;
	}
	if (addNewListItemById("fixation_id","New Item") >= 0) {
		doTask(1);
	}
	
}

function saveFixation()
{
	if (getValue("fixation_id") <= 0) {
		alert("Please select a fixation letter.");
		return;
	}
	doTask(1);
}

function deleteFixation()
{
	removeItem("fixation_id", 2);
}

function printFixation()
{
	if (getValue("fixation_id") <= 0) {
		alert("Please select a fixation letter.");
		return;
	}
	doTask(3);
}
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td width="240" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
			<tr bgcolor="#DDDDDD">
				<th width="120">Contract Ref.</th>
				<th width="">Fixation Ref.</th>
			</tr>
			<tr>
				<td><select name="contract_id" id="contract_id" size="25" class="style11" style="width:100%;" onChange="setValue('fixation_id',0);doPost()"><%=Html.selectOptionsX(cts,sc.contract_id,"All")%></select></td>
				<td><select name="fixation_id" id="fixation_id" size="25" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(task.selectFixationLetter(),sc.fixation_id,"All")%></select></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><img src="../shared/images/new.gif" title="Create New Fixation" onClick="newFixation()" style="display:<%=displayed%>">
				    <img src="../shared/images/delete.gif" title="Delete The Selected Fixation" onClick="deleteFixation()" style="display:<%=displayed%>">&nbsp;</td>
			</tr>
		</table></td>
		<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
			<tr>
				<td><%@include file="finance.fixation.filter.jsp"%></td>
			</tr>
			<tr>
				<td><%@include file="finance.fixation.detail.jsp"%></td>
			</tr>
		</table></td>
	</tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td>&nbsp;</td>
		<td align="right">&nbsp;</td>
		<td width="60" align="right"><img src="../shared/images/listview.jpg"  onClick="setValue('view',0);doPost();"></td>
	</tr>
</table>

<script language="javascript" type="text/javascript">

	if (<%=fixation.getIdLong()%> == -1) {
    var idx = addNewListItem(document.formMain.fixation_id,"<%=fixation.getRefNumber()%>");
	}

</script>