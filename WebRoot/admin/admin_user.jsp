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
	
	if(!userType.equals("1")){
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
<title>账号管理列表</title>
<script type="text/javascript" src="/MR_ST/resource/jquery-1.7.2.min.js"></script>
<script>
	var userId="";
	var flag=0;
  	function checkfn(){
	
		var radio = document.getElementsByName('radiocheck');
		
					
		for(var i=0; i<radio.length; i++){
			if(radio[i].checked){
			flag=1;
			userId=radio[i].value;
			}
		}
				
		
	}
	
	function jump(use){
	
		if(use=="d"&&flag==0){		
			alert('请选择账号');
		}else if(use=="d"&&flag==1){	
			if(confirm("确定停用账号"+userId+"吗？")){
				window.location.href=encodeURI(encodeURI("/MR_ST/admin/disable_user.jsp?userId="+userId+"&sid="+"<%=sid%>"+"&action=disable"));
			}
			
		}else if(use=="e"&&flag==1){	
			if(confirm("确定恢复使用账号"+userId+"吗？")){
				window.location.href=encodeURI(encodeURI("/MR_ST/admin/disable_user.jsp?userId="+userId+"&sid="+"<%=sid%>"+"&action=enable"));
			}
			
		}else if(use=="n"){
			window.location.href="/MR_ST/admin/new_user.jsp"+"?sid="+"<%=sid%>";
		}
	
	}

	function showps(id){
		var psInput = document.getElementById(id).children[2].children[0];
		var temp = psInput.children[0].value;

		if(psInput.children[0].type=="password"){
			psInput.innerHTML='<input id="pw" type="text" disabled="disabled" style="border:0px;background-color:transparent"/>';
			psInput.children[0].value=temp;
			document.getElementById(id).children[2].children[1].value="隐藏密码";
		}else if(psInput.children[0].type=="text"){
			psInput.innerHTML='<input id="pw" type="password" disabled="disabled" style="border:0px;background-color:transparent"/>';
			psInput.children[0].value=temp;
			document.getElementById(id).children[2].children[1].value="显示密码";
		}
		


	}
	
	function changeInfo(id){
		var line = document.getElementById(id);
		line.getElementsByClassName("btnCHANI")[0].style.display="none";
		line.getElementsByClassName("btnCONI")[0].style.display="";
		line.getElementsByClassName("btnCANI")[0].style.display="";
		
		var list = [2,4,5,6,7];	
		for(var i=0;i<list.length;i++){
			var n=list[i];
			var temp=line.children[n].innerHTML;
			var width=$(line).children().eq(n).width();
			
			
			
			if(n==2){
				temp=line.children[n].children[0].children[0].value;
				line.children[n].innerHTML='<input type="text" value="'+temp+'"  maxlength="40"/>';
			}else if(n==7){	line.children[n].innerHTML='<input type="email" value="'+temp+'"  maxlength="15"/>';
			}else{
				line.children[n].innerHTML='<input type="text" value="'+temp+'"  maxlength="40"/>';
			}
			
			$(line).children().eq(n).children().eq(0).width(width);
		}

	}
	
	function confirmInfo(id){
		var line = document.getElementById(id);

		var password = line.children[2].children[0].value;
		var company = line.children[4].children[0].value;
		var name = line.children[5].children[0].value;
		var tele = line.children[6].children[0].value;
		var email = line.children[7].children[0].value;
		var uid=id;
		
		window.location.href=encodeURI(encodeURI("/MR_ST/admin/change_user_info.jsp?sid=<%=sid%>&uid="+uid+
				"&password="+password+"&company="+company+"&name="+name+"&tele="+tele+"&email="+email));

	}

	function cancelInfo(){
		location.reload();
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
		<a href="/MR_ST/admin/admin_proj.jsp?">项目管理列表</a>
		<a href="/MR_ST/admin/admin_user.jsp?" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >账号管理列表</a>
		
		<h2 class="left">账号管理</h2>
		<a href="/MR_ST/reset/change_info.jsp?sid=<%=sid%>">更改基本信息</a>
		<a href="/MR_ST/reset/change_pw.jsp?sid=<%=sid%>">更改密码</a>
		<a href="/MR_ST/reset/change_email.jsp?sid=<%=sid%>">更改绑定邮箱</a>		
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">账号管理列表</h2>   
		<hr></hr>
		<br>

		<table class="tableref" id="myproject" border="1" style="width:100%" >
	    <tr>
	      <th></th>
	      <th>账号ID</th>
	      <th>账号密码</th>
	      <th>账号类型</th>
	      <th>公司名称</th>
	      <th>姓名</th>
	      <th>电话</th>
	      <th>Email</th>
	      <th>说明</th>
	      <th>状态</th>
	      <th>修改信息</th>
	      
	    </tr>
	    
	 	<%
	 	SqlHelper sh=new SqlHelper();
		String sql="select ID, PASSWORD, TYPE, USER_NAME, TELEPHONE, EMAIL, DISABLE, COMPANY"
			+" from user order by DISABLE ASC, TYPE ASC";					
		ResultSet rs=sh.query(sql);
		
	 	while(rs.next()){
	 		String usertype="";
	 		if(rs.getString(3).equals("1"))	usertype="管理员";
	 		else if(rs.getString(3).equals("2"))	usertype="项目管理员";
	 		else if(rs.getString(3).equals("3"))	usertype="当地账号";
	 		else if(rs.getString(3).equals("4"))	usertype="制作人员";
	  	%>
	  	<tr id="<%=rs.getString(1)%>">
		   <td class="radio"><input name="radiocheck" type="radio" value="<%=rs.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>
		   <td><%=rs.getString(1)%></td>
		   <td style="width:150px">
		   <spam><input id="pw" type="password"  value="<%=rs.getString(2)%>" disabled="disabled" style="border:0px;background-color:transparent"/></spam> 
		   <input id="b" class="btn" type="button"  value="显示密码" onclick="showps('<%=rs.getString(1)%>')" />
		   </td>
		   <td><%=usertype%></td>
		   <td><%=rs.getString(8)%></td>
		   <td><%=rs.getString(4)%></td>
		   <td><%=rs.getString(5)%></td>
		   <td><%=rs.getString(6)%></td>
		   
		   <% 
			if(usertype.equals("制作人员")){
				SqlHelper sh1=new SqlHelper();
				String sql1="select count(PROJECT_ID)"
					+" from assignment where STAFF_ID=? and ASSIGNMENT_STATUS='1'";
				String[] paras1={rs.getString(1)};
				ResultSet rs1=sh1.query(sql1,paras1);
				rs1.next();
				int task1=rs1.getInt(1);
				
				sql1="select count(PROJECT_ID)"
					+" from assignment where STAFF_ID=? and ASSIGNMENT_STATUS='2'";
				rs1=sh1.query(sql1,paras1);
				rs1.next();
				int task2=rs1.getInt(1);
				
				sql1="select count(PROJECT_ID)"
					+" from assignment where STAFF_ID=? and ASSIGNMENT_STATUS='0'";
				rs1=sh1.query(sql1,paras1);
				rs1.next();
				int task0=rs1.getInt(1);
				
				sql1="select count(PROJECT_ID)"
					+" from assignment where STAFF_ID=? and ASSIGNMENT_STATUS='-1'";
				rs1=sh1.query(sql1,paras1);
				rs1.next();
				int taskm1=rs1.getInt(1);
				
				int taskING=task1-task2;
				int taskED=task2;
				int taskUN=task0-task1-taskm1;
				String comments="未确定接受的项目数:"+taskUN+", 正在制作的项目数:"+taskING+", 已完成的项目数:"+taskED;
				%>
					<td><%=comments%></td>	   
			  	
				<%
					rs1.close();	
				 	sh1.close();
			}else if(usertype.equals("项目管理员")){
				SqlHelper sh1=new SqlHelper();
				String sql1="select count(PROJECT_ID)"
					+" from project_pmanager where P_MANAGER=?";
				String[] paras1={rs.getString(1)};
				ResultSet rs1=sh1.query(sql1,paras1);
				rs1.next();
				int num=rs1.getInt(1);
				String comments="负责的项目数:"+num;
				%>
					<td><%=comments%></td>	   
			  	
				<%
				rs1.close();	
			 	sh1.close();
			}else if(usertype.equals("当地账号")){
				SqlHelper sh1=new SqlHelper();
				String sql1="select count(PROJECT_ID)"
					+" from project where SUBMIT_BY=?";
				String[] paras1={rs.getString(1)};
				ResultSet rs1=sh1.query(sql1,paras1);
				rs1.next();
				int num=rs1.getInt(1);
				String comments="提交的项目数:"+num;
				%>
					<td><%=comments%></td>	   
			  	
				<%
				rs1.close();	
			 	sh1.close();
			}else if(usertype.equals("管理员")){%>
			<td></td>
			<%}
			if(rs.getString(7).equals("1")){%>
		   <td>已停用</td>
		   <%}else{ %>
		   <td>使用中</td>
		   <%} %>
		   
		   <td class="btns" style="border:0px">
		   <input type="button" class="btn btnCHANI"  value="更改信息" onclick="changeInfo('<%=rs.getString(1) %>')"/>
		   <input type="button" class="btn btnCONI"  value="确定" style="display:none" onclick="confirmInfo('<%=rs.getString(1) %>')"/>
		   <input type="button" class="btn btnCANI"  value="取消" style="display:none" onclick="cancelInfo('<%=rs.getString(1) %>')"/>
		   
		   </td> 
		   </tr>
		   
		   <script>
		   if(<%=rs.getString(7).equals("1")%>){
				
				document.getElementById("<%=rs.getString(1)%>").style.backgroundColor="#ebebeb";
				
			}
		   </script>
		<%
		}	
		 rs.close();	
		 sh.close();	 
		
	%>
		
		 </table>
		
		<div class="fix-div"> 		 
		 <input id="btnD" class="btn" type="button"  value="停用选中的账号" onclick="jump('d')"/>
		 <input id="btnD" class="btn" type="button"  value="恢复使用选中的账号" onclick="jump('e')"/>
		 
		 <input id="btnN" class="btn" type="button" style="float:right;" value="新建账号" onclick="jump('n')"/>
		</div>
				
	    <input type="hidden" name="projectId" value="${param.projectId}">
	    
	    <s:fielderror/><br><br><br>
	    <s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
		
		<script>
		$(".fix-div").width($(".right-main-body").width());
		</script>
	</div>
	
	</div>
	
	<div style="clear:both;"></div>
</div>


</body>
</html>