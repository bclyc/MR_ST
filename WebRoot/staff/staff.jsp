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
	
	if(!userType.equals("4")){
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
<title>项目列表</title>
<script type="text/javascript" src="/MR_ST/resource/jquery-1.7.2.min.js"></script>
<script type="text/javascript">
$(function(){
    $('.tree li:has(ul)').addClass('parent_li').find(' > span').attr('title', 'Collapse this branch');
    $('.tree li.parent_li > span').on('click', function (e) {
        var children = $(this).parent('li.parent_li').find(' > ul > li');
        if (children.is(":visible")) {
            children.hide('fast');
            $(this).attr('title', 'Expand this branch').find(' > i').addClass('icon-plus-sign').removeClass('icon-minus-sign');
        } else {
            children.show('fast');
            $(this).attr('title', 'Collapse this branch').find(' > i').addClass('icon-minus-sign').removeClass('icon-plus-sign');
        }
        e.stopPropagation();
    });
});
</script>

<script type="text/javascript">
var projectId="";

function checkfn(use){
	
	var radio = document.getElementsByName('radiocheck');
	
	var selected;
	var flag=0;
	for(var i=0; i<radio.length&&flag==0; i++){
		if(radio[i].checked){
		flag=1;
		document.getElementById("select-tip").style.display="none";	
		
		projectId=radio[i].value;
		selected=radio[i].parentNode.parentNode;
		}
	}
	document.getElementById("btnVass").style.display = "none";
	document.getElementById("btnVI").style.display = "";
	
	if(selected.cells[5].innerHTML=="4"){
		document.getElementById("btnVass").style.display = "";		
	}else if(selected.cells[5].innerHTML=="5"){
		document.getElementById("btnVass").style.display = "";
	}else if(selected.cells[5].innerHTML=="6"){
		document.getElementById("btnVass").style.display = "";
	}
		
}

function jump(use){
	if(use=="assignment"){
		
		window.location.href=encodeURI(encodeURI("/MR_ST/staff/view_assignment.jsp?projectId="+projectId+"&staffId="+"<%=userId%>"+"&sid="+"<%=sid%>"));
				
	}else if(use=="down"){
		window.location.href="/MR_ST/local/download_m.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use=="up"){
		window.location.href="/MR_ST/staff/upload_conf.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use=="finish"){
		if(confirm("确定"+projectId+"制作完成吗？")){
			var comments = prompt("请输入您的备注，无需备注点击取消","");
			post(encodeURI(encodeURI("/MR_ST/staff/finish.jsp?projectId="+projectId+"&staffId="+"<%=userId%>"+"&sid="+"<%=sid%>")),comments);
		
		}
		
	}else if(use==6){
		window.location.href="/MR_ST/staff/project_info.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
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
.tableref
{
	table-layout:fixed;
}
.tableref tr td
{
	height:100px;
}
.tableref tr td.name-cell
{
	height:100px;overflow:hidden;text-overflow:ellipsis;
}
.tableref tr td.note-cell
{
	height:100px;overflow:hidden;text-overflow:ellipsis;
}
.tableref tr th:nth-child(1)
{
	width:3%;
}
.tableref tr th:nth-child(2)
{
	width:7%;
}
.tableref tr th:nth-child(3)
{
	width:8%;
}
.tableref tr th:nth-child(4)
{
	width:72%;
}
</style>
  
  <link rel="stylesheet" type="text/css" href="/MR_ST/css/tree.css" >
  <link rel="stylesheet" type="text/css" href="/MR_ST/css/step.css" >
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
		
		<a href="/MR_ST/staff/staff.jsp" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >项目列表</a>
		
		<h2 class="left">账号管理</h2>
		<a href="/MR_ST/reset/change_info.jsp?sid=<%=sid%>">更改基本信息</a>
		<a href="/MR_ST/reset/change_pw.jsp?sid=<%=sid%>">更改密码</a>
		<a href="/MR_ST/reset/change_email.jsp?sid=<%=sid%>">更改绑定邮箱</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">我负责的项目</h2>   
		<hr></hr>
		
		<div class="tree">
		    <ul style="padding-left:0px;">
		        <li class="treeli">
		            <span class="treespan"><i class="icon-minus-sign"></i> 进行中的项目</span>
		            <ul id="ingProjects">
		           
		            <%
	 	SqlHelper sh=new SqlHelper();
	 	
	 	String sql="select distinct a.MAIN_PROJECT_ID"
		+" from project_sub as a, assignment as b, project as c"+
	 	" where a.SUB_PROJECT_ID=b.PROJECT_ID and b.PROJECT_ID=c.PROJECT_ID and b.STAFF_ID=? and a.ABANDON=0 order by c.PROJECT_ID DESC;";
		String[] paras={userId};
		ResultSet rs=sh.query(sql,paras);
		
		int row=-1;
		int mainprojectnum=0;
		while(rs.next()){
			mainprojectnum++;
			String mainId=rs.getString(1);
			System.out.println(mainId);
			int allfinishflag=1;
			int allinvisibleflag=1;
			String mainPn=mainprojectnum+"table";
			
			String sqlm="select TITLE,SUBMIT_DATE from project where PROJECT_ID=?";
			String[] parasm={mainId};
			ResultSet rsm=sh.query(sqlm,parasm);
			rsm.next();
			String projname=rsm.getString(1);
			String projsubdate=rsm.getString(2);
			projsubdate=projsubdate.substring(0, 10);
			
			String btnManager="btnManager"+mainprojectnum;
			sqlm="select P_MANAGER from project_pmanager where PROJECT_ID=?";			
			rsm=sh.query(sqlm,parasm);
			int existPnamager = 0;
			String sentencePnamager="";
			if(rsm.next()){
				existPnamager=1;
				sentencePnamager=", 项目管理员:"+rsm.getString(1);
			}
			%>
						<li class="treeli" id="<%=mainPn %>">
		                	<span class="treespan"><i class="icon-plus-sign"></i> <%=projname %></span>
		                	<span style="font-size:70%;font-weight:bold;margin-left:20px">项目编号:<%=mainId %>,  创建日期:<%=projsubdate %><%=sentencePnamager %></span>
		                	
		                    <ul>
		                    	<li class="treeli" style="display:none">
			                    <table class="tableref" id="myproject" border="1" style="width:100%" >
							    <tr>
							      <th></th>
							      <th>子项目编号</th>
							      <th>子项目名</th>	      
							      <th>子项目进程</th>
							      <th>事件/反馈信息</th>
							    </tr>
			<%
			
			String sql1="select distinct a.PROJECT_ID, a.TITLE, a.PROGRESS, a.SUBMIT_DATE, a.V_SUBMIT_DATE, a.VALIDATION_DATE, a.ASSIGNMENT_DATE, a.START_DATE, a.FINISH_DATE, a.RESULT_VALIDATION_DATE, a.CLIENT_CONFIRM_DATE, a.NOTE, b.MAIN_PROJECT_ID, c.ASSIGNMENT_ID"
				+" from project as a,project_sub as b,assignment as c where a.PROJECT_ID=b.SUB_PROJECT_ID and a.PROJECT_ID=c.PROJECT_ID and b.MAIN_PROJECT_ID=? and c.STAFF_ID=? and b.ABANDON=0 order by  a.PROGRESS ASC,a.PROJECT_ID ASC,c.ASSIGNMENT_ID ASC";
			String[] paras1={mainId,userId};
			ResultSet rs1=sh.query(sql1,paras1);
			
			while(rs1.next()){
				//System.out.println(rs1.getString(1)+""+rs1.getString(14));
				String ass_id=rs1.getString(14);
				
				SqlHelper sh5=new SqlHelper();
				String sql5="select ASSIGNMENT_STATUS, STATUS_CHANGE_DATE"
					+" from assignment where PROJECT_ID=? and STAFF_ID=? and ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC;";
				String paras5[]={rs1.getString(1),userId,ass_id};				
				ResultSet rs5=sh5.query(sql5, paras5);
				rs5.next();
				System.out.println(rs5.getString(1)+" "+rs5.getString(2));
				if(rs5.getString(1).equals("-1")){
					continue;
				}
				if(rs1.getString(3).equals("8")){
					continue;
				}
				allinvisibleflag=0;
				
				row++;								
		 		String li0=row+"li0";
		 		String li1=row+"li1";
		 		String li2=row+"li2";
		 		String li3=row+"li3";
		 		String li4=row+"li4";
		 		String li5=row+"li5";
		 		String li6=row+"li6";
		 		String li7=row+"li7";
				/* if(rs.getString(15).equals("0")) progress="待上传材料";
				else if (rs.getString(15).equals("1")) progress="待审核";
				else if (rs.getString(15).equals("2")) progress="审核通过，待分配任务";
				else if (rs.getString(15).equals("3")) progress="分配任务待接受中";
				else if (rs.getString(15).equals("4")) progress="制作中";
				else if (rs.getString(15).equals("5")) progress="制作任务完成,等待审核";
				else if (rs.getString(15).equals("6")) progress="制作完成"; */
				
				String progress = rs1.getString(3);
				String note=rs1.getString(12);
				if(progress.equals("4")){
					SqlHelper sh55=new SqlHelper();
					String sql55="select ASSIGNMENT_STATUS, STATUS_CHANGE_DATE"
						+" from assignment where PROJECT_ID=? and STAFF_ID=? order by STATUS_CHANGE_DATE DESC;";
					String paras55[]={rs1.getString(1),userId};				
					ResultSet rs55=sh55.query(sql55, paras55);
					rs5.next();
				}
				if(!progress.equals("8")){
					allfinishflag=0;
				}
				
				String[] date1= {"","","","","","","",""};
				String[] date2= {"","","","","","","",""};
				int progressnum = Integer.parseInt(progress);
				
				for(int i=0;i< progressnum;i++){
					String datetime=rs1.getString(4+i);
					if(datetime.length()>=19){
						date1[i]=datetime.substring(0, 10);
						date2[i]=datetime.substring(11, 19);
					}					
				}
				
				boolean redoflag=false;
				if(progress.equals("6")){
					if(rs1.getString(12).indexOf("返工")>=0)		redoflag=true;
				}
			%>
								<tr>
								   <td class="radio"><input name="radiocheck" type="radio" value="<%=rs1.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>
								   <td><%=rs1.getString(1)%></td>
								   <td title="<%=rs1.getString(2)%>"><%=rs1.getString(2)%></td>
								   
								   <td class="step-cell" >
								   <div style="display:flex">
								   		<ol class="ui-step ui-step-8" style="width:100%;height:100%" >
										<li id="<%=li0 %>" class="step-start step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">0</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[0] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[0] %></span>
												<span class="ui-step-cont-text">新建项目</span>
												
											</div>
										</li>
										<li id="<%=li1 %>" class="step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">1</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[1] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[1] %></span>
												<span class="ui-step-cont-text">材料上传并提交审核</span>
											</div>
										</li>
										<li id="<%=li2 %>" class="step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">2</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[2] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[2] %></span>
												<span class="ui-step-cont-text">材料审核</span>
											</div>
										</li>
										<li id="<%=li3 %>" class="step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">3</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[3] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[3] %></span>
												<span class="ui-step-cont-text">制作任务分配</span>
											</div>
										</li>
										<li id="<%=li4 %>" class="step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">4</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[4] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[4] %></span>
												<span class="ui-step-cont-text">制作任务接受</span>
											</div>
										</li>
										<li id="<%=li5 %>" class="step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">5</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[5] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[5] %></span>
												<span class="ui-step-cont-text">制作中</span>
											</div>
										</li>
										<li id="<%=li6 %>" class="step-done">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">6</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[6] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[6] %></span>
												<span class="ui-step-cont-text">制作结果审核</span>
											</div>
										</li>			
										<li id="<%=li7 %>" class="step-end">
											<div class="ui-step-line"></div>
											<div class="ui-step-cont">
												<span class="ui-step-cont-number">7</span>
												<span id="01" class="ui-step-cont-date1"><%=date1[7] %></span>
												<span id="02" class="ui-step-cont-date2"><%=date2[7] %></span>
												<span class="ui-step-cont-text">客户确认结果</span>
											</div>
										</li>
									</ol>
								   </div>
								   </td>
								   <td class="note-cell" title="<%=note%>"><%=note%></td>
								   <td hidden ><%=rs1.getString(3)%></td>
							  	</tr>
							  	
							  	<script>
							  		var flag=0;
							  		var i=1;
							  		
							  		if(<%=progress%> == "0"){
										document.getElementById("<%=row%>"+"li0").className="step-start step-active";
										document.getElementById("<%=row%>"+"li0").style="";
										flag=1;
									}
									for(i=1; i<=6; i++){
										var id="<%=row%>"+"li"+i;
										if(flag==1){
											document.getElementById(id).className="";					
										}else if(flag==0){
											if(<%=progress%>==(i+"")){
												document.getElementById(id).className="step-active";
												flag=1;
											}
										}
									}
									if(<%=progress%> == "7"){
										document.getElementById("<%=row%>"+"li7").className="step-end step-active";
										flag=1;
									}else if(<%=progress%> == "8"){
										document.getElementById("<%=row%>"+"li7").className="step-end step-done";
										document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.style.backgroundColor="#ebebeb";
										flag=1;
									}
									if(<%=redoflag%>){
										document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.getElementsByClassName("note-cell")[0].style.color="#ff0000";
									}
							  	</script>
				<%	
			}
			rs1.close();
			
			%>
								</table>
								</li>
							</ul>
						</li>
						<script>
					  		if(<%=allinvisibleflag==1%>){
								var ingli = document.getElementById("<%=mainPn%>");
								
								document.getElementById("ingProjects").removeChild(ingli);
								
							}
								
						</script>		
			<%
		}
		rs.close();
			
		sh.close();
	 	%>    
				    </ul>
		        </li>
		        
		        <br><span id="ingProjects-none" style="margin:10px 0px 0px 40px"></span>
		    </ul>
		</div>
		
		<div class="fix-div">
		<p id="select-tip">请选择项目进行操作</p>
		
		<input id="btnVass" class="btn" type="button" value="查看/处理制作任务" style="display:none" onclick="jump('assignment')" >		
				
		<input id="btnVI" type="button" class="btn" style="float:right;display:none;" value="查看项目信息" onclick="jump(6)">		
		</div>
		
		<s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
		<input type="hidden" name="projectId" value="${param.projectId}">
		    
	    <s:fielderror/><br>
	    
	    
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