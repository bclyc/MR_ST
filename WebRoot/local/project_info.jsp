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
	
	if(!userType.equals("3")||!sid.equals(request.getParameter("sid"))){		
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
/* textarea{ */
/* 	background:transparent; */
/* 	border-style:none; */
/* 	display:table-cell; */
/* 	vertical-aglin:middle; */
/* } */
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
		
		<a href="/MR_ST/local/local.jsp?" >��Ŀ�����б�</a>
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
		<form action="NewProject" method="post">
		<table class="input_tableref">
		<tr>
		<td>�½����˺�:</td> <td><%=rs.getString(10)%></td>
		</tr>
		<tr>
		<td>*��Ŀ����:</td> <td><textarea  required name="title" rows="1" cols="60" maxlength="30" /><%=rs.getString(1)%></textarea><spam style="margin-left:20px">���磺����+����+Ӧ��</spam></td>	
		</tr>
		<tr>
		<td>*��˾����:</td> <td><textarea  required name="companyname" rows="1" cols="60" maxlength="30"/><%=rs.getString(11)%></textarea></td>	
		</tr>
		<tr>
		<td>����:</td> <td><textarea required name="description" rows="5" cols="60" maxlength="150"><%=rs.getString(2)%></textarea><spam style="margin-left:20px">�뾡���꾡��������</spam></td>	
		</tr>
		<tr>
		<td>*���ڳ���:</td> <td><textarea  required name="city"  rows="1" cols="60" maxlength="30"/><%=rs.getString(3)%></textarea></td>	
		</tr>
		<tr>
		<td>*��ַ:	</td> <td><textarea  required name="address" rows="2" cols="60" maxlength="60"/><%=rs.getString(4)%></textarea><spam style="margin-left:20px">�뾫ȷ�����ƺ�</spam></td>	
		</tr>
		<tr>
		<td>*������:</td> <td><textarea  required name="personincharge" rows="1" cols="60" maxlength="30"/><%=rs.getString(5)%></textarea></td>	
		</tr>
		<tr>
		<td>*��ϵ�绰:</td> <td><textarea   required name="contacttele" rows="1" cols="60" maxlength="30"/><%=rs.getString(6)%></textarea></td>	
		</tr>
		<tr>
		<td>��������:</td> <td><textarea   required name="contactemail" rows="1" cols="60" maxlength="30"/><%=rs.getString(7)%></textarea></td>	
		</tr>
		<tr>
		<td>*Ԥ�������Ŀ:</td> <td><input type="number" required min="1" max="200" step="1" name="cameranum"  value="<%=rs.getString(8)%>" style="margin-bottom:0px" /></td>	
		</tr>
		<tr>
		<td>��ע:</td> <td><textarea  required name="remark" rows="5" cols="60" maxlength="150"/><%=rs.getString(9)%></textarea></td>
		</tr>
		
		</table>
		<input type="hidden" name="userId" value="<%=userId%>"/>
		<input type="hidden" name="sid" value="<%=sid%>"/>
		<input type="hidden" name="projectId" value="${param.projectId}"/>
		<input type="hidden" name="sub" value="no"/>
		
		<input id="comments" type="hidden" name="comments" value=""/>
		
		<input class="btn" type="submit" name="submit" value="�ύ" style="font-size:20px"  />
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