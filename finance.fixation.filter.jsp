<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="style2">
          <tr bgcolor="#DDDDDD" align="center" style="font-weight:bold">
            <th>Fixation</th>
			<th width="250">Supplier</th>
            <th width="250">Grade</th>
            <th>Fixation Date </th>
		  </tr>
			<tr>
			  <td valign="top"><%@include file="inc/filter.fixation.jsp"%></td>
              <td valign="top"><select name="filter_seller_id" id="filter_seller_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getSellerFilter('T'),sc.filter_seller_id,"All")%></select></td>
             <td valign="top"><select name="filter_grade_id" id="filter_grade_id" size=7 class="style11" style="width:100%;" onChange="doPost();"><%=Html.selectOptions(dao.getPurchaseContractDao().getGradeFilter(),sc.filter_grade_id,"All")%></select></td>
            <td valign="top"><select name="filter_date" id="filter_date" size=7 class="style11" style="width: 100%;" onChange="doPost()"><%=Html.selectOptions(dao.getPriceFixationDao().selectDateFilter(),sc.filter_date,"All")%></select></td>
		  </tr>
</table>