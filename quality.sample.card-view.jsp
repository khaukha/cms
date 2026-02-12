<%
	SampleEntity  sample = task.getSample();		
	task.doTask(sample);	
	QualityReportEntity quality_report = sample.getQualityReport();
	SaleContractEntity contract = sample.getContract();
	String sample_color  = Action.getColor(sample.status);
	String readonly  = task.isReadOnly() ? "readonly" : "";
	String disabled  = task.isReadOnly() ? "disabled" : "";
	String displayed   = task.isReadOnly() ? "none" : "";	
	if (sc.contract_id == 0) {
		sc.contract_id = sample.contract_id;
	}
%>

<link href="../shared/style.css" rel="stylesheet" type="text/css">

<script language="javascript">
var completed_ = true;
var completed = (<%=sample.status%> == 2);
var can_update = <%=!task.isReadOnly()%>;
var grade_id = <%=sample.getGrade().getIdInt()%>;

function typeChange()
{
	setValue("contract_id",0);
	setValue("inst_id",0);
	setValue("sample_id",0);
	doPost();
}

function checkValid()
{
	var sample_type = getValue("type");
	if (sample_type == ' ' || sample_type == '') {
		alert("Please select a sample type.");
		return false;
	}	
	if (sample_type == 'A' || sample_type == 'P' || sample_type == 'S') {
		if (getValue("contract_id") == 0 && <%=sample.isNew()%>) {
			alert("Please select a Contract");
			return false;
		}
		if (getValue("inst_id") == 0 && <%=sample.isNew()%>) {
			alert("Please select a Shipping Instruction");
			return false;
		}
	}	
	/*
	if (sample_type == 'P' || sample_type == 'S') {
		if (getValue("inst_id") == 0 && <%=sample.isNew()%>) {
			alert("Please select a Shipping Instruction");
			return false;
		}
	}	
	*/
	return true;
}

function save_Sample()
{
	if (getValue("sample_id") == 0) {
		alert("Please select a Sample");
	}
	doTask(1);
}

function new_Sample()
{
	var sample_type = getValue("type");
	if (sample_type == ' ' || sample_type == '') {
		alert("Please select a sample type.");
		return;
	}	
	if (sample_type == 'A' || sample_type == 'P' || sample_type == 'S') {
		if (getValue("contract_id") == 0) {
			alert("Please select a Contract");
			return;
		}
		if (getValue("inst_id") ==  0) {
			alert("Please select a Shipping Instruction");
			return;
		}
	}	
	/*
	if (sample_type == 'P' || sample_type == 'S') {
		if (getValue("inst_id") ==  0) {
			alert("Please select a Shipping Instruction");
			return;
		}
	}	
	*/
	if (addNewListItemById("sample_id","New Sample") >= 0) {
		doPost();
	}
}

function delete_Sample()
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}

	if ( confirm("Are you sure to delete " + getSelectedText("sample_id")) ) {
		doTask(3);
	}
}

function statusClick(o)
{
	var value = o == null ? <%=sample.status%> : toInt(o.value);
	var status_label = "";
	show("response_date_row");
	switch (value) {
		case 1: hide("response_date_row"); break;
		case 2: status_label = "Approved Date"; break;
		case 3: status_label = "Rejected Date"; break;
	}
	setText("status_lablel", status_label);
}

</script>

