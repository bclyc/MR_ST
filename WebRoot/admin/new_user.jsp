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
		System.out.println(sid);
		System.out.println(request.getParameter("sid"));		
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
<title>�½��˺�</title>

<script>
	
	
	function jump(use){		
		if(flag==0){		
			alert('��ѡ���˺�');
		}else if(use=="d"){	
			if(confirm("ȷ��ɾ���˺�"+userId+"��")){
				window.location.href="/MR_ST/admin/delete_user.jsp?userId="+userId;
			}
			
		}else if(use=="n"){
			window.location.href="/MR_ST/admin/new_user.jsp";
		}
	
	}
	
	
	
  </script> 
  
  <style>	
  .input_tableref tr{
  	height:40px;
  }
  .input_tableref tr td input{
  	width:200px;
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
		<a href="/MR_ST/admin/admin_proj.jsp?">��Ŀ�����б�</a>
		<a href="/MR_ST/admin/admin_user.jsp?">�˺Ź����б�</a>
				
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">�½��˺�</h2>   
		<hr></hr>
		<br>

		<form action="NewUser" method="post">
		<table class="input_tableref">
		<tr>
		<td>*�˺����ͣ�</td> 
		<td>
		<select name="type">
		<option value="2">��Ŀ����Ա</option>	
		<option value="3">�����˺�</option>
		<option value="4">������Ա</option>		
		</select>	
		</td>	
		</tr>
		
		<tr>
		<td>*�˺�ID��</td> <td><input type="text"  name="id" required oninvalid="setCustomValidity('����Ϊ��')" oninput="setCustomValidity('')" maxlength="15"/></td>	
		</tr>
		<tr>
		<td>*�˺����룺 </td> <td> <input type="text" required name="password" maxlength="15"/></td>	
		</tr>
		<tr>
		<td>*��Email��</td> <td> <input type="email" required name="email" maxlength="40"/></td>	
		</tr>
		<tr>
		<td>*������</td> <td> <input type="text" required name="username" maxlength="15"/></td>	
		</tr>
		<tr>
		<td>*�绰���룺</td> <td><input type="text" required name="telephone" maxlength="15"/></td>	
		</tr>
		 	
		</table>
		
		<input type="hidden" name="sid" value="${param.sid}">
		<br>
		<input class="btn" type="submit" name="submit" value="�½�" style="font-size:20px"/>
		</form>
	
		<br><br>
		 <p style="font-size:80%">*˵����*�Ǻ���Ϊ����</p>
		 <p style="font-size:80%"></p>
	    
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