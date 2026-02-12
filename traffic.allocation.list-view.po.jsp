<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr bgcolor="#DDDDDD" align="center">
            <th width="110">Type</th>
            <th width="100">Status</th>
            <th width="180">Type</th>
            <th width="120">Quality</th>
            <th>Grade</th>            
            <th width="120">Completed Date</th>
  </tr>
          <tr>
            <td><select name="alloc_type" id="alloc_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%@include file="inc/options.allocation.jsp"%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(), sc.filter_status, "All")%></select></td>
            <td><select name="filter_type_id" id="filter_type_id" size="7" class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptions(dao.getProcessingTypeDao().selectAll(), sc.filter_type_id, "All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(), sc.filter_quality_id, "All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getProcessingDao().getGradeFilter(sc.filter_quality_id),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getProcessingDao().selectDateFilter(),sc.filter_date,"All")%></select></td>
  </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr align="center" bgcolor="#DDDDDD">
                <th width="42"  rowspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
                <th width="110"  rowspan="2">PO Ref</th>
                <th width="100"  rowspan="2">Type</th>
                <th width="180" rowspan="2">Grade</th>
                <th width="80" rowspan="2">Packing</th>
                <th colspan="4">Tons</th>
                <th colspan="2">Period</th>
                <th width="" rowspan="2">&nbsp;</th>
              </tr>
              <tr align="center" bgcolor="#DDDDDD">
                <th width="80">Allocated</th>
                <th width="80">In-Pro</th>
                <th width="80">Ex-Pro</th>
                <th width="80">Pending</th>
                <th width="70">From</th>
                <th width="87">To</th>
              </tr>
</table>

<div id="allocation_list_view" style="overflow:scroll; height:250px; width:100%">
		<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	sc.setFilterDate();
	double sum_balanced_tons = 0;
	List<ProcessingEntity> insts = dao.getProcessingDao().getPaging().paging();
	ProcessingEntity	sum = dao.getProcessingDao().newEntity();	
	for (int i = 0; i < insts.size(); i++) {
		ProcessingEntity inst = insts.get(i);
		sum.add(inst);
		String color = Action.getColor(inst.status);
		sum_balanced_tons += inst.getOpenTons();
%>				
                <tr onClick="instClicked(this,<%=inst.getIdLong()%>)" onDblClick="setValue('view',1);doTask();">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=inst.getIdLong()%>&nbsp;</th>
                  <td width="110" style="color:<%=color%>"><%=inst.getRefNumber()%></td>
                  <td width="100"><%=inst.getProcessingType().short_name%></td>
                  <td width="180"><%=inst.getGrade().short_name%></td>
                  <td width="80"><%=inst.getPacking().short_name%></td>
                  <td width="80" align="right"><%=Numeric.numberToStr(inst.allocated_tons)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(inst.ip_tons)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(inst.xp_tons)%>&nbsp;</td>
                  <td width="80" align="right"><%=Numeric.numberToStr(inst.getOpenTons())%>&nbsp;</td>
                  <td width="70" align="center"><%=DateTime.dateToStr(inst.first_date)%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(inst.last_date)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>		
	</table></div>
	
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr style="font-weight:bold" align="right" bgcolor="#DDDDDD">
                <td width="516" align="center">Total</td>
                <td width="80"><%=Numeric.numberToStr(sum.allocated_tons)%>&nbsp;</td>
                <td width="80"><%=Numeric.numberToStr(sum.ip_tons)%>&nbsp;</td>
                <td width="80"><%=Numeric.numberToStr(sum.xp_tons)%>&nbsp;</td>
                <td width="80"><%=Numeric.numberToStr(sum_balanced_tons)%>&nbsp;</td>
				<td width="70">&nbsp;</td>
				<td width="">&nbsp;</td>
              </tr>
</table>

