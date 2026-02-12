<table width="100%" class="style2" border="0" cellpadding="0" cellspacing="1">
	<tr bgcolor="#DDDDDD">
		<th>WN Ref.</th>
		<th width="70">Date</th>
		<th width="60">Net</th>
	    <th width="50">BB</th>
	    <th width="50">Brown</th>
	    <th width="50">Excel.</th>
	    <th width="50">FM</th>
	    <th width="50">Moist.</th>
	    <th width="50">Moldy</th>
	    <th width="50">SC.18</th>
	    <th width="50">SC.16</th>
	    <th width="50">SC.13</th>
	    <th width="50">SC.13-</th>
    </tr>
<%
	List<WnImportEntity> wns = payment.getWeightNotes();
	for (int i = 0; i < wns.size(); i++) {
		WnImportEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();
%>	
	<tr onClick="highlightOn(this,1)" align="right" bgcolor="#CCFFFF">
		<td align="center">&nbsp;<%=wn.getRefNumber()%></td>
		<td align="center"><%=DateTime.dateToStr(wn.date)%></td>
		<td><%=Numeric.numberToStr(wn.net_weight/1000)%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.getBlackBroken(),"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.sound,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.floats,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.foreign_matter,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.moisture,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.moldy,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.sc18,"")%></td>
	    <td><%=Numeric.getPercent(qr.sc16 + qr.sc17,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.sc13 + qr.sc14 + qr.sc15,"")%>&nbsp;</td>
	    <td><%=Numeric.getPercent(qr.sc12 + qr.below_sc12,"")%>&nbsp;</td>
    </tr>
<%
	}
	String _readonly = "readonly";
	String q_disabled = payment.isDiscountQuality() ? "" : "disabled";
	String v_disabled = payment.isDiscountVolume() ? "" : "disabled";
	
%>	
	<tr bgcolor="#DDDDDD" style="font-weight:bold; color:#0000FF">
		<td colspan="2" align="center">Quality In</td> 
		<td align="right"><%=Numeric.numberToStr(payment.tons,4)%>&nbsp;</td>
	    <td><input name="black_broken_in"	type="text" id="black_broken_in"	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.black_broken_in,2)%>" 	onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="brown_in"       	type="text" id="brown_in"        	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.brown_in,2)%>"        	onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="excelsa_in"     	type="text" id="excelsa_in"      	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.excelsa_in,2)%>"      	onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="fm_in"          	type="text" id="fm_in"           	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.fm_in,4)%>"           	onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="moisture_in"    	type="text" id="moisture_in" 		class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.moisture_in,2)%>" 		onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="moldy_in"			type="text" id="moldy_in" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.moldy_in,2)%>" 		onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="sc18_in" 			type="text" id="sc18_in" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc18_in,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="sc16_in" 			type="text" id="sc16_in" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc16_in,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	    <td><input name="sc13_in" 			type="text" id="sc13_in" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc13_in,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	  	<td><input name="below_sc13_in" 	type="text" id="below_sc13_in" 		class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.below_sc13_in,2)%>" 	onChange="dataChanged(this)" <%=_readonly%>></td>
    </tr>
	<tr bgcolor="#EEEEEE" style="font-weight:bold">
	  <td colspan="2" align="center">Standard</td>
	  <td align="right">&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.black_broken_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.brown_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.excelsa_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.fm_allow,4)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.moisture_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.moldy_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.sc18_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.sc16_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.sc13_allow,2)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.below_sc13_allow,2)%>&nbsp;</td>
    </tr>
	<tr bgcolor="#DDDDDD" style="font-weight:bold; color:#FF0000">
	  <td align="center">Over</td>
	  <td align="center"><%//=Numeric.numberToStr(payment.qualitytDiscountToTons(),4)%></td>
	  <td align="center"><%=Numeric.numberToStr(payment.getDiscount().getDiscountPercent(),4)%></td>
	  <td><input name="black_broken_over"	type="text" id="black_broken_over"	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.black_broken_over,2)%>" 	onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="brown_over"       	type="text" id="brown_over"        	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.brown_over,2)%>"        	onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="excelsa_over"     	type="text" id="excelsa_over"      	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.excelsa_over,2)%>"      	onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="fm_over"          	type="text" id="fm_over"           	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.fm_over,4)%>"           	onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="moisture_over"    	type="text" id="moisture_over" 		class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.moisture_over,2)%>" 		onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="moldy_over" 			type="text" id="moldy_over" 		class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.moldy_over,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="sc18_over" 			type="text" id="sc18_over" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc18_over,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="sc16_over" 			type="text" id="sc16_over" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc16_over,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="sc13_over" 			type="text" id="sc13_over" 			class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc13_over,2)%>" 			onChange="dataChanged(this)" <%=_readonly%>></td>
	  <td><input name="below_sc13_over" 	type="text" id="below_sc13_over" 	class="style1" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.below_sc13_over,2)%>" 		onChange="dataChanged(this)" <%=_readonly%>></td>
    </tr>
	<tr bgcolor="#EEEEEE" style="font-weight:normal">
	  <td align="center">Contract Discount % </td>
	  <td align="center"><input name="discount_type" id="type_tons" type="radio" value="V" <%=payment.isDiscountVolume()?"checked":""%> onclick="doTask(1)" />&nbsp;Mts</td>
	  <td align="center"><input name="discount_type" id="type_quality" type="radio" value="Q" <%=payment.isDiscountQuality()?"checked":""%> onclick="doTask(1)" />&nbsp;%</td>
	  <td align="right"><%=Numeric.numberToStr(qa.black_broken_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.brown_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.excelsa_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.fm_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.moisture_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.moldy_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.sc18_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.sc16_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.sc13_discount,0)%>&nbsp;</td>
	  <td align="right"><%=Numeric.numberToStr(qa.below_sc13_discount,0)%>&nbsp;</td>
    </tr>
	<tr bgcolor="#DDDDDD" style="font-weight:bold; color:#FF0000">
	  <td align="center">Actual Discount</td>	  
	  <td><input name="discount_tons"	 type="text"  id="discount_tons" 	class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(payment.discount_tons,4)%>"    onChange="" <%=readonly%> <%=v_disabled%>></td>
	  <td><input name="discount_quality"  type="text" id="discount_quality" class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(payment.discount_quality,4)%>" onChange="" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="black_broken_discount"	type="text" id="black_broken_discount" 	class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.black_broken_discount,4)%>" 	onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="brown_discount" 			type="text" id="brown_discount" 		class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.brown_discount,4)%>" 			onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="excelsa_discount" 		type="text" id="excelsa_discount" 		class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.excelsa_discount,4)%>" 		onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="fm_discount" 			type="text" id="fm_discount" 			class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.fm_discount,4)%>" 				onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="moisture_discount" 		type="text" id="moisture_discount" 		class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.moisture_discount,4)%>" 		onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="moldy_discount" 			type="text" id="moldy_discount" 		class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.moldy_discount,4)%>" 			onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="sc18_discount" 			type="text" id="sc18_discount" 			class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc18_discount,4)%>" 			onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="sc16_discount" 			type="text" id="sc16_discount" 			class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc16_discount,4)%>" 			onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="sc13_discount" 			type="text" id="sc13_discount" 			class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.sc13_discount,4)%>" 			onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
	  <td><input name="below_sc13_discount" 	type="text" id="below_sc13_discount" 	class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(dc.below_sc13_discount,4)%>" 		onChange="dataChanged(this)" <%=readonly%> <%=q_disabled%>></td>
    </tr>
	
</table>			  
