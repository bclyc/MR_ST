<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>跳转中</title>

<script>
function doUpdate(num) 
{ 
document.getElementById('texts').innerHTML = '域名迁移中，页面将在'+num+'秒后自动跳转，如果没有自动跳转，请点击下面链接。' ; 
if(num == 0) { window.location=URL; } 
} 
</script>
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body>
<div class="login" >
<h2 id="texts" style="margin:50px auto;text-align:center;">域名迁移中，页面将自动跳转，如果没有自动跳转，请点击下面链接。</h2>
<br>
<a href='http://www.bigviewcloud.com.cn' style="margin:0 200px">跳转</a>
</div>
<script type='text/javascript'> 
var secs =5; //倒计时的秒数 
var URL = "http://www.bigviewcloud.com.cn"; 
 
for(var i=secs;i>=0;i--) 
{ 
window.setTimeout('doUpdate(' + i + ')', (secs-i) * 1000); 
} 
 

</script> 

</body>
</html>