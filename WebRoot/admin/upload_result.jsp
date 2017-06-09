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
	
	if(!userType.equals("1")||!sid.equals(request.getParameter("sid"))){
 		//response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
						
	}
		
%>

<!DOCTYPE html>
<html>
<head>
<title>�ϴ����Ϻ���������</title>
<script>
	
	var projectId=${param.projectId};
	
	function jump(use){
	
		if(use=="finish"){
			if(confirm("ȷ�������"+projectId+"��Ŀ�����������˺ͺϲ���")){
				var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
				post("/MR_ST/admin/validationF.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&validation=true",comments);
			
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
		
		<a href="/MR_ST/admin/admin_proj.jsp">������Ŀ�б�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >		
		<h2 style="">�ϴ����Ϻ���������</h2>   
		<hr></hr>
		
		<%
		SqlHelper sh=new SqlHelper();
		
		
		String sql1="select distinct CONFIG_FILE,RESULT_LINK from project_filepath where PROJECT_ID=? and CONFIG_FILE IS NOT NULL and RESULT_LINK IS NOT NULL";
		String[] paras1={request.getParameter("projectId")};
		ResultSet rs1=sh.query(sql1,paras1);
		String filepath="";
		String links="";
		if(rs1.next()){
			filepath=rs1.getString(1).substring(rs1.getString(1).lastIndexOf("/")+1, rs1.getString(1).length());
			links=rs1.getString(2);
		}
		if(filepath.trim().equals(""))	filepath="��";
		if(links.trim().equals(""))	links="��";
		%>
		<div class="mainleft">
		 ����Ŀ ID: <label style="font-weight:bold;margin-right:50px">${param.projectId}</label>
		<br><br>
		
	    <form action="UploadResult" method="post" enctype="multipart/form-data">         
	                              
			�ļ���<input type="file" name="upload"  /> <br>                
			���ӣ�<textarea name="links" rows="5" cols="60"> </textarea><br>  
	        <input class="btn" type="submit" value='�ύ' />           
	        
	        <input type="hidden" name="projectId" value="${param.projectId}">
	        <input type="hidden" name="fileUsage" value="Result">
	        <input type="hidden" name="sid" value="${param.sid}">
	    </form> 
	    <s:fielderror/><br>
	    
	   	<p>*˵��</p>
	   	<p>1. ������ѡ���ļ����ļ����50M��������ļ���ʹ�����ӷ�ʽ</p>
	   	<p>2. ���Ӳ����Ƹ�ʽ�͸���������������ö��Ÿ����Ա�鿴ʹ��</p>
	   	<p>3. �ļ������ӿ�Ϊ�գ�ÿ���ύ������֮ǰ�ύ������</p>
	   	<p>4. ���Ҳ�ȷ���ϴ��ɹ�����˺ϲ�������ɺ�������"��˺ϲ���ɣ��ȴ������˺�ȷ��"</p>
	   	
	    <input id="btnF" class="btn" type="button" value="��˺ϲ���ɣ��ȴ������˺�ȷ��" style="" onclick="jump('finish')" >
	   	
	   	</div>
	   	
	   	<div class="mainright">
	   	����Ŀ���ύ�ģ�<br>
	   	�ļ���<label style="font-weight:bold"><%=filepath %></label> <br>
	   	���ӣ�<label style="font-weight:bold"><%=links %></label> 
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