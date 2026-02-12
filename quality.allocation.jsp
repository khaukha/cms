
<%
	request.setCharacterEncoding("utf-8");

    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.quality.Allocation task = user.getBiz().getQuality().allocation;
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";	
%>

<%@include file="header.jsp"%>

<%
	sc.filter_status = 0;
	SaleContractEntity contract = task.doTask();
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="quality.qr.js"></script>

<script language="javascript">

getObj("main_window").width = "";
		

function updateAllocation(no, wn_type)
{
	if (<%=task.isReadOnly()%>) {
		return;
	}
	if (getValue("contract_id") <= 0) {
		alert("Please select a contract.");
		return;
	}
	setValue("no", no);
	setValue("wn_type", wn_type);
	doTask(1);
}

function unAllocate(wna_id, wn_ref)
{
	if (<%=task.isReadOnly()%>) {
		return;
	}

	if (confirm("Are you sure to deallocate this lot " + wn_ref + " ?")) {
		setValue("wna_id", wna_id);
		doTask(3);
	}
}

function contractChange()
{
	setValue("filter_grade_id", 0);
	setValue("quality_id", 0);
	doTask(2);
}

function wnaTonsChange(i, packing_id)
{
	if (getValue("contract_id") <= 0) {
		alert("Please select a contract for allocation.");
		return;
	}
	var kg_per_bag = (packing_id == 2) ? 1 : 0.06;
	var wna_bags = (toFloat(getValue("wna_tons_" + i))/kg_per_bag).toFixed(0);
	setValue("wna_bags_" + i, wna_bags);
}

function doPrint()
{
  	if (getValue("contract_id") <= 0) {
		alert("Please select a contract.");
		return;
	}
	doTask(5);
}

function doGenerateReport()
{
	doTask(6);
}

function cancelGenerateReport()
{
	show("qa_list_view_1");
	show("qa_list_view_2");
	show("qa_list_view_3");
	show("qa_list_view_4");
	hide("report_status_");
	cancelReport('qa');
}

function do_Report(id)
{
	hide("qa_list_view_1");
	hide("qa_list_view_2");
	hide("qa_list_view_3");
	hide("qa_list_view_4");
	show("report_status_");
	
	setText("report_text", "     Generate report with Sales Contracts : ");
	
	doReport(id);
}
</script>
<form method="POST" name="formMain" action="" target="">	
	<%@include file="posted-fields.jsp"%>	

<table width="100%" border="0" class="style2" cellpadding="0" cellspacing="1">
				<tr>
				  <td width="60px" align="right" style="display:">Contract. &nbsp;</td>
				  <td width="130px"><select name="contract_id" id="contract_id" class="style2" style="width:100%" onChange="contractChange();"><%=Html.selectOptionsX(dao.getSaleContractDao().list(),sc.contract_id,"Sale Contract")%></select></td>
					<td align="right" width="60px">Grade &nbsp;</td>
					<td width="250px"><select name="filter_grade_id" id="filter_grade_id" class="style2" style="width:250px" onChange="doPost();"><%=Html.selectOptions(dao.getGradeDao().selectAll(),sc.filter_grade_id,"All")%><%//=Html.selectOptions(dao.getQualityReportDao().getGradeFilter(true),sc.filter_grade_id,"All")%></select></td>
				    <td>&nbsp;&nbsp;<strong><%=contract.getRefNumber()%>&nbsp;(<%=contract.getIdLong()%>)&nbsp;<label style="color:#0000FF"><%=contract.getGrade().short_name%></label>&nbsp;<%=contract.tons%> Mts.</strong></td>
				    <td align="right"><%@include file="search.jsp"%></td>
				</tr>
</table>

<div style="width:100%; border:thin; border-style:solid; border-width:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" align="center" class="style11" style="font-weight:bold; cursor:pointer">
                <th width="25"><img src="../shared/images/refresh.gif" width="9" height="9" onClick="doPost();"></th>
                <th width="115" onClick="doSort(table,'ref_number')">WN Ref</th>
                <th width="90" onClick="doSort(table,'grade')">Grade</th>
                <th>Remarks</th>
                <th width="60 "onClick="doSort(table,'packing')">Packing</th>
                <th width="50">Avail.<br />Tons</th>
                <th width="40">Avail.<br />Bags</th>
                <th width="46">Alloc.<br />Tons</th>
                <th width="46">Alloc.<br />Bags</th>
                <th width="40">Moist</th>
                <th width="40">FM</th>
                <th width="40">Black</th>
                <th width="40">Brok.</th>
                <th width="40">Brown</th>
                <th width="40">O.Cr.</th>
                <th width="40">Exce.</th>
                <th width="36">S18</th>
                <th width="36">S17</th>
                <th width="36">S16</th>
                <th width="36">S15</th>
                <th width="36">S14</th>
                <th width="36">S13</th>
                <th width="36">S12</th>
                <th width="36">S12-</th>
                <th width="20">&nbsp;</th>
                <th width="16"></th>
              </tr>
