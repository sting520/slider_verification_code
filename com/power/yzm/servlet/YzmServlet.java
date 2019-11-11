package com.power.yzm.servlet;


import com.power.yzm.util.DragYzm;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;


public class YzmServlet extends HttpServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DragYzm.init(config.getServletContext());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imgname = request.getParameter("imgname");
        String point = request.getParameter("point");
        PrintWriter out = null;
        try {
            Map<String, String> result = new HashMap<String, String>();
            out = response.getWriter();
            response.setContentType("application/json-rpc;charset=UTF-8");
            if (StringUtils.isEmpty(point)) { //生成图形验证码
              if(StringUtils.isEmpty(imgname)) {
                    imgname = "5.png";
                }
                DragYzm resourImg = new DragYzm();
                result = resourImg.create(request, imgname);
            } else { //验证验证码
                Integer location_x = (Integer) request.getSession().getAttribute("location_x");
                if ((Integer.valueOf(point) < location_x + 4) && (Integer.valueOf(point) > location_x - 4)) {
                    //说明验证通过，
                    result.put("data", "success");
                } else {
                    result.put("data", "error");
                }
            }
            JSONObject jsonObject = JSONObject.fromObject(result);
            out.println(jsonObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


    }
}
