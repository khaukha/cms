
<%
	boolean completed = instr.status == 2;	
	String disabled = completed ? "disabled" : "";
	sc.filter_quality_id = 0;
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";
var can_update = (<%=!task.isReadOnly() && !completed%>);
var access_error_msg = "You do not have permisstion to modify data or the allocation has been completed.";

function showWnr(wn_id, allowed)
{	
	setValue('wn_alloc_id',wn_id); 
	doPost();
}

function save_Allocation()
{
	if (!can_update) {
		alert(access_error_msg);
		return;
	}

	if (getValue("inst_id") <= 0) {
		alert('Please Select a Processing Order/Shipping Instruction for allocation');
		return;
	}
	if (<%=sc.alloc_type == 'S'%>) {
		if (getValue('wn_id') == 0) {
			alert('Please Select a Shipping WN');
			return;
		}
	}
	doTask(1);
}

function save_UnAllocation()
{
	if (!can_update) {
		alert(access_error_msg);
		return;
	}
	doTask(3);
}

function save_Check()
{
	if (!can_update) {
		alert(access_error_msg);
		return;
	}
	doTask(5);
}

function goBack()
{
	setValue('wn_alloc_id',0);
	setValue('wn_dealloc_id',0);
	doPost();
}

function sumAllocated(type)
{
	var sum = 0;
	for (var i = 1;; i++) {
		var cbx = getObj(type + "_alloc_sel_" + i + "_");
		if (cbx == null) break;
		if (cbx.checked) {
			sum += toFloat(getText(type + "_stock_weight_" + i));
		}
	}
	sum += toFloat(getText("total_allocated_tons__"));
	setText("total_allocated_tons_",formatNumber(sum,4,true));
}

function splitWNR(wnr_id)
{
	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}	
	window.open("traffic.allocation.split-wnr.jsp?uid=<%=user.getuid()%>&wnr_id=" + wnr_id,'','width=840, height=400');
}

function instSelect(o)
{
	//doTask(-1);
	itemSelected(o, -1);
}
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
	<tr bgcolor="#DDDDDD">
	  <th width="24"><img src="../shared/images/backicon.gif" width="18" height="18" onClick="goBack();"></th>
	  <th width="80">Alloc. Type</th>
		<th width="80">Status</th>
		<th width="130"><a href="javascript:doRefresh()" title="Reload list.">PO/SI/TR Ref.</a></th>
		<th width="140" style="display:<%=sc.alloc_type=='S'?"":"none"%>">WN Export</th>
		<th width="200">Select Quality</th>
		<th width="150">Warehouse</td>
	    <td align="right"><%@include file="search.jsp"%></td>
	</tr>
	<tr>
	  <th bgcolor="#DDDDDD">&nbsp;</th>
	  <td><select name="alloc_type" id="alloc_type" class="style11" style="width:100%;" onChange="doPost();"><%@include file="inc/options.allocation.jsp"%></select></td>
		<td><select name="filter_status" id="filter_status" class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
		<td><select name="inst_id" id="inst_id" class="style11" style="width:100%" onChange="instSelect(this)"><%=Html.selectOptionsX(alloc_class.getInstList(),sc.inst_id,"Select PO/SI/TR")%></select></td>
		<td style="display:<%=sc.alloc_type=='S'?"":"none"%>"><select name="wn_id" id="wn_id" class="style11" style="width:100%" onChange="doPost();"><%=Html.selectOptionsX(alloc_class.getWnList(sc.inst_id),sc.wn_id,"")%></select></td>
		<td><select name="filter_grade_id" id="filter_grade_id" class="style11" style="width:100%" onChange="doPost();"><%=Html.selectOptions(dao.getWnImXpDao().getGradeFilter(true),sc.filter_grade_id,"All")%></select></td>
		<td><select name="filter_warehouse_id" id="filter_warehouse_id" class="style11" style="width:100%" onChange="doPost();"><%=Html.selectOptions(dao.getWarehouseDao().selectAll(),sc.filter_warehouse_id,"All")%></select></td>
	    <td align="right"><strong>Allocated : <label id="total_allocated_tons_">0.0000</label>&nbsp;Mts</strong>&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="0" class="style11">
			  	<tr>
			  		<th valign="top" align="left">Available Weight Notes &nbsp; <label style="color:#FF0000; font-weight:bold" id="note_">&nbsp;</label></th>
					<td align="right"><%=instr.getWarehouse().short_name%>&nbsp;<label id="wn_id_"><strong><%=instr.getGrade().getQuality().short_name%> - <%=instr.getGrade().short_name%></strong></label>&nbsp;</td>
				</tr>
