<%@ page contentType="text/html;charset=GBK" import="java.util.*,database.SqlHelper,java.sql.*"%>
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
<title>��Ŀ�������</title>
<script>
var projectId=${param.projectId};
function down(id){
	var filepath = document.getElementsByClassName('file')[0].innerHTML;
	if(filepath=="���ļ�"){
		alert("���ļ���");
	}else{
		window.location.href="/MR_ST/local/download_conf.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}
}

function jump(use){

	if(use=="c1"){
		if(confirm("ȷ��"+projectId+"��Ŀ�Ľ�����")){
			var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
			post("/MR_ST/local/confirm_end.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&confirm=true",comments);		
		}
	}else if(use=="c2"){
		if(confirm("ȷ��Ҫ��"+projectId+"��Ŀ������")){
			var comments = prompt("���������ı�ע�����豸ע���ȡ��","");
			post("/MR_ST/local/confirm_end.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&confirm=false",comments);		
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
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>
<%	
	ResourceBundle myResourcesBundle = ResourceBundle.getBundle("global");
%>
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
		
		<a href="/MR_ST/local/local.jsp" >������Ŀ�б�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2>��Ŀ�������(�ļ�+����)</h2>
		<hr></hr>		
		 Project ID: ${param.projectId} <br><br>
		
		<% 
			SqlHelper sh=new SqlHelper();
			String sql="select CONFIG_FILE,RESULT_LINK from project_filepath where PROJECT_ID=?";
			String[] paras={request.getParameter("projectId")};
			ResultSet rs=sh.query(sql,paras);
			
			rs.next();
			
			String filepath="���ļ�";
			String link="��";
			if(rs.getString(2)!=null&&!"".equals(rs.getString(2).trim()))	link=rs.getString(2);				
			if(rs.getString(1)!=null&&!"".equals(rs.getString(1).trim()))	filepath=rs.getString(1);
			
			boolean noconfirmflag = request.getParameter("noconfirm").equals("true")?true:false;
		%>
		
		�ļ���<input type="button" class="btn" value="�������" onclick="down('${param.projectId}')"> <br>
		���ӣ�<label><%=link%></label>
		<label class="file" style="display:none"><%=filepath%></label>
		<br><br>
		
		
		<input id="btnC1" type="button" class="btn" value="ȷ����Ŀ���" style="" onclick="jump('c1')" >
		<input id="btnC2" type="button" class="btn" value="Ҫ�󷵹���˵������" style="" onclick="jump('c2')" >
		
		<script>
		if(<%=noconfirmflag%>){
			document.getElementById("btnC1").style.display="none";
			document.getElementById("btnC2").style.display="none";
		}
		</script>
		
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