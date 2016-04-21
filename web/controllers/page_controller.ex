defmodule Remarksync.PageController do
  use Remarksync.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
