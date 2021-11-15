require("git-worktree").setup({
    change_directory_command = 'cd', -- default: "cd",
    update_on_change = true, -- default: true,
    update_on_change_command = 'e .', -- default: "e .",
    clearjumps_on_change = true, -- default: true,
    autopush = false, -- default: false,
})

-- Can hook into events and follow up operations - e.g. switch to a branch after it is created
-- op = Operation.Switch, Operation.Create, Operation.Delete
-- -- metadata = table of useful values (structure dependent on op)
-- --      Switch
-- --          path = path you switched to
-- --          prev_path = previous worktree path
-- --      Create
-- --          path = path where worktree created
-- --          branch = branch name
-- --          upstream = upstream remote name
-- --      Delete
-- --          path = path where worktree deleted
--
-- Worktree.on_tree_update(function(op, metadata)
-- end)
