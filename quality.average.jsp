<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.quality.QAverage task = user.getBiz().getQuality().getQAverage();
	task.select();
%>


<%@include file="header.jsp"%>

<%
	task.doTask();
	boolean in_stock = requester.getBoolean("in_stock", true);
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="quality.qr.js"></script>

<script language="javascript">
getObj("main_window").width = "";

function doUnCheck(obj)
{
	setValue("wn_id",obj.value);
	doTask(3);
}

function contractChange(o)
{
	//setValue("in_stock", o.value==0?1:0);
	setValue("filter_grade_id", 0);
	setValue("quality_id", 0);
	itemSelected(o);
}

</script>
<form method="POST" name="formMain" action="" target="">	
	<%@include file="posted-fields.jsp"%>
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style11">
	<tr bgcolor="#DDDDDD">
		<th width="120">P.Contract</th>
		<th width="130">Warehouse</th>
		<th width="80">Status</th>
		<th width="200">Grade</th>
		<th align="right">&nbsp;</th>
    </tr>
	<tr>
		<td><select name="contract_id" id="contract_id" class="style2" style="width:120" onChange="contractChange(this);"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(),sc.contract_id,"All")%></select></td>
		<td><select name="warehouse_id" id="warehouse_id" class="style2" style="width:130" onChange="doPost();"><%=Html.selectOptions(dao.getWarehouseDao().selectByLocationId(user.getLocationId()), sc.warehouse_id, "All")%></select></td>
		<td><select name="in_stock" id="in_stock" class="style2" style="width:80px" onChange="doPost();">
			<option value="0" <%=in_stock?"":"selected"%>>All</option>
			<option value="1" <%=in_stock?"selected":""%>>In-Stock</option>
        </select></td>
		<td><select name="filter_grade_id" id="filter_grade_id" class="style2" style="width:100%" onChange="doPost();"><%=Html.selectOptions(dao.getWnImXpDao().getGradeFilter(in_stock),sc.filter_grade_id,"All")%></select></td>
		<td align="right"><%@include file="search.jsp"%></td>
	</tr>
</table>	

<div style="border:thin; border-style:solid; border-width:1; border-left:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD">
                <th width="42"><img src="../shared/images/refresh.gif" onClick="doPost();" style="cursor:pointer"></th>
                <th width="90">WN Ref</th>
                <th width="60">Date</th>
                <th width="150">Grade</th>
                <th width="60">Packing</th>
                <th width="40">Bags</th>
                <th width="45">Tons</th>
                <th width="36">Alloc.<br />Bags</th>
                <th width="45">Alloc.<br />Tons</th>
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
                <th width="24">Sel</th>
                <th width=""></th>
              </tr>
</table>

<div style="height:200px; width:100%; overflow:scroll; display:">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	AverageEntity sav = dao.getAverageDao().newEntity();
	List<WnImXpEntity> wns = task.getStockWNs();
	for (int i = 0; i < wns.size(); i++) {
		WnImXpEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();
		boolean is_selected = wn.status > 0;
		
		double net_weight = sc.contract_id == 0 ? wn.stock_weight : wn.net_weight;
		long no_of_bags   = sc.contract_id == 0 ? wn.stock_bags   : wn.no_of_bags;
		
		double alloc_tons = (is_selected ? wn.allocated_weight : net_weight)/1000;
		long alloc_bags   = (is_selected ? wn.allocated_bags : no_of_bags);

		sav.add(dao.getAverageDao().newEntity(qr, alloc_tons));
		String color = wn.isQualityLocking() ? "#0066FF" : "";
%>			  

              <tr align="right" onClick="highlightOn(this)">
                <th width="42" bgcolor="#DDDDDD" align="right"><%=wn.getIdLong()%>&nbsp;</th>
                <td width="90" align="left" style="color:<%=color%>"><%=wn.getShortRef()%><%//=wn.getRefNumber()%></td>
                <td width="60" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                <td width="150" align="left"><%=wn.getGrade().short_name%></td>
                <td width="60" align="left"><%=wn.getPacking().short_name%></td>
                <td width="40" align="right"><%=no_of_bags%></td>
                <td width="45" align="right"><%=Numeric.numberToStr(net_weight/1000)%></td>
                <td width="36"><input type="text" name="bags_<%=i%>" id="bags_<%=i%>" class="style11" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(alloc_bags,0)%>"></td>
                <td width="45"><input type="text" name="tons_<%=i%>" id="tons_<%=i%>" class="style11" style="width:100%; text-align:right" value="<%=Numeric.numberToStr(alloc_tons,3)%>"></td>
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
                <td width="24" align="center"><input type="checkbox" name="wn_sel_<%=i%>_" id="wn_sel_<%=i%>_" value="1" onClick="cbxClick(this);" <%=is_selected ? "checked" : ""%>></td>
				<td>&nbsp;</td>
              </tr>
		  	<input type="hidden" name="wn_sel_<%=i%>" id="wn_sel_<%=i%>" value="<%=wn.status%>">	
		  	<input type="hidden" name="wn_id_<%=i%>"  id="wn_id_<%=i%>"  value="<%=wn.getIdLong()%>">				  
<%
	}
