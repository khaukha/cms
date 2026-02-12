<%
	//String dis = completed  ? "" : "";			
	dis = "";
%>
<script language="javascript">
function new_WNCA(i)
{
	if (<%=completed%>) {
		return;
	}
	show("wnca_" + i);
}

function save_WNCA(wne_id, no)
{
	if (<%=completed%>) {
		//return;
	}
	setValue("wn_id", wne_id);
	setValue("no", no);
	doTask(16);
}

function delete_WNCA(no)
{
	if (<%=completed%>) {
		return;
	}
	if (confirm("Are you sure to delete this item ?")) {
		setValue("no", no);
		doTask(17);
	}
}

</script>

<table width="100%" border="0" class="style2" cellspacing="1" cellpadding="0">
	<tr bgcolor="#DDDDDD">
	  <th width="30" bgcolor="#DDDDDD">Id&nbsp;</th>
		<th width="160">WN Ref.</th>
	    <th width="200" align="left">Grade</th>
	    <th width="120" align="left">Packing</th>
	    <th width="40" align="right">Bags&nbsp;</th>
	    <th width="60" align="right">Kgs&nbsp;</th>
	    <th width="40" align="right">Bags&nbsp;</th>
	    <th width="70" align="right">Kgs&nbsp;</th>
	    <th width="94" align="center">Date</th>
	    <td width="40" align="center"><a href="JavaScript:new_WNCA(<%=i%>)" <%=dis%>>Add</a></td>
	    <th width="40" align="center">&nbsp;</th>
	    <th>&nbsp;</th>
	</tr>
	<%
		WncAllocationDAO wnca_dao  = dao.getWncAllocationDao();
		WnConsolidationDAO wnc_dao = dao.getWnConsolidationDao();
		sc.filter_grade_id = 0;
		sc.filter_status = 0;
		sc.warehouse_id = 0;
		wncas.add(wnca_dao.newEntity());
		sc.filter_status = 0;
		List wnc_list = wnc_dao.list(false);
		WncAllocationEntity csum = dao.getWncAllocationDao().newEntity();
		for (int j = 0; j < wncas.size(); j++) {
			WncAllocationEntity wnca = wncas.get(j);
			int no = i*1000 + j;
			csum.add(wnca);
	%>
              <input type="hidden" name="wnca_id_<%=no%>"  id="wnca_id_<%=no%>"  value="<%=wnca.getIdLong()%>">
              <tr id="<%=wnca.isNull()?"wnca_"+i:""%>" onClick="highlightOn(this,3);" style="display:<%=wnca.isNull()?"none":""%>">
                <td align="right" bgcolor="#DDDDDD"><strong><%=wnca.getIdLong()%></strong>&nbsp;</td>
                <td><select id="wnca_wnc_id_<%=no%>" name="wnca_wnc_id_<%=no%>" class="style2" style="width:100%;" <%=dis%>><%=Html.selectOptionsX(wnc_list,wnca.wnc_id,"Select WN")%></select></td>
                <td>&nbsp;<%=wnca.getWnConsolidation().getGrade().short_name%></td>
                <td>&nbsp;<%=wnca.getWnConsolidation().getPacking().short_name%></td>
                <th align="right"><%=Numeric.numberToStr(wnca.getWnConsolidation().stock_bags,0)%>&nbsp;</th>
                <th align="right"><%=Numeric.numberToStr(wnca.getWnConsolidation().stock_weight,1)%>&nbsp;</th>
                <td><input type="text" name="wnca_bags_out_<%=no%>"   id="wnca_bags_out_<%=no%>"   class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(wnca.bags_out,0)%>" <%=dis%>></td>
                <td><input type="text" name="wnca_weight_out_<%=no%>" id="wnca_weight_out_<%=no%>" class="style2" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(wnca.weight_out,1)%>" <%=dis%>></td>
                <td><%=Html.datePicker("wnca_date_" + no, wnca.date,"style2",dis)%></td>
                <td align="center"><a href="JavaScript:save_WNCA(<%=wne_id%>,<%=no%>)" style="display:<%=displayed%>;" <%=dis%>>Save</a></td>
                <td align="center"><a href="JavaScript:delete_WNCA(<%=no%>)" style="display:<%=displayed%>" <%=dis%>>Delete</a></td>
                <td align="center">&nbsp;</td>
              </tr>
	<%
		}
	%>			  
              <tr bgcolor="#DDDDDD">
                <td align="right">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <th align="right">&nbsp;</th>
                <th align="right">&nbsp;</th>
                <td align="right"><strong><%=Numeric.numberToStr(csum.bags_out,0)%></strong>&nbsp;</td>
                <td align="right"><strong><%=Numeric.numberToStr(csum.weight_out,1)%></strong>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
              </tr>
</table>
