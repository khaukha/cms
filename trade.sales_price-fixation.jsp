<div style="border-style:solid; border-width:1; width:auto">
<table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
	<tr bgcolor="#DDDDDD">
       <th width="40"><img src="../shared/images/refresh.gif" style="cursor:pointer" onclick="doPost()"></th>
       <th width="96">Fixation<br />Date</th>
       <th width="40">Lots</th>
       <th width="72">Tons</th>
       <th width="72">Hedge<br>Price</th>
       <th width="72">Differential</th>
       <th width="72">Base<br />Currency</th>
       <th width="72">Exchange<br />Rate</th>
       <th width="72">Price<br />USD</th>
       <th width="90">Price<br /><%=location.currency%></th>
       <th>&nbsp;</th>
	</tr>
<%	
	List<PriceFixationEntity> fxs = contract.getPriceFixations();
	PriceFixationEntity sfx = dao.getSalesPriceFixationDao().newEntity();
	for (int i = 0; i < fxs.size(); i++) {
		PriceFixationEntity fx = fxs.get(i);	
		sfx.add(fx);
%>	
          <tr align="right">
            <th bgcolor="#EEEEEE"><%=fx.getIdLong()%></th>
            <td align="center"><%=DateTime.dateToStr(fx.fixation_date)%></td>
            <td><%=fx.no_of_lots%>&nbsp;</td>
            <td><%=Numeric.numberToStr(fx.tons)%>&nbsp;</td>
            <td><%=Numeric.numberToStr(fx.hedge_price,2)%>&nbsp;</td>
            <td><%=Numeric.numberToStr(contract.differential_price,2)%>&nbsp;</td>
            <td align="center"><%=fx.base_currency%></td>
            <td><%=Numeric.numberToStr(fx.exchange_rate,0)%>&nbsp;</td>
            <td><%=Numeric.numberToStr(fx.contract_price,2)%>&nbsp;</td>
            <td><%=Numeric.numberToStr(fx.contract_price_local,_dec)%>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
<%
	}
%>
          <tr align="right" bgcolor="#DDDDDD">
            <td>&nbsp;</td>
            <th align="center">Total</th>
            <th><%=sfx.no_of_lots%>&nbsp;</th>
            <th><%=Numeric.numberToStr(sfx.tons)%>&nbsp;</th>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
	
</table>
</div>