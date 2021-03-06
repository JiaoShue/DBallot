<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":"
        + request.getServerPort() + request.getContextPath() + "/"; %>

<!Doctype html>
<html>
<head>
    <base href="<%=basePath%>">
    <title>候选人申请</title>
    <meta charset="utf-8">

    <script src="static/js/jquery-1.11.1.min.js"></script>
    <link href="static/css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/icon.css">
    <script type="text/javascript" src="static/jquery-easyui-1.5.4.2/jquery.easyui.min.js"></script>
</head>
<body style="background: #607d8b4f;">
<div style="position: fixed;top:5%;left:32%">
    <div class="easyui-panel" title="候选人申请" style="width:400px;padding:30px 70px 20px 70px;">
        <div style="margin-bottom:10px">
            <input class="easyui-textbox" style="width:55%;height:40px;padding:12px"  type="password" id="password" data-options="prompt:'输入口令获取用户ID'" />
            <a onclick="getUserID()" class="easyui-linkbutton" style="padding:5px auto;float: right; height:40px;width:43%;">
                <span style="font-size:14px;">获取区块链账户</span>
            </a>
        </div>
        <div style="margin-bottom:10px">
            <input class="easyui-textbox" id="account" style="width:100%;height:40px;padding:12px" data-options="prompt:'请输入区块链账户'"/>
        </div>
        <div style="margin-bottom:10px">
            <input class="easyui-textbox" style="width:100%;height:40px;padding:12px" id="empNo" data-options="prompt:'请输入工号'"/>
        </div>
        <div style="margin-bottom:10px">
            <input class="easyui-textbox" style="width:100%;height:40px;padding:12px" id="name" data-options="prompt:'请输入姓名'"/>
        </div>

        <div style="margin-bottom:10px">
            <input class="easyui-textbox" style="width:100%;height:40px;padding:12px" id="ballotID" data-options="prompt:'请输入场次号'"/>
        </div>
        <div style="margin-bottom:10px">
            <input class="easyui-textbox" style="width:100%;height:40px;padding:12px" id="organization" data-options="prompt:'请输入组织名称'"/>
        </div>
        <div style="margin-bottom:10px">
            <textarea rows="3" cols="20" class="easyui-textbox" style="width:100%;height:100px;border-radius: 5px 5px 5px 5px" id="describe" data-options="prompt:'请填写自我介绍',multiline:true">
            请自我介绍一下
            </textarea>
        </div>
        <div>
            <a onclick="apply()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" style="padding:5px 20px;float:left;width:100%;">
                <span style="font-size:14px;">提交</span>
            </a>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
    $(function(){
        $('#account').val('');
    });
    function getUserID() {
        var password=$('#password').val();
        var reqUrl='http://localhost:7001/newActiveAccount';
        if(!password){
            $.messager.alert('申请提示','密码不能为空');
            return;
        }
        $.ajax({
            url : reqUrl,
            cache : false,
            type : 'post',
            data:JSON.stringify({"password":password}),
            async : false,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if (result.status=="success") {
                    var account=(result.data);
                    $.messager.alert('申请提示',"您的区块链账户是：\n"+account+"，"+"\n请使用Ctrl+C组合键进行复制！");
                    $('#user_id').val(account);
                }else {
                    $.messager.alert('申请提示','获取区块链账户失败，'+'\n错误码'+result.status+'！');
                }
            },
            error: function(err){
                $.messager.alert('申请提示',"请求失败"+err.status);
            }
        });
    }
    function apply() {
        var account=$('#account').val();
        var empNo=$('#empNo').val();
        var name=$('#name').val();
        var password=$('#password').val();
        var ballotID=$('#ballotID').val();
        var organization=$('#organization').val();
        var describe=$('#describe').val();
        var params=new Array(account,empNo,name,password,ballotID,organization,describe);
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache : false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"candidateApply",
                "callType":"send",
                "caller":account,
                "callerPwd":password,
                "params":params
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if (result.status=="success") {
                    $.messager.alert('提示','申请成功！\n'+'交易ID:'+result.data.transactionHash);
                }else {
                    $.messager.alert('提示','申请失败，'+result.status);
                }
            }
        });
    }
</script>
</html>
