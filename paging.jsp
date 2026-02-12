<script language="javascript">
var cur_page = <%=paging.page_no%>;
var last_page = <%=paging.page_count%>;
function goTo(page_no)
{
	if (page_no >= 1 && page_no <= last_page) {
		setValue("page_no", page_no);
		doTask(202);
	}	
}

function goBack()
{
	goTo(cur_page - 1);
}

function goNext()
{
	goTo(cur_page + 1);
}
</script>
<input type="hidden" name="page_no" id="page_no"  value="<%=paging.page_no%>">
<table id="paging_navigator" cellpadding="0" cellspacing="0" class="style2" style="display:<%=sc.isSearchValid()?"none":""%>">
  <tr align="center">
    <td width="45">&nbsp;<a style="display:<%=paging.isFirstPage()||paging.page_count==0?"none":""%>" href="JavaScript:goBack()">Back</a>&nbsp;</td>
<%
	for (int i = paging.from_page; i <= paging.to_page; i++) {
		//String style = paging.isPage(i) ? "font-weight:bold" :"";
		String style = paging.isPage(i) ? "font-weight:bold;color:#FF0000":"";
%>
	<td width="">&nbsp;&nbsp;<a style="<%=style%>" href="JavaScript:goTo(<%=i%>)"><%=i%></a>&nbsp;&nbsp;</td>
<%
	}
%>	
    <td width="45">&nbsp;<a style="display:<%=paging.isLastPage()||paging.page_count==0?"none":""%>" href="JavaScript:goNext()">Next</a>&nbsp;</td> 
  </tr>
</table>