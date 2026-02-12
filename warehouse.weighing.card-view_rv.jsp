<%	
	WeighingReceiving weighing = task.getWeighingReceiving();	
	wn = weighing.doTask();

	QualityReportEntity qr = wn.getQualityReport();

	WnReceivingEntity wnrc = (WnReceivingEntity)wn;

	wnr = weighing.doWeighingWnr(wnrc);

	TruckingEntity tr = wnrc.getTrucking();

	if (wn.warehouse_id == 0) wn.warehouse_id = tr.destination_id;
	//auto_weighing = false;
%>


<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td id="wn_" valign="top" width="140px"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr>
            <th bgcolor="#EEEEEE" align="center">WN Ref</th>
          </tr>
          <tr>
            <td><select name="wn_id" size=16 class="style11" id="wn_id" style="width:140px;" onChange="doPost();"><%=Html.selectOptionsX(dao.getWnReceivingDao().list(true),sc.wn_id,"Select WN")%></select></td>
          </tr>
          <tr>
            <td>
				<img id="new_btn" src="images/new.gif" border="0" width="15" height="15" onClick="new_WN()" style="display:<%=displayed%>">
				<img id="del_btn" src="images/delete.gif" width="15" height="15" border="0" onClick="delete_WN()" style="display:<%=displayed%>">&nbsp;
			</td>
          </tr>
        </table></td>
        <td valign="top"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#EEEEEE">
                <th width="100px">Type</th>
                <th width="100px">Status</th>
                <th width="135px"><input name="search_inst" id="search_inst" type="text"  class="style11" style="width:135;" value="<%=search_inst%>" onKeyUp="doSearch1(event)"></th>
                <th width="150px">From</th>
                <th width="150px">To</th>
                <th>Grade</th>
                <th width="90px">Date</th>
              </tr>
              <tr>
                <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
                <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
                <td><select name="inst_id" id="inst_id" size=7 class="style11" style="width:100%;" onChange="setValue('wn_id',0);itemSelected(this);"><%=Html.selectOptionsX(weighing.getInstList(),sc.inst_id,"All")%></select></td>
                <td><select name="filter_source_id" id="filter_source_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_source_id,"All")%></select></td>
	            <td><select name="filter_destination_id" id="filter_destination_id" size="7" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_destination_id,"All")%></select></td>
                <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnReceivingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
                <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><option selected>All</option><%//=Html.selectOptions(weighing.selectDateFilter(),sc.filter_date,"All")%></select></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%"  border="1" cellpadding="0" cellspacing="0" class="style2">
              <tr>
                <td><table id="main_frame_" width="100%"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="42%" valign="top"><table width="100%"  border="0" cellpadding="1" cellspacing="0" class="style2">
                              <tr>
                                <td width="130px" align="right">WN Ref &nbsp;</td>
                                <td style="color:<%=Action.getColor(wn.status)%>"><strong><%=wn.getRefNumber()%></strong>&nbsp;&nbsp;(<%=wn.getIdLong()%>)</td>
                              </tr>
                              <tr>
		                        <td align="right">Date &nbsp;</td>
        		                <td><%=Html.datePicker("wn_date", wn.date, "","disable")%></td>
                              </tr>
                              <tr>
                                <td align="right">Truck No &nbsp;</td>
                                <td><strong><%=tr.truck_no%></strong></td>
                              </tr>
                              <tr style="display:none">
                                <td align="right">Covered Bags &nbsp;</td>
                                <td><input name="tare_balance" id="tare_balance" type="text"  class="style2" style="width:80px; text-align:right" value="">
                                &nbsp;Kgs</td>
                              </tr>
                            </table></td>
                            <td valign="top"><table width="100%"  border="0" cellpadding="1" cellspacing="0" class="style2">
                              <tr>
		                        <td width="150" align="right">Trucking Ref &nbsp;</td>
        		                <td><a href="javascript:doLink('traffic.trucking.jsp')"><strong><%=tr.getRefNumber()%></strong></a></td>
                              </tr>
                              <tr>
		                        <td align="right">Grade &nbsp;</td>
        		                <td><select name="grade_id" id="grade_id" class="style11" style="width:100%;" onChange=""><%=Html.selectOptions(dao.getGradeDao().getByQuality(wn.getInstruction().getGrade().quality_id),wn.grade_id,"")%></select></td>
                              </tr>
                              <tr id="area_" style="display:">
                                <td align="right">Area &nbsp;</td>
                                <td><select name="area_id" id="area_id" class="style2" style="width:110;"><%=Html.selectOptions(dao.getAreaDao().getByWarehouseId(wn.warehouse_id), wn.area_id, "")%></select>&nbsp;&nbsp;<%=wn.getWarehouse().short_name%></td>
                              </tr>
                              
                            </table></td>
                          </tr>
