package com.sovell.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sovell.crud.bean.Employee;
import com.sovell.crud.bean.Msg;
import com.sovell.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.filter.HttpPutFormContentFilter;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 删除方法 单个与批量二合一
     * 批量删除： 1-2-3
     * 单个删除： 1
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids") String ids){
        if (ids.contains("-")){
            String[] str_ids = ids.split("-");
            List<Integer> list = new ArrayList<Integer>();
            for (String id : str_ids){
                list.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(list);
        }else{
            employeeService.deleteEmp(Integer.parseInt(ids));
        }
        return Msg.success();
    }

    /**
     * 如果直接发送ajax请求=PUT形式的请求
     * Empoyee中数据封装不上 update tbl_emp where emp_id = 1014
     * 导致语法错误
     *
     * 原因：
     * Tomcat:
     *       1、将请求体中的数据，封装一个map
     *       2、request.getParameter("empName")就会从这个map中取值
     *       3、SpringMVC封装POJO对象的时候
     *              会把POJO中的每个属性的值，request.getParameter("email");
     *
     *  AJAX发送PUT请求引发的血案：
     *       PUT请求，请求体中的数据，request.getParameter("empName")拿不到
     *       Tomcat一看是PUT不会封装请求体中的数据为MAP，只有POST形式的请求才封装请求体为MAP
     *
     *       org.apache.catalina.connector.Request;
     *       定义了Request解析的方法 parseParameters()
     *
     *       if( !getConnector().isParseBodyMethod(getMethod()) ) {
     *       success = true;
     *       return;
     *       }
     *
     *       Connector类中解析方法默认值
     *       protected String parseBodyMethods = "POST"; //默认是POST
     *
     *
     *       去们要能支持直接发送PUT之类的请求还要封装请求体中的数据
     *       配置上HttpPutFormContentFilter;
     *       作用：将请求体中的数据解析包装成一个MAP  request被重新包装，request.getParameter()方法
     *       被重写了，就会从自己封装的MAP中取到数据
     *
     *
     * 员工更新
     * @param employee
     * @return
     */

    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println(request.getParameter("email"));
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 查询
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("employee",employee);
    }

    @RequestMapping("/checkuser")
    @ResponseBody
    public Msg checkuser(@RequestParam("empName") String empName){
        //优先判断用户名的合法性
        String regx = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg", "用户名必须是2-5位中文或者6-16位英文和数字组合");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b){
            return Msg.success();
        }
        else{
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /**
     * 员工保存
     * 1、支持JSR303校验
     * 2、导入Hibernate-Validator
     *
     * @return
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid  Employee employee, BindingResult result){

        if (result.hasErrors()) {
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String, Object> map = new HashMap<String,Object>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误字段" + fieldError.getField());
                System.out.println("错误信息" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else{
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 需要导入jackson 包
     * @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn){
        //引入PageHelper分页插件
        //在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn, 5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询结果，只需要将pageInfo交给页面即可
        //封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);
        return Msg.success().add("pageInfo",page);
    }

    /**
     * 查询员工数据（分页查询）
     *
     * @return
     */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {

        //引入PageHelper分页插件
        //在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn, 5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo包装查询结果，只需要将pageInfo交给页面即可
        //封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);
        model.addAttribute("pageInfo", page);

        return "list";
    }
}
