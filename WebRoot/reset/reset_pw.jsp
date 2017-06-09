<%@ page contentType="text/html;charset=GBK" import="java.io.*,java.util.*,javax.mail.*,database.SqlHelper,java.sql.*"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	
	String sidstring = request.getParameter("sidstring");	
	SqlHelper sh0=new SqlHelper(); 
	String sql0="select USER_ID from reset where SID_STRING=? and RESET_TYPE='F_PW' and DONE='0'";
	String[] paras0={sidstring};
	ResultSet rs0=sh0.query(sql0, paras0);
	
	String userId="";	
	if(!rs0.next()){
				
		RequestDispatcher rd;
       	rd = getServletContext().getRequestDispatcher("/login.jsp");
       	request.setAttribute("message", "链接已失效！");
       	rd.forward(request,response);
	}else{
		userId = rs0.getString(1);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<title>重置密码</title>
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
	
	</div>
</div>

<div class="topsecbar">

</div>
<div class="mainbody">
	<div class="row">
	<div class="left-navbar" >
		<div class="navbar-box" >
		<div class="navbar">
		
		
		<a href="/MR_ST/login.jsp"  >返回主页</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>重置密码</h2>
		<hr></hr>
		<p>
		账号名: <%=userId %>
		</p>
		<br>
		<form action="/MR_ST/reset/reset_pw_action.jsp" method="post" onsubmit="return check()">
		
		<table>
		<tr>
		<td>新密码：</td><td><input type="password" required name="pw1" maxlength="15"/></td>		
		</tr>
		<tr>
		<td>确认新密码：</td><td><input type="password" required name="pw2" maxlength="15"/></td>		
		</tr>	
		</table>
		
		<input type="hidden" name="sid" value="<%=session.getId()%>">
		<input type="hidden" name="sidstring" value="<%=sidstring%>">
		<input type="hidden" name="reset_type" value="F_PW">
		<input type="hidden" name="user_id" value="<%=userId%>">
		
		<input class="btn" type="submit" name="submit" value="确认" style="font-size:20px"/>
		</form>
		
		
		<s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
	</div>
	
	</div>
	
	<div style="clear:both;"></div>
</div>
</body>
</html>