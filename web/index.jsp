<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":"
        + request.getServerPort() + request.getContextPath() + "/"; %>

<!Doctype html>
<html>
<head>
  <base href="<%=basePath%>">
  <title>去中心化投票系统</title>
  <meta charset="utf-8">
  <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/bootstrap/easyui.css">
  <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/icon.css">
  <script type="text/javascript" src="static/js/jquery-1.11.1.min.js"></script>
  <script type="text/javascript" src="static/jquery-easyui-1.5.4.2/jquery.easyui.min.js"></script>
  <link rel="stylesheet" href="static/ztree/css/metroStyle/metroStyle.css" type="text/css">
  <script type="text/javascript" src="static/ztree/js/jquery.ztree.all-3.5.min.js"></script>
</head>
<body style="width: 1280px;margin: 0 auto">
<div class="easyui-layout" style="width:100%;height:800px;">
  <div data-options="region:'north'" style="height:93px;">
    <div style="width:303px;height:90px;float:left;overflow: hidden;
            background: url('static/jquery-easyui-1.5.4.2/themes/icons/logo.png')
            center center no-repeat;">

    </div>
  </div>
  <div data-options="region:'west',split:true" title="<span class='glyphicon glyphicon-list'></span> 功能菜单" style="width:220px;height: auto;overflow: hidden">
    <ul id="tree" class="ztree" style="width: 100%; height: 100%; overflow: auto;">

    </ul>
  </div>
  <div data-options="region:'center',title:'内容',iconCls:'icon-ok'">
    <div id="tt" class="easyui-tabs" data-options="fit:true,border:false,plain:true">
      <div title="投票合约信息" style="width: 100%;">
        <div class="easyui-panel" title="">
            <table cellpadding="5" border="1" style="border-collapse:collapse;margin: 20px auto">
              <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">合约名：</td>
                <td id="name" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
              </tr>
              <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">所在区块：</td>
                <td id="position" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
              </tr>
              <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">合约地址：</td>
                <td id="address" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
              </tr>
              <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">部署合约交易哈希：</td>
                <td id="TxHash" style="table-layout: fixed;width: 700px;word-break: break-all;"></td>
              </tr>
              <tr>
                <td style="text-align: right;width: 120px;vertical-align:top;">合约abi：</td>
                <td id="abi" style="table-layout: fixed;width: 700px; word-break: break-all;"></td>
              </tr>
            </table>
        </div>
      </div>
    </div>
  </div>
  <div id="mm" class="easyui-menu" style="width: 150px;">
    <div name="1">刷新</div>
    <div name="2">关闭当前</div>
    <div name="3">全部关闭</div>
    <div name="4">关闭其他</div>
  </div>