<form id="formMain" method="POST" name="formMain" action="" onSubmit="">				
	<%@include file="posted-fields.jsp"%>  
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td><img src="images/samples.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>		  
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD">
		<th width="120">Type</th>
		<th width="150">Shipping Ref.</th>
		<th>&nbsp;</th>
	</tr>
	<tr valign="top">
		<td>
			<select name="type" size=8 class="style11" id="type" style="width:120" onChange="typeChange()"><%=Html.selectOptions(dao.getSampleTypeDao().selectAll(),sc.type,"All")%></select>
			<div align="center" style="background-color:#DDDDDD; font-weight:bold">Sales Ref.</div>
			<select name="contract_id" id="contract_id" size="18" class="style11" style="width:100%;" onChange="setValue('sample_id',0);doPost();"><%=Html.selectOptionsX(task.getContractList(),sc.contract_id,"All")%></select>
		</td>
		<td>
			<select name="inst_id" id="inst_id" size="8" class="style11" style="width:150" onChange="setValue('sample_id',0);doPost();"><%=Html.selectOptionsX(dao.getShippingDao().getByContractId(sc.contract_id),sc.inst_id,"Select SI Ref.")%></select>
			<div align="center" style="background-color:#DDDDDD; font-weight:bold">Sample Ref.</div>			
			<select name="sample_id" size=18 class="style11" id="sample_id" style="width:150;" onChange="doPost()"><%=Html.selectOptionsX(dao.getSampleDao().list(), sample.getIdLong(), "Select Sample Ref.")%></select>
			<div style="display:<%=displayed%>"><img src="../shared/images/new.gif" border="0" width="15" height="15" onClick="new_Sample()">&nbsp;<img src="../shared/images/delete.gif" width="15" height="15" border="0" onClick="delete_Sample()"></div>			  
		</td>
		<td><div style="border-style:solid; border-width:1; border-bottom:none; border-right:none; width:100%">
					    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
                          <tr>
                            <td width="120" align="right">Sample Ref &nbsp;</td>
                            <td width="150" style="color:<%=sample_color%>"><strong><%=sample.getRefNumber()%></strong></td>
                      		<td width="120" align="right">Client &nbsp;</td>
                      		<td><select name="client_id" id="client_id" class="style2" style="width:100%;"><%=Html.selectOptions(dao.getCompanyDao().getBuyers(),sample.client_id,"")%></select></td>
                          </tr>
                          <tr>
							<td align="right">Date &nbsp;</td>
                      		<td><%=Html.datePicker("date",sample.date)%></td>
                      		<td align="right">Quality &nbsp;</td>
                      		<td><strong><%=sample.getGrade().getQuality().short_name%></strong></td>
                          </tr>
                          <tr>
                            <td align="right">Contract Ref. &nbsp;</td>
                      		<td><a href="JavaScript:toPage('trade.sales.jsp')"><strong><%=sample.getContract().getRefNumber()%></strong></a></td>
                            <td align="right">Grade &nbsp;</td>
                            <td><select name="grade_id" id="grade_id" class="style2" style="width:100%;" onChange="" <%=disabled%>><%=Html.selectOptions(dao.getGradeDao().selectAll(),sample.grade_id,"")%></select></td>
                          </tr>
                          <tr>
                            <td align="right">Shipping Ref. &nbsp;</td>
                      		<td><a href="JavaScript:toPage('traffic.si.jsp')"><strong><%=sample.getShipping().getRefNumber()%></strong></a></td>
                      		<td align="right">Packing &nbsp;</td>
                      		<td><strong><%=Numeric.numberToStr(contract.no_of_bags,0)%>&nbsp;<%=contract.getPacking().short_name%>s</strong></td>
                          </tr>
                          <tr>
                            <td align="right">Bill No &nbsp;</td>
                            <td><input type="text" name="bill_no" id="bill_no" class="style2" style="width:100%;" value="<%=sample.bill_no%>"></td>
                            <td align="right">Shipping Period &nbsp;</td>
                            <td><strong>From&nbsp;<%=DateTime.dateToStr(contract.first_date)%>&nbsp;to&nbsp;<%=DateTime.dateToStr(contract.last_date)%></strong></td>
                          </tr>
                          <tr>
                            <td align="right">Sample Weight &nbsp;</td>
                            <td><input type="text" name="sample_weight" id="sample_weight" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(sample.sample_weight,0)%>">&nbsp;Grams</td>
                            <td align="right">Attention &nbsp;</td>
                            <td><input type="text" name="attention" id="attention" class="style2" style="width:50%;" value="<%=sample.attention%>"></td>
                          </tr>
                          <tr>
							<td align="right">Description &nbsp;</td>
                      		<td colspan="3"><textarea name="description" rows="4" class="style2" id="description" style="width:100%" <%=readonly%>><%=sample.description%></textarea></td>
                          </tr>
                        </table>
				</div>
<%@include file="quality.qr.input.jsp"%>
<div style="border:thin; border-style:solid; border-width:1; border-top:none; border-right:none; width:100%; display:">
				<table width="100%" border="0" cellpadding="0" cellspacing="1" class="style2">                
                <tr>
                  <td align="right" width="120">Inspector&nbsp;</td>
                  <td colspan="3"><select name="inspector_id" id="inspector_id" class="style2" style="width:250px;" <%=disabled%>><%=Html.selectOptions(dao.getContactPersonDao().selectAll(list_all),quality_report.inspector_id,"")%></select></td>
                </tr>
                <tr>
                  <td align="right">Remarks &nbsp;</td>
                  <td colspan="3"><textarea name="remark" rows="4" class="style2" id="remark" style="width:100%" <%=readonly%>><%=sample.remark%></textarea></td>
                </tr>
<%  if (sample.type == 'A') {%>				
                <tr>
                  <td align="right">Status &nbsp;</td>
                  <td width="">	
				  	<input name="status" id="status" type="radio" value="1" <%=sample.status==1?"checked":""%> onclick="statusClick(this)" /> Pending &nbsp; &nbsp;
				  	<input name="status" id="status" type="radio" value="2" <%=sample.status==2?"checked":""%> onclick="statusClick(this)" /> Approved &nbsp; &nbsp;
				  	<input name="status" id="status" type="radio" value="3" <%=sample.status==3?"checked":""%> onclick="statusClick(this)" /> Rejected
				  </td>
                  <td  colspan="2" align="right"><%=sample.getUser().full_name%> &nbsp;</td>
                </tr>
                <tr id="response_date_row">
                  <td align="right"><label id="status_lablel">Response Date</label> &nbsp;</td>
                  <td colspan="3"><%=Html.datePicker("response_date",sample.response_date)%></td>
                </tr>
<%	} else { %>				  
                <tr>
                  <td align="right">Status &nbsp;</td>
				  <td><%=Html.checkBox("status",sample.status)%></td>
                  <td  colspan="2" align="right"><%=sample.getUser().full_name%> &nbsp;</td>
                </tr>
<%	} %>
              </table>
                </div>			
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td><img id="update_btn" src="../shared/images/update.gif" onClick="save_Sample()" style="display:<%=displayed%>"></td>
						<td align="right"><img src="../shared/images/print.jpg" onClick="doTask(2)"></td>
						<td align="right" width="60"><img src="../shared/images/listview.jpg" onClick="setValue('view',0);doPost();"></td>
				</tr>
				</table>
		</td>
	</tr>
</table>
</form>

<script language="javascript">
	statusClick();
	var type = getValue("type");

	if (!can_update) 
	{
		hide("update_btn");
    }
	getObj("formMain","<%=task.getLinkPage()%>");

	if (<%=sample.isNew()%>) {	
		var idx = addNewListItem(document.formMain.sample_id,"<%=sample.getRefNumber()%>");
	}

	getObj("main_window").width = "1000";


</script>

