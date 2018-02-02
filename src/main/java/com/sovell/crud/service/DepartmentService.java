package com.sovell.crud.service;

import com.sovell.crud.bean.Department;
import com.sovell.crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    /**
     *
     * @return
     */
    public List<Department> getDepts(){
        List<Department> departments = departmentMapper.selectByExample(null);
        return departments;
    }
}
