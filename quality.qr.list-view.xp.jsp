<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	          <tr bgcolor="#DDDDDD">
    	        <th width="80">Type</th>
        	    <th width="80">Status</th>
            	<th width="130">PO Ref</th>
            	<th width="80">Quality</th>
    	        <th width="">Grade</th>				
        	    <th width="120">Inspector</th>
        	    <th width="100">Month</th>
          	</tr>
			<tr>
            <td><select name="qr_type" id="qr_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.qr_type)%></select></td>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptionsX(dao.getProcessingDao().getList(false),sc.filter_inst_id,"All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="setValue('filter_grade_id',0);doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnDao(qr_type).getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_inspector_id" id="filter_inspector_id" size=7 class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptions(dao.getContactPersonDao().selectAll(),sc.filter_inspector_id,"All")%></select></td>
             <td><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(task.getMonthFilter(), sc.filter_month, "All")%></select></td>
          </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bordercolor="#FFFFFF">
                  <tr align="center" bgcolor="#DDDDDD">
                    <th width="42"  rowspan="3" onClick="doPost()"><img src="../shared/images/refresh.gif" width="9" height="9" class="style3"></th>
                    <th width="90"  rowspan="3">QR Ref</th>
                    <th width="90"  rowspan="3">PO Ref</th>
                    <th width="60"  rowspan="3">WN<br>Date</th>
                    <th width="150" rowspan="3">Grade</th>
                    <th width="150" rowspan="3">Remarks</th>
                    <th width="70" rowspan="3">Packing</th>
                    <th width="60" rowspan="3">Tons</th>
                    <th colspan="15">Quality Report</th>
                    <th width="" rowspan="3">&nbsp;</th>
                  </tr>
                  <tr align="center" bgcolor="#DDDDDD">
                    <th colspan="7">Defect</th>
                    <th colspan="8">Screen</th>					
                  </tr>
                  <tr align="center" bgcolor="#DDDDDD">
                    <th width="40">Moist</th>
                    <th width="40">FM</th>
                    <th width="40">Black</th>
                    <th width="40">Brk.</th>
                    <th width="40">Brown</th>
                    <th width="40">O.Crop</th>					
                    <th width="40">Exc.</th>
                    <th width="32">18</th>
                    <th width="32">17</th>
                    <th width="32">16</th>
                    <th width="32">15</th>
                    <th width="32">14</th>
                    <th width="32">13</th>
                    <th width="32">12</th>
                    <th width="32">12-</th>
                  </tr>
</table>

<div id="qr_list_view" style="overflow:scroll; height:250px; width:100%; display:">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bgcolor="#DDDDDD">
<%
    sc.setFilterMonth();
	sc.type = 'Q';
	List<WnExProEntity> wns = dao.getWnExProDao().getPaging().paging();
	WnExProEntity sum = dao.getWnExProDao().getPaging().sumary();		
	AverageEntity sum_av = dao.getAverageDao().newEntity();
	for (int i = 0; i < wns.size(); i++) {	
		WnExProEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();

		AverageEntity av = dao.getAverageDao().newEntity(qr, wn.net_weight/1000);		
		sum_av.add(av);
		
		String qr_color = Action.getColor(qr.status);
		String wn_color = Action.getColor(wn.status);
%>				
                <tr align="right" onClick="rowClicked(this,<%=qr.getIdLong()%>)" onDblClick="setValue('view',1);doTask();" bgcolor="#FFFFFF">
                  <th width="42" align="right" bgcolor="#DDDDDD"><%=qr.getIdLong()%>&nbsp;</th>
                  <td width="90" align="left" style="color:<%=qr_color%>"><%=qr.getShortRef()%></td>
                  <td width="90" align="left"><%=wn.getInstruction().getShortRef()%></td>
				  <td width="60" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="150" align="left"><%=wn.getGrade().short_name%></td>
                  <td align="left" width="150"><%=qr.remark%></td>
                  <td width="70" align="left"><%=wn.getPacking().short_name%></td>                  				  
                  <td width="60"><%=Numeric.numberToStr(wn.net_weight/1000,3)%>&nbsp;</td>                  				  
                  <td width="40"><%=Numeric.getPercent(qr.moisture,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.foreign_matter,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.black,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.broken,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.sound,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.withered,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.floats,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc18,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc17,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc16,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc15,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc14,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc13,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc12,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.below_sc12,pad)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bordercolor="#FFFFFF">
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000">
                <td width="659" align="center">Estimated Total in %</td>
			  	<td width="60"><%=Numeric.numberToStr(sum_av.total_tons,3)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().moisture,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().foreign_matter,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().black,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().broken,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().sound,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().withered,pad)%></td>				
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().floats,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc18,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc17,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc16,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc15,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc14,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc13,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc12,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().below_sc12,pad)%></td>
                <td width="">&nbsp;</td>
              </tr>
</table>
