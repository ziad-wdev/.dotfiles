import style from "./src/style.scss"
import app from "ags/gtk4/app"
import Bar from "./src/widgets/Bar"

const applyStyle = () => {
  app.reset_css
  app.apply_css(style)
}

applyStyle()

app.start({
  css: style,
  main() {
    app.get_monitors().map(Bar)
  },
})
