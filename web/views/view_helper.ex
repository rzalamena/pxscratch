defmodule Pxscratch.ViewHelper do
  use Phoenix.View, root: "web/templates"
  use Phoenix.HTML

  def checkbox2(form, field, opts \\ []) do
    content_tag(:label, [
      checkbox(form, field, opts),
      content_tag(:div, "", [class: "checkbox"]),
    ], [class: "label-switch"])
  end

  def load_highlightjs do
    ~s"""
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.4.0/styles/default.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.4.0/highlight.min.js"></script>
    """
    |> raw
  end

  def load_simplemde do
    ~s"""
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/simplemde/1.11.2/simplemde.min.css">
    <script src="https://cdn.jsdelivr.net/simplemde/1.11.2/simplemde.min.js"></script>
    """
    |> raw
  end
end
