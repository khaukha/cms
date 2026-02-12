<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
                <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='' onMouseOver="window.status=''" >
                  <th width="30" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="120" rowspan="2" onClick="doSort(table,'wn.ref_number')">WN  Ref</th>
                  <th width="110" rowspan="2">PO Ref</th>
                  <th width="140" rowspan="2" style="display:<%=task.getWnType()==Const.WN_EX_PRO?"none":""%>">Supplier</th>
                  <th rowspan="2" onClick="doSort(table,'grade')">Grade</th>
                  <th width="30" rowspan="2">Area</th>
                  <th width="70" rowspan="2">Date </th>
                  <th width="80" rowspan="2">Packing</th>
                  <th width="40" rowspan="2">Num</th>
                  <th colspan="3">Kgs</th>
                  <th colspan="2">Stock</th>
                  <th width="14" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD" style="font-weight:bold; cursor:pointer" title='Click on columns to sort' onMouseOver="window.status='Click on columns to sort'" >
                  <th width="60">Gross</th>
                  <th width="60">Tare</th>
                  <th width="60">Net</th>
                  <th width="60">Bags</th>
                  <th width="60">Kgs</th>
                </tr>
          </table></td>
          </tr>
	  <tr>
	    <td><div style="overflow:scroll; height:250px;">		  
			  <table width="100%"  border="0" cellpadding="1" cellspacing="1" class="style2">
<%
	task.getSqlCommand().setSort(true);
    WnExPro wnx = task.getWnExPro();
	List<WnExProEntity> wns = wnx.getDetails();
	WnExProEntity sum = new WnExProEntity(task);
	for (int i = 0; i < wns.size(); i++) {
		WnExProEntity wn = wns.get(i);
		sum.add(wn);
		if (i >= 200) continue;		
		String wn_color = task.getColor(wn.status);
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>,<%=wn.inst_id%>)">
                  <td width="30" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%></td>
                  <td width="120" style="color:<%=wn_color%>"><%=wn.getRefNumber()%></td>
                  <td width="110"><%=wn.getInstruction().getRefNumber()%></td>
                  <td width="140" style="display:<%=task.getWnType()==Const.WN_EX_PRO?"none":""%>"><%=wn.getInstruction().getContract().getSeller().short_name%></td>
                  <td><%=wn.getGrade().short_name%></td>
                  <td width="30" align="center"><%=wn.area%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="40" align="right"><%=wn.no_of_bags%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.gross_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.tare_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.net_weight,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_bags,0)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_weight,0)%>&nbsp;</td>
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
	<input type="hidden" name="search_key_1"   id="search_key_1"    value="<%=task.getWnType()%>">
		