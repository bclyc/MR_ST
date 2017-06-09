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
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
						
	}		 
%>

<!DOCTYPE html>
<html>
<head>
<title>��ϸ��ģ</title>

  <script>
  function addRow(){
  	var table=document.getElementById("cameralist");
  	var row = table.insertRow(table.rows.length);
  	var c0=row.insertCell(0);
  	c0.innerHTML='<label for="'+table.rows.length+'">���'+table.rows.length+': </label><input type="text" name="camera['+(table.rows.length-1)+']" id="'+table.rows.length+'"  maxlength="200"/>';
  	  	
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
		<a href="/MR_ST/local/upload_marked.jsp?projectId=${param.projectId}&sid=<%=sid%>">2 �ϴ���ע�ĵ�ͼ</a>
		<a href="/MR_ST/local/upload_video.jsp?projectId=${param.projectId}&sid=<%=sid%>">3 �ύ��Ƶ����</a>
		<a href="/MR_ST/local/upload_fine_modeling.jsp?projectId=${param.projectId}&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >4 ��ϸ��ģ(��ѡ)</a>
		
		<a href="/MR_ST/local/local.jsp">������Ŀ�б�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">���辫ϸ��ģ���ύ����·��ͼ���ֳ���Ƭ</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>
		
		<div class="mainleft">
		    
	    <form action="UploadFine" method="post">
	    
	    <table id="cameralist">
	    <tr>
	    <td>
	    <label for="1">����Ĳ�������:</label>
	    <input type="text" name="filedata" id="1" maxlength="200" style="width:300px"/>
	    </td>
	    </tr>
	    </table>
	    	    
	    <br>
	    <input type="hidden" name="projectId" value="${param.projectId}">
	    <input type="hidden" name="fileUsage" value="Fine_link">
	    <input type="hidden" name="sid" value="${param.sid}">
	    
	    <input type="submit" class="btn"  value="�ύ"/>	    
	    </form>
	    <s:fielderror/><br>
	    </div>
	    
	    <%			
	   	SqlHelper sh0=new SqlHelper(); 
		 String sql0="select FINE_MODELING from project_filepath where PROJECT_ID=?";
		 String[] paras0={request.getParameter("projectId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String base_m="��";
		
		 if(rs0.next()){
		 	if(rs0.getString(1)!=null&&!rs0.getString(1).trim().equals("")){
		 		base_m =rs0.getString(1);
		 	}
		 	
		 }
		%>
	    <div class="mainright">
	    <div style="margin-bottom:50px">
	   	����Ŀ���ύ�ģ�<br>
	   	��ϸ��ģ�������ӣ�<label  style="width:90%;font-weight:bold"><%=base_m %> </label><br>
	   	
	   	</div>
	   	<hr>
	   	<p>*˵��</p>
	   	<p> ���в��������ϴ����̣��ύ����</p>
	   	<p>*����Ҫ��</p>
	   	<p>1. ��׼��һ�ź���ͼ������ƽ��ͼ������ͼֽ�ϱ�ע���յ���ʼλ�ú����յ�˳���ü�ͷ������յ�·�߼������Ա����������άģ��ʱ�ֱܷ����Ƭ��������Ӧ��λ�úͷ���</p>
	   	<p>2. ����ʱ�����ĳ�����ṹ����Ƭ��Ҫ��������ĳ������뽨��֮��Ĺ�ϵ����ͼ20��ʾ�����ٰ���Ԥ���趨��·��˳���ϸ����������Ҫ�����������ǰһ����Ƭ�ͽ���������ƬҪ�аٷ�֮��ʮ���ҵ��ص�����ȷ�����е���Ƭ����������������</p>
	   	<p>3. ע�������������ʱҪ������������������죬�����Ӱ����Ƭ��Ч�������ڵƹ�ȽϺ�ʱ�������㣻������Ƭģ�����ع��������֣����ز���̫�ͣ�</p>
	   	
	   	
	   	<p>*ʾ��</p>
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