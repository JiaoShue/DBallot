<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":"
        + request.getServerPort() + request.getContextPath() + "/"; %>

<!Doctype html>
<html>
<head>
    <base href="<%=basePath%>">
    <title>去中心化投票系统</title>
    <meta charset="utf-8">

    <script src="static/js/jquery-1.11.1.min.js"></script>
    <link href="static/css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/icon.css">
    <script type="text/javascript" src="static/jquery-easyui-1.5.4.2/jquery.easyui.min.js"></script>
</head>
<body>
<div class="easyui-panel" title="当前投票信息">
    <div style="margin:0 auto;">
        <table id="tb" border="0" style="margin: 0 auto;width: 100%;text-align: center">
            <tr>
                <td>投票发起人：<input  style="width:150px; background: none" id="starterID" type="text" placeholder="开始投票与计票填写"/>
                    交易密码：<input  style="width:150px; background: none" id="password" type="password"placeholder="开始投票与计票填写"/>
                    时间间隔：<input  style="width:150px; background: none" id="interval" type="text"placeholder="开始投票填写(单位:分钟)"/>
                    投票场次：<input  style="width:150px; background: none" id="BID" type="text"placeholder="开始投票与计票填写"/>
                    <input type="button" class="easyui-linkbutton"  onclick="startVote()"value="开始投票"/>
                    <input type="button" class="easyui-linkbutton"  onclick="calcRes()"value="计票"/></td>
            </tr>
        </table>
        <table cellpadding="5" border="1" style="border-collapse:collapse; margin: 20px auto">
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">投票场次：</td>
                <td id="ballotID" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">发起方区块链地址：</td>
                <td id="starter" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">发起方工号：</td>
                <td id="empNo" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">发起方姓名：</td>
                <td id="name" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">发起方所属组织：</td>
                <td id="organization" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">当选者数量：</td>
                <td id="victorCount" style="table-layout: fixed;width: 700px; word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">发起时间：</td>
                <td id="createTime" style="table-layout: fixed;width: 700px; word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">开始时间：</td>
                <td id="startTime" style="table-layout: fixed;width: 700px; word-break: break-all;"></td>
            </tr>
            <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">结束时间：</td>
                <td id="endTime" style="table-layout: fixed;width: 700px; word-break: break-all;"></td>
            </tr>
        </table>
    </div>
</div>
</body>
<script type="text/javascript">
    $(function () {
        loadlist();
    });
    function loadlist() {
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache : false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"getCurrBallotInfo",
                "callType":"call",
                "caller":"0xcd34d1fcc8f2284fa2af8ea18d6c7d0b60ee17f5",
                "callerPwd":"123456",
                "params":[]
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if (result.status=="success") {
                    $("#ballotID").html(result.data.ballotID);
                    $("#starter").html(result.data.starter);
                    $("#empNo").html(result.data.empNo);
                    $("#name").html(result.data.name);
                    $("#organization").html(result.data.organization);
                    $("#victorCount").html(result.data.victorCount);
                    $("#createTime").html(result.data.createTime);
                    $("#startTime").html(result.data.startTime);
                    $("#endTime").html(result.data.endTime);
                }else {
                    $.messager.alert('提示','加载数据失败，'+result.status);
                }
            }
        });
    }
    function startVote() {
        var starterID=$('#starterID').val();
        var password=$('#password').val();
        var interval=$('#interval').val();
        var BID=$('#BID').val();
        var params=new Array(BID,interval);
        if(!starterID){
            $.messager.alert("提示","请输入发起人账号");
            return;
        }
        if(!password){
            $.messager.alert("提示","请输入交易密码");
            return;
        }
        if(!interval){
            $.messager.alert("提示","请输入投票持续时间");
            return;
        }
        if(!BID){
            $.messager.alert("提示","请输入投票场次号");
            return;
        }
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache: false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"startVote",
                "callType":"send",
                "caller":starterID,
                "callerPwd":password,
                "params":params
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if(result.status=="success"){
                    $.messager.alert('操作提示',result.data.events.logstartVote.returnValues["0"]);
                }else{
                    $.messager.alert('操作提示','操作失败，'+result.status);
                }
            }
        })
    }
    function calcRes() {
        var starterID=$('#starterID').val();
        var password=$('#password').val();
        var BID=$('#BID').val();
        var params=new Array(BID);
        if(!starterID){
            $.messager.alert("提示","请输入发起人账号");
            return;
        }
        if(!password){
            $.messager.alert("提示","请输入交易密码");
            return;
        }
        if(!BID){
            $.messager.alert("提示","请输入投票场次号");
            return;
        }
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache: false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"calcRes",
                "callType":"send",
                "caller":starterID,
                "callerPwd":password,
                "params":params
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if(result.status=="success"){
                    $.messager.alert('计票操作',result.data.events.logcalcRes.returnValues["0"]);
                }else{
                    $.messager.alert('计票操作','计票失败，'+result.status);
                }
            }
        })
    }
</script>
</html>
