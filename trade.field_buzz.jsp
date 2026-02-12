<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.FieldBuzz task = user.getBiz().getTrade().getFieldBuzz();
	task.select();		
	String displayed = task.isReadOnly() ? "none" : "";			
%>
<%@include file="header.jsp"%>
<%
	BatchEntity batch = task.doTask();
%>
<script language="javascript">
function processBatch(batch_id, task_id, action_title)
{
    if (<%=task.isReadOnly()%>) {
		alert("You don't have permission on doing this task.");
		return;
	}
	if (confirm("Are you sure to " + action_title)) {
		setValue("batch_id", batch_id);
		doTask(task_id);
	}
}

function doGenerateReport()
{
	doTask(4);
}
</script>
<form method="POST" name="formMain" action="" onSubmit="">			
<%@include file="posted-fields.jsp"%>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
			<tr>
			<td style="font-family:'Times New Roman, Times, serif'; color:#CC0000; font-weight:bold; font-size:12px; padding-left:4">FIELD BUZZ BATCHES</td>
			<td align="right"><%@include file="search.jsp"%></td>
			</tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
      <tr bgcolor="#DDDDDD" align="center">
		<th width="120">Status</th>
            <th width="200">DC</th>
            <th width="150">Contract Ref</th>
            <th width="200">Grade</th>			
            <th>&nbsp;</th>
    </tr>
	<tr>
		<td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();">
			<option value="0" <%=sc.filter_status==0?"selected":""%>>All</option>
			<option value="1" <%=sc.filter_status==1?"selected":""%> style="color:#5392DD ">Pending</option>
			<option value="2" <%=sc.filter_status==2?"selected":""%>>Confirmed</option>
			<option value="3" <%=sc.filter_status==3?"selected":""%> style="color:#FF0000">Rejected</option>
		</select></td>
		<td><select name="filter_dc_id" id="filter_dc_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getDcFilter(),sc.filter_dc_id,"All")%></select></td>
		<td><select name="filter_contract_id" id="filter_contract_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(task.getContractFilter(),sc.filter_contract_id,"All")%></select></td>
		<td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(task.getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
		<th align="center" style="color:#0000FF"><%=task.getMessage()%></th>
	</tr>	
</table>	
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr align="center" bgcolor="#DDDDDD">
            <th width="42" onClick="doPost();"><img src="../shared/images/refresh.gif" style="cursor:pointer"></th>
            <th width="80">Batch No</th>
            <th width="180">DC</th>
            <th width="60">Total Kg</th>
            <th width="110">Delivery Inst.</th>
            <th width="180">Grade</th>
            <th width="60">Paid Kg</th>
            <th width="60">Price<br>UGX/Kg</th>
			<th width="70">Batch Value<br>UGX</th>
            <th width="60">Comm.<br>UGX</th>
            <th width="70">Prepayment<br>UGX</th>
			<th width="70">Tobe Paid<br>UGX</th>
			<th width="60">Status</th>
			<th width="60">Conf./Rej.<br>Date</th>
			<th width="50"><a href="javascript:doTask(3)" title="Load new batches from FieldBuzz">Load Batches</a></th>
			<th width="">&nbsp;</th>
          </tr>
</table>
<div id="fb_list_view" style="overflow:scroll; height:250px; width:100%;"><table width="100%" border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<BatchEntity> bas = dao.getBatchDao().getPaging().paging();
	BatchEntity sum = dao.getBatchDao().getPaging().sumary();
	for (int i = 0; i < bas.size(); i++) {
		BatchEntity ba = bas.get(i);
		String color = Action.getColor(ba.status);
		DeliveryEntity di = ba.getDelivery();
		String action_txt = "", action_title = "";
		int tid = 0;
		if (ba.isPending()) {
		  action_txt = "Reject";
		  action_title = "Reject batch " + ba.batch_no;
		  tid = 1;
		} else if (ba.isConfirmed() && user.isAdmin()) {
		  action_txt = "Rollback";
		  action_title = "Rollback batch " + ba.batch_no;
		  tid = 2;
		}
%>
	<tr onClick="highlightOn(this)" style="color:">
		<th width="42" bgcolor="#DDDDDD"  align="right"><%=ba.getIdLong()%>&nbsp;</th>	
		<td width="80" style="color:<%=color%>"><%=ba.batch_no%></td>
		<td width="180"><%=ba.getDc().dc_name%></td>		
		<td width="60" align="right"><%=Numeric.numberToStr(ba.total_kgs, 0)%>&nbsp;</td>
		<td width="110"><%=ba.getDelivery().getRefNumber()%></td>
		<td width="180"><%=ba.getGrade().short_name%></td>
		<td width="60" align="right"><%=Numeric.numberToStr(ba.paid_kgs, 0, "")%>&nbsp;</td>
		<td width="60" align="right"><%=Numeric.numberToStr(ba.price_ugx, 0, "")%>&nbsp;</td>
		<td width="70" align="right"><%=Numeric.numberToStr(di.isNull()?0:ba.getPaidValueUgx(), 0, "")%>&nbsp;</td>
		<td width="60" align="right"><%=Numeric.numberToStr(ba.commission_amount_ugx, 0, "")%>&nbsp;</td>
		<td width="70" align="right"><%=Numeric.numberToStr(ba.prepayment_amount_ugx, 0, "")%>&nbsp;</td>
		<td width="70" align="right"><%=Numeric.numberToStr(di.isNull()?0:ba.getPaidAmountUgx(), 0, "")%>&nbsp;</td>
		<td width="60" style="color:<%=color%>"><%=ba.getStatusText()%></td>
		<td width="60" align="center"><%=DateTime.dateToStr(ba.post_date)%></td>
		<td width="50" align="center"><div style="display:<%=ba.isCompleted() && task.isReadOnly()?"none":""%>"><a href="javascript:processBatch(<%=ba.getIdLong()%>, <%=tid%>, '<%=action_title%>')" style="display:<%=ba.isPending()?"":""%>" title="<%=action_title%>"><%=action_txt%></a></div></td>
		<td>&nbsp;</td>
	</tr>
<%
	}
%>	
</table>
</div>
<div id="fb_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
<table id="fb_buttons" width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td width="42">&nbsp;</td>
		<td align="center">&nbsp;<%@include file="paging.jsp"%></td>
        <td align="center" width="60"><img src="images/report.jpg" onClick="doReport('fb');"></td>
      </tr>
</table>
<input type="hidden" name="batch_id"   id="batch_id" value="0">
<input type="hidden" name="no"   id="no" value="-1">
</form>

<%@include file="footer.jsp"%>

