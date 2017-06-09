<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>虚拟现实视频融合监控项目 协同工作流管理平台</title>
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
		
		
		<a href="/MR_ST/login.jsp" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >登录账号</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>虚拟现实视频融合监控项目</h2>
		<h2>协同工作流管理平台</h2>
		<hr></hr>
		<br>
		<s:form action="LoginCheck" method="post"  theme="simple">
		<table>
		<tr>
		<td>账号名/邮箱：</td><td><s:textfield type="requiredstring" name="username" /></td>		
		</tr>
		<tr>
		<td>密码：</td><td><s:password type="requiredstring" name="password" /></td>		
		</tr>
		<tr>
		<td></td><td><s:submit class="btn" name="submit" value="登录" /></td>		
		</tr>
		
		</table>
		</s:form>
		<input id="btnF" type="button" style="" value="忘记密码" onclick="window.location.href='/MR_ST/reset/forget_pw.jsp'"/>
		
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