WITH RECURSIVE
    employees_by_manager_ivan AS (SELECT e.employeeid, e.departmentid, e.name AS employeename, e.managerid, e.roleid
                                  FROM employees e
                                  WHERE e.employeeid = 1

                                  UNION ALL

                                  SELECT e.employeeid, e.departmentid, e.name, e.managerid, e.roleid
                                  FROM employees e
                                           JOIN employees_by_manager_ivan em ON em.employeeid = e.managerid),
    employees_count_manager_and_tasks AS (SELECT em.employeeid,
                                                 COUNT(DISTINCT e.employeeid) AS TotalSubordinates,
                                                 COUNT(DISTINCT t.taskid)     AS TotalTasks
                                          FROM employees_by_manager_ivan em
                                                   lEFT JOIN employees e ON e.managerid = em.employeeid
                                                   LEFT JOIN tasks t on em.employeeid = t.assignedto
                                          GROUP BY em.employeeid)

SELECT e.EmployeeID,
       e.employeename,
       e.managerid,
       d.departmentname,
       r.rolename,
       STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames,

       em.TotalTasks,
       em.TotalSubordinates
FROM employees_by_manager_ivan e
         JOIN employees_count_manager_and_tasks em ON em.employeeid = e.employeeid
         JOIN departments d ON e.departmentid = d.departmentid
         JOIN roles r ON r.roleid = e.roleid
         LEFT JOIN projects p ON p.departmentid = d.departmentid
         LEFT JOIN tasks t ON t.assignedto = e.employeeid
GROUP BY e.EmployeeID, e.managerid, d.departmentname, r.rolename, e.employeename, em.TotalTasks,
         em.TotalSubordinates
ORDER BY e.employeename;