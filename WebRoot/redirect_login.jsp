<%@ page import="database.SqlHelper,java.sql.*" contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>会话过期</title>
<style>	

</style>

<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body>
<div class="login" >
<h2 style="margin:50px auto;text-align:center;">会话已过期, 请重新登录。</h2>
<br><br>
<input class="btn" type="button" onclick="window.location.href='/MR_ST/login.jsp'" value="返回主页登录" style="display:table;margin:auto;"/>
</div>

</body>
</html>