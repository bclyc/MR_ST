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
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
						
	}		 
%>

<!DOCTYPE html>
<html>
<head>
<title>项目信息</title>

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
		
		<a href="/MR_ST/local/local.jsp?" >项目管理列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>项目信息</h2>
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
		<td>新建由账号:</td> <td><%=rs.getString(10)%></td>
		</tr>
		<tr>
		<td>*项目名称:</td> <td><textarea  required name="title" rows="1" cols="60" maxlength="30" /><%=rs.getString(1)%></textarea><spam style="margin-left:20px">例如：城市+场景+应用</spam></td>	
		</tr>
		<tr>
		<td>*公司名称:</td> <td><textarea  required name="companyname" rows="1" cols="60" maxlength="30"/><%=rs.getString(11)%></textarea></td>	
		</tr>
		<tr>
		<td>描述:</td> <td><textarea required name="description" rows="5" cols="60" maxlength="150"><%=rs.getString(2)%></textarea><spam style="margin-left:20px">请尽量详尽列明需求</spam></td>	
		</tr>
		<tr>
		<td>*所在城市:</td> <td><textarea  required name="city"  rows="1" cols="60" maxlength="30"/><%=rs.getString(3)%></textarea></td>	
		</tr>
		<tr>
		<td>*地址:	</td> <td><textarea  required name="address" rows="2" cols="60" maxlength="60"/><%=rs.getString(4)%></textarea><spam style="margin-left:20px">请精确到门牌号</spam></td>	
		</tr>
		<tr>
		<td>*负责人:</td> <td><textarea  required name="personincharge" rows="1" cols="60" maxlength="30"/><%=rs.getString(5)%></textarea></td>	
		</tr>
		<tr>
		<td>*联系电话:</td> <td><textarea   required name="contacttele" rows="1" cols="60" maxlength="30"/><%=rs.getString(6)%></textarea></td>	
		</tr>
		<tr>
		<td>电子邮箱:</td> <td><textarea   required name="contactemail" rows="1" cols="60" maxlength="30"/><%=rs.getString(7)%></textarea></td>	
		</tr>
		<tr>
		<td>*预计相机数目:</td> <td><input type="number" required min="1" max="200" step="1" name="cameranum"  value="<%=rs.getString(8)%>" style="margin-bottom:0px" /></td>	
		</tr>
		<tr>
		<td>备注:</td> <td><textarea  required name="remark" rows="5" cols="60" maxlength="150"/><%=rs.getString(9)%></textarea></td>
		</tr>
		
		</table>
		<input type="hidden" name="userId" value="<%=userId%>"/>
		<input type="hidden" name="sid" value="<%=sid%>"/>
		<input type="hidden" name="projectId" value="${param.projectId}"/>
		<input type="hidden" name="sub" value="no"/>
		
		<input id="comments" type="hidden" name="comments" value=""/>
		
		<input class="btn" type="submit" name="submit" value="提交" style="font-size:20px"  />
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