<%
	TruckingEntity trucking = task.getTrucking();
	if (trucking.isNew()) {
		trucking.trucking_vat_percent = 10;
	}
	task.doTask(trucking);
	boolean completed = trucking.isCompleted();
	String dis = "";			
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

var readonly = <%=task.isReadOnly()%>;

function saveTrucking(task_id)
{
	if (readonly) {
		alert("You do not have permisstion to update data.");
		return;
	}

	if (getValue("filter_status") == 2) {
		if (Math.abs(<%=trucking.getDiffWeight()%>) > 1000) {
			alert("The differential weight is too big.");
			//alert("Can not complete this Trucking because the differential weight is too big.");
			//return;
		}
	}
	
	if (getValue("trucking_id") == 0) {
		alert("Please select Trucking Ref.");
		return;
	}
	//if (getValue("truck_id") == 0) {
		//alert("Please remember to fill in Truck No.");
		//return;
	//}
	if (getValue("source_id") == 0) {
		alert("Please select source warehouse");
		return;
	}
	if (getValue("destination_id") == 0) {
		alert("Please select destination warehouse");
		return;
	}
	doTask(task_id);
}

function newTrucking()
{
	if (getValue("type") == " ") {
		//alert("Please select a Type");
		//return;
	}
	if (addNewListItemById("trucking_id","New Item") >= 0) {
		doPost();
	}
}

function deleteTrucking()
{
	if (readonly) {
		alert("You do not have permisstion to modify data.");
		return;
	}
	if (getValue("trucking_id") <= 0) {
		return;
	}
	if (confirm("Are you sure to delete " + getSelectedText("trucking_id"))) {
		doTask(3);
	}
}

function doListView()
{
	setValue("truck_id", 0);
	setValue("filter_grade_id", 0);
	setValue("filter_status", 0);
	setView(0);
	doPost();
}

function allocate()
{
	show("wnc_alloc");
}

function printTrucking()
{
	if (getValue("trucking_id") == 0) {
		alert("Please select Trucking Ref.");
		return;
	}
	doTask(5);
}
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr>
		<td width="100"><img src="images/trucking.jpg"></td>
		<td width="90"><select name="filter_status" id="filter_status" class="style11" style="width:90" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(), sc.filter_status, "Status (All)")%></select></td>
		<td width="150"><select name="filter_source_id" id="filter_source_id" class="style11" style="width:150" onChange="doPost()"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_source_id,"From (All)")%></select></td>
		<td width="150"><select name="filter_destination_id" id="filter_destination_id" class="style11" style="width:150" onChange="doPost()"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_destination_id,"To (All)")%></select></td>
		<td>&nbsp;</td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>


