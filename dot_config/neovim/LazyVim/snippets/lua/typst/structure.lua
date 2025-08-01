return {
  s(
    { trig = "latex", name = "LaTeX (setup)", dscr = "Starting point to get a LaTeX look in typst." },
    fmta(
      [[
#set page(margin: 1.75in)
#set par(leading: 0.55em, spacing: 0.55em, first-line-indent: 1.8em, justify: true)
#set text(font: "New Computer Modern")
#show raw: set text(font: "New Computer Modern Mono")
#show heading: set block(above: 1.4em, below: 1em)
<>]],
      {
        i(0),
      }
    )
  ),
}
