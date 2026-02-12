<%
	CheckingInPro checking = task.getCheckingInPro();	
	WnAllocationEntity wni = checking.doTask();
	wn = wni.getWeightNote();
	InstructionEntity inst = wni.getInstruction();
	ProcessingEntity po;
	if (inst instanceof ProcessingEntity) {
		po = (ProcessingEntity)inst;
	} else {
		po = dao.getProcessingDao().newEntity();
	}
	boolean done = wni.isCompleted() && po.isCompleted();
	if (wni.getIdLong() != 0) {
		//sc.filter_status = wn.status;
		//sc.inst_id = wni.inst_id;
	}
	if (sc.search_key != null) {
		sc.search_key = sc.search_key.trim();
		if (sc.search_key.equals("")) {
			sc.search_key = null;
		}
	}
	wnr = checking.doCheckingWnr(wni);
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
            <td><select name="wn_id" size=16 class="style11" id="wn_id" style="width:140px;" onChange="doPost();"><%=Html.selectOptionsX(checking.getWnList(),sc.wn_id,"Select WN")%></select></td>
          </tr>
        </table></td>
        <td valign="top"><table width="100%"  border="0" cellspacing="1" cellpadding="0">
          <tr>
            <td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#EEEEEE">
                <th width="100px">Type</th>
                <th width="100px">Status</th>
                <th width="120px">Processing Type</th>
                <th width="135px"><input name="search_inst" id="search_inst" type="text"  class="style11" style="width:135;" value="<%=search_inst%>" onKeyUp="doSearch1(event)"></th>
                <th>Grade</th>
                </tr>
              <tr>
                <td><select name="wn_type" id="wn_type" size=7 class="style11" style="width:100%;" onChange="wnTypeChange()"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.wn_type)%></select></td>
                <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
                <td><select name="filter_type_id" size="7" id="filter_type_id" class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(dao.getProcessingTypeDao().selectAll(), sc.filter_type_id, "All")%></select></td>
                <td><select name="filter_inst_id" id="filter_inst_id" size=7 class="style11" style="width:100%;" onChange="itemSelected(this);"><%=Html.selectOptionsX(checking.getInstList(),sc.filter_inst_id,"All")%></select></td>
                <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getProcessingDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
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
                                <td width="150px" align="right">WN Ref &nbsp;</td>
                                <td style="color:<%=Action.getColor(wn.status)%>"><strong><%=wni.getWeightNote().getRefNumber()%></strong>&nbsp;&nbsp;<%=DateTime.dateToStr(wn.date)%></td>
                              </tr>
                              <tr>
		                        <td align="right">PO Ref &nbsp;</td>
        		                <td><strong><%=wni.getInstruction().getRefNumber()%></strong>&nbsp;(<%=wni.getInstruction().getIdLong()%>)</td>
                              </tr>

                            </table></td>
                            <td valign="top"><table width="100%"  border="0" cellpadding="1" cellspacing="0" class="style2">
                              <tr>
		                        <td width="150px" align="right">Quality Ref &nbsp;</td>
        		                <td style="color:<%=Action.getColor(wni.getWeightNote().getQualityReport().status)%>"><strong><%=wni.getWeightNote().getQualityReport().getRefNumber()%></strong></td>
                              </tr>
                              <tr>
		                        <td align="right">Grade &nbsp;</td>
        		                <td><strong><%=wni.getWeightNote().getGrade().short_name%></strong></td>
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
                    <th scope="col" align="left" id="msg_" style="color:#0000FF; font-size:15px">&nbsp;</th>
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
                    <td><%@include file="warehouse.weighing.card-view.wnr-ip.jsp"%></td>
                  </tr>
                  <tr>
                    <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                  <tr>
                    <td width="150px" align="right">Completed &nbsp;</td>
                    <td width="24px"><%=Html.checkBox("status", wni.status)%></td>
					<td width="94"><%=Html.datePicker("date", wni.date, "style11")%></td>
                    <td align="right" style="display:">Updated By <%=wn.getUser().user_name%> &nbsp;</td>
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
                <td width="30px"><img id="save_btn_" src="../shared/images/update.gif" onClick="save_WN()" style="display:<%=done?"none":displayed%>"></td>
				<td>&nbsp;</td>
				<td width="100px" align="right">&nbsp;</td>
                <td align="right" width="65px"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost()"></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>
<script language="javascript">
	getObj("search_key").title = "Input a number to search Processing Order.";
</script>