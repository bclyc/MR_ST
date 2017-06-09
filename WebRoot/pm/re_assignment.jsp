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
	
	if(!userType.equals("2")||!sid.equals(request.getParameter("sid"))){		
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
<title>����ָ��������Ա</title>



<script>

	var assId="";
	function checkfn(obj){
	
		var radio = document.getElementsByName('radiocheck');
		
		var flag=0;
		var selected;
		for(var i=0; i<radio.length&&flag==0; i++){
			if(radio[i].checked){
			flag=1;
			
			assId=radio[i].value;
			selected=radio[i].parentNode.parentNode;	
			
			}		
		}
	}
	
	function jump(){		
		var staffselect=document.getElementById("staffselect");
		var staffId=staffselect.options[staffselect.selectedIndex].value;
		var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
		post(encodeURI(encodeURI("/MR_ST/pm/re_assignment_action.jsp?projectId="+${param.projectId}+"&assId="+assId+"&staffId="+staffId+"&sid="+"<%=sid%>")),comments);	
		
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
		<a href="/MR_ST/pm/pm.jsp">������Ŀ�����б�</a>
				
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">����ָ��������Ա��</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>

		<table class="tableref" id="myproject" border="1" style="width:100%" >
	    <tr>
	      
	      <th></th>
	      <th>���������Ŀ</th>
	      <th>�����������˵��</th>
	      <th>��ǰ��ָ����������Ա</th>
	      <th>״̬</th>
	      
	    </tr>
	    
	 	<%
	 	SqlHelper sh=new SqlHelper();
		String sql="select distinct ASSIGNMENT_ID,CAM_NUMBER,CAM_NOTE from assignment where PROJECT_ID=?";
		String[] paras={request.getParameter("projectId")};
		ResultSet rs=sh.query(sql,paras);
				
	 	while(rs.next()){
	 		String sql0="select STAFF_ID,ASSIGNMENT_STATUS from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC";
	 		String[] paras0={rs.getString(1)};
	 		ResultSet rs0=sh.query(sql0,paras0);
	 		rs0.next();
	 		
	 		String status=rs0.getString(2);
	 		String statusString="";
	 		boolean refusedflag=false;
	 		if(status.equals("-1")){
	 			refusedflag=true;
	 			statusString="�����ѱ��ܾ�";
	 		}else if(status.equals("0")){
	 			statusString="���������";
	 		}else if(status.equals("1")){
	 			statusString="�����ѱ�����";
	 		}else if(status.equals("2")){
	 			statusString="�����ѱ����";
	 		}
		  	%>
		  	<tr id="<%=rs.getString(1)%>">
		  		<td class="radio"><input name="radiocheck" type="radio" value="<%=rs.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>		   
			   <td><%=rs.getString(2)%></td>
			   <td><%=rs.getString(3)%></td>
			   <td><%=rs0.getString(1)%></td>
			   <td class="status-string"><%=statusString%></td>
					   
		  	</tr>
		  	
		  	<script>
			if(<%=refusedflag%>){
				document.getElementById("<%=rs.getString(1)%>").getElementsByClassName("status-string")[0].style.color="#ff0000";
			}
		  	</script>
			<%
			rs0.close();
		 	
		}	
	 	rs.close();	
		sh.close();	 
		
		 %>
		 </table>
		 
		 <br>
		 ��ѡ������ָ������Ա��
		 <select id="staffselect" style="font-size:130%" runat="server">
		 <%
		SqlHelper sh1=new SqlHelper();
		String sql1="select ID from user where TYPE=4 and DISABLE=0";	 	
	 	ResultSet rs0=sh1.query(sql1);
	 	while(rs0.next()){
	 	%>
	 		<option value="<%=rs0.getString(1)%>" runat="server"><%=rs0.getString(1)%></option>
	 	<%
	 	}	 	
		sh1.close();
		 %>
		 </select>
		 
		 <br><br>
		 <p style="font-size:80%">*˵����ѡ����Ҫ����ָ����Ա������Ȼ��ѡ������ָ������Ա�������ť��</p>
		 <p style="font-size:80%">����ָ������������Ա�󣬲���Ҫ������Ա���ܣ�Ĭ���ѽ���</p>
		 
		 
		 <input id="btnV" class="btn" type="button" style="font-size:20px" value="����ָ��ѡ�������������Ա" onclick="jump()"/>
		 
				
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