</div>
</body>
<script type="text/javascript">
  $(function () {
    getMenu();
    loadlist();
  });
  function loadlist() {
    $.ajax({
      url:'http://localhost:7001/getAllContractInfo',
      data:JSON.stringify({}),
      cache:false,
      type:'get',
      async : true,
      contentType:"application/json",
      dataType:"json",
      success:function (result) {
        if (result.status=="success") {
          $("#name").html(result.data[0].name);
          $("#position").html(result.data[0].position);
          $("#address").html(result.data[0].address);
          $("#TxHash").html(result.data[0].TxHash);
          $("#abi").html(result.data[0].abi);
        }else {
          $.messager.alert('提示','显示合约信息失败，'+'\n错误码'+result.status+'！');
        }

      }
    })
  }
  function addTab(title, href) {
    var tt = $('#tt');
    if (tt.tabs('exists', title)) {//如果tab已经存在,则选中并刷新该tab
      tt.tabs('select', title);
    } else {
      var content = '未实现';
      if (href) {
        content = '<iframe scrolling="auto" frameborder="0" src="' + href + '" ></iframe>';
      }
      tt.tabs('add', {
        title : title,
        closable : true,
        content : content
      });
      $("iframe").css({
        width : '100%',
        height : '100%'
      });
    }
  }

  function closeTab(menu, type) {
    var allTabs = $("#tt").tabs('tabs');
    var allTabtitle = [];
    $.each(allTabs, function(i, n) {
      var opt = $(n).panel('options');
      if (opt.closable)
        allTabtitle.push(opt.title);
    });
    var curTabTitle = $(menu).data("tabTitle");
    switch (type) {
      case "1": //刷新
        $("#tt").tabs('select', curTabTitle);
        var _refresh_ifram = $("#tt").tabs("getTab", curTabTitle).panel().find('iframe');
        _refresh_ifram.attr('src', _refresh_ifram.attr('src')).css({
          width : '100%',
          height : '100%'
        });

        break;
      case "2"://关闭当前
        $("#tt").tabs("close", curTabTitle);
        return false;
        break;
      case "3"://全部关闭
        for (var i = 0; i < allTabtitle.length; i++) {
          $('#tt').tabs('close', allTabtitle[i]);
        }
        break;
      case "4"://除此之外全部关闭
        for (var i = 0; i < allTabtitle.length; i++) {
          if (curTabTitle != allTabtitle[i])
            $('#tt').tabs('close', allTabtitle[i]);
        }
        $('#tt').tabs('select', curTabTitle);
        break;
    }

  }

  var setting = {
    view : {
      dblClickExpand : true,
      showLine : true,
      selectedMulti : false
    },
    callback : {
      onClick : zTreeOnClick
    }
  };
  function zTreeOnClick(event, treeId, treeNode) {
    if(treeNode.parentId==null || treeNode.parentId==''){
      if(treeNode.children!=null && treeNode.children!=''){
        return;
      }
    }
    if (treeNode.action && treeNode.action != "") {
      addTab(treeNode.name, treeNode.action);
    }
  };

  $(function() {
    $('#tt').tabs({
      onContextMenu : function(e, title, index) {
        e.preventDefault();
        if (index > 0) {
          $('#mm').menu('show', {
            left : e.pageX,
            top : e.pageY
          }).data("tabTitle", title);
        }
      }
    });
    //右键菜单click
    $("#mm").menu({
      onClick : function(item) {
        closeTab(this, item.name);
      }
    });
    getMenu();
    $("#menu").on("click", "li", function() {
      $("li").removeClass("selected");
      $(this).addClass("selected");
    });
  });
  function getMenu() {
    var zNodes = [{
      "id":"1","name":"投票与申请","action":"","parentId":null,"checked":true,"open":true,"menutype":"0",
      "children":[
        {"id":"11","name":"创建投票","action":"initVote.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":""},
        {"id":"12","name":"当前投票","action":"currVote.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":""},
        {"id":"13","name":"候选人登记","action":"candidateApply.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":null},
        {"id":"14","name":"候选人列表","action":"allCandidate.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":null},
        {"id":"15","name":"申请投票","action":"voteApply.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":""},
        {"id":"16","name":"所有投票","action":"allVote.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":""},
        {"id":"17","name":"投票结果","action":"showRes.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":""},
        {"id":"18","name":"获取手续费","action":"increaseFee.jsp","parentId":"1","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":null}],
      "parent":true,"iconCls":""
    },
      {"id":"2","name":"审核与验票","action":"","parentId":null,"checked":true,"open":true,"menutype":"0","children":
                [
                  {"id":"21","name":"投票人审核","action":"verifyVoter.jsp","parentId":"2","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":null},
                  {"id":"22","name":"候选人审核","action":"verifyCandidate.jsp","parentId":"2","checked":true,"open":true,"menutype":"0","children":[],"parent":true,"iconCls":null},
                ],
        "parent":true,"iconCls":""
      }
    ];
    var t = $("#tree");
    t = $.fn.zTree.init(t, setting, zNodes);
  }
</script>
</html>