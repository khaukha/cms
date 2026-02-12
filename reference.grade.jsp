
<%
    User user = CMS.getUser(pageContext);
	ibu.ucms.biz.reference.Grade task = user.getBiz().getReference().getGrade();	
	task.getOwner().clearFocus();
	task.setFocus(true);
	String displayed = task.isReadOnly() ? "none" : "";	
%>

<%@include file="header.jsp"%>

<%
	GradeEntity grade = task.getGrade();
	task.doTask(grade);
	QualityDiscountEntity qa = grade.getQualityDiscount();
	String qa_readonly = "readonly";
%>

<link href="style.css" rel="stylesheet" type="text/css">
<script language="javascript">

getObj("main_window").width = "1000";

function doAddNew(id)
{
	if (getValue("quality_id") == 0) 
	{
		alert("Please select an quality value.");
		return;
	}
	if (addNewListItemById("grade_id","New Grade") >= 0) 
	{
		doPost();
	}
}

function doDelete()
{
	var id = "grade_id";
	var s = "Are you sure to delete item: " + getSelectedText(id) + " (" + getSelectedValue(id) + ")";
	if (confirm(s) == 1) 
	{
		doTask(3);
	}	
}

function saveGrade()
{
	if (getValue("grade_id") == 0) {
		alert("Please select item to save.");
		return;
	}
	doTask(1);
}
</script>
<img src="images/grade-list.jpg">
<form method="POST" name="formMain" action="" onSubmit="">				
<table width="100%"  border="0" cellspacing="1" cellpadding="0" class="style2">
	<tr bgcolor="#EEEEEE">
		<th width="220">Grade</th>
		<th width="600">Detail</th>
		<td>&nbsp;</td>
	</tr>
	<tr valign="top">
		<td><select name="grade_id" id="grade_id" size=24 class="style2" style="width:220" onChange="doPost();"><%=Html.selectOptions(dao.getGradeDao().filterByQuality(sc.quality_id),grade.getIdInt(),"Select Grade")%></select></td>
		<td><!-- BEGIN --><div style="border:thin; border-style:solid; border-width:1; width:100%; height:272; padding-top:60"><table width="100%"  border="0" cellpadding="0" cellspacing="1" class="style2">
              <tr>
                <td width="150" align="right">ID</td>
                <td width="500"><strong><%=grade.getIdInt()%></strong></td>
				<td width="">&nbsp;</td>
              </tr>
              
              <tr>
                <td align="right">Quality &nbsp;</td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
						<tr>
							<td width="120"><select name="quality_id" id="quality_id" class="style2" style="width:120px;" onChange="setValue('grade_id',0);doPost();"><%=Html.selectOptions(dao.getQualityDao().selectAll(),grade.quality_id,"Select Quality")%></select></td>
							<td width="60" align="right"><input name="processed_type" id="processed_type_d" type="radio" value="D" <%=grade.processed_type=='D'?"checked":""%> /></td>
							<td width="60">Natural</td>
							<td width="40" align="right"><input name="processed_type" id="processed_type_w" type="radio" value="W" <%=grade.processed_type=='W'?"checked":""%> /></td>
							<td width="">Wet Process</td>
						</tr>
					</table></td>
				<td>&nbsp;</td>
              </tr>
              <tr>
                <td align="right">Origin &nbsp;</td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
					<tr>
						<td width="120"><select name="origin_id" id="origin_id" class="style2" style="width:120;"><%=Html.selectOptions(dao.getOriginDao().selectAll(),grade.origin_id,"Select Origin")%></select></td>
						<td width="60" align="right">Code &nbsp;</td>
						<td width="50"><input name="grade_code" type="text" id="grade_code" class="style2" style="width:50" value="<%=grade.grade_code%>"></td>
						<td>&nbsp;</td>
					</tr>
				</table></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td align="right">Name &nbsp;</td>
                <td><input name="short_name" type="text" id="short_name" class="style2"style="width:100%" value="<%=grade.short_name%>"></td>
				<td>&nbsp;</td>
              </tr>
              <tr>
                <td align="right">Full Name &nbsp;</td>
                <td><strong><%=grade.getFullName()%></strong></td>
                <td>&nbsp;</td>
              </tr>
              <tr style="display:none">
                <td align="right">Short Name &nbsp;</td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
					<tr>
						<td width="120"><input name="ref_number" type="text" id="ref_number" class="style2" style="width:120px;" value="<%=grade.ref_number%>"></td>
						<td>&nbsp;</td>
						<td align="right">Order &nbsp;</td>
						<td align="right" width="50"><input name="idx" type="text" id="idx" class="style2" style="width:50; text-align:right" value="<%=grade.getIdx()%>"></td>
					</tr>
				</table></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td align="right">Screen &nbsp;</td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0" class="style2">
  					<tr>
    					<td width="120"><input name="screen" type="text" id="screen" class="style2" style="width:120px; text-align:right" value="<%=grade.screen%>"></td>
    					<td align="right">Type &nbsp;</td>
    					<td width="100" align="right"><select name="type" id="type" class="style2" style="width:100px;">
                     	<option value=" " <%=grade.type==' '?"selected":""%>></option>
                     	<option value="S" <%=grade.type=='S'?"selected":""%>>Screen</option>
                     	<option value="R" <%=grade.type=='R'?"selected":""%>>Raw</option>
                     	<option value="L" <%=grade.type=='L'?"selected":""%>>Low Grade</option>
                     	<option value="O" <%=grade.type=='O'?"selected":""%>>Off Grade</option>
                     	<option value="P" <%=grade.type=='P'?"selected":""%>>Processed</option>
                 </select></td>
  					</tr>
				</table></td>
				<td>&nbsp;</td>
              </tr>

