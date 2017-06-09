<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>忘记密码</title>
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body>
<div class="topbar">
	<div class="row">
	<a href="/MR_ST/login.jsp" class="logo"><img style="" src="/MR_ST/resource/logo25.png"/></a>
	
	</div>
</div>

<div class="topsecbar">

</div>
<div class="mainbody">
	<div class="row">
	<div class="left-navbar" >
		<div class="navbar-box" >
		<div class="navbar">
		
		<a href="/MR_ST/login.jsp" style="" >返回登录</a>
		
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>重置密码</h2>
		<hr></hr>
		<br>
		<form action="/MR_ST/reset/reset.jsp" method="post">
		
		<table>
		<tr>
		<td>绑定邮箱：</td><td><input type="email" required name="email" maxlength="30"/></td>		
		</tr>	
		</table>
		
		<input type="hidden" name="sid" value="<%=session.getId()%>">
		<input type="hidden" name="reset_type" value="F_PW">
		
		<input class="btn" type="submit" name="submit" value="向邮箱发送重置邮件" style="font-size:20px"/>
		</form>
		
		
		<script  type="text/javascript">
		if(<%= (request.getAttribute("message")!=null) %>){
			var msg = "${message}";
			alert(msg);
		}		
		</script>
	</div>
	
	</div>
	
	<div style="clear:both;"></div>
</div>
</body>
</html>