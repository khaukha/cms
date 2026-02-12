<%
	int wnr_packing_id = requester.getInt("wnr_packing_id");
%>
<select name="wnr_packing_id" id="wnr_packing_id" class="style2" style="width:120px;" onChange="changePacking()">
	<option id="0" value="0" selected></option>
<%
	for (int i = 0; i < pks.size(); i++) {
		PackingEntity pk = pks.get(i); 
		String selected = pk.getIdInt() == wnr_packing_id ? "selected" : "";	
%>      <option id="<%=pk.bags_per_pallet%>" value="<%=pk.getIdInt()%>" <%=selected%>><%=pk.short_name%></option>
<%
	}
%>
