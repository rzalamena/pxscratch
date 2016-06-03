defmodule Pxscratch.PageView do
  use Pxscratch.Web, :view

  alias Pxscratch.Repo
  alias Pxscratch.Role
  alias Pxscratch.Setting

  def render_setting(f, type) do
    opts = [ onchange: "form = this; setTimeout(function(){form.submit()}, 500);" ]
    case type do
      "select:" <> what -> select(f, :ivalue, select_options(what), opts)
      "integer" -> number_input f, :ivalue, opts
      "boolean" -> checkbox2 f, :bvalue, opts
      "text" -> text_input f, :tvalue, opts
      _ -> "unknown type: '#{type}'"
    end
  end

  defp select_options(what) do
    case what do
      "role" ->
        Enum.map(Repo.all(Role), fn(x) ->
          {x.name, x.id}
        end)
      _ -> []
    end
  end
end
