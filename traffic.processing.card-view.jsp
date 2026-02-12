<%@include file="grade.jsp"%>
<%
	ProcessingEntity po = task.getProcessing();
	task.doTask(po);
	sc.inst_id = po.getIdLong();
	double balanced_tons = po.isCompleted() ? po.getAllLossTons() : po.getOpenTons();
	double total_tons    = po.isCompleted() ? po.allocated_tons : po.ip_tons;
	String balanced_percent = "";
	if (total_tons > 0) {
		balanced_percent = Numeric.numberToStr(balanced_tons*100/total_tons);
	}
	sc.filter_grade_id = 0;
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">
getObj("main_window").width = "";

var completed = <%=task.getProcessing().status == 2%>;
var readonly = <%=task.isReadOnly()%>;
var can_update = <%=!task.isReadOnly()%>;

function new_PO()
{
	if (getValue("filter_type_id") <= 0) {
		alert("Please select Processing Type");
		return;
	}
	if (addNewListItemById("inst_id","New Item") >= 0) doPost();
}

function doAllocation()
{
	doLink("traffic.allocation.jsp?alloc_type=P");
}

function delete_PO()
{
	if (readonly) {
		alert("You do not have permisstion to modify  data.");
		return;
	}
	if (getValue("inst_id") <= 0) return;
	if (confirm("Are you sure to delete " + getSelectedText("inst_id"))) doTask(3);
}

function listView()
{
	//setValue("filter_type_id", 0);
	setValue("view",0);
	doPost();
}
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style11">
	<tr>
		<td width="100"><img src="images/processing-orders.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr bgcolor="#DDDDDD">
		<th width="100">Status</th>
		<th width="135">PO Ref</th>
		<th>Detail</th>
	</tr>
	<tr valign="top">
		<td>
		<select name="filter_status" size="4" id="filter_status" class="style11" style="width:100;" onChange="doPost();"><%@include file="inc/options.status.jsp"%></select>
		<div style="width:100; height:; background-color:#DDDDDD; font-weight:bold;" align="center" class="style11">Type</div>
		<select name="filter_type_id" size="12" id="filter_type_id" class="style11" style="width:100; height:189" onChange="doPost()"><%=Html.selectOptions(dao.getProcessingTypeDao().selectAll(), sc.filter_type_id, "All")%></select></td>
		<td>
		<select name="inst_id" size=20 class="style11" id="inst_id" style="width:100%;" onChange="itemSelected(this)"><%=Html.selectOptionsX(dao.getProcessingDao().getList(po),po.getIdLong(),"All")%></select>
		<div style="display:<%=displayed%>">
			<img id="new_btn" src="images/new.gif" border="0" width="15" height="15" onClick="new_PO()">
			<img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="delete_PO()">
		</div></td>
		<td><div style="border-style:solid; border-width:1; width:auto; border-right:0">
