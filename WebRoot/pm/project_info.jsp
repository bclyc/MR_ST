<%@ page contentType="text/html;charset=GBK" import="java.util.*,database.SqlHelper,java.sql.*"%>
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
	
	if(!userType.equals("2")||!sid.equals(request.getParameter("sid"))){		
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
<title>��Ŀ��Ϣ</title>

<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">

<style>
textarea{
	background:transparent;
	border-style:none;
	display:table-cell;
	vertical-aglin:middle;
}
</style>
</head>
<%	
	ResourceBundle myResourcesBundle = ResourceBundle.getBundle("global");
%>
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
		
		<a href="/MR_ST/pm/pm.jsp?" >��Ŀ�����б�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>��Ŀ��Ϣ</h2>
		<hr></hr>		
		 Project ID: ${param.projectId} <br><br>
		
		<% 
			SqlHelper sh=new SqlHelper();
			String sql="select TITLE, DESCRIPTION, CITY,ADDRESS, PERSON_IN_CHARGE, CONTACT_TELE, CONTACT_EMAIL, CAMERA_NUM, REMARK, SUBMIT_BY, COMPANY_NAME"
			+" from project where PROJECT_ID=?";
			String[] paras={request.getParameter("projectId")};
			ResultSet rs=sh.query(sql,paras);
			
			rs.next();
		%>
		
		
		<table class="input_tableref">
		<tr>
		<td>�½����˺�:</td> <td><%=rs.getString(10)%></td>
		</tr>
		<tr>
		<td>��Ŀ����:</td> <td><%=rs.getString(1)%></td>	
		</tr>
		<tr>
		<td>��˾����:</td> <td><%=rs.getString(11)%></td>	
		</tr>
		<tr>
		<td>����:</td> <td><%=rs.getString(2)%></td>	
		</tr>
		<tr>
		<td>���ڳ���:</td> <td><%=rs.getString(3)%></td>	
		</tr>
		<tr>
		<td>��ַ:	</td> <td><%=rs.getString(4)%></td>	
		</tr>
		<tr>
		<td>������:</td> <td><%=rs.getString(5)%></td>	
		</tr>
		<tr>
		<td>��ϵ�绰:</td> <td><%=rs.getString(6)%></td>	
		</tr>
		<tr>
		<td>��������:</td> <td><%=rs.getString(7)%></td>	
		</tr>
		<tr>
		<td>���������Ŀ:</td> <td><%=rs.getString(8)%></td>	
		</tr>
		<tr>
		<td>��ע:</td> <td><%=rs.getString(9)%></td>
		</tr>
		
		
		</table>
		<input type="hidden" name="userId" value="<%=userId%>"/>
		<input type="hidden" name="sid" value="<%=sid%>"/>
		
		
		
		
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