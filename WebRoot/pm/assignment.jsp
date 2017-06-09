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
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
						
	}		 
%>

<!DOCTYPE html>
<html>
<head>
<title>分配制作任务</title>

<%
	
	SqlHelper sh2=new SqlHelper(); 
	String sql2="select VALIDATION,CAMERA_NUM from project where PROJECT_ID=?";
	String[] paras2={request.getParameter("projectId")};
	ResultSet rs2=sh2.query(sql2, paras2);
	rs2.next();
	int flagV=-1;
	if(rs2.getString(1).equals("1"))	flagV=1;
	String camnum = rs2.getString(2);
 %>

<script>
		
	function jump(){		
		var comments = prompt("请输入您的备注，无需备注点击取消","");
		post("/MR_ST/pm/assignment_action.jsp?projectId="+${param.projectId}+"&sid="+"<%=sid%>",comments);	
		
	}

	function changeCamNum(){
		
		var comments = Number(prompt("请输入相机数目，无需备注点击取消",""));
		if(isNaN(comments)||comments==""){
			alert("请输入数字");
		}else{
			window.location.href="/MR_ST/pm/change_camnum.jsp?projectId="+${param.projectId}+"&sid="+"<%=sid%>"+"&camNum="+comments;

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
    
    var arrayObj = new Array();
    var rows=document.getElementsByName("row"); 
    for(var i=0;i<rows.length;i++){
    	var userid=rows[i].getElementsByClassName("userid")[0].innerHTML;
    	var CamNum=rows[i].getElementsByClassName("CamNum")[0].children[0].value;
    	var CamNote=rows[i].getElementsByClassName("CamNote")[0].children[0].value;
    	console.log(rows[i].getElementsByClassName("CamNum")[0].children[0].value);
    	console.log(rows[i].getElementsByClassName("CamNote")[0].children[0].value);
    	
    	if(CamNum==""&&CamNote!=""){
    		alert("如果分配任务，相机数目和说明需要同时填写！");
    		return false;
    	}
    	else if(CamNum!=""&&CamNote==""){
    		alert("如果分配任务，相机数目和说明需要同时填写！");
    		return false;
    	}
    	else if(CamNum!=""&&CamNote!=""){
    		arrayObj.push([userid,CamNum,CamNote]);
    		var opt = document.createElement("textarea");        
		    opt.name = "array";        
		    opt.value = userid+","+CamNum+","+CamNote;
		    temp.appendChild(opt);
    	}
    } 
    console.log(arrayObj);
         
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
		<a href="/MR_ST/pm/pm.jsp?">项目管理列表</a>
				
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">指定该项目的配置人员：</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br>
		 所需相机数目：<%=camnum %> <input class="btn" type="button" style="font-size:20px" value="更改相机数目" onclick="changeCamNum()"/>
		 <br><br>

		<table class="tableref" id="myproject" border="1" style="width:100%" >
	    <tr>
	      
	      <th>人员ID</th>
	      <th>姓名</th>
	      <th>电话</th>
	      <th>Email</th>
	      <th style="width:10%">未确定接受的项目数</th>
	      <th style="width:10%">正在制作的项目数</th>	      
	      <th style="width:10%">已完成的项目数</th>
	      <th style="width:10%">分配相机数目</th>
	      <th style="width:30%">具体分配的相机说明</th>
	      
	    </tr>
	    
	 	<%
	 	SqlHelper sh=new SqlHelper();
		String sql="select ID, USER_NAME, TELEPHONE, EMAIL"
			+" from user where TYPE='4' and DISABLE='0'";					
		ResultSet rs=sh.query(sql);
		
	 	while(rs.next()){
	 		
	  	%>
	  	<tr name="row">		   
		   <td class="userid"><%=rs.getString(1)%></td>
		   <td><%=rs.getString(2)%></td>
		   <td><%=rs.getString(3)%></td>
		   <td><%=rs.getString(4)%></td>
		<%
		SqlHelper sh0=new SqlHelper();
		String sql0="select distinct ASSIGNMENT_ID"
			+" from assignment where STAFF_ID=?";
		String[] paras0={rs.getString(1)};
		ResultSet rs0=sh0.query(sql0,paras0);
		
		int taskING=0;
		int taskED=0;
		int taskUN=0;
		while(rs0.next()){
			SqlHelper sh1=new SqlHelper();
			String sql1="select ASSIGNMENT_STATUS"
				+" from assignment where STAFF_ID=? and ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC";
			String[] paras1={rs.getString(1),rs0.getString(1)};
			ResultSet rs1=sh1.query(sql1,paras1);
			rs1.next();
			if(rs1.getString(1).equals("0"))	taskUN++;
			else if(rs1.getString(1).equals("1"))	taskING++;
			else if(rs1.getString(1).equals("2"))	taskED++;
			
			
			
			rs1.close();	
		 	sh1.close();
		}
		
		
		%>
			<td><%=taskUN%></td>
			<td><%=taskING%></td>
			<td><%=taskED%></td>
			<td class="CamNum"><input type="number" value="" style="width:98%"></td>
			<td class="CamNote"><input type="text" value="" style="width:98%"></td>		   
	  	</tr>
		<%
			
		  }	
		 rs.close();	
		 sh.close();	 
		
		 %>
		 </table>
		 
		 <p style="font-weight:bold">*说明：</p>
		 <p style="font-weight:bold">1.不分配任务的人员不填；如果分配任务，相机数目和说明需要同时填写。</p>
		 <p style="font-weight:bold">2.请确保分配的相机数之和等于子项目需要制作的相机数</p>
		 <br>
		 <input id="btnV" class="btn" type="button" style="font-size:20px" value="确定分配" onclick="jump()"/>
		 
				
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