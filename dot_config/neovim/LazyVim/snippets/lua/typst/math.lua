local util = require("util.snippets")

return {
  s(
    { trig = "mk", name = "Math", dscr = "Inline math mode", wordTrig = true },
    fmta([[$<math>$<>]], {
      math = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      f(function(_, snip)
        local next = snip.env.TM_NEXT_CHAR or ""
        if not next:match("[,%.%?%-%s]") then
          return " "
        end
        return ""
      end, {}),
      -- i(2),
    }),
    {
      snippetType = "autosnippet",
      condition = util.typst_not_in_math,
    }
  ),
  s(
    { trig = "dm", name = "Math (display)", dscr = "Display math mode", wordTrig = true },
    fmta(
      [[
$
<math>
$
<>
  ]],
      {
        math = d(1, function(_, parent)
          local selected = parent.snippet.env.SELECT_RAW
          return sn(nil, { i(1, selected ~= "" and selected or "") })
        end, {}),
        i(0),
      }
    ),
    {
      snippetType = "autosnippet",
      condition = util.typst_in_math,
    }
  ),
  s(
    {
      trig = "//",
      name = "Fraction (manual)",
      dscr = "a / b",
      snippetType = "autosnippet",
    },
    fmta("<>/<>", {
      i(1),
      i(0),
    }),
    {
      condition = util.typst_in_math(),
    }
  ),
  s(
    { trig = "/", name = "Fraction (visual)", dscr = "$VISUAL / b" },
    fmta("(<>)/<>", {
      d(1, function(_, parent)
        local sel = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, sel ~= "" and sel or "") })
      end),
      i(0),
    }),
    {
      condition = util.typst_in_math(),
    }
  ),
  s(
    {
      trig = [[((\d+)|(\d*)([A-Za-z]+)((\^|_)(\(\d+\)|\d))*)/]],
      trigEngine = "ecma",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "fraction ()",
    },
    fmta([[(<>)/<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end, {}),
      i(0),
    }),
    {
      condition = util.typst_in_math(),
    }
  ),

  -- auto subscript
  s(
    {
      trig = [[([A-Za-z])(\d)]],
      trigEngine = "ecma",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "auto subscript",
    },
    fmta("<>_<>", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    {
      condition = util.typst_in_math(),
    }
  ),

  -- auto subscript with braces
  s(
    {
      trig = [[([A-Za-z])_(\d\d)]],
      trigEngine = "ecma",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "auto subscript2",
    },
    fmta("<>_(<>)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "**", name = "multiply", wordTrig = false, snippetType = "autosnippet" },
    t(" dot "),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "==", name = "equals", snippetType = "autosnippet" },
    fmta([[&= <> \<>]], { i(1), i(0) }),
    { condition = util.typst_in_math() }
  ),
  s({ trig = "!=", name = "not equals" }, t("eq.not "), { condition = util.typst_in_math() }),
  s(
    { trig = "+-", name = "plus-minus", wordTrig = false, snippetType = "autosnippet" },
    t("plus.minus "),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "-+", name = "minus-plus", wordTrig = false, snippetType = "autosnippet" },
    t("minus.plus "),
    { condition = util.typst_in_math() }
  ),

  s({ trig = "gt", name = "greater than", snippetType = "autosnippet" }, t("gt"), { condition = util.typst_in_math() }),
  s({ trig = "lt", name = "less than", snippetType = "autosnippet" }, t("lt"), { condition = util.typst_in_math() }),
  s(
    { trig = "gte", name = "greater than or equals", snippetType = "autosnippet" },
    t("gt.eq"),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "lte", name = "less than or equals", snippetType = "autosnippet" },
    t("lt.eq"),
    { condition = util.typst_in_math() }
  ),

  s({ trig = "abt", name = "approx", snippetType = "autosnippet" }, t("approx"), { condition = util.typst_in_math() }),
  s(
    { trig = "abte", name = "approx. equals", snippetType = "autosnippet" },
    t("approx.eq"),
    { condition = util.typst_in_math() }
  ),

  s(
    { trig = "=>", name = "implied" },
    t("arrow.r.double.long"),
    { snippetType = "autosnippet", condition = util.typst_in_math }
  ),
  s(
    { trig = "=<", name = "implied by" },
    t("arrow.l.double.long"),
    { snippetType = "autosnippet", condition = util.typst_in_math }
  ),
  s(
    -- TODO: find a better trigger than `cancel` to easier utilize this snippet.
    { trig = "cancel", name = "cancel n" },
    fmta([[cancel(<n>)<>]], {
      n = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),

  s(
    { trig = "sq", name = "square root", wordTrig = true, snippetType = "autosnippet" },
    fmta([[sqrt(<squared>)<>]], {
      squared = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "rt", name = "nth root", wordTrig = true, snippetType = "autosnippet" },
    fmta([[root(<>, <squared>)<>]], {
      i(1, "n"),
      squared = d(2, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),

  s(
    { trig = "sr", name = "^2", wordTrig = false, snippetType = "autosnippet" },
    t("^2"),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "cb", name = "^3", wordTrig = false, snippetType = "autosnippet" },
    t("^3"),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "td", name = "to the ... power", wordTrig = false, snippetType = "autosnippet" },
    fmta([[^<>]], {
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "rd", name = "to the ... power", wordTrig = false, snippetType = "autosnippet" },
    fmta([[^(<>)<>]], {
      i(1),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),

  s(
    { trig = "abs", name = "absolute value" },
    fmta([[abs(<n>)<>]], {
      n = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "floor", name = "floor expression" },
    fmta([[floor(<n>)<>]], {
      n = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "ceil", name = "ceil expression" },
    fmta([[ceil(<n>)<>]], {
      n = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),
  s(
    { trig = "round", name = "round expression" },
    fmta([[round(<n>)<>]], {
      n = d(1, function(_, parent)
        local selected = parent.snippet.env.SELECT_RAW
        return sn(nil, { i(1, selected ~= "" and selected or "") })
      end, {}),
      i(0),
    }),
    { condition = util.typst_in_math() }
  ),

  s(
    { trig = "cases", name = "cases", dscr = "suitable for graph systems" },
    fmta(
      [[
<> = cases(
  <> = <>
)]],
      {
        i(1),
        i(2, "x"),
        i(0, "2y - 8"),
      }
    ),
    { condition = util.typst_in_math() }
  ),

  s(
    {
      trig = "(sin|cos|ln|log|exp)$",
      regTrig = true,
      wordTrig = false,
      name = "Math Function",
      snippetType = "autosnippet",
    },
    fmta("<>(<>)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = util.typst_in_math() }
  ),
}
