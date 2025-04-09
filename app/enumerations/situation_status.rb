class TaskStatus < EnumerateIt::Base
    associate_values(
      to_do:        [0, 'to-do'],
      in_progress:  [1, 'in-progress'],
      testing:      [2, 'testing'],
      completed:    [3, 'completed']
    )
  
    sort_by :value
end