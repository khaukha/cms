<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
                <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='Click on columns to sort' onMouseOver="window.status='Click on columns to sort'" >
                  <th width="30" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="120" rowspan="2" onClick="doSort(table,'wn.ref_number')">WN  Ref</th>
                  <th width="110" rowspan="2">PO Ref</th>
                  <th width="140" rowspan="2">Supplier</th>
                  <th rowspan="2">Grade</th>
                  <th width="30" rowspan="2">Area</th>
                  <th width="70" rowspan="2">Date </th>
                  <th width="80" rowspan="2">Packing</th>
                  <th colspan="2">Allocation</th>
                  <th width="60" rowspan="2">Delivered<br>(Mts)</th>
                  <th width="60" rowspan="2">W.Loss<br>(Mts)</th>
                  <th width="60" rowspan="2">Balance<br>(Mts)</th>
                  <th width="14" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='Click on columns to sort' onMouseOver="window.status='Click on columns to sort'" >
                  <th width="40">Bags</th>
                  <th width="60">Mts</th>
                </tr>
          </table></td>
          </tr>
	  <tr>
	    <td><div style="overflow:scroll; height:250px;">		  
			  <table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
<%
	WnInPro wne = task.getWnInPro();
	task.getSqlCommand().setSort(true);
	List<WnAllocationEntity> wns = wne.getDetails();
	WnAllocationEntity sum = new WnAllocationEntity(task);
	for (int i = 0; i < wns.size(); i++) {
		WnAllocationEntity wna = wns.get(i);
		WnImXpEntity wn = wna.getWeightNote();
		sum.add(wna);
		if (i >= 200) continue;
		String wn_color = task.getColor(wna.status);
		String sb = wn.getInstruction().getContract().getSeller().short_name;
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wna.getIdLong()%>,<%=wna.inst_id%>)">
                  <td width="30" align="right" bgcolor="#DDDDDD"><%=wna.getIdLong()%></td>
                  <td width="120" style="color:<%=wn_color%>"><%=wn.getRefNumber()%></td>
                  <td width="110"><%=wna.getInstruction().getRefNumber()%></td>
                  <td width="140"><%=sb%></td>
                  <td><%=wn.getGrade().short_name%></td>
                  <td width="30" align="center"><%=wn.area%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wna.date)%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="40" align="right"><%=wna.allocated_bags%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wna.allocated_weight/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wna.weight_out/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wna.weight_loss/1000)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wna.getBalanceWeight()/1000)%></td>
                </tr>
<%
	}
	wns = null;
%>				
          </table>
</div></td>
      </tr>
          <tr>
            <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style11">
          <tr style="font-weight:bold" align="right">
            <th  align="center">Total</th>
            <td width="60"><%=Numeric.numberToStr(sum.allocated_bags,0)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.allocated_weight/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.weight_out/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.weight_loss/1000)%></td>
            <td width="60"><%=Numeric.numberToStr(sum.balance_weight/1000)%></td>
			<td width="14">&nbsp;</td>
          </tr>
        </table></td>
          </tr>
        </table>
		
	<input type="hidden" name="search_field_1" id="search_field_1"  value="wna.inst_type">
	<input type="hidden" name="search_key_1"   id="search_key_1"    value="<%=Const.TYPE_PROCESSING%>">
		