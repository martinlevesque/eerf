// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import "./path-data-polyfill"

import "./socket"

import "./minitpl"
import "./board"

import "./tools/pencil/pencil"
import "./tools/eraser/eraser"
import "./tools/hand/hand"
import "./tools/line/line"
import "./tools/rect/rect"
import "./tools/text/text"

//import Pencil from "./tools/pencil/pencil"

//Pencil(Tools)
