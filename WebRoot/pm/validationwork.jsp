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
<title>审核制作结果</title>



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
	function down(id){
		var filepath = document.getElementsByClassName(id)[0].getElementsByClassName("filepath")[0].innerHTML;
		if(filepath=="无文件"){
			alert("无文件！");
		}else{
			var assIdToDL = id;
			window.location.href="/MR_ST/pm/download_work.jsp?assId="+assIdToDL+"&sid="+"<%=sid%>";
		
		}
	}
	function link(id){
		var link = document.getElementsByClassName(id)[0].getElementsByClassName("link")[0];
		var linkbtn = document.getElementsByClassName(id)[0].getElementsByClassName("linkbtn")[0];
		if(link.innerHTML.trim()=="")	link.innerHTML="无";
		
		link.style.display="";		
		linkbtn.style.display="none";
	}
	function jump(use){
		if(use=="R"){
			if(assId==""){
				alert("请选择需要返工的任务！");
				return false;
			}
			var comments = prompt("请输入您的备注，无需备注点击取消","");
			post("/MR_ST/pm/validationF.jsp?projectId="+${param.projectId}+"&assId="+assId+"&sid="+"<%=sid%>"+"&validation=false",comments);	
		}else if(use=="U"){
			
			window.location.href="/MR_ST/pm/upload_result.jsp?projectId="+${param.projectId}+"&sid="+"<%=sid%>";	
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
		<a href="/MR_ST/pm/pm.jsp">返回项目管理列表</a>
				
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">审核制作结果：</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>

		<table class="tableref" id="myproject" border="1" style="width:100%" >
	    <tr>
	      
	      <th></th>
	      <th>被指定的制作人员</th>
	      <th>分配相机数目</th>
	      <th>具体分配的相机说明</th>
	      <th>制作结果下载(文件+链接)</th>
	      
	      <th>状态</th>
	      
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
	 		
	 		String sql00="select FILE_PATH,LINKS from ass_filepath where ASSIGNMENT_ID=?";
	 		String[] paras00={rs.getString(1)};
	 		ResultSet rs00=sh.query(sql00,paras00);
	 		rs00.next();
	 		
	 		String links = "无链接";
	 		if(!rs00.getString(2).equals("")){
	 			links = rs00.getString(2);
	 		}
	 		String filepath = "无文件";
	 		if(!rs00.getString(1).equals("")){
	 			filepath = rs00.getString(1);
	 		}
	 		
	 		String status=rs0.getString(2);
	 		String statusString="";
	 		boolean refusedflag=false;
	 		if(status.equals("2")){
	 			statusString="制作完成";
	 		}else if(status.equals("3")){
	 			statusString="已要求重做";
	 		}
		  	%>
		  	<tr class="<%=rs.getString(1)%>">
		  		<td class="radio"><input name="radiocheck" type="radio" value="<%=rs.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>		   
			   <td><%=rs0.getString(1)%></td>
			   <td><%=rs.getString(2)%></td>
			   <td><%=rs.getString(3)%></td>
			   <td style="min-width:50%">
			   <input type="button" class="btn" value="下载文件" onclick="down('<%=rs.getString(1)%>')">
			   <input type="button" class="btn linkbtn" value="显示链接" onclick="link('<%=rs.getString(1)%>')">
			   <br><label class="link" style="display:none"><%=links%></label>
			   <label class="filepath" style="display:none"><%=filepath%></label>
			   </td>
			   
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
		 
		 <input id="btnV" class="btn" type="button" style="font-size:20px" value="要求选中的人员重做" onclick="jump('R')"/>
		 
		 <input id="btnU" class="btn" type="button" style="font-size:20px" value="上传合并后的制作结果" onclick="jump('U')"/>
		 		 
		 <br><br>
		 <p style="font-size:80%">*说明：</p>
		 <p style="font-size:80%">1.下载各个人员的制作结果审核，若需要返工则点击"要求选中的人员重做"</p>
		 <p style="font-size:80%">2.所有人员制作结果都没问题后请合并，点击"上传合并后的制作结果"进行上传。</p>
		 
		 
				
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