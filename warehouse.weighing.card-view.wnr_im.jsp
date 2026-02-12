<script language="javascript">
function new_WNR(no)
{
	if (getValue("wn_id") == 0) {
		alert("Please select a weight note.");
		return;
	}
	show('_new_wnr_');
	var o = getObj("wnr_gross_weight_" + no);
	o.focus();
	o.select();
}

function splitWnr(wnr_id)
{
	if (!can_update) {
		//alert("You do not have permisstion to modify the data.");
		return;
	}	
	var url = "warehouse.allocation.split-wnr.jsp?uid=<%=user.getuid()%>&wnr_id=" + wnr_id + "&status=4";
	//alert(url);
	window.open(url,'','width=840, height=400');
}

var count = 0;
function save_WNR(i)
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}
	var gw = toFloat(getValue("wnr_gross_weight_" + i));
	if (gw <= 0) {
		alert("Invalid Gross Weight.");
		return;
	}
	if (count > 0) return;
	count++; 
	setValue("no", i);
	doTask(2);
	count--;
}

function delete_WNR(i)
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}
	if (<%=wn.isCompleted()%>) {
		alert("Completed Weight Note can not be modified.");
		return;
	}
	if (getValue("wnr_id_"   + i) == -1) {
		setValue("wnr_id_"   + i, 0);
		hide("wnr_" + i);
		return;
	} 
	if (confirm("Delete " + getValue("wnr_ref_number_" + i) + "?")) {
		setValue("no", i);
		doTask(4);
	}
}

