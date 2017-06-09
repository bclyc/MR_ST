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
<title>项目制作结果</title>
<script>
var projectId=${param.projectId};
function down(id){
	var filepath = document.getElementsByClassName('file')[0].innerHTML;
	if(filepath=="无文件"){
		alert("无文件！");
	}else{
		window.location.href="/MR_ST/local/download_conf.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}
}

function jump(use){

	if(use=="c1"){
		if(confirm("确定"+projectId+"项目的结束吗？")){
			var comments = prompt("请输入您的备注，无需备注点击取消","");
			post("/MR_ST/local/confirm_end.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&confirm=true",comments);		
		}
	}else if(use=="c2"){
		if(confirm("确定要求"+projectId+"项目返工吗？")){
			var comments = prompt("请输入您的备注，无需备注点击取消","");
			post("/MR_ST/local/confirm_end.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&confirm=false",comments);		
		}
	}
}

function post(URL, comments) {        
    var temp = document.createElement("form");        
    temp.action = URL;        
    temp.method = "post";        
    temp.style.display = "none";        
            
    var opt = document.createElement("textarea");        
    opt.name = "comments";        
    opt.value = comments;        
    // alert(opt.name)        
    temp.appendChild(opt);        
           
    document.body.appendChild(temp);        
    temp.submit();        
    return temp;        
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
		
		<a href="/MR_ST/local/local.jsp" >返回项目列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>项目制作结果(文件+链接)</h2>
		<hr></hr>		
		 Project ID: ${param.projectId} <br><br>
		
		<% 
			SqlHelper sh=new SqlHelper();
			String sql="select CONFIG_FILE,RESULT_LINK from project_filepath where PROJECT_ID=?";
			String[] paras={request.getParameter("projectId")};
			ResultSet rs=sh.query(sql,paras);
			
			rs.next();
			
			String filepath="无文件";
			String link="无";
			if(rs.getString(2)!=null&&!"".equals(rs.getString(2).trim()))	link=rs.getString(2);				
			if(rs.getString(1)!=null&&!"".equals(rs.getString(1).trim()))	filepath=rs.getString(1);
			
			boolean noconfirmflag = request.getParameter("noconfirm").equals("true")?true:false;
		%>
		
		文件：<input type="button" class="btn" value="点击下载" onclick="down('${param.projectId}')"> <br>
		链接：<label><%=link%></label>
		<label class="file" style="display:none"><%=filepath%></label>
		<br><br>
		
		
		<input id="btnC1" type="button" class="btn" value="确认项目完成" style="" onclick="jump('c1')" >
		<input id="btnC2" type="button" class="btn" value="要求返工并说明理由" style="" onclick="jump('c2')" >
		
		<script>
		if(<%=noconfirmflag%>){
			document.getElementById("btnC1").style.display="none";
			document.getElementById("btnC2").style.display="none";
		}
		</script>
		
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