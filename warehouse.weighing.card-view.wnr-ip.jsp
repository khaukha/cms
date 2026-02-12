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
					<th width="60">WL<br>(Kgs)</th>
                    <th width="54">Checked</th>
                    <th>&nbsp;</th>
                  </tr>
<%
	WnrAllocationEntity sum = dao.getWnrAllocationDao().newEntity();
	List<WnrAllocationEntity> wnas = wni.getWnrAllocations();
	int no = 1;
	List pk_list = dao.getPackingDao().selectAll();
	for (int i = 0; i < wnas.size(); i++) {
		WnrAllocationEntity wna = wnas.get(i);
		if (DateTime.isNull(wni.date)) {
			if (wna.isCompleted()) {
				wni.date = wna.date_out;
				wni.update();
			}
		}
		WnrEntity wne = wna.getWnr();
		sum.add(wna);
		String wnr_color = Action.getColor(wna.status);
		long id = wna.getIdLong();
%>				  
		  <input type="hidden" name="wnr_id_<%=no%>" id="wnr_id_<%=no%>"        value="<%=id%>">
		  <input type="hidden" name="pallet_id_<%=no%>"  id="pallet_id_<%=no%>" value="<%=wne.pallet_id%>">
                  <tr id="wnr_<%=no%>" class="style11" onClick="highlightOn(this);">
                    <td align="center" bgcolor="#EEEEEE" style="cursor:pointer" onClick="checkSplittedWnr(<%=no%>)"><strong><%=no%></strong></td>
                    <td><input type="text" name="wnr_ref_number_<%=no%>" id="wnr_ref_number_<%=no%>" class="style11" style="width:120px; color:<%=wnr_color%>" value="<%=wne.getRefNumber()%>" readonly></td>
                    <td align="center"><input type="text" name="wnr_date_in_<%=no%>" id="wnr_date_in_<%=no%>" class="style11" style="width:60px; text-align:center" value="<%=DateTime.dateToStr(wne.date)%>" readonly></td>
                    <td align="center"><input type="text" name="wnr_date_out_<%=no%>" id="wnr_date_out_<%=no%>" class="style11" style="width:60px; text-align:center" value="<%=DateTime.dateToStr(wna.date_out)%>"></td>
                    <td><select name="wnr_packing_id_<%=no%>" id="wnr_packing_id_<%=no%>" class="style11" style="width:100%;" onChange="changePacking()" <%=disabled%>><%=Html.selectOptions(pk_list,wne.packing_id,"")%></select></td>
                    <td align="center"><input type="text" name="wnr_no_of_bags_<%=no%>"   id="wnr_no_of_bags_<%=no%>"   class="style11" style="width:50px; text-align:right" value="<%=wne.no_of_bags%>"     onChange="no_of_bags_Changed('wnr',<%=no%>,this.value)"></td>
                    <td align="center"><input type="text" name="wnr_bags_weight_<%=no%>"   id="wnr_bags_weight_<%=no%>"   class="style11" style="width:60px; text-align:right" value="<%=wne.bags_weight%>" readonly></td>
                    <td align="center"><input type="text" name="wnr_pallet_weight_<%=no%>" id="wnr_pallet_weight_<%=no%>" class="style11" style="width:60px; text-align:right" value="<%=wne.pallet_weight%>" readonly></td>
                    <td align="center"><input type="text" name="wnr_gross_weight_<%=no%>" id="wnr_gross_weight_<%=no%>" class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.gross_weight,1)%>" onChange="gross_Changed('wnr',<%=no%>,this.value)" readonly></td>
                    <td align="center"><input type="text" name="wnr_tare_weight_<%=no%>"  id="wnr_tare_weight_<%=no%>"  class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.tare_weight,2)%>"  onChange="tare_Changed('wnr',<%=no%>,this.value)" readonly></td>
                    <td align="center"><input type="text" name="wnr_net_weight_<%=no%>"   id="wnr_net_weight_<%=no%>"   class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wne.net_weight,1)%>"   readonly></td>
					<td align="center"><input type="text" name="wnr_weight_loss_<%=no%>"  id="wnr_weight_loss_<%=no%>"   class="style11" style="width:60px; text-align:right" value="<%=Numeric.numberToStr(wna.getWeightLoss(),1)%>" readonly></td>
                    <td align="center"><input type="checkbox" name="checked_<%=no%>" id="checked_<%=no%>" value="2" border="0" <%=wna.isCompleted()?"checked":""%> onClick="pass_RW(this,<%=no%>)" <%=task.isReadOnly()||done?"disabled":""%>></td>
                    <td align="center">&nbsp;</td>
                  </tr>
<%
		no++;
	}
	String color = "";
	if (wn.getIdLong() > 0) {
		if (wni.weight_loss != sum.weight_loss) {
			wni.weight_loss = sum.weight_loss;
			wni.update();
			color = "#0000FF";
		}
	}
%>				  
				  
                  <tr class="style11" bgcolor="#EEEEEE">
                    <td align="center"><img src="../shared/images/new.gif" width="15" height="15" title="Add New WNR" onClick="new_WNR(<%=no%>)" style="display:none"></td>
                    <td align="center" style="color:<%=color%>">Total</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().no_of_bags,0)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().bags_weight,1)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().pallet_weight,1)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().gross_weight,1)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().tare_weight,2)%></strong></td>
                    <td align="right"><strong><%=Numeric.numberToStr(sum.getWnr().net_weight,1)%></strong></td>
					<td align="right"><strong><%=Numeric.numberToStr(sum.weight_loss,1)%></strong></td>
                    <td align="center"><%=Numeric.numberToStr(sum.getWnr().net_weight-sum.weight_loss,1)%></td>
                    <td align="center">&nbsp;</td>
                  </tr>
                </table>

				
