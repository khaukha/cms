<script type="text/javascript" language="JavaScript" src="../shared/js/packing.js"></script>

<script type="text/javascript" language="javascript">
<%
	String packing_fmt = "packing_array[%d] = new Array(%d,'%s',%.2f,%.0f,%d)";
	List<PackingEntity> pks = dao.getPackingDao().selectAll();
	for (int i = 0; i < pks.size(); i++) {
		PackingEntity pk = pks.get(i); 
		out.write(String.format(packing_fmt, i, pk.getIdInt(), pk.short_name, pk.weight, pk.kg_per_bag, pk.bags_per_pallet));
%>		
<%
	}
%>
</script>
