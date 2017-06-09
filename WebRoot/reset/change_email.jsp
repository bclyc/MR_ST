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
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
	}
%>

<!DOCTYPE html>
<html>
<head>
<title>���İ�����</title>

<script>

</script>
<style>

</style>

<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body>
<div class="topbar">
	<div class="row">
	<a href="/MR_ST/login.jsp" class="logo"><img style="" src="/MR_ST/resource/logo25.png"/></a>
	<div class="userInfo" style="">
	<h5> ��ӭ��<%=userId%>�������˺�������<i><%=userTypeName%></i> </h5>
	<a href="/MR_ST/login.jsp">�ǳ�</a>
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
		<a href="/MR_ST/admin/admin_proj.jsp">��Ŀ�����б�</a>
		<a href="/MR_ST/admin/admin_user.jsp">�˺Ź����б�</a>
		<%}else if(userType.equals("2")){ %>
		<a href="/MR_ST/pm/pm.jsp">��Ŀ�б�</a>		
		<%}else if(userType.equals("3")){ %>
		<a href="/MR_ST/local/local.jsp">��Ŀ�б�</a>
		<%}else if(userType.equals("4")){ %>
		<a href="/MR_ST/staff/staff.jsp">��Ŀ�б�</a>
		<%} %>
		
		<h2 class="left">�˺Ź���</h2>
		<a href="/MR_ST/reset/change_info.jsp?sid=<%=sid%>">���Ļ�����Ϣ</a>
		<a href="/MR_ST/reset/change_pw.jsp?sid=<%=sid%>">��������</a>
		<a href="/MR_ST/reset/change_email.jsp?sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >���İ�����</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>���İ�����</h2>
		<hr></hr>
		
		<% 
			SqlHelper sh=new SqlHelper();
			String sql="select EMAIL from user where ID=?";			
			String[] paras={userId};
			ResultSet rs=sh.query(sql,paras);
			
			rs.next();
		%>
		
		<br>
		<form action="/MR_ST/reset/reset.jsp" method="post" onsubmit="">
		
		<table>
		<tr>
		<td>ԭ�����䣺</td><td><%=rs.getString(1) %></td>		
		</tr>
		<tr>
		<td>�°����䣺</td><td><input type="email" required name="email" maxlength="40"/></td>		
		</tr>
		
		</table>
		
		<input type="hidden" name="sid" value="<%=session.getId()%>">
		<input type="hidden" name="user_id" value="<%=userId%>">
		<input type="hidden" name="reset_type" value="CH_EM">
		
		<br>
		<input class="btn" type="submit" name="submit" value="�������䷢����֤�ʼ�" style="font-size:20px"/>
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