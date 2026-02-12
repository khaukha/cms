<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.management.Allocation task = user.getBiz().getManagement().getAllocation();
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";
%>


<%@include file="header.jsp"%>

<%
	task.doTask();
%>

<script language="javascript">

function goBack()
{
	setValue("wn_alloc_id",0);
	doPost();
}

function showWnr(wn_id)
{	
	setValue("wn_alloc_id",wn_id); 
	doPost();
}

function selectWn(wn_id, is_selected)
{
	setValue("wn_id", wn_id);
	setValue("is_selected", is_selected);
	doTask(1);
}

function selectWnr(wnr_id, is_selected)
{
	setValue("wnr_id", wnr_id);
	setValue("is_selected", is_selected);
	doTask(2);
}

</script>

<form method="POST" name="formMain" action="" target="">	
	<%@include file="posted-fields.jsp"%>

<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
	<tr bgcolor="#DDDDDD">
	  <th width="20">&nbsp;</th>
		<th width="130">Warehouse</th>
		<th width="200">Grade</th>
		<th align="right">&nbsp;</th>
    </tr>
	<tr>
	  <td align="center"><img src="../shared/images/backicon.gif" onClick="goBack();"></td>
	  <td><select name="warehouse_id" id="warehouse_id" class="style2" style="width:100%" onChange="setValue('wn_alloc_id',0);doTask(6);"><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(user.getLocationId()), sc.warehouse_id, "All")%></select></td>
	  <td><select name="filter_grade_id" id="filter_grade_id" class="style2" style="width:100%" onChange="doPost();"><%=Html.selectOptions(dao.getWnImXpDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
	  <td align="right">&nbsp;</td>
    </tr>
</table>	


<div style="width:100%;border:thin; border-style:solid; border-width:1; border-left:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" align="center" class="style11" style="font-weight:bold; cursor:pointer">
    	<th width="36"><img src="../shared/images/refresh.gif" width="9" height="9" onClick="doPost();"></th>
        <th width="86">WN Ref</th>
        <th width="60">Date</th>
        <th>Grade</th>
        <th width="60">Packing</th>
        <th width="40">Bags</th>
        <th width="50">Tons</th>
        <th width="42">Moist</th>
        <th width="42">FM</th>
        <th width="42">Blk.</th>
        <th width="42">Bro.</th>
        <th width="42">Brown</th>
        <th width="42">OCrop</th>
        <th width="42">Excel.</th>
        <th width="42">M.A</th>
        <th width="42">S18</th>
        <th width="42">S17</th>
        <th width="42">S16</th>
        <th width="42">S15</th>
        <th width="42">S14</th>
        <th width="42">S13</th>
        <th width="42">S12</th>
        <th width="42">S12-</th>
        <th width="24">&nbsp;</th>
        <th width="20">&nbsp;</th>
        <th width="16">&nbsp;</th>
     </tr>
</table>

<div style="height:200px; width:100%; overflow:scroll"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<WnImXpEntity> wns = task.getAvailableWNs();
	int no = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnImXpEntity wn = wns.get(i);
		double availble_weight = wn.stock_weight - wn.allocated_weight;
		long availble_bags = wn.stock_bags - wn.allocated_bags;
		if (availble_weight == 0) continue;
		if (sc.filter_grade_id != 0 && sc.filter_grade_id != wn.grade_id) continue;
		String bgcolor = no%2==1?"":"#CCFFFF";
		no++;
		QualityReportEntity qr = wn.getQualityReport();
		String can_alloc = "";
		boolean allowed = true;
		String color = wn.isQualityLocking() ? "#0066FF" : "";
%>
		<tr onClick="highlightOn(this)" align="right" bgcolor="<%=bgcolor%>">
			<td width="36" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</td>
			<td width="86" align="left" style="color:<%=color%>"><%=wn.getShortRef()%></td>
			<td width="60" align="center"><%=DateTime.dateToStr(wn.date)%></td>
			<td align="left"><%=wn.getGrade().short_name%></td>
        	<td width="60" align="left"><%=wn.getPacking().short_name%></td>
        	<td width="40"><%=Numeric.numberToStr(availble_bags,0)%></td>
			<td width="50"><%=Numeric.numberToStr(availble_weight/1000,4)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.moisture,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.foreign_matter,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.black,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.broken,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sound,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.withered,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.floats,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.insect_half,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc18,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc17,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc16,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc15,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc14,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc13,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.sc12,2)%></td>
            <td width="42"><%=Numeric.numberToStr(qr.below_sc12,2)%></td>
			<td width="24" align="center"><img src="../shared/images/new.gif" onClick="selectWn(<%=wn.getIdLong()%>,1)" style="display:<%=displayed%>"></td>
			<td width="20" align="center"><img src="../shared/images/detail.gif" onClick="showWnr(<%=wn.getIdLong()%>);" style="display:<%=displayed%>"></td>
		</tr>
<%
		List<WnrEntity> wnrs = task.getAvailableWNRs(wn.getIdLong());
		for (WnrEntity wnr : wnrs) {
			if (task.isAllocated(wnr)) continue;
%>
			<tr onClick="highlightOn(this)">
				<td>&nbsp;</td>
				<td><%=wnr.getIdLong()%></td>
				<td colspan="2"><%=wnr.getRefNumber()%></td>
				<td>&nbsp;</td>
				<td align="right"><%=Numeric.numberToStr(wnr.no_of_bags,0)%></td>
				<td align="right"><%=Numeric.numberToStr(wnr.net_weight/1000,4)%></td>
				<td align="center"><img src="../shared/images/new.gif" onClick="selectWnr(<%=wnr.getIdLong()%>,1)" style="display:<%=displayed%>"></td>
				<td colspan="17">&nbsp;</td>
			</tr>
<%					
		}
	}
