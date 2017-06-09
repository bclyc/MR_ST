<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*"%>
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
	
	if(!userType.equals("4")||!sid.equals(request.getParameter("sid"))){
 		//response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
						
	}
		
%>

<!DOCTYPE html>
<html>
<head>
<title>上传配置文件</title>
<script>
	var assId = ${param.assId};
	var projectId=${param.projectId};
	
	function jump(use){
	
		if(use=="finish"){
			if(confirm("确定制作完成吗？完成后依然可以修改")){
				var comments = prompt("请输入您的备注，无需备注点击取消","");
				post(encodeURI(encodeURI("/MR_ST/staff/finish.jsp?projectId="+projectId+"&staffId="+"<%=userId%>"+"&sid="+"<%=sid%>"+"&assId="+assId)),comments);			
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
  
  <style>	
  </style>
  
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
		<a href="/MR_ST/local/download_m.jsp?projectId=${param.projectId}&sid=<%=sid%>">下载子项目材料</a>
		<a href="/MR_ST/staff/view_assignment.jsp?projectId=${param.projectId}&staffId=<%=userId%>&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >上传制作结果</a>
		
		<a href="/MR_ST/staff/staff.jsp">返回项目列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >		
		<h2 style="">上传制作结果</h2>   
		<hr></hr>
		
		<%
		SqlHelper sh=new SqlHelper();
		String sql="select distinct CAM_NUMBER,CAM_NOTE from assignment where ASSIGNMENT_ID=?";
		String[] paras={request.getParameter("assId")};
		ResultSet rs=sh.query(sql,paras);
		rs.next();
		
		String sql1="select distinct FILE_PATH,LINKS from ass_filepath where ASSIGNMENT_ID=? and FILE_PATH IS NOT NULL and LINKS IS NOT NULL";
		String[] paras1={request.getParameter("assId")};
		ResultSet rs1=sh.query(sql1,paras1);
		String filepath="";
		String links="";
		if(rs1.next()){
			filepath=rs1.getString(1).substring(rs1.getString(1).lastIndexOf("/")+1, rs1.getString(1).length());
			links=rs1.getString(2);
		}
		if(filepath.trim().equals(""))	filepath="无";
		if(links.trim().equals(""))	links="无";
		%>
		<div class="mainleft">
		 任务所属子项目 ID: <label style="font-weight:bold;margin-right:50px">${param.projectId}</label> <br>
		 任务相机数目：<label style="font-weight:bold;margin-right:50px"><%=rs.getString(1) %></label>
		 具体分配的相机说明 ：<label style="font-weight:bold;margin-right:50px"><%=rs.getString(2) %></label>
		<br><br>
		
	    <form action="UploadConf" method="post" enctype="multipart/form-data">         
	                              
			文件：<input type="file" name="upload"  /> <br>                
			链接：<textarea name="links" rows="5" cols="60"> </textarea><br>  
	        <input class="btn" type="submit" value='提交' />           
	        
	        <input type="hidden" name="projectId" value="${param.projectId}">
	        <input type="hidden" name="fileUsage" value="Config_file">
	        <input type="hidden" name="sid" value="${param.sid}">
	        <input type="hidden" name="assId" value="${param.assId}">
	    </form> 
	    <s:fielderror/><br>
	    
	   	<p>*说明</p>
	   	<p>1. 点击浏览选择文件，文件最大15M，更大的文件请使用链接方式</p>
	   	<p>2. 链接不限制格式和个数，多个链接请用逗号隔开以便查看使用</p>
	   	<p>3. 文件和链接可为空，每次提交将覆盖之前提交的内容</p>
	   	<p>4. 在右侧确认上传成功、制作任务完成后点击下面"制作完成"</p>
	   	
	    <input id="btnF" class="btn" type="button" value="制作完成" style="" onclick="jump('finish')" >
	   	
	   	</div>
	   	
	   	<div class="mainright">
	   	该任务已提交的：<br>
	   	文件：<label style="font-weight:bold"><%=filepath %></label> <br>
	   	链接：<label style="font-weight:bold"><%=links %></label> 
	   	</div>
	   	
	   	
		 
	   	
	    	
		<s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
		
	</div>
	
	</div>
</div>


</body>
</html>