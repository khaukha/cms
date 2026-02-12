<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
                <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='Click on columns to sort' onMouseOver="window.status='Click on columns to sort'" >
                  <th width="30" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="115" onClick="doSort(table,'wn.ref_number')">WN  Ref</th>
                  <th width="110">Trucking Ref</th>
                  <th width="60">Truck<br />No</th>
                  <th width="100">From</th>
                  <th width="100">To</th>
                  <th>Grade</th>
                  <th width="30">Wh</th>
                  <th width="30">Ar.</th>
                  <th width="70">Date </th>
                  <th width="80">Packing</th>
                  <th width="40">Num</th>
                  <th width="60">Gross<br>(Mts)</th>
                  <th width="60">Tare<br>(Mts)</th>
                  <th width="60">Net<br>(Mts)</th>
                  <th width="60">Stock<br>(Mts)</th>
                  <th width="14">&nbsp;</th>
                </tr>
          </table></td>
          </tr>
	  <tr>
	    <td><div style="overflow:scroll; height:250px;">		  
			  <table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
<%
	task.getSqlCommand().setSort(true);
    WnReceiving wnx = task.getWnReceiving();
	List<WnReceivingEntity> wns = wnx.getDetails();
	WnReceivingEntity sum = new WnReceivingEntity(task);
	for (int i = 0; i < wns.size(); i++) {
		WnReceivingEntity wn = wns.get(i);
		sum.add(wn);
		if (i >= 200) continue;
		String wn_color = task.getColor(wn.status);
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <td width="30" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%></td>
                  <td width="115" style="color:<%=wn_color%>"><%=wn.getRefNumber()%></td>
                  <td width="110"><%=wn.getTrucking().getRefNumber()%></td>
                  <td width="60"><%=wn.getTrucking().truck_no%></td>
                  <td width="100"><%=wn.getTrucking().getFrom().short_name%></td>
                  <td width="100"><%=wn.getTrucking().getDestination().short_name%></td>
                  <td><%=wn.getGrade().short_name%></td>
                  <td width="30" align="center"><%=wn.getWarehouse().code%></td>
                  <td width="30" align="center"><%=wn.area%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="40" align="right"><%=wn.no_of_bags%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.gross_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.net_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_weight/1000)%></td>
                </tr>
<%
	}
%>				
          </table>
</div></td>
      </tr>
          <tr>
            <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right">
            <th  align="right">Total</th>
            <td width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.gross_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.tare_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.net_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.stock_weight/1000)%></td>
			<td width="14">&nbsp;</td>
          </tr>
        </table></td>
          </tr>
        </table>
		
	<input type="hidden" name="search_field_1" id="search_field_1"  value="wn.type">
	<input type="hidden" name="search_key_1"   id="search_key_1"    value="R">