<%
	List<GradeDescriptionEntity> gds = grade.getDescriptions();
	GradeDescriptionEntity gd = dao.getGradeDescriptionDao().newEntity();
	gd.setNew();
	gds.add(gd);
	for (int no = 1; no <= gds.size(); no++) {
		gd = gds.get(no-1);
%>			  
				<input type="hidden" name="description_id_<%=no%>" id="description_id_<%=no%>" value="<%=gd.getIdLong()%>">	
              <tr>
                <td align="right">Description <%=no%></td>
                <td><textarea name="description_<%=no%>" id="description_<%=no%>"  rows="3" class="style2" style="width:100%"><%=gd.description%></textarea></td>
				<td>&nbsp;</td>
              </tr>
<%
	}
%>			  
		      <tr>
        		<td  align="right">Active</td>
        		<td><input name="active_" id="active_" type="checkbox" value="1" onClick="cbxClick(this)" <%=grade.active?"checked":""%>></td>
				<input type="hidden" name="active" id="active" value="<%=grade.active?"1":"0"%>">
        		<td>&nbsp;</td>
      		</tr>
            </table></div><!-- END --></td>
		<td><%@include file="quality.discount.jsp"%></td>
	</tr>
	<tr>
		<td><img src="../shared/images/new.gif" onClick="doAddNew()" style="display:<%=displayed%>">&nbsp;<img src="../shared/images/delete.gif" onClick="doDelete()" style="display:<%=displayed%>"></td>
		<td><img src="../shared/images/update.gif" onClick="saveGrade()" style="display:<%=displayed%>"></td>
		<td><img src="images/report.jpg" onclick="doTask(4)" /></td>
	</tr>
</table>
	<input type="hidden" name="uid"        id="uid"        value="<%=user.getuid()%>">		
    <input type="hidden" name="task_id"    id ="task_id"   value="0">
</form>  

<script language="javascript">
	if (<%=grade.getIdInt()%> == -1) {	
		var idx = addNewListItem(document.formMain.grade_id,"New Grade");
	}
	getObj("discount_div").style.height = 332;
</script>
<%@include file="../footer.jsp"%>

