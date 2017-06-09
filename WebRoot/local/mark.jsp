<%@ page contentType="text/html;charset=GBK" import="java.io.*,java.util.*,database.SqlHelper,java.sql.*"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
	
	String baseMap="";
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!userType.equals("3")||!sid.equals(request.getParameter("sid"))){		
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
		
		
		SqlHelper sh0=new SqlHelper();
		String sql="select BASE_MAP from project_filepath where PROJECT_ID=? and BASE_MAP IS NOT NULL";
		String[] paras={request.getParameter("projectId")};
		ResultSet rs=sh0.query(sql, paras);
		if(!rs.next()){
			RequestDispatcher rd;
       		rd = getServletContext().getRequestDispatcher("/reset/forget_pw.jsp");
       		request.setAttribute("message", "还没有上传底图！");
       		rd.forward(request,response);
		}
		
		if(rs.getString(1)==null||rs.getString(1).equals("")||rs.getString(1).length()==0){
		}else{
			baseMap=rs.getString(1);
		}				
	}		 
%>

<!DOCTYPE html>
<html>
<head>
<title>标记底图</title>

<script type="text/javascript">


var canvas;
var context;
var canvasWidth;
var canvasHeight;
var padding = 25;
var mapImage = new Image();
var clickX = new Array();
var clickY = new Array();
var paint = false;
var num=0;
var dirFlag=0;
var xhr ; 