</table>
				  
	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
		  <tr>
		  	<td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
				<script language="javascript">	var table = 'warehouse.allocation.stock';  </script>
              <tr bgcolor="#DDDDDD" align="center" class="style2">
                <th width="40"><img src="../shared/images/refresh.gif" onClick="doPost();"></th>
                <th width="115">WN Ref</th>
                <th width="60">Stock Date</th>
                <th>Grade</th>
                <th width="60">Stock<br />Tons</th>
                <th width="40">Stock<br />Bags</th>
                <th width="42">Black</th>
                <th width="42">Brown</th>
                <th width="42">FM</th>
                <th width="42">Broken</th>
                <th width="42">Moist</th>
                <th width="42">With.</th>
                <th width="42">S18</th>
                <th width="42">S17</th>
                <th width="42">S15</th>
                <th width="42">S14</th>
                <th width="42">S12</th>
                <th width="42">S12-</th>
                <th width="30">Sel</th>
                <th width="20">&nbsp;</th>
                <th width="16">&nbsp;</th>
              </tr>
            </table></td>
	  	  </tr>
		  <tr>
		    <td>
			  <div style="height:200px; overflow:scroll"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	AverageEntity sav = dao.getAverageDao().newEntity();
	List<WnImXpEntity> awns = task.getAvailableWNs();
	double total_stock_tons = 0;
	int i = 0;
	for (WnImXpEntity wn : awns) {
		//if (wn.isImport() && !wn.isCompleted()) continue;
		i++;
		QualityReportEntity qr = wn.getQualityReport();
		double stock_tons = wn.stock_weight/1000;	
		sav.add(dao.getAverageDao().newEntity(qr, stock_tons));
		//
		total_stock_tons += stock_tons;
		String can_alloc = disabled;
		boolean allowed = true;
		if (task.isReadOnly() || !wn.isCompleted() || wn.warehouse_id != instr.warehouse_id) {
			can_alloc = "disabled";
			allowed = false;
		}
		String color = "";
		if (!wn.isCompleted()) {
			color = "#3300FF";
		}
		String bgcolor = i%2==1?"":"#CCFFFF";
%>			  
              <tr align="right" onClick="highlightOn(this)" onDblClick="showWnr(<%=wn.getIdLong()%>,<%=allowed%>);" bgcolor="<%=bgcolor%>">
                <td width="40" bgcolor="#DDDDDD"><strong><%=wn.getIdLong()%></strong></td>
                <td width="115" align="left" style="color:<%=color%>"><%=wn.getShortRef()%></td>
                <td width="60" align="center"><%=DateTime.dateToStr(wn.date)%></td>
                <td align="left"><%=wn.getGrade().short_name%></td>
                <td width="60" id="wn_stock_weight_<%=i%>"><%=Numeric.numberToStr(stock_tons)%></td>
                <td width="40"><%=wn.stock_bags%></td>
                <td width="42"><%=Numeric.numberToStr(qr.black,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.sound,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.foreign_matter,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.broken,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.moisture,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.withered,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.sc18,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.sc17,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.sc15,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.sc14,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.sc12,2)%></td>
                <td width="42"><%=Numeric.numberToStr(qr.below_sc12,2)%></td>
                <td width="30" align="center"><%=Html.checkBox("wn_alloc_sel_" + i, false, "sumAllocated('wn')", can_alloc)%></td>
                <td width="20" align="center"><img src="../shared/images/detail.gif" width="18" height="18" onClick="showWnr(<%=wn.getIdLong()%>,<%=allowed%>);" style="display:<%=displayed%>"></td>
              </tr>
		  	<input type="hidden" name="wn_alloc_id_<%=i%>"  id="wn_alloc_id_<%=i%>"  value="<%=wn.getIdLong()%>">	
			<%
				List<WnrEntity> wnrs = task.get_Stock_WNRs();
				for (int j = 1; j <= wnrs.size(); j++) {
					WnrEntity wnr = wnrs.get(j-1);
					String dbl_click = "splitWNR(" + wnr.getIdLong() + ")";
			%>
              <tr align="right" onClick="highlightOn(this)" onDblClick="<%=dbl_click%>">
                <td align="right" bgcolor=""><strong><%=wnr.getIdLong()%></strong>&nbsp;</td>
                <td align="right"><%=wnr.getRefNumber()%></td>
                <td align="center"><%=DateTime.dateToStr(wnr.date)%></td>
				<td align="left"><%=wnr.getParent().getRefNumber()%></td>
                <td id="wnr_stock_weight_<%=j%>"><%=Numeric.numberToStr(wnr.net_weight/1000)%></td>
                <td><%=wnr.no_of_bags%></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><%=Html.checkBox("wnr_alloc_sel_" + j, false, "sumAllocated('wnr')", can_alloc)%></td>
                <td>&nbsp;</td>
              </tr>
			  	<input type="hidden" name="wnr_alloc_id_<%=j%>"  id="wnr_alloc_id_<%=j%>"  value="<%=wnr.getIdLong()%>">	
			<%
				}
			%>
<%
	}
