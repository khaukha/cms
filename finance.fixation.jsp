<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.finance.Fixation task = user.getBiz().getFinance().fixation;
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";	
%>


<%@include file="header.jsp"%>

<form method="POST" name="formMain" action="" onSubmit="">

<%@include file="posted-fields.jsp"%>	

<%
	FixationLetterEntity fixation = task.doTask();
	PurchaseContractEntity contract = fixation.getContract();
	List<PurchaseContractEntity> cts = task.getContracts();
%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td class="style1"><img src="images/fixation.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>


<%if (sc.isListView()) {%><%@include file="finance.fixation.list-view.jsp"%><%}%>
<%if (sc.isCardView()) {%><%@include file="finance.fixation.card-view.jsp"%><%}%>

<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">

</form>

<%@include file="footer.jsp"%>