</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
  <tr bgcolor="#DDDDDD">
    <th width="24"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()" /></th>
    <th width="120">WNR Ref</th>
    <th width="94">Date</th>
    <th width="100">Packing</th>
    <th width="50">Num</th>
    <th width="50">Bags<br />(Kgs)</th>
    <th width="50">Husks<br />(Kgs)</th>
    <th width="60">Gross<br />(Kgs)</th>
    <th width="50">Tare<br />(Kgs)</th>
    <th width="60">Net<br />(Kgs)</th>
    <th width="40">&nbsp;</th>
    <th width="40">&nbsp;</th>
    <th>Allocation Ref</th>
  </tr>
  <%
	wnr = dao.getWnrDao().newEntity((WnImXpEntity)wn);
	List pk_list = dao.getPackingDao().selectAll();
	List<WnrEntity> wnrs = wn.getWnrs();
	wnr = dao.getWnrDao().newEntity((WnImXpEntity)wn);
	wnr.setNew();
	wnr.packing_id = wn.packing_id;
	if (wn instanceof WnImportEntity) {
		if (!wn.isEmpty()) wnr.date = wn.date;
		wnr.no_of_bags = 6;
		if (wnr.packing_id == 0) wnr.packing_id = 4;
	}
	wnrs.add(wnr);
	int no = 1;
	double sum_stock_weight = 0;
	WnrEntity sum = dao.getWnrDao().newEntity();
	for (int i = 0; i < wnrs.size(); i++) {
		WnrEntity wne = wnrs.get(i);
		if (!wne.isNull()) {
			sum.add(wne);
		}
		WnrAllocationEntity wnra = wne.getWnrAllocation(); 
		InstructionEntity instr = wnra.getInstruction();
		double stock_weight = wnra.isNull() ? wne.net_weight : 0; 
		sum_stock_weight += stock_weight;
		boolean new_wnr = wne.isNull(); 
		String split_wnr = wne.hasChildren()?"splitWnr(" + wne.getIdLong() + ")" : "";
%>
  <input type="hidden" name="wnr_id_<%=no%>" id="wnr_id_<%=no%>"        value="<%=wne.getIdLong()%>" />
  <input type="hidden" name="pallet_id_<%=no%>"  id="pallet_id_<%=no%>" value="<%=wne.pallet_id%>" />
  <tr id="<%=wne.isNull()?"_new_wnr_":""%>" onclick="highlightOn(this);" style="display:<%=wne.isNull()?"none":""%>" title="<%=wne.isNew()?"New WNR":""%>">
    <td align="right" bgcolor="#DDDDDD" style="cursor:pointer" onDblClick="<%=split_wnr%>"><strong><%=wne.getIdLong()>0?""+no:"+"%></strong>&nbsp;</td>
    <td><input type="text" name="wnr_ref_number_<%=no%>" id="wnr_ref_number_<%=no%>" class="style11" style="width:120;" value="<%=wne.getRefNumber()%>" readonly /></td>
    <td align="center"><%=Html.datePicker("wnr_date_" + no,wne.date, "style11")%></td>
    <td><select name="wnr_packing_id_<%=no%>" id="wnr_packing_id_<%=no%>" class="style11" style="width:100;" onchange="changePacking()"><%=Html.selectOptions(pk_list,wne.packing_id,"")%></select></td>
    <td align="center"><input type="text" name="wnr_no_of_bags_<%=no%>"   id="wnr_no_of_bags_<%=no%>"   class="style11" style="width:50; text-align:right" value="<%=wne.no_of_bags%>"   /></td>
    <td align="center"><input type="text" name="wnr_bags_weight_<%=no%>"   id="wnr_bags_weight_<%=no%>"   class="style11" style="width:50; text-align:right" value="<%=wne.bags_weight%>" disabled /></td>
    <td align="center"><input type="text" name="wnr_tare_balance_<%=no%>"  id="wnr_tare_balance_<%=no%>"  class="style11" style="width:50; text-align:right" value="<%=wne.tare_balance%>" disabled /></td>
    <td align="center"><input type="text" name="wnr_gross_weight_<%=no%>" id="wnr_gross_weight_<%=no%>" class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wne.gross_weight,1)%>" <%=can_modify%> /></td>
    <td align="center"><input type="text" name="wnr_tare_weight_<%=no%>"  id="wnr_tare_weight_<%=no%>"  class="style11" style="width:50; text-align:right" value="<%=Numeric.numberToStr(wne.tare_weight,2)%>" disabled  /></td>
    <td align="center"><input type="text" name="wnr_net_weight_<%=no%>"   id="wnr_net_weight_<%=no%>"   class="style11" style="width:60; text-align:right" value="<%=Numeric.numberToStr(wne.net_weight,1)%>" disabled  /></td>
    <td align="center"><a href="JavaScript:save_WNR(<%=no%>)" class="style11" style="display:<%=displayed%>">Save</a></td>
    <td align="center"><a href="JavaScript:delete_WNR(<%=no%>)" class="style11" style="display:<%=displayed%>">Delete</a></td>
    <td>&nbsp;<%=instr.getRefNumber()%></td>
  </tr>
  <%
		no++;
	}
	if (wn.getIdLong() > 0 && wn.net_weight != sum.net_weight) {
		wn.net_weight = sum.net_weight;
		wn.update();
	}
%>
  <tr bgcolor="#DDDDDD">
    <td align="center"><img src="../shared/images/new.gif" title="New WN" onClick="new_WNR(<%=no-1%>)" style="display:<%=displayed%>"></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
    <td align="right"><strong>Total</strong> &nbsp;</td>
    <td align="right"><strong><%=Numeric.numberToStr(wni.no_of_bags,0)%></strong>&nbsp;</td>
    <td align="right"><input type="text" name="bags_weight"   id="bags_weight"   class="style11" style="width:50; text-align:right" value="<%=Numeric.numberToStr(wni.bags_weight,1)%>"  /></td>
    <td align="right"><input type="text" name="tare_balance"  id="tare_balance"  class="style11" style="width:50; text-align:right" value="<%=Numeric.numberToStr(wni.tare_balance,1)%>" /></td>
    <td align="right"><strong><%=Numeric.numberToStr(wni.gross_weight,1)%></strong>&nbsp;</td>
    <td align="right"><strong><%=Numeric.numberToStr(wni.tare_weight,2)%></strong>&nbsp;</td>
    <td align="right"><strong><%=Numeric.numberToStr(wni.net_weight,1)%></strong>&nbsp;</td>
    <td align="center"><a href="JavaScript:save_WN()" class="style11" style="display:<%=displayed%>">Save</a></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
  </tr>
</table>
