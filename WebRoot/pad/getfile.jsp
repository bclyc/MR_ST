<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,org.apache.struts2.ServletActionContext"%><%@ taglib prefix="s" uri="/struts-tags"%><%
	String username="";	
	String password="";
	String use="";
	String suffix="";
	
	if(request.getParameter("username")==null||request.getParameter("password")==null||request.getParameter("use")==null||request.getParameter("suffix")==null){
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		username= request.getParameter("username");
		password= request.getParameter("password");	
		use= request.getParameter("use");
		suffix= request.getParameter("suffix");
				
		
		SqlHelper sh=new SqlHelper(); 
		String sql="select TYPE,DISABLE from user where ID=? and PASSWORD=?";
		String paras[]={username,password};
		ResultSet rs=sh.query(sql, paras);
		
		if(!rs.next()){
			response.sendRedirect("/MR_ST/redirect_login.jsp");			
		}else if(!rs.getString(1).equals("3")){
			response.sendRedirect("/MR_ST/redirect_login.jsp");
		}else if(!use.equals("base")&&!use.equals("mark")){
			response.sendRedirect("/MR_ST/redirect_login.jsp");
		}else{
			String filedownload = ServletActionContext.getServletContext().getRealPath("/Uploads/Pad/"+username+"/"+use+"."+suffix) ;
			System.out.println("filedownload path:"+filedownload);
			
	    	response.addHeader("Content-Disposition","attachment;filename=" + use+"."+suffix); 
	    	
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
				 			
	}	 
%>