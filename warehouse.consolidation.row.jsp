<%
	boolean same_grade = wnc.grade_id == 0 || wnc.grade_id == wn.grade_id; 
	boolean locked = task.isReadOnly()||wnc.isLocked()||!same_grade;
%>
	<tr bgcolor="<%=bgcolor%>" onClick="highlightOn(this)">
		<td width="120" style="color:<%=color%>"><%=wn.getRefNumber()%></td>
	    <td width="120" style="color:<%=color%>"><%=wn.getInstruction().getRefNumber()%></td>
		<td width="60" align="center"><%=DateTime.dateToStr(wn.date)%></td>
		<td width="60" align="center"><%=wn.getArea().short_name%></td>
		<td width="120"><%=_wnc.getRefNumber()%></td>
		<td width=""><%=wn.getGrade().short_name%></td>
		<td width="100"><%=wn.getPacking().short_name%></td>
		<td width="50" align="right"><%=Numeric.numberToStr(wn.no_of_bags,0)%>&nbsp;</td>
		<td width="60" align="right"><%=Numeric.numberToStr(wn.net_weight/1000,4)%>&nbsp;</td>
		<td width="45" align="right"><%=Numeric.numberToStr(wn.getQualityReport().moisture,2)%>&nbsp;</td>
		<td width="20" align="center"><%=Html.checkBox("",wn.isConsolidated(), "doConsolidation(this, " + wn.getIdLong() + ")",locked?"disabled":"")%></td>
	</tr>
