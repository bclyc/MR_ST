<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>��ת��</title>

<script>
function doUpdate(num) 
{ 
document.getElementById('texts').innerHTML = '����Ǩ���У�ҳ�潫��'+num+'����Զ���ת�����û���Զ���ת�������������ӡ�' ; 
if(num == 0) { window.location=URL; } 
} 
</script>
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body>
<div class="login" >
<h2 id="texts" style="margin:50px auto;text-align:center;">����Ǩ���У�ҳ�潫�Զ���ת�����û���Զ���ת�������������ӡ�</h2>
<br>
<a href='http://www.bigviewcloud.com.cn' style="margin:0 200px">��ת</a>
</div>
<script type='text/javascript'> 
var secs =5; //����ʱ������ 
var URL = "http://www.bigviewcloud.com.cn"; 
 
for(var i=secs;i>=0;i--) 
{ 
window.setTimeout('doUpdate(' + i + ')', (secs-i) * 1000); 
} 
 

</script> 

</body>
</html>