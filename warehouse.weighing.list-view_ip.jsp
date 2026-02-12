<%
	CheckingInPro checking = task.getCheckingInPro();
	checking.doTask();
%>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	      <tr bgcolor="#DDDDDD">
            <th width="100">Type</th>
            <th width="100">Status</th>
            <th width="150">PO Ref.</th>
            <th width="100">Quality</th>
            <th width="">Grade</th>
            <th width="100">Date</th>
	        </tr>
          <tr>
            <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onchange="itemSelected(this)"><%=Html.selectOptionsX(dao.getProcessingDao().getList(false),sc.filter_inst_id,"All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="qualityChange()"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnAllocationDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(checking.selectDateFilter(), sc.filter_date, "All")%></select></td>
            </tr>		  
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="42" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="100" rowspan="2">WN  Ref</th>
                  <th width="100" rowspan="2">PO Ref</th>
                  <th width="140" rowspan="2">Supplier</th>
                  <th width="180" rowspan="2">Grade</th>
                  <th width="40" rowspan="2">Area</th>
                  <th width="70" rowspan="2">Date </th>
                  <th width="80" rowspan="2">Packing</th>
                  <th colspan="2">Allocated</th>
                  <th width="70" rowspan="2">In-Pro.<br>(Mts)</th>
                  <th width="70" rowspan="2">W.Loss<br>(Mts)</th>
                  <th width="70" rowspan="2">Pending<br>(Mts)</th>
                  <th width="" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD" >
                  <th width="60">Bags</th>
                  <th width="70">Mts</th>
                </tr>
</table>
<div id="weighing_list_view" style="overflow:scroll; height:250px; width:100%">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.inst_type = 'P';
	sc.setFilterDate();
	List<WnAllocationEntity> wns = dao.getWnAllocationDao().getPaging().paging();
	WnAllocationEntity sum = dao.getWnAllocationDao().getPaging().sumary();
	double pending_weight = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnAllocationEntity wn = wns.get(i);
		pending_weight += wn.getPendingWeight();
		String wn_color = Action.getColor(wn.status);
		String supplier = wn.getWeightNote().type == 'I' ? wn.getWeightNote().getInstruction().getContract().getSeller().short_name : "";
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=wn_color%>"><%=wn.getWeightNote().getShortRef()%></td>
                  <td width="100"><%=wn.getInstruction().getShortRef()%></td>
                  <td width="140"><%=supplier%></td>
                  <td width="180"><%=wn.getWeightNote().getGrade().short_name%></td>
                  <td width="40" align="center"><%=wn.getWeightNote().getArea().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="80"><%=wn.getWeightNote().getPacking().short_name%></td>
                  <td width="60" align="right"><%=wn.allocated_bags%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.allocated_weight/1000)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.weight_out/1000)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.weight_loss/1000)%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.getPendingWeight()/1000)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right" bgcolor="#DDDDDD">
		  	<td width="42">&nbsp;</td>
            <td width="716" align="center">Total</td>
            <td width="60"><%=Numeric.numberToStr(sum.allocated_bags,0)%></td>
            <td width="70"><%=Numeric.numberToStr(sum.allocated_weight/1000)%></td>
            <td width="70"><%=Numeric.numberToStr(sum.weight_out/1000)%></td>
            <td width="70"><%=Numeric.numberToStr(sum.weight_loss/1000)%></td>
            <td width="70"><%=Numeric.numberToStr(pending_weight/1000)%></td>
			<td width="">&nbsp;</td>
          </tr>
</table>
<div id="weighing_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
<table id="weighing_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
               <tr>
                 <td width="20"><img src="../shared/images/new.gif" onClick="doAddNew();" style="display:<%=displayed%>"></td>
				 <td align="center"><%@include file="paging.jsp"%></td>
                 <td width="60" align="right"><img src="images/report.jpg" onClick="doReport('weighing','(WN Date)');"></td>
				 <td width="60" align="right"><img src="../shared/images/cardview.jpg" onClick="doCardView();"></td>
               </tr>
</table>