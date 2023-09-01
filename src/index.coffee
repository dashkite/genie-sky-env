import * as cheerio from "cheerio"
import * as M from "@dashkite/masonry"

inject = ( description  ) ->
  ( context ) ->
    # target build env:
    target  = context.build?.env ? {}
    description = { description..., target... }
    $ = cheerio.load context.input
    $ "head"
      .append """
        <script>
          window.process = { env: #{ JSON.stringify description } }
        </script>
      """
    $.html()

export default ( t ) ->

  if ( options = ( t.get "env" ))?

    t.define "env", M.start [
      M.glob ( options.target ? options.targets ), "."
      M.read
      M.tr inject options.description
      M.write "."
    ]

    t.after "build", "env"
    
