<%
	WeighingSample weighing = task.getWeighingSample();
	weighing.doTask();
%>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	      <tr bgcolor="#EEEEEE" align="center">
            <th width="100">Type</th>
            <th width="100">Status</th>
            <th width="250">Grade</th>
            <th width="100">Date</th>
	        <th>&nbsp;</th>
	      </tr>
          <tr>
            <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnSampleDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(weighing.selectDateFilter(), sc.filter_date, "All")%></select></td>
             <td>&nbsp;</td>
          </tr>		  
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="30" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="115" onClick="doSort(table,'wn.ref_number')">WN  Ref</th>
                  <th width="200">Grade</th>
                  <th width="30">Wh</th>
                  <th width="40">Ar.</th>
                  <th width="70">Date </th>
                  <th width="80">Packing</th>
                  <th width="40">Num</th>
                  <th width="60">Gross<br>(Mts)</th>
                  <th width="60">Tare<br>(Mts)</th>
                  <th width="60">Net<br>(Mts)</th>
                  <th width="60">Stock<br>(Mts)</th>
                  <th width="16">&nbsp;</th>
                </tr>
</table>
<div id="weighing_list_view" style="overflow:scroll; height:250px; width:100%"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<WnSampleEntity> wns = dao.getWnSampleDao().getPaging().paging();
	WnSampleEntity sum = dao.getWnSampleDao().getPaging().sumary();
	for (int i = 0; i < wns.size(); i++) {
		WnSampleEntity wn = wns.get(i);
		String wn_color = Action.getColor(wn.status);
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <td width="30" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%></td>
                  <td width="115" style="color:<%=wn_color%>"><%=wn.getRefNumber()%></td>
                  <td width="200"><%=wn.getGrade().short_name%></td>
                  <td width="30" align="center"><%=wn.getWarehouse().code%></td>
                  <td width="40" align="center"><%=wn.getArea().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="40" align="right"><%=wn.no_of_bags%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.gross_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.net_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_weight/1000)%></td>
		<td>&nbsp;</td>				  
	</tr>
<%
	}
%>				
</table>
</div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right">
            <td align="right">Total</td>
            <td width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.gross_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.tare_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.net_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.stock_weight/1000)%></td>
			<td width="">&nbsp;</td>
          </tr>
</table>
<div id="weighing_report" style="display:none"><%@include file="report.parameter.jsp"%></div>	
<table id="weighing_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="20"><img src="../shared/images/new.gif" onClick="doAddNew();" style="display:<%=displayed%>"></td>
		<td align="center"><%@include file="paging.jsp"%></td>
        <td width="60" align="center"><img src="images/report.jpg" onClick="doReport('weighing','(WN Date)');"></td>
		<td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="doCardView();"></td>
    </tr>
</table>  

