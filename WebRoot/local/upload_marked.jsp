<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
	
	int baseMapExist=0;
	
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
		
		
		SqlHelper sh=new SqlHelper();
		
		String sql="select BASE_MAP from project_filepath where PROJECT_ID=? and BASE_MAP IS NOT NULL";
		String[] paras={request.getParameter("projectId")};
					
		ResultSet rs=sh.query(sql,paras);
				
		if(rs.next()&&!rs.getString(1).trim().equals("")){
		
			baseMapExist=1;
			
		}
						
	}		 
%>

<!DOCTYPE html>
<html>
<head>
<title>上传标记的底图</title>

  <script>
   function PreviewImage(imgFile)
   {
    var pattern = /(\.*.jpg$)|(\.*.png$)|(\.*.jpeg$)|(\.*.gif$)|(\.*.bmp$)/;     
    if(!pattern.test(imgFile.value))
    {
     alert("系统仅支持jpg/jpeg/png/gif/bmp格式的照片！"); 
     imgFile.focus();
    }
    else
    {
     var path;
     
     if(document.all)//IE
     {
      imgFile.select();
      path = document.selection.createRange().text;
      document.getElementById("imgPreview").innerHTML="";
      document.getElementById("imgPreview").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true',sizingMethod='',src=\"" + path + "\")";//使用滤镜效果
     }
     else//FF
     {
      path = URL.createObjectURL(imgFile.files[0]);
      document.getElementById("imgPreview").innerHTML = "<img id='preview' src='"+path+"'/>";      
     }
     
    var img = new Image();    
    img.onload = function(){
    	var divh=500;
    	var divw=500;
        var imgw=img.width;
    	var imgh=img.height;
	   
	    var wratio=imgw/divw;
		var hratio=imgh/divh;		
		
		var w=(wratio>=hratio)?(imgw/wratio):(imgw/hratio);
		var h=(wratio>=hratio)?(imgh/wratio):(imgh/hratio);		
		
		document.getElementById("preview").width=w;
		document.getElementById("preview").height=h;
	};
	img.src = path;
	
    }
   }
   
   function checkExist(){
   		if(<%=baseMapExist%>==1){
   			window.location.href='/MR_ST/local/mark.jsp?sid=<%=sid%>&projectId=<%=request.getParameter("projectId")%>';
   		}else if(<%=baseMapExist%>==0){
   			alert("未上传底图！");
   		}
   }

   function AutoResizeImage(maxWidth,maxHeight,objImg){
		var img = new Image();
		img.src = objImg.src;
		var hRatio;
		var wRatio;
		var Ratio = 1;
		var w = img.width;
		var h = img.height;
		wRatio = maxWidth / w;
		hRatio = maxHeight / h;
		if (maxWidth ==0 && maxHeight==0){
		Ratio = 1;
		}else if (maxWidth==0){//
		if (hRatio<1) Ratio = hRatio;
		}else if (maxHeight==0){
		if (wRatio<1) Ratio = wRatio;
		}else if (wRatio<1 || hRatio<1){
		Ratio = (wRatio<=hRatio?wRatio:hRatio);
		}
		if (Ratio<1){
		w = w * Ratio;
		h = h * Ratio;
		}
		objImg.height = h;
		objImg.width = w;
	}
  </script> 
  
  <style>	
  p{
  font-size:18px;
  margin:8px 0;
  }
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
		<a href="/MR_ST/local/upload_marked.jsp?projectId=${param.projectId}&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >2 上传标注的底图</a>
		<a href="/MR_ST/local/upload_video.jsp?projectId=${param.projectId}&sid=<%=sid%>">3 提交视频链接</a>
		<a href="/MR_ST/local/upload_fine_modeling.jsp?projectId=${param.projectId}&sid=<%=sid%>" >4 精细建模(可选)</a>
		
		<a href="/MR_ST/local/local.jsp">返回项目列表</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">上传标注后的底图/在底图上直接标注</h2>   
		<hr></hr>
				
		 Project ID: ${param.projectId} <br><br>
		 
		 <div class="mainleft">
		 <h3>方法一：在底图上直接标注</h3>
	   	 <input class="btn" type="button" value='在底图上直接标注' onclick="checkExist()"/> 
	   	 <br><br>
	   	 
		 <h3>方法二：上传标注后的底图</h3>
	    <form action="UploadMarked" method="post" enctype="multipart/form-data">         
	                              
	        <input type="file" name="upload" onchange="PreviewImage(this)"/> <br>                
	          
	        <input class="btn" type="submit" value='提交' />           
	        
	        <input type="hidden" name="projectId" value="${param.projectId}">
	        <input type="hidden" name="fileUsage" value="Base_map_marked">
	        <input type="hidden" name="sid" value="${param.sid}">
	    </form> 
	    <s:fielderror/>
	    
	    
	    <br>	    
	   	
	    <div class="divbox" id="imgPreview"  >	    
	   	</div>
	   	   	
	   	</div>
	   	
	   	<%			
	   	SqlHelper sh0=new SqlHelper(); 
		 String sql0="select BASE_MAP_MARKED from project_filepath where PROJECT_ID=?";
		 String[] paras0={request.getParameter("projectId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String base_m="";
		 String base_m_string="无";
		
		 if(rs0.next()){
		 	if(rs0.getString(1)!=null&&!rs0.getString(1).trim().equals("")){
		 		base_m =rs0.getString(1);
		 		base_m_string="";
		 	}
		 	
		 }
		%>	   
	   	<div class="mainright">
	   	<div style="margin-bottom:50px">
	   	该项目已提交的：<br>
	   	标注后的底图：<img id="base_m" style="margin:5px 5px" src="<%=base_m%>" onload="AutoResizeImage(0,200,this)"/><%=base_m_string %> <br>
	   	
	   	</div>
	   	<hr>
	   	<p>*说明</p>
	   	<p>1. 方法一和方法二选其一即可</p>
	   	<p>2. 选方法一请根据提示标注相机大概位置、大概朝向</p>
	   	<p>3. 选方法二请上传标注好相机大概位置、大概朝向的底图</p>
	   	<br>
	   	<p>*示例</p>
	   	<img src="/MR_ST/resource/BASE_MAP_Marked.png" width="350px" height="212px" style="margin-bottom:50px"/>
	   	
	   	<img src="/MR_ST/resource/BASE_MAP_Marked2.png" width="350px" height="150px" style="margin-bottom:50px"/>
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