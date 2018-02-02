<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<html>
<head>
    <title>员工列表</title>
    <%--web路径：不以/开始的相对路径，找路径，以当前资源的路径为基准，经常容易出问题--%>
    <%--以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306）；需要加上项目名称
    http://localhost:3306/crud --%>
    <!-- Bootstrap -->
    <link href="${APP_PATH}/static/css/bootstrap.css" rel="stylesheet">
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="${APP_PATH}/static/js/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="${APP_PATH}/static/js/bootstrap.js"></script>
</head>
<body>

<%--员工添加模态框--%>
<div class="modal fade" role="dialog" id="empAddModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工新增</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input"
                                   placeholder="email">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" checked="checked" name="gender" id="gender1" value="M"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2" value="F">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="deptName_add_select" class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--部门ID--%>
                            <select class="form-control" id="deptName_add_select" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<%--员工修改模态框--%>
<div class="modal fade" role="dialog" id="empUpdateModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empId</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empId_update_input"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_input"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_update_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input"
                                   placeholder="email">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" checked="checked" name="gender" id="gender1_update_input" value="M">
                                男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F">女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="deptName_update_select" class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--部门ID--%>
                            <select class="form-control" id="deptName_update_select" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<%--搭建显示页面--%>
<div class="container">
    <%--标题行--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_all_btn">删除</button>
        </div>
    </div>
    <%--显示表格信息--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table tab-content" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="chkAll"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页的文字信息--%>
        <div class="col-md-6" id="page_info_area">
        </div>
        <!--分页信息-->
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>


