<%
	long timeout = 10*60;
	task.setTimeout(timeout);
	ScaleEntity scale = task.getScale();	
	TruckWeightEntity truck_weight = task.getTruckWeight();
	sc.inst_id = truck_weight.inst_id;
	task.doTask(truck_weight, scale);
%>
<script language="javascript">

getObj("main_window").width = "";
var readonly = <%=task.isReadOnly()%>;

function wnTypeChange()
{
	setValue("truck_weight_id", 0);
	doPost();
}

function checkUpdate()
{
	if (<%=truck_weight.isCompleted()%>) {
		alert("This item is locked and cannot be updated.");
		return false;
	}
	return true;
}

function newTruck()
{
	if (addNewListItemById("truck_weight_id","New Truck No.") >= 0) {
		doPost();
	}
}

function saveTruck()
{
	if (getValue("truck_weight_id") == 0) {
		alert("Please select a Truck No.");
		return;
	}
	//if (!checkUpdate()) {
		//return;
	//}
	doTask(1);
}

function deleteTruck()
{
	if (<%=truck_weight.getIdLong() == 0%>) {
		alert("Please select a Truck No.");
		return;
	}
	if (!checkUpdate()) {
		return;
	}
	if (confirm("Are you sure to delete Truck No " + getSelectedText("truck_weight_id"))) {
		doTask(2);
	}
}

function updateWeight(cbx, no)
{
	setValue("no", no);
	doTask(cbx.checked ? 3 : 4);
}

function selectWN(cbx, wn_id, wn_type)
{
	setValue("wn_id", wn_id);
	setValue("wn_type", wn_type);
	doTask(cbx.checked ? 6 : 7);
}
</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="140px" valign="top">
			<div style="background-color:#DDDDDD; width:100%;" align="center"><strong>Truck No</strong></div>
			<select name="truck_weight_id" id="truck_weight_id" size=20 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptionsX(task.getTruckWeightList(),truck_weight.getIdLong(),"All")%></select>
			<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" style="display:<%=displayed%>">
				<tr>
					<td width="15"><img id="new_btn" src="images/new.gif" onClick="newTruck()"></td>
					<td width="15"><img id="del_btn" src="images/delete.gif" onClick="deleteTruck()"></td>
					<td align="right"><img id="sav_btn" src="images/update.gif" onClick="saveTruck()"></td>
				</tr>
			</table>
		</td>
		<td valign="top">
			<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
				<tr bgcolor="#DDDDDD">
				  <th width="100">Type</th>
					<th width="100">Status</th>
					<th width="100">Date</th>
					<td align="right"><%@include file="search.jsp"%></td>
				</tr>
				<tr>
				  <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(true),sc.wn_type)%></select></td>
				  <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
				  <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getTruckWeightDao().selectDateFilter(), sc.filter_date, "All")%></select></td>
				  <td align="center" valign="middle">
				  	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
						<tr>
						  <th><%=DateTime.timeToString(scale.time)%></th>
					  </tr>
						<tr>
							<th><input type="text" name="weight_value" id="weight_value" style="width:150; text-align:center; background-color:#000000; color:#FF0000; font-size:24px; font-weight:bold; height:36" value="<%=Numeric.numberToStr(scale.value,0)%>" readonly /></th>
						</tr>
						<tr>
						  <th><a href="JavaScript:doTask(10)" style="display:<%=displayed%>">Get Value</a></th>
					  </tr>
					</table></td>
			  </tr>
			</table>
<div style=" border:solid; border-width:1;width:100%;">			
			<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
				<tr bgcolor="#DDDDDD">
				  <th width="40" rowspan="2">Id</th>
				  <th width="130" rowspan="2">Truck No </th>
				  <th colspan="3">In</th>
				  <th colspan="3">Out</th>
				  <th colspan="3">Gross (Kgs) </th>
				  <th colspan="2">Weighing</th>
				  <th width="100"><%=DateTime.timeToString(DateTime.getCurTime())%></th>
				</tr>
				<tr bgcolor="#DDDDDD">
				  <th width="80">Date</th>
				  <th width="50">Time</th>
			      <th width="70">Kgs</th>
			      <th width="80">Date</th>
			      <th width="50">Time</th>
			      <th width="70">Kgs</th>
			      <th width="70">Brigde</th>
			      <th width="70">E.Scale</th>
			      <th width="70">Diff.</th>
			      <th width="36">In</th>
			      <th width="36">Out</th>
			      <th><%=truck_weight.inst_id%></th>
			  </tr>
<%
	boolean in_locked  = scale.value == 0 || truck_weight.isWeightInLocked(timeout);
	boolean out_locked = scale.value == 0 || truck_weight.isWeightOutLocked(timeout);
