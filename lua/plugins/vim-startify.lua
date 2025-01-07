vim.g.startify_session_persistence = 1
vim.g.startify_lists = {
       { type = "sessions", header = {"   Sessions"}               },
       { type = "files",    header = {"   MRU"}                    },
       { type = "dir",      header = {"   MRU ".. vim.fn.getcwd()} },
}

return {
  "mhinz/vim-startify"
}
