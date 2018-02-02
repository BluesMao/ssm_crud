package com.sovell.crud.controller;

import com.sovell.crud.bean.Department;
import com.sovell.crud.bean.Msg;
import com.sovell.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门相关的请求
 */

@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    /**
     * 返回所有的部门信息
     */
    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){
        //查出所有部门信息
        List<Department> depts = departmentService.getDepts();
        return Msg.success().add("depts",depts);
    }
}