%>				
</table></div>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000">
                <td width="493" align="center">Estimated Total in %</td>
			  	<td width="82">100%</td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().moisture,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().foreign_matter,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().black,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().broken,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sound,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().withered,2)%></td>				
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().floats,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().insect_half,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc18,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc17,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc16,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc15,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc14,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc13,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc12,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().below_sc12,2)%></td>
                <td width="24">&nbsp;</td>
                <td width="" rowspan="2">&nbsp;</td>
              </tr>
              <tr bgcolor="#DDDDDD" align="right">
                <th align="center">Estimated Total in Mts</th>
                <td><%=Numeric.numberToStr(sav.total_tons,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().moisture,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().foreign_matter,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().black,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().broken,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sound,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().withered,2)%></td>				
				<td><%=Numeric.numberToStr(sav.getVolume().floats,2)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().insect_half,2)%></td>
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
</table>

<div style="width:100%;" align="center"><img src="../shared/images/update.gif" width="15" height="15" onClick="doTask(1)"></div>
</div>
<span class="style2" style="font-weight:bold">Quality Average Result</span>

<div style="border:thin; border-style:solid; border-width:1; border-left:0">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD">
                <th width="42"><img src="../shared/images/refresh.gif" onClick="doPost();"></th>
                <th width="90">WN Ref</th>
                <th width="60">Date </th>
                <th width="150">Grade</th>
                <th width="60">Packing</th>
                <th width="40">Bags</th>
                <th width="50">Tons</th>
                <th width="45">Moist</th>
                <th width="45">FM</th>
                <th width="45">Black</th>
                <th width="45">Broken</th>
                <th width="45">Brown</th>
                <th width="45">O.Crop</th>				
                <th width="45">Excel.</th>
                <th width="45">M.A.</th>
                <th width="45">S18</th>
                <th width="45">S17</th>
                <th width="45">S16</th>
                <th width="45">S15</th>
                <th width="45">S14</th>
                <th width="45">S13</th>
                <th width="45">S12</th>
                <th width="45">S12-</th>
                <th width="24">&nbsp;</th>
                <th width="">&nbsp;</th>
              </tr>
<%
 	sav = dao.getAverageDao().newEntity();
	wns = task.getSelectedWNs();
	for (int i = 0; i < wns.size(); i++) {
		WnImXpEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();
		sav.add(dao.getAverageDao().newEntity(qr, wn.allocated_weight/1000));
%>			  
              <tr align="right" onClick="highlightOn(this,1)">
                <th align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%>&nbsp;</th>
                <td align="left"><%=wn.getShortRef()%></td>
                <td align="center"><%=DateTime.dateToStr(wn.date)%></td>
                <td align="left"><%=wn.getGrade().short_name%></td>
                <td align="left"><%=wn.getPacking().short_name%></td>
                <td><%=Numeric.numberToStr(wn.allocated_bags,0)%></td>
                <td><%=Numeric.numberToStr(wn.allocated_weight/1000)%></td>
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
                <td align="center"><input type="checkbox" name="wn_cal_<%=i%>_" id="wn_cal_<%=i%>_" value="<%=wn.getIdLong()%>" onClick="doUnCheck(this)" checked="checked"></td>
                <td align="center">&nbsp;</td>
              </tr>
<%
	}
%>			  
			<tr bgcolor="#DDDDDD" class="style11" style="font-weight:bold; color:#000000" align="right">
			  <td colspan="4" align="center">Estimated  in %</td>
			  <td align="right">&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td align="right">100%</td>
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
			  <td>&nbsp;</td>
			</tr>
			<tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; color:#000000">
				<td colspan="4" align="center">Estimated  in Mts</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td align="right" id="total_allocated_tons__"><%=Numeric.numberToStr(sav.total_tons)%></td>
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
			    <td>&nbsp;</td>
			</tr>
</table>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="1">
	<tr>
		<th>&nbsp;</th>
		<th width="60px"><a href="JavaScript:doTask(4)" class="style2">Print</a></th>
		<th width="60px"><a href="JavaScript:doTask(2)" class="style2">Reset</a></th>
	</tr>
</table>

	<input type="hidden" name="wn_id"  id="wn_id"  value="0">	
	<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">	
</form>

<%@include file="../footer.jsp"%>

