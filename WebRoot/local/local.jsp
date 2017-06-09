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
	
	if(!userType.equals("3")){
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

function checkfn(obj){
	
	var radio = document.getElementsByName('radiocheck');
	
	var flag=0;
	var selected;
	for(var i=0; i<radio.length&&flag==0; i++){
		if(radio[i].checked){
		flag=1;
		document.getElementById("select-tip").style.display="none";	
		
		projectId=radio[i].value;
		selected=radio[i].parentNode.parentNode;	
		
		}		
	}
	document.getElementById("btnU").style.display = "none";
	document.getElementById("btnV").style.display = "none";	
	document.getElementById("btnF").style.display = "none";
	document.getElementById("btnD").style.display = "none";
	document.getElementById("btnDD").style.display = "none";
	document.getElementById("btnAB").style.display = "none";
	document.getElementById("btnDE").style.display = "none";
	document.getElementById("btnVI").style.display = "";		
	
	if(selected.cells[6].innerHTML=="1"){
		document.getElementById("btnDE").style.display = "none";
	}else if(selected.cells[5].innerHTML=="1"){		
		document.getElementById("btnU").style.display = "";
		document.getElementById("btnV").style.display = "";
		document.getElementById("btnF").style.display = "";
		document.getElementById("btnDE").style.display = "";
	}else if(selected.cells[5].innerHTML=="7"){
		document.getElementById("btnV").style.display = "";
		document.getElementById("btnD").style.display = "";
	}else if(selected.cells[5].innerHTML=="8"){
		document.getElementById("btnV").style.display = "";
		document.getElementById("btnDD").style.display = "";	
	}else if(selected.cells[5].innerHTML=="2"||selected.cells[5].innerHTML=="3"||selected.cells[5].innerHTML=="4"||selected.cells[5].innerHTML=="5"||selected.cells[5].innerHTML=="6"){
		document.getElementById("btnV").style.display = "";
	}
			
}

function jump(use){

	if(use=="s"){
		window.location.href="/MR_ST/local/upload.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use=="uf"){
		if(confirm("确定完成"+projectId+"项目的材料提交吗？")){
			var comments = prompt("请输入您的备注，无需备注点击取消","");
			post("/MR_ST/local/upload_finish.jsp?projectId="+projectId+"&sid="+"<%=sid%>",comments);		
		}
	}else if(use=="v"){
		window.location.href="/MR_ST/local/download_m.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use==6){
		window.location.href="/MR_ST/local/project_info.jsp?projectId="+projectId+"&sid="+"<%=sid%>";
	}else if(use=="ab"){
		if(confirm("确定废弃"+projectId+"子项目吗？请备注理由")){
			var comments = prompt("请输入您的备注，无需备注点击取消","");
			post("/MR_ST/local/abandon.jsp?projectId="+projectId+"&sid="+"<%=sid%>",comments);		
		}
	}else if(use=="de"){
		if(confirm("确定删除"+projectId+"项目吗？")){
			
			window.location.href="/MR_ST/local/delete.jsp?projectId="+projectId+"&sid="+"<%=sid%>";		
		}
	}else if(use=="d"){
		window.location.href="/MR_ST/local/view_result.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&noconfirm=false";
	}else if(use=="dd"){
		window.location.href="/MR_ST/local/view_result.jsp?projectId="+projectId+"&sid="+"<%=sid%>"+"&noconfirm=true";
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

<link rel="stylesheet" type="text/css" href="/MR_ST/css/tree.css" >
<link rel="stylesheet" type="text/css" href="/MR_ST/css/step.css" >
<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">

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
		
		<a href="/MR_ST/local/local.jsp" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >项目列表</a>
		
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
		<div style="height:10px">
		<input type="button" class="btn" style="float:right;margin-right:50px" value="新建项目" onclick="window.location.href='/MR_ST/local/newproject.jsp?sid=<%=sid%>'">
		</div>
		
		<div class="tree">
		    <ul style="padding-left:0px;">
		        <li class="treeli">
		            <span class="treespan"><i class="icon-minus-sign"></i> 进行中的项目</span>
		            
		            <ul id="ingProjects">
		           
		           
					</ul>
	 			</li>		
	 	        
	 	        <br><span id="ingProjects-none" style="margin:10px 0px 0px 40px"></span>
	 	        <br>
	 	        <hr></hr>        
		        <li class="treeli">
		            <span class="treespan"><i class="icon-minus-sign"></i> 已结束的项目</span>
		            <ul id="edProjects">
		            
		            <%
	 	SqlHelper sh=new SqlHelper();
	 	
	 	String sql="select distinct a.MAIN_PROJECT_ID"
		+" from project_sub as a, project as b where a.MAIN_PROJECT_ID=b.PROJECT_ID and b.SUBMIT_BY=? order by b.SUBMIT_DATE DESC;";
		String[] paras={userId};
		ResultSet rs=sh.query(sql,paras);
		
		int row=-1;
		int mainprojectnum=0;
		while(rs.next()){
			mainprojectnum++;
			String mainId=rs.getString(1);
			//System.out.println(mainId);
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
		                	<span><input type="button" class="btn newsub" style="" value="新建子项目" onclick="window.location.href='/MR_ST/local/newsubproject.jsp?sid=<%=sid%>&mainId=<%=mainId %>'"></span>
		                    <ul>
		                    	<li class="treeli"  style="display:none">
			                    <table class="tableref" id="myproject" border="1" style="width:100%" >
							    <tr>
							      <th></th>
							      <th>子项目编号</th>
							      <th>子项目名</th>	      
							      <th>子项目进程</th>
							      <th>事件/反馈信息</th>
							    </tr>
			<%
			
			String sql1="select distinct a.PROJECT_ID, a.TITLE, a.PROGRESS, a.SUBMIT_DATE, a.V_SUBMIT_DATE, a.VALIDATION_DATE, a.ASSIGNMENT_DATE, a.START_DATE, a.FINISH_DATE, a.RESULT_VALIDATION_DATE, a.CLIENT_CONFIRM_DATE, a.NOTE, b.MAIN_PROJECT_ID, b.ABANDON"
				+" from project as a,project_sub as b where a.PROJECT_ID=b.SUB_PROJECT_ID and b.MAIN_PROJECT_ID=? and a.SUBMIT_BY=? order by b.ABANDON ASC, a.PROGRESS ASC, a.PROJECT_ID ASC";
			String[] paras1={mainId,userId};
			ResultSet rs1=sh.query(sql1,paras1);
			
			while(rs1.next()){
				//System.out.println(rs1.getString(1)+""+rs1.getString(14));
				
				int abandonflag = rs1.getString(14).equals("0")?0:1;
				
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
				
				if(!progress.equals("8")&&abandonflag!=1){
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
				
			%>
								<tr>
								   <td class="radio"><input name="radiocheck" type="radio" value="<%=rs1.getString(1)%>" onchange="checkfn(this)" autocomplete="off"/></td>
								   <td class="id-cell"><%=rs1.getString(1)%><br><label class="notelabel"></label></td>
								   <td class="name-cell" title=""><%=rs1.getString(2)%></td>
								   
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
								   <td class="note-cell" title="<%=note %>"><%=note%></td>
								   <td hidden ><%=rs1.getString(3)%></td>
								   <td hidden ><%=abandonflag%></td>
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
									document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.getElementsByClassName("notelabel")[0].innerHTML="(已完成)";
									document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.getElementsByClassName("notelabel")[0].style="color:#00FF00";				
									flag=1;
								}else if(<%=progress%> == "3"||<%=progress%> == "4"||<%=progress%> == "5"){
									document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.getElementsByClassName("note-cell")[0].innerHTML="";
									
								}
								if(<%=abandonflag%>==1){
									document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.getElementsByClassName("notelabel")[0].innerHTML="(已废弃)";
									document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.style.backgroundColor="#ebebeb";
									document.getElementById("<%=row%>"+"li7").parentNode.parentNode.parentNode.parentNode.getElementsByClassName("id-cell")[0].style.backgroundColor="#FF0000";
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
					  									
							if(<%=allfinishflag==0%>){
								var ingli = document.getElementById("<%=mainPn%>");
								document.getElementById("edProjects").appendChild(ingli);
								document.getElementById("ingProjects").appendChild(ingli);
								
							}else{
								var ingli = document.getElementById("<%=mainPn%>");
								
								var subbtns = ingli.getElementsByClassName("newsub");
								for(var i=0;i<subbtns.length;i++){
									subbtns.item(i).style="display:none";
								}
							}
								
						</script>		
			<%
		}
		rs.close();
			
		sh.close();
	 	%>    
				    </ul>
		        </li>
		        <br><span id="edProjects-none" style="margin:10px 0px 0px 40px"></span>
		    </ul>
		</div>
		
		
		
		<div class="fix-div">
		<p id="select-tip">请选择项目进行操作</p>
		<input id="btnU"  type="button" class="btn" value="提交/修改材料" style="display:none" onclick="jump('s')" >
		<input id="btnV"  type="button" class="btn" value="查看已提交的材料" style="display:none" onclick="jump('v')" >
		<input id="btnF" type="button" class="btn" value="材料提交完成，申请审核" style="display:none" onclick="jump('uf')" >
		<input id="btnD" type="button" class="btn" value="查看制作结果并确认" style="display:none" onclick="jump('d')" >
		<input id="btnDD" type="button" class="btn" value="查看制作结果" style="display:none" onclick="jump('dd')" >
		
		
		
		<input id="btnVI" type="button" class="btn" style="float:right;display:none;" value="查看项目信息" onclick="jump(6)">
		<input id="btnAB" type="button" class="btn" value="废弃子项目" style="float:right;display:none;background-color:#A80000" onclick="jump('ab')" >
		<input id="btnDE" type="button" class="btn" value="删除子项目" style="float:right;display:none;background-color:#A80000" onclick="jump('de')" >
		</div>		
		
		
		<s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
		
		<script>
		$(".fix-div").width($(".right-main-body").width());
		
		//By default collapse all branches
		if(document.getElementById("ingProjects").childElementCount==0){
			document.getElementById("ingProjects-none").innerHTML="无";
		}
		if(document.getElementById("edProjects").childElementCount==0){
			document.getElementById("edProjects-none").innerHTML="无";
		}
		</script>
		
	</div>
	
	</div>
	
	<div style="clear:both;"></div>
</div>

</body>
</html>