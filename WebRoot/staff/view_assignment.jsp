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
	
	if(!userType.equals("4")||!sid.equals(request.getParameter("sid"))){		
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
<title>�鿴������Ŀ�����������</title>
<script>

	var assId="";
	var projectId=${param.projectId};
	
	function checkfn(obj){
		document.getElementById("btnA").style.display = "none";
		document.getElementById("btnR").style.display = "none";
		document.getElementById("btnD").style.display = "none";
		document.getElementById("btnU").style.display = "none";
		document.getElementById("btnF").style.display = "none";
		
		var radio = document.getElementsByName('radiocheck');
		
		var flag=0;
		var selected;
		for(var i=0; i<radio.length&&flag==0; i++){
			if(radio[i].checked){
				flag=1;
				
				assId=radio[i].value;
				selected=radio[i].parentNode.parentNode;
				if(selected.dataset.confirmflag=="true"){
					document.getElementById("btnA").style.display = "";
					document.getElementById("btnR").style.display = "";
				}else if(selected.dataset.step6flag=="false"){
					document.getElementById("btnD").style.display = "";
					document.getElementById("btnU").style.display = "";
					document.getElementById("btnF").style.display = "";
				}else if(selected.dataset.redoflag=="true"){
					document.getElementById("btnD").style.display = "";
					document.getElementById("btnU").style.display = "";
					document.getElementById("btnF").style.display = "";
				} 	
				
			}		
		}
	}
	
	function jump(use){		
				
		if(use=="accept"){
			if(confirm("ȷ������������")){
				post(encodeURI(encodeURI("/MR_ST/staff/confirm.jsp?projectId="+projectId+"&staffId="+"<%=userId%>"+"&assId="+assId+"&confirm=A"+"&sid="+"<%=sid%>")),"");
			}		
		}else if(use=="refuse"){
			if(confirm("ȷ���ܾ�������")){
				var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
				post(encodeURI(encodeURI("/MR_ST/staff/confirm.jsp?projectId="+projectId+"&staffId="+"<%=userId%>"+"&assId="+assId+"&confirm=R"+"&sid="+"<%=sid%>")),comments);
			
			}
		}else if(use=="download"){
			window.location.href="/MR_ST/local/download_m.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
		}else if(use=="upload"){
			window.location.href=encodeURI(encodeURI("/MR_ST/staff/upload_conf.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&staffId="+"<%=userId%>"+"&assId="+assId));
		}else if(use=="finish"){
			if(confirm("ȷ�������������ɺ���Ȼ�����޸�")){
				var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
				post(encodeURI(encodeURI("/MR_ST/staff/finish.jsp?projectId="+projectId+"&staffId="+"<%=userId%>"+"&sid="+"<%=sid%>"+"&assId="+assId)),comments);
			
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
		<a href="/MR_ST/staff/staff.jsp" >��Ŀ�б�</a>
				
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">�鿴����Ŀ�����������</h2>   
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
		
		String sql1="select distinct PROGRESS from project where PROJECT_ID=?";
		String[] paras1={request.getParameter("projectId")};
		ResultSet rs1=sh.query(sql1,paras1);
		rs1.next();
		boolean step6flag=rs1.getString(1).equals("6")?true:false;
				
	 	while(rs.next()){
	 		String sql0="select STAFF_ID,ASSIGNMENT_STATUS from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC";
	 		String[] paras0={rs.getString(1)};
	 		ResultSet rs0=sh.query(sql0,paras0);
	 		rs0.next();
	 		
	 		if(!rs0.getString(1).equals(userId))	continue;
	 		
	 		String status=rs0.getString(2);
	 		String statusString="";
	 		boolean needconfirmflag=false;
	 		boolean redoflag=false;
	 		
	 		if(status.equals("-1")){	 			
	 			statusString="�����ѱ��ܾ�";
	 		}else if(status.equals("0")){
	 			statusString="���������";
	 			needconfirmflag=true;
	 		}else if(status.equals("1")){
	 			statusString="�����ѱ�����";
	 		}else if(status.equals("2")){
	 			statusString="���񱻱�Ϊ�����";
	 		}else if(status.equals("3")){
	 			statusString="��Ҫ�󷵹���";
	 			redoflag=true;
	 		}
		  	%>
		  	<tr id="<%=rs.getString(1)%>" data-confirmflag="<%=needconfirmflag%>" data-step6flag="<%=step6flag%>" data-redoflag="<%=redoflag%>">
		  		<td class="radio"><input name="radiocheck" type="radio" value="<%=rs.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>		   
			   <td><%=rs.getString(2)%></td>
			   <td><%=rs.getString(3)%></td>
			   <td><%=rs0.getString(1)%></td>
			   <td class="status-string"><%=statusString%></td>
				
						   
		  	</tr>
		  	
		  	<script>
			
		  	</script>
			<%
			rs0.close();
		 	
		}	
	 	rs.close();	
		sh.close();	 
		
		 %>
		 </table>
		 
		 
		 <input id="btnA" class="btn" type="button" value="��������" style="display:none" onclick="jump('accept')" >
		<input id="btnR" class="btn" type="button" value="�ܾ����񲢱�ע����" style="display:none" onclick="jump('refuse')" >
		<input id="btnD" class="btn" type="button" value="���ز���" style="display:none" onclick="jump('download')" >
		<input id="btnU" class="btn" type="button" value="�ϴ��������" style="display:none" onclick="jump('upload')" >
		<input id="btnF" class="btn" type="button" value="�������" style="display:none" onclick="jump('finish')" >
		 
		 <br><br>
		 <p style="font-size:80%">*˵����</p>
		 <p style="font-size:80%">1.ѡ������ܵ�����Ȼ�������ܻ��߾ܾ���ť��</p>
		 <p style="font-size:80%">2.ѡ���ѽ��ܵ�����Ȼ�������ز��ϡ��ϴ��������������ɰ�ť��</p>
		 <p style="font-size:80%">3.��������������ʱ(��6��)�������㱻Ҫ�󷵹���״̬������"��Ҫ�󷵹���"��ʾ�������������ϴ��������ɰ�ť��</p>
		 
				
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