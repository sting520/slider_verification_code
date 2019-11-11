# 滑块验证码

#### 介绍
简单滑块验证码

#### 软件架构
servlet


#### 安装教程

1、引入silder_code.jar。
2、配置web.xml文件
 <servlet>
        <servlet-name>yzmServlet</servlet-name>
        <servlet-class>com.power.yzm.servlet.YzmServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>yzmServlet</servlet-name>
        <url-pattern>/yzmServlet</url-pattern>
    </servlet-mapping>

 
	
3、将web文件拷贝进入项目。
4、验证码验证
  String yzm = request.getParameter("yzm");
 Integer location_x = (Integer) request.getSession().getAttribute("location_x");
        if ((Integer.valueOf(yzm) < location_x + 4) && (Integer.valueOf(yzm) > location_x - 4)) {
            request.setAttribute("msg", "登录成功");
            request.getRequestDispatcher("/result.jsp").forward(request, response);
        } else {
            request.setAttribute("msg", "图形验证失败");
            request.getRequestDispatcher("/result.jsp").forward(request, response);
        }
5、sourceYzmImg 这个文件夹下面就是验证码图片 
也可以自己拷贝进去 想要图片    	
260 * 116 
图片大小 	