</div>
<script type="text/javascript">

    var totalRecord, current;

    //页面加载完成后，直接发送ajax请求
    $(function () {
        //首页
        to_page(1);
    });

    //解析表格数据
    function build_emps_table(result) {

        //清空表格
        $("#emps_table tbody").empty();

        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            var checkBoxTd = $("<td></td>").append($("<input type='checkbox' class='check_item'></intput>"));
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == "M" ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").append($("<span></span>")
                .addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append($("<span></span>")
                .addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            //append方法执行完成后还是返回原来的元素，链式操作
            $("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(genderTd).append(emailTd).append(deptNameTd).append(btnTd)
                .appendTo($("#emps_table tbody"));
        });
    }

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "get",
            success: function (result) {
                //console.log(result);
                //1、解析并显示员工数据
                build_emps_table(result);
                //2、解析并显示分页信息
                build_page_info(result);
                //3、显示分页数据
                build_page_nav(result);
            }
        });
    }

    //分页信息
    function build_page_info(result) {

        $("#page_info_area").empty();

        $("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + "页，总"
            + result.extend.pageInfo.pages + "页，总" + result.extend.pageInfo.total + "条记录");

        totalRecord = result.extend.pageInfo.total;
        current = result.extend.pageInfo.pageNum;
    }

    //解析显示分页条，点击分页能够分页
    function build_page_nav(result) {

        $("#page_nav_area").empty();

        var ul = $("<ul></ul>").addClass("pagination");

        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href", "#"));

        if (result.extend.pageInfo.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            //为元素添加点击翻页事件
            firstPageLi.click(function () {
                to_page(1);
            });

            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }


        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href", "#"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));

        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {

            //为元素添加点击翻页事件
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });

            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
        }


        //首页与前一页
        ul.append(firstPageLi).append(prePageLi);

        //页码号
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum == item) {
                numLi.addClass("active");
            }

            numLi.click(function () {
                to_page(item);
            });

            ul.append(numLi);
        });

        //下一页与末页
        ul.append(nextPageLi).append(lastPageLi);

        var navEle = $("<nav></nav>").append(ul);

        $("#page_nav_area").append(navEle);
    }

    //点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {

        //清除表单数据与表单样式
        $("#empAddModal form").get(0).reset();
        $("#empAddModal").removeClass("has-error has-success");
        $("#empAddModal").find(".help-block").text("");

        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts("#deptName_add_select");

        $("#empAddModal").modal({
            backdrop: "static"
        });
    });

    //查出所有部门的信息并显示在下拉列表中
    function getDepts(ele) {
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success: function (result) {
                //清空下拉列表
                $(ele).empty();
                //显示部门信息在下拉列表中
                $.each(result.extend.depts, function (index, item) {
                    var option = $("<option></option>").append(item.deptName).attr("value", item.deptId);
                    $(ele).append(option);
                });
            }
        });
    }

    //显示校验结果
    function show_validate_msg(ele, status, msg) {
        //清空当前元素的校验状态
        $(ele).parent().removeClass("has-error has-success");
        $(ele).next("span").text("");
        if (status == "success") {
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if (status == "error") {
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    //校验表单数据
    function validate_add_form() {
        //1、拿到需要检验的数据
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)) {
            //alert("用户名可以是2-5位中文或者6-16位英文和数字组合");
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字组合");
            //$("#empName_add_input").parent().addClass("has-error");
            //$("#empName_add_input").next("span").text("用户名可以是2-5位中文或者6-16位英文和数字组合");
            return false;
        } else {
            show_validate_msg("#empName_add_input", "success", "");
            //$("#empName_add_input").parent().addClass("has-success");
            //$("#empName_add_input").next("span").text("");
        }
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            //alert("邮箱格式不正确");
            //$("#email_add_input").parent().addClass("has-error");
            //$("#email_add_input").next("span").text("邮箱格式不正确");
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            return false;
        } else {
            show_validate_msg("#email_add_input", "success", "");
            //$("#email_add_input").parent().addClass("has-success");
            //$("#email_add_input").next("span").text("");
        }

        return true;
    }

    //绑定单击保存事件
    $("#emp_save_btn").click(function () {

        //校验数据
        if (!validate_add_form()) {
            return false;
        }

        //判断之前的ajax检验是否成功
        if ($(this).attr("ajax-va") == "error") {
            return false;
        }

        //1、模态框中填写的表单数据提交给服务器进行保存
        //2、发送ajax请求保存数据
        $.ajax({
            url: "${APP_PATH}/emp",
            type: "POST",
            data: $("#empAddModal form").serialize(),
            success: function (result) {
                if (result.code == 100) {
                    //员工保存成功
                    //1、关闭模态框
                    $("#empAddModal").modal("hide");
                    //2、定位到最后一页
                    //发送ajax请求显示最后一页数据
                    to_page(totalRecord);
                } else {
                    //显示失败信息
                    //console.log(result);
                    if (result.extend.errorFields.email != undefined) {
                        show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                    }
                    if (result.extend.errorFields.empName != undefined) {
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                }
            }
        });
    });

    //检验用户名是否可用
    $("#empName_add_input").change(function () {
        var empName = $(this).val();
        //发送ajax请求校验用户名是否可用
        $.ajax({
            url: "${APP_PATH}/checkuser",
            data: "empName=" + empName,
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    $("#emp_save_btn").attr("ajax-va", "success");
                } else {
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va", "error");
                }
            }
        });
    });

    $(document).on("click", ".edit_btn", function () {
        //1、查出部门信息并显示部门列表
        getDepts("#deptName_update_select");
        //2、查出员工信息并显示
        var empId = $(this).parent().parent().find("td:eq(1)").text();
        getEmp(empId);

        $("#empUpdateModal").modal({
            backdrop: "static"
        });
    });

    //单个删除
    $(document).on("click", ".delete_btn", function () {
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).parents("tr").find("td:eq(1)").text();
        if (confirm("确认删除【" + empName + "】嘛？")) {
            $.ajax({
                url: "${APP_PATH}/emp/" + empId,
                type: "DELETE",
                success: function (result) {
                    //回到本页
                    to_page(current);
                }
            });
        }
    });

    function getEmp(id) {
        $.ajax({
            url: "${APP_PATH}/emp/" + id,
            type: "GET",
            success: function (result) {
                $("#empId_update_input").text(result.extend.employee.empId);
                $("#empName_update_input").text(result.extend.employee.empName);
                $("#email_update_input").val(result.extend.employee.email);
                $("#empUpdateModal input[name=gender]").val([result.extend.employee.gender]);
                $("#deptName_update_select").val([result.extend.employee.dId]);
            }
        });
    }

    //更新按钮
    $("#emp_update_btn").click(function () {
        //表单验证
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)) {
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
            return false;
        } else {
            show_validate_msg("#email_update_input", "success", "");
        }

        //发送ajax请求保存数据
        $.ajax({
            url: "${APP_PATH}/emp/" + $("#empId_update_input").text(),
            type: "PUT",
            data: $("#empUpdateModal form").serialize(),
            success: function (result) {
                //关闭页面
                $("#empUpdateModal").modal("hide");
                //重新回到当前页面
                to_page(current);
            }
        });
    });

    //全选/全不选按钮
    $("#chkAll").click(function () {
        //attr获取checked是undefined
        //原因是当时定义时并没有checked属性
        //原生的dom属性，使用 prop 属性，自定义的属性使用 attr
        //prop修改和读取dom原生属性的值
        $(".check_item").prop("checked", $(this).prop("checked"));
    });

    //check_item
    $(document).on('click', ".check_item", function () {
        //判断当前选中的元素
        if ($(".check_item:checked").length == $(".check_item").length) {
            $("#chkAll").prop("checked", true);
        } else {
            $("#chkAll").prop("checked", false);
        }
    });

    //点击全部删除，批量删除
    $("#emp_del_all_btn").click(function () {
        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"), function () {
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });

        if (del_idstr == ""){
            alert("请选择需要删除的记录！");
            return;
        }

        if (confirm("确认删除【" + empNames.substring(0,empNames.length - 1) + "】嘛？")){
            //发送ajax请求批量删除
            $.ajax({
                url:"${APP_PATH}/emp/" + del_idstr.substring(0,del_idstr.length - 1),
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    to_page(current);
                }
            });
        }
    });

</script>
</body>
</html>