%>
</table></div>

</div>
<label class="style2"><strong>Result</strong></label>
<div style="width:100%;border:thin; border-style:solid; border-width:1; border-left:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD" align="center" class="style11" style="font-weight:bold; cursor:pointer">
    	<th width="36"><img src="../shared/images/refresh.gif" width="9" height="9" onClick="doPost();"></th>
        <th width="86">WN Ref</th>
        <th width="60">Date</th>
        <th>Grade</th>
        <th width="60">Packing</th>
        <th width="40">Bags</th>
        <th width="50">Tons</th>
        <th width="42">Moist</th>
        <th width="42">FM</th>
        <th width="42">Blk.</th>
        <th width="42">Bro.</th>
        <th width="42">Brown</th>
        <th width="42">OCrop</th>
        <th width="42">Excel.</th>
        <th width="42">M.A</th>
        <th width="42">S18</th>
        <th width="42">S17</th>
        <th width="42">S16</th>
        <th width="42">S15</th>
        <th width="42">S14</th>
        <th width="42">S13</th>
        <th width="42">S12</th>
        <th width="42">S12-</th>
        <th width="24">&nbsp;</th>
      </tr>
<%
	AverageEntity sav = dao.getAverageDao().newEntity();
	wns = task.getAllocatedWNs();
	for (int i = 0; i < wns.size(); i++) {
		String bgcolor = i%2==1?"":"#CCFFFF";
		WnImXpEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();
		double allocated_tons = wn.allocated_weight/1000;
		AverageEntity av = dao.getAverageDao().newEntity(qr, allocated_tons);
		sav.add(av);
%>
		<tr onClick="highlightOn(this,1)" align="right" bgcolor="<%=bgcolor%>">
			<td bgcolor="#DDDDDD"><%=wn.getIdLong()%></td>
			<td align="left"><%=wn.getShortRef()%></td>
			<td align="center"><%=DateTime.dateToStr(wn.date)%></td>
			<td align="left"><%=wn.getGrade().short_name%></td>
			<td align="left"><%=wn.getPacking().short_name%></td>
        	<td><%=Numeric.numberToStr(wn.allocated_bags,0)%></td>
			<td><%=Numeric.numberToStr(allocated_tons,4)%></td>
            <td><%=Numeric.numberToStr(qr.moisture,2)%></td>
            <td><%=Numeric.numberToStr(qr.foreign_matter,2)%></td>
            <td><%=Numeric.numberToStr(qr.black,2)%></td>
            <td><%=Numeric.numberToStr(qr.broken,2)%></td>
            <td><%=Numeric.numberToStr(qr.sound,2)%></td>
            <td><%=Numeric.numberToStr(qr.withered,2)%></td>
            <td><%=Numeric.numberToStr(qr.floats,2)%></td>
            <td><%=Numeric.numberToStr(qr.insect_half,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc18,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc17,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc16,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc15,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc14,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc13,2)%></td>
            <td><%=Numeric.numberToStr(qr.sc12,2)%></td>
            <td><%=Numeric.numberToStr(qr.below_sc12,2)%></td>
			<td align="center"><img src="../shared/images/delete.gif" onClick="selectWn(<%=wn.getIdLong()%>,0)" style="display:<%=displayed%>"></td>
		</tr>
<%
	}
%>		
		<tr align="right" bgcolor="#DDDDDD" style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td align="center" colspan="2">Estimated  in %</td>
		  <td align="left">&nbsp;</td>
		  <td align="left">&nbsp;</td>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		      <td><%=Numeric.numberToStr(sav.getPercent().moisture,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().foreign_matter,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().black,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().broken,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sound,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().withered,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().floats,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().insect_half,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc18,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc17,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc16,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc15,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc14,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc13,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().sc12,2)%></td>
			  <td><%=Numeric.numberToStr(sav.getPercent().below_sc12,2)%></td>
		  <td>&nbsp;</td>
	  </tr>
		<tr align="right" bgcolor="#DDDDDD" style="font-weight:bold">
		  <td>&nbsp;</td>
		  <td align="center" colspan="2">Estimated  in Mt</td>
		  <td align="center">&nbsp;</td>
		  <td align="left">&nbsp;</td>
		  <td align="left">&nbsp;</td>
				<td><%=Numeric.numberToStr(sav.total_tons)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().moisture,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().foreign_matter,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().black,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().broken,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sound,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().withered,3)%></td>				
				<td><%=Numeric.numberToStr(sav.getVolume().floats,3)%></td>
                <td><%=Numeric.numberToStr(sav.getVolume().insect_half,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc18,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc17,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc16,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc15,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc14,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc13,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc12,3)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().below_sc12,3)%></td>
		  <td>&nbsp;</td>
	  </tr>
</table>

</div>

<table width="100%" border="0" cellpadding="0" cellspacing="1">
	<tr>
		<th>&nbsp;</th>
		<th width="60px"><a href="JavaScript:doTask(5)" class="style2">Print</a></th>
		<th width="60px"><a href="JavaScript:setValue('wn_alloc_id',0);doTask(6)" class="style2">Reset</a></th>
	</tr>
</table>


	<input type="hidden" name="is_selected"   id="is_selected"   value="0"> 
	<input type="hidden" name="wn_alloc_id"   id="wn_alloc_id"   value="<%=requester.getLong("wn_alloc_id")%>"> 
	<input type="hidden" name="wn_id"   id="wn_id"   value="0"> 
	<input type="hidden" name="wnr_id"   id="wnr_id"   value="0"> 

</form>

<%@include file="footer.jsp"%>
