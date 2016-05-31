defmodule Pxscratch.ViewHelper do
  use Phoenix.View, root: "web/templates"
  use Phoenix.HTML

  def checkbox2(form, field, opts \\ []) do
    content_tag(:label, [
      checkbox(form, field, opts),
      content_tag(:div, "", [class: "checkbox"]),
    ], [class: "label-switch"])
  end
end
