<%
	WnConsolidationEntity wnc = task.getWnConsolidation();
	task.doTask(wnc);
	String mcolor = wnc.stock_weight < 0 ? "#FF0000" : Action.getColor(wnc.status);
%>
<script language="javascript">

getObj("main_window").width = "";

function checkUpdate()
{
	if (<%=wnc.isLocked()%>) {
		//alert("This item is locked and cannot be updated.");
		//return false;
	}
	return true;
}

function newWN()
{
	if (getValue("filter_warehouse_id") == 0) {
		alert("Please select a Warehouse first.");
		return;
	}
	if (addNewListItemById("wnc_id","New Item") >= 0) {
		setValue("filter_grade_id", 0);
		doPost();
	}
}

function savWN()
{
	if (getValue("wnc_id") == 0) {
		alert("Please select a WN.");
		return;
	}
	if (!checkUpdate()) {
		return;
	}
	if (getValue("area_id") == 0) {
		alert("Please select Area for this WN.");
		return;
	}		
	if (getValue("grade_id") == 0) {
		alert("Please select Grade for this WN.");
		return;
	}	
	 
	doTask(1);
}

function delWN()
{
	var wnc_id = getValue("wnc_id");
	if (wnc_id == 0) {
		alert("Please select a WN");
		return;
	}
	if (!checkUpdate()) {
		return;
	}
	if (wnc_id < 0) {
		doPost();
	}
	if (confirm("Are you sure to delete " + getSelectedText("wnc_id"))) {
		doTask(4);
	}
}

function printWN()
{
	var wnc_id = getValue("wnc_id");
	if (wnc_id == 0) {
		alert("Please select a WN");
		return;
	}
	if (wnc_id < 0) {
		alert("Please save this WN before printing.");
		return;
	}
	doTask(5);
}

</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="140px" valign="top">
			<div style="background-color:#DDDDDD; width:100%;" align="center"><strong>WN Ref</strong></div>
			<select name="wnc_id" size=20 class="style11" id="wnc_id" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(dao.getWnConsolidationDao().getList(), wnc.getIdLong(), "All")%></select>
		    <img id="new_btn" src="images/new.gif" border="0" width="15" height="15" onClick="newWN()">
			<img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="delWN()">
		</td>
		<td valign="top">
			<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
				<tr bgcolor="#DDDDDD">
				  <td width="60" align="right">Status&nbsp;</td>
				  <td width="80" align="right"><select name="filter_status" id="filter_status" class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
					<td width="80" align="right">Warehouse&nbsp;</td>
					<td width="100"><select name="filter_warehouse_id" id="filter_warehouse_id" class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_warehouse_id,"All")%></select></td>
					<td align="right"><%@include file="search.jsp"%></td>
				</tr>
			</table>
			<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
				<tr bgcolor="#DDDDDD">
				  <th width="42" rowspan="2">Id&nbsp;</th>
				  <th width="130" rowspan="2">Ref Number</th>
				  <th width="54" rowspan="2">Area</th>
				  <th width="200" rowspan="2">Grade</th>
				  <th width="100" rowspan="2">Packing</th>
				  <th colspan="2">In</th>
				  <th colspan="2">Out</th>
				  <th colspan="2">Balance</th>
				  <th width="114" rowspan="2" align="left">&nbsp;Complete</th>
				  <td width="40" rowspan="2">&nbsp;</td>
				  <td width="40" rowspan="2">&nbsp;</td>
				  <td width="" rowspan="2">&nbsp;</td>
				</tr>
				<tr bgcolor="#DDDDDD">
				  <th width="40">Bags</th>
			      <th width="60">Mts</th>
			      <th width="40">Bags</th>
			      <th width="60">Mts</th>
			      <th width="40">Bags</th>
			      <th width="60">Mts</th>
			  </tr>
				<tr>
				  <td bgcolor="#DDDDDD" align="right"><strong><%=wnc.getIdLong()%></strong>&nbsp;</td>
				  <td style="color:<%=mcolor%>"><%=wnc.getRefNumber()%></td>
				  <td><select name="area_id" class="style11" id="area_id" size="1" style="width:100%;"><%=Html.selectOptions(dao.getAreaDao().getByWarehouseId(sc.filter_warehouse_id),wnc.area_id,"All")%></select></td>
				  <td align="center"><select name="grade_id" class="style11" id="grade_id" style="width:100%;"><%=Html.selectOptions(task.getGradeFilter(wnc),wnc.grade_id,"All")%></select></td>
				  <td align="center"><%=wnc.getPacking().short_name%></td>
		  		  <td align="right"><%=Numeric.numberToStr(wnc.no_of_bags,0)%>&nbsp;</td>
		  		  <td align="right"><%=Numeric.numberToStr(wnc.net_weight/1000)%>&nbsp;</td>
		  		  <td align="right"><%=Numeric.numberToStr(wnc.allocated_bags,0)%>&nbsp;</td>
		  		  <td align="right"><%=Numeric.numberToStr(wnc.allocated_weight/1000)%>&nbsp;</td>
		  		  <td align="right"><%=Numeric.numberToStr(wnc.stock_bags,0)%>&nbsp;</td>
		  		  <td align="right" style="color:<%=mcolor%>"><%=Numeric.numberToStr(wnc.stock_weight/1000)%>&nbsp;</td>
				  <td><%=Html.completionCheckBox(wnc,"style11", wnc.isLocked() || wnc.stock_weight < -200?"disabled":"")%></td>
		  		  <td align="center"><a href="javascript:savWN()" style="display:<%=displayed%>">Save</a></td>
		  		  <td align="center"><a href="javascript:printWN()">Print</a></td>
				  <td>&nbsp;</td>
			  </tr>
			</table>
			<%@include file="warehouse.consolidation.unconsolidated.jsp"%>
			<%@include file="warehouse.consolidation.consolidated.jsp"%>		
		</td>
	</tr>
</table>

<table width="100%"  border="0" cellspacing="1" cellpadding="1">
            <tr>
			  <td>&nbsp;</td>
              <td align="right" width="60">&nbsp;</td>
			  <td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" border="0" onClick="setValue('view',0);doPost();"></td>
            </tr>
</table>
		  
	<input type="hidden" name="no" id="no" value="0">	
	  

<script language="javascript">
	if (<%=wnc.getIdLong()%> == -1) {	
		var idx = addNewListItem(document.formMain.wnc_id,"<%=wnc.getRefNumber()%>");
	}

	
</script>
