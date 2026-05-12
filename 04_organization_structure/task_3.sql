WITH RECURSIVE
    employees_manager AS (
    SELECT
           e.employeeid,
           e.name AS EmployeeName,
           e.managerid,
           e.departmentid,
           e.roleid,
           r.rolename,
           e.employeeid AS rootmanagerid
                          FROM employees e
                                   JOIN roles r ON r.roleid = e.roleid
                          WHERE r.rolename = 'Менеджер'
    UNION ALL

    SELECT
        e.employeeid,
        e.name AS EmployeeName,
        e.managerid,
        e.departmentid,
        e.roleid,
        em.rolename,
        em.rootmanagerid
    FROM employees e
    JOIN employees_manager em ON e.managerid = em.employeeid
),

    employees_count_manager AS (
                                SELECT em.rootmanagerid,
                                       COUNT(*) - 1 AS TotalSubordinates
                                FROM employees_manager em
                                GROUP BY em.rootmanagerid
                                HAVING COUNT(*) - 1 > 0
            )


SELECT e.employeeid,
       e.EmployeeName,
       e.managerid,
       d.departmentname,
       e.rolename,
       STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames,
       STRING_AGG(DISTINCT t.taskname, ', ' ORDER BY t.taskname)       AS TaskNames,
       em.TotalSubordinates
FROM employees_count_manager em
        JOIN employees_manager e ON em.rootmanagerid = e.employeeid AND e.employeeid = e.rootmanagerid
         JOIN departments d ON e.departmentid = d.departmentid
         LEFT JOIN projects p ON p.departmentid = d.departmentid
         LEFT JOIN tasks t ON t.assignedto = e.employeeid
GROUP BY e.employeeid, e.managerid, d.departmentname, e.rolename, e.EmployeeName, em.TotalSubordinates
ORDER BY e.EmployeeName;