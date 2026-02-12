<table width="100%" class="style2" border="0" cellpadding="0" cellspacing="1">
	<tr bgcolor="#DDDDDD">
		<th width="94">Settlement Date</th>
		<th width="94">Maturity Date</th>
		<th width="50">Int.Rate</th>
		<th width="60">Int.Days</th>
		<th width="90">Int.Amount</th>
		<td width="122" colspan="2" align="center"><a href="JavaScript:new_Interest()" class="style2" style="display:<%=displayed%>">New Interest Rate</a></td>
		<th>&nbsp;</th>
	</tr>
<%
	List<InterestDetailEntity> ids = av.getInterestDetails();
	ids.add(av.newInterestDetail());
	for (int j = 0; j < ids.size(); j++) {
		InterestDetailEntity id = ids.get(j); 
%>	
	<input type="hidden" name="interest_detail_id_<%=no%>"  id="interest_detail_id_<%=no%>"  value="<%=id.getIdLong()%>">		
    <tr id="<%=id.isNull()?"interest":""%>" style="display:<%=id.isNull()?"none":""%>">
		<td><%=Html.datePicker("interest_settlement_date_" + no,id.settlement_date)%></td>
		<td><%=Html.datePicker("interest_maturity_date_" + no,id.maturity_date)%></td>
		<td><input type="text" name="interest_interest_rate_<%=no%>"	id="interest_interest_rate_<%=no%>"		class="style2" style="width:100%; text-align:right"  value="<%=id.interest_rate%>"></td>
		<td><input type="text" name="interest_interest_days_<%=no%>" 	id="interest_interest_days_<%=no%>"		class="style2" style="width:100%; text-align:right"  value="<%=id.interest_days%>" disabled></td>
		<td align="right"><strong><%=Numeric.numberToStr(id.interest_amount_local,_dec)%></strong>&nbsp;</td>
		<td width="60" align="center"><a href="JavaScript:save_Interest(<%=av.getIdLong()%>,<%=no%>)" class="style2" style="display:<%=displayed%>">Save</a></td>
		<td width="60" align="center"><a href="JavaScript:delete_Interest(<%=no%>)" class="style2" style="display:<%=displayed%>">Delete</a></td>
		<td>&nbsp;</td>
	</tr>
<%
		no++;
	}
%>
</table>
