<script type="text/javascript" language="javascript">
var batch_array = [];
<%
	//List<BatchEntity> batch_list = task.getFreeBatches();	
	String batch_fmt = "packing_array.push({id:%d,batch_no:\"%s\",dc_id:%d,total_kgs:%.1f,commission_rate:%.2f,status:%d});\n";
	for (BatchEntity op : task.getFreeBatches()) {
		String str = String.format(batch_fmt, op.getIdLong(), op.batch_no, op.dc_id, op.total_kgs, op.commission_rate, op.status);
		out.write(str);
    }
%>	
//
function getBatch(batch_no)
{
	return getArrayItem(batch_array, batch_no);
}
//
</script>
