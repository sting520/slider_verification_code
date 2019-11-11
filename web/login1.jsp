<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>江苏省学生健康监测系统</title>

    <link rel="stylesheet" href="login/css/login.css">
    <script src="schoolClass/jquery-3.4.1.min.js"></script>
    <script src="login/js/drag.js"></script>
    <style>
        body {
            width: 100%;font-family:Helvetica Neue,Helvetica,PingFang SC,Tahoma,Arial,sans-serif;
        }

        .form {
            width: 400px;
            margin-left: 32%;
            margin-top: 8%;
            border:1px white solid;
            border-radius: 10px;
            padding-bottom: 15px;
            background-color: white;
        }

        .form-item {
            text-align: left;
            padding: 10px;
        }

        .form-item label {
            float: left;
            width: 60px !important;
            text-align: right;
            height: 40px;
            padding-top: 5px;
        }

        .form-item input {
            margin-left: 20px;
            width: 270px;
            height: 40px;
            line-height: 40px;
            font-size: 14px;
        }

        .btm {
            width: 260px !important;
            margin-left: 80px !important;
            background-color: #1E9FFF;
            border: none;
            cursor: pointer;
            color: white;
            font-size: 20px;

        }
    </style>
</head>
<body style=" background-color:#F0F0F0 ;">

<div class=" " style=" " >
<form class="form"   action="LoginYZM.action" method="post"  name="form" >
    <input id="yzm" name="yzm" type="hidden" value="">
    <input id="passcheck" name="passcheck" type="hidden">
    <input id="sourceImgName" name="sourceImgName" type="hidden">
    <div class="form-item">
        <p style="text-align: center;font-size: 20px;color: #1E9FFF">用户登录</p>
    </div>
    <div class="form-item">
        <label>用户名</label>
        <input id="username" name="username" placeholder="请输入用户名" onkeypress="if(event.keyCode==13) { document.forms[0].userpass.focus();}"  autocomplete="off"  />
    </div>
    <div class="form-item">
        <label>密&nbsp;&nbsp;&nbsp;&nbsp;码</label>
        <input id="userpass" name="userpass" placeholder="请输入密码"  type= "password"   autocomplete="off"  />
    </div>
    <div class="form-item">
        <%--<input name="">--%>
        <div class="yzm">
            <!--展示原图-->
            <div id="yzm_image_source" class="yzm_image_source"></div>
            <!--展示凹图-->
            <div id="yzm_image_cut_big" class="yzm_image_cut_big"></div>
            <!--加载中..-->
            <div id="yzm_image_cut_loading" class="yzm_image_cut_loading"></div>
            <!--拼图-->
            <div id="yzm_image_cut_small" class="yzm_image_cut_small"></div>
            <div style="top: 37px; left: 0px;display: none; "
                 id="xy_img"></div>
            <img id="refreshyzm" src="login/img/refresh.png"
                 style="position:relative;top: -60px;/* top:120px; */left: 280px;width: 20px;height: 20px;cursor: pointer;"
                 onclick="initYzm()">
        </div>
        <div id="drag" style="width: 260px;"></div>
    </div>

    <div class="form-item">
        <input type="button" style="height: 50px;line-height: 50px;" class="btm" value="登  录" onclick="login()">
    </div>




</form>
</div>

<script>



    document.forms[0].username.focus();
    $(function () {
        //初始化图形验证码
        initYzm();
        //注册验证码拖动事件
        $('#drag').drag(null, null, initYzm);
    })

    function initYzm() {
        //加载中
        $("#xy_img").css("display", "none");
        $("#yzm_image_source").css("display", "none");
        $(".yzm_image_cut_big").css("display", "none");
        $(".yzm_image_cut_loading").show();
        // alert( $(".yzm_image_source").css("background-image"))
        $.ajax({
            type: "POST",
            async: true,
            url: "yzmServlet",
            dataType: 'json',
            data:{imgname: $("#sourceImgName").val()},
            success: function (result) {
                if (result) {
                   // console.log(result.location_y)
                    $("#sourceImgName").val(result.sourceImgName);
                    //设置大图，小图，及其位置
                    // $(".yzm_image_source").css("background", "url('data:image/png;base64," + Trim(result.bigImgName) + "') no-repeat ");
                    $(".yzm_image_source").css("background-image", "url(sourceYzmImg/" + result.sourceImgName + ")");
                    $(".yzm_image_cut_big").css("background", "url('data:image/png;base64," + Trim(result.bigImgName) + "') no-repeat ");
                    $("#xy_img").css("background", "url('data:image/png;base64," + Trim(result.smallImgName) + "') no-repeat ");
                    $("#xy_img").css("top", Number(result.location_y) + "px");
                    $(".yzm_image_cut_loading").css("display", "none");
                    $(".yzm_image_source").show();
                    $(".yzm_image_cut_big").css("display", "none");
                } else {
                    alert('获取图形验证码失败！')
                    // $.ligerDialog.error('获取图形验证码失败！');
                }
            },
            error: function (errormsg) {
                alert('获取图形验证码失败！')
                // $.ligerDialog.warn("获取图形验证码失败！");
            }
        });
    }
    function Trim(val){
        val=val.replace(/\ +/g,"");//去掉空格
        val=val.replace(/[ ]/g,"");    //去掉空格
        val=val.replace(/[\r\n]/g,"");//去掉回车换行
        return val;
    }


    function login() {
        if ((document.forms[0].username.value == '') ) {
            alert("警告：必须输入用户名！");
            document.forms[0].username.focus();

        }else if (document.forms[0].userpass.value == '')
        {
            alert("警告：必须输入密码！");
            document.forms[0].userpass.focus();
        }else if (document.forms[0].yzm.value == '')
        {
            alert("警告：请滑动图片选择验证！");
            // document.forms[0].rand.focus();
        }else {
            document.forms[0].submit();
            return true;
        }
    }
</script>
</body>
</html>
