<div style="border:thin; border-style:solid; border-width:1; width:1000px; height:150px;" align="left">
<br />
<label id="report_text" style="font-weight:bold;" class="style2">&nbsp;&nbsp;&nbsp;&nbsp;Submit more information for creating report</label>&nbsp;&nbsp;<label id="report_filter" style="font-weight:bold;" class="style2">&nbsp;</label>
<br />
			  <table width="100%"  border="0" class="style2" cellspacing="1" cellpadding="0">
                
                <tr style="padding-top:12px">
                  <td width="10">&nbsp;</td>
                  <th width="150" align="right"><label id="from_date_label">From Date</label> &nbsp;</th>
                  <td width="100"><%=Html.datePicker("report_date_from",requester.getDate("report_date_from"))%></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <th align="right"><label id="from_date_label">To Date</label> &nbsp;</th>
                  <td><%=Html.datePicker("report_date_to",requester.getDate("report_date_to"))%></td>
                  <td>&nbsp;</td>
                </tr>
                
                <tr id="date_type_" style="display:none">
                  <td>&nbsp;</td>
                  <th align="right">Date Type &nbsp;</th>
                  <td><select name="date_type" id="date_type" class="style2" style="width:120;">
              			<option value="C" <%=sc.date_type=='C'?"selected":""%>>Contract Date</option>
						<option value="P" <%=sc.date_type=='P'?"selected":""%>>Payment Date</option>
            		</select></td>
                  <td>&nbsp;</td>
                </tr>
                
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>
				  	<img src="images/update.gif" width="15" height="15" onClick="doGenerateReport();" title="Begin generating report.">&nbsp;
				  	<img src="images/delete.gif" width="15" height="15" onClick="cancelGenerateReport();" title="Close">				  </td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
		    </table>
</div>