<%
	QualityReportEntity  quality_report = task.doTask();
	WnEntity wn = quality_report.getWeightNote();
	String qr_color  = Action.getColor(quality_report.status);
	String qr_color_ = Action.getColor(quality_report.getWeightNote().status);
	String readonly  = task.isReadOnly() ? "readonly" : "";
	String disabled  = task.isReadOnly() ? "disabled" : "";
	String displayed = task.isReadOnly() ? "none" : "";	
	sc.filter_status = 0;
	ContractEntity contract = quality_report.getContract();
	String sb_name = quality_report.type == 'E' ? contract.getBuyer().short_name : contract.getSeller().short_name;
%>

<link href="../shared/style.css" rel="stylesheet" type="text/css">

<script language="javascript">
var completed = <%=quality_report.isCompleted()%>;
var completed_ = (<%=quality_report.getWeightNote().status%> == 2);
var can_update = <%=!task.isReadOnly()%>;
var grade_id = <%=quality_report.getWeightNote().getGrade().getIdInt()%>;
</script>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="style2">
          <tr valign="top">
            <td width="150px"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
              <tr bgcolor="#EEEEEE">
                <th align="center">Type</th>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
                    <tr>
                      <td><select name="qr_type" id="qr_type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnTypeDao().selectAll(),sc.qr_type)%></select></td>
                    </tr>
                    <tr bgcolor="#EEEEEE">
                      <th height="22">Conntract/PO Ref</th>
                    </tr>
                    <tr>
                      <td><select name="inst_id" id="inst_id" size=20 class="style11" style="width:100%;" onChange="itemSelected(this);"><%=Html.selectOptionsX(task.getInstDao().getList(),sc.inst_id,"All")%></select></td>
                    </tr>
                  </table>
                  </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
            </table></td>
            <td width="130"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
              <tr bgcolor="#EEEEEE">
                <th align="center">QR Ref</th>
              </tr>
              <tr>
                <td><select name="qr_id" size=28 class="style11" id="qr_id" style="width:150px;" onChange="doPost()"><%=Html.selectOptionsX(task.getQrList(),quality_report.getIdLong(),"Select QR")%></select></td>
              </tr>
              <tr style="display:none">
                <td>
					<img src="../shared/images/new.gif" border="0" width="15" height="15" onClick="new_DSI('qr')">
					<img src="../shared/images/delete.gif" width="15" height="15" border="0" onClick="delete_DSI('qr','Quality Report')"></td>
              </tr>
            </table></td>
            <td><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
              <tr bgcolor="#EEEEEE" style="font-weight:bold">
                <td align="center">Detail</td>
              </tr>
              <tr>
                <td><div style="border-style:solid; border-width:1; border-bottom:none; border-right:none; width:100%">
					    <table width="100%" border="0" cellspacing="2" cellpadding="0" class="style2">
                          <tr>
                            <td width="120px" align="right">QR Ref &nbsp;</td>
                            <td width="150px" style="color:<%=qr_color%>"><strong><%=quality_report.getRefNumber()%></strong></td>
                      		<td width="120px" align="right">WN Ref &nbsp;</td>
                      		<td style="color:<%=qr_color_%>"><strong><%=wn.getRefNumber()%></strong></td>
                          </tr>
                          <tr>
							<td align="right">Date &nbsp;</td>
                      		<td><strong><%=DateTime.dateToStr(quality_report.date)%>  <%=DateTime.timeToStr(quality_report.time)%></strong></td>
                      		<td align="right">Grade &nbsp;</td>
                      		<td><select name="grade_id" id="grade_id" class="style2" style="width:100%;" <%=disabled%>><%=Html.selectOptions(dao.getGradeDao().selectAll(),wn.grade_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Contract/PO/TR &nbsp;</td>
                      		<td><strong><%=quality_report.getWeightNote().getInstruction().getRefNumber()%></strong></td>
                      		<td align="right">Weight &nbsp;</td>
                      		<td><strong><%=Numeric.numberToStr(quality_report.getTons()*1000,0)%></strong> Kgs</td>
                          </tr>
                          <tr>
                            <td align="right">Seller/Buyer &nbsp;</td>
                            <td><strong><%=sb_name%></strong></td>
                            <td align="right">No Of Bags &nbsp;</td>
                            <td><strong><%=Numeric.numberToStr(quality_report.getTons()*1000,0)%></strong> <%=quality_report.getWeightNote().getPacking().short_name%></td>
                          </tr>
                          <tr>
							<td align="right">Warehouse &nbsp;</td>
                      		<td><strong><%=wn.getArea().getWarehouse().short_name%></strong></td>
                            <td align="right"><label style="display:none">Plant / Station</label> &nbsp;</td>
                            <td><table width="100%" border="0" cellpadding="0" cellspacing="0" class="style2" style="display:none">
								<tr>
									<td>&nbsp;</td>
									<td>Location &nbsp;</td>
									<td>&nbsp;</td>
								</tr>
							</table></td>
                          </tr>
                        </table>
				</div></td>
              </tr>
              <tr>
                <td><%@include file="quality.qr.input.jsp"%></td>
              </tr>
              <tr>
                <td><div style="border:thin; border-style:solid; border-width:1; border-top:none; border-right:none; width:100%; padding-top:4px">
				<table width="100%" border="0" cellpadding="1" cellspacing="1" class="style2">                
                <tr>
                  <td align="right">Inspector&nbsp;</td>
                  <td colspan="3"><select name="inspector_id" id="inspector_id" class="style11" style="width:250px;" <%=disabled%>><%=Html.selectOptionsX(dao.getContactPersonDao().selectAll(list_all),quality_report.inspector_id,"")%></select></td>
                </tr>
                <tr>
                  <td align="right">Remarks &nbsp;</td>
                  <td colspan="3"><textarea name="remark" rows="4" class="style2" id="remark" style="width:100%" <%=readonly%>><%=quality_report.remark%></textarea></td>
                </tr>
                <tr>
                  <td align="right">Completed &nbsp;</td>
                  <td width="33%"><%=Html.checkBox("status",quality_report.status)%></td>
                  <td width="52%" colspan="2" align="right"><%=quality_report.getUser().full_name%> &nbsp;</td>
                </tr>
                
              </table></div></td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><img id="update_btn" src="../shared/images/update.gif" width="15" height="15" border="0" onClick="doUpdate('qr_id')" style="display:<%=displayed%>"></td>
						<td align="right"><img src="../shared/images/print.jpg" width="55" height="18" border="0" onClick="doTask(2)"></td>
						<td align="right" width="60"><img src="../shared/images/listview.jpg" width="55" height="18" border="0" onClick="setValue('view',0);doPost();"></td>
				</tr>
				</table></td>
              </tr>
            </table></td>
          </tr>
        </table></td>
	</tr>
</table>

<script language="javascript">
	var qr_type = getValue("qr_type");
	if (getValue("qr_id") == 0 || qr_type == 'E' || qr_type == 'N' || qr_type == 'C' || qr_type == 'T' || qr_type == 'M' || !can_update) 
	{
		hide("update_btn");
		setDisabled("status_");
    }
	getObj("formMain","<%=task.getLinkPage()%>");
	setCbxById("completed_");

	//if (getValue("qr_id") == 0) hide("update_btn");

	if (<%=quality_report.isNew()%>) {	
		var idx = addNewListItem(document.formMain.qr_id,"");
		//setText("ref_number_",getSelectedText("qr_id"));
	}

	getObj("main_window").width = "1000";

</script>