</table>

<div style="height:200px; width:100%; overflow:scroll"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">

<%
	List<WnImXpEntity> wns = task.getInStockWns();
	double total_avail_tons = 0;
	double total_wna_bags = 0;
	
	AverageEntity sav = dao.getAverageDao().newEntity();
	for (int i = 0; i < wns.size(); i++) {
		WnImXpEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();
		double wna_tons = wn.allocated_weight/1000;
		double wna_bags = wn.allocated_bags;
		
		double avail_tons = wn.stock_weight/1000;
		double avail_bags = Math.max(wn.stock_bags, 0);
		
		total_avail_tons += avail_tons;
		total_wna_bags += wna_bags;
		sav.add(dao.getAverageDao().newEntity(qr, wna_tons));
		String color = wna_tons != 0 ? "#0000FF" : "";
%>			  
		  	  <input type="hidden" name="wn_id_<%=i%>"  id="wn_id_<%=i%>"  value="<%=wn.getIdLong()%>">				  
              <tr align="right" onClick="highlightOn(this)" style="color:<%=color%>">
                <td width="25" bgcolor="#DDDDDD"><strong><%=wn.getIdLong()%></strong></td>
                <td width="115" align="left" style="color:<%=color%>"><%=wn.getRefNumber()%></td>
                <td align="left" width="90"><%=wn.getGrade().short_name%></td>
                <td align="left"><%=qr.remark%>&nbsp;</td>
				<td width="60" align="left"><%=wn.getPacking().short_name%></td>
                <td width="50" align="rifgt"><%=Numeric.numberToStr(avail_tons,3)%></td>
                <td width="40" align="right"><%=Numeric.numberToStr(avail_bags,0)%></td>
                <td width="46"><input type="text" name="wna_tons_<%=i%>" id="wna_tons_<%=i%>" class="style11" style="width:44px; text-align:right" value="<%=Numeric.numberToStr(wna_tons,3)%>" onChange="wnaTonsChange(<%=i%>,<%=wn.packing_id%>)"></td>
                <td width="46"><input type="text" name="wna_bags_<%=i%>" id="wna_bags_<%=i%>" class="style11" style="width:44px; text-align:right" value="<%=Numeric.numberToStr(wna_bags,0)%>"></td>
                <td width="40"><%=Numeric.numberToStr(qr.moisture,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.foreign_matter,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.black,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.broken,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.sound,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.withered,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.floats,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc18,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc17,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc16,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc15,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc14,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc13,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc12,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.below_sc12,2)%></td>
                <td width="20" align="center"><img src="../shared/images/update.gif" onClick="updateAllocation(<%=i%>,'<%=wn.type%>')" style="display:<%=displayed%>"></td>
              </tr>
<%
	}	
	List<WnConsolidationEntity> wncs = task.getInStockWncs();	
	for (int j = 0; j < wncs.size(); j++) {
		WnConsolidationEntity wn = wncs.get(j);
		QualityReportEntity qr = wn.getQualityReport();
		double wna_tons = wn.allocated_weight/1000;
		double wna_bags = wn.allocated_bags;
		
		double avail_tons = wn.stock_weight/1000;
		double avail_bags = Math.max(wn.stock_bags, 0);
		
		total_avail_tons += avail_tons;
		total_wna_bags += wna_bags;
		sav.add(dao.getAverageDao().newEntity(qr, wna_tons));
		String color = wna_tons != 0 ? "#0000FF" : "";

		int i = wns.size() + j;
%>	
		  	  <input type="hidden" name="wn_id_<%=i%>"  id="wn_id_<%=i%>"  value="<%=wn.getIdLong()%>">				  
              <tr align="right" onClick="highlightOn(this)" style="color:<%=color%>">
                <td width="25" bgcolor="#DDDDDD"><strong><%=wn.getIdLong()%></strong></td>
                <td width="115" align="left" style="color:<%=color%>"><%=wn.getRefNumber()%></td>
                <td align="left" width="90"><%=wn.getGrade().short_name%></td>
                <td align="left"><%=qr.remark%>&nbsp;</td>
				<td width="60" align="left"><%=wn.getPacking().short_name%></td>
                <td width="50" align="rifgt"><%=Numeric.numberToStr(avail_tons,3)%></td>
                <td width="40" align="right"><%=Numeric.numberToStr(avail_bags,0)%></td>
                <td width="46"><input type="text" name="wna_tons_<%=i%>" id="wna_tons_<%=i%>" class="style11" style="width:44px; text-align:right" value="<%=Numeric.numberToStr(wna_tons,3)%>" onChange="wnaTonsChange(<%=i%>,<%=wn.packing_id%>)"></td>
                <td width="46"><input type="text" name="wna_bags_<%=i%>" id="wna_bags_<%=i%>" class="style11" style="width:44px; text-align:right" value="<%=Numeric.numberToStr(wna_bags,0)%>"></td>
                <td width="40"><%=Numeric.numberToStr(qr.moisture,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.foreign_matter,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.black,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.broken,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.sound,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.withered,2)%></td>
                <td width="40"><%=Numeric.numberToStr(qr.floats,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc18,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc17,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc16,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc15,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc14,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc13,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.sc12,2)%></td>
                <td width="36"><%=Numeric.numberToStr(qr.below_sc12,2)%></td>
                <td width="20" align="center"><img src="../shared/images/update.gif" onClick="updateAllocation(<%=i%>,'<%=wn.type%>')" style="display:<%=displayed%>"></td>
              </tr>
<%
	}
