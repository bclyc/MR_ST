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
<title>�ϴ���ͼ</title>

  <script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=0f29dcda3c41b2e322b6e4075c1c059c" >
  
  </script>
  <script type="text/javascript">
  window.onload = initMap;
  var markerold;
  var markerPosition = "";
  var geocoder;
  
  var map;  
  var marker = new Array();
  var markersOnMap = new Array();  
  var windowsArr = new Array();
  var cloudDataLayer;
  var MSearch;  
  var keyword;
  
function PreviewImage(imgFile)
   {
    var pattern = /(\.*.jpg$)|(\.*.png$)|(\.*.jpeg$)|(\.*.gif$)|(\.*.bmp$)/;     
    if(!pattern.test(imgFile.value))
    {
     alert("ϵͳ��֧��jpg/jpeg/png/gif/bmp��ʽ����Ƭ��"); 
     imgFile.focus();
    }
    else
    {
     var path;
     
     if(document.all)//IE
     {
      imgFile.select();
      path = document.selection.createRange().text;
      document.getElementById("imgPreview").innerHTML="";
      document.getElementById("imgPreview").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true',sizingMethod='',src=\"" + path + "\")";//ʹ���˾�Ч��
     }
     else//FF
     {
      path = URL.createObjectURL(imgFile.files[0]);
      document.getElementById("imgPreview").innerHTML = "<img id='preview' src='"+path+"'/>";      
     }
     
    var img = new Image();    
    img.onload = function(){
    	var divh=500;
    	var divw=500;
        var imgw=img.width;
    	var imgh=img.height;
	   
	    var wratio=imgw/divw;
		var hratio=imgh/divh;		
		
		var w=(wratio>=hratio)?(imgw/wratio):(imgw/hratio);
		var h=(wratio>=hratio)?(imgh/wratio):(imgh/hratio);		
		
		document.getElementById("preview").width=w;
		document.getElementById("preview").height=h;
	};
	img.src = path;
	
    }
   }
   
   function initMap(){
  		map = new AMap.Map("container",{
            isHotspot:true
    });
	    map.setZoom(12);
	    map.setCenter([116.39,39.9]);
	    
	    AMap.service('AMap.Geocoder',function(){//�ص�����
	        //ʵ����Geocoder
	        geocoder = new AMap.Geocoder({
	            city: "010"//���У�Ĭ�ϣ���ȫ����
	        });
	       
	    })
	    
	    //����������ʾ���  
	    map.plugin(["AMap.Autocomplete"], function() {  
        //�ж��Ƿ�IE�����  
	        if (navigator.userAgent.indexOf("MSIE") > 0) {  
	            document.getElementById("keyword").onpropertychange = autoSearch;  
	        }  
	        else {  
	            document.getElementById("keyword").oninput = autoSearch;  
	        }  
	    });
	    AMap.event.addListener(map,'click',getLnglat); //����¼�
	    AMap.event.addListener(map,'click',getLnglat);
	    
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
		
	   	markerold = new AMap.Marker({
// 		          position:[116.39,39.9],
		          map:map,
		        });
	   	markerold.hide();
	    map.on('click',function(e){
			
	    	markerold.show();
	    	markerold.setPosition(e.lnglat);

	    	markerPosition=e.lnglat.getLng()+"_"+e.lnglat.getLat();
			console.log(e.lnglat);
			
			//alert(e.name+" "+e.lnglat+" "+e.id);
			geocoder.getAddress(e.lnglat, function(status, result) {
	            if (status === 'complete' && result.info === 'OK') {
	            
	               document.getElementById("location").innerHTML="��ǵ�ַ��"+result.regeocode.formattedAddress;
	               
	            }else{
	               
	            }
	        });
	    })
}

 //���������ȡ��γ������  
function getLnglat(e){    
   	var x = e.lnglat.getLng();
   	var y = e.lnglat.getLat(); 
   	
   	geocoder.getAddress(e.lnglat, function(status, result) {
        if (status === 'complete' && result.info === 'OK') {
        
           document.getElementById("location").innerHTML="��ǵ�ַ��"+result.regeocode.formattedAddress;
           
        }else{
           
        }
    });
}   
  	
