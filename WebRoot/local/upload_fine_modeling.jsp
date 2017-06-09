<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*"%>
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
<title>精细建模</title>

  <script>
  function addRow(){
  	var table=document.getElementById("cameralist");
  	var row = table.insertRow(table.rows.length);
  	var c0=row.insertCell(0);
  	c0.innerHTML='<label for="'+table.rows.length+'">相机'+table.rows.length+': </label><input type="text" name="camera['+(table.rows.length-1)+']" id="'+table.rows.length+'"  maxlength="200"/>';
  	  	
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
		<a href="/MR_ST/local/upload_video.jsp?projectId=${param.projectId}&sid=<%=sid%>">3 提交视频链接</a>
		<a href="/MR_ST/local/upload_fine_modeling.jsp?projectId=${param.projectId}&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >4 精细建模(可选)</a>
		
		<a href="/MR_ST/local/local.jsp">返回项目列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">如需精细建模，提交拍照路线图和现场照片</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>
		
		<div class="mainleft">
		    
	    <form action="UploadFine" method="post">
	    
	    <table id="cameralist">
	    <tr>
	    <td>
	    <label for="1">打包的材料链接:</label>
	    <input type="text" name="filedata" id="1" maxlength="200" style="width:300px"/>
	    </td>
	    </tr>
	    </table>
	    	    
	    <br>
	    <input type="hidden" name="projectId" value="${param.projectId}">
	    <input type="hidden" name="fileUsage" value="Fine_link">
	    <input type="hidden" name="sid" value="${param.sid}">
	    
	    <input type="submit" class="btn"  value="提交"/>	    
	    </form>
	    <s:fielderror/><br>
	    </div>
	    
	    <%			
	   	SqlHelper sh0=new SqlHelper(); 
		 String sql0="select FINE_MODELING from project_filepath where PROJECT_ID=?";
		 String[] paras0={request.getParameter("projectId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String base_m="无";
		
		 if(rs0.next()){
		 	if(rs0.getString(1)!=null&&!rs0.getString(1).trim().equals("")){
		 		base_m =rs0.getString(1);
		 	}
		 	
		 }
		%>
	    <div class="mainright">
	    <div style="margin-bottom:50px">
	   	该项目已提交的：<br>
	   	精细建模材料链接：<label  style="width:90%;font-weight:bold"><%=base_m %> </label><br>
	   	
	   	</div>
	   	<hr>
	   	<p>*说明</p>
	   	<p> 所有材料请打包上传网盘，提交链接</p>
	   	<p>*材料要求</p>
	   	<p>1. 请准备一张航拍图或建筑的平面图，并在图纸上标注拍照的起始位置和拍照的顺序（用箭头标出拍照的路线及方向以便后期制作三维模型时能分辨出照片数据所对应的位置和方向）</p>
	   	<p>2. 拍照时请先拍出整体结构的照片（要求能清楚拍出建筑与建筑之间的关系，如图20所示）。再按照预先设定的路线顺序把细节拍下来（要求连接区域的前一张照片和接下来的照片要有百分之二十左右的重叠区，确保所有的照片都能连续起来）。</p>
	   	<p>3. 注意事项：室外拍照时要尽量避免阴雨天或雾天，否则会影响照片的效果；室内灯光比较好时可以拍摄；避免照片模糊、曝光等现象出现（像素不能太低）</p>
	   	
	   	
	   	<p>*示例</p>
	   	<img src="/MR_ST/resource/fineEx1.png" width="350px" height="247px"/>
	   	<img src="/MR_ST/resource/fineEx2.png" width="350px" height="147px"/>
	   	</div>
	    
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