%>
</table></div>

<table style="display:none" width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000">
                <th align="center">Estimated Total in %</th>
			  	<td width="50"><%=Numeric.numberToStr(total_avail_tons,3)%></td>
			  	<td width="40">&nbsp;</td>
			  	<td width="46"><%=Numeric.numberToStr(sav.total_tons,3)%></td>
			  	<td width="46">&nbsp;</td>
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().moisture,2)%></td>
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().foreign_matter,2)%></td>
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().black,2)%></td>
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().broken,2)%></td>
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().sound,2)%></td>
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().withered,2)%></td>				
			  	<td width="40"><%=Numeric.numberToStr(sav.getPercent().floats,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc18,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc17,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc16,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc15,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc14,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc13,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().sc12,2)%></td>
			  	<td width="36"><%=Numeric.numberToStr(sav.getPercent().below_sc12,2)%></td>
                <td width="20">&nbsp;</td>
                <td width="16">&nbsp;</td>
              </tr>
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000; display:none">
                <th align="center">Estimated Total in Mts</th>
                <td><%//=Numeric.numberToStr(total_stock_tons,3)%>&nbsp;</td>
                <td>&nbsp;</td>
                <td><%=Numeric.numberToStr(sav.total_tons,3)%></td>
                <td><%=Numeric.numberToStr(total_wna_bags,0)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().moisture)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().foreign_matter)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().black)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().broken)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sound)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().withered)%></td>				
				<td><%=Numeric.numberToStr(sav.getVolume().floats)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc18)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc17)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc16)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc15)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc14)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc13)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc12)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().below_sc12)%></td>
                <td>&nbsp;</td>
                <td width="16">&nbsp;</td>
              </tr>
</table>
	  
</div>

<span id="qa_list_view_1" class="style2" style="font-weight:bold">Allocated WNs</span>

<div id="qa_list_view" style="border:thin; width:100%; border-style:solid; border-width:0"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" align="center" class="style11" style="font-weight:bold">
                <th width="25" rowspan="2"><img src="../shared/images/refresh.gif" width="9" height="9" style="cursor:pointer" onClick="doPost();"></th>
                <th width="115" rowspan="2">WN Ref</th>
                <th rowspan="2">Grade</th>
                <th width="120" rowspan="2">Remarks</th>
                <th width="60" rowspan="2">Packing </th>
                <th colspan="3">Allocation</th>
                <th width="40" rowspan="2">Moist</th>
                <th width="40" rowspan="2">FM</th>
                <th width="40" rowspan="2">Black</th>
                <th width="40" rowspan="2">Brok.</th>
                <th width="40" rowspan="2">Brown</th>
                <th width="40" rowspan="2">O.Cr.</th>				
                <th width="40" rowspan="2">Exce.</th>
                <th width="40" rowspan="2">S18</th>
                <th width="40" rowspan="2">S17</th>
                <th width="40" rowspan="2">S16</th>
                <th width="40" rowspan="2">S15</th>
                <th width="40" rowspan="2">S14</th>
                <th width="40" rowspan="2">S13</th>
                <th width="40" rowspan="2">S12</th>
                <th width="40" rowspan="2">S12-</th>
                <th width="20" rowspan="2">&nbsp;</th>
              </tr>
              <tr bgcolor="#DDDDDD" align="center" class="style11" style="font-weight:bold">
                <th width="50">Date</th>
                <th width="50">Mts</th>
                <th width="40">Bags</th>
              </tr>
