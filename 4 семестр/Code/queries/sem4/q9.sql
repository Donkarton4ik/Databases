UPDATE passports

-- делаем подзапрос т.к. нужно изменить id, а дано только имя
SET condition_id = (
    SELECT exhibit_conditions_id 
    FROM exhibit_conditions 
    WHERE exhibit_conditions_name = 'Хорошее'
)

FROM employees, exhibit_conditions

WHERE passports.employee_id = employees.employee_id
  AND passports.condition_id = exhibit_conditions.exhibit_conditions_id
  
  AND employees.last_name = 'Алексеев'
  AND exhibit_conditions.exhibit_conditions_name = 'Критическое';