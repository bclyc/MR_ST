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
<title>ָ����Ŀ����Ա</title>

<%
	
	SqlHelper sh2=new SqlHelper(); 
	String sql2="select VALIDATION from project where PROJECT_ID=?";
	String[] paras2={request.getParameter("projectId")};
	ResultSet rs2=sh2.query(sql2, paras2);
	rs2.next();
	int flagV=-1;
	if(rs2.getString(1).equals("1"))	flagV=1;
 %>

<script>
	var userId="";
	var flag=0;	 
  	function checkfn(){
	
		var radio = document.getElementsByName('radiocheck');
				
		for(var i=0; i<radio.length&&flag==0; i++){
			if(radio[i].checked){
			flag=1;
			userId=radio[i].value;
			}
		}
				
		
	}
	
	function jump(){		
		if(flag==0){		
			alert('��ѡ����Ա');
		}else{
			var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
			post("/MR_ST/admin/appoint_pmanager_action.jsp?projectId="+${param.projectId}+"&sid="+"<%=sid%>",comments,userId);
		}
	
	}
	
	function post(URL, comments,userId) {        
    var temp = document.createElement("form");        
    temp.action = URL;        
    temp.method = "post";        
    temp.style.display = "none";        
            
    var opt = document.createElement("textarea");        
    opt.name = "comments";        
    opt.value = comments;        
    // alert(opt.name)        
    temp.appendChild(opt);

    var opt2 = document.createElement("textarea");        
    opt2.name = "staffId";        
    opt2.value = userId;        
    // alert(opt.name)        
    temp.appendChild(opt2);        
           
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
		<a href="/MR_ST/admin/admin_proj.jsp?">��Ŀ�����б�</a>
		<a href="/MR_ST/admin/admin_user.jsp?">�˺Ź����б�</a>
				
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">ָ������Ŀ����Ŀ����Ա��</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>

		<table class="tableref" id="myproject" border="1" style="width:80%" >
	    <tr>
	      <th></th>
	      <th>��ԱID</th>
	      <th>����</th>
	      <th>�绰</th>
	      <th>Email</th>
	      <th>�������Ŀ��</th>
	      
	    </tr>
	    
	 	<%
	 	SqlHelper sh=new SqlHelper();
		String sql="select ID, USER_NAME, TELEPHONE, EMAIL"
			+" from user where TYPE='2' and DISABLE='0'";					
		ResultSet rs=sh.query(sql);
		
	 	while(rs.next()){
	 		
	  	%>
	  	<tr>
		   <td class="radio"><input name="radiocheck" type="radio" value="<%=rs.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>
		   <td><%=rs.getString(1)%></td>
		   <td><%=rs.getString(2)%></td>
		   <td><%=rs.getString(3)%></td>
		   <td><%=rs.getString(4)%></td>
		<% 
		SqlHelper sh1=new SqlHelper();
		String sql1="select count(PROJECT_ID)"
			+" from project_pmanager where P_MANAGER=?";
		String[] paras1={rs.getString(1)};
		ResultSet rs1=sh1.query(sql1,paras1);
		rs1.next();
		int projectnum=rs1.getInt(1);
		
		%>
			<td><%=projectnum%></td>	   
	  	</tr>
		<%
			rs1.close();	
		 	sh1.close();
		  }	
		 rs.close();	
		 sh.close();	 
		
		 %>
		 </table>
		 
		 <br>
		 <input id="btnV" class="btn" type="button" style="font-size:20px" value="ָ��" onclick="jump()"/>
		 
				
	    <input type="hidden" name="projectId" value="${param.projectId}">
	    
	    <s:fielderror/><br>
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