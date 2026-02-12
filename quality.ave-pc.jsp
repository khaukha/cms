
<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.quality.AVE_PC task = user.getBiz().getQuality().getAvePC();
	task.getOwner().clearFocus();
	task.setFocus(true);
%>

<%@include file="header.jsp"%>

<%
	String displayed   = task.isReadOnly() ? "none" : "";	
	String readonly  = "readonly";

	PaymentEntity payment = task.getPayment();
	task.doTask(payment);

	QualityReportEntity  quality_report = payment.getQualityReport();
	PurchaseContractEntity contract = payment.getContract();
	average = true;
	sc.view = 1;

	String disabled  = task.isReadOnly() || payment.getDiscount().isCompleted() ? "disabled" : "";
%>

<link href="style.css" rel="stylesheet" type="text/css">

<script language="javascript">

getObj("main_window").width = "";

var can_update = <%=!task.isReadOnly()%>;
var busy = false;

function doCheck(cbx,i)
{
	if (busy) {
		return;
	}
	busy = true;
	setValue("no",i);
	doTask(1);
}

function unCheck(cbx,i)
{
	setValue("no",i);
	doTask(3);
}
	
function newPayment()
{
	var contract_id = getValue("contract_id");
	if (contract_id == 0) {
		alert("Please select a contract.");
		return;
	}	
	if (addNewListItemById("payment_id","New Payment For P.Contract") >= 0) {
		doPost();
	}
}

function deletePayment()
{
	if (getValue("payment_id") == 0) {
		alert("Please select a Payment");
		return;
	}

	if (!can_update) {
		alert("You do not have permisstion to modify the data.");
		return;
	}

	if ( confirm("Are you sure to delete " + getSelectedText("payment_id")) ) {
		if (getValue("payment_id") < 0) {
			setValue("payment_id", 0);
			doPost();
			return;
		} 
		doTask(5);
	}
}

function savePayment()
{
	if (<%=payment.getDiscount().isCompleted()%>) {
		alert("This payment already completed.");
		return;
	}
	doTask(4);
}	

</script>
<form method="POST" name="formMain" action="" target="">
	<%@include file="posted-fields.jsp"%>

<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
      <tr>
        <td><img src="images/ave-pc.jpg"></td>
		<td align="right"><%@include file="search.jsp"%></td>
      </tr>
</table>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
	<tr>
		<td width="270" valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
		  <tr bgcolor="#EEEEEE">
            <th width="120">Contract Ref.</th>
            <th>Payment Ref.</th>
          </tr>
          <tr>
            <td><select name="contract_id" id="contract_id" size="24" class="style11" style="width:100%;" onChange="setValue('payment_id',0);itemSelected(this)"><%=Html.selectOptionsX(dao.getPurchaseContractDao().getList(),sc.contract_id,"All")%></select></td>
            <td valign="top"><select name="payment_id" size=24 class="style11" id="payment_id" style="width:100%;" onChange="doPost()"><%=Html.selectOptionsX(dao.getPaymentDao().list(false),payment.getIdLong(),"All")%></select></td>
          </tr>
          <tr style="display:<%=displayed%>">
            <td>&nbsp;</td>
            <td><img src="../shared/images/new.gif" border="0" width="15" height="15" onClick="newPayment()">
			<img src="../shared/images/delete.gif" width="15" height="15" border="0" onClick="deletePayment()"></td>
          </tr>
        </table></td>
		<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
            <tr>
              <td><table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
          <tr bgcolor="#EEEEEE">
            <th>Status</th>
            <th>Supplier</th>
            <th>Quality</th>
            <th>Grade</th>
          </tr>
          <tr>
            <td><select name="filter_status" id="filter_status" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getStatusDao().selectAll(),sc.filter_status,"All")%></select></td>
            <td><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter(),sc.filter_seller_id,"All")%></select></td>
            <td><%@include file="inc/filter.quality.jsp"%></td>
            <td><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
          </tr>
        </table></td>
            </tr>
			<tr>
				<td><div style="width:100%;border:thin; border-style:solid; border-width:1; border-right:none" align="center">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
					<tr bgcolor="#DDDDDD" align="left">
					  <th width="120">Contract Ref.</th>
					  <th width="120">Supplier</th>
					  <th width="">Grade</th>
				  </tr>
					<tr align="left">
						<th><%=contract.getRefNumber()%></th>
						<th><%=contract.getSeller().short_name%></th>
						<th><%=contract.getGrade().short_name%></th>
					</tr>
				</table>				
				</div></td>
			</tr>

			<tr>
				<td><strong>Available Weight Notes</strong></td>
			</tr>
			
			<tr>
				<td><div style="width:100%;border:thin; border-style:solid; border-width:1; border-right:none" align="center">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
					<tr bgcolor="#DDDDDD">
					  	<th width="128">WN Ref.</th>
					  	<th width="62">Date</th>
					  	<th width="60">Net</th>
	    			  	<th width="52">BB</th>
						<th width="52">Brown</th>
	    				<th width="52">Excel.</th>
	    				<th width="52">Cherry</th>
	    				<th width="52">FM</th>
	    				<th width="52">Moist.</th>
	    				<th width="52">Moldy</th>
	    				<th width="52">SC.18</th>
	    				<th width="52">SC.17</th>
	    				<th width="52">SC.15</th>
	    				<th width="52">SC.12</th>
	    				<th width="52">SC12-</th>
						<th width="20">&nbsp;</th>
				  </tr>
