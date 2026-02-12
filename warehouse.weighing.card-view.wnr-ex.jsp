<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                  <tr bgcolor="#EEEEEE">
                    <th width="24"><img src="../shared/images/refresh.gif" style="cursor:pointer" onClick="doPost()"></th>
                    <th width="120">WNR Ref</th>
                    <th width="60">Date<br />In</th>
                    <th width="60">Date<br />Out</th>
                    <th width="120">Packing</th>
                    <th width="50">Num</th>
                    <th width="60">Bags<br>(Kgs)</th>
                    <th width="60">Pallet<br>(Kgs)</th>
                    <th width="60">Gross<br>(Kgs)</th>
                    <th width="60">Tare<br>(Kgs)</th>
                    <th width="60">Net<br>(Kgs)</th>
					<th width="54">Checked</th>
                    <th>&nbsp;</th>
                  </tr>
<%

	ShippingEntity shipping = wne.getShipping();
	double tons_per_con = shipping.getTonsPerContainer();
   	double tons_out = wne.getNetTons();//sum_wnr.getWnrAllocation().weight_out/1000;
	bal_tons = Numeric.round(wne.getPendingTons(),3);//Numeric.round(tons_per_con - tons_out,3);		
	bal_msg = " " + Numeric.round(tons_per_con,3) + " - " + Numeric.round(tons_out,3) + " = " + bal_tons + " Mts";
	if (bal_tons < 0) {
		double percent = tons_per_con > 0 ? Numeric.round(-bal_tons*100/tons_per_con,2) : 100;
		bal_msg = "Over: " + bal_msg + " (" + percent + "%)";
	} 
	
	WnrAllocationEntity sum = dao.getWnrAllocationDao().newEntity();
	List<WnrAllocationEntity> wnras = wne.getWnrAllocations();
	int no = 1;
	List pk_list = dao.getPackingDao().selectAll();
	for (int i = 0; i < wnras.size(); i++) {
		WnrAllocationEntity wnra = wnras.get(i);
		WnrEntity wnre = wnra.getWnr();
		sum.add(wnra);
		String wnr_color = wnra.status > 0 ? Action.getColor(2) : Action.getColor(1); 
		long id = wnra.getIdLong();
%>				  
		  <input type="hidden" name="wnr_id_<%=no%>" id="wnr_id_<%=no%>"        value="<%=id%>">
		  <input type="hidden" name="pallet_id_<%=no%>"  id="pallet_id_<%=no%>" value="<%=wnre.pallet_id%>">
                  <tr id="wnr_<%=no%>" class="style11" onClick="highlightOn(this);">
                    <td align="center" bgcolor="#EEEEEE" style="cursor:pointer" onClick="checkSplittedWnr(<%=no%>)"><strong><%=no%></strong></td>
                    <td><input type="text" name="wnr_ref_number_<%=no%>" id="wnr_ref_number_<%=no%>" class="style11" style="width:120px; color:<%=wnr_color%>" value="<%=wnre.getRefNumber()%>" readonly></td>
                    <td align="center"><input type="text" name="wnr_date_in_<%=no%>" id="wnr_date_in_<%=no%>" class="style11" style="width:60px; text-align:center" value="<%=DateTime.dateToStr(wnre.date)%>" readonly></td>
                    <td align="center"><input type="text" name="wnr_date_out_<%=no%>" id="wnr_date_out_<%=no%>" class="style11" style="width:60px; text-align:center" value="<%=wnra.isCompleted()?DateTime.dateToStr(wnra.date_out):""%>" ></td>
                    <td><select name="wnr_packing_id_<%=no%>" id="wnr_packing_id_<%=no%>" class="style11" style="width:100%;" onChange="changePacking()" <%=disabled%>><%=Html.selectOptions(pk_list,wnre.packing_id,"")%></select></td>
                    <td align="center"><input type="text" name="wnr_no_of_bags_<%=no%>"   id="wnr_no_of_bags_<%=no%>"   class="style11" style="width:50px; text-align:right" value="<%=wnre.no_of_bags%>"     onChange="no_of_bags_Changed('wnr',<%=no%>,this.value)"></td>
                    <td align="center"><input type="text" name="wnr_bags_weight_<%=no%>"   id="wnr_bags_weight_<%=no%>"   class="style11" style="width:60px; text-align:right" value="<%=wnre.bags_weight%>" readonly=""></td>
                    <td align="center"><input type="text" name="wnr_pallet_weight_<%=no%>" id="wnr_pallet_weight_<%=no%>" class="style11" style="width:60px; text-align:right" value="<%=wnre.pallet_weight%>" readonly=""></td>
                    <td align="center"><input type="text" name="wnr_gross_weight_<%=no%>" id="wnr_gross_weight_<%=no%>" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wnre.gross_weight,1)%>" onChange="gross_Changed('wnr',<%=no%>,this.value)" readonly></td>
                    <td align="center"><input type="text" name="wnr_tare_weight_<%=no%>"  id="wnr_tare_weight_<%=no%>"  class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wnre.tare_weight,2)%>"  onChange="tare_Changed('wnr',<%=no%>,this.value)" readonly></td>
                    <td align="center"><input type="text" name="wnr_net_weight_<%=no%>"   id="wnr_net_weight_<%=no%>"   class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wnre.net_weight,1)%>"   readonly></td>
					<td align="center"><input type="checkbox" name="checked_<%=no%>" id="checked_<%=no%>" value="2" border="0" <%=wnra.status==2?"checked":""%> onClick="pass_RW(this,<%=no%>)" <%=task.isReadOnly()?"disabled":""%>></td>
                    <td align="center">&nbsp;</td>
                  </tr>
