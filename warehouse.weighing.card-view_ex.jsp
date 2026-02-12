<%	
	WeighingExport weighing = task.getWeighingExport();
	wn = weighing.doTask();

	if (wn.getIdLong() != 0) {
		//sc.filter_status = 0;
		//sc.inst_id = wn.inst_id;
	}
		
	WnExportEntity wne = (WnExportEntity)wn;
	QualityReportEntity qr = wne.getQualityReport();
	
	wnr = weighing.doCheckingWnr(wne);
	//auto_weighing = false;
	sc.contract_id = 0;
    sc.stuffing_date_from = null;
    sc.stuffing_date_to = null;

%>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style11">
      <tr>
        <td id="wn_" valign="top" width="140px"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
          <tr>
            <th bgcolor="#EEEEEE" align="center">WN Ref</th>
          </tr>
          <tr>
            <td><select name="wn_id" size=16 class="style11" id="wn_id" style="width:140px;" onChange="doPost();"><%=Html.selectOptionsX(dao.getWnExportDao().list(true),sc.wn_id,"Select WN")%></select></td>
          </tr>
          <tr>
            <td>
				<img id="new_btn" src="images/new.gif" border="0" onClick="new_WN()" style="display:<%=displayed%>">
				<img id="del_btn" src="images/delete.gif" border="0" onClick="delete_WN()" style="display:<%=displayed%>">&nbsp;
			</td>
          </tr>
        </table></td>
        <td valign="top"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#EEEEEE">
                <th width="100px">Type</th>
                <th width="100px">Status</th>
                <th width="150px"><input name="search_inst" id="search_inst" type="text"  class="style11" style="width:150;" value="<%=search_inst%>" onKeyUp="doSearch1(event)"></th>
                <th>Grade</th>
                <th width="150px">Buyer</th>
                <th width="150px">Date</th>
              </tr>
              <tr>
                <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
                <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
                <td><select name="inst_id" id="inst_id" size=7 class="style11" style="width:100%;" onchange="setValue('wn_id',0);itemSelected(this);"><%=Html.selectOptionsX(weighing.getInstList(),sc.inst_id,"All")%></select></td>
                <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnExportDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
                <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
                <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(weighing.selectDateFilter(),sc.filter_date,"All")%></select></td>
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
                            <td width="42%" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                              <tr>
                                <td width="150px" align="right">WN Ref &nbsp;</td>
                                <td style="color:<%=Action.getColor(wn.status)%>"><strong><%=wn.getRefNumber()%></strong>&nbsp;&nbsp;<%=DateTime.dateToStr(wn.date)%></td>
                              </tr>
                              <tr>
		                        <td align="right">Shipping Ref &nbsp;</td>
        		                <td><a href="javascript:doLink('traffic.si.jsp')"><strong><%=wn.getInstruction().getRefNumber()%></strong></a></td>
                              </tr>
                              <tr id="wn_export_1" style="display:">
                                <td align="right">Dropp-off Container No &nbsp;</td>
                                <td><input name="container_no" id="container_no" type="text"  class="style2" style="width:150px;" value="<%=wne.container_no%>" onblur="toUpper(this);"></td>
                              </tr>
                              <tr id="wn_export_2" style="display:">
                                <td align="right">Seal No &nbsp;</td>
                                <td><input name="seal_no" id="seal_no" type="text"  class="style2" style="width:150px;" value="<%=wne.seal_no%>" onblur="toUpper(this);"></td>
                              </tr>
                            </table></td>
                            <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
                              <tr style="display:">
		                        <td width="150" align="right">Buyer &nbsp;</td>
        		                <td><strong><%=wne.getShipping().getContract().getBuyer().short_name%></strong></td>
                              </tr>
                              <tr>
		                        <td align="right">Grade &nbsp;</td>
        		                <td><strong><%=wne.getGrade().short_name%></strong></td>
                              </tr>
                              <tr>
                                <td align="right">Export Container No &nbsp;</td>
                                <td><input name="export_container_no" id="export_container_no" type="text"  class="style2" style="width:150px;" value="<%=wne.export_container_no%>" onblur="toUpper(this);"></td>
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
                    <th scope="col" width="150" id="pallet_id_">WNR ID</th>
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
                    <td><input name="pallet_id" id="pallet_id" type="text"  autocomplete="off" onKeyUp="if (<%=(wn.getIdLong() > 0)%>)checkPallet(this);" class="style2" style="width:150px; text-align:center; font-weight:bold" <%=task.isReadOnly()?"disabled":""%>></td>
                    <td align="center"><%=Html.checkBox("show_wnr",requester.getBoolean("show_wnr",true),"show_WNR(this)")%></td>
                    <td align="center"><%=Html.checkBox("print_wnr",requester.getBoolean("print_wnr",true))%></td>
					<td id="msg__" style="font-weight:bold; color:#0000FF; font-size:14px"><label id="msg_1"></label>&nbsp;&nbsp;<label id="msg_2" style="color:#FF0000">&nbsp;</label></td>
                  </tr>
                </table></td>
                  </tr>
                  <tr>
                    <td><%@include file="warehouse.weighing.card-view.wnr-ex.jsp"%></td>
                  </tr>
                  <tr>
                    <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                  <tr>
                    <td width="150px" align="right">Completed &nbsp;</td>
                    <td width="24px"><%=Html.checkBox("status", wne.status)%></td>
					<td width="94"><%=Html.datePicker("date", wne.date, "style11")%></td>
                    <td align="right" style="display:">Updated By <%=wne.getUser().user_name%> &nbsp;</td>
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
				<td width="100px" align="right">&nbsp;</td>
				<td width="100px" align="right" style="display:none"><a href="JavaScript:doTask(5)" class="style2">Print WN Detail</a></td>
                <td align="right" width="65px"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost()"></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>

