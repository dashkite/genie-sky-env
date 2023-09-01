import * as cheerio from "cheerio"
import * as M from "@dashkite/masonry"

inject = ( env  ) ->
  ( context ) ->
    $ = cheerio.load context.input
    $ "head"
      .append """
        <script>
          window.process = { env: #{ JSON.stringify env } }
        </script>
      """
    $.html()

export default ( t ) ->

  if ( env = ( t.get "env" ))?

    t.define "sky:env", M.start [
      M.glob ( options.target ? options.targets ), "."
      M.read
      M.tr inject env
      M.write "."
    ]

    t.after "build", "env"
    
