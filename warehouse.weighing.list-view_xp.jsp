<%
	WeighingExPro weighing = task.getWeighingExPro();
	weighing.doTask();
%>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	      <tr bgcolor="#DDDDDD" align="center">
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
            <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onchange="itemSelected(this);"><%=Html.selectOptionsX(dao.getProcessingDao().getList(false),sc.filter_inst_id,"All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="qualityChange()"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnExProDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
            <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(weighing.selectDateFilter(), sc.filter_date, "All")%></select></td>
            </tr>		  
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr align="center" bgcolor="#DDDDDD">
    	<th width="42" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
        <th width="100" rowspan="2">WN  Ref</th>
        <th width="100" rowspan="2">PO Ref</th>
        <th width="180" rowspan="2">Grade</th>
        <th width="40" rowspan="2">Area</th>
        <th width="70" rowspan="2">Date </th>
        <th width="80" rowspan="2">Packing</th>
        <th width="60" rowspan="2">Num</th>
        <th colspan="3">Kgs</th>
        <th colspan="2">Stock</th>
        <th width="" rowspan="2">&nbsp;</th>
	</tr>
	<tr align="center" bgcolor="#DDDDDD">
	  <th width="70">Gross</th>
      <th width="60">Tare</th>
	  <th width="70">Net</th>
	  <th width="60">Bags</th>
	  <th width="70">Kgs</th>
	</tr>
</table>

<div  id="weighing_list_view" style="overflow:scroll; height:250px; width:100%">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
    sc.setFilterDate();
	List<WnExProEntity> wns =  dao.getWnExProDao().getPaging().paging();
	WnExProEntity sum = dao.getWnExProDao().getPaging().sumary();
	for (int i = 0; i < wns.size(); i++) {
		WnExProEntity wn = wns.get(i);
		String wn_color = Action.getColor(wn.status);
%>				
                <tr onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
                  <td width="100" style="color:<%=wn_color%>"><%=wn.getShortRef()%></td>
                  <td width="100"><%=wn.getInstruction().getShortRef()%></td>
                  <td width="180"><%=wn.getGrade().short_name%></td>
                  <td width="40" align="center"><%=wn.getArea().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="60" align="right"><%=wn.no_of_bags%></td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.gross_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.net_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.stock_weight,0)%>&nbsp;</td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right" bgcolor="#DDDDDD">
		  <td width="42">&nbsp;</td>
            <td width="575" align="center">Total</td>
            <td width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</td>
            <td width="70"><%=Numeric.numberToStr(sum.gross_weight,0)%>&nbsp;</td>
            <td width="60"><%=Numeric.numberToStr(sum.tare_weight,0)%>&nbsp;</td>
            <td width="70"><%=Numeric.numberToStr(sum.net_weight,0)%>&nbsp;</td>
            <td width="60" align="right"><%=Numeric.numberToStr(sum.stock_bags,0)%>&nbsp;</td>
             <td width="70" align="right"><%=Numeric.numberToStr(sum.stock_weight,0)%>&nbsp;</td>
			<td width="">&nbsp;</td>
          </tr>
</table>

<div id="weighing_report" style="display:none"><%@include file="report.parameter.jsp"%></div>

<table id="weighing_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
               <tr>
                 <td width="20"><img src="../shared/images/new.gif" width="15" height="15" onClick="doAddNew();" style="display:<%=displayed%>"></td>
				 <td align="center"><%@include file="paging.jsp"%></td>
                 <td width="60" align="center"><img src="images/report.jpg" width="55" height="18" onClick="doReport('weighing','(WN Date)');"></td>
				 <td width="60" align="center"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="doCardView();"></td>
               </tr>
</table>