<%
	//List<WnImportEntity> wns = task.getUnpaidWeightNotes(payment);
	List<WnImportEntity> wns = contract.getWeightNotes();
	double sum = 0;
	for (int i = 0; i < wns.size(); i ++) {
		WnImportEntity wn = wns.get(i);
		if (wn.status != 2 || wn.payment_id != 0) continue;
		String dis = payment.getIdLong() == 0 || wn.net_weight == 0 ? "disabled" : disabled;
		QualityReportEntity qr = wn.getQualityReport();
		sum += wn.net_weight;
%>				  
				  
					<input type="hidden" name="wn_sel_id_<%=i%>" id="wn_sel_id_<%=i%>" value="<%=wn.getIdLong()%>">
					<tr align="right">
						<td align="left"><%=wn.getRefNumber()%></td>
						<td align="center"><%=DateTime.dateToStr(wn.date)%></td>
						<td><%=Numeric.numberToStr(wn.net_weight/1000)%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.getBlackBroken(),"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sound,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.floats,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.cherry,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.foreign_matter,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.moisture,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.moldy,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sc19 + qr.sc18,"")%></td>
	    				<td><%=Numeric.getPercent(qr.sc17,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sc16 + qr.sc15,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sc14 + qr.sc13 + qr.sc12,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.below_sc12,"")%>&nbsp;</td>
                    	<td align="center"><%=Html.checkBox("wn_sel_" + i,false,String.format("doCheck(this,%d)", i),dis)%></td>
					</tr>
<%
	}
%>					
				</table>				
				</div></td>
			</tr>

			<tr>
				<td><table width="100%" border="0" cellpadding="0" class="style2">
					<tr>
						<th align="left">Weight Notes For Payment</th>
						<th align="right"><%=user.getMessage()%>&nbsp;</th>
					</tr>
				</table></td>
			</tr>

			<tr>
				<td><div style="width:100%;border:thin; border-style:solid; border-width:1; border-right:none;" align="center">
			  	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="style2">
					<tr bgcolor="#DDDDDD">
					  	<th width="128">WN Ref.</th>
					  	<th width="62">Date</th>
					  	<th width="60">Net</th>
	    			  	<th width="52">BB</th>
						<th width="52">Brown</th>
	    				<th width="52">Excel.</th>
	    				<th width="52">Cherry</th>
	    				<th width="52">FM</th>
	    				<th width="52">Moist.</th>
	    				<th width="52">Moldy</th>
	    				<th width="52">SC.18</th>
	    				<th width="52">SC.17</th>
	    				<th width="52">SC.15</th>
	    				<th width="52">SC.12</th>
	    				<th width="52">SC12-</th>
						<th width="20">&nbsp;</th>
				  </tr>