%>			  
            </table>
			  </div>
			</td>
      </tr>
		  <tr>
		    <td align="center"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold">
                <td align="center">Estimated Total in %</td>
			  	<td width="60"><%=Numeric.numberToStr(total_stock_tons)%></td>
			  	<td width="40">&nbsp;</td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().black,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sound,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().foreign_matter,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().broken,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().moisture,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().withered,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc18,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc17,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc15,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc14,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().sc12,2)%></td>
			  	<td width="42"><%=Numeric.numberToStr(sav.getPercent().below_sc12,2)%></td>
                <td width="30">&nbsp;</td>
                <td width="20">&nbsp;</td>
                <td width="16">&nbsp;</td>
              </tr>
              <tr bgcolor="#DDDDDD" align="right" class="style11" style="font-weight:bold; display:none">
                <th align="center">Estimated Total in Mts</th>
                <td><%=Numeric.numberToStr(total_stock_tons)%></td>
                <td>&nbsp;</td>
				<td><%=Numeric.numberToStr(sav.getVolume().black)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sound)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().foreign_matter)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().broken)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().moisture)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().withered)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc18)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc17)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc15)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc14)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().sc12)%></td>
				<td><%=Numeric.numberToStr(sav.getVolume().below_sc12)%></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table></td>
      </tr>
		  <tr style="display:">
		  	<td align="center"><img src="../shared/images/update.gif" onClick="save_Allocation()" style="display:<%=displayed%>"></td>
      	  </tr>
		  <tr style="display:">
		    <th align="left">Allocated Weight Notes</th>
      </tr>
		  <tr style="display:">
		    <td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
              <tr bgcolor="#DDDDDD" align="center" class="style11">
                <th width="40"><img src="../shared/images/refresh.gif" width="9" height="9" onClick="doPost();"; style="cursor:pointer"></th>
                <th width="115">WN Ref</th>
                <th width="60">Alloc.<Br />Date </th>
                <th>Grade</th>
                <th width="60">Alloc.<br />Tons</th>
                <th width="40">Alloc.<br />Bags</th>
                <th width="42">Black</th>
                <th width="42">Brown</th>
                <th width="42">FM</th>
                <th width="42">Broken</th>
                <th width="42">Moist</th>
                <th width="42">With.</th>
                <th width="42">S18</th>
                <th width="42">S17</th>
                <th width="42">S15</th>
                <th width="42">S12</th>
                <th width="42">S12-</th>
                <th width="24">Del</th>
                <th width="20">...</th>
              </tr>