<table width=""  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="130" align="right">PO Ref. &nbsp;</td>
		<td width="240" colspan="2" style="color:<%=Action.getColor(po.status)%>"><strong><%=po.getRefNumber()%></strong>&nbsp;(<%=po.getIdLong()%>)</td>
		<td width="120" align="right">Date &nbsp;</td>
		<td width="80"><strong><%=DateTime.dateToStr(po.date)%></strong></td>
	    <td width="120">&nbsp;</td>
	</tr>
	<tr>
		<td align="right">Type &nbsp;</td>
		<td colspan="2"><strong><%=po.getProcessingType().short_name%></strong></td>
		<td align="right">Value Addes &nbsp;</td>
		<td><%=Html.checkBox("value_added",po.value_added)%></td>
	    <td>&nbsp;</td>
	</tr>
	<tr>
	  <td align="right">Process At &nbsp;</td>
	  <td colspan="2"><select name="warehouse_id" id="warehouse_id" class="style2" style="width:180;"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),po.warehouse_id)%></select></td>
	  <td align="right">Allocated &nbsp;</td>
	  <td align="right"><strong><%=Numeric.numberToStr(po.allocated_tons)%></strong> &nbsp;</td>
	  <td>Mts</td>
	</tr>
	<tr>
	  <td align="right">Quality &nbsp;</td>
	  <td colspan="2"><select name="quality_id" id="quality_id" class="style2" style="width:180;" onChange="qualityChanged(this);"><%=Html.selectOptions(dao.getQualityDao().selectAll(),po.getGrade().quality_id)%></select></td>
	  <td align="right">In-Process &nbsp;</td>
	  <td align="right"><strong><%=Numeric.numberToStr(po.ip_tons)%></strong> &nbsp;</td>
	  <td>Mts</td>
	</tr>
	<tr>
	  <td align="right">Grade &nbsp;</td>
	  <td colspan="2"><select name="grade_id" id="grade_id" class="style2" style="width:240;" onChange="gradeChanged(this);"><%=Html.selectOptions(dao.getGradeDao().selectAll(),po.grade_id,"")%></select></td>
	  <td align="right">Ex-Process &nbsp;</td>
	  <td align="right"><strong><%=Numeric.numberToStr(po.xp_tons)%></strong> &nbsp;</td>
	  <td>Mts</td>
	</tr>
	<tr>
	  <td align="right">Packing &nbsp;</td>
	  <td colspan="2"><select name="packing_id" id="packing_id" class="style2" style="width:180;"><%=Html.selectOptions(dao.getPackingDao().selectAll(), po.packing_id, "")%></select></td>
	  <td align="right">Storage WL &nbsp;</td>
	  <td align="right"><strong><%=Numeric.numberToStr(po.ip_loss_tons)%></strong> &nbsp;</td>
	  <td>Mts</td>
	</tr>
	<tr>
	  <td align="right">&nbsp;</td>
	  <td>From</td>
	  <td>To</td>
	  <td align="right">Balance &nbsp;</td>
	  <td align="right"><strong><%=Numeric.numberToStr(balanced_tons)%></strong> &nbsp;</td>
	  <td>Mts &nbsp; ~ &nbsp;<%=balanced_percent%> % </td>
	</tr>
	<tr>
	  <td align="right">&nbsp;</td>
	  <td><%=Html.datePicker("first_date", po.first_date)%></td>
	  <td><%=Html.datePicker("last_date",po.last_date)%></td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>
	<tr>
	  <td align="right">Remark &nbsp;</td>
	  <td colspan="5"><textarea name="remark" rows="8" class="style2" id="remark" style="width:660;" wrap="hard"><%=po.remark%></textarea></td>
	</tr>
	<tr>
	  <td align="right">Completed &nbsp;</td>
	  <td><%=Html.completionCheckBox(po)%></td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  </tr>
	<tr>
	  <td align="right">By Order Of &nbsp;</td>
	  <td colspan="2"><strong><%=po.getUser().full_name%></strong></td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  </tr>
</table>
</div></td>
	</tr>
	<tr>
		<td><strong>In-Process</strong></td>
		<td valign="top">&nbsp;</td>
		<td><table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style11">
            <tr>
              <td width="20"><img id="save_btn_" src="images/update.gif" border="0" onClick="if (getValue('inst_id')!=0) doTask(1)" style="display:<%=displayed%>"></td>
			  <td>&nbsp;</td>
              <td align="center" width="60"><img src="../shared/images/print.jpg" width="55" height="18" border="0" onClick="doTask(2)"></td>
			  <td align="center" width="60"><img src="../shared/images/allocation.jpg" width="55" height="18" onClick="doAllocation();"></td>
		  	  <td align="center" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" border="0" onClick="listView();"></td>
            </tr>
</table></td>
	</tr>
</table>
<div style="border:thin; border-style:solid; border-width:1; border-left:none; border-right:none; width:100%">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD">
                <th width="45">Id</th>
                <th width="90">WN Ref. </th>
                <th width="100">Warehouse</th>
                <th width="120">Source Ref.</th>
                <th width="120">Quality</th>
                <th>Grade </th>
                <th width="70">Date</th>
                <th width="80">Packing</th>
                <th width="60">Bags</th>
                <th width="70">Allocated<br>(Mts)</th>
                <th width="70">InProcess<br>(Mts)</th>
                <th width="60">Pending<br>(Mts)</th>
              </tr>

<%
	List<WnAllocationEntity> wns = po.getWnAllocations();
	WnAllocationEntity isum = dao.getWnAllocationDao().newEntity();
	double pending_weight = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnAllocationEntity wn = wns.get(i);
		WnEntity wni = wn.getWeightNote();
		isum.add(wn);
		int no = i + 1;
		pending_weight += wn.getPendingWeight();
		String color = Action.getColor(wn.status);