<%
	wns = payment.getWeightNotes();
	sum = 0;
	for (int i = 0; i < wns.size(); i ++) {
		WnImportEntity wn = wns.get(i);
		QualityReportEntity qr = wn.getQualityReport();
		sum += Numeric.round(wn.net_weight,1);
%>				  
					<input type="hidden" name="wn_unsel_id_<%=i%>" id="wn_unsel_id_<%=i%>" value="<%=wn.getIdLong()%>">
					<tr align="right" bgcolor="#CCFFFF">
						<td align="left"><%=wn.getRefNumber()%></td>
						<td align="center"><%=DateTime.dateToStr(wn.date)%></td>
						<td><%=Numeric.numberToStr(wn.net_weight/1000)%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.getBlackBroken(),"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sound,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.floats,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.cherry,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.foreign_matter,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.moisture,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.moldy,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sc19 + qr.sc18,"")%></td>
	    				<td><%=Numeric.getPercent(qr.sc17,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sc16 + qr.sc15,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.sc14 + qr.sc13 + qr.sc12,"")%>&nbsp;</td>
	    				<td><%=Numeric.getPercent(qr.below_sc12,"")%>&nbsp;</td>
						<td align="center"><%=Html.checkBox("wn_unsel_" + i,wn.payment_id != 0,String.format("unCheck(this,%d)",i),disabled)%></td>
					</tr>				
<%
	}
	QualityReportEntity qr = quality_report;
%>					  
					<tr bgcolor="#DDDDDD" style="font-weight:bold; color:#0000FF" align="right">
						<td colspan="2" align="center">Quality Average</td> 
						<td align="right"><%=Numeric.numberToStr(payment.tons,4)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.getBlackBroken(),2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.sound,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.floats,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.cherry,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.foreign_matter,4)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.moisture,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.moldy,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.sc19 + qr.sc18,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.sc17,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.sc16 + qr.sc15,2)%>&nbsp;</td>
	    				<td><%=Numeric.numberToStr(qr.sc14 + qr.sc13 + qr.sc12,2)%>&nbsp;</td>
	  					<td><%=Numeric.numberToStr(qr.below_sc12,2)%>&nbsp;</td>
						<td>&nbsp;</td>
				</tr>
				</table>
				</div></td>
			</tr>
			
			<tr>
				<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
  <tr>
    <td><strong>Quality Average &nbsp; <%=quality_report.getRefNumber()%></strong></td>
	<td align="right" style="display:none">Payment Date&nbsp;</td>
	<td width="92" style="display:none"><%=Html.datePicker("delivery_date",payment.delivery_date)%></td>
    <td width="60" align="right"><a href="JavaScript:savePayment()" class="style2" style="display:<%=displayed%>">Update</a> &nbsp;&nbsp;</td>
  </tr>
</table>
				</td>
			</tr>
            <tr>
              <td><%@include file="quality.qr.input.jsp"%></td>
            </tr>
			<tr>
				<td align="right"><img src="../shared/images/print.jpg" width="55" height="18" border="0" onClick="doTask(2)"></td>
			</tr>			
          </table></td>
	</tr>
	
</table>

	<input type="hidden" name="no" id="no" value="-1">		
	<input type="hidden" name="search_field"   id="search_field"    value="ct.ref_number">	
</form>

<script language="javascript">
	hide("inspector_input");
	hide("completed_input");
    setValue("view",1);
    hide('cup_test_input');
	if (!can_update) 
	{
		hide("update_btn");
    }
	
	setCbxById("completed_");
	if (<%=payment.isNew()%>) {	
		var idx = addNewListItem(document.formMain.payment_id,"<%=payment.getRefNumber()%>");
      	setValue("delivery_date","<%=DateTime.dateToStr(DateTime.getCurDate())%>");		
	}

	//getObj("main_window").width = "1000";

	if (<%=task.isReadOnly()%>) {
		//setCompletedElements("contract_id","payment_id");
	}

</script>

<%@include file="../footer.jsp"%>