%>			  
				<tr>
				  <td align="right" bgcolor="#DDDDDD"><strong><%=truck_weight.getIdLong()%></strong>&nbsp;</td>
				  <td><input name="ref_number" id="ref_number" type="text"  class="style2" style="width:100%;" value="<%=truck_weight.getRefNumber()%>" onblur="toUpper(this);"></td>
				  <td><input type="text" name="date" id="date" class="style2" style="width:100%; text-align:center" value="<%=DateTime.dateToStr(truck_weight.date)%>" readonly /></td>
				  <td><input type="text" name="time_in" id="time_in" class="style2" style="width:100%; text-align:center" value="<%=DateTime.timeToStr(truck_weight.time_in)%>" readonly /></td>
		  		  <td><input type="text" name="weight_in" id="weight_in" class="style2" style="width:100%; text-align:center" value="<%=Numeric.numberToStr(truck_weight.weight_in,0)%>" readonly /></td>
		  		  <td><input type="text" name="date_out" id="date_out" class="style2" style="width:100%; text-align:center" value="<%=DateTime.dateToStr(truck_weight.date_out)%>" readonly /></td>
		  		  <td><input type="text" name="time_out" id="time_out" class="style2" style="width:100%; text-align:center" value="<%=DateTime.timeToStr(truck_weight.time_out)%>" readonly /></td>
		  		  <td><input type="text" name="weight_out" id="weight_out" class="style2" style="width:100%; text-align:center" value="<%=Numeric.numberToStr(truck_weight.weight_out,0)%>" readonly /></td>
		  		  <th><%=Numeric.numberToStr(truck_weight.gross_weight,1)%>&nbsp;</th>
		  		  <th><%=Numeric.numberToStr(truck_weight.e_gross_weight,1)%>&nbsp;</th>
				  <th><%=Numeric.numberToStr(truck_weight.diff_weight,1)%>&nbsp;</th>
				  <td align="center"><%=Html.checkBox("in", truck_weight.time_in != null, "updateWeight(this,1)", in_locked?"disabled":"")%></td>
		  		  <td align="center"><%=Html.checkBox("out", truck_weight.time_out != null, "updateWeight(this,2)", out_locked?"disabled":"")%></td>
				  <td><%=truck_weight.getUser().user_name%></td>
			  </tr>
				<tr bgcolor="#DDDDDD">
				  <td align="right">&nbsp;</td>
				  <td align="right">Remark &nbsp;</td>
				  <td colspan="11"><input name="remark" id="remark" type="text"  class="style2" style="width:100%;" value="<%=truck_weight.remark%>"></td>
				  <td>&nbsp;<a href="JavaScript:saveTruck()" style="display:<%=displayed%>">Save</a>&nbsp;</td>
			  </tr>
			</table>
</div>			
<div style=" border:solid; border-width:1;width:100%;">			
	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
		<tr bgcolor="#DDDDDD">
			<th width="40">Id</th>
			<th width="30">&nbsp;</th>
			<th width="130" align="left">&nbsp;WN Ref</th>
			<th width="60">Date</th>
			<th width="70" align="left">&nbsp;Truck No</th>
			<th width="80" align="left">&nbsp;Packing</th>
			<th width="60" align="right">No.Bags&nbsp;</th>
			<th width="70" align="right">Net&nbsp;</th>
			<th width="50" align="right">Tare&nbsp;</th>
			<th width="70" align="right">Gross&nbsp;</th>
			<th width="120" align="left">&nbsp;Contract Ref.</th>
			<th>&nbsp;</th>
		</tr>
<%
	List<WnEntity> wns = truck_weight.getWeightNotes();
	//dao.getWnImXpDao().getByTruckNo();
	wns.addAll(task.getFreeWns(truck_weight, 5));
	double sum_gross = 0, sum_tare = 0, sum_net = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnEntity wn = wns.get(i);
		double tare_weight = wn.getEGrossWeight() - wn.net_weight;
		boolean checked = wn.truck_weight_id == truck_weight.getIdLong();
		sum_gross += wn.getEGrossWeight();
		sum_tare += tare_weight;
		sum_net += wn.net_weight;
		String action = String.format("selectWN(this,%d,'%c')", wn.getIdLong(), wn.type);
%>		
		<tr>
			<th align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
			<th><%=Html.checkBox("wn_"+i, checked, action, "")%></th>
			<td style="color:<%=Action.getColor(wn.status)%>">&nbsp;<%=wn.getRefNumber()%></td>
			<td><%=DateTime.dateToStr(wn.date)%></td>
			<td>&nbsp;<%=wn.truck_no%></td>
			<td>&nbsp;<%=wn.getPacking().short_name%></td>
			<td align="right"><%=Numeric.numberToStr(wn.no_of_bags,0)%>&nbsp;</td>
			<td align="right"><%=Numeric.numberToStr(wn.net_weight,1)%>&nbsp;</td>
			<td align="right"><%=Numeric.numberToStr(tare_weight,1)%>&nbsp;</td>
			<td align="right"><%=Numeric.numberToStr(wn.getEGrossWeight(),1)%>&nbsp;</td>
			<td>&nbsp;<%=wn.getInstruction().getRefNumber()%></td>
			<td>&nbsp;<%=wn.getGrade().short_name%></td>
		</tr>
<%
	}
%>
		<tr bgcolor="#DDDDDD">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<th align="right"><%=Numeric.numberToStr(sum_net,1)%>&nbsp;</th>
			<th align="right"><%=Numeric.numberToStr(sum_tare,1)%>&nbsp;</th>
			<th align="right"><%=Numeric.numberToStr(sum_gross,1)%>&nbsp;</th>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
</div>

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
	<input type="hidden" name="wn_id" id="wn_id" value="0">	
	  

<script language="javascript">
	if (<%=truck_weight.isNew()%>) {	
		var idx = addNewListItem(document.formMain.truck_weight_id, "New Truck No.");
	}

	if (completed || readonly) {
		//setCompletedElements("inst_id","contract_id");
	}
	
</script>