<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="130" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr bgcolor="#DDDDDD">
			    <th width="130">Trucking Ref.</th>
			</tr>
			<tr bgcolor="#DDDDDD">
			    <th><select name="trucking_id" id="trucking_id" size=18 class="style11" style="width:130" onChange="itemSelected(this);"><%=Html.selectOptionsX(dao.getTruckingDao().getList(trucking),trucking.getIdLong(),"All")%></select></th>
			</tr>
	        <tr style=" padding-top:1px; display:<%=displayed%>">
	          <td>
			  	<img id="new_btn" src="images/new.gif" border="0" onClick="newTrucking()">
		  		<img id="del_btn" src="images/delete.gif" border="0" onClick="deleteTrucking()"></td>
          	</tr>

		</table></td>
		<td valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr bgcolor="#DDDDDD">
				<th><%=trucking.getRefNumber()%> (<%=trucking.getIdLong()%>)</th>
		    </tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; width:100%; overflow:hidden; padding-top:8px; padding-right:1px; padding-left:1px">
					<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style2">
						<tr>
							<td align="right" width="100">Trucking Ref. &nbsp;</td>
							<td width="120"><input name="ref_number" type="text" id="ref_number" class="style2" style="width:120; font-weight:bold" value="<%=trucking.getRefNumber()%>" onblur="toUpper(this);" readonly></td>
							<td width="100" align="right">Packing &nbsp;</td>
						    <td width=""><select name="packing_id" id="packing_id" class="style2" style="width:120;" onChange="">
                				<%=Html.selectOptions(dao.getPackingDao().selectAll(), trucking.packing_id, "")%>
              				</select></td>
						</tr>
						<tr>
						  <td align="right">Date &nbsp;</td>
						  <td><%=Html.datePicker("date",trucking.date)%></td>
						  <td align="right">Truck No. &nbsp;</td>
					      <td><input name="truck_no" type="text" id="truck_no" style="width:120; font-weight:bold" value="<%=trucking.truck_no%>" onKeyUp="toUpper(this);" ></td>
					  </tr>
						<tr>
						  <td align="right">Quality &nbsp;</td>
						  <td><select name="quality_id" id="quality_id" class="style2" style="width:100%;" onChange="qualityChanged(this);"><%=Html.selectOptions(dao.getQualityDao().selectAll(),trucking.getGrade().quality_id,"")%></select></td>
						  <td align="right">Grade &nbsp;</td>
						  <td><select name="grade_id" id="grade_id" class="style2" style="width:250;" onChange="gradeChanged(this);"><%=Html.selectOptions(dao.getGradeDao().selectAll(),trucking.grade_id,"")%></select></td>
					  </tr>
						<tr>
						  <td align="right">Driver &nbsp;</td>
						  <td><input name="driver" type="text" id="driver" style="width:100%;" value="<%=trucking.driver%>"></td>
						  <td align="right">Forwarder &nbsp;</td>
						  <td><select name="forwarder_id" id="forwarder_id" class="style2" style="width:250;"><%=Html.selectOptions(dao.getCompanyDao().getServices(),trucking.forwarder_id,"")%></select></td>
					  </tr>
						<tr>
						  <td align="right">From <%=mandatory%> &nbsp;</td>
					      <td><select name="source_id" id="source_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(trucking.location_id), trucking.source_id)%></select></td>
						  <td align="right">To <%=mandatory%> &nbsp;</td>
					      <td><select name="destination_id" id="destination_id" class="style2" style="width:250;"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(), trucking.destination_id, "")%></select></td>
					  </tr>
						<tr>
						  <td align="right">Trucking Price &nbsp;</td>
						  <td><input name="trucking_price_local" type="text" id="trucking_price_local" class="style11" style="width:80; text-align:right" value="<%=Numeric.numberToStr(trucking.trucking_price_local,_dec)%>" <%=is_center?"":""%>> <%=location.currency%>/Mt</td>
						  <td align="right">Attention &nbsp;</td>
						  <td><input name="attention" type="text" id="attention" style="width:250;" value="<%=trucking.attention%>"></td>
					  </tr>
						<tr>
						  <td align="right">VAT &nbsp;</td>
						  <td><input name="trucking_vat_percent"  type="text" id="trucking_vat_percent" class="style11" style="width:80; text-align:right;" value="<%=Numeric.numberToStr(trucking.trucking_vat_percent,0)%>" <%=is_center?"":""%>> %</td>
						  <td align="right">Amount &nbsp;</td>
						  <td><strong><%=Numeric.numberToStr(trucking.trucking_total_amount_local,_dec)%></strong> <%=location.currency%></td>
					  </tr>
					</table>
				</div></td>
			</tr>
			<tr>
				<td><div style="border:thin; border-style:solid; border-top:0; border-width:1; width:100%; overflow:hidden; padding-right:1px; padding-left:1px">
					<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
						  	<tr bgcolor="#DDDDDD">
						  	  <th colspan="2">Loading (Kgs)</th>
						  	  <th colspan="2">Delivered (Kgs)</th>
					  	      <th colspan="2">Diff.</th>
						  	  <th width="" rowspan="2">&nbsp;</th>
						  	</tr>
						  	<tr bgcolor="#DDDDDD">
						  	  <th width="80">Bags</th>
					  	      <th width="80">Net</th>
						  	  <th width="80">Bags</th>
						  	  <th width="80">Net</th>
						  	  <th width="80">Bags</th>
						  	  <th width="80">Net</th>
						  	</tr>
						  	<tr>
								<td><input name="no_of_bags" type="text" id="no_of_bags" class="style11" style="width:80; text-align:right;" value="<%=Numeric.numberToStr(trucking.no_of_bags,0)%>" readonly></td>
						        <td><input name="net_weight"  type="text" id="net_weight" class="style11" style="width:80; text-align:right;" value="<%=Numeric.numberToStr(trucking.net_weight,0)%>" readonly></td>
						  	    <td><input name="delivered_bags"  type="text" id="delivered_bags" class="style11" style="width:80; text-align:right;" value="<%=Numeric.numberToStr(trucking.delivered_bags,0)%>" readonly></td>
						  	    <td><input name="delivered_weight" type="text" id="delivered_weight" class="style11" style="width:80; text-align:right;" value="<%=Numeric.numberToStr(trucking.delivered_tons*1000,0)%>" readonly></td>
						  	    <td align="right"><%=Numeric.numberToStr(trucking.no_of_bags-trucking.delivered_bags,0)%>&nbsp;</td>
						  	    <td align="right"><strong><%=Numeric.numberToStr(trucking.getDiffWeight(),0)%></strong>&nbsp;</td>
						  	    <td align="right">&nbsp;</td>
						  	</tr>
					</table>
				</div></td>
			</tr>

			<tr>
				<td><div style="border:thin; border-style:solid; border-width:1; border-top:0; width:100%; overflow:hidden; padding-right:1px; padding-left:1px"><table width="100%" border="0" cellpadding="0" cellspacing="1" class="style2">
					  <tr>
		  			  	<td width="100" align="right">Remarks &nbsp;</td>
					  	<td colspan="2"><textarea name="remark" rows="4" class="style2" id="remark" style="width:100%" <%=readonly%>><%=trucking.remark%></textarea></td>
		  			  </tr>
		  			  <tr>
					  	<td  align="right">Completed &nbsp;</td>
						<td><%=Html.completionCheckBox(trucking)%></td>
		  			    <td align="right"><%=trucking.getUser().full_name%> &nbsp;</td>
		  			  </tr>
				</table>
				</div></td>
			</tr>

			<tr style="padding-top:1px">
				<td><table width="100%" cellpadding="0" cellspacing="0" class="style2">
					<tr>
						<td width="30"><img id="save_btn_" src="images/update.gif" border="0" onClick="saveTrucking(1)" style="display:<%=displayed%>" title="Save Data"></td>
						<td width="60" style="display:none"><a href="JavaScript:allocate()" style="display:<%=displayed%>">Allocation</a></td>
						<td>&nbsp;</td>
						<td align="right"><img src="../shared/images/print.jpg" onClick="printTrucking();"></td>
						<td width="60" align="right"><img src="../shared/images/listview.jpg" onClick="doListView();"></td>
					</tr>
				</table></td>
		    </tr>
		</table></td>
	</tr>
