
<%
	task.doTask(null);
%>
<link href="../shared/style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

function startReport()
{
	if (<%=sc.type != 'A'%>) {
		//alert("This type of report is under construction. Please try again later.");
		//return;
	} 
	doReport('sample');
}

function rowClicked(row,sample_id)
{
	if (sample_id != null) {
		setValue("sample_id",sample_id);
	}
	highlightOn(row);
}

function doGenerateReport()
{
	doTask(4);
}

function cancelGenerateReport()
{
	cancelReport('sample');
}

</script>
<form method="POST" name="formMain" action="" onSubmit="">		
	<%@include file="posted-fields.jsp"%>
		  
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td><img src="images/samples.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>		
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr bgcolor="#EEEEEE">
		<th width="11%">Type</th>
		<th width="11%">Status</th>
		<th width="11%">Contract</th>
		<th width="12%">Quality</th>
		<th width="20%">Grade</th>				
		<th width="15%">Client</th>
		<th width="9%">Inspector</th>
	</tr>
	<tr>
            <td><select name="type" id="type" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSampleTypeDao().selectAll(),sc.type,"All")%></select></td>
			<td><%if (sc.type == 'A') {%><%@include file="inc/filter.sample.jsp"%><%} else {%><%@include file="inc/filter.status.jsp"%><%}%></td>
            <td><select name="filter_contract_id" id="filter_contract_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptionsX(dao.getSaleContractDao().list(), sc.filter_contract_id, "All")%></select></td>
            <td><select name="filter_quality_id" id="filter_quality_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),sc.filter_quality_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSampleDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_buyer_id" id="filter_buyer_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getSaleContractDao().getBuyerFilter(),sc.filter_buyer_id,"All")%></select></td>
             <td><select name="filter_inspector_id" id="filter_inspector_id" size=7 class="style11" style="width:100%;" onChange="doPost()"><%=Html.selectOptions(dao.getContactPersonDao().selectAll(),sc.filter_inspector_id,"All")%></select></td>
	</tr>
</table> 
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bordercolor="#FFFFFF">
                  <tr align="center" bgcolor="#EEEEEE">
                    <th width="42"  rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif" style="cursor:pointer"></th>
                    <th width="90"  rowspan="2">Sample Ref</th>
                    <th width="90"  rowspan="2">Contract Ref.</th>
                    <th width="42"  rowspan="2">Insp.</th>
                    <th width="120" rowspan="2">Client</th>
                    <th width="150" rowspan="2">Grade</th>
                    <th width="180" rowspan="2">Remark</th>
                    <th width="60" rowspan="2">Date </th>
                    <th colspan="6">Defect</th>
                    <th colspan="8">Screen</th>
                    <th width="" rowspan="2">&nbsp;</th>
                  </tr>
                  <tr align="center" bgcolor="#EEEEEE">
                    <th width="40">Moist</th>
                    <th width="40">FM</th>
                    <th width="40">Black</th>
                    <th width="40">Broken</th>
                    <th width="40">Brown</th>
                    <th width="40">Owith.</th>
                    <th width="32">18</th>
                    <th width="32">17</th>
                    <th width="32">16</th>
                    <th width="32">15</th>
                    <th width="32">14</th>
                    <th width="32">13</th>
                    <th width="32">12</th>
                    <th width="32">12-</th>
                  </tr>
</table> 
<div id="sample_list_view" style="overflow:scroll; height:250px; width:100%">		  
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11" bgcolor="#DDDDDD">
<%
	List<SampleEntity> samples = dao.getSampleDao().getPaging().paging();
	dao.getSampleDao().getPaging().sumary();
	for (int i = 0; i < samples.size(); i++) {
		SampleEntity sample = samples.get(i);
		QualityReportEntity qr = sample.getQualityReport();
		String sa_color  = Action.getColor(sample.status);
%>				
                <tr align="right" onClick="rowClicked(this,<%=sample.getIdLong()%>)" onDblClick="setValue('view',1);doTask();" bgcolor="#FFFFFF">
                  <th width="42" align="right" bgcolor="#EEEEEE"><%=sample.getIdLong()%>&nbsp;</th>
                  <td align="left" width="90" style="color:<%=sa_color%>"><%=sample.getShortRef()%></td>
                  <td align="left" width="90"><%=sample.getContract().getShortRef()%></td>
				  <td align="left" width="42"><%=qr.getInspector().short_name%></td>
                  <td align="left" width="120"><%=sample.getClient().short_name%></td>
                  <td align="left" width="150"><%=sample.getGrade().short_name%></td>
                  <td width="180" align="left"><%=sample.remark%></td>
                  <td width="60" align="center"><%=DateTime.dateToStr(sample.date)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.moisture,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.foreign_matter,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.black,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.broken,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.sound,pad)%></td>
                  <td width="40"><%=Numeric.getPercent(qr.withered,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc18,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc17,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc16,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc15,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc14,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc13,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.sc12,pad)%></td>
                  <td width="32"><%=Numeric.getPercent(qr.below_sc12,pad)%></td>
				  <td>&nbsp;</td>
                </tr>
<%
	}
%>				
</table>
</div>
<div id="sample_report" style="display:none"><%@include file="report.parameter.jsp"%></div>
<table id="sample_buttons" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center"><%@include file="paging.jsp"%></td>
		<td width="60" align="center"><img src="../shared/images/report.jpg" onClick="startReport()"></td>
		<td width="60" align="center"><img src="../shared/images/cardview.jpg" onClick="setValue('view',1);doPost();"></td>
	</tr>
</table>
	<input type="hidden" name="sample_id"  id="sample_id"  value="0">

	
</form>

