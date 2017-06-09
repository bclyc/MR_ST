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
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
		
		
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
<title>�ϴ���ǵĵ�ͼ</title>

  <script>
   function PreviewImage(imgFile)
   {
    var pattern = /(\.*.jpg$)|(\.*.png$)|(\.*.jpeg$)|(\.*.gif$)|(\.*.bmp$)/;     
    if(!pattern.test(imgFile.value))
    {
     alert("ϵͳ��֧��jpg/jpeg/png/gif/bmp��ʽ����Ƭ��"); 
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
      document.getElementById("imgPreview").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true',sizingMethod='',src=\"" + path + "\")";//ʹ���˾�Ч��
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
   			alert("δ�ϴ���ͼ��");
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
		<a href="/MR_ST/local/upload.jsp?projectId=${param.projectId}&sid=<%=sid%>">1 �ϴ���ͼ</a>
		<a href="/MR_ST/local/upload_marked.jsp?projectId=${param.projectId}&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >2 �ϴ���ע�ĵ�ͼ</a>
		<a href="/MR_ST/local/upload_video.jsp?projectId=${param.projectId}&sid=<%=sid%>">3 �ύ��Ƶ����</a>
		<a href="/MR_ST/local/upload_fine_modeling.jsp?projectId=${param.projectId}&sid=<%=sid%>" >4 ��ϸ��ģ(��ѡ)</a>
		
		<a href="/MR_ST/local/local.jsp">������Ŀ�б�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">�ϴ���ע��ĵ�ͼ/�ڵ�ͼ��ֱ�ӱ�ע</h2>   
		<hr></hr>
				
		 Project ID: ${param.projectId} <br><br>
		 
		 <div class="mainleft">
		 <h3>����һ���ڵ�ͼ��ֱ�ӱ�ע</h3>
	   	 <input class="btn" type="button" value='�ڵ�ͼ��ֱ�ӱ�ע' onclick="checkExist()"/> 
	   	 <br><br>
	   	 
		 <h3>���������ϴ���ע��ĵ�ͼ</h3>
	    <form action="UploadMarked" method="post" enctype="multipart/form-data">         
	                              
	        <input type="file" name="upload" onchange="PreviewImage(this)"/> <br>                
	          
	        <input class="btn" type="submit" value='�ύ' />           
	        
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
		 String base_m_string="��";
		
		 if(rs0.next()){
		 	if(rs0.getString(1)!=null&&!rs0.getString(1).trim().equals("")){
		 		base_m =rs0.getString(1);
		 		base_m_string="";
		 	}
		 	
		 }
		%>	   
	   	<div class="mainright">
	   	<div style="margin-bottom:50px">
	   	����Ŀ���ύ�ģ�<br>
	   	��ע��ĵ�ͼ��<img id="base_m" style="margin:5px 5px" src="<%=base_m%>" onload="AutoResizeImage(0,200,this)"/><%=base_m_string %> <br>
	   	
	   	</div>
	   	<hr>
	   	<p>*˵��</p>
	   	<p>1. ����һ�ͷ�����ѡ��һ����</p>
	   	<p>2. ѡ����һ�������ʾ��ע������λ�á���ų���</p>
	   	<p>3. ѡ���������ϴ���ע��������λ�á���ų���ĵ�ͼ</p>
	   	<br>
	   	<p>*ʾ��</p>
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