<%
	List<ExportAllocationEntity> wnas = task.getAllocatedWns();
	total_wna_bags = 0;
	sav = dao.getAverageDao().newEntity();
	for (int i = 0; i < wnas.size(); i++) {
		ExportAllocationEntity wna = wnas.get(i);
		WnEntity wn = wna.getWeightNote();
		QualityReportEntity qr = wn.getQualityReport();
		sav.add(dao.getAverageDao().newEntity(qr, wna.tons));
		total_wna_bags += wna.bags;
%>			  
              <tr align="right" onClick="highlightOn(this,1)">
                <td bgcolor="#DDDDDD"><strong><%=wna.getIdLong()%></strong></td>
                <td align="left" style="color:<%=Action.getColor(wna.status)%>"><%=wn.getRefNumber()%></td>
                <td align="left"><%=wn.getGrade().short_name%></td>
                <td align="left"><%=qr.remark%></td>
                <td align="left"><%=wn.getPacking().short_name%></td>
                <td align="center"><%=DateTime.dateToStr(wna.date)%></td>
                <td><%=Numeric.numberToStr(wna.tons,3)%></td>
                <td><%=Numeric.numberToStr(wna.bags,0)%></td>
                <td><%=Numeric.numberToStr(qr.moisture,2)%></td>
                <td><%=Numeric.numberToStr(qr.foreign_matter,2)%></td>
                <td><%=Numeric.numberToStr(qr.black,2)%></td>
                <td><%=Numeric.numberToStr(qr.broken,2)%></td>
                <td><%=Numeric.numberToStr(qr.sound,2)%></td>
                <td><%=Numeric.numberToStr(qr.withered,2)%></td>				
                <td><%=Numeric.numberToStr(qr.floats,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc18,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc17,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc16,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc15,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc14,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc13,2)%></td>
                <td><%=Numeric.numberToStr(qr.sc12,2)%></td>
                <td><%=Numeric.numberToStr(qr.below_sc12,2)%></td>
                <td align="center"><img src="../shared/images/delete.gif" onClick="unAllocate(<%=wna.getIdLong()%>,'<%=wn.getRefNumber()%>')" style="display:<%=wna.isCompleted()||task.isReadOnly()?"none":""%>"></td>
              </tr>
<%
	}
%>			  
			<tr bgcolor="#DDDDDD" class="style11" style="font-weight:bold; color:#000000" align="right">
			  <th colspan="5" align="center">Estimated  in %</th>
			  <td align="right">&nbsp;</td>
			  <td align="right">100%</td>
			  <td align="right">&nbsp;</td>
			  <td><%=Numeric.numberToStr(sav.getPercent().moisture,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().foreign_matter,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().black,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().broken,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sound,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().withered,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().floats,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc18,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc17,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc16,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc15,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc14,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc13,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc12,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().below_sc12,2)%></td>
			  <td align="center">&nbsp;</td>
			</tr>
			<tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000; display:">
				<th colspan="5" align="center">Estimated  in Mts</th>
				<td align="right">&nbsp;</td>
				<td align="right"><%=Numeric.numberToStr(sav.total_tons,3)%></td>
				<td align="right"><%=Numeric.numberToStr(total_wna_bags,0)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().moisture,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().foreign_matter,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().black,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().broken,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sound,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().withered,2)%></td>				
				<td><%=Numeric.numberToStr(sav.getVolume().floats,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc18,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc17,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc16,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc15,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc14,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc13,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc12,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().below_sc12,2)%></td>
			    <td>&nbsp;</td>
			</tr>
</table></div>
					
<table id="qa_list_view_2" width="100%" class="style2" border="0" cellpadding="0" cellspacing="1">
	<tr>
		<td>Remarks</td>
	</tr>		
	<tr>
		<td><textarea name="allocation_remark" rows="4" style="width:100%" class="style2"><%=contract.allocation_remark%></textarea></td>
	</tr>		
</table>

<table id="qa_list_view_3" width="100%" cellpadding="0" border="0">
				<tr>
				    <th align="left"><a href="JavaScript:if (<%=!task.isReadOnly()%>) doTask(4)" class="style2" style="display:<%=displayed%>">Save Remarks</a></th>
					<th>&nbsp;</th>
					<th width="60"><a href="JavaScript:do_Report('qa')" class="style2">Report</a></th>
					<th width="60px"><a href="JavaScript:doPrint()" class="style2">Print</a></th>
				</tr>
</table>
					
<div id="qa_report" style="width:100%; display:none"><%@include file="report.parameter.jsp"%></div>

	<input type="hidden" name="no"  id="no"  value="0">	
	<input type="hidden" name="wna_id"  id="wna_id"  value="0">	
	<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">	
	<input type="hidden" name="wn_type"  id="wn_type"  value="">	
</form>

<script language="javascript">
	if (<%=task.isReadOnly()%>) {
		//setCompletedElements();
		//setReadonlyElements("INPUT");
		//setReadonlyElements("TEXTAREA");	
	}

</script>

<%
	if (sc.task_id == 2) {
	}
%>

<%@include file="../footer.jsp"%>

