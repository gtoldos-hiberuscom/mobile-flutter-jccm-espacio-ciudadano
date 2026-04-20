# Default ticket transition policy

This file defines the default workflow used by the `ticket-transition` skill.

If the repository later adds a project-specific transition matrix, that project-specific policy takes precedence.

## Default statuses
- To Do
- In Progress
- QA Testing
- Blocked
- Done
- Reopened
- Cancelled

## Default allowed transitions
- To Do -> In Progress, Blocked, Cancelled
- In Progress -> QA Testing, Blocked, To Do
- QA Testing -> Done, In Progress, Blocked
- Blocked -> In Progress, Cancelled
- Done -> Reopened
- Reopened -> In Progress, Blocked