%>
              <input type="hidden" name="wn_id_<%=no%>"  id="wn_id_<%=no%>"  value="<%=wn.getIdLong()%>">
              <tr id="wn_<%=no%>" onClick="highlightOn(this,2);">
                <th bgcolor="#DDDDDD" align="right"><%=wn.getIdLong()%>&nbsp;</th>
                <td style="color:<%=color%>"><%=wni.getShortRef()%></td>
                <td><%=wni.getWarehouse().short_name%></td>
                <td style="color:"><%=wni.getInstruction().getRefNumber()%></td>
                <td style="color:"><%=wni.getGrade().getQuality().short_name%></td>
                <td style="color:"><%=wni.getGrade().short_name%></td>
                <td align="center"><%=DateTime.dateToStr(wni.date)%></td>
                <td><%=wni.getPacking().short_name%></td>
                <td align="right"><%=Numeric.numberToStr(wn.allocated_bags,0)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(wn.allocated_weight/1000)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(wn.weight_out/1000)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(wn.getPendingWeight()/1000)%> &nbsp;</td>
              </tr>
<%
	}
%>
              <tr style="background:#DDDDDD">
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><strong>Total :</strong></td>
                <td align="right"><strong><%=Numeric.numberToStr(isum.allocated_bags,0)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(isum.allocated_weight/1000)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(isum.weight_out/1000)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(pending_weight/1000)%></strong> &nbsp;</td>
              </tr>
</table>
</div>
<label class="style1">Ex-Process</label>
<div style="border:thin; border-style:solid; border-width:1; border-left:none; border-right:none; width:100%">
<table width="100%" border="0" class="style11" cellpadding="0" cellspacing="1">
              <tr bgcolor="#DDDDDD">
                <th width="45">Id</th>
                <th width="90">WN Ref. </th>
                <th width="100">Warehouse</th>
                <th width="100">Quality</th>
                <th>Grade </th>
                <th width="70">Date</th>
                <th width="80">Packing</th>
                <th width="60">Bags</th>
                <th width="80">Net<br>(Mts)</th>
                <th width="80">Stock<br>(Mts)</th>
              </tr>

<%
	List<WnExProEntity> xps = po.getWeightNotes();
	WnExProEntity sum = dao.getWnExProDao().newEntity();
	for (int i = 0; i < xps.size(); i++) {
		WnExProEntity xp = xps.get(i);
		sum.add(xp);
		int no = i + 1;
		String wn_color = Action.getColor(xp.status);
		String qr_color = Action.getColor(xp.getQualityReport().status);
%>
              <input type="hidden" name="wn_id_<%=no%>"  id="wn_id_<%=no%>"  value="<%=xp.getIdLong()%>">
              <tr id="wn_<%=no%>" onClick="highlightOn(this,2);">
                <th bgcolor="#DDDDDD" align="right"><%=xp.getIdLong()%>&nbsp;</th>
                <td style="color:<%=wn_color%>"><%=xp.getShortRef()%></td>
                <td><%=xp.getWarehouse().short_name%></td>
                <td><%=xp.getGrade().getQuality().short_name%></td>
                <td style="color:<%=qr_color%>"><%=xp.getGrade().short_name%></td>
                <td align="center"><%=DateTime.dateToStr(xp.date)%></td>
                <td><%=xp.getPacking().short_name%></td>
                <td align="right"><%=Numeric.numberToStr(xp.no_of_bags,0)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(xp.net_weight/1000)%> &nbsp;</td>
                <td align="right"><%=Numeric.numberToStr(xp.stock_weight/1000)%> &nbsp;</td>
              </tr>
<%
		no++;
	}
%>
              <tr style="background:#DDDDDD">
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right">&nbsp;</td>
                <td align="right"><strong>Total:</strong></td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.no_of_bags,0)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.net_weight/1000)%></strong> &nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(sum.stock_weight/1000)%></strong> &nbsp;</td>
              </tr>
</table>
</div>
    <input type="hidden" name="contract_id"  id="contract_id"  value="<%=po.contract_id%>">
	<input type="hidden" name="no"  id="no"  value="0">
	  

<script language="javascript">
	//

	if (<%=po.isNew()%>) {	
		addNewListItem(document.formMain.inst_id,"<%=po.getRefNumber()%>");
	}
</script>
