<%@ page contentType="text/html;charset=GBK" import="java.util.*"%>
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
<title>新建子项目</title>

<script>
function comment(){
	var comments = prompt("请输入您的备注，无需备注点击取消","");
	document.getElementById("comments").value= comments;
}
</script>
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
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
		
		
		<a href="/MR_ST/local/local.jsp">返回项目列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>新建项目</h2>
		<hr></hr>
	
		<form action="NewProject" method="post">
		<table class="input_tableref">
		<tr>
		<td>*子项目名称:</td> <td><textarea  required name="title" rows="1" cols="60" maxlength="30"/></textarea></td>	
		</tr>
		<tr>
		<td>描述:</td> <td><textarea required name="description" rows="5" cols="60" maxlength="150"></textarea></td>	
		</tr>		
		<tr>
		<td>*预计相机数目:</td> <td><input type="number" required min="1" max="200" step="1" name="cameranum"  value="5" style="margin-bottom:0px" /></td>	
		</tr>
		<tr>
		<td>备注:</td> <td><textarea  required name="remark" rows="5" cols="60" maxlength="150"/></textarea></td>
		</tr>
		
		</table>
		<input type="hidden" name="userId" value="<%=userId%>"/>
		<input type="hidden" name="sid" value="<%=sid%>"/>
		<input type="hidden" name="sub" value="yes"/>
		<input type="hidden" name="mainId" value="${param.mainId}"/>
		
		<input id="comments" type="hidden" name="comments" value=""/>
		
		<input class="btn" type="submit" name="submit" value="提交" style="font-size:20px" onclick="comment()" />
		</form>
		
		<s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
	
		<br><br>
		 <p style="font-size:80%">*说明：*星号项为必填，其余项若没有请填写"无"</p>
		 
	</div>
	
	</div>
	
	<div style="clear:both;"></div>
</div>
</body>
</html>