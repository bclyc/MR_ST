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
	
	if(!sid.equals(request.getParameter("sid"))){		
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
<title>��Ŀ����</title>

<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=0f29dcda3c41b2e322b6e4075c1c059c" >
  
</script>
<script>
window.onload = initMap;
var marker;
var markerPosition = "";
<%
	SqlHelper sh5=new SqlHelper(); 
	String sql5="select LNGLAT from project_filepath where PROJECT_ID=?";
	String[] paras5={request.getParameter("projectId")};
	ResultSet rs5=sh5.query(sql5, paras5);
	
	String ll="";
	double lng=116.39;
	double lat=39.9;
	
	if(rs5.next()){
		if(rs5.getString(1)!=null&&!"".equals(rs5.getString(1).trim())){
			ll=rs5.getString(1);		
			lng= Double.valueOf(ll.substring(0, ll.lastIndexOf("_")));
			lat= Double.valueOf(ll.substring(ll.lastIndexOf("_")+1, ll.length()));
		}		
	}
	
	String sql6="select FINE_MODELING from project_filepath where PROJECT_ID=?";
	String[] paras6={request.getParameter("projectId")};
	ResultSet rs6=sh5.query(sql6, paras6);
	
	String fineLink="";
	if(rs6.next()){
		if(rs6.getString(1)!=null){
			fineLink=rs6.getString(1);					
		}		
	}
%>
  
function copy(obj){
	
	if(window.clipboardData) {
		var linkid="link"+obj.id;		
		var link = document.getElementById(linkid);
		var clipBoardContent="";
		clipBoardContent+=link.value;
		window.clipboardData.setData("Text",clipBoardContent);
		alert("���Ƴɹ�");
	}else if (navigator.userAgent.indexOf("MSIE") == -1){
		alert("�����������֧�ִ˹���,���ֶ������ı���������");
		return ;
	}
}

function AutoResizeImage(maxWidth,maxHeight,objImg){
	var img = new Image();
	img.src = objImg.src;
	var hRatio;
	var wRatio;
	var Ratio = 1;
	var w = img.width;
	var h = img.height;
	wRatio = maxWidth / w;
	hRatio = maxHeight / h;
	if (maxWidth ==0 && maxHeight==0){
	Ratio = 1;
	}else if (maxWidth==0){//
	if (hRatio<1) Ratio = hRatio;
	}else if (maxHeight==0){
	if (wRatio<1) Ratio = wRatio;
	}else if (wRatio<1 || hRatio<1){
	Ratio = (wRatio<=hRatio?wRatio:hRatio);
	}
	if (Ratio<1){
	w = w * Ratio;
	h = h * Ratio;
	}
	objImg.height = h;
	objImg.width = w;
}
	
function initMap(){
  		var map = new AMap.Map("container",{
            isHotspot:true
    });
	    map.setZoom(17);
	    map.setCenter([<%=lng%>,<%=lat%>]);
	    
	    AMap.service('AMap.Geocoder',function(){//�ص�����
	        //ʵ����Geocoder
	        geocoder = new AMap.Geocoder({
	            city: "010"//���У�Ĭ�ϣ���ȫ����
	        });
	        
	    })
	    

	    var geolocation;
	   	map.plugin('AMap.Geolocation', function(){
	        geolocation = new AMap.Geolocation({
	            enableHighAccuracy: true,//�Ƿ�ʹ�ø߾��ȶ�λ��Ĭ��:true
	            timeout: 10000,          //����10���ֹͣ��λ��Ĭ�ϣ������
	            maximumAge: 0,           //��λ�������0���룬Ĭ�ϣ�0
	            convert: true,           //�Զ�ƫ�����꣬ƫ�ƺ������Ϊ�ߵ����꣬Ĭ�ϣ�true
	            showButton: true,        //��ʾ��λ��ť��Ĭ�ϣ�true
	            buttonPosition: 'LB',    //��λ��ťͣ��λ�ã�Ĭ�ϣ�'LB'�����½�
	            buttonOffset: new AMap.Pixel(10, 20),//��λ��ť�����õ�ͣ��λ�õ�ƫ������Ĭ�ϣ�Pixel(10, 20)
	            showMarker: true,        //��λ�ɹ����ڶ�λ����λ����ʾ���ǣ�Ĭ�ϣ�true
	            showCircle: true,        //��λ�ɹ�����ԲȦ��ʾ��λ���ȷ�Χ��Ĭ�ϣ�true
	            panToLocation: true,     //��λ�ɹ��󽫶�λ����λ����Ϊ��ͼ���ĵ㣬Ĭ�ϣ�true
	            zoomToAccuracy:true      //��λ�ɹ��������ͼ��Ұ��Χʹ��λλ�ü����ȷ�Χ��Ұ�ڿɼ���Ĭ�ϣ�false
	        });
	        map.addControl(geolocation);
	        AMap.event.addListener(geolocation, 'complete', onComplete);//���ض�λ��Ϣ
    	});
		
		marker = new AMap.Marker({
		          position:[<%=lng%>,<%=lat%>],
		          map:map,
		        });
		        
		geocoder.getAddress([<%=lng%>,<%=lat%>], function(status, result) {
	            if (status === 'complete' && result.info === 'OK') {
	            
	               document.getElementById("location").innerHTML="��ǵ�ַ��"+result.regeocode.formattedAddress;
	               
	            }else{
	               
	            }
	        });
	    
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
		<%if(userType.equals("1")){ %>
		<a href="/MR_ST/admin/admin_proj.jsp">������Ŀ�б�</a>
		<%}else if(userType.equals("2")){ %>
		<a href="/MR_ST/pm/pm.jsp">������Ŀ�б�</a>
		<%}else if(userType.equals("3")){ %>
		<a href="/MR_ST/local/local.jsp">������Ŀ�б�</a>
		<%}else if(userType.equals("4")){ %>
		<a href="/MR_ST/staff/staff.jsp">������Ŀ�б�</a>
		<%} %>
		
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">�鿴��Ŀ����</h2>   
		<hr></hr>
		 Project ID: ${param.projectId} <br><br>
		    
		 <%
		 SqlHelper sh0=new SqlHelper(); 
		 String sql0="select BASE_MAP, BASE_MAP_MARKED from project_filepath where PROJECT_ID=?";
		 String[] paras0={request.getParameter("projectId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String base_m="";
		 String base_m_m="";
		 if(rs0.next()){
		 	if(rs0.getString(1)!=null&&!"".equals(rs0.getString(1).trim()))	base_m =rs0.getString(1);		 	
		 	if(rs0.getString(2)!=null&&!"".equals(rs0.getString(2).trim()))	base_m_m =rs0.getString(2);
		 }		 
		 %>
		 <table>   
		    <tr><td>��ͼ����ͼ��</td>
		 	<td id="img1"><img id="base_m" style="margin:5px 5px;" src="<%=base_m%>" onload="AutoResizeImage(0,200,this)"/></td>
		 	<td><input class="btn" type="button" value="����ԭͼ" onclick="window.location.href='/MR_ST/staff/filedownload.jsp?projectId=${param.projectId}&use=base_m&sid=<%=sid%>'"></td>
		 	</tr>
		   
		    <tr><td>��ע��ĵ�ͼ����ͼ:</td>
	     	<td id="img2"><img style="margin:5px 5px;" src="<%=base_m_m%>" onload="AutoResizeImage(0,200,this)"/></td>
	     	<td><input class="btn" type="button" value="����ԭͼ" onclick="window.location.href='/MR_ST/staff/filedownload.jsp?projectId=${param.projectId}&use=base_m_m&sid=<%=sid%>'"></td>
	     	</tr>		 
		 </table>
		 
		 <script type="text/javascript">
		 if(<%=base_m.equals("")%>){
		 	document.getElementById("img1").innerHTML="δ�ϴ�";
		 }
		 if(<%=base_m_m.equals("")%>){
		 	document.getElementById("img2").innerHTML="δ�ϴ�";
		 }
		 </script>
		 
		 <p id="location">��ǵ�ַ��</p>
		 <div id="mapDiv">
		 <div id="container" style="width:600px; height: 500px;">
		 </div>
		 </div>
		 
		 <script type="text/javascript">
		 if(<%=ll.equals("")%>){
		 	document.getElementById("mapDiv").innerHTML="δ���";
		 }
		 </script>
		 
		 <br>
		<table class="tableref" id="myproject" border="1" >
	    <tr>
	      <th>������</th>
	      <th>��Ƶ����</th>
	      <th></th>
	      
	    </tr>
	    
	 	<%
	 	SqlHelper sh=new SqlHelper();
	 	
	 	int rscount =0;
	 	for(int i=1;i<=30;i++){
	 		String sql="select CAMERA_"+i+" from project_filepath where CAMERA_"+i+" IS NOT NULL and PROJECT_ID=?";
	 		String paras[]={request.getParameter("projectId")};
	 		ResultSet rs=sh.query(sql, paras);
	 		
	 		
	 		if(rs.next()){
	 			rscount++;
	 			String linkid="link"+i;
	 	%>
	 		<tr>
	 		<td>���<%=i%></td>
	 		<td><input id="<%=linkid%>" type="text" readonly="readonly" value="<%=rs.getString(1)%>" style="width:90%" ></td>
	 		<td><input class="btn" id="<%=i%>" type="button" value="��������" onclick="copy(this)"></td>
	 		</tr>
	 	<%	
	 		}else{
	 			rs.close();	
		 		sh.close();
	 			break;
	 		}
	 	}
	 	
	 	if(rscount==0){			
	  	%>
	  		<tr>
	  		<td>δ�ϴ�</td>
	  		<td>δ�ϴ�</td>
	  		</tr>
	  	<%} 
	  	%>	  	
		 </table>
		 
		 
		 <div>
		 <h3 id="isfine">�Ƿ�ϸ��ģ��</h3>
		 <div id="finelinkDiv" style="display:none">
		 ��ϸ��ģ�������ӣ� <input type="text" id="linkfine1" maxlength="200"  style="width:400px" readonly="readonly"/>
		 <input class="btn" id="fine1" type="button" value="���Ʋ�������" onclick="copy(this)">
		 </div>
		 </div>
		 
		 <script type="text/javascript">
		 if(<%=fineLink.equals("0")%>){
		 	document.getElementById("isfine").innerHTML="�Ƿ�ϸ��ģ�� ��";
		 }else{
		 	document.getElementById("isfine").innerHTML="�Ƿ�ϸ��ģ�� ��";
		 	document.getElementById("finelinkDiv").style.display="";
		 	document.getElementById("linkfine1").value="<%=fineLink%>";
		 }
		 </script>
		 		
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