<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>������ʵ��Ƶ�ںϼ����Ŀ Эͬ����������ƽ̨</title>
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
		
		
		<a href="/MR_ST/login.jsp" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >��¼�˺�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>������ʵ��Ƶ�ںϼ����Ŀ</h2>
		<h2>Эͬ����������ƽ̨</h2>
		<hr></hr>
		<br>
		<s:form action="LoginCheck" method="post"  theme="simple">
		<table>
		<tr>
		<td>�˺���/���䣺</td><td><s:textfield type="requiredstring" name="username" /></td>		
		</tr>
		<tr>
		<td>���룺</td><td><s:password type="requiredstring" name="password" /></td>		
		</tr>
		<tr>
		<td></td><td><s:submit class="btn" name="submit" value="��¼" /></td>		
		</tr>
		
		</table>
		</s:form>
		<input id="btnF" type="button" style="" value="��������" onclick="window.location.href='/MR_ST/reset/forget_pw.jsp'"/>
		
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