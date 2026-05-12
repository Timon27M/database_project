WITH RECURSIVE employees_by_manager_ivan AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM employees e
    WHERE e.employeeid = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM employees e
    JOIN employees_by_manager_ivan em ON em.employeeid = e.managerid
)

SELECT e.employeeid AS EmployeeID, e.name AS EmployeeName, e.managerid AS ManagerID, d.departmentname AS DepartmentName, r.rolename AS RoleName, STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames, STRING_AGG(DISTINCT t.taskname, ', ' ORDER BY t.taskname) AS TaskNames
FROM employees_by_manager_ivan e
JOIN departments d ON d.departmentid = e.departmentid
JOIN roles r ON r.roleid = e.roleid
LEFT JOIN projects p ON p.departmentid = e.departmentid
LEFT JOIN tasks t ON t.assignedto = e.employeeid
GROUP BY e.employeeid, e.name, e.managerid, d.departmentname, r.rolename
ORDER BY e.name;