function onComplete (data) {   //������λ���
    var str = '<p>��λ�ɹ�</p>';
    str += '<p>���ȣ�' + data.position.getLng() + '</p>';
    str += '<p>γ�ȣ�' + data.position.getLat() + '</p>';
    str += '<p>���ȣ�' + data.accuracy + ' ��</p>';
    str += '<p>�Ƿ񾭹�ƫ�ƣ�' + (data.isConverted ? '��' : '��') + '</p>';
    
};
	
function setLocation(){
	var fd = new FormData();   

        fd.append("markerPosition", markerPosition);
        fd.append("projectId", "${param.projectId}");   
        fd.append("fileUsage", "Base_map_marked_position");
        fd.append("sid", "${param.sid}");
        
      if (window.XMLHttpRequest) {//in JavaScript, if it exists(not null and undifine), it is true.
                // code for IE7+, Firefox, Chrome, Opera, Safari
                xhr = new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                // code for IE6, IE5
                xhr = new ActiveXObject("Microsoft.XMLHTTP");
            } else {
                //very rare browsers, can be ignored.
            }
    xhr.open("POST", "UploadMarkedPosition.action");   
	//xhr.onreadystatechange = callback1;
	
    xhr.send(fd);
    alert("��ַ����ɹ���");
    window.location.reload();
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
function placeSearch1() {  
	clearMap();
	keyword = document.getElementById("keyword").value;
    map.plugin(["AMap.PlaceSearch"], function() {          
        MSearch = new AMap.PlaceSearch({ //����ص��ѯ��  
            pageSize:10,  
            pageIndex:1,  
            city:"021" //����  
        });   
        AMap.event.addListener(MSearch, "complete", Search_CallBack);//���صص��ѯ���  
        MSearch.search(keyword); //�ؼ��ֲ�ѯ  
    });  
} 
//���marker&infowindow      
function addmarker(i, d) {  
	var lngX; 
	var latY;
	var iName;
	var iAddress;
	if(d.location){
		lngX = d.location.getLng();  
		latY = d.location.getLat();  
	}else{
		lngX = d._location.getLng();  
		latY = d._location.getLat(); 
	}
	if(d.name){
		iName = d.name;
	}else{
		iName = d._name;
	}
	if(d.name){
		iAddress = d.address;
	}else{
		iAddress = d._address;
	}
    var markerOption = {  
        map:map,  
        icon:"http://webapi.amap.com/images/" + (i + 1) + ".png",  
        position:new AMap.LngLat(lngX, latY)  
    };  
    var mar = new AMap.Marker(markerOption);      
    markersOnMap.push(mar);      
    marker.push(new AMap.LngLat(lngX, latY));  
  
    var infoWindow = new AMap.InfoWindow({  
        content:"<h3><font color=\"#00a6ac\">" + (i + 1) + ". " + iName + "</font></h3>" + TipContents(d.type, iAddress, d.tel),  
        size:new AMap.Size(300, 0),   
        autoMove:true,    
        offset:new AMap.Pixel(0,-30)  
    });  
    windowsArr.push(infoWindow);   
    var aa = function (e) {
        infoWindow.open(map, mar.getPosition());
		console.log(mar.getPosition());
		markerPosition=mar.getPosition().getLng()+"_"+mar.getPosition().getLat();
		
		geocoder.getAddress(mar.getPosition(), function(status, result) {
	        if (status === 'complete' && result.info === 'OK') {        
	           document.getElementById("location").innerHTML="��ǵ�ַ��"+result.regeocode.formattedAddress;           
	        }else{           
	        }
	    });
    };  
    AMap.event.addListener(mar, "click", aa);  
}  
  


function TipContents(type, address, tel) {  //��������  
    if (type == "" || type == "undefined" || type == null || type == " undefined" || typeof type == "undefined") {  
        type = "����";  
    }  
    if (address == "" || address == "undefined" || address == null || address == " undefined" || typeof address == "undefined") {  
        address = "����";  
    }  
    if (tel == "" || tel == "undefined" || tel == null || tel == " undefined" || typeof address == "tel") {  
        tel = "����";  
    }  
    var str = "&nbsp;&nbsp;��ַ��" + address  ;  
    return str;  
}  
function openMarkerTipById1(pointid, thiss) {  //����id �����������tip  
    thiss.style.background = '#CAE1FF';  
    windowsArr[pointid].open(map, marker[pointid]);  
}  
function onmouseout_MarkerStyle(pointid, thiss) { //����ƿ������ʽ�ָ�  
    thiss.style.background = "";  
} 

//�ص�����
function autoSearch() {   
	var keywords = document.getElementById("keyword").value;  
    var auto;    
    var autoOptions = {  
        pageIndex:1,  
        pageSize:10,  
        city: "" //���У�Ĭ��ȫ��  
    };  
    auto = new AMap.Autocomplete(autoOptions);  
    //��ѯ�ɹ�ʱ���ز�ѯ���  
    AMap.event.addListener(auto, "complete", autocomplete_CallBack);  
    auto.search(keywords);  
} 

function autocomplete_CallBack(data) {  
	var resultStr = "";  
    var tipArr = [];  
    tipArr = data.tips;  
    if (tipArr.length>0) {                    
        for (var i = 0; i < tipArr.length; i++) {  
            resultStr += "<div id='divid" + (i + 1) + "' onmouseover='openMarkerTipById(" + (i + 1)  
                        + ",this)' onclick='selectResult(" + i + ")' onmouseout='onmouseout_MarkerStyle(" + (i + 1)  
                        + ",this)' style=\"font-size: 13px;cursor:pointer;padding:5px 5px 5px 5px;\">" + tipArr[i].name + "<span style='color:#C1C1C1;'>"+ tipArr[i].district + "</span></div>";  
        }  
    }  
    else  {  
        resultStr = " ��__�� ��,�˼��Ҳ������!<br />Ҫ�����ԣ�<br />1.��ȷ�������ִ�ƴд��ȷ<br />2.���Բ�ͬ�Ĺؼ���<br />3.���Ը����Ĺؼ���";  
    }  
     
    document.getElementById("result1").innerHTML = resultStr;  
    document.getElementById("result1").style.display = "block";  
}

function Search_CallBack(data) {
	for(var i=0;i<markersOnMap.length;i++){
		markersOnMap[i].hide();
	}
	markersOnMap=[];
	marker=[];
	windowsArr=[];
    var resultStr = "";  
    var poiArr = data.poiList.pois;  
    var resultCount = poiArr.length;  
    for (var i = 0; i < resultCount; i++) {  
        resultStr += "<div id='divid" + (i + 1) + "' onclick='clickResult("+(i)+")'" +" onmouseover='openMarkerTipById1(" + i + ",this)' onmouseout='onmouseout_MarkerStyle(" + (i + 1) + ",this)' style=\"font-size: 12px;cursor:pointer;padding:0px 0 4px 2px; border-bottom:1px solid #C1FFC1;\"><table><tr><td><img src=\"http://webapi.amap.com/images/" + (i + 1) + ".png\"></td>" + "<td><h3><font color=\"#00a6ac\">����: " + poiArr[i].name + "</font></h3>";  
            resultStr += TipContents(poiArr[i].type, poiArr[i].address, poiArr[i].tel) + "</td></tr></table></div>";  
            addmarker(i, poiArr[i]);  
    }  
    map.setFitView();  
    document.getElementById("result").innerHTML = resultStr;  
}

function clickResult(pointid){
// 	alert(marker[pointid].getLng());
	markerold.hide();
	console.log(marker[pointid]);
	markerPosition=marker[pointid].getLng()+"_"+marker[pointid].getLat();
	
	geocoder.getAddress(marker[pointid], function(status, result) {
        if (status === 'complete' && result.info === 'OK') {        
           document.getElementById("location").innerHTML="��ǵ�ַ��"+result.regeocode.formattedAddress;           
        }else{           
        }
    });
}


function openMarkerTipById1(pointid, thiss) {  //����id �����������tip  
    thiss.style.background = '#CAE1FF';  
    windowsArr[pointid].open(map, marker[pointid]);  
}  
function onmouseout_MarkerStyle(pointid, thiss) { //����ƿ������ʽ�ָ�  
    thiss.style.background = "";  
}

//������ʾ����껬��ʱ����ʽ  
function openMarkerTipById(pointid, thiss) {  //����id�����������tip    
    thiss.style.background = '#CAE1FF';  
}  
  
//������ʾ������Ƴ�ʱ����ʽ  
function onmouseout_MarkerStyle(pointid, thiss) {  //����ƿ������ʽ�ָ�    
    thiss.style.background = "";  
}  
  
//��������ʾ����ѡ��ؼ��ֲ���ѯ  
function selectResult(index) {  
    if (navigator.userAgent.indexOf("MSIE") > 0) {  
        document.getElementById("keyword").onpropertychange = null;  
        document.getElementById("keyword").onfocus = focus_callback;  
    }  
    //��ȡ������ʾ�Ĺؼ��ֲ���  
    var text = document.getElementById("divid" + (index + 1)).innerHTML.replace(/<[^>].*?>.*<\/[^>].*?>/g,"");;  
    document.getElementById("keyword").value = text;  
    document.getElementById("result1").style.display = "none";  
    //����ѡ���������ʾ�ؼ��ֲ�ѯ  
    map.plugin(["AMap.PlaceSearch"], function() {          
        var msearch = new AMap.PlaceSearch();  //����ص��ѯ��  
        AMap.event.addListener(msearch, "complete", Search_CallBack); //��ѯ�ɹ�ʱ�Ļص�����  
        msearch.search(text);  //�ؼ��ֲ�ѯ��ѯ  
    });  
}
//��λѡ��������ʾ�ؼ���  
function focus_callback() {  
    if (navigator.userAgent.indexOf("MSIE") > 0) {  
        document.getElementById("keyword").onpropertychange = autoSearch;  
    }
}

//��յ�ͼ
function clearMap(){	
	map.clearMap();	
	document.getElementById("result").innerHTML = '&nbsp;';
}
</script> 

 
<style>	


#container {width:600px; height: 500px; }
</style>
  
  <link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>

<body >

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
		<a href="/MR_ST/local/upload.jsp?projectId=${param.projectId}&sid=<%=sid%>" style="background-color: rgb(150, 185, 125); font-weight: bold; color: rgb(255, 255, 255);" >1 �ϴ���ͼ</a>
		<a href="/MR_ST/local/upload_marked.jsp?projectId=${param.projectId}&sid=<%=sid%>">2 �ϴ���ע�ĵ�ͼ</a>
		<a href="/MR_ST/local/upload_video.jsp?projectId=${param.projectId}&sid=<%=sid%>">3 �ύ��Ƶ����</a>
		<a href="/MR_ST/local/upload_fine_modeling.jsp?projectId=${param.projectId}&sid=<%=sid%>" >4 ��ϸ��ģ(��ѡ)</a>
		
		<a href="/MR_ST/local/local.jsp">������Ŀ�б�</a>
		</div>
		</div>
	</div>	
	
	<div class="right-main-body" >
		<h2 style="">�ϴ���ͼ����ǵ���λ��</h2>   
		<hr></hr>
				
		 Project ID: ${param.projectId}<br><br>
		 
		 
		 <div class="mainleft">
		 <h3>һ���ϴ���ͼ</h3>
	    <form action="Upload" method="post" enctype="multipart/form-data">         
	                              
	        <input type="file" name="upload" onchange="PreviewImage(this)" /> <br>                
	          
	        <input class="btn" type="submit" value='�ύ' />           
	        
	        <input type="hidden" name="projectId" value="${param.projectId}">
	        <input type="hidden" name="fileUsage" value="Base_map">
	        <input type="hidden" name="sid" value="${param.sid}">
	    </form> 
	    <s:fielderror/>
	    	    
	    <br>
	   	
	    <div class="divbox" id="imgPreview"  >
<!-- 	    <img src="" id='preview'/> -->
	   	</div> 
	   	
	   	<h3>������Ǵ��µ���λ��</h3>
	   	<div class="autoclass">
        	<spam style="width: 20%;">��������</spam><input type="text" id="keyword" name="keyword" value="" style="width: 80%;"/>  
        <div id="result1" class="autobox" name="result1"></div>
	   	<div id="GDmap">
		   	<div id="container" style="float:left;width:70%;height: 600px;">	   	
		   	</div>
		   	<div id="result" style="float:left;width: 25%;overflow: scroll;height: 600px;"></div>
		   	<div  style="clear:both;"></div>
	   	</div>
	   	
	   	        
   		</div >
	   	<p id="location">��ǵ�ַ��</p>
	   	<input type="button" class="btn" value="ȷ��" onclick="setLocation()" style="margin-left:500px"/>
	   	</div>
	   	
	   	<%		
		
	   	SqlHelper sh0=new SqlHelper(); 
		 String sql0="select BASE_MAP,LNGLAT from project_filepath where PROJECT_ID=?";
		 String[] paras0={request.getParameter("projectId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String base_m="";
		 String ll="";
		 String base_m_string="��";
		 double lng=116.39;
		 double lat=39.9;
		 if(rs0.next()){
		 	if(rs0.getString(1)!=null&&!rs0.getString(1).trim().equals("")){
		 		base_m =rs0.getString(1);
		 		base_m_string="";
		 	}
		 	if(rs0.getString(2)!=null&&!rs0.getString(2).trim().equals("")){
		 		ll =rs0.getString(2);
		 		lng = Double.parseDouble(ll.substring(0, ll.indexOf("_")));
		 		lat = Double.parseDouble(ll.substring(ll.indexOf("_")+1));
		 	}
		 }
		%>
	   	<div class="mainright">
	   	<div style="margin-bottom:50px">
	   	����Ŀ���ύ�ģ�<br>
	   	��ͼ��<img id="base_m" style="margin:5px 5px" src="<%=base_m%>" onload="AutoResizeImage(0,200,this)"/><%=base_m_string %> <br>
	   	����λ�ã�<p id="location1" style="font-weight:bold">��</p> 
	   	</div>
	   	<script>
	   		var lnglat = AMap.LngLat([<%=lng%>,<%=lat%>]);

	   		AMap.service('AMap.Geocoder',function(){//�ص�����
		        //ʵ����Geocoder
		        geocoder = new AMap.Geocoder({
		            city: "010"//���У�Ĭ�ϣ���ȫ����
		        });
		       
		    })
		   	geocoder.getAddress([<%=lng%>,<%=lat%>], function(status, result) {
			   	
	            if (status == 'complete' && result.info == 'OK') {
	            
	               document.getElementById("location1").innerHTML = result.regeocode.formattedAddress;
	               
	            }else{
	               
	            }
	        });
	   	</script>
	   	
	   	<hr>
	   	<p>*˵��</p>
	   	<p>1. ��������</p>
	   	<p>���ڳ���: �ϴ�����ͼ�������CADͼֽ��</p>
	   	<p>���ⳡ��: �ϴ�����ͼƬ</p>
	   	<p>2. �ֱ��ʾ�����</p>
	   	<p style="font-weight:bold">3. ���ϴ��ĵ�ͼ����Ƶ���ӵȶ��Ḳ�Ǿɵģ�������Ŀ�б�鿴���ύ�Ĳ���</p>
	   	
	   		   	
	   	</div>
	    	
		<s:if test="message != null"> 
			<script  type="text/javascript">
			var msg = "${message}";
			alert(msg);
			</script>
		</s:if>
		
		<script type="text/javascript">
		    
		</script> 
		
	</div>
	
	</div>
</div>


</body>
</html>