</table></td>
                  </tr>
                  <tr style="display:none">
                    <td><table  width="100%" border="0" cellpadding="1" cellspacing="1" class="style2">
                  <tr align="center" bgcolor="#EBEADB">
                    <th scope="col" width="80">Scale No</th>
                    <th scope="col" width="80" style="display:<%=auto_weighing?"none":""%>">Gross</th>
                    <th scope="col" width="120px">Packing</th>
                    <th scope="col" width="80">No Of Bags</th>
                    <th scope="col" width="60" style="display:<%="none"%>">Tare Bal.</th>
                    <th scope="col" width="150" id="pallet_id_">Pallet ID</th>
                    <th scope="col" width="40">Show</th>
                    <th scope="col" width="40" align="center">Print </th>
                    <th scope="col" align="left" id="msg_" style="font-weight:bold; color:#0000FF; font-size:15px">&nbsp;</th>
                  </tr>
                  <tr>
                    <td><select name="scale_id" id="scale_id" class="style2" style="width:80px;" onChange="setFocus('pallet_id');"><%if (!task.isReweigh() || !auto_weighing) {%><option value="0" selected></option><%}%><%=Html.selectOptions(scales,sc.scale_id)%></select></td>
                    <td style="display:<%=auto_weighing?"none":""%>"><input name="value" id="value" type="text"  autocomplete="off" class="style2" style="width:80px; text-align:center; font-weight:bold"></td>
                    <td><%@include file="wnr-packing.jsp"%></td>
                    <td><input name="wnr_no_of_bags" id="wnr_no_of_bags" type="text" value="<%=requester.getInt("wnr_no_of_bags")%>" class="style2" style="width:80px; text-align:right; font-weight:bold"></td>
					<td style="display:<%="none"%>"><input name="wnr_tare_balance" id="wnr_tare_balance" type="text"  class="style2" style="width:60px; text-align:right" value="<%=requester.getDouble("wnr_tare_balance")%>"></td>					
                    <td><input name="pallet_id" id="pallet_id" type="text"  autocomplete="off" onKeyUp="if (<%=(wn.getIdLong() > 0)%>)checkPallet(this);" class="style2" style="width:150px; text-align:center; font-weight:bold"></td>
                    <td align="center"><%=Html.checkBox("show_wnr",requester.getBoolean("show_wnr",true),"show_WNR(this)")%></td>
                    <td align="center"><%=Html.checkBox("print_wnr",requester.getBoolean("print_wnr",true))%></td>
					<td id="msg__" style="font-weight:bold; color:#0000FF; font-size:14px"><label id="msg_1"></label>&nbsp;&nbsp;<label id="msg_2" style="color:#FF0000">&nbsp;</label></td>
                  </tr>
                </table></td>
                  </tr>
                  <tr>
                    <td><%@include file="warehouse.weighing.card-view.wnr-rv.jsp"%></td>
                  </tr>
                  <tr>
                    <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
                  <tr>
                    <td width="150px" align="right">Completed &nbsp;</td>
                    <td width="24px"><%=Html.checkBox("status", wn.status)%></td>
                    <td align="right">Created By <%=wn.getUser().user_name%> &nbsp;</td>
                  </tr>
                </table></td>
                  </tr>
                </table></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="30px"><img id="save_btn_" src="../shared/images/update.gif" onClick="save_WN()" style="display:<%=displayed%>"></td>
				<td>&nbsp;</td>
				<td width="100px" align="right"><a href="JavaScript:doTask(5)" class="style2">Print WN Detail</a></td>
                <td align="right" width="65px"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost()"></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>
