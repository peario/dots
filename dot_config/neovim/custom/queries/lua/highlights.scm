;; extends

; for vim global module
((identifier) @namespace.builtin
              (#eq? @namespace.builtin "vim"))

; for local modules
((identifier) @variable.builtin
              (#eq? @variable.builtin "M"))