<%
	WnImXpEntity sum = (WnImXpEntity)dao.getWnImXpDao().newEntity();
	List<WnImXpEntity> wns = task.get_Allocated_WNs();
	AverageEntity av = dao.getAverageDao().newEntity();
	for (i = 1; i <= wns.size(); i++) {
		WnImXpEntity wn = wns.get(i-1);
		sum.add(wn);
		QualityReportEntity qr = wn.getQualityReport();
		av.add(dao.getAverageDao().newEntity(qr,wn.allocated_weight/1000));
		String color = "#3300FF";
		String bgcolor = i%2==1?"":"#CCFFFF";
%>			  
              <tr align="right" onClick="highlightOn(this,1)" bgcolor="<%=bgcolor%>">
                <td bgcolor="#DDDDDD"><strong><%=wn.getIdLong()%></strong></td>
                <td align="left"><%=wn.getRefNumber()%></td>
                <td align="center"><%=DateTime.dateToStr(wn.date)%></td>
                <td align="left"><%=wn.getGrade().short_name%></td>
                <td><%=Numeric.numberToStr(wn.allocated_weight/1000)%></td>
                <td><%=Numeric.numberToStr(wn.allocated_bags,0)%></td>
                <td><%=Numeric.getPercent(qr.black,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.sound,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.foreign_matter,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.broken,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.moisture,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.withered,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.sc18,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.sc17,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.sc15,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.sc12,"&nbsp;")%></td>
                <td><%=Numeric.getPercent(qr.below_sc12,"&nbsp;")%></td>
                <td align="center"><%=Html.checkBox("wn_dealloc_sel_" + i, false, null, wn.isCompleted()?"disabled":"")%></td>
                <td  align="center"><img src="../shared/images/detail.gif" onClick="setValue('wn_dealloc_id',<%=wn.getIdLong()%>); doPost();" style="display:<%=displayed%>"></td>
			  </tr>
  		  		<input type="hidden" name="wn_dealloc_id_<%=i%>"  id="wn_dealloc_id_<%=i%>"  value="<%=wn.getIdLong()%>">	

			<%
				List<WnrAllocationEntity> wnas = task.get_Allocated_WNRs();
				for (int j = 1; j <= wnas.size(); j++) {
					WnrAllocationEntity wna = wnas.get(j-1);
					WnrEntity wnr = wna.getWnr();
			%>
              <tr align="right" onClick="highlightOn(this)">
                <td>&nbsp;</td>
                <td align="right"><strong><%=wna.getIdLong()%></strong>&nbsp;</td>
				<td align="center"><%=DateTime.dateToStr(wna.date_out)%></td>
                <td align="left"><%=wnr.getRefNumber()%></td>
                <td ><%=Numeric.numberToStr(wnr.net_weight/1000)%></td>
                <td >&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center"><%=Html.checkBox("wnr_dealloc_sel_" + j, false, null, wna.isCompleted()?"disabled":"")%></td>
                <td align="center">&nbsp;</td>
              </tr>
			  	<input type="hidden" name="wnr_dealloc_id_<%=j%>"  id="wnr_dealloc_id_<%=j%>"  value="<%=wna.wnr_id%>">	
			<%
				}
			%>			
<%
	}
%>			  
			<tr bgcolor="#DDDDDD" class="style11" style="font-weight:bold" align="right">
			  <td colspan="4" align="center">Estimated XP in %</td>
			  <td align="right">100%</td>
			  <td align="right">&nbsp;</td>
			  <td><%=Numeric.getPercent(av.getPercent().black,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().sound,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().foreign_matter,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().broken,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().moisture,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().withered,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().sc18,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().sc17,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().sc15,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().sc12,"&nbsp;")%></td>
			  <td><%=Numeric.getPercent(av.getPercent().below_sc12,"&nbsp;")%></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  </tr>
			<tr bgcolor="#DDDDDD" class="style11" style="font-weight:bold" align="right">
				<td colspan="4" align="center">Estimated XP in Mts</td>
				<td align="right" id="total_allocated_tons__"><%=Numeric.numberToStr(sum.allocated_weight/1000)%></td>
				<td align="right" id="total_allocated_bags__"><%=Numeric.numberToStr(sum.allocated_bags,0)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().black)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().sound)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().foreign_matter)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().broken)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().moisture)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().withered)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().sc18)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().sc17)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().sc15)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().sc12)%></td>
				<td><%=Numeric.numberToStr(av.getVolume().below_sc12)%></td>
				<td>&nbsp;</td>
			    <td>&nbsp;</td>
			  </tr>
            </table></td>
      </tr>
		  <tr style="display:<%=displayed%>">
		    <td align="center"><img src="../shared/images/update.gif" width="15" height="15" onClick="save_UnAllocation()" title="Start Deallocation"></td>
          </tr>
		  <tr>
		    <td align="right"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><img src="../shared/images/backicon.gif" width="18" height="18" onClick="goBack()"></td>
                <td align="right">
					<img src="../shared/images/wnr.jpg" width="55" height="18" onClick="doTask(4)">
					<img src="../shared/images/print.jpg" width="55" height="18" onClick="doTask(2)">
					<img src="../shared/images/listview.jpg" width="55" height="18" onClick="setValue('view',0);doPost();">
				</td>
              </tr>
            </table>		      </td>
      </tr>
  </table>
	<input type="hidden" name="wn_alloc_id"   id="wn_alloc_id"   value="<%=requester.getLong("wn_alloc_id")%>"> 
	<input type="hidden" name="wn_dealloc_id" id="wn_dealloc_id" value="<%=requester.getLong("wn_dealloc_id")%>"> 

	<input type="hidden" name="search_field"   id="search_field"    value="ref_number">	
	

<script language="javascript">
	setText("total_allocated_tons_","<%=Numeric.numberToStr(sum.allocated_weight/1000)%>");
</script>

