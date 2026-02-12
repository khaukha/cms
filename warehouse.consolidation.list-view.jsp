<%
	task.doTask(null);
%>
<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

var table = 'warehouse.allocation';

getObj("main_window").width = "";

function doCardView()
{
	setValue("view",1);
	doPost();
}

function doReport()
{
	doTask(6);
}

function wnDblClicked(row,wnc_id)
{
	if (wnc_id != null) { 
		setValue("wnc_id",wnc_id);
	}
	setValue("view",1);
	doTask()
}

</script>
		  
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td><img src="images/consolidation.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style11">
          <tr bgcolor="#EEEEEE">
            <th width="100">Status</th>
            <th width="150">Warehouse</th>
            <th width="100">Area</th>
            <th width="250">Grade</th>            
            <th>&nbsp;</th>
            </tr>
          <tr>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_warehouse_id" id="filter_warehouse_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(user.selectWarehouse(),sc.filter_warehouse_id,"All")%></select></td>
            <td><select name="filter_area_id" id="filter_area_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getAreaDao().getByWarehouseId(sc.warehouse_id),sc.filter_area_id,"All")%></select></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getWnConsolidationDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
             <td><select name="filter_date" id="filter_date" size=7 class="style11" style="width:100%;" onChange="doPost();"><%//=Html.selectOptions(alloc_class.selectDateFilter(),requester.getDate("filter_date",DateTime.NullDate),"All")%></select></td>
            </tr>
</table>

	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="30" rowspan="2" onClick="doPost()"><img src="../shared/images/refresh.gif"></th>
                  <th width="120" rowspan="2">WN  Ref</th>
                  <th width="150" rowspan="2">Grade</th>
                  <th width="100" rowspan="2">Whse</th>
                  <th width="60" rowspan="2">Area</th>
                  <th width="80" rowspan="2">Packing</th>
                  <th width="70" rowspan="2">Completed<br />Date</th>
                  <th colspan="2">In</th>
                  <th colspan="2">Out</th>
                  <th colspan="2">Balance</th>
                  <th width="70" rowspan="2">W.Loss</th>
                  <th width="" rowspan="2">&nbsp;</th>
                </tr>
                <tr align="center" bgcolor="#DDDDDD">
                  <th width="60">Bags</th>
                  <th width="70">Mts</th>
                  <th width="60">Bags</th>
                  <th width="70">Mts</th>
                  <th width="60">Bags</th>
                  <th width="70">Mts</th>
                </tr>
	</table>

<div id="consolidation_list_view" style="overflow:scroll; height:250px; width:100%;"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
<%
	List<WnConsolidationEntity> wns = dao.getWnConsolidationDao().getPaging().paging();
	WnConsolidationEntity sum = dao.getWnConsolidationDao().getPaging().sumary();
	double sum_wl = 0;
	for (int i = 0; i < wns.size(); i++) {
		WnConsolidationEntity wn = wns.get(i);
		double wl = 0;
		if (wn.isCompleted()) {
			wl = wn.stock_weight;
			wn.stock_weight = 0;
		} else {
			wn.completed_date = null;
		}
		sum_wl += wl;
		sum.add(wn);
		//if (i >= 200) continue;
		String color = Action.getColor(wn.status);
		if (wn.stock_weight < 0) {
			color = "#FF0000";
		}
%>				
                <tr style="font-size:11px" onClick="highlightOn(this);" onDblClick="wnDblClicked(this,<%=wn.getIdLong()%>)">
                  <td width="30" align="right" bgcolor="#DDDDDD"><%=wn.getIdLong()%></td>
                  <td width="120" style="color:<%=color%>"><%=wn.getRefNumber()%></td>
                  <td width=""><%=wn.getGrade().short_name%></td>
                  <td width="100"><%=wn.getArea().getWarehouse().short_name%></td>
                  <td width="60" align="center"><%=wn.getArea().short_name%></td>
                  <td width="80"><%=wn.getPacking().short_name%></td>
                  <td width="70" align="center"><%=DateTime.dateToStr(wn.completed_date)%></td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.no_of_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.net_weight/1000)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.allocated_bags,0)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wn.allocated_weight/1000)%>&nbsp;</td>
                  <td width="60" align="right"><%=Numeric.numberToStr(wn.stock_bags,0)%>&nbsp;</td>
                  <td width="70" align="right" style="color:<%=color%>"><%=Numeric.numberToStr(wn.stock_weight/1000)%>&nbsp;</td>
                  <td width="70" align="right"><%=Numeric.numberToStr(wl/1000)%>&nbsp;</td>
                </tr>
<%
	}
%>				
</table></div>

	<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style11">
                <tr align="right" bgcolor="#DDDDDD">
                  <th width="30">&nbsp;</th>
                  <th width="">Total</th>
                  <th width="60"><%=Numeric.numberToStr(sum.no_of_bags,0)%>&nbsp;</th>
                  <th width="70"><%=Numeric.numberToStr(sum.net_weight/1000)%>&nbsp;</th>
                  <th width="60"><%=Numeric.numberToStr(sum.allocated_bags,0)%>&nbsp;</th>
                  <th width="70"><%=Numeric.numberToStr(sum.allocated_weight/1000)%>&nbsp;</th>
                  <th width="60" align="right"><%=Numeric.numberToStr(sum.stock_bags,0)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum.stock_weight/1000)%>&nbsp;</th>
                  <th width="70" align="right"><%=Numeric.numberToStr(sum_wl/1000)%>&nbsp;</td>
                  <th width="16" align="right">                  
                </tr>
	</table>

<div id="consolidation_report" style="display:none"><%@include file="report.parameter.jsp"%></div>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
		 <td align="center"><%@include file="paging.jsp"%></td>
          <td width="60" align="right"><img style="display:" src="images/report.jpg" width="55" height="18" onClick="doReport();"></td>
    	  <td width="60" align="right"><img src="../shared/images/cardview.jpg" width="55" height="18" onClick="doCardView();"></td>
        </tr>
</table>
	<input type="hidden" name="inst_id" id="inst_id"  value="0">
	<input type="hidden" name="wnc_id" id="wnc_id"  value="0">
	<input type="hidden" name="search_field"   id="search_field"    value="ins.ref_number">	