</table>

<%
	List<WncAllocationEntity> wncas = trucking.getWncAllocations();
	long wne_id = 0;
	int grade_id = 0;
	int i = 0;
%>

<div id="wnc_alloc" style=" border:solid; border-width:1; border-left:none; border-right:none; border-bottom:none; width:100%; display:<%=wncas.isEmpty()?"none":""%>">
<%@include file="traffic.wnc_allocation.jsp"%>
</div>
<%
	QualityReportEntity quality_report = trucking.getQualityReport();
%>
<%//@include file="quality.qr.input.jsp"%>
<div style="border-style:solid; border-width:1; border-left:none; border-right:none;; border-top:none; width:100%; display:">
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="style2" style="display:none">   
	<tr>
		<td width="15%" align="right">Inspector &nbsp;</td>
		<td><select name="inspector_id" id="inspector_id" class="style2" style="width:200px;" <%=disabled%>><%=Html.selectOptions(dao.getContactPersonDao().selectAll(list_all),quality_report.inspector_id,"")%></select></td>
	    <td align="right"><strong><%=quality_report.getRefNumber()%></strong>&nbsp;</td>
	</tr>
</table>
</div>

<div style="border-style:solid; border-width:1; border-left:none; border-right:none; border-bottom:none; border-top:0; width:100%;">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD">
	  <th width="30" rowspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onClick="doPost();"></th>
		<th width="120" rowspan="2">Wn Ref<br>(Loading)</th>
		<th width="70" rowspan="2">Date</th>
		<th width="150" rowspan="2">Grade</th>
		<th width="80" rowspan="2">Packing</th>
		<th width="60" rowspan="2">No of <br>Bags</th>
		<th colspan="4">Mts</th>
		<th rowspan="2">&nbsp;</th>
	</tr>
	<tr bgcolor="#DDDDDD">
	  <th width="70">Gross</th>
      <th width="60">Tare</th>
	  <th width="70">Net</th>
	  <th width="70">Out</th>
	</tr>
