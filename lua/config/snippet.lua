return require("local.snippet")

-- NOTE: This is how `local.snippet` should look like
-- {
-- 	rust = {
-- 		macro_rules = {
-- 			prefix = "macro_rules",
-- 			body = { "macro_rules! ${1:name} {", "    (${2}) => (${3})", "}" },
-- 			description = "macro_rules! … { … }"
-- 		}
-- 	}
-- }
