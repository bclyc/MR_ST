<%@ page contentType="text/html;charset=GBK"  import="database.SqlHelper,java.sql.*"%>
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
<title>提交视频链接</title>

  <script>
  function addRow(){
  	var table=document.getElementById("cameralist");
  	var row = table.insertRow(table.rows.length);
  	var c0=row.insertCell(0);
  	c0.innerHTML='<label for="'+table.rows.length+'">相机'+table.rows.length+': </label><input type="text" name="camera['+(table.rows.length-1)+']" id="'+table.rows.length+'"  maxlength="200"  style="width:400px"/>';
  	  	
  }
  
  function deleteRow(){
  	var table=document.getElementById("cameralist");
  	table.deleteRow(table.rows.length-1);
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
		<a href="/MR_ST/local/upload.jsp?projectId=${param.projectId}&sid=<%=sid%>">1 上传底图</a>
		<a href="/MR_ST/local/upload_marked.jsp?projectId=${param.projectId}&sid=<%=sid%>">2 上传标注的底图</a>
		<a href="/MR_ST/local/upload_video.jsp?projectId=${param.projectId}&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >3 提交视频链接</a>
		<a href="/MR_ST/local/upload_fine_modeling.jsp?projectId=${param.projectId}&sid=<%=sid%>" >4 精细建模(可选)</a>
		
		<a href="/MR_ST/local/local.jsp">返回项目列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">提交视频片段链接</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>
		
		<div class="mainleft">
		    
	    <form action="UploadVideo" method="post">
	    
	    <table id="cameralist">
	    <tr>
	    <td>
	    <label for="1">链接1:</label>
	    <input type="text" name="camera[0]" id="1" maxlength="200"  style="width:400px"/>
	    </td>
	    </tr>
	    </table>
	    
	    <input type="button" class="btn" onclick="addRow()" value="添加链接"/>
	    <input type="button" class="btn" onclick="deleteRow()" value="删除链接"/>
	    <br>
	    <input type="hidden" name="projectId" value="${param.projectId}">
	    <input type="hidden" name="fileUsage" value="Video_link">
	    <input type="hidden" name="sid" value="${param.sid}">
	    
	    <input type="submit" class="btn"  value="提交"/>	    
	    </form>
	    <s:fielderror/><br>
	    </div>
	    
	    <div class="mainright">
	    <div style="margin-bottom:50px">
	   	该项目已提交的链接：<br>
	    <%
	 	SqlHelper sh=new SqlHelper();
	 	
	 	int rscount =0;
	 	for(int i=1;i<=30;i++){
	 		String sql="select CAMERA_"+i+" from project_filepath where CAMERA_"+i+" IS NOT NULL and PROJECT_ID=?";
	 		String paras[]={request.getParameter("projectId")};
	 		ResultSet rs=sh.query(sql, paras);
	 		
	 		
	 		if(rs.next()){
	 			rscount++;
	 			String linkid="link"+i;
	 	%>
	 		链接<%=i%>: <label id="<%=linkid%>" style="width:90%;font-weight:bold"><%=rs.getString(1)%></label><br>
	 	<%	
	 		}else{
	 			rs.close();	
		 		sh.close();
	 			break;
	 		}
	 	}
	 	
	 	if(rscount==0){			
	  	%>
	  		未上传
	  	<%} 
	  	%>
	  	
	   	</div>
	   	
	   	<hr>
	   	<p>*说明</p>
	   	<p>1. 相机数目、编号应与上传的标记底图中对应</p>
	   	<p>2. 此处网页最多添加30个链接，请看说明3</p>
	   	<p style="font-weight:bold">3. 可以打包只提交一个链接，请在压缩包内按相机编号命名好文件。</p>
	   	</div>
	    
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