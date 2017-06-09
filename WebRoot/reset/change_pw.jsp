<%@ page contentType="text/html;charset=GBK" import="java.io.*,java.util.*,javax.mail.*,database.SqlHelper,java.sql.*"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();	
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!sid.equals(request.getParameter("sid"))){
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
	}
%>

<!DOCTYPE html>
<html>
<head>
<title>更改账号密码</title>
<script>
function check(){
	var pw1 = document.getElementsByName("pw1")[0].value;
	var pw2 = document.getElementsByName("pw2")[0].value;
	if(pw1==pw2) return true;
	else{
		alert("两次输入的新密码不同！");
		return false;
	} 
}
</script>
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body>
<div class="topbar">
	<div class="row">
	<a href="/MR_ST/login.jsp" class="logo"><img style="" src="/MR_ST/resource/logo25.png"/></a>
	<div class="userInfo" style="">
	<h5> 欢迎，<%=userId%>，您的账号类型是<i><%=userTypeName%></i> </h5>
	<a href="/MR_ST/login.jsp">登出</a>
	</div>
	</div>
</div>

<div class="topsecbar">

</div>
<div class="mainbody">
	<div class="row">
	<div class="left-navbar" >
		<div class="navbar-box" >
		<div class="navbar">
		<%if(userType.equals("1")){ %>
		<a href="/MR_ST/admin/admin_proj.jsp">项目管理列表</a>
		<a href="/MR_ST/admin/admin_user.jsp">账号管理列表</a>
		<%}else if(userType.equals("2")){ %>
		<a href="/MR_ST/pm/pm.jsp">项目列表</a>		
		<%}else if(userType.equals("3")){ %>
		<a href="/MR_ST/local/local.jsp">项目列表</a>
		<%}else if(userType.equals("4")){ %>
		<a href="/MR_ST/staff/staff.jsp">项目列表</a>
		<%} %>
		
		<h2 class="left">账号管理</h2>
		<a href="/MR_ST/reset/change_info.jsp?sid=<%=sid%>">更改基本信息</a>
		<a href="/MR_ST/reset/change_pw.jsp?sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >更改密码</a>
		<a href="/MR_ST/reset/change_email.jsp?sid=<%=sid%>">更改绑定邮箱</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>更改密码</h2>
		<hr></hr>
		
		<br>
		<form action="/MR_ST/reset/change_pw_action.jsp" method="post" onsubmit="return check()">
		
		<table>
		<tr>
		<td>原密码：</td><td><input type="password" required name="oldpw" maxlength="15"/></td>		
		</tr>
		<tr>
		</tr>
		<tr>
		<td>新密码：</td><td><input type="password" required name="pw1" maxlength="15"/></td>		
		</tr>
		<tr>
		<td>确认新密码：</td><td><input type="password" required name="pw2" maxlength="15"/></td>		
		</tr>	
		</table>
		
		<input type="hidden" name="sid" value="<%=session.getId()%>">
		<input type="hidden" name="user_id" value="<%=userId%>">
		
		<input class="btn" type="submit" name="submit" value="确认" style="font-size:20px"/>
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