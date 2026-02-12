<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.trade.Hedge task = user.getBiz().getTrade().hedge;
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";			
%>


<%@include file="header.jsp"%>

<script language="JavaScript" src="trade.js"></script>
<%
	//if (sc.terminal_market_id <= 0) sc.terminal_market_id = Const.LIFFE;
	//sc.quality_id = (sc.terminal_market_id == Const.LIFFE ? Const.ROBUSTA : Const.ARABICA);
	if (sc.quality_id <= 0) sc.quality_id = 2;
	task.doTask();
%>
<form method="POST" name="formMain">				
	<%@include file="posted-fields.jsp"%>	

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
		<td width="120" align="right">Hedge Type &nbsp;</td>
        <td width="120"><select name="type" id="type" size=1 class="style2" style="width:100%;" onChange="doPost();">
              <option value="P" <%=sc.type=='P'?"selected":""%>>Purchase</option>
              <option value="S" <%=sc.type=='S'?"selected":""%>>Sale</option>
            </select></td>
        <td width="120" align="right">Terminal Market &nbsp;</td>
        <td width="120"><select name="quality_id" id="quality_id" size=1 class="style11" style="width:100%;" onchange="doPost()"><%=Html.selectOptions(dao.getQualityDao().listByTerminalMarket(),sc.quality_id)%></select></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>

<%	if (sc.isListView()) {%><%@include file="trade.hedge.list-view.jsp"%><%}%>
<%	if (sc.isCardView()) {%><%@include file="trade.hedge.card-view.jsp"%><%}%>

	<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">

</form>


<%@include file="footer.jsp"%>

