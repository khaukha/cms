<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	          <tr bgcolor="#DDDDDD" align="center" style="font-weight:bold">
    	        <th width="80">Type</th>
        	    <th width="80">Status</th>
            	<th width="80">Quality</th>
    	        <th width="">Grade</th>				
        	    <th width="120">Inspector</th>
        	    <th width="100">Month</th>
          	</tr>
			<tr>
            <td valign="top"><select name="qr_type" id="qr_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.qr_type)%></select></td>
            <td valign="top"><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td valign="top"><select name="quality_id" id="quality_id" size=7 class="style11" style="width:100%;" onChange="setValue('grade_id',0);doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.quality_id,"All")%></select></td>
            <td valign="top"><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnDao(qr_type).getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td valign="top"><select name="inspector_id" id="inspector_id" size=7 class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptions(dao.getContactPersonDao().selectAll(),sc.inspector_id,"All")%></select></td>
             <td valign="top"><select name="filter_month" id="filter_month" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(task.getMonthFilter(), sc.filter_month, "All")%></select></td>
          </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bordercolor="#FFFFFF">
                  <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''">
                    <th width="30"  rowspan="3" onClick="doPost()"><img src="../shared/images/refresh.gif" width="9" height="9" class="style3"></th>
                    <th width="120"  rowspan="3" onClick="">QR Ref</th>
                    <th width="60"  rowspan="3" onClick="">WN<br>Date</th>
                    <th rowspan="3">Grade</th>
                    <th width="150" rowspan="3">Remarks</th>
                    <th width="70" rowspan="3">Packing</th>
                    <th width="60" rowspan="3">Tons</th>
                    <th colspan="14">Quality Report</th>
                    <th>&nbsp;</th>
                  </tr>
                  <tr align="center" bgcolor="#DDDDDD" class="style11" style="font-weight:; cursor:pointer">
                    <th colspan="6">Defect</th>
                    <th colspan="8">Screen</th>					
                    <th>&nbsp;</th>
                  </tr>
                  <tr align="center" bgcolor="#DDDDDD" class="style11" style="font-weight:; cursor:pointer">
                    <th width="40">Moist</th>
                    <th width="40">FM</th>
                    <th width="40">Black</th>
                    <th width="40">Brk.</th>
                    <th width="40">Brown</th>
                    <th width="40">Exc.</th>
                    <th width="32">18</th>
                    <th width="32">17</th>
                    <th width="32">16</th>
                    <th width="32">15</th>
                    <th width="32">14</th>
                    <th width="32">13</th>
                    <th width="32">12</th>
                    <th width="32">12-</th>
                    <th width="16">&nbsp;</th>
                  </tr>
</table>

<div style="overflow:scroll; height:250px; width:100%"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bgcolor="#DDDDDD">
<%
	sc.type = 'Q';
	sc.setFilterMonth();	
	PagingView<WnSampleEntity> _paging = dao.getWnSampleDao().getPaging();
	List<WnSampleEntity> wns = _paging.paging();
	WnSampleEntity sum = _paging.sumary();	
	AverageEntity sum_av = dao.getAverageDao().newEntity();	
	//List<WnSampleEntity> wns = task.getQrSample().search(sc);
	//AverageEntity sum_av = dao.getAverageDao().newEntity();
	for (int i = 0; i < wns.size(); i++) {	
		//if (i >= 200) break;
		WnSampleEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();

		AverageEntity av = dao.getAverageDao().newEntity(qr, wn.net_weight/1000);		
		sum_av.add(av);
		
		String qr_color = Action.getColor(qr.status);
		String wn_color = Action.getColor(wn.status);
%>				
                <tr style="font-size:11px" align="right" onClick="rowClicked(this,<%=qr.getIdLong()%>)" onDblClick="setValue('view',1);doTask();" bgcolor="#FFFFFF">
                  <td width="30"><%=qr.getIdLong()%></td>
                  <td width="120" align="left" style="color:<%=qr_color%>"><%=qr.getRefNumber()%></td>
				  <td width="60" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td align="left"><%=wn.getGrade().short_name%></td>
                  <td align="left" width="150"><%=qr.remark%></td>
                  <td width="70" align="left"><%=wn.getPacking().short_name%></td>                  				  
                  <td width="60"><%=Numeric.numberToStr(wn.net_weight/1000,3)%>&nbsp;</td>                  				  
                  <td width="40"><%=Numeric.getPercent(qr.moisture,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.foreign_matter,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.black,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.broken,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.sound,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.floats,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc18,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc17,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc16,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc15,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc14,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc13,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc12,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.below_sc12,pad)%></td>
                </tr>
<%
	}
%>				
</table></div>

<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bordercolor="#FFFFFF">
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000">
                <th align="center">Estimated Total in %</th>
			  	<td width="60"><%=Numeric.numberToStr(sum_av.total_tons,3)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().moisture,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().foreign_matter,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().black,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().broken,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().sound,pad)%></td>
			  	<td width="40"><%=Numeric.getPercent(sum_av.getPercent().floats,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc18,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc17,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc16,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc15,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc14,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc13,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().sc12,pad)%></td>
			  	<td width="32"><%=Numeric.getPercent(sum_av.getPercent().below_sc12,pad)%></td>
                <td width="16">&nbsp;</td>
              </tr>
</table>				
