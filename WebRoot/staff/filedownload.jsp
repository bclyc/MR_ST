<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,org.apache.struts2.ServletActionContext"%><%@ taglib prefix="s" uri="/struts-tags"%><%
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
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
		
		
		SqlHelper sh0=new SqlHelper(); 
		 String sql0="select BASE_MAP, BASE_MAP_MARKED from project_filepath where PROJECT_ID=?";
		 String[] paras0={request.getParameter("projectId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String base_m="";
		 String base_m_m="";
		 if(rs0.next()){
		 	base_m =rs0.getString(1);
		 	base_m_m =rs0.getString(2);
		 }else{
		 	System.out.println("no rs0");
		 }
		 
		 String filedownload = ""; 
    	 String filedisplay = ""; 
		 if(request.getParameter("use").equals("base_m")){
		 	filedownload = base_m; 
    		filedisplay = "Base_map"+ base_m.substring(base_m.lastIndexOf("."), base_m.length()); 
		 }else if(request.getParameter("use").equals("base_m_m")){
		 	filedownload = base_m_m; 
    		filedisplay = "Base_map_marked"+ base_m_m.substring(base_m_m.lastIndexOf("."), base_m_m.length());;
		 }
		
		filedownload = filedownload.substring(filedownload.indexOf("MR_ST")+5);
		filedownload = ServletActionContext.getServletContext().getRealPath(filedownload) ;
		System.out.println("filedownload path:"+filedownload);
		
    	response.addHeader("Content-Disposition","attachment;filename=" + filedisplay); 
    	
    	java.io.OutputStream outp = null; 
    	java.io.FileInputStream in = null; 
    	try 
    	{
    		outp = response.getOutputStream(); 
    		in = new FileInputStream(filedownload); 
    		
    		byte[] b = new byte[1024]; 
    		int i = 0; 
    		
    		while((i = in.read(b)) > 0) 
    		{ 
    		outp.write(b, 0, i); 
    		} 
    		//   
    		outp.flush(); 
    		 
    		out.clear(); 
    		out = pageContext.pushBody(); 
    		response.reset();
    	} 
    	  catch(Exception e) 
    	  { 
    	  //System.out.println("Error!"); 
    	  //e.printStackTrace(); 
    	  } 
    	  finally 
    	  { 
	    	  if(in != null) 
	    	  { 
	    	  in.close(); 
	    	  in = null; 
	    	  } 
    	
    	  }				
	}	 
%>