<%
	List<WnrAllocationEntity> wnas = trucking.getWnrAllocations();
	WnrAllocationEntity sum1 = dao.getWnrAllocationDao().newEntity();
	for (i = 0; i < wnas.size(); i++) {
		WnrAllocationEntity wna = wnas.get(i);
		WnrEntity wnr = wna.getWnr();
		WnEntity wn = wnr.getWeightNote();
		sum1.add(wna);
%>	
	<tr>
	  <td bgcolor="#DDDDDD" align="right"><%=i+1%>&nbsp;</td>
		<td style="color:<%=Action.getColor(wna.status)%>"><%=wnr.getRefNumber()%></td>
		<td align="center"><%=DateTime.dateToStr(wna.date_out)%></td>
		<td><%=wn.getGrade().short_name%></td>
		<td><%=wn.getPacking().short_name%></td>
		<td align="right"><%=wnr.no_of_bags%>&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(wnr.gross_weight/1000)%>&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(wnr.tare_weight/1000)%>&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(wnr.net_weight/1000)%>&nbsp;</td>
		<td align="right"><%=Numeric.numberToStr(wna.weight_out/1000)%>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
<%
	}
%>
	<tr bgcolor="#DDDDDD">
	  <th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th align="right"><%=sum1.getWnr().no_of_bags%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(sum1.getWnr().gross_weight/1000)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(sum1.getWnr().tare_weight/1000)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(sum1.getWnr().net_weight/1000)%>&nbsp;</th>
		<th align="right"><%=Numeric.numberToStr(sum1.weight_out/1000)%>&nbsp;</th>
		<th>&nbsp;</th>
	</tr>
</table>
</div>

<div style="border-style:solid; border-width:1; border-left:none; border-right:none; border-bottom:none; width:100%;">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD">
                <th width="30" rowspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onClick="doPost();"></th>
                <th width="120" rowspan="2">WN Ref<br>(Unloading)</th>
                <th width="70" rowspan="2">Date</th>
                <th width="150" rowspan="2">Grade</th>
                <th width="80" rowspan="2">Packing</th>
                <th width="60" rowspan="2">No of<br>Bags</th>
                <th colspan="3">Mts</th>
                <th width="" rowspan="2">&nbsp;</th>
              </tr>
              <tr bgcolor="#DDDDDD">
                <th width="70">Gross</th>
                <th width="60">Tare</th>
                <th width="70">Net</th>
              </tr>
<%
	List<WnReceivingEntity> wns = trucking.getWeightNotes();
	WnReceivingEntity sum = dao.getWnReceivingDao().newEntity();
	int no = 1;
	for (WnReceivingEntity wn : wns) {
		sum.add(wn);
%>
              <tr style="background:">
                <td align="right" bgcolor="#DDDDDD"><%=no++%></td>
                <td><%=wn.getRefNumber()%></td>
                <td align="center"><%=DateTime.dateToStr(wn.date)%></td>
                <td><%=wn.getGrade().short_name%></td>
                <td><%=wn.getPacking().short_name%></td>
                <td align="right"><%=Numeric.numberToStr(wn.no_of_bags,0)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(wn.gross_weight/1000,4)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(wn.tare_weight/1000,4)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(wn.net_weight/1000,4)%> &nbsp;</td>
                <td align="right">&nbsp;</td>
              </tr>
<%
	}
%>
              <tr style="background:#DDDDDD">
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><strong>Total :</strong></td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.no_of_bags,0)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.gross_weight/1000,4)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.tare_weight/1000,4)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.net_weight/1000,4)%></strong> &nbsp;</td>
                <td align="right">&nbsp;</td>
              </tr>
</table>
</div>
	  
<input type="hidden" name="no"    id="no"    value="0">	

<script language="javascript">
	//getObj("quality_input_div").style.borderLeft = "0";
	hide("cup_test_input");
	if (<%=trucking.getIdLong()%> == -1) {	
		addNewListItem(document.formMain.trucking_id,"<%=trucking.getRefNumber()%>");
	}

	if (readonly) {
		//setCompletedElements("inst_id","contract_id");
	}	
	

</script>
