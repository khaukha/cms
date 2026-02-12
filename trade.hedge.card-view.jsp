
<script language="javascript">

getObj("main_window").width = "";
var terminal_market_id = <%=sc.terminal_market_id%>;
var readonly = <%=task.isReadOnly()%>;

function saveHedging(no)
{
	if (readonly) {
		alert("You can not update this item.");
		return;
	}
	if (getValue("terminal_month_" + no) == "") {
		alert("Please select Terminal Month");
		return;
	}
	setValue("no",no);
	doTask(1);
}

function deleteHedging(no)
{
	if (readonly) {
		alert("You can not delete this item.");
		return;
	}
	if (confirm("Are you sure to delte this item?")) {
		setValue("no",no);
		doTask(2);
	}
}

function newHedging()
{
	show("hedging_");
}

function rowClicked(row,contract_id)
{
	highlightOn(row);
}
</script>
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr>
		<td width="120" valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr bgcolor="#DDDDDD">
				<th>Fixation Date</th>
			</tr>
			<tr>
				<td valign="top"><select name="fixation_date" id="fixation_date" size=24 class="style2" style="width:100%;" onchange="doPost();"><%=Html.selectOptions(task.getFixationDateList(),sc.fixation_date,"None")%></select></td>
			</tr>
		</table></td>
		
		<td valign="top"><table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
			<tr bgcolor="#DDDDDD">
				<th>Details</th>
			</tr>
			<tr>
				<td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
						<tr bgcolor="#DDDDDD">
           					<th width="40"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
           					<th width="96">Fixation<br />Date</th>
           					<th width="80">Location</th>
           					<th width="100">Contract Ref.</th>
           					<th width="96">Quality</th>
           					<th width="80">Terminal<br />Month</th>
           					<th width="80">Fixed Mts</th>
           					<th id="sum_fixation">&nbsp;</th>
						</tr>
					</table></td>
			</tr>
			<tr>
				<td><div style="overflow:scroll; height:150px; width:100%; border-width:1; border-style:solid">
					<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
<%
	List<PriceFixationEntity> fxs = task.getFixations();
	double fixed_tons = 0;
	for (int i = 0; i < fxs.size(); i++) {
		PriceFixationEntity fx = fxs.get(i);		
		ContractEntity ct = fx.getContract();
		if (ct.isNull()) {
			fx.delete();
			continue;
		}
		if (ct.isCancelled() || !ct.isActive()) continue;
		fixed_tons += fx.tons;
%>						
						<tr onClick="highlightOn(this)">
							<td width="40" align="right"><%=i+1%>&nbsp;</td>
							<td width="96" align="center"><%=DateTime.dateToStr(fx.fixation_date)%></td>
							<td width="80"><%=fx.getLocation().short_name%></td>
							<td width="100"><%=ct.getRefNumber()%></td>
							<td width="96"> <%=ct.getGrade().getQuality().short_name%></td>
							<td width="80" align="center"><%=DateTime.dateToTerminalMonth(ct.terminal_month)%></td>
							<th width="80" align="right"><%=Numeric.numberToStr(fx.tons,3)%>&nbsp;</th>
							<td>&nbsp;</td>
						</tr>
<%
	}
%>						
					</table>
				</div>
				</td>
			</tr>
			<tr>
				<td><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
						<tr bgcolor="#DDDDDD">
							<th width="40" rowspan="2"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
							<th width="96" rowspan="2">Hedge Date</th>
							<th colspan="3">Hedge</th>
							<th width="80" rowspan="2">Terminal<br />Month</th>
							<th width="240" rowspan="2">Remark</th>
							<th width="80" rowspan="2"><a href="javascript:newHedging()" style="display:<%=displayed%>">New</a></th>
							<th width="80" rowspan="2" id="sum_hedge">&nbsp;</th>
							<th rowspan="2">&nbsp;</th>
						</tr>
						<tr bgcolor="#DDDDDD">
						  <th width="40">Lots</th>
					      <th width="60">Mts</th>
					      <th width="80">Level</th>
					  </tr>
					</table></td>
			</tr>
			<tr>
				<td><div style="overflow:scroll; height:150px; width:100%; border-width:1; border-style:solid">
					<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
<%
	List<HedgingEntity> hedgings = task.getHedgings();
	HedgingEntity hed = dao.getHedgingDao().newEntity();
	hed.hedge_date = sc.fixation_date;
	hedgings.add(0,hed);
	double hedge_lots = 0;
	List<OptionEntity> tms = Terminal.getListByDate(sc.quality_id, sc.fixation_date, 6);
	
	for (int i = 0; i < hedgings.size(); i++) {
		HedgingEntity hedging = hedgings.get(i);
		hedge_lots += hedging.hedge_lots;
%>					
						<input type="hidden" name="hedge_id_<%=i%>"  id="hedge_id_<%=i%>"  value="<%=hedging.getIdLong()%>" />
						<tr id="<%=hedging.isNull()?"hedging_":""%>" style="display:<%=hedging.isNull()?"none":""%>">
							<td width="40" align="right"><%=hedging.isNull()?"New":""+i%>&nbsp;</td>
							<th width="96"><%=Html.datePicker("hedge_date_" + i,hedging.hedge_date)%></th>
							<td width="40"><input type="text" name="hedge_lots_<%=i%>" id="hedge_lots_<%=i%>" class="style2" style="width:40; text-align:right" value="<%=Numeric.numberToStr(hedging.hedge_lots,0)%>"  /></td>
							<th width="60" align="right"><%=Numeric.numberToStr(hedging.getHedgeTons(),2)%>&nbsp;</th>
							<td width="80"><input type="text" name="hedge_price_<%=i%>" id="hedge_price_<%=i%>" class="style2" style="width:80; text-align:right" value="<%=Numeric.numberToStr(hedging.hedge_price,2)%>"  /></td>
							<th width="80"><select name="terminal_month_<%=i%>" id="terminal_month_<%=i%>" class="style2" style="width:80"><%=Html.selectOptions(tms, hedging.terminal_month)%></select></th>
							<th width="240"><input type="text" name="remark_<%=i%>" id="remark_<%=i%>" class="style2" style="width:100%;" value="<%=hedging.remark%>"  /></th>
							<th width="80"><a href="javascript:saveHedging(<%=i%>)" style="display:<%=displayed%>">Save</a></th>
							<th width="80"><a href="javascript:deleteHedging(<%=i%>)" style="display:<%=displayed%>">Delete</a></th>
							<td>&nbsp;</td>
						</tr>
<%
	}
%>						
					</table>
				</div></td>
			</tr>
			<tr>
				<td><table width="100%">
					<tr>
						<td align="right"><img src="../shared/images/listview.jpg" title="Back To List View Screen" onClick="doListView();"></td>
					</tr>
				</table></td>
			</tr>
		</table></td>
	</tr>
</table>

	<input type="hidden" name="no"  id="no"  value="0">
	

<script language="javascript">
	if (readonly) {
		//setCompletedElements("terminal_market_id");
	}
	setValue("view",1);
	setText("sum_fixation","<%=Numeric.numberToStr(fixed_tons,3)%>");
	setText("sum_hedge","<%=Numeric.numberToStr(hedge_lots,0)%>");
</script>