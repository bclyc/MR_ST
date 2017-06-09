<%@ page import="database.SqlHelper,java.sql.*" contentType="text/html;charset=GBK"%>
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
<title>����Ŀ��־</title>

<script type="text/javascript">

var projectId="";

function checkfn(obj){
	
	var radio = document.getElementsByName('radiocheck');
	
	var flag=0;
	var selected;
	for(var i=0; i<radio.length&&flag==0; i++){
		if(radio[i].checked){
		flag=1;
		projectId=radio[i].value;
		selected=radio[i].parentNode.parentNode;	
		
		}		
	}
	document.getElementById("btnM").style.display = "none";
	document.getElementById("btnV").style.display = "none";
	document.getElementById("btnA").style.display = "none";
	document.getElementById("btnC").style.display = "none";
	document.getElementById("btnVF").style.display = "none";
	document.getElementById("btnVL").style.display = "";
	document.getElementById("btnVI").style.display = "";
	
		
	if(selected.cells[5].innerHTML=="2"){				
		document.getElementById("btnM").style.display = "";
		document.getElementById("btnV").style.display = "";
				
	}else if(selected.cells[5].innerHTML=="3"){
		document.getElementById("btnM").style.display = "";
		document.getElementById("btnA").style.display = "";	
			
	}else if(selected.cells[5].innerHTML=="6"){
		document.getElementById("btnM").style.display = "";
		document.getElementById("btnC").style.display = "";
		document.getElementById("btnVF").style.display = "";		
	}else if(selected.cells[5].innerHTML=="7"||selected.cells[5].innerHTML=="8"){
		document.getElementById("btnM").style.display = "";
		document.getElementById("btnC").style.display = "";		
	}else if(selected.cells[5].innerHTML=="4"||selected.cells[5].innerHTML=="5"){
		document.getElementById("btnM").style.display = "";			
	}
			
}

function jump(use){
	if(use==1){
		window.location.href="/MR_ST/local/download_m.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==2){
		window.location.href="/MR_ST/admin/validation.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==3){
		window.location.href="/MR_ST/admin/assignment.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==4){
		window.location.href="/MR_ST/admin/download_conf.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==5){
		window.location.href="/MR_ST/admin/validationF.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==6){
		window.location.href="/MR_ST/admin/project_info.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==7){
		window.location.href="/MR_ST/admin/project_log.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}
	
}
</script>

<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css" >
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
		<a href="/MR_ST/admin/admin_proj.jsp?" >��Ŀ�����б�</a>
		<a href="/MR_ST/admin/admin_user.jsp?">�˺Ź����б�</a>
		
		
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		
		<h2 style="">��Ŀ��־</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>
		 
		<table class="tableref" id="myproject" border="1"  >
	    <tr>
	      
	      <th>��Ŀ���</th>
	      <th>��������ʱ��</th>
	      <th>������</th>
	      <th>����״̬</th> 	      
	      <th>����/������Ϣ</th>
	    </tr>
	    
	 	<%
	 	SqlHelper sh=new SqlHelper();
		
		String sql="select PROJECT_ID, DATE, USER_ID, PROGRESS, NOTE"
		+" from log where PROJECT_ID=? order by DATE ASC";
		String[] paras={request.getParameter("projectId")};
					
		ResultSet rs=sh.query(sql,paras);
				
	 	while(rs.next()){
	 		
	 		String progress="";
			if(rs.getString(4).equals("1")) progress="1.��Ŀ�½����";
			else if (rs.getString(4).equals("2")) progress="2.�����ϴ����";
			else if (rs.getString(4).equals("3")) progress="3.�������ͨ��";
			else if (rs.getString(4).equals("4")) progress="4.�������񱻹���Ա����";
			else if (rs.getString(4).equals("5")) progress="5.����������Ա���ܣ���ʼ����";
			else if (rs.getString(4).equals("6")) progress="6.�����������";
			else if (rs.getString(4).equals("7")) progress="7.�����������Ա���ͨ��";
			else if (rs.getString(4).equals("8")) progress="8.��������ͻ�ȷ�ϣ���Ŀ����";		
	  	%>
	  	<tr>
		   <td><%=rs.getString(1)%></td>
		   <td><%=rs.getString(2)%></td>
		   <td><%=rs.getString(3)%></td>
		   <td><%=progress%></td>
			<td><%=rs.getString(5)%></td>
		</tr>	  	
	  	
		<%
					
		  }	
		 rs.close();	
		 sh.close();	 
		
		 %>
		 </table>
		 				
		<br>
		
		
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