<%
		no++;
	}
	List<WncAllocationEntity> wncas = wne.getWncAllocations();
	for (WncAllocationEntity wnca : wncas) {
		WnConsolidationEntity wnc = wnca.getWnConsolidation();
		double gross_weight = wnca.tare_out + wnca.weight_out;
		String wnr_color = Action.getColor(2);
%>
		<tr id="wnr_<%=no%>" class="style11" onClick="highlightOn(this);">
			<td align="center" bgcolor="#EEEEEE" style="cursor:pointer" onClick=""><strong><%=no%></strong></td>
            <td><input type="text" name="wnc_ref_number_<%=no%>" id="wnc_ref_number_<%=no%>" class="style11" style="width:120px; color:<%=wnr_color%>" value="<%=wnc.getRefNumber()%>" readonly></td>
            <td align="center"><input type="text" name="wnc_date_in_<%=no%>" id="wnc_date_in_<%=no%>" class="style11" style="width:60px; text-align:center" value="<%=DateTime.dateToStr(wnc.date)%>" readonly></td>
            <td align="center"><input type="text" name="wnc_date_out_<%=no%>" id="wnc_date_out_<%=no%>" class="style11" style="width:60px; text-align:center" value="<%=DateTime.dateToStr(wnca.date)%>" readonly></td>
            <td><select name="wnr_packing_id_<%=no%>" id="wnr_packing_id_<%=no%>" class="style11" style="width:100%;" onChange="changePacking()" <%=disabled%>><%=Html.selectOptions(pk_list,wnc.packing_id,"")%></select></td>
            <td align="center"><input type="text" name="wnr_no_of_bags_<%=no%>"   id="wnr_no_of_bags_<%=no%>"   class="style11" style="width:50px; text-align:right" value="<%=wnca.bags_out%>"  onChange=""></td>
                    <td align="center"><input type="text" name="wnr_bags_weight_<%=no%>"   id="wnr_bags_weight_<%=no%>"   class="style11" style="width:60px; text-align:right" value="" readonly=""></td>
                    <td align="center"><input type="text" name="wnr_pallet_weight_<%=no%>" id="wnr_pallet_weight_<%=no%>" class="style11" style="width:60px; text-align:right" value="" readonly=""></td>
                    <td align="center"><input type="text" name="wnr_gross_weight_<%=no%>" id="wnr_gross_weight_<%=no%>" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(gross_weight,1)%>" onChange="gross_Changed('wnr',<%=no%>,this.value)" readonly></td>
                    <td align="center"><input type="text" name="wnr_tare_weight_<%=no%>"  id="wnr_tare_weight_<%=no%>"  class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wnca.tare_out,2)%>"  onChange="tare_Changed('wnr',<%=no%>,this.value)" readonly></td>
                    <td align="center"><input type="text" name="wnr_net_weight_<%=no%>"   id="wnr_net_weight_<%=no%>"   class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wnca.weight_out,1)%>"   readonly></td>
					<td align="center"><input type="checkbox" name="checked_<%=no%>" id="checked_<%=no%>" value="2" border="0" checked disabled></td>
                    <td align="center">&nbsp;</td>
		</tr>
<%
		no++;
	}
	if (wn.getIdLong() > 0) {
		String msg = "";
		//if (wne.weight_loss != sum.weight_loss) {
			//wne.weight_loss = sum.weight_loss;
			//wne.update();
			//msg = "Updated";
		//}
%>				  
				  
                  <tr class="style11" bgcolor="#EEEEEE">
                    <td align="center"><img src="../shared/images/new.gif" title="Add New WNR" onClick="new_WNR(<%=no%>)" style="display:none"></td>
                    <td align="center">Total</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().no_of_bags,0)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().bags_weight,1)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().pallet_weight,1)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().gross_weight,1)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().tare_weight,2)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().net_weight,1)%></strong></td>
					<td align="center"><%=Numeric.numberToStr(sum.getWnr().net_weight-sum.weight_loss,1)%></td>
                    <td align="center">&nbsp;</td>
                  </tr>
                  <tr class="style11" bgcolor="#EEEEEE" style="font-weight:bold">
                    <td align="center">&nbsp;</td>
                    <td><%=wn.getRefNumber()%></td>
                    <td align="center"><%=DateTime.dateToStr(wn.date)%></td>
                    <td align="center"><%=DateTime.timeToStr(wn.time)%></td>
                    <td><select name="packing_id" id="packing_id" class="style11" style="width:100%;" onChange="changePacking()"><%=Html.selectOptions(pk_list,wne.packing_id,"")%></select></td>
                    <td align="right"><input type="text" name="no_of_bags" id="no_of_bags" class="style11" style="width:50px; text-align:right" value="<%=wne.no_of_bags%>"></td>
                    <td align="right"><input type="text" name="bags_weight"   id="bags_weight"   class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.getBagsWeight(),1)%>" readonly></td>
                    <td align="right"><input type="text" name="pallet_weight"  id="pallet_weight"  class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.pallet_weight,1)%>"></td>
                    <td align="right"><input type="text" name="gross_weight" id="gross_weight" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.gross_weight,1)%>" readonly></td>
                    <td align="right"><input type="text" name="tare_weight" id="tare_weight" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.tare_weight,1)%>" readonly></td>
                    <td align="right"><input type="text" name="net_weight" id="net_weight" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.net_weight,1)%>" readonly></td>
					<td align="center"><%=msg%>&nbsp;</td>
                    <td align="center">&nbsp;</td>
                  </tr>
<%
	}
%>				  
</table>