window.onload = function() {
	 canvas = document.getElementById("canvas");
	context = canvas.getContext("2d");
	
	
	mapImage.src = "<%=baseMap%>";
	
	mapImage.onload = function() {
		var img = new Image();
		img.src = mapImage.src;
		
		var maxWidth = 700;
		var maxHeight = 700;	
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
		canvas.width=mapImage.width;
		canvas.height=mapImage.height;
		canvasWidth=mapImage.width;
		canvasHeight=mapImage.height;

		mapImage.width=w;
		mapImage.height=h;
		canvas.width=w;
		canvas.height=h;
		canvasWidth=w;
		canvasHeight=h;
		
		context.drawImage(mapImage, 0, 0, canvas.width, canvas.height);
		
		document.getElementById("instruction").style.marginLeft=canvasWidth/3+"px";
		document.getElementById("buttonDiv").style.marginLeft=canvasWidth/3*2+"px";
	};
	
	canvas.addEventListener("mousedown", doMouseDown, false);
	canvas.addEventListener("mousemove", doMouseMove, false); 
	
	
	 
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

function doMouseDown(event) {  
	
	if(num%2==0){
		num++;
	
		var x = event.pageX;  
	    var y = event.pageY;  
	    var canvas = event.target;  
	    var loc = getPointOnCanvas(canvas, x, y);  
	    console.log("mouse down at point( x:" + loc.x + ", y:" + loc.y + ")");  
	    	    
	    clickX.push(loc.x);
	    clickY.push(loc.y);
	    
	    redraw();
	    dirFlag=1;
	    document.getElementById("instruction").innerHTML="请指定"+(num/2+0.5)+"号相机大致朝向";
	    
	}else if(num%2==1){
		num++;
		
		var x = event.pageX;  
    	var y = event.pageY;
    	var canvas = event.target;  
    	var loc = getPointOnCanvas(canvas, x, y);    	
    	
    	//console.log(""+loc.x+" "+loc.y+" "+clickX[num-2]+" "+clickY[num-2]);
		if(loc.x==clickX[num-2]&&loc.y==clickY[num-2]){
			num--;			
			redraw();
			return;
		}
		clickX.push(loc.x);
	    clickY.push(loc.y);
        redraw();
        dirFlag=0;
        
        document.getElementById("instruction").innerHTML="请点击"+(num/2+1)+"号相机位置";
	}  
     
}

function doMouseMove(event) {  
	
	if(num%2==1){
		
		var x = event.pageX;  
    	var y = event.pageY;
    	var canvas = event.target;  
    	var loc = getPointOnCanvas(canvas, x, y);
    	
    	

		clickX.push(loc.x);
	    clickY.push(loc.y);
        redraw();
        clickX.pop();
	    clickY.pop();
	}
      
}

function getPointOnCanvas(canvas, x, y) {  
    var bbox = canvas.getBoundingClientRect();  
    return { x: x - bbox.left * (canvas.width  / bbox.width),  
            y: y - bbox.top  * (canvas.height / bbox.height)  
            };  
}

function clearCanvas() {  
    context.clearRect(0, 0, canvas.width, canvas.height);  
}

function redraw(){
	clearCanvas();
	context.drawImage(mapImage, 0, 0, canvas.width, canvas.height);
	
	for(var i=0;i<=num;i++){
		if(i%2==0){
			context.beginPath();
		    context.fillStyle = "red";  
		    context.arc(clickX[i], clickY[i], 3, 0, Math.PI*2, false);
		    context.closePath();
		    
		    context.fill();
		}else if(i%2==1){
			var x=clickX[i-1];
			var y=clickY[i-1];
			var tan=Math.atan((clickX[i]-x)/(clickY[i]-y));
			tan=Math.PI/2-tan;
	        var angle1=tan+Math.PI/6;
	        var angle2=tan-Math.PI/6;
	        var lineL=30;
	        
	        
	        context.beginPath();
	        context.strokeStyle = "red";
	        
	        if((clickY[i]-y)>=0){
	        	context.moveTo(x, y);
		        context.lineTo(x+lineL*Math.cos(angle1), y+lineL*Math.sin(angle1));
		        context.moveTo(x, y);
		        context.lineTo(x+lineL*Math.cos(angle2), y+lineL*Math.sin(angle2));
	        }else if((clickY[i]-y)<0){
	        	context.moveTo(x, y);
		        context.lineTo(x-lineL*Math.cos(angle1), y-lineL*Math.sin(angle1));
		        context.moveTo(x, y);
		        context.lineTo(x-lineL*Math.cos(angle2), y-lineL*Math.sin(angle2));
	        }	       
	        context.closePath();
	        context.stroke();
	        
	        
	        
	        if(i!=num){
		        context.fillStyle = "yellow"; 
		        context.font = "24px Arial";
	            var txt = (i+1)/2+"";            
	            lineL=20;
	            if((clickY[i]-y)>=0){
	            	
	            	context.fillText(txt, x-lineL*Math.cos(tan)-6, y-lineL*Math.sin(tan)+6);
	            	
		        	
		        }else if((clickY[i]-y)<0){
		        	
		        	context.fillText(txt, x+lineL*Math.cos(tan)-6, y+lineL*Math.sin(tan)+6);
		        }
	        }
	        
		}
	}
}

function undo(){
	if(num<=0) return;
	num--;
	clickX.pop();
	clickY.pop();
	redraw();
	
	if(num%2==0)	document.getElementById("instruction").innerHTML="请点击"+(num/2+1)+"号相机位置";
	else if(num%2==1)	document.getElementById("instruction").innerHTML="请指定"+(num/2+0.5)+"号相机大致朝向";
}

function fileUpload() {
	if(num%2==1){
		alert("请完成"+(num/2+0.5)+"号相机的标记");
		return;
	}
   
    var data = canvas.toDataURL("image/png", 1.0);   
    console.log(data);
    
    data = data.split(',')[1];   
  
    var fd = new FormData();   

        fd.append("filedata", data);
        fd.append("projectId", "${param.projectId}");   
        fd.append("fileUsage", "Base_map_marked_canvas");
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
    xhr.open("POST", "UploadMarkedCanvas.action");   
	xhr.onreadystatechange = callback1;
	
    xhr.send(fd);
    //xhr.response.sendRedirect("/MR_ST/local/upload_marked.jsp?projectId="+"${param.projectId}"+"&sid="+"<%=sid%>");
    
    //window.location.href="/MR_ST/local/upload_marked.jsp?projectId="+"${param.projectId}"+"&sid="+"<%=sid%>";  
 }
 
 function callback1(){
 	
 	 if (4 == xhr.readyState && 200 == xhr.status) {
 	 	alert("上传成功");
        window.location.href="/MR_ST/local/upload_marked.jsp?projectId="+"${param.projectId}"+"&sid="+"<%=sid%>";
    }
 }
</script>

<link rel="stylesheet" type="text/css" href="/MR_ST/css/style.css">
</head>
  
  
  <body>
 
    <div id="canvasDiv" >
    <canvas id="canvas" ></canvas>
    </div>
  	<p id="instruction" style="color:#ff0000">请点击1号相机位置</p>
  	
    <div id="buttonDiv">
    <input type="button" class="btn" value="撤销" onclick="undo()">
    
	<input type="button" class="btn" value="完成标注并提交" onclick="fileUpload()">
	
    </div>

  </body>
</html>